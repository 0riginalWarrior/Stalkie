local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local UI_CONFIG = {
    MainColor = Color3.fromRGB(22, 22, 24),
    SecondaryColor = Color3.fromRGB(30, 30, 34),
    AccentColor = Color3.fromRGB(56, 189, 248),
    ErrorColor = Color3.fromRGB(239, 68, 68),
    SuccessColor = Color3.fromRGB(34, 197, 94),
    WarningColor = Color3.fromRGB(251, 191, 36),
    TextColor = Color3.fromRGB(248, 250, 252),
    SubTextColor = Color3.fromRGB(148, 163, 184),
    BorderColor = Color3.fromRGB(51, 65, 85),
    HoverColor = Color3.fromRGB(40, 40, 46),
    Font = Enum.Font.GothamMedium,
    HeaderFont = Enum.Font.GothamBold,
    TextSize = 14,
    TitleSize = 18,
    SubTextSize = 12,
    CornerRadius = UDim.new(0, 8),
    WindowCornerRadius = UDim.new(0, 12),
    BorderSize = 1,
    Padding = 12,
}

local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
api.script_id = "ccd243d0572844a3c22f20b233235d5c"

local folder = "SPremium"
local file = folder .. "/key.txt"
local saved_key = nil

if isfolder(folder) then
    if isfile(file) then
        saved_key = readfile(file)
    end
else
    makefolder(folder)
end

local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function ApplyCorner(instance, radius)
    local corner = CreateInstance("UICorner", {
        CornerRadius = radius or UI_CONFIG.CornerRadius
    })
    corner.Parent = instance
    return corner
end

local function ApplyStroke(instance, color, thickness)
    local stroke = CreateInstance("UIStroke", {
        Color = color or UI_CONFIG.BorderColor,
        Thickness = thickness or UI_CONFIG.BorderSize,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    stroke.Parent = instance
    return stroke
end

local function try_load_with_key(key)
    local status = api.check_key(key)
    if status.code == "KEY_VALID" then
        if not saved_key or saved_key ~= key then
            writefile(file, key)
        end
        script_key = key
        return true
    else
        return false
    end
end

local function load_main_script()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/ccd243d0572844a3c22f20b233235d5c.lua"))()
end

if saved_key and try_load_with_key(saved_key) then
    load_main_script()
    return
end

local player = game.Players.LocalPlayer
local gui = CreateInstance("ScreenGui", {
    Name = "KeySystemGui",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    Parent = player:WaitForChild("PlayerGui")
})

local frame = CreateInstance("Frame", {
    Size = isMobile and UDim2.new(0, 320, 0, 280) or UDim2.new(0, 400, 0, 320),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = UI_CONFIG.MainColor,
    BorderSizePixel = 0,
    Parent = gui
})

ApplyCorner(frame, UI_CONFIG.WindowCornerRadius)
ApplyStroke(frame, UI_CONFIG.BorderColor, 2)

local header = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundColor3 = UI_CONFIG.SecondaryColor,
    BorderSizePixel = 0,
    Parent = frame
})

ApplyCorner(header, UI_CONFIG.WindowCornerRadius)

local bottomCover = CreateInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 1, -25),
    BackgroundColor3 = UI_CONFIG.SecondaryColor,
    BorderSizePixel = 0,
    Parent = header
})

local title = CreateInstance("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 20, 0, 0),
    BackgroundTransparency = 1,
    Text = " Stalkie Premium Key System",
    Font = UI_CONFIG.HeaderFont,
    TextSize = isMobile and 16 or UI_CONFIG.TitleSize,
    TextColor3 = UI_CONFIG.AccentColor,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = header
})

local subtitle = CreateInstance("TextLabel", {
    Size = UDim2.new(1, -40, 0, 20),
    Position = UDim2.new(0, 20, 0, 65),
    BackgroundTransparency = 1,
    Text = "Please enter your premium key to continue",
    Font = UI_CONFIG.Font,
    TextSize = UI_CONFIG.SubTextSize,
    TextColor3 = UI_CONFIG.SubTextColor,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = frame
})

local inputContainer = CreateInstance("Frame", {
    Size = UDim2.new(1, -40, 0, 40),
    Position = UDim2.new(0, 20, 0, 95),
    BackgroundColor3 = UI_CONFIG.SecondaryColor,
    BorderSizePixel = 0,
    Parent = frame
})

ApplyCorner(inputContainer, UI_CONFIG.CornerRadius)
ApplyStroke(inputContainer, UI_CONFIG.BorderColor, 1)

local keyInput = CreateInstance("TextBox", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    PlaceholderText = "Enter your key here...",
    PlaceholderColor3 = UI_CONFIG.SubTextColor,
    Text = "",
    Font = UI_CONFIG.Font,
    TextSize = UI_CONFIG.TextSize,
    TextColor3 = UI_CONFIG.TextColor,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = inputContainer
})

local buttonContainer = CreateInstance("Frame", {
    Size = UDim2.new(1, -40, 0, 40),
    Position = UDim2.new(0, 20, 0, 155),
    BackgroundTransparency = 1,
    Parent = frame
})

