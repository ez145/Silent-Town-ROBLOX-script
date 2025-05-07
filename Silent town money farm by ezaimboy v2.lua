-- Silent Town Money Collector Script for JJSploit (Automated, Fixed Prompt)
-- Automatically teleports to and collects "Money" objects in Workspace with Material Plastic
-- Simple draggable, minimizable, closable GUI with Support tab

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local isCollecting = false
local collectedMoney = {}

-- Create simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.Name = "MoneyCollectorGui"
ScreenGui.ResetOnSpawn = false -- Prevent GUI from resetting on death

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 200)
Frame.Position = UDim2.new(0.5, -100, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Money Collector"
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Parent = Frame

-- Tabs (Main and Support)
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 30)
TabFrame.Position = UDim2.new(0, 0, 0, 30)
TabFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TabFrame.Parent = Frame

local MainTabButton = Instance.new("TextButton")
MainTabButton.Size = UDim2.new(0.5, 0, 1, 0)
MainTabButton.Text = "Main"
MainTabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
MainTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabButton.TextScaled = true
MainTabButton.Parent = TabFrame

local SupportTabButton = Instance.new("TextButton")
SupportTabButton.Size = UDim2.new(0.5, 0, 1, 0)
SupportTabButton.Position = UDim2.new(0.5, 0, 0, 0)
SupportTabButton.Text = "Support !"
SupportTabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
SupportTabButton.TextColor3 = Color3.fromRGB(255, 0, 0)
SupportTabButton.TextScaled = true
SupportTabButton.Parent = TabFrame

-- Main Tab Content
local MainTab = Instance.new("Frame")
MainTab.Size = UDim2.new(1, 0, 0, 140)
MainTab.Position = UDim2.new(0, 0, 0, 60)
MainTab.BackgroundTransparency = 1
MainTab.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
ToggleButton.Text = "Auto Collect: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Parent = MainTab

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.8, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
StatusLabel.Text = "Status: Idle"
StatusLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextScaled = true
StatusLabel.Parent = MainTab

-- Support Tab Content
local SupportTab = Instance.new("Frame")
SupportTab.Size = UDim2.new(1, 0, 0, 140)
SupportTab.Position = UDim2.new(0, 0, 0, 60)
SupportTab.BackgroundTransparency = 1
SupportTab.Visible = false
SupportTab.Parent = Frame

local SupportButton = Instance.new("TextButton")
SupportButton.Size = UDim2.new(0.8, 0, 0, 40)
SupportButton.Position = UDim2.new(0.1, 0, 0.2, 0)
SupportButton.Text = "SUPPORT ME"
SupportButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
SupportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SupportButton.TextScaled = true
SupportButton.Parent = SupportTab

-- Minimize and Close Buttons
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextScaled = true
MinimizeButton.Parent = Frame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Parent = Frame

-- GUI functionality
local isMinimized = false

-- Tab switching
MainTabButton.MouseButton1Click:Connect(function()
    MainTab.Visible = true
    SupportTab.Visible = false
    MainTabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    SupportTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)

SupportTabButton.MouseButton1Click:Connect(function()
    MainTab.Visible = false
    SupportTab.Visible = true
    MainTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    SupportTabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

-- Toggle auto collect
ToggleButton.MouseButton1Click:Connect(function()
    isCollecting = not isCollecting
    ToggleButton.Text = isCollecting and "Auto Collect: ON" or "Auto Collect: OFF"
    collectedMoney = {} -- Reset collected list
end)

-- Minimize functionality
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Frame.Size = UDim2.new(0, 200, 0, 30)
        MinimizeButton.Text = "+"
        TabFrame.Visible = false
        MainTab.Visible = false
        SupportTab.Visible = false
    else
        Frame.Size = UDim2.new(0, 200, 0, 200)
        MinimizeButton.Text = "-"
        TabFrame.Visible = true
        MainTab.Visible = true
        SupportTab.Visible = false
    end
end)

-- Close functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Support button to copy link
SupportButton.MouseButton1Click:Connect(function()
    setclipboard("https://www.donationalerts.com/r/ezaimboy")
    StatusLabel.Text = "Link copied, put it in your browser"
end)

-- Function to find nearest uncollected Money
local function findNearestMoney()
    local nearestMoney = nil
    local minDist = math.huge
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "Money" and obj:IsA("MeshPart") and obj.Material == Enum.Material.Plastic and not collectedMoney[obj] then
            local dist = (obj.Position - HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearestMoney = obj
            end
        end
    end
    return nearestMoney
end

-- Function to collect money automatically with retry
local function collectMoney()
    if isCollecting then
        local money = findNearestMoney()
        if money then
            StatusLabel.Text = "Collecting at " .. math.floor(money.Position.X) .. ", " .. math.floor(money.Position.Z)
            -- Teleport to money
            HumanoidRootPart.CFrame = CFrame.new(money.Position + Vector3.new(0, 3, 0))
            -- Try to fire ProximityPrompt if it exists
            local prompt = money:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                prompt.HoldDuration = 0 -- Remove hold requirement
                -- Retry firing prompt until money is collected or 3 seconds pass
                local startTime = tick()
                while money.Parent and (tick() - startTime) < 3 do
                    fireproximityprompt(prompt)
                    wait(0.1)
                end
            end
            collectedMoney[money] = true
            wait(0.5) -- Delay to ensure collection
        else
            StatusLabel.Text = "No Money Found, Bro!"
            collectedMoney = {} -- Reset for new spawn
        end
    end
end

-- Run collectMoney every frame if collecting is enabled
RunService.RenderStepped:Connect(function()
    if isCollecting then
        collectMoney()
    end
end)

-- Update character on respawn
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

-- Recreate GUI on respawn if needed
Player.CharacterRemoving:Connect(function()
    if not ScreenGui.Parent then
        ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
end)