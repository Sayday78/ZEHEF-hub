--==================================================
-- ZEHEF HUB | discord.gg/fsQ2B4tD
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

-- VARS
local SavedPosition
local NoclipConn
local AutoGrabConn
local DesyncEnabled = false
local ESPEnabled = false

--==================================================
-- UI (RAYFIELD)
--==================================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "ZEHEF HUB  |  discord.gg/fsQ2B4tD",
    LoadingTitle = "ZEHEF HUB",
    LoadingSubtitle = "by Zehef",
    Theme = "Dark"
})

--==================================================
-- TABS
--==================================================
local MainTab = Window:CreateTab("MAIN")
local FeaturesTab = Window:CreateTab("FEATURES")
local PvpTab = Window:CreateTab("PVP HELPER")

--------------------------------------------------
-- MAIN
--------------------------------------------------
MainTab:CreateSection("MAIN")

-- WalkSpeed
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16,120},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        Humanoid.WalkSpeed = v
    end
})

-- NoClip
MainTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(state)
        if NoclipConn then NoclipConn:Disconnect() end
        if state then
            NoclipConn = RunService.Stepped:Connect(function()
                for _,v in pairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            for _,v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
})

-- DESYNC (ex Ghost Mode)
MainTab:CreateToggle({
    Name = "Desync",
    CurrentValue = false,
    Callback = function(state)
        DesyncEnabled = state
        for _,v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.LocalTransparencyModifier = state and 0.7 or 0
            end
        end
    end
})

-- Save Position
MainTab:CreateButton({
    Name = "Save Position",
    Callback = function()
        SavedPosition = Root.CFrame
    end
})

-- Instant Steal
MainTab:CreateButton({
    Name = "Instant Steal",
    Callback = function()
        if SavedPosition then
            Root.CFrame = SavedPosition
        end
    end
})

-- Auto Kick
MainTab:CreateToggle({
    Name = "Auto Kick after Steal",
    CurrentValue = false,
    Callback = function(state)
        if state then
            task.delay(1.2, function()
                Player:Kick("ZEHEF HUB | Auto Kick Enabled")
            end)
        end
    end
})

-- Xray / Base Transparent
MainTab:CreateToggle({
    Name = "Xray / Base Transparent",
    CurrentValue = false,
    Callback = function(state)
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsDescendantOf(Character) then
                v.LocalTransparencyModifier = state and 0.6 or 0
            end
        end
    end
})

--------------------------------------------------
-- FEATURES
--------------------------------------------------
FeaturesTab:CreateSection("FEATURES")

-- FPS BOOSTER (REAL)
FeaturesTab:CreateToggle({
    Name = "FPS Booster (REAL)",
    CurrentValue = false,
    Callback = function(state)
        if state then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e9
            Lighting.Brightness = 1
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        else
            Lighting.GlobalShadows = true
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end
    end
})

-- AUTO GRAB (Instant, sans E)
FeaturesTab:CreateToggle({
    Name = "Auto Grab (Instant)",
    CurrentValue = false,
    Callback = function(state)
        if AutoGrabConn then AutoGrabConn:Disconnect() AutoGrabConn=nil end
        if state then
            AutoGrabConn = RunService.Heartbeat:Connect(function()
                for _,p in ipairs(workspace:GetDescendants()) do
                    if p:IsA("ProximityPrompt") and p.Enabled then
                        local part = p.Parent
                        if part and part:IsA("BasePart") then
                            if (Root.Position - part.Position).Magnitude <= p.MaxActivationDistance then
                                pcall(function()
                                    fireproximityprompt(p)
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- PLAYER ESP
FeaturesTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(state)
        ESPEnabled = state

        local function apply(plr)
            if plr ~= Player and plr.Character then
                local h = plr.Character:FindFirstChild("ZEHEF_ESP")
                if ESPEnabled then
                    if not h then
                        h = Instance.new("Highlight")
                        h.Name = "ZEHEF_ESP"
                        h.Adornee = plr.Character
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.FillColor = plr.TeamColor.Color
                        h.Parent = plr.Character
                    end
                else
                    if h then h:Destroy() end
                end
            end
        end

        for _,plr in ipairs(Players:GetPlayers()) do
            apply(plr)
        end

        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                task.wait(1)
                apply(plr)
            end)
        end)
    end
})

--------------------------------------------------
-- PVP HELPER
--------------------------------------------------
PvpTab:CreateSection("PVP HELPER")

PvpTab:CreateToggle({
    Name = "Speed 30",
    CurrentValue = false,
    Callback = function(state)
        Humanoid.WalkSpeed = state and 30 or 16
    end
})

--------------------------------------------------
-- RESPAWN FIX
--------------------------------------------------
Player.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    Root = c:WaitForChild("HumanoidRootPart")
end)
