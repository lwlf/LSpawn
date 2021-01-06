LSpawnItemsWindow = ISCollapsableWindow:derive("LSpawnItemsWindow")

function LSpawnItemsWindow:new(x, y, width, height)
    local o = {}

    o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.resizable = false
    o.spawnNumber = 1
    o.changed = true
    o.itemsList = LSpawnUtil:getItemsList()
    o.tabs = nil
    o:setTitle(LSpawnUtil:getMod():getName())

    return o
end

function LSpawnItemsWindow:initialise()
    ISCollapsableWindow.initialise(self)
end

function LSpawnItemsWindow:createChildren()
    ISCollapsableWindow.createChildren(self)

    self.tabs = ISTabPanel:new(0, self:titleBarHeight(), self.width, self.height - self:titleBarHeight() - 30 - (self.resizable and self:resizeWidgetHeight() or 0))

    self.footer = ISPanel:new(0, self:titleBarHeight() + self.tabs.height, self.width, 30)

    self.footer.searchBox = ISTextEntryBox:new("", 5, 5, 50, 20)
    self.footer.searchBox.onTextChange = self.onFilterChange
    self.footer.searchBox:initialise()
    self.footer.searchBox:instantiate()
    self.footer.searchBox:setClearButton(true)
    self.footer.searchBox:setTooltip(getText("IGUI_LSpawn_Tooltip_FilterName"))
    -- self.footer.searchBox:setTooltip("Filter by name: \nPlease input item's name")

    self.footer.spawnNumberBox = ISTextEntryBox:new("", self.footer.width - 55, 5, 50, 20)
    self.footer.spawnNumberBox.onTextChange = self.onSpawnNumberChange
    self.footer.spawnNumberBox:initialise()
    self.footer.spawnNumberBox:instantiate()
    self.footer.spawnNumberBox:setClearButton(true)
    self.footer.spawnNumberBox:setOnlyNumbers(true)
    self.footer.spawnNumberBox:setTooltip(getText("IGUI_LSpawn_Tooltip_SpawnNumber"))
    -- self.footer.spawnNumberBox:setTooltip("Spawn Number: \nPlease input spawn number")

    self:addChild(self.tabs)
    self:addChild(self.footer)
    self.footer:addChild(self.footer.searchBox)
    self.footer:addChild(self.footer.spawnNumberBox)
end

function LSpawnItemsWindow:addItems(category, items)
    self.itemsList[category] = self.itemsList[category] or {}
    table.insert(self.itemsList[category], items)
    self.changed = true
end

function LSpawnItemsWindow:setItemsList(itemsList)
    self.itemsList = itemsList or {}
    self.changed = true
end

function LSpawnItemsWindow:setSpawnNumber(spawnNumber)
    if type(spawnNumber) == "number" then
        self.spawnNumber = spawnNumber
    else
        self.spawnNumber = 1
    end
end

function LSpawnItemsWindow:prerender()
    ISCollapsableWindow.prerender(self)

    if self.changed then
        for category, items in pairs(self.itemsList) do
            local displayCategory = (string.upper(category) == "ALL") and getText("UI_All") or getText("IGUI_ItemCat_" .. category)
            local view = self.tabs:getView(displayCategory)
            if view then
                view:setItems(items)
            else
                local listPanel = LSpawnItemsListPanel:new(0, self.tabs.tabHeight, self.tabs.width, self.tabs.height - self.tabs.tabHeight)

                listPanel.onAddItem = self.onAddItem
                listPanel:setItems(items)
                self.tabs:addView(displayCategory, listPanel)
            end
        end

        self.changed = false
    end
end

function LSpawnItemsWindow:onResize()
    ISCollapsableWindow.onResize(self)

    self.tabs:setX(0)
    self.tabs:setY(self:titleBarHeight())
    self.tabs:setWidth(self.width)
    self.tabs:setHeight(self.height - self:titleBarHeight() - 30 - (self.resizable and self:resizeWidgetHeight() or 0))

    -- for _, view in pairs(self.tabs.viewList) do
        
    -- end

    self.footer:setX(0)
    self.footer:setY(self:titleBarHeight() + self.tabs.height)
    self.footer:setWidth(self.width)
    self.footer:setHeight(30)

    self.footer.spawnNumberBox:setX(self.footer.width - 55)
end

function LSpawnItemsWindow:onFilterChange()
    local text = self:getInternalText()
    if text == "" then
        self.parent.parent:setItemsList(LSpawnUtil:getItemsList())
    else
        self.parent.parent:setItemsList(LSpawnUtil:getItemsListByName(text))
    end
end

function LSpawnItemsWindow:onSpawnNumberChange()
    local text = self:getInternalText()
    if text == "" then
        self.parent.parent:setSpawnNumber(1)
    else
        self.parent.parent:setSpawnNumber(tonumber(text))
    end
end

function LSpawnItemsWindow:onAddItem(item)
    self.player:getInventory():AddItems(item:getFullName(), self.parent.parent.spawnNumber)
end