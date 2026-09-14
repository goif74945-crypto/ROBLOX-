local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")

local E01Listener = {}

local STATES = {
    PATROL = "PATROL",
    INVESTIGATE = "INVESTIGATE",
    SEARCH = "SEARCH",
    HUNT = "HUNT",
    CHASE = "CHASE",
    ATTACK = "ATTACK",
    RETREAT = "RETREAT",
    AMBUSH = "AMBUSH",
    LOSE_TARGET = "LOSE_TARGET",
    RECOVER = "RECOVER",
}

local function findRoot(player)
    local character = player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function hasLineOfSight(fromPosition, toCharacter, model)
    local root = toCharacter and toCharacter:FindFirstChild("HumanoidRootPart")
    if not root then
        return false
    end

    local direction = root.Position - fromPosition
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {model, toCharacter}

    local hit = workspace:Raycast(fromPosition, direction, params)
    return hit == nil
end

local function makeEntity(spawnPosition)
    local model = Instance.new("Model")
    model.Name = "E01_LISTENER"

    local root = Instance.new("Part")
    root.Name = "HumanoidRootPart"
    root.Size = Vector3.new(2, 2, 1)
    root.Anchored = false
    root.CanCollide = true
    root.Position = spawnPosition + Vector3.new(0, 3, 0)
    root.Parent = model

    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(3, 5, 2)
    body.Anchored = false
    body.CanCollide = true
    body.Position = spawnPosition + Vector3.new(0, 6, 0)
    body.Parent = model

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = root
    weld.Part1 = body
    weld.Parent = root

    local humanoid = Instance.new("Humanoid")
    humanoid.WalkSpeed = 8
    humanoid.AutoRotate = true
    humanoid.Parent = model

    model.PrimaryPart = root
    model.Parent = workspace
    return model, humanoid, root
end

local function pathTo(humanoid, root, destination)
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = false,
    })

    local ok = pcall(function()
        path:ComputeAsync(root.Position, destination)
    end)

    if not ok or path.Status ~= Enum.PathStatus.Success then
        humanoid:MoveTo(destination)
        return
    end

    local waypoints = path:GetWaypoints()
    if #waypoints >= 2 then
        humanoid:MoveTo(waypoints[2].Position)
    else
        humanoid:MoveTo(destination)
    end
end

function E01Listener.Start(config, traceService)
    local spawnPosition = Vector3.new(0, 0, 14)
    local model, humanoid, root = makeEntity(spawnPosition)
    model:SetAttribute("EntityId", config.EntityId)
    model:SetAttribute("State", STATES.PATROL)
    model:SetAttribute("TargetPlayer", "")

    local state = STATES.PATROL
    local targetPlayer = nil
    local lastStateChange = workspace:GetServerTimeNow()
    local lastThink = 0
    local lastTargetSeen = 0
    local lastInvestigate = 0

    local function setState(nextState)
        if state == nextState then
            return false
        end
        state = nextState
        model:SetAttribute("State", nextState)
        lastStateChange = workspace:GetServerTimeNow()
        return true
    end

    local function chooseTrace()
        local traces = traceService.GetRecent(root.Position, config.Listener.TraceRange, config.Listener.MemorySeconds)
        for _, trace in ipairs(traces) do
            if trace.Type == "DOOR" or trace.Type == "NOISE" or trace.Type == "MOVEMENT" or trace.Type == "INTERACTION" then
                return trace
            end
        end
        return nil
    end

    local function nearestVisiblePlayer()
        local bestPlayer = nil
        local bestDistance = config.Listener.VisionRange
        for _, player in ipairs(Players:GetPlayers()) do
            local playerRoot = findRoot(player)
            if playerRoot then
                local distance = (playerRoot.Position - root.Position).Magnitude
                if distance <= bestDistance and hasLineOfSight(root.Position, player.Character, model) then
                    bestDistance = distance
                    bestPlayer = player
                end
            end
        end
        return bestPlayer
    end

    task.spawn(function()
        while model.Parent do
            local t = workspace:GetServerTimeNow()
            if t - lastThink >= 0.1 then
                lastThink = t

                local visible = nearestVisiblePlayer()
                if visible then
                    targetPlayer = visible
                    model:SetAttribute("TargetPlayer", visible.UserId)
                    lastTargetSeen = t
                    setState(STATES.CHASE)
                elseif state == STATES.CHASE and t - lastTargetSeen > config.Listener.MaxChaseSeconds then
                    targetPlayer = nil
                    model:SetAttribute("TargetPlayer", "")
                    setState(STATES.LOSE_TARGET)
                end

                if not targetPlayer then
                    local trace = chooseTrace()
                    if trace and t - lastInvestigate >= config.Listener.ThinkInvestigate then
                        lastInvestigate = t
                        setState(STATES.INVESTIGATE)
                        pathTo(humanoid, root, trace.Location)
                    elseif state == STATES.INVESTIGATE and t - lastStateChange >= config.Listener.SearchSeconds then
                        setState(STATES.SEARCH)
                    elseif state == STATES.SEARCH and t - lastStateChange >= config.Listener.SearchSeconds then
                        setState(STATES.RECOVER)
                    elseif state == STATES.LOSE_TARGET then
                        setState(STATES.RECOVER)
                    elseif state == STATES.RECOVER and t - lastStateChange >= config.Listener.ThinkPatrol then
                        setState(STATES.PATROL)
                    end
                else
                    local targetRoot = findRoot(targetPlayer)
                    if targetRoot then
                        local distance = (targetRoot.Position - root.Position).Magnitude
                        if distance <= config.Listener.AttackRange then
                            setState(STATES.ATTACK)
                            local targetHumanoid = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                            if targetHumanoid and t - lastStateChange >= config.Listener.AttackCooldown then
                                targetHumanoid:TakeDamage(config.Listener.MaxHealthDamage)
                                lastStateChange = t
                            end
                        elseif distance <= config.Listener.HearingRange then
                            humanoid.WalkSpeed = config.Listener.ChaseSpeed
                            pathTo(humanoid, root, targetRoot.Position)
                            setState(STATES.CHASE)
                        else
                            targetPlayer = nil
                            model:SetAttribute("TargetPlayer", "")
                            setState(STATES.LOSE_TARGET)
                        end
                    else
                        targetPlayer = nil
                        model:SetAttribute("TargetPlayer", "")
                        setState(STATES.LOSE_TARGET)
                    end
                end

                if state == STATES.PATROL then
                    humanoid.WalkSpeed = config.Listener.PatrolSpeed
                elseif state == STATES.INVESTIGATE or state == STATES.SEARCH then
                    humanoid.WalkSpeed = config.Listener.InvestigateSpeed
                elseif state == STATES.CHASE then
                    humanoid.WalkSpeed = config.Listener.ChaseSpeed
                end
            end
            task.wait(0.05)
        end
    end)

    return model
end

return E01Listener
