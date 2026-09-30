--thanks claude
local REVIEWED = {
    ["2026-09-29T16:55:12.2114189Z"] = true
}
script_key="iFNqnWtkCtVDpaVenoXZBcLRiIyOkpHj";

local LUARMOR_URL = "https://api.luarmor.net/files/v4/loaders/e63bd83e96ab9992d6b1bbd08cc93209.lua"
local LOBBY_PLACE_ID = 4111023553

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local MAIN    = Color3.fromRGB(18, 23, 40)
local BG      = Color3.fromRGB(10, 13, 24)
local ACCENT  = Color3.fromRGB(124, 160, 240)
local OUTLINE = Color3.fromRGB(48, 58, 92)
local FONT    = Color3.fromRGB(226, 232, 246)
local RISK    = Color3.fromRGB(255, 50, 50)

local FONT_REG  = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium)
local FONT_SEMI = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold)
local FONT_BOLD = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)

local function runBypassAndLoad()
    if game.PlaceId ~= LOBBY_PLACE_ID then
        local e = game:GetService("ScriptContext").Error
        if not (getconnections and getconstants and setconstant and pcall(function()
            local t, d = false, os.clock() + 6.7
            repeat
                for _, c in ipairs(getconnections(e)) do
                    local f = c.Function
                    if f then
                        pcall(function()
                            for i, k in pairs(getconstants(f)) do
                                if k == "IsStudio" then
                                    setconstant(f, i, "IsClient")
                                    t = true
                                end
                            end
                        end)
                    end
                end
                if t then break end
                task.wait(0.67)
            until os.clock() > d
        end)) then
            return LocalPlayer:Kick("luma: failed bypass in ClientManager")
        end

        if not pcall(function()
            LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("ClientActor"):WaitForChild("ClientManager").Enabled = false
        end) then
            return LocalPlayer:Kick("luma: failed disabling ClientManager")
        end
    end

    getgenv().__luma_loader_handshake = "a3f19c7e2b8d4f60"
    loadstring(game:HttpGet(LUARMOR_URL))()
end

if game.PlaceId == LOBBY_PLACE_ID then
    runBypassAndLoad()
    return
end

local function httpRequest()
    return (syn and syn.request)
        or (http and http.request)
        or http_request
        or request
        or (fluxus and fluxus.request)
        or (getgenv and getgenv().request)
end

local function universeUpdated()
    local req = httpRequest()
    if not req then
        return nil
    end
    local ok, res = pcall(req, {
        Url = ("https://games.roblox.com/v1/games?universeIds=%d"):format(game.GameId),
        Method = "GET",
    })
    if not ok or type(res) ~= "table" or type(res.Body) ~= "string" then
        return nil
    end
    local ok2, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(res.Body)
    end)
    if ok2 and type(data) == "table" and type(data.data) == "table" and data.data[1] then
        return data.data[1].updated
    end
    return nil
end

local signature = universeUpdated()
local shownSig = signature or "unknown (games API unreachable)"
print(("[luma loader] %s"):format(shownSig))

if signature and REVIEWED[signature] then
    runBypassAndLoad()
    return
end

