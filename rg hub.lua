local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Consistt/Ui/main/UnLeaked"))()

library.rank = "developer"
local Wm = library:Watermark("RG Hub | v" .. library.version .. " | " .. library:GetUsername() .. " | rank: " .. library.rank)
local FpsWm = Wm:AddWatermark("fps: " .. library.fps)

coroutine.wrap(function()
    while wait(.75) do
        FpsWm:Text("fps: " .. library.fps)
    end
end)()

local Notif = library:InitNotifications()

for i = 5, 0, -1 do
    task.wait(0.05)
    Notif:Notify("Loading RG Hub, please be patient.", 3, "information")
end

library.title = "RG Hub v1"

library:Introduction()
wait(1)
local Init = library:Init()

local Tab1 = Init:NewTab("Tab 1")
local Tab2 = Init:NewTab("Tab 2")
local Tab3 = Init:NewTab("Tab 3")
local Tab4 = Init:NewTab("Tab 4")

local Button1 = Tab1:NewButton("invisible (R)", function()
    local Global = getgenv and getgenv() or _G
    local First = true
    local Restart = true
    local SoundService = game:GetService("SoundService")
    local StoredCF
    local SafeZone
    if Global.SafeZone ~= nil then
        if type(Global.SafeZone) ~= "userdata" then return error("CFrame must be a userdata (CFrame.new(X, X, X)") end
        SafeZone = Global.SafeZone
    else
        SafeZone = CFrame.new(50000, -500, 50000)
    end

    local ScriptStart = true
    local DeleteOnDeath = {}
    local Activate
    local Noclip
    if Global.Key == nil then
        Activate = "R"
    else
        Activate = tostring(Global.Key)     
    end

    if Global.Noclip == nil then
        Noclip = false
    else
        Noclip = Global.Noclip        
    end

    if type(Noclip) ~= "boolean" then return error("Noclip value isn't a boolean") end

    function notify(Message)
        game:GetService("StarterGui"):SetCore("SendNotification", { 
            Title = "invis by kjefeer";
            Text = Message;
            Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://7046168694"
        SoundService:PlayLocalSound(sound)
    end

    if Global.Running then
        return notify("Script is already running")
    else
        Global.Running = true
    end

    local IsInvisible = false
    local Died = false
    local LP = game:GetService("Players").LocalPlayer
    local UserInputService = game:GetService("UserInputService")
    repeat wait() until LP.Character
    repeat wait() until LP.Character:FindFirstChild("Humanoid")
    local RealChar = LP.Character or LP.CharacterAdded:Wait()
    RealChar.Archivable = true
    local FakeChar = RealChar:Clone()
    FakeChar:WaitForChild("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer -- Видимость ника
    FakeChar.Parent = game:GetService("Workspace")

    for _, child in pairs(FakeChar:GetDescendants()) do
        if child:IsA("BasePart") and child.CanCollide == true then
            child.CanCollide = false
        end
    end

    FakeChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 3, 0))

    local Part
    Part = Instance.new("Part", workspace)
    Part.Anchored = true
    Part.Size = Vector3.new(2000000000, 1, 2000000000)
    Part.CFrame = SafeZone
    Part.CanCollide = true

    for i, v in pairs(FakeChar:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = 0.7
        end
    end

    for i, v in pairs(RealChar:GetChildren()) do
        if v:IsA("LocalScript") then
            local clone = v:Clone()
            clone.Disabled = true
            clone.Parent = FakeChar
        end
    end

    function StopScript()
        if not ScriptStart then return end
        notify("Вы умерли, скрипт отключен.") -- Уведомление об остановке скрипта

        -- Восстановление нормального состояния персонажа
        if IsInvisible and RealChar:FindFirstChild("HumanoidRootPart") then
            Visible()
        end

        Part:Destroy() -- Удаление части
        Global.Running = false -- Остановка скрипта
        ScriptStart = false -- Завершение работы скрипта

        if FakeChar then
            FakeChar:Destroy() -- Удаление поддельного персонажа
        end

        -- Восстановление стандартного состояния персонажа
        if RealChar then
            LP.Character = RealChar
            game:GetService("Workspace").CurrentCamera.CameraSubject = RealChar:WaitForChild("Humanoid")
        end
    end

    RealChar:WaitForChild("Humanoid").Died:Connect(function()
        StopScript() -- Остановка скрипта при смерти персонажа
    end)

    FakeChar:WaitForChild("Humanoid").Died:Connect(function()
        StopScript() -- Остановка скрипта при смерти поддельного персонажа
    end)

    function Invisible()
        StoredCF = RealChar:GetPrimaryPartCFrame()

        if First == true then
            First = false
            for _,v in pairs(LP:WaitForChild("PlayerGui"):GetChildren()) do 
                if v:IsA("ScreenGui") then
                    if v.ResetOnSpawn == true then
                        v.ResetOnSpawn = false
                        table.insert(DeleteOnDeath, v)
                    end
                end
            end
        end
        
        if Noclip == true then
            for _, child in pairs(FakeChar:GetDescendants()) do
                if child:IsA("BasePart") and child.CanCollide == true then
                    child.CanCollide = false
                end
            end
        end

        FakeChar:SetPrimaryPartCFrame(StoredCF)
        FakeChar:WaitForChild("HumanoidRootPart").Anchored = false
        LP.Character = FakeChar
        game:GetService("Workspace").CurrentCamera.CameraSubject = FakeChar:WaitForChild("Humanoid")

        for _, child in pairs(RealChar:GetDescendants()) do
            if child:IsA("BasePart") and child.CanCollide == true then
                child.CanCollide = false
            end
        end

        RealChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 5, 0))
        RealChar:WaitForChild("Humanoid"):UnequipTools()

        for i, v in pairs(FakeChar:GetChildren()) do
            if v:IsA("LocalScript") then
                v.Disabled = false
            end
        end
    end

    function Visible()
        StoredCF = FakeChar:GetPrimaryPartCFrame()
        for _, child in pairs(RealChar:GetDescendants()) do
            if child:IsA("BasePart") and child.CanCollide == true then
                child.CanCollide = true
            end
        end
        RealChar:WaitForChild("HumanoidRootPart").Anchored = false
        RealChar:SetPrimaryPartCFrame(StoredCF)
        LP.Character = RealChar
        FakeChar:WaitForChild("Humanoid"):UnequipTools()
        game:GetService("Workspace").CurrentCamera.CameraSubject = RealChar:WaitForChild("Humanoid")
        for _, child in pairs(FakeChar:GetDescendants()) do
            if child:IsA("BasePart") and child.CanCollide == true then
                child.CanCollide = false
            end
        end
        FakeChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 5, 0))
        FakeChar:WaitForChild("HumanoidRootPart").Anchored = true
        for i, v in pairs(FakeChar:GetChildren()) do
            if v:IsA("LocalScript") then
                v.Disabled = true
            end
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not ScriptStart then return end
        if gameProcessed then return end
        if input.KeyCode.Name:lower() ~= Activate:lower() then return end
        if not IsInvisible then
            Invisible()
            IsInvisible = true
        else
            Visible()
            IsInvisible = false
        end
    end)

    LP.Chatted:Connect(function(msg)
        if not ScriptStart then return end
        msg = msg:lower()
        if msg == "/e stop" then
            StopScript()
        end
        
        if msg == "/e cmds" then
            Global.Header = "Available Commands"
            Global.Message = "/e cmds -- Show this GUI \n /e stop -- Stop the script \n /e noclip -- Toggle noclip"
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Error-Cezar/Roblox-Scripts/main/Notif.lua'))()
        end
        
        if msg == "/e noclip" then
            Noclip = not Noclip
            notify("Noclip set to "..tostring(Noclip))
        end
    end)
