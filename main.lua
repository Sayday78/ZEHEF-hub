--==================================================
-- ZEHEF HUB | discord.gg/fsQ2B4tD
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

-- VARS
local SavedPosition
local NoclipConn
local ESPEnabled = false
local ESPObjects = {}
local TracerLines = {}
local BaseRainbowConn
local DesyncActive = false
local FirstDesync = true

--==================================================
-- UI (RAYFIELD)
--==================================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "ZEHEF HUB  |  discord.gg/fsQ2B4tD",
    LoadingTitle = "ZEHEF HUB",
    LoadingSubtitle = "by Zehef",
    Theme = "Pink",
AccentColor = Color3.fromRGB(255, 105, 180) -- Rose

})

local MainTab = Window:CreateTab("MAIN")
local FeaturesTab = Window:CreateTab("FEATURES")
local PvpTab = Window:CreateTab("PVP HELPER")

--==================================================
-- MAIN
--==================================================
MainTab:CreateSection("MAIN")

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16,120},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        Humanoid.WalkSpeed = v
    end
})

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

MainTab:CreateButton({
    Name = "Save Position",
    Callback = function()
        SavedPosition = Root.CFrame
    end
})

MainTab:CreateButton({
    Name = "Instant Steal",
    Callback = function()
        if SavedPosition then
            Root.CFrame = SavedPosition
        end
    end
})

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

--==================== DESYNC ======================
local FFlags = {
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000,
    LargeReplicatorWrite5 = true,
    LargeReplicatorEnabled9 = true,
    AngularVelociryLimit = 360,
    S2PhysicsSenderRate = 15000,
    MaxDataPacketPerSend = 2147483647
}

local DefaultFlags = {
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = 8,
    LargeReplicatorWrite5 = false,
    LargeReplicatorEnabled9 = false,
    AngularVelociryLimit = 180,
    S2PhysicsSenderRate = 60,
    MaxDataPacketPerSend = 1024
}

local function ApplyFlags(t)
    for k,v in pairs(t) do
        pcall(function()
            setfflag(k, tostring(v))
        end)
    end
end

local function Respawn()
    local hum = Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Dead) end
end

MainTab:CreateToggle({
    Name = "Desync",
    CurrentValue = false,
    Callback = function(state)
        DesyncActive = state
        if state then
            ApplyFlags(FFlags)
            if FirstDesync then
                Respawn()
                FirstDesync = false
            end
        else
            ApplyFlags(DefaultFlags)
        end
    end
})

--==================================================
-- FEATURES
--==================================================
FeaturesTab:CreateSection("FEATURES")

-- FPS BOOSTER
FeaturesTab:CreateToggle({
    Name = "FPS Booster",
    CurrentValue = false,
    Callback = function(state)
        Lighting.GlobalShadows = not state
        settings().Rendering.QualityLevel = state and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
    end
})

--==================== PLAYER ESP ==================
local function ClearESP()
    for _,v in pairs(ESPObjects) do v:Destroy() end
    for _,l in pairs(TracerLines) do l:Remove() end
    ESPObjects = {}
    TracerLines = {}
end

local function CreateESP(plr)
    if plr == Player then return end
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0, 120, 255)
    hl.OutlineColor = Color3.new(1,1,1)
    hl.Parent = char
    table.insert(ESPObjects, hl)

    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Color = Color3.fromRGB(0,120,255)
    table.insert(TracerLines, line)

    RunService.RenderStepped:Connect(function()
        if not ESPEnabled or not char.Parent then
            line.Visible = false
            return
        end
        local pos1, on1 = workspace.CurrentCamera:WorldToViewportPoint(Root.Position)
        local pos2, on2 = workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position)
        if on1 and on2 then
            line.From = Vector2.new(pos1.X, pos1.Y)
            line.To = Vector2.new(pos2.X, pos2.Y)
            line.Visible = true
        else
            line.Visible = false
        end
    end)
end

FeaturesTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(state)
        ESPEnabled = state
        ClearESP()
        if state then
            for _,plr in ipairs(Players:GetPlayers()) do
                CreateESP(plr)
            end
        end
    end
})

Players.PlayerAdded:Connect(CreateESP)

--==================== BASE RAINBOW =================
local SpawnPos = Root.Position
local BaseParts = {}

for _,v in pairs(Workspace:GetDescendants()) do
    if v:IsA("BasePart") and (v.Position - SpawnPos).Magnitude < 80 then
        table.insert(BaseParts, v)
    end
end

FeaturesTab:CreateToggle({
    Name = "Base Rainbow",
    CurrentValue = false,
    Callback = function(state)
        if BaseRainbowConn then BaseRainbowConn:Disconnect() end
        if state then
            BaseRainbowConn = RunService.RenderStepped:Connect(function()
                local hue = tick() % 5 / 5
                for _,p in pairs(BaseParts) do
                    p.Color = Color3.fromHSV(hue,1,1)
                end
            end)
        end
    end
})

--==================================================
-- PVP HELPER
--==================================================
PvpTab:CreateSection("PVP HELPER")

PvpTab:CreateToggle({
    Name = "Speed 30",
    CurrentValue = false,
    Callback = function(state)
        Humanoid.WalkSpeed = state and 30 or 16
    end
})

--==================================================
-- RESPAWN FIX
--==================================================
Player.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    Root = c:WaitForChild("HumanoidRootPart")
end)
