local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InveriumLoader"
screenGui.DisplayOrder = 999
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- === ВСТУПИТЕЛЬНАЯ ЗАСТАВКА (WELCOME TO INVERRIUM) ===
local welcomeFrame = Instance.new("Frame", screenGui)
welcomeFrame.Size = UDim2.new(0.35, 0, 0.15, 0)
welcomeFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
welcomeFrame.AnchorPoint = Vector2.new(0.5, 0.5)
welcomeFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
welcomeFrame.BorderSizePixel = 0
welcomeFrame.BackgroundTransparency = 1
welcomeFrame.ZIndex = 5

Instance.new("UICorner", welcomeFrame).CornerRadius = UDim.new(0, 16)

local welcomeStroke = Instance.new("UIStroke", welcomeFrame)
welcomeStroke.Color = Color3.fromRGB(255, 100, 150)
welcomeStroke.Transparency = 1
welcomeStroke.Thickness = 1.5

local welcomeText = Instance.new("TextLabel", welcomeFrame)
welcomeText.Size = UDim2.new(1, 0, 1, 0)
welcomeText.Position = UDim2.new(0, 0, 0, 0)
welcomeText.Text = "Welcome to Inverium"
welcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeText.Font = Enum.Font.GothamBold
welcomeText.TextSize = 18
welcomeText.BackgroundTransparency = 1
welcomeText.TextTransparency = 1
welcomeText.ZIndex = 6

-- === ОСНОВНОЕ МЕНЮ ===
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0.35, 0, 0.23, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BackgroundTransparency = 1
mainFrame.Visible = false -- Скрыто до конца интро
mainFrame.ZIndex = 2
mainFrame.ClipsDescendants = true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

local mainAspect = Instance.new("UIAspectRatioConstraint", mainFrame)
mainAspect.AspectRatio = 2.1
mainAspect.DominantAxis = Enum.DominantAxis.Height

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(255, 100, 150)
mainStroke.Transparency = 1
mainStroke.Thickness = 1.5

local bgContainer = Instance.new("Frame", mainFrame)
bgContainer.Size = UDim2.new(1, 0, 1, 0)
bgContainer.BackgroundTransparency = 1
bgContainer.ZIndex = 3

local function spawnParticle()
    if not mainFrame.Parent then return end
    local p = Instance.new("Frame", bgContainer)
    local size = math.random(4, 7)
    p.Size = UDim2.new(0, size, 0, size)
    local startX = math.random()
    p.Position = UDim2.new(startX, 0, 1.1, 0)
    p.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
    p.BackgroundTransparency = math.random(2, 6) / 10
    p.BorderSizePixel = 0
    p.ZIndex = 3
    Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
    
    local duration = math.random(3, 5)
    local endX = startX + (math.random() - 0.5) * 0.2
    
    local tween = TweenService:Create(p, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Position = UDim2.new(endX, 0, -0.1, 0),
        BackgroundTransparency = 1
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        p:Destroy()
        spawnParticle()
    end)
end

local function startParticles()
    for i = 1, 12 do
        task.delay(math.random() * 2, spawnParticle)
    end
end

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0.25, 0)
title.Position = UDim2.new(0, 0, 0.05, 0)
title.Text = "Select your platform"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.BackgroundTransparency = 1
title.TextTransparency = 1
title.ZIndex = 4

local isClosing = false
local function fadeOutAndLoad(url)
    if isClosing then return end
    isClosing = true

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(mainStroke, tweenInfo, {Transparency = 1}):Play()
    TweenService:Create(title, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(bgContainer, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()

    for _, child in pairs(mainFrame:GetChildren()) do
        if child:IsA("TextButton") then
            TweenService:Create(child, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            local stroke = child:FindFirstChildOfClass("UIStroke")
            if stroke then
                TweenService:Create(stroke, tweenInfo, {Transparency = 1}):Play()
            end
        end
    end

    task.wait(0.6)
    screenGui:Destroy()
    loadstring(game:HttpGet(url))()
end

local function createButton(name, posX, targetUrl)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.42, 0, 0.52, 0)
    btn.Position = UDim2.new(posX, 0, 0.36, 0)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.ZIndex = 4
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(40, 40, 40)
    stroke.Thickness = 1
    
    -- Плавные анимации при наведении и нажатии
    btn.MouseEnter:Connect(function()
        if isClosing then return end
        TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Size = UDim2.new(0.44, 0, 0.54, 0)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(255, 100, 150)}):Play()
    end)

    btn.MouseLeave:Connect(function()
        if isClosing then return end
        TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            BackgroundColor3 = Color3.fromRGB(22, 22, 22),
            Size = UDim2.new(0.42, 0, 0.52, 0)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 40)}):Play()
    end)

    btn.MouseButton1Down:Connect(function()
        if isClosing then return end
        TweenService:Create(btn, TweenInfo.new(0.1), {
            Size = UDim2.new(0.40, 0, 0.48, 0)
        }):Play()
    end)

    btn.MouseButton1Up:Connect(function()
        if isClosing then return end
        TweenService:Create(btn, TweenInfo.new(0.1), {
            Size = UDim2.new(0.44, 0, 0.54, 0)
        }):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        fadeOutAndLoad(targetUrl)
    end)
    
    return btn
end

local mobileBtn = createButton("Mobile", 0.05, "https://raw.githubusercontent.com/ula537792-png/mobile-fps-one-tab/refs/heads/main/fps%20one%20tab%20mobile.lua")
local pcBtn = createButton("PC", 0.53, "https://raw.githubusercontent.com/ula537792-png/one-tab/refs/heads/main/%5BFPS%5D%20One%20Tab.lua")

-- === ПОСЛЕДОВАТЕЛЬНОСТЬ АНИМАЦИИ ===
task.spawn(function()
    local introInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    -- 1. Появление приветствия
    TweenService:Create(welcomeFrame, introInfo, {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(welcomeStroke, introInfo, {Transparency = 0.4}):Play()
    TweenService:Create(welcomeText, introInfo, {TextTransparency = 0}):Play()
    
    task.wait(1.8) -- Время показа надписи
    
    -- 2. Исчезновение приветствия
    local outroInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(welcomeFrame, outroInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(welcomeStroke, outroInfo, {Transparency = 1}):Play()
    TweenService:Create(welcomeText, outroInfo, {TextTransparency = 1}):Play()
    
    task.wait(0.5)
    welcomeFrame:Destroy()
    
    -- 3. Плавное появление основного меню
    mainFrame.Visible = true
    startParticles()
    
    local mainTweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(mainFrame, mainTweenInfo, {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(mainStroke, mainTweenInfo, {Transparency = 0.4}):Play()
    TweenService:Create(title, mainTweenInfo, {TextTransparency = 0}):Play()
end)