end)


-- Невидимость и другие функции остаются без изменений...

-- Функция для телепорта на арену
local Button1 = Tab2:NewButton("tp on arena", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(1479, 811, -720)
    end
end)

-- Функция для телепорта на карту
local Button2 = Tab2:NewButton("tp map", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(133, 441, 34)
    end
end)

-- Создание платформы
local Button3 = Tab1:NewButton("create platform", function()
    local part = Instance.new("Part")
    part.Size = Vector3.new(300, 1, 300)
    part.Position = Vector3.new(1000, 996, 1000)
    part.Anchored = true
    part.BrickColor = BrickColor.new("Dark stone gray")
    part.Material = Enum.Material.SmoothPlastic
    part.Transparency = 0.5
    part.Parent = game.Workspace
end)

-- Кнопка для телепорта ко всем игрокам
local Button4 = Tab1:NewButton("goto all (J)", function()
    local players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")

    local teleportDelay = 0.01
    local teleporting = false

    local function teleportToPlayers()
        if teleporting then return end
        teleporting = true

        local character = players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        for _, targetPlayer in pairs(players:GetPlayers()) do
            if targetPlayer ~= players.LocalPlayer then
                local targetCharacter = targetPlayer.Character
                if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                    humanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame
                    wait(teleportDelay)
                end
            end
        end

        teleporting = false
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.J and not gameProcessedEvent then
            teleportToPlayers()
        end
    end)
end)

-- Кнопка для загрузки Infinite Yield
local Button5 = Tab3:NewButton("IY", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'), true))()
end)
