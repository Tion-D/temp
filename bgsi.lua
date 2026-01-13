warn("New Execution")
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bomboclatzak-sudo/Bgs/refs/heads/main/HatcherMenu.lua')))()

local Window = OrionLib:MakeWindow({Name = "Hatcher", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Main = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Automations = Window:MakeTab({
	Name = "Rifts",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Teleportations = Window:MakeTab({
	Name = "Teleport",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local WebhookSection = Window:MakeTab({
	Name = "Webhook",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local EggSection = Main:AddSection({
	Name = "Eggs"
})

local settings = {
    DefaultEggName = "Gingerbread Egg",
    SelectedEggName = "Gingerbread Egg",
    AutoHatchEgg = false,
    SelectedWorld = "Christmas",
    PresentName = "Christmas Present",
    PresentAmount = 50
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Framework = Shared:WaitForChild("Framework")
local Network = Framework:WaitForChild("Network")
local Remote = Network:WaitForChild("Remote")
local RemoteEvent = Remote:WaitForChild("RemoteEvent")
local RemoteFunction = Remote:WaitForChild("RemoteFunction")
local LocalPlayer = game:getService("Players").LocalPlayer
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent
local RemoteModule = require(ReplicatedStorage.Shared.Framework.Network.Remote)
local LocalData = require(ReplicatedStorage.Client.Framework.Services.LocalData)
local StatsUtil = require(ReplicatedStorage.Shared.Utils.Stats.StatsUtil)
local ItemUtil = require(ReplicatedStorage.Shared.Utils.Stats.ItemUtil)
local PetUtil = require(ReplicatedStorage.Shared.Utils.Stats.PetUtil)
local FormatSuffix = require(ReplicatedStorage.Shared.Framework.Utilities.String.FormatSuffix)
local FormatCommas = require(ReplicatedStorage.Shared.Framework.Utilities.String.FormatCommas)
local Pets = require(ReplicatedStorage.Shared.Data.Pets)
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
local HttpService = game:GetService('HttpService')
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Spot = PlayerGui:WaitForChild("ScreenGui"):WaitForChild("Hatching")
local leaderstats = LocalPlayer:WaitForChild("leaderstats")

local RiftFolder = workspace:WaitForChild("Rendered"):WaitForChild("Rifts")

local AllowedRifts = {
    ["yuletide-egg"] = { DisplayName = "Yuletide Egg", Emoji = "🎄" },
    ["gingerbread-egg"] = { DisplayName = "Gingerbread Egg", Emoji = "🍪" },
    ["candycane-egg"] = { DisplayName = "Candycane Egg", Emoji = "🍡" },
    ["peppermint-chest"] = { DisplayName = "Peppermint Chest", Emoji = "🍬"}
}

local RiftLookup = {} 
local RiftCheckboxes = {}

local webhooks = {
    Evolve = "https://discord.com/api/webhooks/1447874255672053876/7LshEP70cey0NEXPuJlEEjGiDZBQYCFr8R1MkEyO4uQj-gWyH_3-3oeDBfOIfr4qEJxT",
    Creature = "https://discord.com/api/webhooks/1447849142020739134/P7VVNfz9w0h_IPp2laKSdsR34_zAAIKbIJJLM40RcboBKDkX9jWTRhWl7KuRzY75G7gW",
    Kody = "https://discord.com/api/webhooks/1447891040160710750/eRMI023AHVEjlRrShYcRTEFq64hLahFDsf0iH7A8DvzKZNHehPp4-iuy1odPXFT5j47X"
}

local RoleIds = {
    Evolve = "1448571148421042277",
    Creature = "1448572060765917285",
    Kody = "1448572017052880987"
}

local webhookNames = {}
for name, _ in pairs(webhooks) do
    table.insert(webhookNames, name)
end

getgenv().AutoHatchEgg = false
getgenv().AutoHatchRunning = false
getgenv().AutoPetNotifierEnabled = false
getgenv().AutoPetNotifierRunning = false
getgenv().AutoWheelRunning = false
getgenv().AutoWheel = false
getgenv().AutoGift = false
getgenv().AutoGiftRunning = false
getgenv().AutoBlow = false
getgenv().AutoBlowRunning = false
getgenv().AutoPresent = false
getgenv().AutoPresentRunning = false
getgenv().AutoRarePet = false
getgenv().AutoRarePetRunning = false
getgenv().AutoRift = false
getgenv().AutoRiftRunning = false
getgenv().WebhookURL = getgenv().WebhookURL or ""
getgenv().WebhookRole = getgenv().WebhookRole or ""
getgenv().SelectedRarity = getgenv().SelectedRarity or "Secret"
getgenv().WebhookEnabled = false
getgenv().WebhookRunning = false
getgenv().AutoPresents = false
getgenv().AutoPresentsRunning = false
getgenv().SavedPosition = nil
getgenv().SelectedRifts = {}
getgenv().SelectedRiftType = "gingerbread-egg"
getgenv().SelectedRiftEggName = "Gingerbread Egg" 

EggSection:AddTextbox({
	Name = "Egg Name",
	Default = "input Egg Name",
	TextDisappear = true,
	Callback = function(SelectedEgg)
        settings.SelectedEggName = SelectedEgg
	end
})

EggSection:AddDropdown({
	Name = "Dropdown",
	Default = "Gingerbread Egg",
	Options = {"Gingerbread Egg", "Candycane Egg", "Yuletide Egg"},
	Callback = function(DropDown)
		settings.SelectedEggName = DropDown
	end    
})

EggSection:AddToggle({
	Name = "AutoHatch",
	Default = false,
	Callback = function(AutoHatch)
		getgenv().AutoHatchEgg = AutoHatch
		if AutoHatch and not getgenv().AutoHatchRunning then
			getgenv().AutoHatchRunning = true
			task.spawn(function()
				while getgenv().AutoHatchEgg do
					RemoteEvent:FireServer("HatchEgg", settings.SelectedEggName, 13)
					task.wait()
				end
				getgenv().AutoHatchRunning = false
			end)
		end
	end
})

EggSection:AddToggle({
	Name = "AutoBubble",
	Default = false,
	Callback = function(AutoHatch)
		getgenv().AutoBlow = AutoHatch
		if AutoHatch and not getgenv().AutoBlowRunning then
			getgenv().AutoBlowRunning = true
			task.spawn(function()
				while getgenv().AutoBlow do
					RemoteEvent:FireServer("BlowBubble")
					task.wait()
				end
				getgenv().AutoBlowRunning = false
			end)
		end
	end
})

EggSection:AddToggle({
	Name = "AutoWheel",
	Default = false,
	Callback = function(AutoWheel)
		getgenv().AutoWheel = AutoWheel
		if AutoWheel and not getgenv().AutoWheelRunning then
			getgenv().AutoWheelRunning = true
			task.spawn(function()
				while getgenv().AutoWheel do
                    RemoteFunction:InvokeServer("ChristmasWheelSpin")
                    RemoteEvent:FireServer("ClaimChristmasWheelSpinQueue")
					task.wait()
				end
				getgenv().AutoWheelRunning = false
			end)
		end
	end
})

local function formatNumber(num)
    local formatted = tostring(num)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

local function UpdateChar(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChildOfClass("Humanoid")
    if hrp then hrp.Anchored = false end
    if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
end

LocalPlayer.CharacterAdded:Connect(UpdateChar)
if not char then
    char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    UpdateChar(char)
end

local function GetActivations()
    local path = workspace.Worlds["Christmas World"].GiveGifts
    local activations = {}
    for _, v in ipairs(path:GetDescendants()) do
        if v:IsA("Model") and v.Name == "Activation" then
            table.insert(activations, v)
        end
    end
    return activations
end

local function SafeTP(hrp, pos)
    if hrp then
        hrp.Anchored = false
        hrp.CFrame = CFrame.new(pos) * CFrame.fromMatrix(Vector3.zero, hrp.CFrame.RightVector, hrp.CFrame.UpVector)
        task.wait()
    end
end

EggSection:AddToggle({
    Name = "AutoGift",
    Default = false,
    Callback = function(state)
        getgenv().AutoGift = state

        if not state then
            getgenv().AutoGiftRunning = false
            if hrp then hrp.Anchored = false end
            if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
            return
        end

        if getgenv().AutoGiftRunning then return end
        getgenv().AutoGiftRunning = true

        task.spawn(function()
            while getgenv().AutoGift do
                task.wait(0.1)

                if not char or not hrp or not hum then continue end
                hum:ChangeState(Enum.HumanoidStateType.Running)
                hrp.Anchored = false

                for _, activation in ipairs(GetActivations()) do
                    if not getgenv().AutoGift then break end

                    local root = activation:FindFirstChild("Root")
                    if not root then continue end

                    SafeTP(hrp, root.Position + Vector3.new(0, 5, 0))

                    local elapsed = 0
                    local waitTime = 3 
                    while elapsed < waitTime do
                        if not getgenv().AutoGift then break end
                        task.wait(0.05) 
                        elapsed = elapsed + 0.05
                    end

                    if not getgenv().AutoGift then break end
                    RemoteEvent:FireServer("GiveGifts", activation.Parent.Name)
                    task.wait(0.05) 
                end
            end

            if hrp then hrp.Anchored = false end
            if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
            getgenv().AutoGiftRunning = false
        end)
    end
})

local function FormatRiftName(name)
    local words = {}
    for word in name:gmatch("[^%-]+") do
        table.insert(words, word:sub(1,1):upper() .. word:sub(2))
    end
    return table.concat(words, " ")
end

local function BuildRiftDisplay(rift)
    local info = AllowedRifts[rift.Name] or { DisplayName = FormatRiftName(rift.Name), Emoji = "❓" }

    local emoji = tostring(info.Emoji)
    local displayName = tostring(info.DisplayName)

    local luck = "?"
    local icon = rift:FindFirstChild("Display")
        and rift.Display:FindFirstChild("SurfaceGui")
        and rift.Display.SurfaceGui:FindFirstChild("Icon")
    if icon and icon:FindFirstChild("Luck") and icon.Luck:IsA("TextLabel") then
        luck = tostring(icon.Luck.Text)
    end

    local time = "??"
    local displayPart = rift:FindFirstChild("Display")
    if displayPart then
        local gui = displayPart:FindFirstChild("SurfaceGui")
        if gui then
            local timerLabel = gui:FindFirstChild("Timer")
            if timerLabel and timerLabel:IsA("TextLabel") then
                time = tostring(timerLabel.Text)
            end
        end
    end

    return string.format("%s %s (%s • %s)", emoji, displayName, luck, time)
end

local function GenerateDropdownOptions()
    local list = {}
    table.clear(RiftLookup)

    for _, rift in ipairs(RiftFolder:GetChildren()) do
        if AllowedRifts[rift.Name] then
            local text = BuildRiftDisplay(rift)
            table.insert(list, text)
            RiftLookup[rift] = text
        end
    end

    table.sort(list)
    return list
end

local RiftDropDown = Automations:AddDropdown({
    Name = "Select Rift",
    Default = "",
    Options = GenerateDropdownOptions(),
    Callback = function(selectedText)
        for rift, text in pairs(RiftLookup) do
            if text == selectedText then
                SelectedRift = rift
                break
            end
        end
    end
})

local function RefreshDropdown()
    local options = {}
    table.clear(RiftLookup)

    for _, rift in ipairs(RiftFolder:GetChildren()) do
        if AllowedRifts[rift.Name] then
            local text = BuildRiftDisplay(rift)
            table.insert(options, text)
            RiftLookup[rift] = text
        end
    end

    table.sort(options)

    if RiftDropDown.Value ~= nil then
        local currentValue = SelectedRift and RiftLookup[SelectedRift] or nil
        RiftDropDown:Refresh(options, true)

        if currentValue then
            RiftDropDown.Value = currentValue
        end
    else
        RiftDropDown:Refresh(options, true)
    end

    if SelectedRift and not RiftLookup[SelectedRift] then
        SelectedRift = nil
    end
end

RiftFolder.ChildAdded:Connect(function() task.wait(0.1) RefreshDropdown() end)
RiftFolder.ChildRemoved:Connect(RefreshDropdown)

task.spawn(function()
    while task.wait(1) do
        RefreshDropdown()
    end
end)

Automations:AddButton({
    Name = "Teleport to Selected Rift",
    Callback = function()
        if not SelectedRift then
            warn("No rift selected.")
            return
        end

        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and SelectedRift:FindFirstChild("Display") then
            local targetPos = SelectedRift.Display.Position or SelectedRift.Display.CFrame.Position
            hrp.CFrame = CFrame.new(targetPos)
            print("Teleported to:", BuildRiftDisplay(SelectedRift))
        else
            warn("Cannot teleport: missing HumanoidRootPart or Display")
        end
    end
})

Automations:AddDropdown({
    Name = "Select Rif",
    Default = "Gingerbread Egg",
    Options = {"Gingerbread Egg", "Candycane Egg", "Yuletide Egg", "Peppermint Chest"},
    Callback = function(selection)
        local riftMap = {
            ["Gingerbread Egg"] = {rift = "gingerbread-egg", egg = "Gingerbread Egg"},
            ["Candycane Egg"] = {rift = "candycane-egg", egg = "Candycane Egg"},
            ["Yuletide Egg"] = {rift = "yuletide-egg", egg = "Yuletide Egg"},
            ["Peppermint Chest"] = {rift = "peppermint-chest", egg = "Peppermint Chest"}
        }
        getgenv().SelectedRiftType = riftMap[selection].rift
        getgenv().SelectedRiftEggName = riftMap[selection].egg
    end
})
Automations:AddToggle({
    Name = "Auto Rift",
    Default = false,
    Callback = function(state)
        getgenv().AutoRift = state

        if not state then
            getgenv().AutoRiftRunning = false
            if hrp then hrp.Anchored = false end
            if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
            return
        end

        if getgenv().AutoRiftRunning then return end
        getgenv().AutoRiftRunning = true

        task.spawn(function()
            while getgenv().AutoRift do
                task.wait(0.5)

                if not char or not hrp or not hum then continue end

                local foundRift = nil
                for _, rift in ipairs(RiftFolder:GetChildren()) do
                    if rift.Name == getgenv().SelectedRiftType and rift:FindFirstChild("Display") then
                        foundRift = rift
                        SelectedRift = rift
                        break
                    end
                end

                if not foundRift then
                    if getgenv().SavedPosition then
                        hrp.CFrame = getgenv().SavedPosition
                    end
                    RemoteEvent:FireServer("HatchEgg", settings.SelectedEggName, 13)
                    task.wait(0.1)
                    continue
                end

                if not getgenv().SavedPosition then
                    getgenv().SavedPosition = hrp.CFrame
                end

                local targetPos = foundRift.Display.Position
                SafeTP(hrp, targetPos)
                task.wait(0.5)

                while getgenv().AutoRift and foundRift and foundRift.Parent do
                    RemoteEvent:FireServer("HatchEgg", getgenv().SelectedRiftEggName, 13)
                    task.wait(0.1)
                end

                if getgenv().SavedPosition then
                    hrp.CFrame = getgenv().SavedPosition
                    task.wait(0.5)
                end

                local waitTime = 0
                while getgenv().AutoRift and waitTime < 30 do
                    local newRift = nil
                    for _, rift in ipairs(RiftFolder:GetChildren()) do
                        if rift.Name == getgenv().SelectedRiftType and rift:FindFirstChild("Display") then
                            newRift = rift
                            break
                        end
                    end

                    if newRift then
                        break
                    end

                    RemoteEvent:FireServer("HatchEgg", settings.SelectedEggName, 13)
                    task.wait(0.1)
                    waitTime = waitTime + 0.1
                end
            end

            if hrp then hrp.Anchored = false end
            if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
            getgenv().AutoRiftRunning = false
        end)
    end
})

Teleportations:AddButton({
    Name = "Teleport to Winter Eggs",
    Callback = function()
        local targetCFrame = CFrame.new(
            -2481.11572, 36.0117455, 1226.60803,
            -0.636197329, -3.65438495e-07, 0.771526337,
            -2.59595339e-07, 1, 2.59595311e-07,
            -0.771526337, -3.51307925e-08, -0.636197329
        )

        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            warn("HumanoidRootPart not found")
            return
        end

        hrp.CFrame = targetCFrame
        print("Teleported to secret CFrame!")
    end
})

Teleportations:AddButton({
    Name = "Teleport to Enchanter",
    Callback = function()
        local targetCFrame = CFrame.new(
          -52.0119133, 10148.71, 
          47.0890388, 
          0.512039363,
          1.40908876e-20, 0.858961999, 
          9.69264938e-22, 1, 
          -1.69823459e-20, 
          -0.858961999, 
          9.52819169e-21, 
          0.512039363
        )

        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            warn("HumanoidRootPart not found")
            return
        end

        hrp.CFrame = targetCFrame
        print("Teleported to secret CFrame!")
    end
})

Teleportations:AddButton({
    Name = "Teleport to Bubble Shrine",
    Callback = function()
        local targetCFrame = CFrame.new( 
            5.203871250152588, 
            15976.845703125, 
            76.09961700439453
        )

        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            warn("HumanoidRootPart not found")
            return
        end

        hrp.CFrame = targetCFrame
        print("Teleported to secret CFrame!")
    end
})

Teleportations:AddButton({
    Name = "Teleport to Dream Shrine",
    Callback = function()
        local targetCFrame = CFrame.new(
            -21799.4765625, 
            7.846194267272949, 
            -20440.369140625
        )

        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            warn("HumanoidRootPart not found")
            return
        end

        hrp.CFrame = targetCFrame
        print("Teleported to secret CFrame!")
    end
})

Teleportations:AddButton({
    Name = "Teleport to Admin Abuse Egg",
    Callback = function()
        local targetCFrame = CFrame.new(
            126.619072, 
            8.59998417, 
            91.6279297, 
            -0.761533022, 
            4.84210312e-26, 
            -0.648126066, 
            -3.17974163e-29, 
            1, 
            7.47466415e-26, 
            0.648126066, 
            5.69426425e-26, 
            -0.761533022
        )

        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            warn("HumanoidRootPart not found")
            return
        end

        hrp.CFrame = targetCFrame
        print("Teleported to secret CFrame!")
    end
})

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

WebhookSection:AddDropdown({
    Name = "Select Webhook",
    Default = webhookNames[1],
    Options = webhookNames,
    Callback = function(selection)
        getgenv().WebhookURL = webhooks[selection]
        getgenv().WebhookRole = RoleIds[selection]
    end
})

WebhookSection:AddDropdown({
    Name = "Minimum Rarity",
    Default = getgenv().SelectedRarity,
    Options = {"Legendary", "Secret", "Infinity"},
    Callback = function(rarity)
        getgenv().SelectedRarity = rarity
    end
})

WebhookSection:AddToggle({
    Name = "Enable Webhook Notifications",
    Default = false,
    Callback = function(state)
        getgenv().WebhookEnabled = state
        
        if state and not getgenv().WebhookRunning then
            getgenv().WebhookRunning = true
            
            RemoteModule.Event("HatchEgg"):Connect(function(data)
                if not getgenv().WebhookEnabled then return end
                if not data then return end
                
                local dataaa = LocalData:Get()
                local embeds = {}
                
                for x,v in data.Pets do
                    local Name = ItemUtil:GetName(v.Pet)
                    local Rarity = ItemUtil:GetRarity(v.Pet)
                    local Chance = PetUtil:GetChance(v.Pet)

                    local rarityOrder = {Legendary = 1, Secret = 2, Infinity = 3}
                    local petRarityLevel = rarityOrder[Rarity] or 0
                    local minRarityLevel = rarityOrder[getgenv().SelectedRarity] or 0
                    
                    if petRarityLevel >= minRarityLevel then
                        local Stats = {}
                        for m,n in PetUtil:GetStats(v.Pet) do
                            Stats[#Stats + 1] = "> "..m..": "..FormatCommas(math.floor(n))
                        end

                        local Pet = Pets[v.Pet.Name]
                        local Image = Pet.Images.Normal
                        if v.Pet.Mythic then
                            Image = Pet.Images.Mythic
                            if v.Pet.Shiny then
                                Image = Pet.Images.MythicShiny
                            end
                        elseif v.Pet.Shiny then
                            Image = Pet.Images.Shiny
                        end

                        embeds[#embeds + 1] = {
                            title = Name.." Pet Hatched (Odds 1/"..FormatSuffix(math.ceil(100 / Chance))..")",
                            description = "Total Hatches: **"..FormatCommas(dataaa.Stats.Hatches).."**\nRarity: **"..Rarity.."**\n"..table.concat(Stats, "\n"),
                            thumbnail = {url = HttpService:JSONDecode(game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds="..Image:match("%d+").."&size=420x420&format=Png"))["data"][1]["imageUrl"]},
                            color = tonumber(0xFF0000)
                        }
                    end
                end
                
                if #embeds > 0 and getgenv().WebhookURL ~= "" then
                    local success, err = pcall(function()
                        request({
                            Url = getgenv().WebhookURL,
                            Method = "POST",
                            Body = HttpService:JSONEncode({
                                content = getgenv().WebhookRole and ("<@&" .. getgenv().WebhookRole .. ">") or "",
                                embeds = embeds
                            }),
                            Headers = {["Content-Type"] = "application/json"}
                        })
                    end)
                    
                    if success then
                        warn("Webhook sent successfully!")
                    else
                        warn("Webhook failed: " .. tostring(err))
                    end
                end
            end)
        end
    end
})
