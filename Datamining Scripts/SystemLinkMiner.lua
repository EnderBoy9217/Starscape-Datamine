local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Pretty-printing helper
local function formatJSON(data, indentLevel)
    indentLevel = indentLevel or 0
    local indent = string.rep("    ", indentLevel)
    local nextIndent = string.rep("    ", indentLevel + 1)

    if type(data) == "table" then
        local isArray = #data > 0
        local result = {}

        if isArray then
            table.insert(result, "[")
            for i, v in ipairs(data) do
                table.insert(result, nextIndent .. formatJSON(v, indentLevel + 1) .. (i < #data and "," or ""))
            end
            table.insert(result, indent .. "]")
        else
            table.insert(result, "{")
            local keys = {}
            for k in pairs(data) do table.insert(keys, k) end
            table.sort(keys)

            for i, k in ipairs(keys) do
                local value = formatJSON(data[k], indentLevel + 1)
                table.insert(result, nextIndent .. string.format("%q: %s", k, value) .. (i < #keys and "," or ""))
            end
            table.insert(result, indent .. "}")
        end

        return table.concat(result, "\n")
    elseif type(data) == "string" then
        return string.format("%q", data)
    else
        return tostring(data)
    end
end

-- Function to process links and create JSON structure
local function processLinks()
    local linkData = {}

    local linksFolder = ReplicatedStorage:FindFirstChild("Galaxy") and ReplicatedStorage.Galaxy:FindFirstChild("Links")
    if not linksFolder then
        warn("Links folder not found in ReplicatedStorage.Galaxy")
        return
    end

    for _, config in pairs(linksFolder:GetChildren()) do
        if config:IsA("Configuration") then
            local start = config:GetAttribute("Start")
            local endPoint = config:GetAttribute("End")

            if start and endPoint then
                if not linkData[start] then
                    linkData[start] = {
                        connections = {}
                    }
                end

                if not table.find(linkData[start].connections, endPoint) then
                    table.insert(linkData[start].connections, endPoint)
                end
            end
        end
    end

    -- Convert to pretty-printed JSON
    local jsonString = formatJSON(linkData, 0)

    if isfile("system_links.json") then
        warn("Overwriting existing links.json")
    end

    writefile("system_links.json", jsonString)
    print("Link data saved to links.json")
end

processLinks()