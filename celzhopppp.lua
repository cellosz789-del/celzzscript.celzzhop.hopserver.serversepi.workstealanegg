-- ═══════════════════════════════════════════════════════
--  CELZZ HOP | Universal ServerHop
--  Powered by EGX AI | ENDXZ
--  Dedicated to ENDXZ | JAILBREAK HAS DONE
-- ═══════════════════════════════════════════════════════

local CONFIG = {
    MaxPlayers = 0,
    AutoHop = false,
    MinHopDelay = 6,
    MaxHopDelay = 12,
    SessionLimit = 3600,
    SessionRest = 300,
}

local RUNNING = true

local Players         = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService     = game:GetService("HttpService")
local TweenService    = game:GetService("TweenService")
local LocalPlayer     = Players.LocalPlayer
local PlayerGui       = LocalPlayer:WaitForChild("PlayerGui")
local PlaceId         = game.PlaceId

-- THEME HITAM PUTIH
local THEME = {
    Bg        = Color3.fromRGB(0, 0, 0),
    Panel     = Color3.fromRGB(15, 15, 15),
    HeaderBg  = Color3.fromRGB(25, 25, 25),
    RowBg     = Color3.fromRGB(30, 30, 30),
    Border    = Color3.fromRGB(60, 60, 60),
    Text      = Color3.fromRGB(255, 255, 255),
    TextDim   = Color3.fromRGB(150, 150, 150),
    Accent    = Color3.fromRGB(255, 255, 255),
    Green     = Color3.fromRGB(50, 200, 100),
    Red       = Color3.fromRGB(220, 60, 80),
}

local old = PlayerGui:FindFirstChild("CELZZ_HOP_UI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "CELZZ_HOP_UI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

-- CIRCLE BUTTON (TENGAH LAYAR)
local circle = Instance.new("TextButton")
circle.Size = UDim2.new(0, 60, 0, 60)
circle.Position = UDim2.new(0.5, -30, 0.5, -30)
circle.BackgroundColor3 = THEME.Bg
circle.BorderSizePixel = 0
circle.Text = "CELZZ"
circle.TextColor3 = THEME.Text
circle.TextSize = 12
circle.Font = Enum.Font.GothamBold
circle.AutoButtonColor = false
circle.Parent = gui

Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

local cStroke = Instance.new("UIStroke")
cStroke.Color = THEME.Border
cStroke.Thickness = 1.5
cStroke.Parent = circle

-- PANEL (UKURAN PAS)
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 280, 0, 340)
panel.Position = UDim2.new(0.5, -140, 0.5, -170)
panel.BackgroundColor3 = THEME.Panel
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui

Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

local pStroke = Instance.new("UIStroke")
pStroke.Color = THEME.Border
pStroke.Thickness = 1
pStroke.Parent = panel

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = THEME.HeaderBg
header.BorderSizePixel = 0
header.Parent = panel
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = THEME.HeaderBg
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Text = "CELZZ HOP"
title.TextColor3 = THEME.Text
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Tombol − (MINIMIZE)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -32, 0.5, -12)
minBtn.BackgroundColor3 = THEME.RowBg
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = THEME.Text
minBtn.TextSize = 18
minBtn.Font = Enum.Font.GothamBold
minBtn.AutoButtonColor = false
minBtn.Parent = header
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

-- CONTENT
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -16, 1, -50)
content.Position = UDim2.new(0, 8, 0, 44)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 2
content.ScrollBarImageColor3 = THEME.TextDim
content.CanvasSize = UDim2.new(0, 0, 0, 500)
content.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