local function showWarning(onChoice)
    local answered = false
    local function answer(v)
        if answered then return end
        answered = true
        onChoice(v)
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "\0LumaUpdateGate"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 2147483647
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        local protect = protectgui or (syn and syn.protect_gui)
        if protect then protect(gui) end
    end)
    gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

    local backdrop = Instance.new("Frame")
    backdrop.Size = UDim2.fromScale(1, 1)
    backdrop.BackgroundColor3 = Color3.new(0, 0, 0)
    backdrop.BackgroundTransparency = 1
    backdrop.BorderSizePixel = 0
    backdrop.Parent = gui
    TweenService:Create(backdrop, TweenInfo.new(0.25), { BackgroundTransparency = 0.5 }):Play()

    local outer = Instance.new("Frame")
    outer.AnchorPoint = Vector2.new(0.5, 0.5)
    outer.Position = UDim2.fromScale(0.5, 0.5)
    outer.Size = UDim2.fromOffset(462, 220)
    outer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    outer.BorderSizePixel = 0
    outer.Parent = gui

    local panel = Instance.new("Frame")
    panel.Position = UDim2.fromOffset(1, 1)
    panel.Size = UDim2.fromOffset(460, 218)
    panel.BackgroundColor3 = MAIN
    panel.BorderSizePixel = 1
    panel.BorderColor3 = OUTLINE
    panel.Parent = outer

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(1, 0, 0, 2)
    accent.BackgroundColor3 = ACCENT
    accent.BorderSizePixel = 0
    accent.Parent = panel

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(18, 14)
    title.Size = UDim2.new(1, -36, 0, 26)
    title.FontFace = FONT_BOLD
    title.TextSize = 20
    title.TextColor3 = FONT
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = "DEEPWOKEN UPDATED..."
    title.Parent = panel

    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.Position = UDim2.fromOffset(18, 46)
    body.Size = UDim2.new(1, -36, 0, 64)
    body.FontFace = FONT_REG
    body.TextSize = 14
    body.TextColor3 = FONT
    body.TextTransparency = 0.15
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.TextWrapped = true
    body.Text = "Deepwoken has updated since this version was last reviewed. Injecting on an unreviewed update may potentially trigger new anticheat features. (ping me if I don't know about this already)\n\nInject anyway, or cancel and wait?"
    body.Parent = panel

    local infoBox = Instance.new("TextLabel")
    infoBox.Position = UDim2.fromOffset(18, 116)
    infoBox.Size = UDim2.new(1, -36, 0, 34)
    infoBox.BackgroundColor3 = BG
    infoBox.BorderSizePixel = 1
    infoBox.BorderColor3 = OUTLINE
    infoBox.FontFace = FONT_REG
    infoBox.TextSize = 13
    infoBox.TextColor3 = ACCENT
    infoBox.TextXAlignment = Enum.TextXAlignment.Left
    infoBox.Text = "Updated: " .. shownSig
    infoBox.Parent = panel
    local pad = Instance.new("UIPadding", infoBox)
    pad.PaddingLeft = UDim.new(0, 10)

    local function makeButton(text, x, w, baseText, hoverText, borderColor)
        local b = Instance.new("TextButton")
        b.Position = UDim2.fromOffset(x, 168)
        b.Size = UDim2.fromOffset(w, 34)
        b.BackgroundColor3 = BG
        b.BorderSizePixel = 1
        b.BorderColor3 = borderColor
        b.AutoButtonColor = false
        b.FontFace = FONT_SEMI
        b.TextSize = 15
        b.TextColor3 = baseText
        b.Text = text
        b.Parent = panel
        b.MouseEnter:Connect(function()
            b.TextColor3 = hoverText
            b.BackgroundColor3 = MAIN
        end)
        b.MouseLeave:Connect(function()
            b.TextColor3 = baseText
            b.BackgroundColor3 = BG
        end)
        return b
    end

    local copyBtn = makeButton("Copy", 18, 96, FONT, ACCENT, OUTLINE)
    local cancelBtn = makeButton("Cancel", 124, 150, FONT, ACCENT, OUTLINE)
    local injectBtn = makeButton("Inject Anyway", 284, 158, RISK, Color3.fromRGB(255, 120, 120), RISK)

    copyBtn.MouseButton1Click:Connect(function()
        local ok = pcall(function()
            (setclipboard or toclipboard or set_clipboard)(signature or "")
        end)
        copyBtn.Text = ok and "Copied!" or "Failed"
        task.delay(1.2, function()
            if copyBtn and copyBtn.Parent then copyBtn.Text = "Copy" end
        end)
    end)

    local function close(choice)
        local t = TweenService:Create(backdrop, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
        t:Play()
        pcall(function() outer:Destroy() end)
        t.Completed:Connect(function()
            pcall(function() gui:Destroy() end)
        end)
        answer(choice)
    end

    cancelBtn.MouseButton1Click:Connect(function() close(false) end)
    injectBtn.MouseButton1Click:Connect(function() close(true) end)
end

showWarning(function(inject)
    if inject then
        runBypassAndLoad()
    end
end)
