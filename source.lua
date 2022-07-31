for i,v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "dosage's solaris gui" then
        v:Destroy()
    end
end

local Blacklisted = {
    [1] = 'ROBLOX',
    [2] = '345'
}

for i,v in pairs(game.Players:GetPlayers()) do
    if table.find(Blacklisted, v.Name) then 
        v:Kick('\nYou have been Blacklisted from NubWare for:\nAbusing\nYou may appeal/buy an unban from here\ndiscord.gg/84zaEF3uJJ')
    end
end

-- Variables
local InfiniteJumpEnabled = false
local uis = game:GetService('UserInputService')
local gamename = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local localnm = game.Players.LocalPlayer
local noclip = false
-- End of Variables

local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()


local win = SolarisLib:New({
  Name = "NubWare | "..gamename,
  FolderToSave = "SolarisLibStuff"
})


local tab = win:Tab("")


local CharacterModify = tab:Section("Character Modifications")

local InfJumpToggle = CharacterModify:Toggle("Infinite Jump", false,"Toggle", function(t)
    if t == true then
        InfiniteJumpEnabled = true
    else
        InfiniteJumpEnabled = false
    end
end)

--[[
toggle:Set(state <boolean>)
]]

--sec:Slider(title <string>,default <number>,max <number>,minimum <number>,increment <number>, flag <string>, callback <function>)
local WalkSpeedSlider = CharacterModify:Slider("WalkSpeed", 16,500,0,1,"Slider", function(t)
    if t == '' then return end
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = t
end)
local JumpPowerSlider = CharacterModify:Slider("JumpPower", 50,500,0,1,"Slider", function(t)
    if t == '' then return end
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = t
end)


--[[
slider:Set(state <number>)
]]

--sec:Dropdown(title <string>,options <table>,default <string>, flag <string>, callback <function>)


game:GetService("UserInputService").JumpRequest:connect(function()
	if InfiniteJumpEnabled then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)

game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50


local PlrTweeksABypass = tab:Section("Player Tweeks & Bypasses")

PlrTweeksABypass:Button("Client Anti Kick", function()
    local antikick
    antikick = hookmetamethod(game, "__namecall", function(...) 
    
    if getnamecallmethod() == "Kick" then
        SolarisLib:Notification("Anti Kick", "A client script attempted to kick you but got blocked.")
        return ""
    end
    
    return antikick(...)
end)
    SolarisLib:Notification("Anti Kick", "Enabled.")
end)

PlrTweeksABypass:Button('Anti AFK', function()
    if not game:IsLoaded() then game.Loaded:Wait(); end

    local idledEvent = game:GetService("Players").LocalPlayer.Idled
    local function disable()
        for _, cn in ipairs(getconnections(idledEvent)) do
            cn:Disable()
        end
    end

    oldConnect = hookfunction(idledEvent.Connect, function(self, ...)
        local cn = oldConnect(self, ...); disable()
        return cn
    end)

    namecall = hookmetamethod(game, "__namecall", function(self, ...)
        if self == idledEvent and getnamecallmethod() == "Connect" then
            local cn = oldConnect(self, ...); disable()
            return cn
        end
    return namecall(self, ...)
    end)
    SolarisLib:Notification("Anti AFK", "Enabled.")
    disable()
end)

PlrTweeksABypass:Button('Suicide', function()
    game.Players.LocalPlayer.Character:BreakJoints()
end)

local AnimationToggle = PlrTweeksABypass:Toggle("Player Animation Toggle", false,"Toggle", function(t)
    if t == true then
        game.Players.LocalPlayer.Character.Animate.Disabled = true
    else
        game.Players.LocalPlayer.Character.Animate.Disabled = false
    end
end)


local Teleportation = tab:Section("Teleportation")

Teleportation:Button("Teleport To Center", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,100,0)
end)

local PlrTP = Teleportation:Dropdown("TP to player", {},"","Dropdown", function(t)
    if t == '' then return end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace:FindFirstChild(t).HumanoidRootPart.CFrame
end)

local PlrTPRefresh = Teleportation:Button('Refresh Player Dropdown', function()
    local PlayerTable = {}

    for i,v in pairs(game:GetService("Players"):GetPlayers()) do 
        table.insert(PlayerTable,v.Name)
    end
    PlrTP:Refresh(PlayerTable, true)
    SolarisLib:Notification("Notification", "Refreshed.")
end)

