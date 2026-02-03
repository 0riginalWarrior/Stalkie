local function performSecurityChecks()
    local executor_name, executor_version = identifyexecutor()
    
    if not executor_name then
        return false, "Unknown executor detected"
    end
    
    if not loadstring or not identifyexecutor or not writefile then
        return false, "Required functions not available"
    end
    
    return true, "Security checks passed"
end

local security_ok, security_msg = performSecurityChecks()
if not security_ok then
    game.Players.LocalPlayer:Kick("Security Check Failed: " .. security_msg)
    return
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local api
do
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
    end)
    
    if not success then
        game.Players.LocalPlayer:Kick("Failed to load Luarmor API: " .. tostring(result))
        return
    end
    
    api = result
    if not api or type(api) ~= "table" then
        game.Players.LocalPlayer:Kick("Invalid Luarmor API response")
        return
    end
end

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

local Theme = {
    Background = Color3.fromRGB(12, 12, 14),
    Secondary = Color3.fromRGB(16, 16, 18),
    Accent = Color3.fromRGB(0, 116, 224),
    AccentHover = Color3.fromRGB(0, 140, 255),
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(239, 68, 68),
    Warning = Color3.fromRGB(251, 191, 36),
    Text = Color3.fromRGB(235, 235, 235),
    TextDim = Color3.fromRGB(156, 163, 175),
    Border = Color3.fromRGB(28, 28, 32)
}

local CustomFont = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

local function Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function try_load_with_key(key)
    local executor_name, executor_version = identifyexecutor()
    
    if not key or #key ~= 32 or key:match("[^%w]") then
        return false, "Invalid key format. Keys must be 32 characters (letters/numbers only)."
    end
    
    local success, status = pcall(function()
        return api.check_key(key)
    end)
    
    if not success then
        return false, "Failed to connect to key server. Check your internet connection."
    end
    
    if status.code == "KEY_VALID" then
        if not saved_key or saved_key ~= key then
            writefile(file, key)
        end
        script_key = key
        return true, "Key verified successfully! Welcome " .. (status.data.note ~= "" and status.data.note or "user") .. "!"
    else
        local error_messages = {
            ["KEY_EXPIRED"] = "Your key has expired. Please get a new key.",
            ["KEY_BANNED"] = "Your key has been banned/blacklisted. Contact support if you believe this is an error.",
            ["KEY_HWID_LOCKED"] = "Key is linked to a different device. Use the Discord bot to reset your HWID.",
            ["KEY_INCORRECT"] = "Key not found. Please check your key and try again.",
            ["KEY_INVALID"] = "Invalid key format. Please enter a valid 32-character key.",
            ["SCRIPT_ID_INCORRECT"] = "Script configuration error. Contact the developer.",
            ["SCRIPT_ID_INVALID"] = "Script configuration error. Contact the developer.", 
            ["INVALID_EXECUTOR"] = "Unsupported executor.",
            ["SECURITY_ERROR"] = "Security validation failed. Your executor may not be supported.",
            ["TIME_ERROR"] = "System time error. Please sync your computer's clock and try again.",
            ["UNKNOWN_ERROR"] = "Server error occurred. Please try again later or contact support."
        }
        
        local error_msg = error_messages[status.code] or ("Unknown error: " .. (status.message or "No details available"))
        return false, error_msg
    end
end

local function load_main_script()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/ccd243d0572844a3c22f20b233235d5c.lua"))()
end

if saved_key then
    local success, message = try_load_with_key(saved_key)
    if success then
        load_main_script()
        return
    end
end

local Gui = Create("ScreenGui", {
    Name = "KeySystem",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = gethui and gethui() or game.Players.LocalPlayer:WaitForChild("PlayerGui")
})

local Main = Create("Frame", {
    Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    Parent = Gui
})

Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Main})
Create("UIStroke", {Color = Theme.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = Main})

local Title = Create("TextLabel", {
    Size = UDim2.new(1, -40, 0, 24),
    Position = UDim2.new(0, 20, 0, 20),
    BackgroundTransparency = 1,
    Text = "Stalkie Premium",
    FontFace = CustomFont,
    TextSize = 18,
    TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Main
})

local Subtitle = Create("TextLabel", {
    Size = UDim2.new(1, -40, 0, 16),
    Position = UDim2.new(0, 20, 0, 48),
    BackgroundTransparency = 1,
    Text = "Enter your key to continue",
    FontFace = CustomFont,
    TextSize = 13,
    TextColor3 = Theme.TextDim,
    TextTransparency = 0.3,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Main
})

