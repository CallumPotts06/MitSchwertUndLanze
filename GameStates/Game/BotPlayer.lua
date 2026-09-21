
BotPlayer = {}

BotPlayer.Team = ""
BotPlayer.Stratergy = ""
BotPlayer.Army = {}
BotPlayer.EnemyArmy = {}
BotPlayer.GenericEnemyDirection = "Right"
BotPlayer.Difficulty = ""

BotPlayer.Active = false

function BotPlayer.Init(team, difficulty, strat, army, enemy, generalTarget)
    if difficulty == "Easy" then difficulty = 3
    elseif difficulty == "Medium" then difficulty = 2
    else difficulty = 1 end

    BotPlayer.Team = team
    BotPlayer.Difficulty = difficulty
    BotPlayer.Stratergy = strat
    BotPlayer.Army = army
    BotPlayer.EnemyArmy = enemy
    BotPlayer.GenericEnemyDirection = generalTarget
    BotPlayer.Active = true
end

----//// BRIGADE THOUGHT PROCESS ////----
--[[ 

    INFANTRY

    DISTANCE TO ENEMY > 4250 * 4
        march towards generic position in marching column

    DISTANCE TO ENEMY > 4250 * 1.5
        deploy into battle line with a regiment in reserve

    ENEMY VISIBLE
        turn and face enemy to fight

    IF THERE ARE MORE THAN ENEMY UNITS VISIBLE THAN FREINDLY
        deploy all regiments

    IF BRIGADE IS BEING FLANKED
        deploy reserve to cover flank




]]--

function BotPlayer.ArmyLevelControl()
    for i=1,#BotPlayer.Army,1 do
        BotPlayer.BrigadeLevelControl( BotPlayer.Army[i] )
    end
end


