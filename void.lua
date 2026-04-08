--// 6lol8 Void - API Key System (Connects to Wispbyte)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--// ==================== CONFIGURATION ====================
local DiscordLink = "https://discord.gg/EYpFQQBhAd"
local apiUrl = "http://87.106.155.7:10486/check_key?key=" -- ← CHANGE THIS!

--// ==================== WORKSPACE AUTO-SAVE LOGIC ====================
local keyValid = false
local folderName = "6lol8Void"
local keyFilePath = folderName .. "/key.txt"

if isfolder and makefolder and not isfolder(folderName) then
    makefolder(folderName)
end

-- Function to check key against Wispbyte API
local function checkKeyWithAPI(enteredKey)
    if not enteredKey or enteredKey == "" then return false end
    
    local success, response = pcall(function()
        return HttpService:GetAsync(apiUrl .. enteredKey)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        return data.valid == true
    end
    return false
end

-- Notification Function
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5,
    })
end

-- Try loading saved key first
local savedKey = nil
if isfile and readfile and isfile(keyFilePath) then
    savedKey = readfile(keyFilePath):match("^%s*(.-)%s*$")
end

-- Auto-verify if script_key or savedKey exists
local keyToCheck = script_key or savedKey
if keyToCheck and checkKeyWithAPI(keyToCheck) then
    keyValid = true
end

--// ==================== MAIN 6LOL8 GUI ====================
local function loadMainGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Void6lol8"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 270, 0, 220)
    MainFrame.Position = UDim2.new(1, -290, 1, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(120, 85, 255)
    MainStroke.Thickness = 1.6

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 46)
    TitleBar.BackgroundColor3 = Color3.fromRGB(18, 16, 32)
    TitleBar.Parent = MainFrame
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 14)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "6lol8 void"
    TitleLabel.TextColor3 = Color3.fromRGB(240, 210, 255)
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, -30, 0, 68)
    ToggleButton.Position = UDim2.new(0, 15, 0, 105)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(85, 55, 190)
    ToggleButton.Text = "START VOIDING"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 20
    ToggleButton.Parent = MainFrame
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 12)

    local isVoiding = false
    local connection = nil

    ToggleButton.Activated:Connect(function()
        isVoiding = not isVoiding
        if isVoiding then
            ToggleButton.Text = "STOP VOIDING"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 70)
            connection = RunService.Heartbeat:Connect(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -2e22) -- Simple Void Logic
                end
            end)
        else
            ToggleButton.Text = "START VOIDING"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(85, 55, 190)
            if connection then connection:Disconnect() end
        end
    end)

    notify("✅ 6lol8 Void", "Loaded successfully!", 5)
end

--// ==================== KEY SYSTEM GUI ====================
if not keyValid then
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KeySystem"
    KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 320, 0, 360)
    Main.Position = UDim2.new(0.5, -160, 0.5, -180)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Main.Active = true
    Main.Draggable = true
    Main.Parent = KeyGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -40, 0, 50)
    KeyBox.Position = UDim2.new(0, 20, 0, 110)
    KeyBox.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    KeyBox.PlaceholderText = "Enter key here..."
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.TextSize = 18
    KeyBox.Parent = Main
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 10)

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(1, -40, 0, 55)
    SubmitBtn.Position = UDim2.new(0, 20, 0, 175)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(85, 55, 190)
    SubmitBtn.Text = "SUBMIT KEY"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 20
    SubmitBtn.Parent = Main
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 12)

    SubmitBtn.Activated:Connect(function()
        local entered = KeyBox.Text:gsub("%s+", "")
        if checkKeyWithAPI(entered) then
            if writefile then writefile(keyFilePath, entered) end
            KeyGui:Destroy()
            loadMainGUI()
        else
            notify("❌ Error", "Invalid or Expired Key!", 3)
        end
    end)
else
    loadMainGUI()
end
