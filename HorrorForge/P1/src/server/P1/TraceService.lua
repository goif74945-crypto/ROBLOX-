local TraceService = {}

local tracesByPlayer = {}

local function now()
    return workspace:GetServerTimeNow()
end

local function prune(list, lifetime)
    local t = now()
    local write = 1
    for i = 1, #list do
        local trace = list[i]
        if t - trace.Timestamp <= lifetime then
            list[write] = trace
            write += 1
        end
    end
    for i = write, #list do
        list[i] = nil
    end
end

function TraceService.Record(player, traceType, position, intensity, lifetime, maxPerPlayer, metadata)
    if not player or not position then
        return nil
    end

    local list = tracesByPlayer[player]
    if not list then
        list = {}
        tracesByPlayer[player] = list
    end

    prune(list, lifetime)

    local trace = {
        Type = traceType,
        Location = position,
        Timestamp = now(),
        Intensity = intensity,
        SourcePlayer = player,
        Confidence = 1,
        DecayTime = lifetime,
        Metadata = metadata,
    }

    list[#list + 1] = trace
    while #list > maxPerPlayer do
        table.remove(list, 1)
    end

    return trace
end

function TraceService.GetRecent(rangeOrigin, range, lifetime)
    local result = {}
    local t = now()

    for _, list in pairs(tracesByPlayer) do
        prune(list, lifetime)
        for _, trace in ipairs(list) do
            if (trace.Location - rangeOrigin).Magnitude <= range and (t - trace.Timestamp) <= lifetime then
                result[#result + 1] = trace
            end
        end
    end

    table.sort(result, function(a, b)
        return a.Timestamp > b.Timestamp
    end)

    return result
end

function TraceService.ForgetPlayer(player)
    tracesByPlayer[player] = nil
end

return TraceService
