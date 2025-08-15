-- Prevent multiple executions
if _G.TrollScriptExecuted then
    warn("Troll script is already executed!")
    return
end
_G.TrollScriptExecuted = true

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local workspace = game:GetService("Workspace")

-- Wait for LocalPlayer to exist
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

-- Wait 5 seconds after loading LocalPlayer
task.wait(5)

-- Invisible Characters
local blob = "\u{000D}" -- newline
local blob2 = "\u{001E}" -- invisible character

-- Script URL for re-execution
local scriptUrl = "https://raw.githubusercontent.com/0riginalWarrior/Stalkie/refs/heads/main/up.lua"

-- Queue teleport compatibility across executors
local queueTeleport = (syn and syn.queue_on_teleport) or
                     (fluxus and fluxus.queue_on_teleport) or
                     queue_on_teleport or
                     function() warn("queue_on_teleport not supported by this executor!") end

-- Chat Function
local function chatMessage(str)
    str = tostring(str)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrollGui"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 290)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -145)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(50, 50, 60)
UIStroke.Transparency = 0.5
UIStroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Server Troll Control"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.Parent = MainFrame

local PlayerCountLabel = Instance.new("TextLabel")
PlayerCountLabel.Size = UDim2.new(1, -20, 0, 30)
PlayerCountLabel.Position = UDim2.new(0, 10, 0, 40)
PlayerCountLabel.BackgroundTransparency = 1
PlayerCountLabel.Text = "Players: " .. #Players:GetPlayers()
PlayerCountLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
PlayerCountLabel.Font = Enum.Font.Gotham
PlayerCountLabel.TextSize = 18
PlayerCountLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerCountLabel.Parent = MainFrame

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(1, -20, 0, 30)
TimerLabel.Position = UDim2.new(0, 10, 0, 70)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "Server Hop: 40s"
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
TimerLabel.Font = Enum.Font.Gotham
TimerLabel.TextSize = 18
TimerLabel.TextXAlignment = Enum.TextXAlignment.Left
TimerLabel.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Position = UDim2.new(0.25, -50, 0, 100)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
ToggleButton.Text = "Troll: ON"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 18
ToggleButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = ToggleButton

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Thickness = 1
ButtonStroke.Color = Color3.fromRGB(70, 70, 80)
ButtonStroke.Parent = ToggleButton

local HideSpectateButton = Instance.new("TextButton")
HideSpectateButton.Size = UDim2.new(0, 100, 0, 40)
HideSpectateButton.Position = UDim2.new(0.75, -50, 0, 100)
HideSpectateButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
HideSpectateButton.Text = "Hide & Spectate: ON"
HideSpectateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideSpectateButton.Font = Enum.Font.Gotham
HideSpectateButton.TextSize = 18
HideSpectateButton.Parent = MainFrame

local HideSpectateButtonCorner = Instance.new("UICorner")
HideSpectateButtonCorner.CornerRadius = UDim.new(0, 10)
HideSpectateButtonCorner.Parent = HideSpectateButton

local HideSpectateButtonStroke = Instance.new("UIStroke")
HideSpectateButtonStroke.Thickness = 1
HideSpectateButtonStroke.Color = Color3.fromRGB(70, 70, 80)
HideSpectateButtonStroke.Parent = HideSpectateButton

local ChatButton = Instance.new("TextButton")
ChatButton.Size = UDim2.new(0, 100, 0, 40)
ChatButton.Position = UDim2.new(0.5, -50, 0, 150)
ChatButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
ChatButton.Text = "Chat: OFF"
ChatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatButton.Font = Enum.Font.Gotham
ChatButton.TextSize = 18
ChatButton.Parent = MainFrame

local ChatButtonCorner = Instance.new("UICorner")
ChatButtonCorner.CornerRadius = UDim.new(0, 10)
ChatButtonCorner.Parent = ChatButton

local ChatButtonStroke = Instance.new("UIStroke")
ChatButtonStroke.Thickness = 1
ChatButtonStroke.Color = Color3.fromRGB(70, 70, 80)
ChatButtonStroke.Parent = ChatButton