local ClickTP = Teleportation:Button('Give TP Tool', function()
    mouse = game.Players.LocalPlayer:GetMouse()
    tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Click Teleport"
    tool.Activated:connect(function()
        local pos = mouse.Hit+Vector3.new(0,2.5,0)
        pos = CFrame.new(pos.X,pos.Y,pos.Z)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    end)
    tool.Parent = game.Players.LocalPlayer.Backpack
end)

-- Fetch Current Players
local PlayerTable = {}

for i,v in pairs(game:GetService("Players"):GetPlayers()) do 
    table.insert(PlayerTable,v.Name)
end
PlrTP:Refresh(PlayerTable, true)

local Visuals = tab:Section('Visuals')

local ESP_Color = Color3.fromRGB(255,0,0)
local ESP = Visuals:Toggle("Highlight ESP", false,"Toggle", function(t)
    if t == true then
        for i,v in pairs(game.Players:GetPlayers()) do
            if v.Character then
                local h = Instance.new('Highlight')
                h.Parent = v.Character
                h.FillTransparency = 1
                h.OutlineColor = ESP_Color
                h.Name = 'NubWareES_P'
            end
        end
    else
        for i,v in pairs(game.Players:GetPlayers()) do
            if v.Character:FindFirstChild('NubWareES_P') then
                v.Character:FindFirstChild('NubWareES_P'):Destroy()
            end
        end
    end
end)

local ESPColorSelector = Visuals:Dropdown("Change ESP Color", {'Red','Green','Blue','White','Hot Pink','Orange'},"","Dropdown", function(t)
    if t == '' then 
        return 
    elseif t == 'Red' then
        ESP_Color = Color3.fromRGB(255,0,0)
    elseif t == 'Green' then
        ESP_Color = Color3.fromRGB(0,255,0)
    elseif t == 'Blue' then
        ESP_Color = Color3.fromRGB(0,0,255)
    elseif t == 'White' then
        ESP_Color = Color3.fromRGB(255,255,255)
    elseif t == 'Hot Pink' then
        ESP_Color = Color3.fromRGB(227,28,121)
    elseif t == 'Orange' then
        ESP_Color = Color3.fromRGB(255,131,0)
    end
    for i,v in pairs(game.Workspace:GetDescendants()) do
        if v.Name == 'NubWareES_P' then
            v.OutlineColor = ESP_Color
        end
    end
end)

local NoFog = Visuals:Button('No Fog',function()
    game:GetService('Lighting').FogStart = 9999999999
    game:GetService('Lighting').FogEnd = 999999999
end)

local NoShadow = Visuals:Button('No Shadows',function()
    game:GetService('Lighting').GlobalShadows = false
end)

local Day = Visuals:Button('Day Time',function()
    game:GetService('Lighting').TimeOfDay = 12
end)

local Night = Visuals:Button('Night Time',function()
    game:GetService('Lighting').TimeOfDay = 0
end)

local WindowMods = tab:Section('Roblox Window Modifications')

UnfocusedFPS_Cap = WindowMods:Button('Enable Unfocused FPS Cap [Synapse & Knrl]', function()
    uis.WindowFocused:Connect(function() 
        setfpscap(144)
    end)

    uis.WindowFocusReleased:Connect(function() 
        setfpscap(15)
    end)
end)

local ls = tab:Section('Loadstrings')

ls:Button('Nameless Animations V4 [R6]',function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/BloxIT8/Nubware/main/loadstrings/nameless_animations.lua'))()
end)

local Credits = tab:Section("Credits")
Credits:Label('Bxl0c | Developer & Maintainer')
Credits:Label('Colorless#0001 | Emotional Support')
Credits:Label('Solaris | GUI Lib')
Credits:Label('Discord Server | discord.gg/84zaEF3uJJ')
Credits:Button('Drivers Paradise [Best Game Ever]',function()
    game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents.SayMessageRequest:FireServer('Go play drivers paradise!','All')
    wait()
    game:GetService('TeleportService'):Teleport(9100638688)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/BloxIT8/Nubware/main/driversparadiseclicks.lua'))()
    
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/BloxIT8/Nubware/main/execution.lua"))()

-- 


