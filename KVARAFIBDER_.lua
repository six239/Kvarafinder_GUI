
-- KVARAhub Finder PRO
-- Build 2: Finder Engine
-- Roblox Lua / LocalScript

local Finder = {}

Finder.Config = {
    Auto = false,
    MinimumFilter = false,
    MinimumIncome = 5000000000,
    MaximumResults = 5,
    RefreshInterval = 10
}

Finder.Sightings = {}

-- Verified game multipliers must be supplied here.
Finder.Mutations = {
    Normal = 1,
    Gold = 1,
    Diamond = 1,
    Rainbow = 1
}

function Finder.Calculate(pet)
    local base = tonumber(pet.BaseIncome) or 0
    local mutation = tonumber(pet.MutationMultiplier)
        or Finder.Mutations[pet.Mutation]
        or 1

    local weight = tonumber(pet.WeightMultiplier) or 1

    return base * mutation * weight
end

function Finder.AddSightings(data)
    if type(data) ~= "table" then
        return false
    end

    for _, pet in ipairs(data) do
        if type(pet) == "table"
            and type(pet.Name) == "string"
            and type(pet.ServerId) == "string" then

            pet.Income = Finder.Calculate(pet)
            table.insert(Finder.Sightings, pet)
        end
    end

    return true
end

function Finder.GetTopFive()
    local results = {}

    for _, pet in ipairs(Finder.Sightings) do
        if not Finder.Config.MinimumFilter
            or pet.Income >= Finder.Config.MinimumIncome then

            table.insert(results, pet)
        end
    end

    table.sort(results, function(a, b)
        return a.Income > b.Income
    end)

    local topFive = {}

    for i = 1, math.min(5, #results) do
        topFive[i] = results[i]
    end

    return topFive
end

function Finder.Clear()
    table.clear(Finder.Sightings)
end

function Finder.SetAuto(enabled)
    Finder.Config.Auto = enabled == true
end

function Finder.SetMinimumFilter(enabled)
    Finder.Config.MinimumFilter = enabled == true
end

return Finder
