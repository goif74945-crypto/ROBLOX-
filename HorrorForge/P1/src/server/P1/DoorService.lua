local DoorService = {}

local function getOrCreateDoor(config)
    local interactive = workspace:FindFirstChild("Interactive")
    if not interactive then
        interactive = Instance.new("Folder")
        interactive.Name = "Interactive"
        interactive.Parent = workspace
    end

    local door = interactive:FindFirstChild(config.Door.Name)
    if door and door:IsA("BasePart") then
        return door
    end

    door = Instance.new("Part")
    door.Name = config.Door.Name
    door.Size = Vector3.new(5, 8, 1)
    door.Anchored = true
    door.CanCollide = true
    door.Position = Vector3.new(0, 4, -12)
    door.Parent = interactive
    door:SetAttribute("P1_InteractionId", config.Door.InteractionId)
    door:SetAttribute("P1_DoorState", "CLOSED")
    return door
end

function DoorService.Initialize(config, traceService)
    local door = getOrCreateDoor(config)
    local prompt = door:FindFirstChildOfClass("ProximityPrompt")
    if not prompt then
        prompt = Instance.new("ProximityPrompt")
        prompt.Name = "P1_DOOR_PROMPT"
        prompt.ActionText = "Interact"
        prompt.ObjectText = "Door"
        prompt.HoldDuration = 0
        prompt.Parent = door
    end

    prompt.Triggered:Connect(function(player)
        if not player or not player.Character then
            return
        end

        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then
            return
        end

        if (root.Position - door.Position).Magnitude > prompt.MaxActivationDistance then
            return
        end

        local current = door:GetAttribute("P1_DoorState")
        local nextState = current == "OPEN" and "CLOSED" or "OPEN"
        door:SetAttribute("P1_DoorState", nextState)
        door.CanCollide = nextState ~= "OPEN"
        door.Transparency = nextState == "OPEN" and 0.35 or 0

        traceService.Record(
            player,
            "DOOR",
            door.Position,
            config.Trace.InteractionStrength,
            config.Trace.Lifetime,
            config.Trace.MaxPerPlayer,
            {
                InteractionId = config.Door.InteractionId,
                DoorState = nextState,
            }
        )
    end)

    return door
end

return DoorService