-- STATUS
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, -4, 0, 36)
statusFrame.BackgroundColor3 = THEME.RowBg
statusFrame.BorderSizePixel = 0
statusFrame.Parent = content
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 6)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -14, 1, 0)
statusLbl.Position = UDim2.new(0, 8, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Ready"
statusLbl.TextColor3 = THEME.TextDim
statusLbl.TextSize = 10
statusLbl.Font = Enum.Font.GothamMedium
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.TextTruncate = Enum.TextTruncate.AtEnd
statusLbl.Parent = statusFrame

local function updateStatus(txt, color)
    statusLbl.Text = txt
    statusLbl.TextColor3 = color or THEME.TextDim
end

-- PLAYER COUNT
local countFrame = Instance.new("Frame")
countFrame.Size = UDim2.new(1, -4, 0, 32)
countFrame.BackgroundColor3 = THEME.RowBg
countFrame.BorderSizePixel = 0
countFrame.Parent = content
Instance.new("UICorner", countFrame).CornerRadius = UDim.new(0, 6)

local countLbl = Instance.new("TextLabel")
countLbl.Size = UDim2.new(1, -14, 1, 0)
countLbl.Position = UDim2.new(0, 8, 0, 0)
countLbl.BackgroundTransparency = 1
countLbl.Text = "Player: ..."
countLbl.TextColor3 = THEME.Text
countLbl.TextSize = 11
countLbl.Font = Enum.Font.GothamBold
countLbl.TextXAlignment = Enum.TextXAlignment.Left
countLbl.Parent = countFrame

-- FILTER LABEL
local filterLbl = Instance.new("TextLabel")
filterLbl.Size = UDim2.new(1, -4, 0, 16)
filterLbl.BackgroundTransparency = 1
filterLbl.Text = "Cari server dengan player maksimal:"
filterLbl.TextColor3 = THEME.TextDim
filterLbl.TextSize = 10
filterLbl.Font = Enum.Font.Gotham
filterLbl.TextXAlignment = Enum.TextXAlignment.Left
filterLbl.Parent = content

-- FILTER INPUT
local filterBox = Instance.new("TextBox")
filterBox.Size = UDim2.new(1, -4, 0, 34)
filterBox.BackgroundColor3 = THEME.RowBg
filterBox.BorderSizePixel = 0
filterBox.Text = "0"
filterBox.TextColor3 = THEME.Text
filterBox.TextSize = 14
filterBox.Font = Enum.Font.GothamBold
filterBox.ClearTextOnFocus = false
filterBox.Parent = content
Instance.new("UICorner", filterBox).CornerRadius = UDim.new(0, 6)

local fbStroke = Instance.new("UIStroke")
fbStroke.Color = THEME.Border
fbStroke.Thickness = 1
fbStroke.Parent = filterBox

filterBox.FocusLost:Connect(function()
    local n = tonumber(filterBox.Text)
    if n and n >= 0 then
        CONFIG.MaxPlayers = math.floor(n)
        updateStatus("Filter: ≤" .. CONFIG.MaxPlayers .. " player", THEME.Green)
    else
        filterBox.Text = tostring(CONFIG.MaxPlayers)
    end
end)

-- HOP BUTTON
local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(1, -4, 0, 44)
hopBtn.BackgroundColor3 = THEME.Accent
hopBtn.BorderSizePixel = 0
hopBtn.Text = "HOP LANGSUNG"
hopBtn.TextColor3 = THEME.Bg
hopBtn.TextSize = 13
hopBtn.Font = Enum.Font.GothamBold
hopBtn.AutoButtonColor = false
hopBtn.Parent = content
Instance.new("UICorner", hopBtn).CornerRadius = UDim.new(0, 8)

-- AUTO HOP BUTTON
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(1, -4, 0, 40)
autoBtn.BackgroundColor3 = THEME.RowBg
autoBtn.BorderSizePixel = 0
autoBtn.Text = "AUTO HOP  •  OFF"
autoBtn.TextColor3 = THEME.TextDim
autoBtn.TextSize = 11
autoBtn.Font = Enum.Font.GothamBold
autoBtn.AutoButtonColor = false
autoBtn.Parent = content
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0, 8)

local abStroke = Instance.new("UIStroke")
abStroke.Color = THEME.Border
abStroke.Thickness = 1
abStroke.Parent = autoBtn

-- INFO
local infoLbl = Instance.new("TextLabel")
infoLbl.Size = UDim2.new(1, -4, 0, 40)
infoLbl.BackgroundColor3 = THEME.RowBg
infoLbl.BackgroundTransparency = 0.5
infoLbl.BorderSizePixel = 0
infoLbl.Text = "  Isi player, klik HOP LANGSUNG"
infoLbl.TextColor3 = THEME.TextDim
infoLbl.TextSize = 9
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextXAlignment = Enum.TextXAlignment.Left
infoLbl.TextYAlignment = Enum.TextYAlignment.Center
infoLbl.Parent = content
Instance.new("UICorner", infoLbl).CornerRadius = UDim.new(0, 6)

-- DRAG SUPPORT
local dragging, dragStart, startPos, dragTarget
local function makeDraggable(target)
    target.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragTarget = target
            dragStart = input.Position
            startPos = target.Position
        end
    end)
    target.InputChanged:Connect(function(input)
        if dragging and dragTarget == target
        and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    target.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            dragTarget = nil
        end
    end)
end
makeDraggable(circle)

-- UI LOGIC

-- Tombol − : Tutup panel, jadi bulatan
minBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    circle.Visible = true
end)

-- Klik circle : Munculin panel di tengah
circle.MouseButton1Click:Connect(function()
    if not dragging then
        panel.Visible = true
        panel.Position = UDim2.new(0.5, -140, 0.5, -170)
    end
end)

-- Hover effects
minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.15), { BackgroundColor3 = THEME.Border }):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.15), { BackgroundColor3 = THEME.RowBg }):Play()
end)

circle.MouseEnter:Connect(function()
    TweenService:Create(circle, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }):Play()
    TweenService:Create(cStroke, TweenInfo.new(0.2), { Color = THEME.Text }):Play()
end)
circle.MouseLeave:Connect(function()
    TweenService:Create(circle, TweenInfo.new(0.2), { BackgroundColor3 = THEME.Bg }):Play()
    TweenService:Create(cStroke, TweenInfo.new(0.2), { Color = THEME.Border }):Play()
end)