local MessageButton = Instance.new("TextButton")
MessageButton.Size = UDim2.new(0, 100, 0, 40)
MessageButton.Position = UDim2.new(0.5, -50, 0, 200)
MessageButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
MessageButton.Text = "Send Msg"
MessageButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MessageButton.Font = Enum.Font.Gotham
MessageButton.TextSize = 18
MessageButton.Parent = MainFrame

local MessageButtonCorner = Instance.new("UICorner")
MessageButtonCorner.CornerRadius = UDim.new(0, 10)
MessageButtonCorner.Parent = MessageButton

local MessageButtonStroke = Instance.new("UIStroke")
MessageButtonStroke.Thickness = 1
MessageButtonStroke.Color = Color3.fromRGB(70, 70, 80)
MessageButtonStroke.Parent = MessageButton

local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(0, 200, 0, 100)
InputFrame.Position = UDim2.new(0.5, -100, 0, 240)
InputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
InputFrame.BorderSizePixel = 0
InputFrame.Parent = MainFrame
InputFrame.Visible = false

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = InputFrame

local InputStroke = Instance.new("UIStroke")
InputStroke.Thickness = 1
InputStroke.Color = Color3.fromRGB(50, 50, 60)
InputStroke.Parent = InputFrame

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -20, 0, 30)
InputBox.Position = UDim2.new(0, 10, 0, 10)
InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 16
InputBox.PlaceholderText = "Enter server message..."
InputBox.Text = ""
InputBox.Parent = InputFrame

local InputBoxCorner = Instance.new("UICorner")
InputBoxCorner.CornerRadius = UDim.new(0, 6)
InputBoxCorner.Parent = InputBox

local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(0, 80, 0, 30)
SendButton.Position = UDim2.new(0.5, -40, 0, 50)
SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
SendButton.Text = "Send"
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.Font = Enum.Font.Gotham
SendButton.TextSize = 16
SendButton.Parent = InputFrame

local SendButtonCorner = Instance.new("UICorner")
SendButtonCorner.CornerRadius = UDim.new(0, 6)
SendButtonCorner.Parent = SendButton

-- Notification System
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Size = UDim2.new(0, 200, 0, 300)
NotificationContainer.Position = UDim2.new(1, -210, 1, -310)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Padding = UDim.new(0, 5)
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationLayout.Parent = NotificationContainer

