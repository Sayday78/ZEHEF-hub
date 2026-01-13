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

--------------------------------------------------
-- DESYNC (FFLAGS)  << REMPLACEMENT ICI
--------------------------------------------------
local FFlags = {
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000,
    LargeReplicatorWrite5 = true,
    LargeReplicatorEnabled9 = true,
    AngularVelociryLimit = 360,
    TimestepArbiterVelocityCriteriaThresholdTwoDt = 2147483646,
    S2PhysicsSenderRate = 15000,
    DisableDPIScale = true,
    MaxDataPacketPerSend = 2147483647,
    PhysicsSenderMaxBandwidthBps = 20000,
    TimestepArbiterHumanoidLinearVelThreshold = 21,
    MaxMissedWorldStepsRemembered = -2147483648,
    PlayerHumanoidPropertyUpdateRestrict = true,
    SimDefaultHumanoidTimestepMultiplier = 0,
    StreamJobNOUVolumeLengthCap = 2147483647,
    DebugSendDistInSteps = -2147483648,
    GameNetDontSendRedundantNumTimes = 1,
    CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1,
    CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1,
    LargeReplicatorSerializeRead3 = true,
    ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 2147483647,
    CheckPVCachedVelThresholdPercent = 10,
    CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1,
    GameNetDontSendRedundantDeltaPositionMillionth = 1,
    InterpolationFrameVelocityThresholdMillionth = 5,
    StreamJobNOUVolumeCap = 2147483647,
    InterpolationFrameRotVelocityThresholdMillionth = 5,
    CheckPVCachedRotVelThresholdPercent = 10,
    WorldStepMax = 30,
    InterpolationFramePositionThresholdMillionth = 5,
    TimestepArbiterHumanoidTurningVelThreshold = 1,
    SimOwnedNOUCountThresholdMillionth = 2147483647,
    GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,
    NextGenReplicatorEnabledWrite4 = true,
    TimestepArbiterOmegaThou = 1073741823,
    MaxAcceptableUpdateDelay = 1,
    LargeReplicatorSerializeWrite4 = true
}

local defaultFFlags = {
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = 8,
    LargeReplicatorWrite5 = false,
    LargeReplicatorEnabled9 = false,
    AngularVelociryLimit = 180,
    TimestepArbiterVelocityCriteriaThresholdTwoDt = 100,
    S2PhysicsSenderRate = 60,
    DisableDPIScale = false,
    MaxDataPacketPerSend = 1024,
    PhysicsSenderMaxBandwidthBps = 10000,
    TimestepArbiterHumanoidLinearVelThreshold = 10,
    MaxMissedWorldStepsRemembered = 10,
    PlayerHumanoidPropertyUpdateRestrict = false,
    SimDefaultHumanoidTimestepMultiplier = 1,
    StreamJobNOUVolumeLengthCap = 1000,
    DebugSendDistInSteps = 10,
    GameNetDontSendRedundantNumTimes = 10,
    CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 50,
    CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 100,
    LargeReplicatorSerializeRead3 = false,
    ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 100,
    CheckPVCachedVelThresholdPercent = 50,
    CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 100,
    GameNetDontSendRedundantDeltaPositionMillionth = 100,
    InterpolationFrameVelocityThresholdMillionth = 100,
    StreamJobNOUVolumeCap = 1000,
    InterpolationFrameRotVelocityThresholdMillionth = 100,
    CheckPVCachedRotVelThresholdPercent = 50,
    WorldStepMax = 60,
    InterpolationFramePositionThresholdMillionth = 100,
    TimestepArbiterHumanoidTurningVelThreshold = 10,
    SimOwnedNOUCountThresholdMillionth = 1000,
    GameNetPVHeaderLinearVelocityZeroCutoffExponent = 8,
    NextGenReplicatorEnabledWrite4 = false,
    TimestepArbiterOmegaThou = 1000,
    MaxAcceptableUpdateDelay = 10,
    LargeReplicatorSerializeWrite4 = false
}

local DesyncActive = false
local FirstActivation = true

local function applyFFlags(flags)
    for name,value in pairs(flags) do
        pcall(function()
            setfflag(tostring(name), tostring(value))
        end)
    end
end

local function respawn(plr)
    local char = plr.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Dead)
        end
    end
end

MainTab:CreateToggle({
    Name = "Desync",
    CurrentValue = false,
    Callback = function(state)
        DesyncActive = state
        if state then
            applyFFlags(FFlags)
            if FirstActivation then
                respawn(Player)
                FirstActivation = false
            end
        else
            applyFFlags(defaultFFlags)
        end
    end
})

--------------------------------------------------
-- SAVE / STEAL
--------------------------------------------------
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
-- FEATURES / PVP / RESPAWN (INCHANGÉ)
--------------------------------------------------

Player.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    Root = c:WaitForChild("HumanoidRootPart")
end)