local InputFrame = Create("Frame", {
    Size = UDim2.new(1, -40, 0, 36),
    Position = UDim2.new(0, 20, 0, 80),
    BackgroundColor3 = Theme.Secondary,
    BorderSizePixel = 0,
    Parent = Main
})

Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = InputFrame})
local InputStroke = Create("UIStroke", {Color = Theme.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = InputFrame})

local KeyInput = Create("TextBox", {
    Size = UDim2.new(1, -16, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    PlaceholderText = "Paste your key here...",
    PlaceholderColor3 = Theme.TextDim,
    Text = "",
    FontFace = CustomFont,
    TextSize = 13,
    TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    Parent = InputFrame
})

local ButtonFrame = Create("Frame", {
    Size = UDim2.new(1, -40, 0, 36),
    Position = UDim2.new(0, 20, 0, 128),
    BackgroundTransparency = 1,
    Parent = Main
})

local GetKeyBtn = Create("TextButton", {
    Size = UDim2.new(0.48, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Theme.Secondary,
    BorderSizePixel = 0,
    Text = "Get Key",
    FontFace = CustomFont,
    TextSize = 13,
    TextColor3 = Theme.Text,
    AutoButtonColor = false,
    Parent = ButtonFrame
})

Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = GetKeyBtn})
Create("UIStroke", {Color = Theme.Border, Thickness = 1, Parent = GetKeyBtn})

local VerifyBtn = Create("TextButton", {
    Size = UDim2.new(0.48, 0, 1, 0),
    Position = UDim2.new(0.52, 0, 0, 0),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    Text = "Verify",
    FontFace = CustomFont,
    TextSize = 13,
    TextColor3 = Theme.Text,
    AutoButtonColor = false,
    Parent = ButtonFrame
})

Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = VerifyBtn})

local StatusText = Create("TextLabel", {
    Size = UDim2.new(1, -40, 0, 32),
    Position = UDim2.new(0, 20, 0, 176),
    BackgroundTransparency = 1,
    Text = "Ready",
    FontFace = CustomFont,
    TextSize = 12,
    TextColor3 = Theme.TextDim,
    TextTransparency = 0.4,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextWrapped = true,
    Parent = Main
})

KeyInput.Focused:Connect(function()
    InputStroke.Color = Theme.Accent
end)

KeyInput.FocusLost:Connect(function()
    InputStroke.Color = Theme.Border
end)

GetKeyBtn.MouseEnter:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Border}):Play()
end)

GetKeyBtn.MouseLeave:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary}):Play()
end)

VerifyBtn.MouseEnter:Connect(function()
    TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.AccentHover}):Play()
end)