function BotPlayer.BrigadeLevelControl(brigade)

    --get self position--
    local meanPosition = brigade.Regiments[1].Position
    for i=2,#brigade.Regiments,1 do
        meanPosition = Mathematics.VectorFromAddition(meanPosition, brigade.Regiments[i].Position)
        meanPosition = Mathematics.VectorFromDivision(meanPosition, 2)

        if brigade.BranchOfService == "Artillery" then
            brigade.Regiments[i].MarchSpeed = brigade.Regiments[i].MarchSpeed / 3
        end
    end



    --get nearest enemy position--
    local distance = 9999999999
    local nearestEnemy = nil
    for i=1,#BotPlayer.EnemyArmy,1 do
        for i2=1,#BotPlayer.EnemyArmy[i].Regiments,1 do
            local enemyPos = BotPlayer.EnemyArmy[i].Regiments[i2].Position
            local mag = Mathematics.VectorMagnitude(meanPosition,enemyPos)
            if mag < distance then
                nearestEnemy = BotPlayer.EnemyArmy[i].Regiments[i2]
                distance = mag
            end
        end
    end

    --adds a bit of randomness and guesswork - based on difficulty--
    distance = distance + math.random(  (-550*BotPlayer.Difficulty)  ,(550*BotPlayer.Difficulty)  )

    brigade.TargetBrigade = nearestEnemy.Brigade




    ----//// ########################## ////----
    ----//// STRATERGY MODE - ATTACKING ////----
    ----//// ########################## ////----

    if BotPlayer.Stratergy == "Attacking" then

        --if the brigade is not currently changing formation, move the brigade where appropriate--
        if brigade.ChangingFormation == 0 then

            local brigadeHidden = true

            for i = 1,#brigade.Regiments,1 do
                if not brigade.Regiments[i].IsHidden then
                    brigadeHidden = false
                    local correctingFormation = false

                    if brigade.BranchOfService == "Infantry" then
                        if brigade.Formation ~= "FullBattleLine" then correctingFormation = true brigade:ChangeFormation( "FullBattleLine" ) end
                    elseif brigade.BranchOfService == "Cavalry" then
                        if brigade.Formation ~= "FullBattleLine" then correctingFormation = true brigade:ChangeFormation( "FullBattleLine" ) end
                    elseif brigade.BranchOfService == "Artillery" then
                        if brigade.Formation ~= "Deployed" then correctingFormation = true brigade:ChangeFormation( "Deployed" ) end
                    end
                    
                    if not correctingFormation then
                        brigade:MoveBrigade( nearestEnemy.Brigade.Regiments[1].Position )
                    end
                    break
                end
            end

            if brigadeHidden then
                --if the enemy are really far away, march to them in column--
                if distance > 4250 * 4.5 then
                    local correctingFormation = false

                    if brigade.Formation ~= "MarchingColumn" then brigade:ChangeFormation( "MarchingColumn" ) correctingFormation = true

                    else
                        if BotPlayer.GenericEnemyDirection == "Right" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(1500,math.random(-300,300))) )
                        elseif BotPlayer.GenericEnemyDirection == "Left" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(-1500,math.random(-300,300))) )
                        elseif BotPlayer.GenericEnemyDirection == "Up" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(math.random(-300,300), -1500)) )
                        elseif BotPlayer.GenericEnemyDirection == "Down" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(math.random(-300,300), 1500)) )
                        end
                    end



                --if the enemy are a bit closer, march to them in battle line--
                elseif distance > 4250 * 0.8 then
                    local correctingFormation = false

                    if brigade.BranchOfService == "Infantry" then
                        if brigade.Formation ~= "FullBattleLine" then correctingFormation = true brigade:ChangeFormation( "FullBattleLine" ) end
                    end
                    if brigade.BranchOfService == "Cavalry" then
                        if brigade.Formation ~= "FullBattleLine" then correctingFormation = true brigade:ChangeFormation( "FullBattleLine" ) end
                    end
                    if brigade.BranchOfService == "Artillery" then
                        
                        if brigade.Formation ~= "Deployed" then correctingFormation = true brigade:ChangeFormation( "Deployed" ) end
                    end
                    
                    if not correctingFormation then
                        if BotPlayer.GenericEnemyDirection == "Right" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(1500,math.random(-300,300))) )
                        elseif BotPlayer.GenericEnemyDirection == "Left" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(-1500,math.random(-300,300))) )
                        elseif BotPlayer.GenericEnemyDirection == "Up" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(math.random(-300,300), -1500)) )
                        elseif BotPlayer.GenericEnemyDirection == "Down" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(math.random(-300,300), 1500)) )
                        end
                    end
                end
            end
        end

        
    end







    ----//// ########################## ////----
    ----//// STRATERGY MODE - DEFENSIVE ////----
    ----//// ########################## ////----

    if BotPlayer.Stratergy == "Defensive" then

        --if the brigade is not currently changing formation, move the brigade where appropriate--
        if brigade.ChangingFormation == 0 then

            local brigadeHidden = true

            for i = 1,#brigade.Regiments,1 do
                if not brigade.Regiments[i].IsHidden then
                    brigadeHidden = false
                    local correctingFormation = false

                    if brigade.BranchOfService == "Infantry" then
                        if brigade.Formation == "MarchingColumn" then correctingFormation = true brigade:ChangeFormation( "FullBattleLine" ) end
                    elseif brigade.BranchOfService == "Cavalry" then
                        if brigade.Formation ~= "FullBattleLine" then correctingFormation = true brigade:ChangeFormation( "FullBattleLine" ) end
                    elseif brigade.BranchOfService == "Artillery" then
                        if brigade.Formation ~= "Deployed" then correctingFormation = true brigade:ChangeFormation( "Deployed" ) end
                    end
                    
                    if not correctingFormation then
                        brigade:MoveBrigade( nearestEnemy.Brigade.Regiments[1].Position )
                    end
                    break
                end
            end

            if brigadeHidden then
                --if the enemy are really far away, march to them in column a little bit--
                if distance > 4250 * 6 then
                    local correctingFormation = false

                    if brigade.Formation ~= "MarchingColumn" then brigade:ChangeFormation( "MarchingColumn" ) correctingFormation = true

                    else
                        if BotPlayer.GenericEnemyDirection == "Right" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(500,math.random(-200,200))) )
                        elseif BotPlayer.GenericEnemyDirection == "Left" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(-500,math.random(-200,200))) )
                        elseif BotPlayer.GenericEnemyDirection == "Up" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(math.random(-200,200), -500)) )
                        elseif BotPlayer.GenericEnemyDirection == "Down" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(math.random(-200,200), 500)) )
                        end
                    end



                --if the enemy are a bit closer, form up in a defensive formation and hold tight--
                else
                    local correctingFormation = false

                    if brigade.BranchOfService == "Infantry" then
                        if brigade.Formation ~= "FullBattleLine" then correctingFormation = true brigade:ChangeFormation( "FullBattleLine" ) end
                    end
                    if brigade.BranchOfService == "Cavalry" then
                        if brigade.Formation ~= "FullBattleLine" then correctingFormation = true brigade:ChangeFormation( "FullBattleLine" ) end
                    end
                    if brigade.BranchOfService == "Artillery" then
                        if brigade.Formation ~= "Deployed" then correctingFormation = true brigade:ChangeFormation( "Deployed" ) end
                    end

                    if not correctingFormation then
                        if BotPlayer.GenericEnemyDirection == "Right" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(500,math.random(-200,200))) )
                        elseif BotPlayer.GenericEnemyDirection == "Left" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(-500,math.random(-200,200))) )
                        elseif BotPlayer.GenericEnemyDirection == "Up" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(math.random(-200,200), -500)) )
                        elseif BotPlayer.GenericEnemyDirection == "Down" then
                            brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition, Vector.New(math.random(-200,200), 500)) )
                        end
                    end

                end
            end
        end


    end


end

return BotPlayer