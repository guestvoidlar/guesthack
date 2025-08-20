local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Ana ekran
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlackHackGUI"
ScreenGui.Parent = PlayerGui

-- Menü çerçevesi
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 500, 0, 500)
MenuFrame.Position = UDim2.new(0.5, -250, 0.5, -250)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MenuFrame.BorderSizePixel = 0
MenuFrame.Parent = ScreenGui

-- Taşınabilir üst bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
TopBar.Parent = MenuFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,30,1,0)
CloseBtn.Position = UDim2.new(1,-35,0,0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
CloseBtn.Text = "-"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.Parent = TopBar

local OpenIcon = Instance.new("TextButton")
OpenIcon.Size = UDim2.new(0,50,0,50)
OpenIcon.Position = UDim2.new(0,10,0,10)
OpenIcon.BackgroundColor3 = Color3.fromRGB(40,40,40)
OpenIcon.Text = "💻"
OpenIcon.TextSize = 30
OpenIcon.Visible = false
OpenIcon.Parent = ScreenGui

CloseBtn.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
    OpenIcon.Visible = true
end)

OpenIcon.MouseButton1Click:Connect(function()
    MenuFrame.Visible = true
    OpenIcon.Visible = false
end)

-- Menü sürükleme
local dragging = false
local dragInput, mousePos, framePos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MenuFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        MenuFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Paneller
local LeftFrame = Instance.new("Frame")
LeftFrame.Size = UDim2.new(0,200,1,0)
LeftFrame.Position = UDim2.new(0,0,0,30)
LeftFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
LeftFrame.Parent = MenuFrame

local RightFrame = Instance.new("Frame")
RightFrame.Size = UDim2.new(0,300,1,0)
RightFrame.Position = UDim2.new(0,200,0,30)
RightFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
RightFrame.Parent = MenuFrame

-- Info başlığı
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1,0,0,50)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Info 📖"
InfoLabel.TextColor3 = Color3.fromRGB(255,255,255)
InfoLabel.Font = Enum.Font.SourceSansBold
InfoLabel.TextSize = 20
InfoLabel.Parent = LeftFrame

-- Hile listesi sol panel
local hacks = {"Noclip","Ölümsüzlük","Speed","Fly","Avatar Değişim"}
local startY = 60
for i, hack in pairs(hacks) do
    local btn = Instance.new("TextLabel")
    btn.Size = UDim2.new(1,-10,0,40)
    btn.Position = UDim2.new(0,5,0,startY + (i-1)*45)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = hack
    btn.Parent = LeftFrame
end

-- Sağ panelde hilelerin ayarları
-- Noclip
local noclipEnabled = false
local NoclipFrame = Instance.new("Frame")
NoclipFrame.Size = UDim2.new(1,-10,0,50)
NoclipFrame.Position = UDim2.new(0,5,0,10)
NoclipFrame.BackgroundTransparency = 1
NoclipFrame.Parent = RightFrame

local NoclipLabel = Instance.new("TextLabel")
NoclipLabel.Size = UDim2.new(0.7,0,1,0)
NoclipLabel.BackgroundTransparency = 1
NoclipLabel.Text = "Noclip aktif et"
NoclipLabel.TextColor3 = Color3.fromRGB(255,255,255)
NoclipLabel.Font = Enum.Font.SourceSansBold
NoclipLabel.TextSize = 18
NoclipLabel.Parent = NoclipFrame

local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0.25,0,0.8,0)
NoclipBtn.Position = UDim2.new(0.75,0,0.1,0)
NoclipBtn.BackgroundTransparency = 1
NoclipBtn.Text = "☝️"
NoclipBtn.TextSize = 20
NoclipBtn.Parent = NoclipFrame

NoclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        NoclipBtn.Text = "✅"
    else
        NoclipBtn.Text = "☝️"
        if Player.Character then
            for _, part in pairs(Player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and Player.Character then
        for _, part in pairs(Player.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end
end)

-- Ölümsüzlük
local godEnabled = false
local GodFrame = Instance.new("Frame")
GodFrame.Size = UDim2.new(1,-10,0,50)
GodFrame.Position = UDim2.new(0,5,0,70)
GodFrame.BackgroundTransparency = 1
GodFrame.Parent = RightFrame

local GodLabel = Instance.new("TextLabel")
GodLabel.Size = UDim2.new(0.7,0,1,0)
GodLabel.BackgroundTransparency = 1
GodLabel.Text = "Ölümsüzlük aktif et"
GodLabel.TextColor3 = Color3.fromRGB(255,255,255)
GodLabel.Font = Enum.Font.SourceSansBold
GodLabel.TextSize = 18
GodLabel.Parent = GodFrame

local GodBtn = Instance.new("TextButton")
GodBtn.Size = UDim2.new(0.25,0,0.8,0)
GodBtn.Position = UDim2.new(0.75,0,0.1,0)
GodBtn.BackgroundTransparency = 1
GodBtn.Text = "☝️"
GodBtn.TextSize = 20
GodBtn.Parent = GodFrame

GodBtn.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    if godEnabled then GodBtn.Text = "✅" else GodBtn.Text = "☝️" end
end)

RunService.Stepped:Connect(function()
    if godEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.Health = Player.Character.Humanoid.MaxHealth
    end
end)

-- Speed
local speedEnabled = false
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(1,-10,0,80)
SpeedFrame.Position = UDim2.new(0,5,0,130)
SpeedFrame.BackgroundTransparency = 1
SpeedFrame.Parent = RightFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.7,0,0,30)
SpeedLabel.Position = UDim2.new(0,0,0,0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Hız aktif et"
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextSize = 18
SpeedLabel.Parent = SpeedFrame

local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0.25,0,0.8,0)
SpeedBtn.Position = UDim2.new(0.75,0,0,0)
SpeedBtn.BackgroundTransparency = 1
SpeedBtn.Text = "☝️"
SpeedBtn.TextSize = 20
SpeedBtn.Parent = SpeedFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.7,0,0,30)
SpeedBox.Position = UDim2.new(0,0,0,40)
SpeedBox.PlaceholderText = "Hız girin"
SpeedBox.Text = ""
SpeedBox.ClearTextOnFocus = false
SpeedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
SpeedBox.TextColor3 = Color3.fromRGB(255,255,255)
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.TextSize = 18
SpeedBox.Parent = SpeedFrame

SpeedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then SpeedBtn.Text = "✅" else SpeedBtn.Text = "☝️"; Player.Character.Humanoid.WalkSpeed = 16 end
end)

RunService.Stepped:Connect(function()
    if speedEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local speed = tonumber(SpeedBox.Text)
        if speed then Player.Character.Humanoid.WalkSpeed = speed end
    end
end)

-- Fly (/fly tarzı)
local flyEnabled = false
local bv, bg
local FlyFrame = Instance.new("Frame")
FlyFrame.Size = UDim2.new(1,-10,0,50)
FlyFrame.Position = UDim2.new(0,5,0,220)
FlyFrame.BackgroundTransparency = 1
FlyFrame.Parent = RightFrame

local FlyLabel = Instance.new("TextLabel")
FlyLabel.Size = UDim2.new(0.7,0,1,0)
FlyLabel.Position = UDim2.new(0,0,0,0)
FlyLabel.BackgroundTransparency = 1
FlyLabel.Text = "Uçma Aktif et"
FlyLabel.TextColor3 = Color3.fromRGB(255,255,255)
FlyLabel.Font = Enum.Font.SourceSansBold
FlyLabel.TextSize = 18
FlyLabel.Parent = FlyFrame

local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0.25,0,0.8,0)
FlyBtn.Position = UDim2.new(0.75,0,0.1,0)
FlyBtn.BackgroundTransparency = 1
FlyBtn.Text = "☝️"
FlyBtn.TextSize = 20
FlyBtn.Parent = FlyFrame

FlyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    local character = Player.Character or Player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    if flyEnabled then
        FlyBtn.Text = "✅"
        humanoid.PlatformStand = true

        bv = Instance.new
