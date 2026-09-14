local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local P1Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("P1"):WaitForChild("P1Config"))
local TraceService = require(script.Parent:WaitForChild("P1"):WaitForChild("TraceService"))
local DoorService = require(script.Parent:WaitForChild("P1"):WaitForChild("DoorService"))
local E01Listener = require(script.Parent:WaitForChild("P1"):WaitForChild("E01Listener"))

local function ensureFolder(name, parent)
    local folder = parent:FindFirstChild(name)
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = name
        folder.Parent = parent
    end
    return folder
end

local function ensureSpawn()
    local spawnFolder = ensureFolder("SpawnPoints", workspace)
    local spawn = spawnFolder:FindFirstChild(P1Config.SpawnName)
    if spawn and spawn:IsA("BasePart") then
        return spawn
    end

    spawn = Instance.new("Part")
    spawn.Name = P1Config.SpawnName
    spawn.Size = Vector3.new(4, 1, 4)
    spawn.Anchored = true
    spawn.Transparency = 1
    spawn.CanCollide = false
    spawn.Position = Vector3.new(0, 0.5, -4)
    spawn.Parent = spawnFolder
    return spawn
end

local spawn = ensureSpawn()
DoorService.Initialize(P1Config, TraceService)
E01Listener.Start(P1Config, TraceService)

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        local root = character:WaitForChild("HumanoidRootPart", 10)
        if root then
            root.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
        end
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(function(player)
    TraceService.ForgetPlayer(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