local function createNotification(text, color)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(0, 200, 0, 50)
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    NotificationFrame.BackgroundTransparency = 0.2
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Parent = NotificationContainer
    NotificationFrame.LayoutOrder = -tick()

    local NotificationCorner = Instance.new("UICorner")
    NotificationCorner.CornerRadius = UDim.new(0, 8)
    NotificationCorner.Parent = NotificationFrame

    local NotificationStroke = Instance.new("UIStroke")
    NotificationStroke.Thickness = 1
    NotificationStroke.Color = Color3.fromRGB(50, 50, 60)
    NotificationStroke.Transparency = 0.5
    NotificationStroke.Parent = NotificationFrame

    local NotificationText = Instance.new("TextLabel")
    NotificationText.Size = UDim2.new(1, -10, 1, -10)
    NotificationText.Position = UDim2.new(0, 5, 0, 5)
    NotificationText.BackgroundTransparency = 1
    NotificationText.Text = text
    NotificationText.TextColor3 = color
    NotificationText.Font = Enum.Font.Gotham
    NotificationText.TextSize = 16
    NotificationText.TextWrapped = true
    NotificationText.TextXAlignment = Enum.TextXAlignment.Left
    NotificationText.Parent = NotificationFrame

    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(NotificationFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
    task.spawn(function()
        task.wait(3)
        TweenService:Create(NotificationFrame, tweenInfo, {BackgroundTransparency = 0.8}):Play()
        task.wait(0.3)
        NotificationFrame:Destroy()
    end)
end

-- Dragging Functionality
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Message Input Logic
MessageButton.MouseButton1Click:Connect(function()
    InputFrame.Visible = not InputFrame.Visible
    if InputFrame.Visible then
        InputBox.Text = ""
        InputBox:CaptureFocus()
    end
end)

SendButton.MouseButton1Click:Connect(function()
    local message = InputBox.Text
    if message ~= "" then
        chatMessage(blob2 .. string.rep(blob, 100) .. "[Server]: " .. message)
        InputFrame.Visible = false
    end
end)

-- Anti-Lag System
local targetItemNames = {"aura", "Fluffy Satin Gloves Black", "fuzzy"}
local antiLagToggled = true

local function hasItemInName(accessory)
    if not accessory or not accessory.Name then return false end
    local accessoryName = accessory.Name:lower()
    for _, itemName in ipairs(targetItemNames) do
        if accessoryName:find(itemName:lower(), 1, true) then
            return true
        end
    end
    return false
end

local function isAccessoryOnHeadOrAbove(accessory)
    if not accessory or not accessory.Parent then return false end
    local handle = accessory:FindFirstChild("Handle")
    if handle and handle.Parent and handle.Parent.Name == "Head" then return true end
    local attachment = accessory:FindFirstChildWhichIsA("Attachment")
    if attachment and attachment.Parent and attachment.Parent.Name == "Head" then return true end
    if accessory.Parent and accessory.Parent:IsA("Model") then
        local head = accessory.Parent:FindFirstChild("Head")
        if head and handle and handle.Position.Y >= head.Position.Y then return true end
    end
    return false
end

local function removeTargetedItems(character)
    if not character or not character.Parent then return end
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Accessory") and hasItemInName(item) and not isAccessoryOnHeadOrAbove(item) then
            local success, err = pcall(function()
                item:Destroy()
                createNotification("Destroyed " .. item.Name .. " on " .. character.Name, Color3.fromRGB(255, 165, 0))
            end)
            if not success then
                warn("Failed to destroy " .. item.Name .. ": " .. tostring(err))
            end
        end
    end
end

local function continuouslyCheckItems()
    while antiLagToggled do
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr and plr.Character then
                pcall(removeTargetedItems, plr.Character)
            end
        end
        task.wait(1)
    end
end

task.spawn(continuouslyCheckItems)

-- Spectate Setup
local SpectateGui = Instance.new("ScreenGui")
SpectateGui.Name = "Spectate"
SpectateGui.Parent = playerGui
SpectateGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SpectateGui.ResetOnSpawn = false

local SpectateFrame = Instance.new("Frame")
SpectateFrame.Name = "SpectateFrame"
SpectateFrame.Parent = SpectateGui
SpectateFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpectateFrame.BackgroundTransparency = 1
SpectateFrame.BorderSizePixel = 0
SpectateFrame.Position = UDim2.new(0, 0, 0.8, 0)
SpectateFrame.Size = UDim2.new(1, 0, 0.2, 0)

local LeftButton = Instance.new("TextButton")
LeftButton.Name = "Left"
LeftButton.Parent = SpectateFrame
LeftButton.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
LeftButton.BackgroundTransparency = 0.25
LeftButton.BorderSizePixel = 0
LeftButton.Position = UDim2.new(0.183150187, 0, 0.238433674, 0)
LeftButton.Size = UDim2.new(0.0688644722, 0, 0.514322877, 0)
LeftButton.Font = Enum.Font.FredokaOne
LeftButton.Text = "<"
LeftButton.TextColor3 = Color3.fromRGB(0, 0, 0)
LeftButton.TextScaled = true

local RightButton = Instance.new("TextButton")
RightButton.Name = "Right"
RightButton.Parent = SpectateFrame
RightButton.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
RightButton.BackgroundTransparency = 0.25
RightButton.BorderSizePixel = 0
RightButton.Position = UDim2.new(0.747985363, 0, 0.238433674, 0)
RightButton.Size = UDim2.new(0.0688644722, 0, 0.514322877, 0)
RightButton.Font = Enum.Font.FredokaOne
RightButton.Text = ">"
RightButton.TextColor3 = Color3.fromRGB(0, 0, 0)
RightButton.TextScaled = true

local PlayerDisplay = Instance.new("TextLabel")
PlayerDisplay.Name = "PlayerDisplay"
PlayerDisplay.Parent = SpectateFrame
PlayerDisplay.BackgroundTransparency = 1
PlayerDisplay.Position = UDim2.new(0.252014756, 0, 0.238433674, 0)
PlayerDisplay.Size = UDim2.new(0.495970696, 0, 0.514322877, 0)
PlayerDisplay.Font = Enum.Font.FredokaOne
PlayerDisplay.Text = "<player>"
PlayerDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerDisplay.TextScaled = true

local PlayerIndex = Instance.new("NumberValue")
PlayerIndex.Name = "PlayerIndex"
PlayerIndex.Parent = SpectateFrame
PlayerIndex.Value = 1

local UIStroke1 = Instance.new("UIStroke")
UIStroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke1.Thickness = 5
UIStroke1.Parent = LeftButton

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Thickness = 5
UIStroke2.Parent = RightButton

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
UIStroke3.Thickness = 5
UIStroke3.Parent = PlayerDisplay

local allPlayers = {}
local currentSpectateTarget = nil
local spectating = false
local cam = workspace.CurrentCamera

local function updatePlayers(leavingPlayer)
    local oldPlayers = allPlayers
    allPlayers = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(allPlayers, plr)
        end
    end
    
    if spectating and #allPlayers > 0 then
        if leavingPlayer and leavingPlayer == currentSpectateTarget then
            local oldIndex = PlayerIndex.Value
            PlayerIndex.Value = math.clamp(oldIndex, 1, #allPlayers)
            currentSpectateTarget = allPlayers[PlayerIndex.Value]
        else
            local newIndex = table.find(allPlayers, currentSpectateTarget)
            if newIndex then
                PlayerIndex.Value = newIndex
            else
                PlayerIndex.Value = math.clamp(PlayerIndex.Value, 1, #allPlayers)
                currentSpectateTarget = allPlayers[PlayerIndex.Value]
            end
        end
    elseif #allPlayers == 0 then
        PlayerIndex.Value = 1
        currentSpectateTarget = nil
    elseif PlayerIndex.Value > #allPlayers then
        PlayerIndex.Value = #allPlayers
        currentSpectateTarget = allPlayers[PlayerIndex.Value]
    end
end
updatePlayers()

Players.PlayerAdded:Connect(function() updatePlayers() end)
Players.PlayerRemoving:Connect(function(player) updatePlayers(player) end)

local function onPress(skip)
    if #allPlayers == 0 then return end
    local newIndex = PlayerIndex.Value + skip
    if newIndex > #allPlayers then
        PlayerIndex.Value = 1
    elseif newIndex < 1 then
        PlayerIndex.Value = #allPlayers
    else
        PlayerIndex.Value = newIndex
    end
    currentSpectateTarget = allPlayers[PlayerIndex.Value]
end

LeftButton.MouseButton1Click:Connect(function() onPress(-1) end)
RightButton.MouseButton1Click:Connect(function() onPress(1) end)

RunService.RenderStepped:Connect(function()
    if spectating and #allPlayers > 0 then
        local targetPlayer = allPlayers[PlayerIndex.Value]
        if targetPlayer and targetPlayer.Character then
            cam.CameraSubject = targetPlayer.Character:WaitForChild("Humanoid", 5)
            PlayerDisplay.Text = targetPlayer.Name
            currentSpectateTarget = targetPlayer
        end
    elseif not spectating then
        if player.Character then
            cam.CameraSubject = player.Character:WaitForChild("Humanoid", 5)
            PlayerDisplay.Text = player.Name
        end
    end
end)

local function updateStrokeThickness()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local scaleFactor = screenSize.X / 1920
    UIStroke1.Thickness = 5 * scaleFactor * 1.25
    UIStroke2.Thickness = 5 * scaleFactor * 1.25
    UIStroke3.Thickness = 5 * scaleFactor * 1.25
end
RunService.RenderStepped:Connect(updateStrokeThickness)

-- Player List Update for Notifications
local currentPlayers = {}
local function updateCurrentPlayers()
    currentPlayers = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(currentPlayers, plr)
        end
    end
    PlayerCountLabel.Text = "Players: " .. #Players:GetPlayers()
end

Players.PlayerAdded:Connect(function(plr)
    updateCurrentPlayers()
    createNotification(plr.Name .. " joined", Color3.fromRGB(100, 255, 100))
end)

Players.PlayerRemoving:Connect(function(plr)
    updateCurrentPlayers()
    createNotification(plr.Name .. " left", Color3.fromRGB(255, 100, 100))
end)

-- Avatar Copying and Tool Acquisition
local function copyAvatarAndGetTools()
    local success, err = pcall(function()
        local Event = ReplicatedStorage:FindFirstChild("EventInputModify")
        if Event then
            Event:FireServer("24k_mxtty1")
            createNotification("Copied avatar of 24k_mxtty1", Color3.fromRGB(100, 255, 100))
        else
            error("EventInputModify not found")
        end
    end)
    if not success then
        warn("Failed to copy avatar: " .. tostring(err))
        createNotification("Failed to copy avatar: " .. tostring(err), Color3.fromRGB(255, 100, 100))
    end

    local tools = {
        "DangerCarot",
        "DangerBlowDryer",
        "DangerPistol",
        "FoodBloxi",
        "DangerSpray",
        "FoodPizza",
        "FoodChocolate"
    }
    for _, toolName in ipairs(tools) do
        local success, err = pcall(function()
            local Event = ReplicatedStorage:FindFirstChild("Tool")
            if Event then
                Event:FireServer(toolName)
                createNotification("Acquired tool: " .. toolName, Color3.fromRGB(100, 255, 100))
            else
                error("Tool event not found")
            end
        end)
        if not success then
            warn("Failed to acquire tool " .. toolName .. ": " .. tostring(err))
            createNotification("Failed to acquire " .. toolName .. ": " .. tostring(err), Color3.fromRGB(255, 100, 100))
        end
        task.wait(0.1)
    end
end

-- Troll Logic
local trollActive = true
local chatActive = false
local seriousMessages = {
    "[Server]: Mining Crypto, The longer you stay the richer i get.",
    "[Server]: Your device is forced to mine crypto.",
    "[Server]: Your device is going to explode. Leave now",
    "[Server]: Using all resources to harm your device",
    "[Server]: Your device is controlled for crypto mining."
}

local function toolLoop()
    -- Send the lag warning message before starting the loop
    if trollActive then
        chatMessage(blob2 .. string.rep(blob, 100) .. "[Server]: LAGGING SERVER, TO STOP IT FRIEND qsvett ON D")
        task.wait(0.5) -- Small delay to ensure the message is sent before lagging starts
    end
    while trollActive do
        local backpack = player.Backpack
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid and backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    humanoid:EquipTool(tool)
                    task.wait()
                end
            end
            humanoid:UnequipTools()
            task.wait()
        else
            task.wait(0.1)
        end
    end
end

task.spawn(function()
    copyAvatarAndGetTools()
    task.wait(1)
    task.spawn(toolLoop)
end)

-- Teleport to Specified Position
local targetCFrame = CFrame.new(
    760.117676, 870.643982, -182.766724,
    -0.050356254, -6.86984336e-08, 0.998731315,
    -2.93581652e-11, 1, 6.87842174e-08,
    -0.998731315, 3.43439477e-09, -0.050356254
)

local function teleportToPosition()
    local character = player.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = targetCFrame
            createNotification("Teleported to specified position!", Color3.fromRGB(100, 255, 100))
        end
    end
end

-- Timer Logic
local timeRemaining = 40
local function startTimer(initialTime, onComplete)
    timeRemaining = initialTime or 40
    TimerLabel.Text = "Server Hop: " .. math.ceil(timeRemaining) .. "s"
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        timeRemaining = timeRemaining - RunService.Heartbeat:Wait()
        if timeRemaining <= 0 then
            connection:Disconnect()
            TimerLabel.Text = "Server Hop: Now"
            if onComplete then
                onComplete()
            end
        else
            TimerLabel.Text = "Server Hop: " .. math.ceil(timeRemaining) .. "s"
        end
    end)
    
    return connection
end

-- Server Hop Function with Infinite Retry
local function serverHop()
    local attempt = 1
    local timerConnection
    local baseDelay = 3

    local function attemptHop()
        local originalJobId = game.JobId
        createNotification("Fetching servers (Attempt " .. attempt .. ")...", Color3.fromRGB(255, 165, 0))
        local servers = {}
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if success and response and response.data then
            for _, v in pairs(response.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end
        else
            createNotification("Failed to fetch servers. Retrying in " .. baseDelay * attempt .. "s...", Color3.fromRGB(255, 100, 100))
            if timerConnection then timerConnection:Disconnect() end
            timerConnection = startTimer(baseDelay * attempt, attemptHop)
            attempt = attempt + 1
            return
        end

        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            createNotification("Attempting to join server " .. randomServer .. "...", Color3.fromRGB(255, 165, 0))
            
            local queueSuccess, queueError = pcall(function()
                queueTeleport([[
                    loadstring(game:HttpGet("]] .. scriptUrl .. [["))()
                ]])
            end)
            if queueSuccess then
                createNotification("Script queued for re-execution!", Color3.fromRGB(100, 255, 100))
            else
                createNotification("Failed to queue script: " .. tostring(queueError), Color3.fromRGB(255, 100, 100))
                warn("Queue teleport failed: " .. tostring(queueError))
            end

            local success, result = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, player)
            end)
            if not success then
                createNotification("Teleport failed: " .. tostring(result) .. ". Retrying in " .. baseDelay * attempt .. "s...", Color3.fromRGB(255, 100, 100))
                if timerConnection then timerConnection:Disconnect() end
                timerConnection = startTimer(baseDelay * attempt, attemptHop)
                attempt = attempt + 1
            else
                task.wait(3)
                if game.JobId == originalJobId then
                    createNotification("Server full or failed to join. Retrying in " .. baseDelay * attempt .. "s...", Color3.fromRGB(255, 100, 100))
                    if timerConnection then timerConnection:Disconnect() end
                    timerConnection = startTimer(baseDelay * attempt, attemptHop)
                    attempt = attempt + 1
                else
                    createNotification("Successfully joined new server!", Color3.fromRGB(100, 255, 100))
                    if timerConnection then timerConnection:Disconnect() end
                    TimerLabel.Text = "Server Hop: Success"
                end
            end
        else
            createNotification("No available servers. Retrying in " .. baseDelay * attempt .. "s...", Color3.fromRGB(255, 100, 100))
            if timerConnection then timerConnection:Disconnect() end
            timerConnection = startTimer(baseDelay * attempt, attemptHop)
            attempt = attempt + 1
        end
    end

    attemptHop()
end

startTimer(40, serverHop)

player.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Started then
        local success, err = pcall(function()
            queueTeleport([[
                loadstring(game:HttpGet("]] .. scriptUrl .. [["))()
            ]])
        end)
        if success then
            createNotification("Script queued for teleport!", Color3.fromRGB(100, 255, 100))
        else
            warn("Teleport queue failed: " .. tostring(err))
            createNotification("Failed to queue script for teleport: " .. tostring(err), Color3.fromRGB(255, 100, 100))
        end
    end
end)

