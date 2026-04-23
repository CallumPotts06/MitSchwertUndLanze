
Queue = {}
Queue.__index =  Queue

--// CONSTRUCTOR //--
function Queue.New(initList)
    local newQueue = {} --create a new table--

    newQueue.Data = {} --setup data--

    setmetatable(newQueue,{__index=Queue})
    return newQueue
end

function Queue:EnQ( data )
    table.insert( self.Data, data )
end

function Queue:DeQ( )
    local value = table.remove( self.Data, 1 )
    return value
end

return Queue