local getKeyButton = CreateInstance("TextButton", {
    Size = UDim2.new(0.48, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = UI_CONFIG.AccentColor,
    BorderSizePixel = 0,
    Text = " Get Key",
    Font = UI_CONFIG.HeaderFont,
    TextSize = UI_CONFIG.TextSize,
    TextColor3 = UI_CONFIG.TextColor,
    AutoButtonColor = false,
    Parent = buttonContainer
})

ApplyCorner(getKeyButton, UI_CONFIG.CornerRadius)

local verifyButton = CreateInstance("TextButton", {
    Size = UDim2.new(0.48, 0, 1, 0),
    Position = UDim2.new(0.52, 0, 0, 0),
    BackgroundColor3 = UI_CONFIG.SuccessColor,
    BorderSizePixel = 0,
    Text = " Verify Key",
    Font = UI_CONFIG.HeaderFont,
    TextSize = UI_CONFIG.TextSize,
    TextColor3 = UI_CONFIG.TextColor,
    AutoButtonColor = false,
    Parent = buttonContainer
})

ApplyCorner(verifyButton, UI_CONFIG.CornerRadius)

local statusLabel = CreateInstance("TextLabel", {
    Size = UDim2.new(1, -40, 0, 60),
    Position = UDim2.new(0, 20, 0, 210),
    BackgroundTransparency = 1,
    Text = "Ready to verify your key",
    Font = UI_CONFIG.Font,
    TextSize = UI_CONFIG.SubTextSize,
    TextColor3 = UI_CONFIG.SubTextColor,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    Parent = frame
})

getKeyButton.MouseEnter:Connect(function()
    TweenService:Create(getKeyButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(45, 152, 200)
    }):Play()
end)

getKeyButton.MouseLeave:Connect(function()
    TweenService:Create(getKeyButton, TweenInfo.new(0.2), {
        BackgroundColor3 = UI_CONFIG.AccentColor
    }):Play()
end)

verifyButton.MouseEnter:Connect(function()
    TweenService:Create(verifyButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(22, 163, 74)
    }):Play()
end)

verifyButton.MouseLeave:Connect(function()
    TweenService:Create(verifyButton, TweenInfo.new(0.2), {
        BackgroundColor3 = UI_CONFIG.SuccessColor
    }):Play()
end)

keyInput.Focused:Connect(function()
    ApplyStroke(inputContainer, UI_CONFIG.AccentColor, 2)
end)

keyInput.FocusLost:Connect(function()
    ApplyStroke(inputContainer, UI_CONFIG.BorderColor, 1)
end)

getKeyButton.MouseButton1Click:Connect(function()
    TweenService:Create(getKeyButton, TweenInfo.new(0.1), {
        Size = UDim2.new(0.46, 0, 0.9, 0)
    }):Play()
    
    task.wait(0.1)
    
    TweenService:Create(getKeyButton, TweenInfo.new(0.1), {
        Size = UDim2.new(0.48, 0, 1, 0)
    }):Play()
    
    setclipboard("https://ads.luarmor.net/get_key?for=Stalkie_Premium_Key-tmDFuKXiJWOW")
    statusLabel.Text = "Link copied! Complete the key process and paste your key above."
    statusLabel.TextColor3 = UI_CONFIG.AccentColor
end)

verifyButton.MouseButton1Click:Connect(function()
    local input_key = keyInput.Text:gsub("%s+", "")
    
    if input_key == "" then
        statusLabel.Text = "Please enter your key in the field above."
        statusLabel.TextColor3 = UI_CONFIG.WarningColor
        return
    end
    
    TweenService:Create(verifyButton, TweenInfo.new(0.1), {
        Size = UDim2.new(0.46, 0, 0.9, 0)
    }):Play()
    
    task.wait(0.1)
    
    TweenService:Create(verifyButton, TweenInfo.new(0.1), {
        Size = UDim2.new(0.48, 0, 1, 0)
    }):Play()
    
    statusLabel.Text = "Verifying key... Please wait."
    statusLabel.TextColor3 = UI_CONFIG.AccentColor
    verifyButton.Text = " Verifying..."
    
    task.spawn(function()
        if try_load_with_key(input_key) then
            statusLabel.Text = "Key verified successfully! Loading script..."
            statusLabel.TextColor3 = UI_CONFIG.SuccessColor
            
            task.wait(1)
            
            if gui and gui.Parent then
                gui:Destroy()
            end
            
            task.wait(0.1) 
            load_main_script()
        else
            verifyButton.Text = " Verify Key"
            statusLabel.Text = "Key verification failed. Please check your key and try again."
            statusLabel.TextColor3 = UI_CONFIG.ErrorColor
        end
    end)
end)

local dragging = false
local dragStart = nil
local startPos = nil

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

frame.Size = UDim2.new(0, 0, 0, 0)
local entrance = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = isMobile and UDim2.new(0, 320, 0, 280) or UDim2.new(0, 400, 0, 320)
})
entrance:Play()
