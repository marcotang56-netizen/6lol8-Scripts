--// tenko Void - Simple Key System (With Workspace Auto-Save)
-- Run with: script_key = "yourkeyhere"; loadstring(game:HttpGet("RAW_URL"))();

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

--// ==================== PRIVATE KEY LIST ====================
local DiscordLink = "https://discord.gg/EYpFQQBhAd"  -- ← CHANGE THIS

local ValidKeys = {
    "6lol8",
    "tenko", 
    "6lol",
}

--// ==================== WORKSPACE AUTO-SAVE LOGIC ====================
local keyValid = false
local folderName = "tenkoVoid"
local keyFilePath = folderName .. "/key.txt"

-- 1. Safely create the folder in the executor's workspace if it doesn't exist
if isfolder and makefolder then
    if not isfolder(folderName) then
        makefolder(folderName)
    end
end

-- 2. Try to read a previously saved key from the file
local savedKey = nil
if isfile and readfile and isfile(keyFilePath) then
    savedKey = readfile(keyFilePath):match("^%s*(.-)%s*$")
end

-- 3. Check if either the script_key (from loadstring) OR the savedKey is valid
local keyToCheck = script_key or savedKey

if keyToCheck and typeof(keyToCheck) == "string" then
    for _, key in ipairs(ValidKeys) do
        if key == keyToCheck then
            keyValid = true
            break
        end
    end
end

-- Notification Function
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5,
    })
end

--// ==================== MAIN TENKO GUI (DEFINED FIRST) ====================
local function loadMainGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "tenkoVoid"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 270, 0, 220)
    MainFrame.Position = UDim2.new(1, -290, 1, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(120, 85, 255)
    MainStroke.Thickness = 1.6
    MainStroke.Transparency = 0.2

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 46)
    TitleBar.BackgroundColor3 = Color3.fromRGB(18, 16, 32)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 14)

    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 10)
    TitleFix.Position = UDim2.new(0, 0, 1, -10)
    TitleFix.BackgroundColor3 = TitleBar.BackgroundColor3
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "tenko void"
    TitleLabel.TextColor3 = Color3.fromRGB(240, 210, 255)
    TitleLabel.TextSize = 20
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 36, 0, 36)
    CloseButton.Position = UDim2.new(1, -46, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 22
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TitleBar
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 8)

    -- Status
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -30, 0, 30)
    StatusLabel.Position = UDim2.new(0, 15, 0, 65)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "● IDLE"
    StatusLabel.TextColor3 = Color3.fromRGB(145, 145, 165)
    StatusLabel.TextSize = 16
    StatusLabel.Font = Enum.Font.GothamSemibold
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = MainFrame

    -- Toggle Button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, -30, 0, 68)
    ToggleButton.Position = UDim2.new(0, 15, 0, 105)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(85, 55, 190)
    ToggleButton.Text = "START VOIDING"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 20
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = MainFrame
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 12)

    -- Counter
    local CounterLabel = Instance.new("TextLabel")
    CounterLabel.Size = UDim2.new(1, -30, 0, 24)
    CounterLabel.Position = UDim2.new(0, 15, 0, 185)
    CounterLabel.BackgroundTransparency = 1
    CounterLabel.Text = "Teleports: 0"
    CounterLabel.TextColor3 = Color3.fromRGB(105, 105, 135)
    CounterLabel.TextSize = 13.5
    CounterLabel.Font = Enum.Font.Gotham
    CounterLabel.TextXAlignment = Enum.TextXAlignment.Left
    CounterLabel.Parent = MainFrame

    -- Variables
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local isVoiding = false
    local teleportCount = 0
    local connection = nil

    local function updateUI()
        if isVoiding then
            StatusLabel.Text = "● VOIDING"
            StatusLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
            ToggleButton.Text = "STOP VOIDING"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 70)
        else
            StatusLabel.Text = "● IDLE"
            StatusLabel.TextColor3 = Color3.fromRGB(145, 145, 165)
            ToggleButton.Text = "START VOIDING"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(85, 55, 190)
        end
    end

    local function performVoid()
        if not HumanoidRootPart then return end
        local pos = HumanoidRootPart.Position
        local angle = math.random() * math.pi * 2
        local dist = 2e22

        HumanoidRootPart.CFrame = CFrame.new(
            pos.X + math.cos(angle) * dist,
            pos.Y,
            pos.Z + math.sin(angle) * dist
        )

        teleportCount += 1
        CounterLabel.Text = "Teleports: " .. teleportCount
    end

    local function toggleVoid()
        isVoiding = not isVoiding
        updateUI()

        if isVoiding then
            if connection then connection:Disconnect() end
            connection = RunService.Heartbeat:Connect(function()
                performVoid()
                task.wait(0.00001)
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end

    local function closeGUI()
        ScreenGui:Destroy()
    end

    -- Hover Effects
    CloseButton.MouseEnter:Connect(function() CloseButton.BackgroundColor3 = Color3.fromRGB(230, 60, 60) end)
    CloseButton.MouseLeave:Connect(function() CloseButton.BackgroundColor3 = Color3.fromRGB(200, 45, 45) end)

    ToggleButton.MouseEnter:Connect(function()
        if not isVoiding then ToggleButton.BackgroundColor3 = Color3.fromRGB(105, 75, 220) end
    end)
    ToggleButton.MouseLeave:Connect(updateUI)

    -- Connections
    ToggleButton.Activated:Connect(toggleVoid)
    CloseButton.Activated:Connect(closeGUI)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.P then
            toggleVoid()
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(newChar)
        Character = newChar
        HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
        if isVoiding then
            if connection then connection:Disconnect() end
            connection = RunService.Heartbeat:Connect(function()
                performVoid()
                task.wait(0.00001)
            end)
        end
    end)

    updateUI()
    notify("✅ tenko Void", "Loaded successfully! Press P or click button", 5)
