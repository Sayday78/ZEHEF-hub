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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

-- VARS
local SavedPosition
local NoclipConn
local AutoGrabConn
local ESPEnabled = false
local AP_SPAMM_Enabled = false

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
-- AP SPAMM (AJOUTÉ)
--------------------------------------------------
local AP_Gui
local AP_Remote
pcall(function()
    AP_Remote = ReplicatedStorage:WaitForChild("Packages")
        :WaitForChild("Net")
        :WaitForChild("RE/AdminPanelService/ExecuteCommand")
end)

local AP_Commands = {"rocket", "balloon", "ragdoll", "jail", "tiny", "jumpscare", "morph"}

local function AP_Execute(target)
    if not AP_Remote then return end
    for _,cmd in ipairs(AP_Commands) do
        pcall(function()
            AP_Remote:FireServer(target, cmd)
        end)
    end
end

local function AP_CreateGui()
    AP_Gui = Instance.new("ScreenGui", Player.PlayerGui)
    AP_Gui.Name = "ZEHEF_AP_SPAMM"
    AP_Gui.ResetOnSpawn = false

    local Frame = Instance.new("Frame", AP_Gui)
    Frame.Size = UDim2.new(0, 260, 0, 360)
    Frame.Position = UDim2.new(0, 15, 0.5, -180)
    Frame.BackgroundColor3 = Color3.fromRGB(15,15,20)
    Frame.BorderSizePixel = 0

    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,14)

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1,0,0,40)
    Title.BackgroundTransparency = 1
    Title.Text = "AP SPAMM"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.new(1,1,1)

    local List = Instance.new("UIListLayout", Frame)
    List.Padding = UDim.new(0,6)

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            local Btn = Instance.new("TextButton", Frame)
            Btn.Size = UDim2.new(1,-20,0,36)
            Btn.Text = plr.Name
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.BackgroundColor3 = Color3.fromRGB(30,30,45)
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.MouseButton1Click:Connect(function()
                AP_Execute(plr)
            end)
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,10)
        end
    end
end

MainTab:CreateToggle({
    Name = "AP SPAMM",
    CurrentValue = false,
    Callback = function(state)
        AP_SPAMM_Enabled = state
        if state then
            if not AP_Gui then
                AP_CreateGui()
            else
                AP_Gui.Enabled = true
            end
        else
            if AP_Gui then
                AP_Gui.Enabled = false
            end
        end
    end
})

--------------------------------------------------
-- FEATURES
--------------------------------------------------
FeaturesTab:CreateSection("FEATURES")

-- FPS BOOSTER
FeaturesTab:CreateToggle({
    Name = "FPS Booster",
    CurrentValue = false,
    Callback = function(state)
        if state then
            Lighting.GlobalShadows = false
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        else
            Lighting.GlobalShadows = true
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end
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
