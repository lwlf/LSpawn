LSpawnItemsListPanel = ISPanel:derive("LSpawnItemsListPanel")

function LSpawnItemsListPanel:new(x, y, width, height)
    local o = {}

    o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.changed = false
    o.player = getPlayer()
    o.items = {}
    o.listBoxViews = {}

    return o
end

function LSpawnItemsListPanel:initialise()
    ISPanel.initialise(self)
end

function LSpawnItemsListPanel:createChildren()
    ISPanel.createChildren(self)

    for i = 1, 3 do
        local listBox = ISScrollingListBox:new((self.width / 3) * (i - 1), 0, self.width / 3, self.height)

        listBox:setOnMouseDownFunction(self, self.onAddItem)
        listBox:setOnMouseDoubleClick(self, self.onAddItem)
        listBox.doDrawItem = self.drawDatas
        table.insert(self.listBoxViews, listBox)
        self:addChild(listBox)
    end
end

function LSpawnItemsListPanel:onResize()
    ISPanel.onResize(self)

    for i, listBox in pairs(self.listBoxViews) do
        listBox:setX((self.width / 3) * (i - 1))
        listBox:setY(0)
        listBox:setWidth(self.width / 3)
        listBox:setHeight(self.height)
    end
end

function LSpawnItemsListPanel:prerender()
    ISPanel.prerender(self)

    if self.changed then
        local itemsParts = table.split(self.items, 3)

        for i, items in pairs(itemsParts) do
            local listBox = self.listBoxViews[i]

            listBox:clear()
            for _, item in pairs(items) do
                listBox:addItem(item:getDisplayName(), item)
            end
        end

        self.changed = false
    end
end

function LSpawnItemsListPanel:setItems(items)
    self.items = items or {}
    self.changed = true
end

function LSpawnItemsListPanel:onAddItem(item)
    self.player:getInventory():AddItem(item:getFullName())
end

function LSpawnItemsListPanel:drawDatas(y, item, alt)
    local fontHeight = getTextManager():getFontHeight(self.font)
    local instanceGoods = instanceItem(item.item)
    local space = 5

    self.itemheight = fontHeight + space
    item.height = item.height or self.itemheight

    -- if self.selected == item.index then
    --     self:drawRect(0, y, self:getWidth(), item.height - 1, 0.3, 0.7, 0.35, 0.15)
    -- end
    -- self:drawRectBorder(0, y, self:getWidth(), item.height, 0.5, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    -- self:drawRect(0, y, self:getWidth(), item.height - 1, 0.3, 0.7, 0.35, 0.15)
    self:drawTextureScaled(instanceGoods:getTexture(), space * 2, y + space * 2, fontHeight - space, fontHeight - space, 1, 1, 1, 1)
    self:drawText(item.text, space * 2 + fontHeight, y + space * 2, 0.9, 0.9, 0.9, 0.9, self.font)
    y = y + item.height

	return y;
end