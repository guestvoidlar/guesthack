-- UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GuestVoid Menü", "DarkTheme")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

----------------------------------------------------
-- 1. Hız Hilesi
----------------------------------------------------
local SpeedTab = Window:NewTab("Hız")
local SpeedSection = SpeedTab:NewSection("Hız Ayarı")

SpeedSection:NewSlider("Hız", "Yürüme hızını değiştirir", 200, 16, function(val)
    player.Character.Humanoid.WalkSpeed = val
end)

----------------------------------------------------
-- 2. Uçma
----------------------------------------------------
local FlyTab = Window:NewTab("Uçma")
local FlySection = FlyTab:NewSection("Uçma Modu")

local flyActive = false
local UIS = game:GetService("UserInputService")

local function fly()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    local velocity = Instance.new("BodyVelocity")
    velocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    velocity.Velocity = Vector3.new(0,0,0)
    velocity.Parent = root

    local direction = {F=false,B=false,L=false,R=false,U=false,D=false}

    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then direction.F = true end
        if input.KeyCode == Enum.KeyCode.S then direction.B = true end
        if input.KeyCode == Enum.KeyCode.A then direction.L = true end
        if input.KeyCode == Enum.KeyCode.D then direction.R = true end
        if input.KeyCode == Enum.KeyCode.Space then direction.U = true end
        if input.KeyCode == Enum.KeyCode.LeftControl then direction.D = true end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then direction.F = false end
        if input.KeyCode == Enum.KeyCode.S then direction.B = false end
        if input.KeyCode == Enum.KeyCode.A then direction.L = false end
        if input.KeyCode == Enum.KeyCode.D then direction.R = false end
        if input.KeyCode == Enum.KeyCode.Space then direction.U = false end
        if input.KeyCode == Enum.KeyCode.LeftControl then direction.D = false end
    end)

    while flyActive do
        local camCF = workspace.CurrentCamera.CFrame
        local move = Vector3.new(0,0,0)
        if direction.F then move = move + camCF.LookVector end
        if direction.B then move = move - camCF.LookVector end
        if direction.L then move = move - camCF.RightVector end
        if direction.R then move = move + camCF.RightVector end
        if direction.U then move = move + Vector3.new(0,1,0) end
        if direction.D then move = move - Vector3.new(0,1,0) end
        velocity.Velocity = move * 50
        task.wait()
    end
    velocity:Destroy()
end

FlySection:NewButton("Uçma Aç/Kapat", "Uçar", function()
    flyActive = not flyActive
    if flyActive then
        fly()
    end
end)

----------------------------------------------------
-- 3. God Mode
----------------------------------------------------
local GodTab = Window:NewTab("God Mode")
local GodSection = GodTab:NewSection("Hasar Almama")

GodSection:NewButton("God Mode Aç", "Hasar almaz", function()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = math.huge
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            humanoid.Health = math.huge
        end)
    end
end)

----------------------------------------------------
-- 4. Noclip
----------------------------------------------------
local NoclipTab = Window:NewTab("Noclip")
local NoclipSection = NoclipTab:NewSection("Duvarlardan Geç")

local noclipActive = false
NoclipSection:NewButton("Noclip Aç/Kapat", "Duvarlardan geçer", function()
    noclipActive = not noclipActive
    game:GetService("RunService").Stepped:Connect(function()
        if noclipActive and character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end)

----------------------------------------------------
-- 5. Chat Spam
----------------------------------------------------
local SpamTab = Window:NewTab("Spam")
local SpamSection = SpamTab:NewSection("Sohbet Spamı")

local spamActive = false
SpamSection:NewButton("Spam Aç/Kapat", "Mesaj spamlar", function()
    spamActive = not spamActive
    if spamActive then
        task.spawn(function()
            while spamActive do
                game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                    "HACKED BY GUESTVOİDLAR",
                    "All"
                )
                task.wait(0.5)
            end
        end)
    end
end)