end

--// ==================== KEY SYSTEM LOGIC ====================
if not keyValid then
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KeySystem"
    KeyGui.ResetOnSpawn = false
    KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 320, 0, 360)
    Main.Position = UDim2.new(0.5, -160, 0.5, -180)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = KeyGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(120, 85, 255)
    Stroke.Thickness = 2

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.BackgroundTransparency = 1
    Title.Text = "TENKO VOID"
    Title.TextColor3 = Color3.fromRGB(240, 210, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBlack
    Title.Parent = Main

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, 0, 0, 30)
    Subtitle.Position = UDim2.new(0, 0, 0, 55)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Key System"
    Subtitle.TextColor3 = Color3.fromRGB(160, 160, 180)
    Subtitle.TextSize = 16
    Subtitle.Font = Enum.Font.GothamSemibold
    Subtitle.Parent = Main

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -40, 0, 50)
    KeyBox.Position = UDim2.new(0, 20, 0, 110)
    KeyBox.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    KeyBox.PlaceholderText = "Enter key here..."
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.TextSize = 18
    KeyBox.Font = Enum.Font.GothamSemibold
    KeyBox.Parent = Main
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(1, -40, 0, 55)
    SubmitBtn.Position = UDim2.new(0, 20, 0, 175)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(85, 55, 190)
    SubmitBtn.Text = "SUBMIT KEY"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 20
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = Main
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 12)

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(1, -40, 0, 55)
    GetKeyBtn.Position = UDim2.new(0, 20, 0, 245)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    GetKeyBtn.Text = "GET KEY (Discord)"
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.TextSize = 20
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Parent = Main
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 12)

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 30)
    Status.Position = UDim2.new(0, 20, 0, 315)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(255, 90, 90)
    Status.TextSize = 14
    Status.Font = Enum.Font.Gotham
    Status.Parent = Main

    -- Submit Logic
    SubmitBtn.Activated:Connect(function()
        local entered = KeyBox.Text:match("^%s*(.-)%s*$")
        for _, key in ipairs(ValidKeys) do
            if key == entered then
                
                -- NEW: Save the key to the workspace folder so they never have to type it again!
                if writefile then
                    writefile(keyFilePath, entered)
                end

                KeyGui:Destroy()
                notify("✅ Success", "Key accepted & saved! Loading tenko Void...", 4)
                loadMainGUI()
                return
            end
        end
        Status.Text = "❌ Invalid Key!"
        task.wait(2)
        Status.Text = ""
    end)

    -- Get Key Logic
    GetKeyBtn.Activated:Connect(function()
        setclipboard(DiscordLink)
        notify("📋 Copied", "Discord link copied to clipboard!\nJoin to get a key", 8)
    end)

    notify("🔑 Key System", "Enter your key or join Discord", 6)
else
    -- If key is already valid via executor script_key variable OR auto-save file
    loadMainGUI()
end
