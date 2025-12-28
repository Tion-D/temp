local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local ToolService = ReplicatedStorage.Shared.Packages.Knit.Services.ToolService
local ToolActivatedRemote = ToolService:WaitForChild("RF"):WaitForChild("ToolActivated")

local LocalPlayer = Players.LocalPlayer


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()


local Window = Fluent:CreateWindow({
    Title = "Jordon Hub",
    SubTitle = "La Forge",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Home = Window:AddTab({ Title = "Home", Icon = "home" }),
    Ingame = Window:AddTab({ Title = "Ingame", Icon = "gamepad-2" }),
    Mining = Window:AddTab({ Title = "Mining", Icon = "pickaxe" }),
    Monster = Window:AddTab({ Title = "Monster", Icon = "skull" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

local Constants = {
    DEFAULT_WALKSPEED = 16,
    MIN_WALKSPEED = 1,
    MAX_WALKSPEED = 500,
    DEFAULT_JUMPPOWER = 50,
    MIN_JUMPPOWER = 50,
    MAX_JUMPPOWER = 500,
    ROCK_TIMEOUT = 360,
    MONSTER_TIMEOUT = 360,
    MAX_BLOCK_DISTANCE = 5,
    MIN_BLOCK_DISTANCE = 20,
    BLOCK_DURATION = 1.0,
}

local PickaxeData = {
    ["Stone Pickaxe"] = { MinePower = 4, Ore = "Stone" },
    ["Bronze Pickaxe"] = { MinePower = 7, Ore = "Copper" },
    ["Iron Pickaxe"] = { MinePower = 10, Ore = "Iron" },
    ["Gold Pickaxe"] = { MinePower = 16, Ore = "Gold" },
    ["Stonewake's Pickaxe"] = { MinePower = 33, Ore = "Stone" },
    ["Platinum Pickaxe"] = { MinePower = 24, Ore = "Platinum" },
    ["Arcane Pickaxe"] = { MinePower = 115, Ore = "Starlite" },
    ["Cobalt Pickaxe"] = { MinePower = 40, Ore = "Cobalt" },
    ["Titanium Pickaxe"] = { MinePower = 55, Ore = "Titanium" },
    ["Uranium Pickaxe"] = { MinePower = 67, Ore = "Uranium" },
    ["Mythril Pickaxe"] = { MinePower = 80, Ore = "Mythril" },
    ["Lightite Pickaxe"] = { MinePower = 100, Ore = "Lightite" },
    ["Magma Pickaxe"] = { MinePower = 135, Ore = "Magmalite" },
    ["Demonic Pickaxe"] = { MinePower = 180, Ore = "Demonite" }
}

local RockData = {
    Pebble = { Ores = {"Stone", "Sand Stone", "Copper", "Iron", "Poopite"}, Health = 14, RequiredDamage = 4, LuckBoost = 0 },
    Rock = { Ores = {"Sand Stone", "Copper", "Iron", "Tin", "Silver", "Poopite", "Bananite", "Cardboardite", "Mushroomite"}, Health = 45, RequiredDamage = 7, LuckBoost = 0.5 },
    Boulder = { Ores = {"Copper", "Iron", "Tin", "Silver", "Gold", "Platinum", "Poopite", "Bananite", "Cardboardite", "Mushroomite", "Aite"}, Health = 100, RequiredDamage = 13, LuckBoost = 1 },
    ["Lucky Block"] = { Ores = {"Fichillium", "Fichilliumgeromoriteiteit"}, Health = 10000, RequiredDamage = 1, LuckBoost = 100 },
    ["Basalt Rock"] = { Ores = {"Silver", "Gold", "Platinum", "Cobalt", "Titanium", "Lapis Lazuli", "Eye Ore"}, Health = 250, RequiredDamage = 16, LuckBoost = 5 },
    ["Basalt Core"] = { Ores = {"Cobalt", "Titanium", "Lapis Lazuli", "Quartz", "Amethyst", "Topaz", "Diamond", "Sapphire", "Cuprite", "Emerald", "Eye Ore"}, Health = 750, RequiredDamage = 39, LuckBoost = 7 },
    ["Basalt Vein"] = { Ores = {"Quartz", "Amethyst", "Topaz", "Diamond", "Sapphire", "Cuprite", "Emerald", "Ruby", "Rivalite", "Uranium", "Mythril", "Eye Ore", "Lightite"}, Health = 2750, RequiredDamage = 78, LuckBoost = 8 },
    ["Volcanic Rock"] = { Ores = {"Volcanic Rock", "Topaz", "Cuprite", "Rivalite", "Obsidian", "Eye Ore", "Fireite", "Magmalite", "Demonite", "Darkryte"}, Health = 4500, RequiredDamage = 100, LuckBoost = 8 },
    ["Earth Crystal"] = { Ores = {"Blue Crystal", "Crimson Crystal", "Green Crystal", "Magenta Crystal", "Orange Crystal", "Rainbow Crystal", "Arcane Crystal"}, Health = 5005, RequiredDamage = 78, LuckBoost = 10 },
    ["Cyan Crystal"] = { Ores = {"Blue Crystal", "Crimson Crystal", "Green Crystal", "Magenta Crystal", "Orange Crystal", "Rainbow Crystal", "Arcane Crystal"}, Health = 5005, RequiredDamage = 78, LuckBoost = 5 },
    ["Crimson Crystal"] = { Ores = {"Blue Crystal", "Crimson Crystal", "Green Crystal", "Magenta Crystal", "Orange Crystal", "Rainbow Crystal", "Arcane Crystal"}, Health = 5005, RequiredDamage = 78, LuckBoost = 5 },
    ["Violet Crystal"] = { Ores = {"Blue Crystal", "Crimson Crystal", "Green Crystal", "Magenta Crystal", "Orange Crystal", "Rainbow Crystal", "Arcane Crystal"}, Health = 5335, RequiredDamage = 78, LuckBoost = 5 },
    ["Light Crystal"] = { Ores = {"Blue Crystal", "Crimson Crystal", "Green Crystal", "Magenta Crystal", "Orange Crystal", "Rainbow Crystal", "Arcane Crystal"}, Health = 5005, RequiredDamage = 78, LuckBoost = 5 }
}

local RockTypes = {"Rock", "Boulder", "Pebble", "Lucky Block", "Light Crystal", "Volcanic Rock", "Basalt Core", "Basalt Rock", "Basalt Vein", "Violet Crystal", "Earth Crystal", "Cyan Crystal", "Crimson Crystal", "Icy Pebble", "Icy Rock", "Icy Boulder", "Small Ice Crystal", "Medium Ice Crystal", "Large Ice Crystal", "Floating Crystal"}

local RockLocations = {"All", "Island1CaveDeep", "Island1CaveMid", "Island1CaveStart", "Roof", "Island2CaveDanger1", "Island2CaveDanger2", "Island2CaveDanger3", "Island2CaveDanger4", "Island2CaveDangerClosed", "Island2CaveDeep", "Island2CaveLavaClosed", "Island2CaveMid", "Island2CaveStart", "Island2GoblinCave", "Island2VolcanicDepths", "Iceberg", "Island3CavePeakEnd", "Island3CavePeakLeft", "Island3CavePeakRight", "Island3CavePeakStart", "Island3RedCave", "Island3SpiderCaveMid", "Island3SpiderCaveMid0", "Island3SpiderCaveMid2", "Island3SpiderCaveStart", "Island3SpiderCaveStart0", "Island3SpiderCaveStart2"}

local MonsterTypes = {"Bomber", "Skeleton Rogue", "Axe Skeleton", "Deathaxe Skeleton", "Elite Rogue Skeleton", "Elite Deathaxe Skeleton", "Zombie", "Delver Zombie", "Elite Zombie", "Brute Zombie", "Reaper", "Blight Puromancer", "Slime", "Blazing Slime", "Common Orc", "Elite Orc", "Crystal Spider", "Diamond Spider", "Prismarine Spider", "Yeti", "Crystal Golem"}

local GOBLIN_CAVE_BOUNDS = {
    Min = Vector3.new(40, 15, -410),
    Max = Vector3.new(260, 75, -20)
}


local State = {
    savedWalkSpeed = Constants.DEFAULT_WALKSPEED,
    savedJumpPower = Constants.DEFAULT_JUMPPOWER,
        
    flyEnabled = false,
    flySpeed = 50,
    flyConnection = nil,
    bodyVelocity = nil,
    bodyGyro = nil,
    
    espEnabled = false,
    espConnections = {},
    
    noclipEnabled = false,
    noclipConnection = nil,
    
    miningEnabled = false,
    indexFarmEnabled = false,
    selectedRockTypes = {"Boulder"},
    selectedLocation = "All",
    selectedIndexAreas = {"All Areas"},
    miningConnection = nil,
    miningNoclipConnection = nil,
    currentTargetRock = nil,
    currentTargetOre = nil,
    currentPickaxePower = 4,
    currentPickaxeName = "Unknown",
    miningTweenSpeed = 80,
    
    monsterFarmEnabled = false,
    monsterBlockingEnabled = false,
    autoBlockEnabled = false,
    autoFaceMonster = true,
    selectedMonsters = {"Zombie"},
    monsterConnection = nil,
    monsterNoclipConnection = nil,
    blockConnection = nil,
    currentTargetMonster = nil,
    isBlocking = false,
    waitingForRespawn = false,
    
    goblinCaveExists = false,
    goblinCaveUnlocked = false,

    rareOreDetectionEnabled = false,
    selectedRareOres = {},
    discordWebhook = "",
    discordUserId = "",
    rareOreCheckInterval = 0.5,
    rockMaintenanceInterval = 20.0,
    lastRockMaintenance = 0,
    initialRockHealth = nil,
    stopMiningOnDetection = false,
    rockCamEnabled = false,
    rockCamHeight = 10
}

local RareOreData = {
    ["Fireite"] = "https://static.wikitide.net/theforgewiki/thumb/6/6c/Fireite.png/121px-Fireite.png",
    ["Magmaite"] = "https://static.wikitide.net/theforgewiki/9/95/Magmaite.png",
    ["Lightite"] = "https://static.wikitide.net/theforgewiki/thumb/1/11/Lightite.png/94px-Lightite.png",
    ["Demonite"] = "https://static.wikitide.net/theforgewiki/3/3d/Demonite.png",
    ["Darkryte"] = "https://static.wikitide.net/theforgewiki/thumb/8/83/Darkryte.png/128px-Darkryte.png",
    ["Arcane Crystal Ore"] = "https://static.wikitide.net/theforgewiki/thumb/9/99/ArcaneCrystal.png/128px-ArcaneCrystal.png"
}

local RareOreTypes = {"Fireite", "Magmaite", "Lightite", "Demonite", "Darkryte", "Arcane Crystal Ore"}

local Connections = {}

local Utils = {}

function Utils.getCharacter()
    return LocalPlayer.Character
end

function Utils.getHumanoid()
    local char = Utils.getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Utils.getHumanoidRootPart()
    local char = Utils.getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

function Utils.isAtSpawnLocation()
    local hrp = Utils.getHumanoidRootPart()
    if not hrp then return false end
    
    local spawnLocation = workspace:FindFirstChild("SpawnLocation", true)
    if spawnLocation and spawnLocation:IsA("SpawnLocation") then
        local distance = (hrp.Position - spawnLocation.Position).Magnitude
        if distance <= 20 then
            return true
        end
    end
    
    if hrp.Position.Y < 10 then
        return true
    end
    
    return false
end

function Utils.fixCameraDesync()
    local camera = workspace.CurrentCamera
    if camera then
        camera.CameraType = Enum.CameraType.Custom
        
        local hrp = Utils.getHumanoidRootPart()
        if hrp then
            camera.CFrame = CFrame.new(camera.CFrame.Position, hrp.Position)
        end
    end
end

function Utils.getSpawnEscapeWaypoints(targetPos)
    local waypoints = {}
    
    local hrp = Utils.getHumanoidRootPart()
    if hrp then
        table.insert(waypoints, Vector3.new(hrp.Position.X, 73, hrp.Position.Z))
    end
    
    table.insert(waypoints, Vector3.new(36, 73, -43))
    
    table.insert(waypoints, Vector3.new(targetPos.X, 73, targetPos.Z))
    
    return waypoints
end

function Utils.notify(title, content, duration)
    Fluent:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3
    })
end

function Utils.isInGoblinCave(position)
    return position.X >= GOBLIN_CAVE_BOUNDS.Min.X and position.X <= GOBLIN_CAVE_BOUNDS.Max.X
        and position.Y >= GOBLIN_CAVE_BOUNDS.Min.Y and position.Y <= GOBLIN_CAVE_BOUNDS.Max.Y
        and position.Z >= GOBLIN_CAVE_BOUNDS.Min.Z and position.Z <= GOBLIN_CAVE_BOUNDS.Max.Z
end

function Utils.pathIntersectsGoblinCave(startPos, endPos)
    if not State.goblinCaveExists or State.goblinCaveUnlocked then
        return false
    end
    for i = 0, 14 do
        local t = i / 14
        local checkPoint = startPos:Lerp(endPos, t)
        if Utils.isInGoblinCave(checkPoint) then
            return true
        end
    end
    return false
end

function Utils.getBypassWaypoint(currentPos, targetPos)
    if not State.goblinCaveExists or State.goblinCaveUnlocked then
        return targetPos
    end
    if not Utils.pathIntersectsGoblinCave(currentPos, targetPos) then
        return targetPos
    end
    local bypassY = GOBLIN_CAVE_BOUNDS.Max.Y + 60
    return Vector3.new(
        (currentPos.X + targetPos.X) / 2,
        bypassY,
        GOBLIN_CAVE_BOUNDS.Min.Z - 100
    )
end

function Utils.detectGoblinCave()
    local debris = workspace:FindFirstChild("Debris")
    if debris then
        local regions = debris:FindFirstChild("Regions")
        if regions and regions:FindFirstChild("Goblin Cave") then return true end
        local mobSpawns = debris:FindFirstChild("MobSpawns")
        if mobSpawns and mobSpawns:FindFirstChild("GoblinCave") then return true end
    end
    local rocksFolder = workspace:FindFirstChild("Rocks")
    if rocksFolder and rocksFolder:FindFirstChild("Island2GoblinCave") then return true end
    local living = workspace:FindFirstChild("Living")
    if living then
        for _, entity in pairs(living:GetChildren()) do
            if entity.Name:lower():find("goblin") then return true end
        end
    end
    return false
end

function Utils.cleanupConnection(connection)
    if connection then
        pcall(function() connection:Disconnect() end)
    end
    return nil
end

function Utils.cleanupBodyMovers()
    if State.bodyVelocity then
        pcall(function() State.bodyVelocity:Destroy() end)
        State.bodyVelocity = nil
    end
    if State.bodyGyro then
        pcall(function() State.bodyGyro:Destroy() end)
        State.bodyGyro = nil
    end
end

function Utils.detectDesync()
    local hrp = Utils.getHumanoidRootPart()
    if not hrp then return false end
    
    local velocity = hrp.AssemblyLinearVelocity
    local speed = velocity.Magnitude
    
    -- Check if being flung (very high velocity)
    if speed > 100 then
        return true, speed
    end
    
    -- Check if position is abnormal (very high Y position)
    if hrp.Position.Y > 500 then
        return true, speed
    end
    
    return false, speed
end
function Utils.fixDesync()
    local hrp = Utils.getHumanoidRootPart()
    if not hrp then return false end
    
    print("[DESYNC FIX] 🔧 Detected client-server desync, fixing...")
    
    -- Stop all tweens
    if State.miningEnabled then
        MiningFunctions.cancelCurrentTween()
    end
    if State.monsterFarmEnabled then
        MonsterFunctions.cancelCurrentTween()
    end
    
    -- Reset all velocity
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    -- Anchor character temporarily to force position sync
    local character = Utils.getCharacter()
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Velocity = Vector3.zero
                part.RotVelocity = Vector3.zero
            end
        end
    end
    
    -- NEW: Fix camera
    local camera = workspace.CurrentCamera
    if camera then
        camera.CameraType = Enum.CameraType.Custom
    end
    
    -- Force humanoid to reset state
    local humanoid = Utils.getHumanoid()
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Landing)
        task.wait(0.1)
    end
    
    -- Reset velocity again after state change
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    print("[DESYNC FIX] ✅ Desync fixed, velocity reset")
    return true
end

function Utils.getRockHealth(rock)
    if not rock then return nil end
    
    local searchObjects = {rock, rock.Parent, rock.Parent and rock.Parent.Parent}
    
    for _, obj in ipairs(searchObjects) do
        if obj then
            local info = obj:FindFirstChild("infoFrame")
            if not info then
                info = obj:FindFirstChild("InfoFrame")
            end
            
            if info then
                local frame = info:FindFirstChild("Frame")
                if frame then
                    local hpLabel = frame:FindFirstChild("rockHP")
                    if hpLabel then
                        local hpText = hpLabel.Text
                        if hpText and typeof(hpText) == "string" then
                            local hp = hpText:match("%d+%.?%d*")
                            if hp then
                                return tonumber(hp)
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nil
end

function Utils.getMonsterHealth(monster)
    if not monster or not monster.Parent then return nil end
    
    local hrp = monster:FindFirstChild("HumanoidRootPart")
    if not hrp or not hrp.Parent then return nil end
    
    local info = hrp:FindFirstChild("infoFrame")
    if not info then
        info = hrp:FindFirstChild("InfoFrame")
    end
    
    if not info or not info.Parent then return nil end
    
    local frame = info:FindFirstChild("Frame")
    if not frame or not frame.Parent then return nil end
    
    local hpLabel = frame:FindFirstChild("rockHP")
    if not hpLabel or not hpLabel.Parent then return nil end
    
    local hpText = hpLabel.Text
    if hpText and typeof(hpText) == "string" then
        local hp = hpText:match("%d+")
        if hp then
            return tonumber(hp)
        end
    end
    
    return nil
end

local PlayerFunctions = {}

function PlayerFunctions.setWalkSpeed(speed)
    local humanoid = Utils.getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = speed
        State.savedWalkSpeed = speed
        return true
    end
    return false
end

function PlayerFunctions.setJumpPower(power)
    local humanoid = Utils.getHumanoid()
    if humanoid then
        humanoid.JumpPower = power
        State.savedJumpPower = power
        return true
    end
    return false
end

function PlayerFunctions.enableFly(speedRef)
    local hrp = Utils.getHumanoidRootPart()
    if not hrp then return false end
    
    Utils.cleanupBodyMovers()
    State.flyConnection = Utils.cleanupConnection(State.flyConnection)
    
    State.bodyVelocity = Instance.new("BodyVelocity")
    State.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    State.bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    State.bodyVelocity.Parent = hrp
    
    State.bodyGyro = Instance.new("BodyGyro")
    State.bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    State.bodyGyro.P = 9e4
    State.bodyGyro.Parent = hrp
    
    State.flyConnection = RunService.Heartbeat:Connect(function()
        if not State.flyEnabled then return end
        
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        local speed = speedRef and speedRef() or State.flySpeed
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        if State.bodyVelocity then
            State.bodyVelocity.Velocity = moveDirection * speed
        end
        if State.bodyGyro then
            State.bodyGyro.CFrame = camera.CFrame
        end
    end)
    
    State.flyEnabled = true
    return true
end

function PlayerFunctions.disableFly()
    State.flyEnabled = false
    State.flyConnection = Utils.cleanupConnection(State.flyConnection)
    Utils.cleanupBodyMovers()
end

function PlayerFunctions.enableNoclip()
    State.noclipConnection = Utils.cleanupConnection(State.noclipConnection)
    
    State.noclipConnection = RunService.Stepped:Connect(function()
        if not State.noclipEnabled then return end
        local character = Utils.getCharacter()
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
    
    State.noclipEnabled = true
end

function PlayerFunctions.disableNoclip()
    State.noclipEnabled = false
    State.noclipConnection = Utils.cleanupConnection(State.noclipConnection)
    
    local character = Utils.getCharacter()
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

function PlayerFunctions.enableESP()
    PlayerFunctions.disableESP()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local function addESP(character)
                if not character then return end
                local hrp = character:WaitForChild("HumanoidRootPart", 5)
                if not hrp then return end
                
                local existing = character:FindFirstChild("DJHUB_ESP")
                if existing then existing:Destroy() end
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "DJHUB_ESP"
                highlight.Adornee = character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = character
            end
            
            if player.Character then
                addESP(player.Character)
            end
            
            table.insert(State.espConnections, player.CharacterAdded:Connect(function(character)
                if State.espEnabled then
                    addESP(character)
                end
            end))
        end
    end
    
    table.insert(State.espConnections, Players.PlayerAdded:Connect(function(player)
        if State.espEnabled and player ~= LocalPlayer then
            player.CharacterAdded:Connect(function(character)
                if State.espEnabled then
                    local hrp = character:WaitForChild("HumanoidRootPart", 5)
                    if hrp then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "DJHUB_ESP"
                        highlight.Adornee = character
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = character
                    end
                end
            end)
        end
    end))
    
    State.espEnabled = true
end

function PlayerFunctions.disableESP()
    State.espEnabled = false
    
    for _, connection in pairs(State.espConnections) do
        pcall(function() connection:Disconnect() end)
    end
    State.espConnections = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, obj in pairs(player.Character:GetDescendants()) do
                if obj.Name == "DJHUB_ESP" and obj:IsA("Highlight") then
                    obj:Destroy()
                end
            end
        end
    end
end


local MiningFunctions = {}

local MiningState = {
    targetConnection = nil,
    noclipConnection = nil,
    currentTarget = nil,
    currentTween = nil,
    currentTweenId = nil,
    rockTypeIndex = 1,
    rockNotFoundCount = 0,
    MAX_NOT_FOUND = 10,
    isAtRock = false,
    isMining = false,
    lastTweenTime = 0,
    rareOreConnection = nil,
    lastMineTime = 0,
    oreDetected = false,
    lastMaintenanceHit = 0,
    shouldMineOut = false,
    recentlyCheckedRocks = {},
    ROCK_COOLDOWN = 30,
    
    lastPosition = nil,
    lastPositionTime = 0,
    stuckCheckInterval = 0.5,
    stuckThreshold = 2,
    stuckTimeout = 3,
    stuckCount = 0,
    maxStuckRetries = 3,
    tweenStartTime = 0,
    tweenTimeout = 15,
    arrivalDistance = 5,
    problematicRocks = {},
    PROBLEMATIC_ROCK_COOLDOWN = 120,
    lastRockHealth = nil,
    lastHealthCheckTime = 0,
    HEALTH_CHECK_INTERVAL = 5, 
    noProgressCount = 0,
    MAX_NO_PROGRESS = 2
}

local function getPickaxeTool()
    local char = LocalPlayer.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("pickaxe") then
                return t
            end
        end
    end

    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("pickaxe") then
                return t
            end
        end
    end

    return nil
end

function MiningFunctions.detectPickaxe()
    pcall(function()
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
        if not playerGui then return end
        local backpackGui = playerGui:FindFirstChild("BackpackGui")
        if not backpackGui then return end
        local backpack = backpackGui:FindFirstChild("Backpack")
        if not backpack then return end
        local hotbar = backpack:FindFirstChild("Hotbar")
        if not hotbar then return end
        
        for _, slot in pairs(hotbar:GetChildren()) do
            local frame = slot:FindFirstChild("Frame")
            if frame then
                local viewportFrame = frame:FindFirstChild("ViewportFrame")
                if viewportFrame then
                    for _, obj in pairs(viewportFrame:GetChildren()) do
                        if obj.Name:find("Pickaxe") then
                            local pickaxeInfo = PickaxeData[obj.Name]
                            if pickaxeInfo then
                                State.currentPickaxePower = pickaxeInfo.MinePower
                                State.currentPickaxeName = obj.Name
                            else
                                State.currentPickaxeName = obj.Name
                                State.currentPickaxePower = 4
                            end
                            return
                        end
                    end
                end
            end
        end
    end)
end

function MiningFunctions.isRockAvailable(rockType)
    local rocksFolder = workspace:FindFirstChild("Rocks")
    if not rocksFolder then return false end

    for _, locationFolder in pairs(rocksFolder:GetChildren()) do
        local a = locationFolder:FindFirstChild(rockType)
        if MiningFunctions.resolveRockPart(a) then return true end

        local spawn = locationFolder:FindFirstChild("SpawnLocation")
        if spawn then
            local b = spawn:FindFirstChild(rockType)
            if MiningFunctions.resolveRockPart(b) then return true end
        end

        for _, d in pairs(locationFolder:GetDescendants()) do
            if d.Name == rockType and MiningFunctions.resolveRockPart(d) then
                return true
            end
        end
    end

    return false
end

function MiningFunctions.resolveRockPart(inst)
    if not inst then return nil end

    if inst:IsA("BasePart") then
        return inst
    end

    local cd = inst:FindFirstChildWhichIsA("ClickDetector", true)
    if cd and cd.Parent and cd.Parent:IsA("BasePart") then
        return cd.Parent
    end

    local part = inst:FindFirstChildWhichIsA("BasePart", true)
    return part
end

function MiningFunctions.isRockProblematic(rock)
    if not rock then return false end
    local currentTime = tick()
    local timestamp = MiningState.problematicRocks[rock]
    if timestamp then
        if currentTime - timestamp < MiningState.PROBLEMATIC_ROCK_COOLDOWN then
            return true
        else
            MiningState.problematicRocks[rock] = nil
        end
    end
    return false
end

function MiningFunctions.markRockAsProblematic(rock)
    if rock then
        MiningState.problematicRocks[rock] = tick()
        print(string.format("[MINING] ⚠️ Marked rock as problematic for %d seconds", MiningState.PROBLEMATIC_ROCK_COOLDOWN))
    end
end

function MiningFunctions.findRock(rockType, location, excludeRock)
    local success, result = pcall(function()
        local rocksFolder = workspace:FindFirstChild("Rocks")
        if not rocksFolder then return nil end

        local hrp = Utils.getHumanoidRootPart()
        local myPos = hrp and hrp.Position or Vector3.new(0, 0, 0)
        local candidates = {}
        local skippedDeadRocks = 0
        
        local shouldExclude = excludeRock and MiningFunctions.rockHasOreModel(excludeRock)
        
        local currentTime = tick()
        
        for rock, timestamp in pairs(MiningState.recentlyCheckedRocks) do
            if currentTime - timestamp > MiningState.ROCK_COOLDOWN then
                MiningState.recentlyCheckedRocks[rock] = nil
            end
        end
        
        for rock, timestamp in pairs(MiningState.problematicRocks) do
            if currentTime - timestamp > MiningState.PROBLEMATIC_ROCK_COOLDOWN then
                MiningState.problematicRocks[rock] = nil
            end
        end

        for _, locationFolder in pairs(rocksFolder:GetChildren()) do
            if location == "All" or locationFolder.Name == location then
                local direct = locationFolder:FindFirstChild(rockType)
                if direct then
                    local directPart = MiningFunctions.resolveRockPart(direct)
                    local isRecentlyChecked = MiningState.recentlyCheckedRocks[directPart] ~= nil
                    local isProblematic = MiningFunctions.isRockProblematic(directPart)
                    if directPart and not (shouldExclude and directPart == excludeRock) and not isRecentlyChecked and not isProblematic then
                        local hp = Utils.getRockHealth(directPart)
                        if hp and hp <= 0 then
                            skippedDeadRocks = skippedDeadRocks + 1
                        elseif not hp or hp > 0 then
                            local dist = (directPart.Position - myPos).Magnitude
                            table.insert(candidates, {rock = directPart, distance = dist})
                        end
                    end
                end

                local spawn = locationFolder:FindFirstChild("SpawnLocation")
                if spawn then
                    local inSpawn = spawn:FindFirstChild(rockType)
                    if inSpawn then
                        local inSpawnPart = MiningFunctions.resolveRockPart(inSpawn)
                        local isRecentlyChecked = MiningState.recentlyCheckedRocks[inSpawnPart] ~= nil
                        local isProblematic = MiningFunctions.isRockProblematic(inSpawnPart)
                        if inSpawnPart and not (shouldExclude and inSpawnPart == excludeRock) and not isRecentlyChecked and not isProblematic then
                            local hp = Utils.getRockHealth(inSpawnPart)
                            if hp and hp <= 0 then
                                skippedDeadRocks = skippedDeadRocks + 1
                            elseif not hp or hp > 0 then
                                local dist = (inSpawnPart.Position - myPos).Magnitude
                                table.insert(candidates, {rock = inSpawnPart, distance = dist})
                            end
                        end
                    end
                end

                for _, d in pairs(locationFolder:GetDescendants()) do
                    if d.Name == rockType then
                        local p = MiningFunctions.resolveRockPart(d)
                        local isRecentlyChecked = MiningState.recentlyCheckedRocks[p] ~= nil
                        local isProblematic = MiningFunctions.isRockProblematic(p)
                        if p and not (shouldExclude and p == excludeRock) and not isRecentlyChecked and not isProblematic then
                            local hp = Utils.getRockHealth(p)
                            if hp and hp <= 0 then
                                skippedDeadRocks = skippedDeadRocks + 1
                            elseif not hp or hp > 0 then
                                local dist = (p.Position - myPos).Magnitude
                                table.insert(candidates, {rock = p, distance = dist})
                            end
                        end
                    end
                end
            end
        end

        if #candidates > 0 then
            table.sort(candidates, function(a, b) return a.distance < b.distance end)
            return candidates[1].rock
        end

        return nil
    end)
    
    if success then
        return result
    else
        warn("[findRock Error]:", result)
        return nil
    end
end

function MiningFunctions.findNextRock(excludeRock)
    local success, result = pcall(function()
        if #State.selectedRockTypes == 0 then 
            return nil 
        end
        
        if MiningState.rockTypeIndex < 1 or MiningState.rockTypeIndex > #State.selectedRockTypes then
            MiningState.rockTypeIndex = 1
        end
        
        local rockType = State.selectedRockTypes[MiningState.rockTypeIndex]
        if not rockType then
            MiningState.rockTypeIndex = 1
            rockType = State.selectedRockTypes[1]
        end
        
        if rockType then
            local rock = MiningFunctions.findRock(rockType, State.selectedLocation, excludeRock)
            if rock then
                return rock
            end
        end
        
        for i = 1, #State.selectedRockTypes do
            local idx = ((MiningState.rockTypeIndex - 1 + i) % #State.selectedRockTypes) + 1
            rockType = State.selectedRockTypes[idx]
            if rockType then
                local rock = MiningFunctions.findRock(rockType, State.selectedLocation, excludeRock)
                if rock then
                    MiningState.rockTypeIndex = idx
                    return rock
                end
            end
        end
        
        return nil
    end)
    
    if success then
        return result
    else
        warn("[findNextRock Error]:", result)
        MiningState.rockTypeIndex = 1
        return nil
    end
end

function MiningFunctions.enableNoclip()
    MiningState.noclipConnection = Utils.cleanupConnection(MiningState.noclipConnection)
    MiningState.noclipConnection = RunService.Stepped:Connect(function()
        if not State.miningEnabled and not State.rareOreDetectionEnabled then return end
        local character = Utils.getCharacter()
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local PickaxeSwing = require(ReplicatedStorage.Assets.Effects.SwingPickaxe.Handler)

function MiningFunctions.mineRock(rock)
    local char = LocalPlayer.Character
    if not char then return false end

    local tool = getPickaxeTool()
    if not tool then return false end

    local hum = Utils.getHumanoid()
    if hum and tool.Parent ~= char then
        hum:EquipTool(tool)
    end

    pcall(function()
        ToolActivatedRemote:InvokeServer(tool.Name, false)
    end)

    pcall(function()
        PickaxeSwing.swing(char, 1)
    end)
    

    return true
end

function MiningFunctions.checkForOresInRock(rock)
    if not rock or not rock.Parent then return nil end
    
    local foundOres = {}
    
    for _, child in pairs(rock:GetChildren()) do
        if child:IsA("Model") and child.Name == "Ore" then
            local oreType = child:GetAttribute("Ore")
            if oreType then
                table.insert(foundOres, {oreType = oreType, model = child})
            end
        end
    end
    
    if rock.Parent then
        for _, child in pairs(rock.Parent:GetChildren()) do
            if child:IsA("Model") and child.Name == "Ore" then
                local oreType = child:GetAttribute("Ore")
                if oreType then
                    local alreadyFound = false
                    for _, ore in ipairs(foundOres) do
                        if ore.model == child then
                            alreadyFound = true
                            break
                        end
                    end
                    if not alreadyFound then
                        table.insert(foundOres, {oreType = oreType, model = child})
                    end
                end
            end
        end
    end
    
    if #foundOres == 0 then
        return nil
    end
    
    for _, ore in ipairs(foundOres) do
        for _, rareOre in ipairs(State.selectedRareOres) do
            if ore.oreType == rareOre or ore.oreType:find(rareOre) then
                print(string.format("[ORE CHECK] 💎 Found RARE ore: %s (among %d total ores)", ore.oreType, #foundOres))
                return ore.oreType, ore.model
            end
        end
    end
    
    print(string.format("[ORE CHECK] Found %d ore(s), first one: %s", #foundOres, foundOres[1].oreType))
    return foundOres[1].oreType, foundOres[1].model
end

function MiningFunctions.rockHasOreModel(rock)
    if not rock or not rock.Parent then return false end
    
    for _, child in pairs(rock:GetChildren()) do
        if child:IsA("Model") and child.Name == "Ore" then
            return true
        end
    end
    
    if rock.Parent then
        for _, child in pairs(rock.Parent:GetChildren()) do
            if child:IsA("Model") and child.Name == "Ore" then
                return true
            end
        end
    end
    
    return false
end

function MiningFunctions.sendDiscordWebhook(oreName, imageUrl)
    if State.discordWebhook == "" then
        warn("[RARE ORE] No Discord webhook configured")
        return false
    end
    
    local success, err = pcall(function()
        local HttpService = game:GetService("HttpService")
        
        local embed = {
            title = "🎉 OMG OGM OMG GAGAGAGA!",
            description = string.format("**%s** has been detected!", oreName),
            color = 15844367,
            thumbnail = {
                url = imageUrl
            },
            fields = {
                {
                    name = "Ore Type",
                    value = oreName,
                    inline = true
                },
                {
                    name = "Location",
                    value = State.selectedLocation or "Unknown",
                    inline = true
                }
            },
            timestamp = DateTime.now():ToIsoDate(),
            footer = {
                text = "Jordon Hub - La Forge"
            }
        }
        
        local content = ""
        if State.discordUserId ~= "" then
            content = string.format("<@%s>", State.discordUserId)
        end
        
        local data = {
            content = content,
            embeds = {embed}
        }
        
        local jsonData = HttpService:JSONEncode(data)
        
        local response = request({
            Url = State.discordWebhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
        
        if response.StatusCode == 204 or response.StatusCode == 200 then
            print("[RARE ORE] ✅ Discord notification sent successfully!")
            return true
        else
            warn("[RARE ORE] ❌ Discord webhook failed with status:", response.StatusCode)
            return false
        end
    end)
    
    if not success then
        warn("[RARE ORE] Discord webhook error:", err)
        return false
    end
    
    return true
end

function MiningFunctions.cancelCurrentTween()
    if MiningState.currentTween then
        MiningState.currentTweenId = nil
        pcall(function() 
            MiningState.currentTween:Cancel() 
        end)
        MiningState.currentTween = nil
    end
end

function MiningFunctions.getDistanceToRock(rock)
    if not rock or not rock.Parent then return math.huge end
    local hrp = Utils.getHumanoidRootPart()
    if not hrp then return math.huge end
    return (hrp.Position - rock.Position).Magnitude
end

function MiningFunctions.isAtRockPosition(rock)
    if not rock or not rock.Parent then return false end
    local distance = MiningFunctions.getDistanceToRock(rock)
    return distance <= MiningState.arrivalDistance
end

function MiningFunctions.checkIfStuck()
    local hrp = Utils.getHumanoidRootPart()
    if not hrp then return false end
    
    local currentTime = tick()
    local currentPos = hrp.Position
    
    if MiningState.lastPosition then
        local timeSinceLastCheck = currentTime - MiningState.lastPositionTime
        
        if timeSinceLastCheck >= MiningState.stuckCheckInterval then
            local distanceMoved = (currentPos - MiningState.lastPosition).Magnitude
            local expectedMovement = MiningState.stuckThreshold
            
            if distanceMoved < expectedMovement and not MiningState.isAtRock then
                MiningState.stuckCount = MiningState.stuckCount + 1
                
                local totalStuckTime = MiningState.stuckCount * MiningState.stuckCheckInterval
                
                if totalStuckTime >= MiningState.stuckTimeout then
                    print(string.format("[MINING] ⚠️ STUCK DETECTED! Moved only %.2f studs in %.1f seconds", distanceMoved, totalStuckTime))
                    return true
                end
            else
                MiningState.stuckCount = 0
            end
            
            MiningState.lastPosition = currentPos
            MiningState.lastPositionTime = currentTime
        end
    else
        MiningState.lastPosition = currentPos
        MiningState.lastPositionTime = currentTime
    end
    
    return false
end

function MiningFunctions.checkTweenTimeout()
    if MiningState.tweenStartTime > 0 then
        local elapsed = tick() - MiningState.tweenStartTime
        if elapsed > MiningState.tweenTimeout then
            print(string.format("[MINING] ⚠️ TWEEN TIMEOUT! Took longer than %d seconds", MiningState.tweenTimeout))
            return true
        end
    end
    return false
end

function MiningFunctions.handleStuckRecovery(rock)
    print("[MINING] 🔄 Attempting stuck recovery...")
    
    MiningFunctions.cancelCurrentTween()
    
    if rock then
        MiningFunctions.markRockAsProblematic(rock)
    end
    
    MiningState.stuckCount = 0
    MiningState.lastPosition = nil
    MiningState.lastPositionTime = 0
    MiningState.tweenStartTime = 0
    MiningState.isAtRock = false
    MiningState.isMining = false
    
    local hrp = Utils.getHumanoidRootPart()
    if hrp then
        local currentPos = hrp.Position
        local escapePos = currentPos + Vector3.new(0, 15, 0)
        
        print("[MINING] 🚀 Teleporting up to escape stuck position...")
        hrp.CFrame = CFrame.new(escapePos)
        task.wait(0.3)
    end
    
    local newRock = MiningFunctions.findNextRock(rock)
    
    if newRock then
        print("[MINING] ✅ Found new rock after recovery!")
        return newRock
    else
        print("[MINING] ❌ No suitable rocks found after recovery")
        return nil
    end
end

function MiningFunctions.teleportToRock(rock)
    local hrp = Utils.getHumanoidRootPart()
    if not hrp or not rock or not rock.Parent then return false end

    MiningFunctions.cancelCurrentTween()
    MiningState.tweenStartTime = 0

    local character = Utils.getCharacter()
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    local targetPos = rock.Position
    hrp.CFrame = CFrame.new(targetPos)

    MiningState.isAtRock = true
    print("[MINING] ⚡ Instant teleport to rock center!")
    return true
end

function MiningFunctions.repositionAtRock(rock)
    if not rock or not rock.Parent then return false end
    
    local hrp = Utils.getHumanoidRootPart()
    if not hrp then return false end
    
    print("[MINING] 🔄 Repositioning to rock center...")
    
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    local targetPos = rock.Position
    hrp.CFrame = CFrame.new(targetPos)
    
    task.wait(0.1)
    
    MiningState.isAtRock = true
    MiningState.lastRockHealth = nil
    MiningState.noProgressCount = 0
    
    print("[MINING] ✅ Repositioned at rock center!")
    return true
end

function MiningFunctions.checkMiningProgress(rock)
    local currentTime = tick()
    
    if currentTime - MiningState.lastHealthCheckTime < MiningState.HEALTH_CHECK_INTERVAL then
        return true
    end
    
    MiningState.lastHealthCheckTime = currentTime
    
    local currentHealth = Utils.getRockHealth(rock)
    if not currentHealth then
        print("[MINING] ⚠️ Cannot read rock health")
        return true
    end
    
    if not MiningState.lastRockHealth then
        MiningState.lastRockHealth = currentHealth
        print(string.format("[MINING] 📊 Initial health check: %.1f HP", currentHealth))
        return true
    end
    
    local healthLost = MiningState.lastRockHealth - currentHealth
    
    if healthLost > 0 then
        print(string.format("[MINING] ✅ Making progress! Lost %.1f HP in %d seconds", healthLost, MiningState.HEALTH_CHECK_INTERVAL))
        MiningState.lastRockHealth = currentHealth
        MiningState.noProgressCount = 0
        return true
    else
        MiningState.noProgressCount = MiningState.noProgressCount + 1
        print(string.format("[MINING] ⚠️ No mining progress! Check %d/%d", MiningState.noProgressCount, MiningState.MAX_NO_PROGRESS))
        
        if MiningState.noProgressCount >= MiningState.MAX_NO_PROGRESS then
            print("[MINING] ❌ Not making progress, need to reposition!")
            MiningState.lastRockHealth = currentHealth
            MiningState.noProgressCount = 0
            return false
        end
        
        MiningState.lastRockHealth = currentHealth
        return true
    end
end

function MiningFunctions.tweenToRock(rock, useInstantTeleport)
    local hrp = Utils.getHumanoidRootPart()
    if not hrp or not rock or not rock.Parent then return false end
    
    if not State.miningEnabled and not State.rareOreDetectionEnabled then
        print("[MINING] ⚠️ Mining disabled, aborting tween")
        return false
    end

    MiningFunctions.cancelCurrentTween()
    
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    MiningState.stuckCount = 0
    MiningState.lastPosition = hrp.Position
    MiningState.lastPositionTime = tick()
    MiningState.tweenStartTime = tick()

    local targetPos = rock.Position
    local currentPos = hrp.Position
    local distance = (targetPos - currentPos).Magnitude
    
    if distance <= MiningState.arrivalDistance then
        hrp.CFrame = CFrame.new(targetPos)
        MiningState.isAtRock = true
        MiningState.tweenStartTime = 0
        return true
    end
    
    if useInstantTeleport or distance < 20 then
        return MiningFunctions.teleportToRock(rock)
    end
    
    local isAtSpawn = Utils.isAtSpawnLocation()
    local waypoints = {}
    
    if isAtSpawn then
        print("[MINING] 🚀 At spawn location, using escape waypoints!")
        waypoints = Utils.getSpawnEscapeWaypoints(targetPos)
        table.insert(waypoints, targetPos)
    else
        table.insert(waypoints, targetPos)
    end
    
    local tweenId = tick()
    MiningState.currentTweenId = tweenId

    local function tweenToNextWaypoint(waypointIndex)
        if not State.miningEnabled and not State.rareOreDetectionEnabled then
            print("[MINING] ⚠️ Mining disabled during tween, stopping")
            return
        end
        
        if MiningState.currentTweenId ~= tweenId then
            return
        end
        
        if waypointIndex > #waypoints then
            MiningState.isAtRock = true
            MiningState.tweenStartTime = 0
            print("[MINING] ✅ Completed all waypoints, arrived at rock!")
            return
        end
        
        local currentHrp = Utils.getHumanoidRootPart()
        if not currentHrp then return end
        
        currentHrp.AssemblyLinearVelocity = Vector3.zero
        currentHrp.AssemblyAngularVelocity = Vector3.zero
        
        local nextWaypoint = waypoints[waypointIndex]
        local dist = (nextWaypoint - currentHrp.Position).Magnitude
        local speed = State.miningTweenSpeed or 80
        local duration = math.clamp(dist / speed, 0.1, MiningState.tweenTimeout - 1)
        
        local tweenInfo = TweenInfo.new(
            duration,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )
        
        MiningState.currentTween = TweenService:Create(currentHrp, tweenInfo, {CFrame = CFrame.new(nextWaypoint)})
        
        MiningState.currentTween.Completed:Connect(function(playbackState)
            if not State.miningEnabled and not State.rareOreDetectionEnabled then
                return
            end
            
            if playbackState == Enum.PlaybackState.Completed and MiningState.currentTweenId == tweenId then
                print(string.format("[MINING] ✅ Reached waypoint %d/%d", waypointIndex, #waypoints))
                task.wait(0.1)
                tweenToNextWaypoint(waypointIndex + 1)
            end
        end)
        
        MiningState.currentTween:Play()
    end
    
    tweenToNextWaypoint(1)
    
    return true
end

function MiningFunctions.startRareOreDetection()
    MiningState.rareOreConnection = Utils.cleanupConnection(MiningState.rareOreConnection)
    
    local lastSearchTime = 0
    local lastTweenTime = 0
    local SEARCH_COOLDOWN = 1.0
    local RETWEEN_INTERVAL = 0.3
    local STUCK_CHECK_INTERVAL = 0.5
    local lastStuckCheck = 0
    
    MiningState.rareOreConnection = RunService.Heartbeat:Connect(function()
        if not State.rareOreDetectionEnabled then return end
        
        local success, err = pcall(function()
            local target = MiningState.currentTarget
            local currentTime = tick()
            
            -- Check for client-server desync
            if currentTime - MiningState.lastDesyncCheck >= MiningState.DESYNC_CHECK_INTERVAL then
                MiningState.lastDesyncCheck = currentTime
                local isDesynced, speed = Utils.detectDesync()
                if isDesynced then
                    print(string.format("[RARE ORE] ⚠️ DESYNC DETECTED! Velocity: %.2f", speed))
                    Utils.fixDesync()
                    MiningState.isAtRock = false
                    MiningState.isMining = false
                    task.wait(0.3)
                    return
                end
            end
            
            if currentTime - lastStuckCheck >= STUCK_CHECK_INTERVAL then
                lastStuckCheck = currentTime
                
                if target and target.Parent and not MiningState.isAtRock then
                    local isStuck = MiningFunctions.checkIfStuck()
                    local isTimedOut = MiningFunctions.checkTweenTimeout()
                    
                    if isStuck or isTimedOut then
                        print("[RARE ORE] 🔧 Stuck or timed out, recovering...")
                        local newRock = MiningFunctions.handleStuckRecovery(target)
                        
                        if newRock then
                            MiningState.currentTarget = newRock
                            MiningState.oreDetected = false
                            MiningState.shouldMineOut = false
                            State.initialRockHealth = nil
                            
                            local initialHP = Utils.getRockHealth(newRock)
                            State.initialRockHealth = initialHP
                            
                            lastTweenTime = currentTime
                            MiningFunctions.tweenToRock(newRock, true)
                        else
                            MiningState.currentTarget = nil
                            lastSearchTime = 0
                        end
                        return
                    end
                end
            end
            
            if target and target.Parent then
                local health = Utils.getRockHealth(target)
                
                if health and health <= 0 then
                    print("[RARE ORE] Rock destroyed, finding new rock...")
                    MiningState.currentTarget = nil
                    MiningState.oreDetected = false
                    MiningState.shouldMineOut = false
                    State.initialRockHealth = nil
                    MiningState.isAtRock = false
                    MiningState.stuckCount = 0
                    lastSearchTime = 0
                    return
                end
                
                local currentDistance = MiningFunctions.getDistanceToRock(target)
                if currentDistance <= tonumber(MiningState.arrivalDistance or 5) then
                    if not MiningState.isAtRock then
                        print(string.format("[RARE ORE] ✅ Arrived at rock! (Distance: %.2f)", currentDistance))
                    end
                    MiningState.isAtRock = true
                    MiningState.stuckCount = 0
                end
                
                if MiningState.isAtRock and MiningState.isMining then
                    local SHOVE_THRESHOLD = MiningState.arrivalDistance + 3
                    if currentDistance > SHOVE_THRESHOLD then
                        print(string.format("[MINING] ⚠️ Pushed away from rock! (Distance: %.2f) Re-positioning...", currentDistance))
                        MiningState.isAtRock = false
                        MiningState.isMining = false
                        MiningFunctions.teleportToRock(target)
                        MiningState.isMining = true
                    end
                end
                
                if not MiningState.isAtRock and currentTime - lastTweenTime >= RETWEEN_INTERVAL then
                    lastTweenTime = currentTime
                    MiningFunctions.tweenToRock(target, false)
                end
                
                pcall(function()
                    MiningFunctions.updateRockCam(target)
                end)
                
                if State.stopMiningOnDetection and MiningState.oreDetected then
                    if currentTime - MiningState.lastMaintenanceHit >= State.rockMaintenanceInterval then
                        MiningState.lastMaintenanceHit = currentTime
                        
                        if MiningState.isAtRock then
                            print("[RARE ORE] 🔨 Maintenance hit (Stop Mode)...")
                            MiningFunctions.mineRock(target)
                        end
                    end
                    return
                end
                
                if MiningState.shouldMineOut then
                    if MiningState.isAtRock then
                        local makingProgress = MiningFunctions.checkMiningProgress(target)
                        if not makingProgress then
                            print("[RARE ORE] 🔧 Not hitting rock properly, repositioning...")
                            MiningFunctions.repositionAtRock(target)
                            task.wait(0.2)
                        end
                        
                        MiningFunctions.mineRock(target)
                    end
                else
                    if currentTime - MiningState.lastMineTime >= State.rareOreCheckInterval then
                        MiningState.lastMineTime = currentTime
                        
                        if MiningState.isAtRock then
                            MiningFunctions.mineRock(target)
                            
                            task.wait()
                            
                            local detectedOre, oreModel = MiningFunctions.checkForOresInRock(target)

                            if detectedOre then
                                print(string.format("[RARE ORE] Detected ore: %s", detectedOre))
                                
                                local foundRareOre = false
                                for _, rareOre in ipairs(State.selectedRareOres) do
                                    if detectedOre == rareOre or detectedOre:find(rareOre) then
                                        print(string.format("[RARE ORE] 💎 Found %s!", detectedOre))
                                        
                                        local imageUrl = RareOreData[rareOre] or RareOreData["Fireite"]
                                        MiningFunctions.sendDiscordWebhook(detectedOre, imageUrl)
                                        
                                        MiningState.oreDetected = true
                                        foundRareOre = true
                                        
                                        if State.stopMiningOnDetection then
                                            Utils.notify("Rare Ore Found!", detectedOre .. " - Maintaining rock!", 5)
                                            MiningState.lastMaintenanceHit = currentTime
                                        else
                                            Utils.notify("Rare Ore Found!", detectedOre .. " - Mining out rock!", 5)
                                            MiningState.shouldMineOut = true
                                        end
                                        break
                                    end
                                end

                                if not foundRareOre and not MiningState.shouldMineOut then
                                    print(string.format("[RARE ORE] Found %s (not target), moving to next rock...", detectedOre))
                                    
                                    local oldRock = MiningState.currentTarget
                                    
                                    MiningState.recentlyCheckedRocks[oldRock] = tick()
                                    print(string.format("[RARE ORE] Added rock to cooldown list for %d seconds", MiningState.ROCK_COOLDOWN))
                                    
                                    MiningState.currentTarget = nil
                                    MiningState.isAtRock = false
                                    MiningState.stuckCount = 0
                                    
                                    local newRock = MiningFunctions.findNextRock(oldRock)
                                    
                                    if newRock then
                                        print(string.format("[RARE ORE] ✅ Found different rock, moving to it..."))
                                        MiningState.currentTarget = newRock
                                        MiningState.isAtRock = false
                                        MiningState.lastMineTime = 0
                                        MiningState.lastMaintenanceHit = currentTime
                                        
                                        local initialHP = Utils.getRockHealth(newRock)
                                        State.initialRockHealth = initialHP
                                        print(string.format("[RARE ORE] Initial rock HP: %.2f", initialHP or 0))
                                        
                                        lastTweenTime = currentTime
                                        MiningFunctions.tweenToRock(newRock, false)
                                        
                                        MiningState.rockTypeIndex = MiningState.rockTypeIndex + 1
                                        if MiningState.rockTypeIndex > #State.selectedRockTypes then
                                            MiningState.rockTypeIndex = 1
                                        end
                                    else
                                        print("[RARE ORE] ⚠️ No other rocks available right now, will retry...")
                                        lastSearchTime = 0
                                    end
                                    
                                    return
                                end
                            end
                        end
                    end
                end
                
            else
                if currentTime - lastSearchTime >= SEARCH_COOLDOWN then
                    lastSearchTime = currentTime
                    
                    MiningState.currentTarget = nil
                    MiningState.isAtRock = false
                    MiningState.oreDetected = false
                    MiningState.shouldMineOut = false
                    MiningState.stuckCount = 0
                    
                    print("[RARE ORE] 🔍 Searching for new rock...")
                    
                    pcall(function()
                        MiningFunctions.detectPickaxe()
                    end)
                    
                    local newRock = MiningFunctions.findNextRock()
                    
                    if newRock then
                        print("[RARE ORE] ✅ Found new rock!")
                        MiningState.currentTarget = newRock
                        MiningState.isAtRock = false
                        MiningState.lastMineTime = 0
                        MiningState.lastMaintenanceHit = currentTime
                        MiningState.rockNotFoundCount = 0
                        
                        local initialHP = Utils.getRockHealth(newRock)
                        State.initialRockHealth = initialHP
                        print(string.format("[RARE ORE] Initial rock HP: %.2f", initialHP or 0))
                        
                        lastTweenTime = currentTime
                        MiningFunctions.tweenToRock(newRock, false)
                        
                        pcall(function()
                            MiningFunctions.updateRockCam(newRock)
                        end)

                        MiningState.rockTypeIndex = MiningState.rockTypeIndex + 1
                        if MiningState.rockTypeIndex > #State.selectedRockTypes then
                            MiningState.rockTypeIndex = 1
                        end
                    else
                        MiningState.rockNotFoundCount = MiningState.rockNotFoundCount + 1
                        
                        if MiningState.rockNotFoundCount >= MiningState.MAX_NOT_FOUND then
                            Utils.notify("Rare Ore Detection", "No rocks found, stopping", 3)
                            State.rareOreDetectionEnabled = false
                            MiningFunctions.stopRareOreDetection()
                        end
                    end
                end
            end
        end)
        
        if not success then
            warn("[Rare Ore Detection Error]:", err)
        end
    end)
end

function MiningFunctions.stopRareOreDetection()
    State.rareOreDetectionEnabled = false
    
    MiningFunctions.cancelCurrentTween()
    
    MiningState.rareOreConnection = Utils.cleanupConnection(MiningState.rareOreConnection)
    MiningState.noclipConnection = Utils.cleanupConnection(MiningState.noclipConnection)
    
    MiningState.currentTarget = nil
    MiningState.isAtRock = false
    MiningState.oreDetected = false
    MiningState.shouldMineOut = false
    MiningState.stuckCount = 0
    MiningState.lastPosition = nil
    MiningState.tweenStartTime = 0
    State.initialRockHealth = nil
    
    if State.rockCamEnabled then
        MiningFunctions.disableRockCam()
    end
end
function MiningFunctions.startTargetingLoop()
    MiningState.targetConnection = Utils.cleanupConnection(MiningState.targetConnection)
    
    local lastSearchTime = 0
    local lastTweenTime = 0
    local SEARCH_COOLDOWN = 1.0
    local RETWEEN_INTERVAL = 0.3
    local STUCK_CHECK_INTERVAL = 0.5
    local lastStuckCheck = 0
    -- REMOVED: errorCount and MAX_ERRORS
    
    MiningState.targetConnection = RunService.Heartbeat:Connect(function()
        if not State.miningEnabled then return end
        
        -- REMOVED: errorCount >= MAX_ERRORS check
        
        local success, err = pcall(function()
            local target = MiningState.currentTarget
            local currentTime = tick()
            
            -- REMOVED: Desync check block
            
            if currentTime - lastStuckCheck >= STUCK_CHECK_INTERVAL then
                lastStuckCheck = currentTime
                
                if target and target.Parent and not MiningState.isAtRock then
                    local isStuck = MiningFunctions.checkIfStuck()
                    local isTimedOut = MiningFunctions.checkTweenTimeout()
                    
                    if isStuck or isTimedOut then
                        print("[MINING] 🔧 Stuck or timed out, recovering...")
                        local newRock = MiningFunctions.handleStuckRecovery(target)
                        
                        if newRock then
                            MiningState.currentTarget = newRock
                            MiningState.rockNotFoundCount = 0
                            -- REMOVED: errorCount = 0
                            
                            lastTweenTime = currentTime
                            lastSearchTime = currentTime
                            MiningFunctions.tweenToRock(newRock, true)
                            
                            MiningState.rockTypeIndex = MiningState.rockTypeIndex + 1
                            if MiningState.rockTypeIndex > #State.selectedRockTypes then
                                MiningState.rockTypeIndex = 1
                            end
                        else
                            MiningState.currentTarget = nil
                            lastSearchTime = 0
                        end
                        return
                    end
                end
            end
            
            if target and target.Parent then
                local health = Utils.getRockHealth(target)
                
                if health and health <= 0 then
                    MiningState.currentTarget = nil
                    MiningState.isAtRock = false
                    MiningState.isMining = false
                    MiningState.stuckCount = 0
                    
                    pcall(function()
                        MiningFunctions.detectPickaxe()
                    end)
                    
                    local newRock = MiningFunctions.findNextRock()
                    
                    if newRock then
                        print("[MINING] ⚡ Instantly switching to new alive rock!")
                        MiningState.currentTarget = newRock
                        MiningState.rockNotFoundCount = 0
                        MiningState.isAtRock = false
                        MiningState.isMining = false
                        MiningState.lastRockHealth = nil
                        MiningState.noProgressCount = 0
                        -- REMOVED: errorCount = 0
                        
                        lastTweenTime = currentTime
                        lastSearchTime = currentTime
                        MiningFunctions.tweenToRock(newRock, false)
                        
                        MiningState.rockTypeIndex = MiningState.rockTypeIndex + 1
                        if MiningState.rockTypeIndex > #State.selectedRockTypes then
                            MiningState.rockTypeIndex = 1
                        end
                    else
                        print("[MINING] ❌ No alive rocks found!")
                        MiningState.rockNotFoundCount = MiningState.rockNotFoundCount + 1
                        lastSearchTime = 0
                        
                        if MiningState.rockNotFoundCount >= MiningState.MAX_NOT_FOUND then
                            Utils.notify("Mining", "No rocks found, stopping", 3)
                            State.miningEnabled = false
                            MiningFunctions.stopMining()
                        end
                    end
                    
                    return
                end
                
                local currentDistance = MiningFunctions.getDistanceToRock(target)
                if currentDistance <= MiningState.arrivalDistance then
                    if not MiningState.isAtRock then
                        print(string.format("[MINING] ✅ Arrived at rock! (Distance: %.2f)", currentDistance))
                    end
                    MiningState.isAtRock = true
                    MiningState.stuckCount = 0
                end

                if MiningState.isAtRock then
                    if not MiningState.isMining then
                        MiningState.isMining = true
                        MiningState.lastRockHealth = nil
                        MiningState.lastHealthCheckTime = currentTime
                        print("[MINING] ⛏️ Started mining rock!")
                    end
                    
                    local makingProgress = MiningFunctions.checkMiningProgress(target)
                    if not makingProgress then
                        print("[MINING] 🔧 Not hitting rock properly, repositioning...")
                        MiningFunctions.repositionAtRock(target)
                        task.wait(0.2)
                    end
                    
                    MiningFunctions.mineRock(target)
                end
                
                if not MiningState.isAtRock and currentTime - lastTweenTime >= RETWEEN_INTERVAL then
                    lastTweenTime = currentTime
                    print("[MINING] 🔄 Re-tweening to rock...")
                    MiningFunctions.tweenToRock(target, false)
                end
                
                pcall(function()
                    MiningFunctions.updateRockCam(target)
                end)

            else
                if currentTime - lastSearchTime >= SEARCH_COOLDOWN then
                    lastSearchTime = currentTime
                    
                    MiningState.currentTarget = nil
                    MiningState.isAtRock = false
                    MiningState.isMining = false
                    MiningState.stuckCount = 0
                    
                    print("[MINING] 🔍 Searching for new rock...")
                    
                    pcall(function()
                        MiningFunctions.detectPickaxe()
                    end)
                    
                    local newRock = MiningFunctions.findNextRock()
                    
                    if newRock then
                        print("[MINING] ✅ Found new rock! Tweening to it...")
                        MiningState.currentTarget = newRock
                        MiningState.rockNotFoundCount = 0
                        MiningState.isAtRock = false
                        MiningState.isMining = false
                        MiningState.lastRockHealth = nil
                        MiningState.noProgressCount = 0
                        -- REMOVED: errorCount = 0
                        
                        lastTweenTime = currentTime
                        MiningFunctions.tweenToRock(newRock, false)
                        
                        pcall(function()
                            MiningFunctions.updateRockCam(newRock)
                        end)

                        MiningState.rockTypeIndex = MiningState.rockTypeIndex + 1
                        if MiningState.rockTypeIndex > #State.selectedRockTypes then
                            MiningState.rockTypeIndex = 1
                        end
                    else
                        MiningState.rockNotFoundCount = MiningState.rockNotFoundCount + 1
                        
                        if MiningState.rockNotFoundCount >= MiningState.MAX_NOT_FOUND then
                            Utils.notify("Mining", "No rocks found, stopping", 3)
                            State.miningEnabled = false
                            MiningFunctions.stopMining()
                        end
                    end
                end
            end
        end)
        
        if not success then
            -- CHANGED: Just warn, don't count errors or stop
            warn("[Mining Error]:", err)
        end
    end)
end

function MiningFunctions.startMining()
    if not State.selectedRockTypes or #State.selectedRockTypes == 0 then
        Utils.notify("Mining Error", "No rock types selected!", 3)
        State.miningEnabled = false
        return
    end
    
    if not State.selectedLocation then
        Utils.notify("Mining Error", "No location selected!", 3)
        State.miningEnabled = false
        return
    end
    
    MiningState.currentTarget = nil
    MiningState.isAtRock = false
    MiningState.isMining = false
    MiningState.rockTypeIndex = 1
    MiningState.rockNotFoundCount = 0
    MiningState.lastTweenTime = 0
    MiningState.stuckCount = 0
    MiningState.lastPosition = nil
    MiningState.tweenStartTime = 0
    
    pcall(function()
        MiningFunctions.detectPickaxe()
    end)
    
    pcall(function()
        MiningFunctions.enableNoclip()
    end)
    
    MiningFunctions.startTargetingLoop()
    
    Utils.notify("Mining", "Started! Searching for rocks...", 2)
end

function MiningFunctions.stopMining()
    State.miningEnabled = false
    
    MiningFunctions.cancelCurrentTween()
    
    MiningState.targetConnection = Utils.cleanupConnection(MiningState.targetConnection)
    MiningState.noclipConnection = Utils.cleanupConnection(MiningState.noclipConnection)
    
    MiningState.currentTarget = nil
    MiningState.isAtRock = false
    MiningState.isMining = false
    MiningState.stuckCount = 0
    MiningState.lastPosition = nil
    MiningState.tweenStartTime = 0
    State.currentTargetRock = nil
    State.currentTargetOre = nil
    
    if State.rockCamEnabled then
        MiningFunctions.disableRockCam()
    end
    
    print("[MINING] 🛑 Mining fully stopped and cleaned up")
end

function MiningFunctions.enableRockCam()
    State.rockCamEnabled = true
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Scriptable
    Utils.notify("Rock Cam", "Enabled - Viewing from above!", 2)
end

function MiningFunctions.disableRockCam()
    State.rockCamEnabled = false
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Custom
    Utils.notify("Rock Cam", "Disabled - Camera restored", 2)
end

function MiningFunctions.updateRockCam(rock)
    if not State.rockCamEnabled then return end
    if not rock or not rock.Parent then return end
    
    local camera = workspace.CurrentCamera
    local rockPos = rock.Position
    local camPos = rockPos + Vector3.new(0, State.rockCamHeight, 0)
    
    camera.CFrame = CFrame.new(camPos, rockPos)
end

local MonsterFunctions = {}

local MonsterState = {
    targetConnection = nil,
    attackConnection = nil,
    noclipConnection = nil,
    blockConnection = nil,
    currentTarget = nil,
    currentTween = nil,
    currentTweenId = nil,
    isAtMonster = false,
    previousAttackStates = {},
    ATTACK_COOLDOWN = 0.1,
    lastAttackTime = 0,
    lastTweenTime = 0,
    lastTargetPosition = nil,
    
    lastPosition = nil,
    lastPositionTime = 0,
    stuckCount = 0,
    stuckTimeout = 3,
    stuckThreshold = 2,
    arrivalDistance = 12,
    tweenStartTime = 0,
    tweenTimeout = 10,
    problematicMonsters = {},
    PROBLEMATIC_MONSTER_COOLDOWN = 60
}

function MonsterFunctions.getPlayerNameFromClaim(claimValue)
    if not claimValue then return nil end
    if typeof(claimValue) == "Instance" then
        if claimValue:IsA("Player") then return claimValue.Name end
        if claimValue:IsA("Model") then return claimValue.Name end
        return claimValue.Name
    end
    return nil
end

function MonsterFunctions.isMonsterClaimedByOther(monster)
    if not monster or not monster.Parent then return false end
    local status = monster:FindFirstChild("Status")
    if not status or not status.Parent then return false end
    local damageDone = status:FindFirstChild("DamageDone")
    if not damageDone or not damageDone.Parent then return false end
    local claimName = MonsterFunctions.getPlayerNameFromClaim(damageDone.Value)
    if not claimName or claimName == "" then return false end
    return claimName ~= LocalPlayer.Name
end

function MonsterFunctions.isMonsterClaimedByUs(monster)
    if not monster or not monster.Parent then return false end
    local status = monster:FindFirstChild("Status")
    if not status or not status.Parent then return false end
    local damageDone = status:FindFirstChild("DamageDone")
    if not damageDone or not damageDone.Parent then return false end
    local claimName = MonsterFunctions.getPlayerNameFromClaim(damageDone.Value)
    return claimName == LocalPlayer.Name
end

function MonsterFunctions.equipWeapon()
    local char = Utils.getCharacter()
    if not char then return false end
    
    local humanoid = Utils.getHumanoid()
    if not humanoid then return false end
    
    local equippedTool = char:FindFirstChildWhichIsA("Tool")
    if equippedTool and equippedTool.Name == "Weapon" then
        return true
    end
    
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not backpack then return false end
    
    local weapon = backpack:FindFirstChild("Weapon")
    if not weapon or not weapon:IsA("Tool") then
        return false
    end
    
    humanoid:EquipTool(weapon)
    task.wait(0.2)
    
    equippedTool = char:FindFirstChildWhichIsA("Tool")
    if equippedTool and equippedTool.Name == "Weapon" then
        print("[MONSTER] ⚔️ Weapon equipped successfully!")
        return true
    end
    
    return false
end

function MonsterFunctions.activateWeapon()
    if State.isBlocking then return end
    
    local currentTime = tick()
    if currentTime - MonsterState.lastAttackTime < MonsterState.ATTACK_COOLDOWN then
        return
    end
    
    local char = Utils.getCharacter()
    if not char then return end
    
    local weapon = char:FindFirstChild("Weapon")
    if not weapon or not weapon:IsA("Tool") then
        MonsterFunctions.equipWeapon()
        return
    end
    
    pcall(function()
        ToolActivatedRemote:InvokeServer(weapon.Name, false)
    end)
    
    MonsterState.lastAttackTime = currentTime
end

function MonsterFunctions.faceMonster(monster)
    if not monster or not monster.Parent then return false end
    
    if MonsterState.currentTween then
        return false
    end
    
    local hrp = Utils.getHumanoidRootPart()
    if not hrp or not hrp.Parent then return false end
    
    local monsterPos = MonsterFunctions.getMonsterPosition(monster)
    if not monsterPos then return false end
    
    local currentPos = hrp.Position
    local direction = (monsterPos - currentPos)
    
    if direction.Magnitude < 1 then return false end
    
    local lookVector = direction.Unit
    local newCFrame = CFrame.new(currentPos, currentPos + Vector3.new(lookVector.X, 0, lookVector.Z))
    
    hrp.CFrame = newCFrame
    return true
end
function MonsterFunctions.getDistanceToMonster(monster)
    if not monster or not monster.Parent then return math.huge end
    local hrp = Utils.getHumanoidRootPart()
    if not hrp or not hrp.Parent then return math.huge end
    local monsterPart = monster:FindFirstChild("HumanoidRootPart")
    if not monsterPart or not monsterPart.Parent then
        monsterPart = monster.PrimaryPart
    end
    if not monsterPart or not monsterPart.Parent then
        monsterPart = monster:FindFirstChildWhichIsA("BasePart")
    end
    if not monsterPart or not monsterPart.Parent then return math.huge end
    return (hrp.Position - monsterPart.Position).Magnitude
end

function MonsterFunctions.getMonsterPosition(monster)
    if not monster or not monster.Parent then return nil end
    
    local hrp = monster:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:IsA("BasePart") and hrp.Parent then
        return hrp.Position
    end
    
    if monster.PrimaryPart and monster.PrimaryPart:IsA("BasePart") and monster.PrimaryPart.Parent then
        return monster.PrimaryPart.Position
    end
    
    local part = monster:FindFirstChildWhichIsA("BasePart")
    if part and part.Parent then
        return part.Position
    end
    
    return nil
end

function MonsterFunctions.isMonsterAttacking(monster)
    if not monster or not monster.Parent then return false end
    local status = monster:FindFirstChild("Status")
    if not status or not status.Parent then return false end
    local attacking = status:FindFirstChild("Attacking")
    if not attacking or not attacking.Parent then return false end
    
    local value = attacking.Value
    local isAttacking = false
    
    if type(value) == "boolean" then
        isAttacking = value
    elseif type(value) == "number" then
        isAttacking = value > 0
    elseif type(value) == "string" then
        isAttacking = value:lower() == "true" or value == "1"
    elseif typeof(value) == "Instance" then
        isAttacking = value ~= nil
    else
        isAttacking = value ~= nil and value ~= false and value ~= 0
    end
    
    return isAttacking
end

function MonsterFunctions.isMonsterProblematic(monster)
    if not monster then return false end
    local currentTime = tick()
    local timestamp = MonsterState.problematicMonsters[monster]
    if timestamp then
        if currentTime - timestamp < MonsterState.PROBLEMATIC_MONSTER_COOLDOWN then
            return true
        else
            MonsterState.problematicMonsters[monster] = nil
        end
    end
    return false
end

function MonsterFunctions.markMonsterAsProblematic(monster)
    if monster then
        MonsterState.problematicMonsters[monster] = tick()
        print(string.format("[MONSTER] ⚠️ Marked monster as problematic for %d seconds", MonsterState.PROBLEMATIC_MONSTER_COOLDOWN))
    end
end

function MonsterFunctions.findNextMonster(excludeMonster)
    local success, result = pcall(function()
        if #State.selectedMonsters == 0 then return nil end
        
        local living = workspace:FindFirstChild("Living")
        if not living then return nil end
        
        local hrp = Utils.getHumanoidRootPart()
        local myPos = hrp and hrp.Position or Vector3.new(0, 0, 0)
        
        local candidates = {}
        local skippedDeadMonsters = 0
        local currentTime = tick()
        
        for monster, timestamp in pairs(MonsterState.problematicMonsters) do
            if currentTime - timestamp > MonsterState.PROBLEMATIC_MONSTER_COOLDOWN then
                MonsterState.problematicMonsters[monster] = nil
            end
        end
        
        for _, monsterType in ipairs(State.selectedMonsters) do
            for _, entity in pairs(living:GetChildren()) do
                if entity.Name:find("^" .. monsterType) and entity ~= excludeMonster then
                    if not MonsterFunctions.isMonsterClaimedByOther(entity) and not MonsterFunctions.isMonsterProblematic(entity) then
                        -- Validate monster has a position before adding to candidates
                        local pos = MonsterFunctions.getMonsterPosition(entity)
                        if pos then
                            local hp = Utils.getMonsterHealth(entity)
                            if hp and hp <= 0 then
                                skippedDeadMonsters = skippedDeadMonsters + 1
                            elseif not hp or hp > 0 then
                                local dist = (pos - myPos).Magnitude
                                table.insert(candidates, {monster = entity, distance = dist})
                            end
                        else
                            -- Skip monsters without valid position (no HumanoidRootPart)
                            print(string.format("[MONSTER] ⚠️ Skipping %s - no valid position/HRP", entity.Name))
                        end
                    end
                end
            end
        end
        
        if skippedDeadMonsters > 0 then
            print(string.format("[MONSTER] 🚫 Skipped %d dead monster(s) with 0 HP", skippedDeadMonsters))
        end
        
        if #candidates > 0 then
            table.sort(candidates, function(a, b) return a.distance < b.distance end)
            print(string.format("[MONSTER] ✅ Found alive %s with HP check passed", candidates[1].monster.Name))
            return candidates[1].monster
        end
        
        return nil
    end)
    
    if success then
        return result
    else
        warn("[findNextMonster Error]:", result)
        return nil
    end
end

function MonsterFunctions.countAvailableMonsters()
    local living = workspace:FindFirstChild("Living")
    if not living then return 0 end
    
    local count = 0
    for _, entity in pairs(living:GetChildren()) do
        for _, monsterType in ipairs(State.selectedMonsters) do
            if entity.Name:find("^" .. monsterType) then
                if not MonsterFunctions.isMonsterClaimedByOther(entity) then
                    count = count + 1
                    break
                end
            end
        end
    end
    return count
end

function MonsterFunctions.startBlock()
    if State.isBlocking then return end
    
    local success = pcall(function()
        ReplicatedStorage:WaitForChild("Shared", 1)
            :WaitForChild("Packages", 1):WaitForChild("Knit", 1)
            :WaitForChild("Services", 1):WaitForChild("ToolService", 1)
            :WaitForChild("RF", 1):WaitForChild("StartBlock", 1)
            :InvokeServer()
    end)
    
    if success then
        State.isBlocking = true
        print("[BLOCK] 🛡️ Shield raised!")
    else
        warn("[BLOCK] ❌ Failed to start blocking")
    end
end

function MonsterFunctions.stopBlock()
    if not State.isBlocking then return end
    
    pcall(function()
        ReplicatedStorage:WaitForChild("Shared", 1)     
            :WaitForChild("Packages", 1):WaitForChild("Knit", 1)
            :WaitForChild("Services", 1):WaitForChild("ToolService", 1)
            :WaitForChild("RF", 1):WaitForChild("StopBlock", 1)
            :InvokeServer()
    end)
    
    State.isBlocking = false
    print("[BLOCK] 🛡️ Shield lowered")
end

function MonsterFunctions.enableAutoBlock()
    MonsterState.blockConnection = Utils.cleanupConnection(MonsterState.blockConnection)
    
    local BLOCK_DISTANCE = 25
    local BLOCK_DURATION = 0.8
    local BLOCK_COOLDOWN = 0.3
    local lastBlockTime = 0
    local blockEndTime = 0
    
    MonsterState.blockConnection = RunService.Heartbeat:Connect(function()
        local shouldBlock = (State.monsterFarmEnabled and State.monsterBlockingEnabled) or State.autoBlockEnabled
        if not shouldBlock then
            if State.isBlocking then 
                MonsterFunctions.stopBlock()
            end
            return
        end
        
        local currentTime = tick()
        
        if State.isBlocking and currentTime >= blockEndTime then
            MonsterFunctions.stopBlock()
        end
        
        if currentTime - lastBlockTime < BLOCK_COOLDOWN then
            return
        end
        
        local target = MonsterState.currentTarget
        if not target or not target.Parent then 
            return 
        end
        
        local hrp = Utils.getHumanoidRootPart()
        if not hrp then return end
        
        local monsterPos = MonsterFunctions.getMonsterPosition(target)
        if not monsterPos then return end
        
        local distance = (hrp.Position - monsterPos).Magnitude
        
        if distance <= BLOCK_DISTANCE then
            local status = target:FindFirstChild("Status")
            if status then
                local attacking = status:FindFirstChild("Attacking")
                if attacking and attacking.Value then
                    if not State.isBlocking then
                        MonsterFunctions.startBlock()
                        lastBlockTime = currentTime
                        blockEndTime = currentTime + BLOCK_DURATION
                        print(string.format("[AUTO BLOCK] 🛡️ Blocking %s's attack! (Distance: %.1f studs)", target.Name, distance))
                    end
                end
            end
        end
    end)
end

function MonsterFunctions.disableAutoBlock()
    MonsterState.blockConnection = Utils.cleanupConnection(MonsterState.blockConnection)
    if State.isBlocking then MonsterFunctions.stopBlock() end
    print("[AUTO BLOCK] 🚫 Auto-block system disabled")
end

function MonsterFunctions.enableNoclip()
    MonsterState.noclipConnection = Utils.cleanupConnection(MonsterState.noclipConnection)
    MonsterState.noclipConnection = RunService.Stepped:Connect(function()
        if not State.monsterFarmEnabled then return end
        local character = Utils.getCharacter()
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end
function MonsterFunctions.cancelCurrentTween()
    if MonsterState.currentTween then
        MonsterState.currentTweenId = nil
        pcall(function()
            MonsterState.currentTween:Cancel()
        end)
        MonsterState.currentTween = nil
    end
    
    -- Wrap in pcall to prevent errors if hrp is nil
    pcall(function()
        local hrp = Utils.getHumanoidRootPart()
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

function MonsterFunctions.checkIfStuck()
    local hrp = Utils.getHumanoidRootPart()
    if not hrp then return false end
    
    local currentTime = tick()
    local currentPos = hrp.Position
    
    if MonsterState.lastPosition then
        local timeSinceLastCheck = currentTime - MonsterState.lastPositionTime
        
        if timeSinceLastCheck >= 0.5 then
            local distanceMoved = (currentPos - MonsterState.lastPosition).Magnitude
            
            if distanceMoved < MonsterState.stuckThreshold and not MonsterState.isAtMonster then
                MonsterState.stuckCount = MonsterState.stuckCount + 1
                
                local totalStuckTime = MonsterState.stuckCount * 0.5
                
                if totalStuckTime >= MonsterState.stuckTimeout then
                    return true
                end
            else
                MonsterState.stuckCount = 0
            end
            
            MonsterState.lastPosition = currentPos
            MonsterState.lastPositionTime = currentTime
        end
    else
        MonsterState.lastPosition = currentPos
        MonsterState.lastPositionTime = currentTime
    end
    
    return false
end

function MonsterFunctions.handleStuckRecovery(monster)
    print("[MONSTER] 🔄 Attempting stuck recovery...")
    
    MonsterFunctions.cancelCurrentTween()
    
    if monster then
        MonsterFunctions.markMonsterAsProblematic(monster)
    end
    
    MonsterState.stuckCount = 0
    MonsterState.lastPosition = nil
    MonsterState.lastPositionTime = 0
    MonsterState.tweenStartTime = 0
    MonsterState.isAtMonster = false
    
    local hrp = Utils.getHumanoidRootPart()
    if hrp then
        local currentPos = hrp.Position
        local escapePos = currentPos + Vector3.new(0, 15, 0)
        hrp.CFrame = CFrame.new(escapePos)
        task.wait(0.3)
    end
    
    local newMonster = MonsterFunctions.findNextMonster(monster)
    return newMonster
end

function MonsterFunctions.teleportToMonster(monster)
    local hrp = Utils.getHumanoidRootPart()
    if not hrp or not hrp.Parent or not monster or not monster.Parent then return false end
    
    local monsterPos = MonsterFunctions.getMonsterPosition(monster)
    if not monsterPos then
        print(string.format("[MONSTER] ⚠️ Cannot teleport to %s - no valid position/HRP", monster.Name))
        return false
    end
    
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    local targetPos = monsterPos
    hrp.CFrame = CFrame.new(targetPos)
    
    MonsterState.isAtMonster = true
    print("[MONSTER] ⚡ Instant teleport to monster center!")
    return true
end

function MonsterFunctions.tweenToMonster(monster, useInstantTeleport)
    local hrp = Utils.getHumanoidRootPart()
    if not hrp or not monster or not monster.Parent then return false end
    
    if not State.monsterFarmEnabled then
        print("[MONSTER] ⚠️ Monster farm disabled, aborting tween")
        return false
    end
    
    local monsterPos = MonsterFunctions.getMonsterPosition(monster)
    if not monsterPos then
        print(string.format("[MONSTER] ⚠️ Cannot tween to %s - no valid position/HRP", monster.Name))
        return false
    end

    -- REMOVED: High velocity desync check block

    MonsterFunctions.cancelCurrentTween()
    
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    
    MonsterState.stuckCount = 0
    MonsterState.lastPosition = hrp.Position
    MonsterState.lastPositionTime = tick()
    MonsterState.tweenStartTime = tick()

    local targetPos = monsterPos
    local currentPos = hrp.Position
    local distance = (targetPos - currentPos).Magnitude
    
    if distance <= MonsterState.arrivalDistance then
        hrp.CFrame = CFrame.new(targetPos)
        MonsterState.isAtMonster = true
        MonsterState.tweenStartTime = 0
        return true
    end
    
    if useInstantTeleport or distance < 20 then
        return MonsterFunctions.teleportToMonster(monster)
    end
    
    local isAtSpawn = Utils.isAtSpawnLocation()
    local waypoints = {}
    
    if isAtSpawn then
        print("[MONSTER] 🚀 At spawn location, using escape waypoints!")
        waypoints = Utils.getSpawnEscapeWaypoints(targetPos)
        table.insert(waypoints, targetPos)
    else
        table.insert(waypoints, targetPos)
    end
    
    local tweenId = tick()
    MonsterState.currentTweenId = tweenId
    
    local function tweenToNextWaypoint(waypointIndex)
        if not State.monsterFarmEnabled then
            print("[MONSTER] ⚠️ Monster farm disabled during tween, stopping")
            return
        end
        
        if MonsterState.currentTweenId ~= tweenId then
            return
        end
        
        if waypointIndex > #waypoints then
            MonsterState.isAtMonster = true
            MonsterState.tweenStartTime = 0
            print("[MONSTER] ✅ Completed all waypoints, arrived at monster!")
            return
        end
        
        local currentHrp = Utils.getHumanoidRootPart()
        if not currentHrp then return end
        
        -- NEW: Check for flinging mid-tween
        local velocity = currentHrp.AssemblyLinearVelocity.Magnitude
        if velocity > 100 then
            print(string.format("[MONSTER] ⚠️ FLING DETECTED mid-tween! Velocity: %.2f, aborting...", velocity))
            currentHrp.AssemblyLinearVelocity = Vector3.zero
            currentHrp.AssemblyAngularVelocity = Vector3.zero
            MonsterState.currentTweenId = nil -- Invalidate this tween
            MonsterState.isAtMonster = false
            return
        end
        
        currentHrp.AssemblyLinearVelocity = Vector3.zero
        currentHrp.AssemblyAngularVelocity = Vector3.zero
        
        local nextWaypoint = waypoints[waypointIndex]
        local dist = (nextWaypoint - currentHrp.Position).Magnitude
        local duration = math.clamp(dist / 50, 0.1, MonsterState.tweenTimeout - 1)
        
        local tweenInfo = TweenInfo.new(
            duration,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )
        
        MonsterState.currentTween = TweenService:Create(currentHrp, tweenInfo, {CFrame = CFrame.new(nextWaypoint)})
        
        MonsterState.currentTween.Completed:Connect(function(playbackState)
            if not State.monsterFarmEnabled then
                return
            end
            
            if playbackState == Enum.PlaybackState.Completed and MonsterState.currentTweenId == tweenId then
                -- NEW: Reset velocity after each waypoint completion
                local hrpCheck = Utils.getHumanoidRootPart()
                if hrpCheck then
                    hrpCheck.AssemblyLinearVelocity = Vector3.zero
                    hrpCheck.AssemblyAngularVelocity = Vector3.zero
                end
                
                print(string.format("[MONSTER] ✅ Reached waypoint %d/%d", waypointIndex, #waypoints))
                task.wait(0.1)
                tweenToNextWaypoint(waypointIndex + 1)
            end
        end)
        
        MonsterState.currentTween:Play()
    end
    
    tweenToNextWaypoint(1)
    
    return true
end
function MonsterFunctions.startTargetingLoop()
    MonsterState.targetConnection = Utils.cleanupConnection(MonsterState.targetConnection)
    
    local lastSearchTime = 0
    local lastTweenTime = 0
    local lastMonsterPos = nil
    local lastWeaponCheck = 0
    local SEARCH_COOLDOWN = 1.0
    local RETWEEN_INTERVAL = 1
    local POSITION_CHANGE_THRESHOLD = 8
    local ATTACK_RANGE = 15
    local WEAPON_CHECK_INTERVAL = 5.0
    local STUCK_CHECK_INTERVAL = 0.5
    local lastStuckCheck = 0
    -- REMOVED: errorCount and MAX_ERRORS
    
    MonsterState.targetConnection = RunService.Heartbeat:Connect(function()
        if not State.monsterFarmEnabled then return end
        
        -- REMOVED: errorCount >= MAX_ERRORS check
        
        local success, err = pcall(function()
            local currentTime = tick()
            
            -- REMOVED: Desync check block
            
            if currentTime - lastWeaponCheck >= WEAPON_CHECK_INTERVAL then
                lastWeaponCheck = currentTime
                
                local char = Utils.getCharacter()
                if char then
                    local equippedTool = char:FindFirstChildWhichIsA("Tool")
                    if not equippedTool or equippedTool.Name ~= "Weapon" then
                        print("[MONSTER] ⚠️ Weapon not equipped, re-equipping...")
                        if not MonsterFunctions.equipWeapon() then
                            Utils.notify("Monster Farm", "Failed to equip weapon!", 3)
                            -- REMOVED: errorCount increment and return
                        end
                    end
                end
            end
            
            local target = MonsterState.currentTarget
            
            if currentTime - lastStuckCheck >= STUCK_CHECK_INTERVAL then
                lastStuckCheck = currentTime
                
                if target and target.Parent and not MonsterState.isAtMonster then
                    local isStuck = MonsterFunctions.checkIfStuck()
                    local isTimedOut = MonsterState.tweenStartTime > 0 and (currentTime - MonsterState.tweenStartTime > MonsterState.tweenTimeout)
                    
                    if isStuck or isTimedOut then
                        print("[MONSTER] 🔧 Stuck or timed out, recovering...")
                        local newMonster = MonsterFunctions.handleStuckRecovery(target)
                        
                        if newMonster then
                            MonsterState.currentTarget = newMonster
                            MonsterState.isAtMonster = false
                            -- REMOVED: errorCount = 0
                            
                            local newMonsterPos = MonsterFunctions.getMonsterPosition(newMonster)
                            lastMonsterPos = newMonsterPos
                            lastTweenTime = currentTime
                            lastSearchTime = currentTime
                            
                            MonsterFunctions.tweenToMonster(newMonster, true)
                        else
                            MonsterState.currentTarget = nil
                            lastSearchTime = 0
                        end
                        return
                    end
                end
            end
            
            if target and target.Parent then
                local monsterPos = MonsterFunctions.getMonsterPosition(target)
                
                if not monsterPos then
                    print(string.format("[MONSTER] ⚠️ Target %s has no valid position/HRP, finding new target...", target.Name))
                    MonsterState.currentTarget = nil
                    MonsterState.isAtMonster = false
                    MonsterState.stuckCount = 0
                    lastMonsterPos = nil
                    lastSearchTime = 0
                    return
                end
                
                local health = Utils.getMonsterHealth(target)
                
                if health and health <= 0 then
                    MonsterState.currentTarget = nil
                    MonsterState.isAtMonster = false
                    MonsterState.stuckCount = 0
                    lastMonsterPos = nil
                    
                    local newMonster = MonsterFunctions.findNextMonster(target)
                    
                    if newMonster then
                        print("[MONSTER] ⚡ Instantly switching to new alive monster!")
                        local newHealth = Utils.getMonsterHealth(newMonster)
                        if newHealth then
                            print(string.format("[MONSTER] 🎯 New target: %s (HP: %d)", newMonster.Name, newHealth))
                        end
                        MonsterState.currentTarget = newMonster
                        MonsterState.isAtMonster = false
                        -- REMOVED: errorCount = 0
                        
                        local newMonsterPos = MonsterFunctions.getMonsterPosition(newMonster)
                        lastMonsterPos = newMonsterPos
                        lastTweenTime = currentTime
                        lastSearchTime = currentTime
                        
                        MonsterFunctions.tweenToMonster(newMonster, false)
                    else
                        print("[MONSTER] ❌ No alive monsters found!")
                        lastSearchTime = 0
                    end
                    
                    return
                end
                
                if not monsterPos or MonsterFunctions.isMonsterClaimedByOther(target) then
                    MonsterState.currentTarget = nil
                    MonsterState.isAtMonster = false
                    MonsterState.stuckCount = 0
                    lastMonsterPos = nil
                    lastSearchTime = 0
                    return
                end
                
                local hrp = Utils.getHumanoidRootPart()
                if hrp then
                    local distToMonster = (hrp.Position - monsterPos).Magnitude
                    if distToMonster <= tonumber(MonsterState.arrivalDistance or 5) then
                        if not MonsterState.isAtMonster then
                            print(string.format("[MONSTER] ✅ Arrived at monster! (Distance: %.2f)", distToMonster))
                        end
                        MonsterState.isAtMonster = true
                        MonsterState.stuckCount = 0
                    elseif MonsterState.isAtMonster and distToMonster > tonumber(MonsterState.arrivalDistance or 5) + 5 then
                        print(string.format("[MONSTER] ⚠️ Monster moved away! (Distance: %.2f) Re-tweening...", distToMonster))
                        MonsterState.isAtMonster = false
                        lastTweenTime = currentTime - RETWEEN_INTERVAL
                    end
                end
                
                local monsterMoved = false
                if lastMonsterPos then
                    local moveDist = (monsterPos - lastMonsterPos).Magnitude
                    if moveDist >= POSITION_CHANGE_THRESHOLD then
                        monsterMoved = true
                    end
                end
                
                if (not MonsterState.isAtMonster and currentTime - lastTweenTime >= RETWEEN_INTERVAL) or monsterMoved then
                    lastTweenTime = currentTime
                    lastMonsterPos = monsterPos
                    MonsterState.isAtMonster = false
                    
                    MonsterFunctions.tweenToMonster(target, false)
                end
                
            else
                if currentTime - lastSearchTime >= SEARCH_COOLDOWN then
                    lastSearchTime = currentTime
                    
                    MonsterState.currentTarget = nil
                    MonsterState.isAtMonster = false
                    MonsterState.stuckCount = 0
                    lastMonsterPos = nil
                    
                    local availableCount = MonsterFunctions.countAvailableMonsters()
                    if availableCount == 0 then
                        if not State.waitingForRespawn then
                            State.waitingForRespawn = true
                            Utils.notify("Monster Farm", "Waiting for mobs to respawn...", 3)
                        end
                        return
                    end
                    
                    if State.waitingForRespawn then
                        State.waitingForRespawn = false
                        Utils.notify("Monster Farm", "Mobs respawned!", 2)
                    end
                    
                    local newMonster = MonsterFunctions.findNextMonster(nil)
                    if newMonster then
                        print("[MONSTER] ✅ Found new monster! Tweening to it...")
                        
                        local newHealth = Utils.getMonsterHealth(newMonster)
                        if newHealth then
                            print(string.format("[MONSTER] 🎯 Target: %s (HP: %d)", newMonster.Name, newHealth))
                        end
                        
                        MonsterState.currentTarget = newMonster
                        MonsterState.isAtMonster = false
                        -- REMOVED: errorCount = 0
                        
                        local monsterPos = MonsterFunctions.getMonsterPosition(newMonster)
                        lastMonsterPos = monsterPos
                        lastTweenTime = currentTime
                        
                        MonsterFunctions.tweenToMonster(newMonster, false)
                    end
                end
            end
        end)
        
        if not success then
            -- CHANGED: Just warn, don't count errors or stop
            warn("[Monster Farm Error]:", err)
        end
    end)
end

function MonsterFunctions.startAttackLoop()
    MonsterState.attackConnection = Utils.cleanupConnection(MonsterState.attackConnection)
    
    local ATTACK_RANGE = 15
    local lastHPPrint = 0
    local HP_PRINT_INTERVAL = 1.0
    local lastFaceTime = 0
    local FACE_INTERVAL = 0.2
    
    MonsterState.attackConnection = RunService.Heartbeat:Connect(function()
        if not State.monsterFarmEnabled then return end
        if State.isBlocking then return end
        if not MonsterState.currentTarget or not MonsterState.currentTarget.Parent then return end
        
        if MonsterState.isAtMonster then
            local hrp = Utils.getHumanoidRootPart()
            if hrp then
                local monsterPos = MonsterFunctions.getMonsterPosition(MonsterState.currentTarget)
                if monsterPos then
                    local dist = (hrp.Position - monsterPos).Magnitude
                    if dist <= ATTACK_RANGE then
                        local currentTime = tick()

                        if State.autoFaceMonster and not MonsterState.currentTween then
                            if currentTime - lastFaceTime >= FACE_INTERVAL then
                                lastFaceTime = currentTime
                                MonsterFunctions.faceMonster(MonsterState.currentTarget)
                            end
                        end
                        
                        MonsterFunctions.activateWeapon()
                        
                        if currentTime - lastHPPrint >= HP_PRINT_INTERVAL then
                            lastHPPrint = currentTime
                            local health = Utils.getMonsterHealth(MonsterState.currentTarget)
                            if health then
                            end
                        end
                    end
                end
            end
        end
    end)
end

function MonsterFunctions.startFarming()
    if not State.selectedMonsters or #State.selectedMonsters == 0 then
        Utils.notify("Monster Farm Error", "No monster types selected!", 3)
        State.monsterFarmEnabled = false
        return
    end
    
    if not MonsterFunctions.equipWeapon() then
        Utils.notify("Monster Farm Error", "No weapon found in backpack!", 5)
        State.monsterFarmEnabled = false
        return
    end
    
    task.wait(0.3)
    
    MonsterState.currentTarget = nil
    MonsterState.isAtMonster = false
    MonsterState.previousAttackStates = {}
    MonsterState.lastAttackTime = 0
    MonsterState.lastTweenTime = 0
    MonsterState.stuckCount = 0
    MonsterState.lastPosition = nil
    MonsterState.tweenStartTime = 0
    State.waitingForRespawn = false
    
    pcall(function()
        MonsterFunctions.enableNoclip()
    end)
    
    if State.monsterBlockingEnabled then
        pcall(function()
            MonsterFunctions.enableAutoBlock()
        end)
    end
    
    MonsterFunctions.startTargetingLoop()
    MonsterFunctions.startAttackLoop()
    
    Utils.notify("Monster Farm", "Started! Hunting monsters...", 2)
end

function MonsterFunctions.stopFarming()
    State.monsterFarmEnabled = false
    
    MonsterFunctions.cancelCurrentTween()
    
    MonsterState.targetConnection = Utils.cleanupConnection(MonsterState.targetConnection)
    MonsterState.attackConnection = Utils.cleanupConnection(MonsterState.attackConnection)
    MonsterState.noclipConnection = Utils.cleanupConnection(MonsterState.noclipConnection)
    
    MonsterFunctions.disableAutoBlock()
    
    MonsterState.currentTarget = nil
    MonsterState.isAtMonster = false
    MonsterState.lastTargetPosition = nil
    MonsterState.stuckCount = 0
    MonsterState.lastPosition = nil
    MonsterState.tweenStartTime = 0
    State.currentTargetMonster = nil
    State.waitingForRespawn = false
    
    print("[MONSTER] 🛑 Monster farming fully stopped and cleaned up")
end

do
    Tabs.Home:AddParagraph({
        Title = "Welcome to Jordon Hub!",
        Content = "La Forge"
    })
    
    Tabs.Home:AddSlider("WalkSpeed", {
        Title = "Walk Speed",
        Description = "Adjust your movement speed",
        Default = Constants.DEFAULT_WALKSPEED,
        Min = Constants.MIN_WALKSPEED,
        Max = Constants.MAX_WALKSPEED,
        Rounding = 0,
        Callback = function(value)
            if not PlayerFunctions.setWalkSpeed(value) then
                Utils.notify("Error", "Character not found!", 2)
            end
        end
    })
    
    Tabs.Home:AddInput("CustomWalkSpeed", {
        Title = "Custom Walk Speed",
        Placeholder = "Enter speed (1-500)",
        Numeric = true,
        Callback = function(value)
            local speed = tonumber(value)
            if speed then
                speed = math.clamp(speed, Constants.MIN_WALKSPEED, Constants.MAX_WALKSPEED)
                if PlayerFunctions.setWalkSpeed(speed) then
                    Utils.notify("Walk Speed", "Set to " .. speed, 2)
                end
            end
        end
    })
end

do
    Tabs.Ingame:AddSlider("JumpPower", {
        Title = "Jump Power",
        Description = "Adjust your jump height",
        Default = Constants.DEFAULT_JUMPPOWER,
        Min = Constants.MIN_JUMPPOWER,
        Max = Constants.MAX_JUMPPOWER,
        Rounding = 0,
        Callback = function(value)
            if not PlayerFunctions.setJumpPower(value) then
                Utils.notify("Error", "Character not found!", 2)
            end
        end
    })
    
    Tabs.Ingame:AddSlider("FlySpeed", {
        Title = "Fly Speed",
        Description = "Speed when flying",
        Default = 50,
        Min = 10,
        Max = 200,
        Rounding = 0,
        Callback = function(value)
            State.flySpeed = value
        end
    })
    
    Tabs.Ingame:AddToggle("Fly", {
        Title = "Fly",
        Description = "Use WASD + Space/Shift to fly",
        Default = false,
        Callback = function(enabled)
            if enabled then
                if PlayerFunctions.enableFly(function() return State.flySpeed end) then
                    Utils.notify("Fly", "Enabled! Use WASD + Space/Shift", 3)
                else
                    Utils.notify("Error", "Character not found!", 2)
                end
            else
                PlayerFunctions.disableFly()
                Utils.notify("Fly", "Disabled", 2)
            end
        end
    })
    
    Tabs.Ingame:AddToggle("PlayerESP", {
        Title = "Player ESP",
        Description = "Highlight all players",
        Default = false,
        Callback = function(enabled)
            if enabled then
                PlayerFunctions.enableESP()
                Utils.notify("ESP", "Player ESP enabled", 2)
            else
                PlayerFunctions.disableESP()
                Utils.notify("ESP", "Player ESP disabled", 2)
            end
        end
    })
    
    Tabs.Ingame:AddToggle("Noclip", {
        Title = "Noclip",
        Description = "Walk through walls",
        Default = false,
        Callback = function(enabled)
            if enabled then
                PlayerFunctions.enableNoclip()
                Utils.notify("Noclip", "Enabled - Walk through walls", 2)
            else
                PlayerFunctions.disableNoclip()
                Utils.notify("Noclip", "Disabled", 2)
            end
        end
    })
end

do
    Tabs.Mining:AddParagraph({
        Title = "Auto Mining",
        Content = "Configure and enable automatic mining with tween movement and noclip. Now tweens to CENTER of rocks!"
    })
    
    State.selectedRockTypes = {"Boulder"}
    State.selectedLocation = "All"
    
    Tabs.Mining:AddDropdown("RockTypes", {
        Title = "Rock Types",
        Description = "Select which rocks to mine",
        Values = RockTypes,
        Multi = true,
        Default = {"Boulder"},
        Callback = function(values)
            local newTypes = {}
            for value, enabled in pairs(values) do
                if enabled then
                    table.insert(newTypes, value)
                end
            end
            if #newTypes > 0 then
                State.selectedRockTypes = newTypes
            else
                State.selectedRockTypes = {"Boulder"}
                Utils.notify("Mining", "At least one rock type required, defaulting to Boulder", 3)
            end
        end
    })
    
    Tabs.Mining:AddDropdown("MiningLocation", {
        Title = "Location",
        Description = "Where to mine",
        Values = RockLocations,
        Default = "All",
        Callback = function(value)
            State.selectedLocation = value or "All"
        end
    })
    
    Tabs.Mining:AddSlider("MiningTweenSpeed", {
        Title = "Tween Speed",
        Description = "How fast to travel to rocks (studs/second)",
        Default = 80,
        Min = 30,
        Max = 200,
        Rounding = 0,
        Callback = function(value)
            State.miningTweenSpeed = value
        end
    })
    
    Tabs.Mining:AddSlider("ArrivalDistance", {
        Title = "Arrival Distance",
        Description = "Distance to consider 'arrived' at rock (studs)",
        Default = 5,
        Min = 3,
        Max = 15,
        Rounding = 1,
        Callback = function(value)
            MiningState.arrivalDistance = tonumber(value) or 5
        end
    })
    
    -- Tabs.Mining:AddToggle("GoblinCaveUnlocked", {
    --     Title = "Goblin Cave Unlocked",
    --     Description = "Enable if you've unlocked the Goblin Cave",
    --     Default = false,
    --     Callback = function(value)
    --         State.goblinCaveUnlocked = value
    --     end
    -- })
    
    Tabs.Mining:AddToggle("AutoMining", {
        Title = "Enable Auto Mining",
        Description = "Automatically mine selected rock types",
        Default = false,
        Callback = function(enabled)
            State.miningEnabled = enabled
            if enabled then
                MiningFunctions.startMining()
            else
                MiningFunctions.stopMining()
                Utils.notify("Mining", "Auto mining stopped", 2)
            end
        end
    })
    
    Tabs.Mining:AddButton({
        Title = "Stop All Mining",
        Description = "Emergency stop for all mining functions",
        Callback = function()
            State.miningEnabled = false
            State.indexFarmEnabled = false
            State.rareOreDetectionEnabled = false
            MiningFunctions.stopMining()
            MiningFunctions.stopRareOreDetection()
            Utils.notify("Mining", "All mining stopped", 2)
        end
    })
    
    Tabs.Mining:AddButton({
        Title = "Clear Problematic Rocks",
        Description = "Reset the list of rocks that caused getting stuck",
        Callback = function()
            MiningState.problematicRocks = {}
            Utils.notify("Mining", "Cleared problematic rocks list", 2)
        end
    })

    Tabs.Mining:AddToggle("RockCam", {
        Title = "Rock Cam",
        Description = "View mining from above the rock (switches with each rock)",
        Default = false,
        Callback = function(enabled)
            if enabled then
                MiningFunctions.enableRockCam()
            else
                MiningFunctions.disableRockCam()
            end
        end
    })

    Tabs.Mining:AddSection("Rare Ore Detection")

    Tabs.Mining:AddDropdown("RareOreTypes", {
        Title = "Target Rare Ores",
        Description = "Select which rare ores to search for",
        Values = RareOreTypes,
        Multi = true,
        Default = {},
        Callback = function(values)
            local newOres = {}
            for value, enabled in pairs(values) do
                if enabled then
                    table.insert(newOres, value)
                end
            end
            State.selectedRareOres = newOres
        end
    })
    
    Tabs.Mining:AddInput("DiscordWebhook", {
        Title = "Discord Webhook URL",
        Description = "Enter your Discord webhook URL",
        Default = State.discordWebhook or "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(value)
            State.discordWebhook = value
            if value ~= "" then
                Utils.notify("Discord", "Webhook URL saved", 2)
                if SaveManager.Config then
                    SaveManager.Config.DiscordWebhook = value
                    SaveManager:Save()
                end
            end
        end
    })
    
    Tabs.Mining:AddInput("DiscordUserID", {
        Title = "Discord User ID (for ping)",
        Description = "Your Discord user ID (optional)",
        Default = State.discordUserId or "",
        Placeholder = "123456789012345678",
        Numeric = true,
        Callback = function(value)
            State.discordUserId = value
            if value ~= "" then
                Utils.notify("Discord", "User ID saved", 2)
                if SaveManager.Config then
                    SaveManager.Config.DiscordUserID = value
                    SaveManager:Save()
                end
            end
        end
    })
    
    Tabs.Mining:AddToggle("StopOnDetection", {
        Title = "Preserve Rare Ore",
        Description = "ON: Stop mining when found (maintain every 20s) | OFF: Mine out entire rock",
        Default = false,
        Callback = function(enabled)
            State.stopMiningOnDetection = enabled
            if enabled then
                Utils.notify("Mode", "Will preserve rocks with rare ores", 2)
            else
                Utils.notify("Mode", "Will mine out rocks with rare ores", 2)
            end
        end
    })
    
    Tabs.Mining:AddToggle("RareOreFinder", {
        Title = "Enable Rare Ore Finder",
        Description = "Automatically search for rare ores in rocks",
        Default = false,
        Callback = function(enabled)
            State.rareOreDetectionEnabled = enabled
            
            if enabled then
                if #State.selectedRareOres == 0 then
                    Utils.notify("Rare Ore Finder", "Please select at least one rare ore!", 3)
                    State.rareOreDetectionEnabled = false
                    return
                end
                
                if State.discordWebhook == "" then
                    Utils.notify("Rare Ore Finder", "Warning: No Discord webhook configured", 3)
                end
                
                MiningFunctions.enableNoclip()
                
                MiningFunctions.startRareOreDetection()
                
                local mode = State.stopMiningOnDetection and "Preserve Mode" or "Mine Out Mode"
                Utils.notify("Rare Ore Finder", "Started! (" .. mode .. ")", 3)
            else
                MiningFunctions.stopRareOreDetection()
                Utils.notify("Rare Ore Finder", "Stopped", 2)
            end
        end
    })
    
    Tabs.Mining:AddButton({
        Title = "Test Discord Webhook",
        Description = "Send a test notification to Discord",
        Callback = function()
            if State.discordWebhook == "" then
                Utils.notify("Discord", "Please enter a webhook URL first!", 3)
                return
            end
            
            local testOre = State.selectedRareOres[1] or "Fireite"
            local testImage = RareOreData[testOre] or RareOreData["Fireite"]
            
            if MiningFunctions.sendDiscordWebhook(testOre .. " (Test)", testImage) then
                Utils.notify("Discord", "Test notification sent!", 3)
            else
                Utils.notify("Discord", "Failed to send test notification", 3)
            end
        end
    })
end

do
    Tabs.Monster:AddParagraph({
        Title = "Monster Farm",
        Content = "Automatically farm monsters with tween movement and optional auto-blocking. Now tweens to CENTER of monsters!"
    })
    
    State.selectedMonsters = {"Zombie"}
    
    Tabs.Monster:AddDropdown("MonsterTypes", {
        Title = "Monster Types",
        Description = "Select which monsters to farm",
        Values = MonsterTypes,
        Multi = true,
        Default = {"Zombie"},
        Callback = function(values)
            local newMonsters = {}
            for value, enabled in pairs(values) do
                if enabled then
                    table.insert(newMonsters, value)
                end
            end
            if #newMonsters > 0 then
                State.selectedMonsters = newMonsters
            else
                State.selectedMonsters = {"Zombie"}
                Utils.notify("Monster Farm", "At least one monster type required, defaulting to Zombie", 3)
            end
        end
    })
    
    Tabs.Monster:AddSlider("MonsterArrivalDistance", {
        Title = "Arrival Distance",
        Description = "Distance to consider 'arrived' at monster (studs)",
        Default = 12,
        Min = 5,
        Max = 20,
        Rounding = 1,
        Callback = function(value)
            MonsterState.arrivalDistance = tonumber(value) or 5
        end
    })
    
    -- Tabs.Monster:AddToggle("MonsterGoblinCave", {
    --     Title = "Goblin Cave Unlocked",
    --     Description = "Enable if you've unlocked the Goblin Cave",
    --     Default = false,
    --     Callback = function(value)
    --         State.goblinCaveUnlocked = value
    --     end
    -- })
    
    Tabs.Monster:AddToggle("AutoMonsterFarm", {
        Title = "Enable Monster Farm",
        Description = "Automatically farm selected monsters",
        Default = false,
        Callback = function(enabled)
            State.monsterFarmEnabled = enabled
            if enabled then
                MonsterFunctions.startFarming()
            else
                MonsterFunctions.stopFarming()
                Utils.notify("Monster Farm", "Stopped", 2)
            end
        end
    })
    
    Tabs.Monster:AddToggle("AutoFaceMonster", {
        Title = "Auto-Face Monster",
        Description = "Automatically face monsters while attacking (prevents missing)",
        Default = true,
        Callback = function(enabled)
            State.autoFaceMonster = enabled
            if enabled then
                Utils.notify("Auto-Face", "Enabled - Will face monsters", 2)
            else
                Utils.notify("Auto-Face", "Disabled", 2)
            end
        end
    })
    
    Tabs.Monster:AddToggle("SmartBlocking", {
        Title = "Smart Blocking (Farm)",
        Description = "Auto-block when monsters attack during farming",
        Default = false,
        Callback = function(enabled)
            State.monsterBlockingEnabled = enabled
            if State.monsterFarmEnabled then
                if enabled then
                    MonsterFunctions.enableAutoBlock()
                else
                    MonsterFunctions.disableAutoBlock()
                end
            end
        end
    })
    
    Tabs.Monster:AddButton({
        Title = "Clear Problematic Monsters",
        Description = "Reset the list of monsters that caused getting stuck",
        Callback = function()
            MonsterState.problematicMonsters = {}
            Utils.notify("Monster Farm", "Cleared problematic monsters list", 2)
        end
    })
    
    Tabs.Monster:AddButton({
        Title = "Stop All Monster Farm",
        Description = "Emergency stop for all monster functions",
        Callback = function()
            State.monsterFarmEnabled = false
            State.autoBlockEnabled = false
            MonsterFunctions.stopFarming()
            MonsterFunctions.disableAutoBlock()
            Utils.notify("Monster Farm", "All functions stopped", 2)
        end
    })
end

do
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    
    InterfaceManager:SetFolder("JordonHub")
    SaveManager:SetFolder("JordonHub/TheForge")
    
    task.spawn(function()
        task.wait(1)
        if SaveManager.Config and SaveManager.Config.DiscordWebhook then
            State.discordWebhook = SaveManager.Config.DiscordWebhook or ""
        end
        if SaveManager.Config and SaveManager.Config.DiscordUserID then
            State.discordUserId = SaveManager.Config.DiscordUserID or ""
        end
    end)
    
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
    
    Tabs.Settings:AddButton({
        Title = "Cleanup All",
        Description = "Stop all features and cleanup connections",
        Callback = function()
            State.miningEnabled = false
            State.monsterFarmEnabled = false
            State.flyEnabled = false
            State.noclipEnabled = false
            State.espEnabled = false
            State.autoBlockEnabled = false
            State.rareOreDetectionEnabled = false
            
            MiningFunctions.stopMining()
            MiningFunctions.stopRareOreDetection()
            MonsterFunctions.stopFarming()
            MonsterFunctions.disableAutoBlock()
            PlayerFunctions.disableFly()
            PlayerFunctions.disableNoclip()
            PlayerFunctions.disableESP()
            
            Utils.notify("Cleanup", "All features stopped and connections cleaned", 3)
        end
    })
    
end

local function onCharacterDied()
    MiningFunctions.cancelCurrentTween()
    MonsterFunctions.cancelCurrentTween()

    MiningState.targetConnection = Utils.cleanupConnection(MiningState.targetConnection)
    MiningState.noclipConnection  = Utils.cleanupConnection(MiningState.noclipConnection)
    MiningState.rareOreConnection = Utils.cleanupConnection(MiningState.rareOreConnection)

    MonsterState.targetConnection = Utils.cleanupConnection(MonsterState.targetConnection)
    MonsterState.attackConnection = Utils.cleanupConnection(MonsterState.attackConnection)
    MonsterState.noclipConnection = Utils.cleanupConnection(MonsterState.noclipConnection)
    MonsterState.blockConnection  = Utils.cleanupConnection(MonsterState.blockConnection)

    MiningState.currentTarget = nil
    MiningState.isAtRock = false
    MiningState.isMining = false
    MiningState.stuckCount = 0
    MiningState.lastPosition = nil
    MiningState.tweenStartTime = 0

    MonsterState.currentTarget = nil
    MonsterState.isAtMonster = false
    MonsterState.stuckCount = 0
    MonsterState.lastPosition = nil
    MonsterState.tweenStartTime = 0

    State.waitingForRespawn = true
end

local function hookCharacter(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then return end

    task.defer(function()
        task.wait(0.1)
        humanoid.WalkSpeed = State.savedWalkSpeed
        humanoid.JumpPower = State.savedJumpPower
    end)

    humanoid.Died:Connect(onCharacterDied)
end

LocalPlayer.CharacterAdded:Connect(function(character)
    hookCharacter(character)

    task.wait(1)

    if State.miningEnabled then
        MiningFunctions.stopMining()
        State.miningEnabled = true
        MiningFunctions.startMining()
    end

    if State.rareOreDetectionEnabled then
        MiningFunctions.stopRareOreDetection()
        State.rareOreDetectionEnabled = true
        MiningFunctions.enableNoclip()
        MiningFunctions.startRareOreDetection()
    end

    if State.monsterFarmEnabled then
        MonsterFunctions.stopFarming()
        State.monsterFarmEnabled = true
        MonsterFunctions.startFarming()
    end
end)

if LocalPlayer.Character then
    hookCharacter(LocalPlayer.Character)
end

task.spawn(function()
    task.wait(2)
    State.goblinCaveExists = Utils.detectGoblinCave()
end)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Jordon Hub Loaded! 🎉",
    Content = "Welcome to La Forge!",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()

Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        State.miningEnabled = false
        State.monsterFarmEnabled = false
        MiningFunctions.stopMining()
        MonsterFunctions.stopFarming()
    end
end)

local GC = getconnections or get_signal_cons
if GC then
    for i, v in pairs(GC(LocalPlayer.Idled)) do
        if v["Disable"] then
            v["Disable"](v)
        elseif v["Disconnect"] then
            v["Disconnect"](v)
        end
    end
else
    local VirtualUser = cloneref(game:GetService("VirtualUser"))
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

