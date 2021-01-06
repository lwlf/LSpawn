LSpawnMain = LSpawnMain or {}

function LSpawnMain:init()
    LSpawn = LSpawnItemsWindow:new(100, 100, 680, 400)
    LSpawn:addToUIManager()
    -- LSpawn:setVisible(false)
end

function LSpawnMain.listener(key)
    print(key)
    if key == 41 then
        LSpawn:setVisible(not LSpawn:getIsVisible())
    end
end

Events.OnGameStart.Add(LSpawnMain.init)
Events.OnKeyStartPressed.Add(LSpawnMain.listener)