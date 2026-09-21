
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


    --if the enemy are really far away, march to them in column--
    if distance > 4250 * 4 then
        if brigade.Formation ~= "MarchingColumn" then brigade:ChangeFormation( "MarchingColumn" )
        else
            if BotPlayer.GenericEnemyDirection == "Right" then
                brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition + Vector.New(1500,math.random(-200,200))) )
            elseif BotPlayer.GenericEnemyDirection == "Left" then
                brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition + Vector.New(-1500,math.random(-200,200))) )
            elseif BotPlayer.GenericEnemyDirection == "Up" then
                brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition + Vector.New(math.random(-200,200), -1500)) )
            elseif BotPlayer.GenericEnemyDirection == "Down" then
                brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition + Vector.New(math.random(-200,200), 1500)) )
            end
        end

    elseif distance > 4250 * 1.5 then
        if brigade.Formation ~= "BattleLine" then brigade:ChangeFormation( "BattleLine" )
        else
            if BotPlayer.GenericEnemyDirection == "Right" then
                brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition + Vector.New(1500,math.random(-200,200))) )
            elseif BotPlayer.GenericEnemyDirection == "Left" then
                brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition + Vector.New(-1500,math.random(-200,200))) )
            elseif BotPlayer.GenericEnemyDirection == "Up" then
                brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition + Vector.New(math.random(-200,200), -1500)) )
            elseif BotPlayer.GenericEnemyDirection == "Down" then
                brigade:MoveBrigade( Mathematics.VectorFromAddition(meanPosition + Vector.New(math.random(-200,200), 1500)) )
            end
        end
    end

    --[[for i = 1,#brigade.Regiments,1 do
        if not brigade.Regiments[i].IsHidden then
            if brigade.Formation ~= "BattleLine" then brigade:ChangeFormation( "BattleLine" ) end
            brigade:MoveBrigade( nearestEnemy.Brigade.Regiments[1] )
            break
        end
    end]]


end

return BotPlayer