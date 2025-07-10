local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Pretty print JSON formatter
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

-- Main export function
local function exportSectorData()
    local sectorFolder = ReplicatedStorage:FindFirstChild("Galaxy") and ReplicatedStorage.Galaxy:FindFirstChild("Sectors")
    if not sectorFolder then
        warn("Sectors folder not found.")
        return
    end

    local result = {}

    for _, sector in ipairs(sectorFolder:GetChildren()) do
        if sector:IsA("Vector3Value") then
            for _, system in ipairs(sector:GetChildren()) do
                if system:IsA("Vector3Value") then
                    local entry = {}

                    for _, child in ipairs(system:GetChildren()) do
                        if child:IsA("IntValue") and child.Name == "Colonization" then
                            entry["Colonization"] = tostring(child.Value)
                        elseif child:IsA("StringValue") then
                            entry[child.Name] = child.Value
                        end
                    end

                    result[system.Name] = entry
                end
            end
        end
    end

    local jsonOutput = formatJSON(result, 0)

    if isfile("system_data.json") then
        warn("Overwriting existing system_data.json")
    end

    writefile("system_data.json", jsonOutput)
    print("System data saved to system_data.json")
end

-- Run it
exportSectorData()
