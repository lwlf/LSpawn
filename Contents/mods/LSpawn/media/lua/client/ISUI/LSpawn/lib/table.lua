function table.dedup(t)
    local dict = {}
    local index = 1

    while true do
        if index > #t then
            break
        end

        local value = t[index]
        if dict[value] then
            table.remove(t, index)
            index = index - 1
        else
            dict[value] = true
        end

        index = index + 1
    end

    return t
end

function table.sub(t, i, j)
    local list = {}

    for index = i, j do
        table.insert(list, t[index])
    end

    return list
end

function table.split(t, n)
    local list = {}
    local size = #t
    local lastIndex = 0

    for i = 1, n do
        local startIndex = lastIndex + 1
        local endIndex = lastIndex + (i <= math.fmod(size, n) and math.ceil(size / n) or math.floor(size / n))

        if endIndex > size then
            endIndex = size
        end
        lastIndex = endIndex
        table.insert(list, table.sub(t, startIndex, endIndex))
    end

    return list
end