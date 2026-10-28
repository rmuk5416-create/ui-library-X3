-- [[ X3 6/1 UI Library - Core Template ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ลบ UI เก่าหากมีอยู่แล้ว
if CoreGui:FindFirstChild("X3_61_Library") then
    CoreGui.X3_61_Library:Destroy()
end

-- ลิงก์รูปภาพโลโก้และพื้นหลัง
local logoUrl = "https://i.postimg.cc/wTdtFfFg/Screenshot-2026-10-28-17-11-39-33.png"
local bgUrl = "https://i.postimg.cc/HstHQBVn/Screenshot-2026-10-28-18-12-34-88.png"

local logoFileName = "x3_hub_logo.png"
local bgFileName = "x3_hub_bg_new.png"

pcall(function()
    if not isfile(logoFileName) then
        writefile(logoFileName, game:HttpGet(logoUrl))
    end
    if not isfile(bgFileName) then
        writefile(bgFileName, game:HttpGet(bgUrl))
    end
end)

local logoAsset = ""
local bgAsset = ""
pcall(function()
    logoAsset = getcustomasset(logoFileName)
    bgAsset = getcustomasset(bgFileName)
end)

-- ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "X3_61_Library"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ปุ่มโลโก้ลอยด้านนอก
local ExternalLogoBtn = Instance.new("ImageButton")
ExternalLogoBtn.Name = "ExternalLogoBtn"
ExternalLogoBtn.Size = UDim2.new(0, 52, 0, 52)
ExternalLogoBtn.Position = UDim2.new(0, 25, 0.5, -26)
ExternalLogoBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ExternalLogoBtn.BorderSizePixel = 0
ExternalLogoBtn.Draggable = true
ExternalLogoBtn.Image = logoAsset ~= "" and logoAsset or ""
ExternalLogoBtn.Parent = ScreenGui

local ExternalLogoCorner = Instance.new("UICorner")
ExternalLogoCorner.CornerRadius = UDim.new(0, 12)
ExternalLogoCorner.Parent = ExternalLogoBtn

local ExternalLogoStroke = Instance.new("UIStroke")
ExternalLogoStroke.Color = Color3.fromRGB(200, 30, 40)
ExternalLogoStroke.Thickness = 1.5
ExternalLogoStroke.Parent = ExternalLogoBtn

-- หน้าต่างหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 260)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- พื้นหลังรูปภาพหน้าต่างหลัก
local BgImage = Instance.new("ImageLabel")
BgImage.Name = "BgImage"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = bgAsset ~= "" and bgAsset or ""
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ZIndex = 0
BgImage.Parent = MainFrame

local BgOverlay = Instance.new("Frame")
BgOverlay.Size = UDim2.new(1, 0, 1, 0)
BgOverlay.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
BgOverlay.BackgroundTransparency = 0.35
BgOverlay.BorderSizePixel = 0
BgOverlay.ZIndex = 0
BgOverlay.Parent = MainFrame
Instance.new("UICorner", BgOverlay).CornerRadius = UDim.new(0, 14)

-- กรอบเรืองแสงสีแดงวิ่งวน
local GlowStroke = Instance.new("UIStroke")
GlowStroke.Color = Color3.fromRGB(255, 30, 30)
GlowStroke.Thickness = 2
GlowStroke.Parent = MainFrame

task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            local t = tick() * 3
            local alpha = (math.sin(t) + 1) / 2
            GlowStroke.Transparency = 0.2 + (alpha * 0.6)
        end)
    end
end)

-- Pop-up ยืนยันการปิดล้าง UI
local ConfirmOverlay = Instance.new("Frame")
ConfirmOverlay.Size = UDim2.new(1, 0, 1, 0)
ConfirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ConfirmOverlay.BackgroundTransparency = 0.5
ConfirmOverlay.Visible = false
ConfirmOverlay.ZIndex = 10
ConfirmOverlay.Parent = MainFrame

local ConfirmBox = Instance.new("Frame")
ConfirmBox.Size = UDim2.new(0, 280, 0, 130)
ConfirmBox.Position = UDim2.new(0.5, -140, 0.5, -65)
ConfirmBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ConfirmBox.ZIndex = 11
ConfirmBox.Parent = ConfirmOverlay
Instance.new("UICorner", ConfirmBox).CornerRadius = UDim.new(0, 10)

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, -20, 0, 50)
ConfirmText.Position = UDim2.new(0, 10, 0, 15)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "ต้องการล้าง UI ทั้งหมด\nหรือเล่นต่อ?"
ConfirmText.TextColor3 = Color3.fromRGB(240, 240, 245)
ConfirmText.TextSize = 14
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.ZIndex = 11
ConfirmText.Parent = ConfirmBox

