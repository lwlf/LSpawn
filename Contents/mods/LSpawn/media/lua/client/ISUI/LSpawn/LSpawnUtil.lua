LSpawnUtil = LSpawnUtil or {}

function LSpawnUtil:getCategories()
    local items = getAllItems()
    local dict = {}
    local categories = {}

    for i = 1, items:size() do
        local category = instanceItem(items:get(i - 1)):getCategory()
        dict[category] = true
    end

    for category, _ in pairs(dict) do
        table.insert(categories, category)
    end

    return categories
end

function LSpawnUtil:getItemsByCategory(category, ignoreHidden, ignoreObsolete)
    category = category or "All"
    ignoreHidden = ignoreHidden or true
    ignoreObsolete = ignoreObsolete or true

    local items = getAllItems()
    local list = {}

    for i = 1, items:size() do
        local item = items:get(i - 1)

        while true do
            if self:getGameVersion() >= 41 then
                if ignoreHidden and item:isHidden() then
                    break
                end
            end

            if ignoreObsolete and item:getObsolete() then
                break
            end

            if string.upper(category) == "ALL" then
                table.insert(list, item)
            elseif string.upper(category) == string.upper(instanceItem(item):getCategory()) then
                table.insert(list, item)
            end

            break
        end
    end

    table.sort(list, function (a, b)
        return not string.sort(a:getDisplayName(), b:getDisplayName())
    end)

    return list
end

function LSpawnUtil:getItemsByName(name, category, ignoreHidden, ignoreObsolete)
    name = name or ""

    local items = self:getItemsByCategory(category, ignoreHidden, ignoreObsolete)
    local list = {}

    for _, item in pairs(items) do
        if string.match(item:getName(), name) or string.match(item:getDisplayName(), name) then
            table.insert(list, item)
        end
    end

    return list
end

function LSpawnUtil:getItemsList(inclueAll, ignoreHidden, ignoreObsolete)
    inclueAll = inclueAll or false
    ignoreHidden = ignoreHidden or true
    ignoreObsolete = ignoreObsolete or true

    local items = getAllItems()
    local list = {}

    if inclueAll then
        list["All"] = {}
        table.insert(list["All"], self:getItemsByCategory("All", ignoreHidden, ignoreObsolete))
    end

    for i = 1, items:size() do
        local item = items:get(i - 1)
        local category = instanceItem(item):getCategory()

        while true do
            list[category] = list[category] or {}

            if self:getGameVersion() >= 41 then
                if ignoreHidden and item:isHidden() then
                    break
                end
            end

            if ignoreObsolete and item:getObsolete() then
                break
            end

            table.insert(list[category], item)

            break
        end
    end

    for _, itemsList in pairs(list) do
        table.sort(itemsList, function (a, b)
            return not string.sort(a:getDisplayName(), b:getDisplayName())
        end)
    end

    return list
end

function LSpawnUtil:getItemsListByName(name, inclueAll, ignoreHidden, ignoreObsolete)
    name = name or ""

    local itemsList = self:getItemsList(inclueAll, ignoreHidden, ignoreObsolete)

    for category, items in pairs(itemsList) do
        local index = 1
        while true do
            if index > #items then break end

            local item = items[index]

            if not string.match(string.upper(item:getName()), string.upper(name)) and not string.match(string.upper(item:getDisplayName()), string.upper(name)) then
                table.remove(itemsList[category], index)
                index = index - 1
            end

            index = index + 1
        end
    end

    return itemsList
end

function LSpawnUtil:getAllItems(ignoreHidden, ignoreObsolete)
    return self:getItemsByCategory("All", ignoreHidden, ignoreObsolete)
end

function LSpawnUtil:getMod()
    return getModInfoByID("LSpawn")
end

function LSpawnUtil:getGameVersion()
    local gameVersion = getCore():getVersionNumber()
    local numStr = string.match(gameVersion, "[0-9]+%.[0-9]+")
    return tonumber(numStr)
end