hopBtn.MouseEnter:Connect(function()
    TweenService:Create(hopBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(220, 220, 220) }):Play()
end)
hopBtn.MouseLeave:Connect(function()
    TweenService:Create(hopBtn, TweenInfo.new(0.15), { BackgroundColor3 = THEME.Accent }):Play()
end)

-- CORE LOGIC

-- Realtime player count
task.spawn(function()
    while RUNNING and gui.Parent do
        local count = #Players:GetPlayers()
        countLbl.Text = "Player: " .. count
        countLbl.TextColor3 = count <= CONFIG.MaxPlayers and THEME.Green or THEME.Text
        task.wait(2)
    end
end)

-- Ambil daftar server
local function getServers()
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, raw = pcall(function() return game:HttpGet(url) end)
    if not ok or not raw or raw == "" then return nil end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok2 or not data or not data.data or #data.data == 0 then return nil end
    return data.data
end

-- Cari server kosong
local function findEmptyServer()
    local servers = getServers()
    if not servers then return nil end
    local currentId = tostring(game.JobId)
    local candidates = {}
    for _, s in ipairs(servers) do
        if s.id and tostring(s.id) ~= currentId then
            local pCount = s.playing or 0
            if pCount <= CONFIG.MaxPlayers then
                table.insert(candidates, { id = tostring(s.id), count = pCount })
            end
        end
    end
    if #candidates == 0 then return nil end
    table.sort(candidates, function(a, b) return a.count < b.count end)
    return candidates[1]
end

-- Hop instant
local function hopInstant()
    local currentCount = #Players:GetPlayers()
    updateStatus("Server ini: " .. currentCount .. " player", THEME.TextDim)

    if currentCount <= CONFIG.MaxPlayers then
        updateStatus("✓ Server sudah ≤" .. CONFIG.MaxPlayers .. " player", THEME.Green)
        return false
    end

    updateStatus("Mencari server kosong...", THEME.Text)

    local target = findEmptyServer()
    if not target then
        updateStatus("✕ Gak ada server kosong", THEME.Red)
        return false
    end

    updateStatus("→ Pindah ke " .. target.count .. " player...", THEME.Text)

    local ok = pcall(function()
        TeleportService:TeleportToPlaceInstance(PlaceId, target.id, LocalPlayer)
    end)

    if not ok then
        updateStatus("✕ Teleport gagal", THEME.Red)
        return false
    end
    return true
end

-- HOP BUTTON
hopBtn.MouseButton1Click:Connect(function()
    hopBtn.Text = "SEARCHING..."
    hopBtn.Active = false
    hopInstant()
    task.wait(2)
    hopBtn.Text = "HOP LANGSUNG"
    hopBtn.Active = true
end)

-- AUTO HOP
local autoThread = nil
autoBtn.MouseButton1Click:Connect(function()
    CONFIG.AutoHop = not CONFIG.AutoHop

    if CONFIG.AutoHop then
        autoBtn.Text = "AUTO HOP  •  ON"
        autoBtn.TextColor3 = THEME.Text
        TweenService:Create(autoBtn, TweenInfo.new(0.25), { BackgroundColor3 = THEME.Green }):Play()
        TweenService:Create(abStroke, TweenInfo.new(0.25), { Color = THEME.Green }):Play()

        autoThread = task.spawn(function()
            local sessionStart = tick()
            while CONFIG.AutoHop and RUNNING and gui.Parent do
                if (tick() - sessionStart) > CONFIG.SessionLimit then
                    updateStatus("Rest " .. CONFIG.SessionRest .. "s...", THEME.TextDim)
                    task.wait(CONFIG.SessionRest)
                    sessionStart = tick()
                end
                local delay = CONFIG.MinHopDelay + math.random() * (CONFIG.MaxHopDelay - CONFIG.MinHopDelay)
                task.wait(delay)
                hopInstant()
                task.wait(5)
            end
        end)
    else
        autoBtn.Text = "AUTO HOP  •  OFF"
        autoBtn.TextColor3 = THEME.TextDim
        TweenService:Create(autoBtn, TweenInfo.new(0.25), { BackgroundColor3 = THEME.RowBg }):Play()
        TweenService:Create(abStroke, TweenInfo.new(0.25), { Color = THEME.Border }):Play()
        if autoThread then
            task.cancel(autoThread)
            autoThread = nil
        end
        updateStatus("Auto hop OFF", THEME.TextDim)
    end
end)

autoBtn.MouseEnter:Connect(function()
    TweenService:Create(autoBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(40, 40, 40) }):Play()
end)
autoBtn.MouseLeave:Connect(function()
    if not CONFIG.AutoHop then
        TweenService:Create(autoBtn, TweenInfo.new(0.15), { BackgroundColor3 = THEME.RowBg }):Play()
    end
end)

print("[CELZZ HOP] Loaded | Tuan ENDXZ 😹")