local BtnContinue = Instance.new("TextButton")
BtnContinue.Size = UDim2.new(0, 120, 0, 32)
BtnContinue.Position = UDim2.new(0, 15, 1, -45)
BtnContinue.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
BtnContinue.Text = "เล่นต่อ"
BtnContinue.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnContinue.TextSize, BtnContinue.Font = 12, Enum.Font.GothamBold
BtnContinue.ZIndex = 11
BtnContinue.Parent = ConfirmBox
Instance.new("UICorner", BtnContinue).CornerRadius = UDim.new(0, 6)

local BtnClear = Instance.new("TextButton")
BtnClear.Size = UDim2.new(0, 120, 0, 32)
BtnClear.Position = UDim2.new(1, -135, 1, -45)
BtnClear.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
BtnClear.Text = "ล้างข้อมูลทั้งหมด"
BtnClear.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnClear.TextSize, BtnClear.Font = 12, Enum.Font.GothamBold
BtnClear.ZIndex = 11
BtnClear.Parent = ConfirmBox
Instance.new("UICorner", BtnClear).CornerRadius = UDim.new(0, 6)

-- ระบบอนิเมชันเปิด/ปิดหน้าต่างแบบเดิม (หด-ขยาย สมูท)
local isAnimating = false

local function openHub()
    if isAnimating then return end
    isAnimating = true
    
    TweenService:Create(ExternalLogoBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 30, 0, 30),
        ImageTransparency = 1
    }):Play()
    
    task.wait(0.12)
    ExternalLogoBtn.Visible = false
    ExternalLogoBtn.Size = UDim2.new(0, 52, 0, 52)
    ExternalLogoBtn.ImageTransparency = 0
    
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 320, 0, 180)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 460, 0, 260),
        Position = UDim2.new(0.5, -230, 0.5, -130)
    }):Play()
    
    task.wait(0.2)
    isAnimating = false
end

local function closeHub()
    if isAnimating then return end
    isAnimating = true
    ConfirmOverlay.Visible = false
    
    TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 320, 0, 180),
        Position = UDim2.new(0.5, -160, 0.5, -90)
    }):Play()
    
    task.wait(0.15)
    MainFrame.Visible = false
    
    ExternalLogoBtn.Visible = true
    ExternalLogoBtn.Size = UDim2.new(0, 30, 0, 30)
    ExternalLogoBtn.ImageTransparency = 1
    
    TweenService:Create(ExternalLogoBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 52, 0, 52),
        ImageTransparency = 0
    }):Play()
    
    task.wait(0.15)
    isAnimating = false
end

ExternalLogoBtn.MouseButton1Click:Connect(openHub)

BtnContinue.MouseButton1Click:Connect(function()
    ConfirmOverlay.Visible = false
end)

BtnClear.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- แถบหัวข้อด้านบน (Top Bar)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, -16, 0, 38)
TopBar.Position = UDim2.new(0, 8, 0, 8)
TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopBar.BackgroundTransparency = 0.85
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 2
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Size = UDim2.new(0, 26, 0, 26)
HeaderLogo.Position = UDim2.new(0, 8, 0.5, -13)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = logoAsset ~= "" and logoAsset or ""
HeaderLogo.ZIndex = 2
HeaderLogo.Parent = TopBar
Instance.new("UICorner", HeaderLogo).CornerRadius = UDim.new(0, 6)

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(0, 200, 1, 0)
HeaderTitle.Position = UDim2.new(0, 42, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "X3 6/1 hub"
HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.TextSize = 14
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 2
HeaderTitle.Parent = TopBar

-- ปุ่มกากบาท (X) สำหรับยืนยันล้างข้อมูล
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 18)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -9)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 2
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

CloseBtn.MouseButton1Click:Connect(function()
    ConfirmOverlay.Visible = true
end)

-- ปุ่มขีด (-) สำหรับย่อซ่อนหน้าต่าง
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 26, 0, 18)
MinimizeBtn.Position = UDim2.new(1, -66, 0.5, -9)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.ZIndex = 2
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

MinimizeBtn.MouseButton1Click:Connect(closeHub)

-- ปุ่มปรับขนาด <->
local ResizeBtn = Instance.new("TextButton")
ResizeBtn.Name = "ResizeBtn"
ResizeBtn.Size = UDim2.new(0, 36, 0, 20)
ResizeBtn.Position = UDim2.new(1, -38, 1, -22)
ResizeBtn.BackgroundTransparency = 1
ResizeBtn.Text = "<->"
ResizeBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
ResizeBtn.TextSize = 12
ResizeBtn.Font = Enum.Font.GothamBold
ResizeBtn.ZIndex = 5
ResizeBtn.Parent = MainFrame

local isResizing = false
local startTouchPos, startFrameSize

ResizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true
        startTouchPos = input.Position
        startFrameSize = MainFrame.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startTouchPos
        local newWidth = math.clamp(startFrameSize.X.Offset + delta.X, 320, 650)
        local newHeight = math.clamp(startFrameSize.Y.Offset + delta.Y, 180, 420)
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = false
    end
end)