-- Button Connections
ToggleButton.MouseButton1Click:Connect(function()
    trollActive = not trollActive
    if trollActive then
        updateCurrentPlayers()
        copyAvatarAndGetTools()
        task.spawn(toolLoop)
        if chatActive then
            local randomMessage = seriousMessages[math.random(1, #seriousMessages)]
            chatMessage(blob2 .. string.rep(blob, 100) .. randomMessage)
        end
        ToggleButton.Text = "Troll: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        ToggleButton.Text = "Troll: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

local hideSpectateActive = true
spectating = true -- Initialize spectating as true
SpectateFrame.Visible = true -- Ensure Spectate GUI is visible at start

local function toggleHideSpectate()
    hideSpectateActive = not hideSpectateActive
    if hideSpectateActive then
        updateCurrentPlayers()
        teleportToPosition()
        spectating = true
        SpectateFrame.Visible = true
        HideSpectateButton.Text = "Hide & Spectate: ON"
        HideSpectateButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        spectating = false
        SpectateFrame.Visible = false
        local character = player.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = CFrame.new(0, 50, 0)
            end
        end
        HideSpectateButton.Text = "Hide & Spectate: OFF"
        HideSpectateButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    end
end

HideSpectateButton.MouseButton1Click:Connect(toggleHideSpectate)

ChatButton.MouseButton1Click:Connect(function()
    chatActive = not chatActive
    if chatActive then
        ChatButton.Text = "Chat: ON"
        ChatButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        ChatButton.Text = "Chat: OFF"
        ChatButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    end
end)

-- Initial Setup
updateCurrentPlayers()
teleportToPosition() -- Initial teleport