VerifyBtn.MouseLeave:Connect(function()
    TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.46, 0, 0.95, 0)}):Play()
    task.wait(0.1)
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.48, 0, 1, 0)}):Play()
    
    local Overlay = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = Main,
        ZIndex = 50
    })
    
    local Popup = Create("Frame", {
        Size = UDim2.new(1, -40, 0, 140),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Parent = Main,
        ZIndex = 51
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Popup})
    Create("UIStroke", {Color = Theme.Border, Thickness = 1, Parent = Popup})
    
    local AccentBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = Popup
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = AccentBar})
    
    local AccentCover = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = AccentBar
    })
    
    local PopupTitle = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 12, 0, 12),
        BackgroundTransparency = 1,
        Text = "Select Key Provider",
        FontFace = CustomFont,
        TextSize = 15,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Popup
    })
    
    local PopupDesc = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 28),
        Position = UDim2.new(0, 12, 0, 36),
        BackgroundTransparency = 1,
        Text = "Choose your preferred provider and complete the process",
        FontFace = CustomFont,
        TextSize = 12,
        TextColor3 = Theme.TextDim,
        TextTransparency = 0.3,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = Popup
    })
    
    local ButtonContainer = Create("Frame", {
        Size = UDim2.new(1, -24, 0, 42),
        Position = UDim2.new(0, 12, 0, 76),
        BackgroundTransparency = 1,
        Parent = Popup
    })
    
    local LinkvertiseBtn = Create("TextButton", {
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 140, 0),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = ButtonContainer
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = LinkvertiseBtn})
    
    local LinkIcon = Create("Frame", {
        Size = UDim2.new(0, 6, 0, 6),
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme.Text,
        BorderSizePixel = 0,
        Parent = LinkvertiseBtn
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = LinkIcon})
    
    local LinkLabel = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 16),
        Position = UDim2.new(0, 20, 0, 6),
        BackgroundTransparency = 1,
        Text = "Linkvertise",
        FontFace = CustomFont,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = LinkvertiseBtn
    })
    
    local LinkTime = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 12),
        Position = UDim2.new(0, 20, 0, 24),
        BackgroundTransparency = 1,
        Text = "6 hours key",
        FontFace = CustomFont,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = LinkvertiseBtn
    })
    
    local WorkinkBtn = Create("TextButton", {
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0.52, 0, 0, 0),
        BackgroundColor3 = Theme.Success,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = ButtonContainer
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = WorkinkBtn})
    
    local WorkIcon = Create("Frame", {
        Size = UDim2.new(0, 6, 0, 6),
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme.Text,
        BorderSizePixel = 0,
        Parent = WorkinkBtn
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = WorkIcon})
    
    local WorkLabel = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 16),
        Position = UDim2.new(0, 20, 0, 6),
        BackgroundTransparency = 1,
        Text = "Workink",
        FontFace = CustomFont,
        TextSize = 13,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = WorkinkBtn
    })
    
    local WorkTime = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 12),
        Position = UDim2.new(0, 20, 0, 24),
        BackgroundTransparency = 1,
        Text = "12 hours key",
        FontFace = CustomFont,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = WorkinkBtn
    })
    
    LinkvertiseBtn.MouseEnter:Connect(function()
        TweenService:Create(LinkvertiseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 120, 0)}):Play()
    end)
    
    LinkvertiseBtn.MouseLeave:Connect(function()
        TweenService:Create(LinkvertiseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 140, 0)}):Play()
    end)
    
    WorkinkBtn.MouseEnter:Connect(function()
        TweenService:Create(WorkinkBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 170, 80)}):Play()
    end)
    
    WorkinkBtn.MouseLeave:Connect(function()
        TweenService:Create(WorkinkBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Success}):Play()
    end)
    
    LinkvertiseBtn.MouseButton1Click:Connect(function()
        setclipboard("https://ads.luarmor.net/get_key?for=Stalkie_Premium_Key-tmDFuKXiJWOW")
        StatusText.Text = "Linkvertise link copied to clipboard"
        StatusText.TextColor3 = Theme.Accent
        StatusText.TextTransparency = 0
        Overlay:Destroy()
        Popup:Destroy()
    end)
    
    WorkinkBtn.MouseButton1Click:Connect(function()
        setclipboard("https://ads.luarmor.net/get_key?for=Premium_Workink-ZwXuREfbRLwQ")
        StatusText.Text = "Workink link copied to clipboard"
        StatusText.TextColor3 = Theme.Accent
        StatusText.TextTransparency = 0
        Overlay:Destroy()
        Popup:Destroy()
    end)
end)

VerifyBtn.MouseButton1Click:Connect(function()
    local input_key = KeyInput.Text:gsub("%s+", "")
    
    if input_key == "" then
        StatusText.Text = "Please enter a key"
        StatusText.TextColor3 = Theme.Error
        StatusText.TextTransparency = 0
        return
    end
    
    TweenService:Create(VerifyBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.46, 0, 0.95, 0)}):Play()
    task.wait(0.1)
    TweenService:Create(VerifyBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.48, 0, 1, 0)}):Play()
    
    StatusText.Text = "Verifying..."
    StatusText.TextColor3 = Theme.Accent
    StatusText.TextTransparency = 0
    VerifyBtn.Text = "Verifying..."
    
    task.spawn(function()
        local success, message = try_load_with_key(input_key)
        if success then
            StatusText.Text = message
            StatusText.TextColor3 = Theme.Success
            VerifyBtn.Text = "Success!"
            
            task.wait(2)
            
            StatusText.Text = "Loading script..."
            StatusText.TextColor3 = Theme.Accent
            
            task.wait(0.5)
            
            for _, element in pairs(Main:GetDescendants()) do
                if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                    TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 1
                    }):Play()
                end
                if element:IsA("Frame") or element:IsA("TextButton") then
                    TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1
                    }):Play()
                end
                if element:IsA("UIStroke") then
                    TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Transparency = 1
                    }):Play()
                end
            end
            
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            }):Play()
            
            task.wait(0.35)
            
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            task.wait(0.35)
            Gui:Destroy()
            
            load_main_script()
        else
            VerifyBtn.Text = "Verify"
            StatusText.Text = message
            StatusText.TextColor3 = Theme.Error
        end
    end)
end)

local dragging, dragStart, startPos = false, nil, nil

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 360, 0, 228)
}):Play()
