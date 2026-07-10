local Astral = {Flags = {}, Elements = {}}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local C = {
    bg = Color3.fromRGB(17, 17, 20),
    header = Color3.fromRGB(23, 23, 27),
    colbg = Color3.fromRGB(24, 24, 29),
    border = Color3.fromRGB(44, 44, 51),
    hover = Color3.fromRGB(34, 34, 40),
    text = Color3.fromRGB(233, 233, 238),
    dim = Color3.fromRGB(150, 150, 160),
    accent = Color3.fromRGB(72, 130, 248),
    trackOff = Color3.fromRGB(58, 58, 66),
    pill = Color3.fromRGB(33, 33, 40),
    knob = Color3.fromRGB(255, 255, 255)
}

local FONT = Enum.Font.Gotham 
local FONTM = Enum.Font.GothamMedium 
local FONTB = Enum.Font.GothamBold

local function corner(p, r) 
    local u = Instance.new("UICorner") 
    u.CornerRadius = UDim.new(0, r or 6) 
    u.Parent = p 
    return u 
end

local function strokeOf(p, col, t) 
    local s = Instance.new("UIStroke") 
    s.Color = col or C.border 
    s.Thickness = 1 
    s.Transparency = t or 0 
    s.Parent = p 
    return s 
end

function Astral:Save()
    if not isfolder("AstralAutoSaves") then makefolder("AstralAutoSaves") end
    local data = HttpService:JSONEncode(self.Flags)
    writefile("AstralAutoSaves/" .. tostring(game.GameId) .. ".json", data)
end

function Astral:Load()
    local path = "AstralAutoSaves/" .. tostring(game.GameId) .. ".json"
    if isfile(path) then
        local s, r = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        if s and type(r) == "table" then
            for k, v in pairs(r) do
                self.Flags[k] = v
            end
        end
    end
end

function Astral:CreateWindow(Config)
    local Title = Config.Name or "Astral Window"
    self:Load()
    
    if CoreGui:FindFirstChild("AstralLibGui") then 
        CoreGui.AstralLibGui:Destroy() 
    end

    local gui = Instance.new("ScreenGui") 
    gui.Name = "AstralLibGui" 
    gui.ResetOnSpawn = false 
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 
    gui.IgnoreGuiInset = true 
    gui.Parent = CoreGui

    local main = Instance.new("Frame") 
    main.Size = UDim2.fromOffset(520, 380) 
    main.Position = UDim2.new(0.5, -260, 0.5, -190) 
    main.BackgroundColor3 = C.bg 
    main.BorderSizePixel = 0 
    main.Active = true 
    main.Draggable = true 
    main.ClipsDescendants = true
    main.Parent = gui 
    corner(main, 12) 
    strokeOf(main, C.border, 0)

    local header = Instance.new("Frame") 
    header.Size = UDim2.new(1, 0, 0, 44) 
    header.BackgroundColor3 = C.header 
    header.Parent = main 
    corner(header, 12)

    local hfix = Instance.new("Frame") 
    hfix.Size = UDim2.new(1, 0, 0, 14) 
    hfix.Position = UDim2.new(0, 0, 1, -14) 
    hfix.BackgroundColor3 = C.header 
    hfix.BorderSizePixel = 0 
    hfix.Parent = header

    local tlabel = Instance.new("TextLabel") 
    tlabel.Size = UDim2.new(0.5, 0, 1, 0) 
    tlabel.Position = UDim2.fromOffset(20, 0) 
    tlabel.BackgroundTransparency = 1 
    tlabel.Font = FONTB 
    tlabel.Text = Title 
    tlabel.TextColor3 = C.text 
    tlabel.TextSize = 14 
    tlabel.TextXAlignment = Enum.TextXAlignment.Left 
    tlabel.Parent = header

    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 70, 1, 0)
    controls.Position = UDim2.new(1, -80, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = header

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(0, 0, 0.5, -15)
    minBtn.BackgroundTransparency = 1
    minBtn.Font = FONTB
    minBtn.Text = "-"
    minBtn.TextColor3 = C.dim
    minBtn.TextSize = 18
    minBtn.Parent = controls

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(0, 35, 0.5, -15)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Font = FONTB
    closeBtn.Text = "X"
    closeBtn.TextColor3 = C.dim
    closeBtn.TextSize = 16
    closeBtn.Parent = controls

    local isMinimized = false
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = isMinimized and UDim2.fromOffset(520, 44) or UDim2.fromOffset(520, 380)
        }):Play()
    end)

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local NotifArea = Instance.new("Frame")
    NotifArea.Size = UDim2.new(0, 250, 1, -20)
    NotifArea.Position = UDim2.new(1, -270, 0, 10)
    NotifArea.BackgroundTransparency = 1
    NotifArea.Parent = gui
    local NotifList = Instance.new("UIListLayout")
    NotifList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifList.Padding = UDim.new(0, 5)
    NotifList.Parent = NotifArea

    local tabBar = Instance.new("ScrollingFrame")
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.Position = UDim2.fromOffset(0, 45)
    tabBar.BackgroundTransparency = 1
    tabBar.ScrollBarThickness = 0
    tabBar.Parent = main
    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tabBar
    local tabPad = Instance.new("UIPadding")
    tabPad.PaddingLeft = UDim.new(0, 12)
    tabPad.PaddingTop = UDim.new(0, 5)
    tabPad.Parent = tabBar

    local body = Instance.new("Frame") 
    body.Size = UDim2.new(1, 0, 1, -85) 
    body.Position = UDim2.fromOffset(0, 85) 
    body.BackgroundTransparency = 1 
    body.Parent = main

    local tabs = {}
    local WindowElements = {}

    function WindowElements:Notify(NotifyConfig)
        local NTitle = NotifyConfig.Title or "Notification"
        local NContent = NotifyConfig.Content or "Message"
        local NFrame = Instance.new("Frame")
        NFrame.Size = UDim2.new(1, 0, 0, 60)
        NFrame.BackgroundColor3 = C.bg
        NFrame.Parent = NotifArea
        corner(NFrame, 6)
        strokeOf(NFrame, C.border, 0)
        local NText = Instance.new("TextLabel")
        NText.Size = UDim2.new(1, -20, 1, 0)
        NText.Position = UDim2.fromOffset(10, 0)
        NText.BackgroundTransparency = 1
        NText.Font = FONTM
        NText.Text = NTitle .. " - " .. NContent
        NText.TextColor3 = C.text
        NText.TextSize = 13
        NText.TextXAlignment = Enum.TextXAlignment.Left
        NText.TextWrapped = true
        NText.Parent = NFrame
        task.delay(3, function() 
            TweenService:Create(NFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(NText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.wait(0.3)
            NFrame:Destroy() 
        end)
    end

    function WindowElements:CreateTab(TabName)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(100, 30)
        btn.BackgroundColor3 = #tabs == 0 and C.hover or C.pill
        btn.Text = TabName
        btn.Font = FONTM
        btn.TextSize = 13
        btn.TextColor3 = #tabs == 0 and C.text or C.dim
        btn.AutoButtonColor = false
        btn.Parent = tabBar
        corner(btn, 6)
        strokeOf(btn, C.border, 0)
        
        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(1, -24, 1, -12)
        container.Position = UDim2.fromOffset(12, 0)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 2
        container.ScrollBarImageColor3 = C.border
        container.Visible = #tabs == 0
        container.Parent = body
        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 8)
        list.Parent = container

        table.insert(tabs, {btn = btn, frame = container})
        
        btn.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabs) do
                t.frame.Visible = (t.btn == btn)
                TweenService:Create(t.btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = (t.btn == btn) and C.hover or C.pill,
                    TextColor3 = (t.btn == btn) and C.text or C.dim
                }):Play()
            end
        end)

        local TabElements = {}

        local function getAutoFlag(name)
            return TabName .. "_" .. name:gsub(" ", "")
        end

        function TabElements:CreateParagraph(Config)
            local pName = Config.Title or "Paragraph"
            local pText = Config.Content or ""
            local f = Instance.new("Frame")
            f.BackgroundColor3 = C.colbg
            f.Size = UDim2.new(1, 0, 0, 60)
            f.Parent = container
            corner(f, 6)
            strokeOf(f, C.border, 0)
            
            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1, -20, 0, 20)
            t.Position = UDim2.fromOffset(10, 5)
            t.BackgroundTransparency = 1
            t.Font = FONTB
            t.Text = pName
            t.TextColor3 = C.text
            t.TextSize = 13
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Parent = f
            
            local c = Instance.new("TextLabel")
            c.Size = UDim2.new(1, -20, 0, 30)
            c.Position = UDim2.fromOffset(10, 25)
            c.BackgroundTransparency = 1
            c.Font = FONTM
            c.Text = pText
            c.TextColor3 = C.dim
            c.TextSize = 12
            c.TextXAlignment = Enum.TextXAlignment.Left
            c.TextWrapped = true
            c.Parent = f
        end

        function TabElements:CreateDivider()
            local d = Instance.new("Frame")
            d.Size = UDim2.new(1, 0, 0, 1)
            d.BackgroundColor3 = C.border
            d.BorderSizePixel = 0
            d.Parent = container
        end

        function TabElements:CreateToggle(Config)
            local tName = Config.Name or "Toggle"
            local flag = getAutoFlag(tName)
            local cb = Config.Callback or function() end
            
            local default = Astral.Flags[flag]
            if type(default) ~= "boolean" then default = Config.CurrentValue or false end
            Astral.Flags[flag] = default

            local btnRow = Instance.new("TextButton") 
            btnRow.Size = UDim2.new(1, 0, 0, 40) 
            btnRow.BackgroundColor3 = C.hover 
            btnRow.BackgroundTransparency = 1 
            btnRow.Text = ""
            btnRow.Parent = container 
            corner(btnRow, 6) 
            
            local lbl = Instance.new("TextLabel") 
            lbl.Size = UDim2.new(1, -60, 1, 0) 
            lbl.Position = UDim2.fromOffset(10, 0) 
            lbl.BackgroundTransparency = 1 
            lbl.Font = FONTM 
            lbl.Text = tName 
            lbl.TextColor3 = C.text 
            lbl.TextSize = 13 
            lbl.TextXAlignment = Enum.TextXAlignment.Left 
            lbl.Parent = btnRow 
            
            local track = Instance.new("Frame") 
            track.Size = UDim2.fromOffset(38, 20) 
            track.Position = UDim2.new(1, -48, 0.5, -10) 
            track.BackgroundColor3 = default and C.accent or C.trackOff 
            track.Parent = btnRow 
            corner(track, 10) 
            
            local knob = Instance.new("Frame") 
            knob.Size = UDim2.fromOffset(16, 16) 
            knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) 
            knob.BackgroundColor3 = C.knob 
            knob.Parent = track 
            corner(knob, 8) 
            
            local st = default 
            btnRow.MouseButton1Click:Connect(function() 
                st = not st 
                Astral.Flags[flag] = st
                TweenService:Create(track, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = st and C.accent or C.trackOff}):Play() 
                TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                    Position = st and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }):Play() 
                cb(st)
                Astral:Save()
            end)
            cb(st)
        end

        function TabElements:CreateSlider(Config)
            local sName = Config.Name or "Slider"
            local flag = getAutoFlag(sName)
            local min = Config.Range[1] or 0
            local max = Config.Range[2] or 100
            local cb = Config.Callback or function() end

            local default = Astral.Flags[flag]
            if type(default) ~= "number" then default = Config.CurrentValue or min end
            Astral.Flags[flag] = default
            local current = default

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 55)
            f.BackgroundColor3 = C.colbg
            f.Parent = container
            corner(f, 6)
            strokeOf(f, C.border, 0)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -60, 0, 25)
            lbl.Position = UDim2.fromOffset(10, 5)
            lbl.BackgroundTransparency = 1
            lbl.Font = FONTM
            lbl.Text = sName
            lbl.TextColor3 = C.text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f

            local valBox = Instance.new("TextBox")
            valBox.Size = UDim2.new(0, 45, 0, 20)
            valBox.Position = UDim2.new(1, -55, 0, 8)
            valBox.BackgroundColor3 = C.bg
            valBox.Font = FONTM
            valBox.Text = tostring(current)
            valBox.TextColor3 = C.text
            valBox.TextSize = 12
            valBox.Parent = f
            corner(valBox, 4)
            strokeOf(valBox, C.border, 0)

            local track = Instance.new("TextButton")
            track.Size = UDim2.new(1, -20, 0, 8)
            track.Position = UDim2.new(0, 10, 0, 35)
            track.BackgroundColor3 = C.bg
            track.Text = ""
            track.AutoButtonColor = false
            track.Parent = f
            corner(track, 4)
            strokeOf(track, C.border, 0)

            local fill = Instance.new("Frame")
            local startSize = math.clamp((current - min) / (max - min), 0, 1)
            fill.Size = UDim2.new(startSize, 0, 1, 0)
            fill.BackgroundColor3 = C.accent
            fill.Parent = track
            corner(fill, 4)

            local dragging = false
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + ((max - min) * pos))
                TweenService:Create(fill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                valBox.Text = tostring(value)
                Astral.Flags[flag] = value
                cb(value)
                Astral:Save()
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            valBox.FocusLost:Connect(function()
                local num = tonumber(valBox.Text)
                if num then
                    num = math.clamp(num, min, max)
                    local pos = (num - min) / (max - min)
                    TweenService:Create(fill, TweenInfo.new(0.2), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                    valBox.Text = tostring(num)
                    Astral.Flags[flag] = num
                    cb(num)
                    Astral:Save()
                else
                    valBox.Text = tostring(Astral.Flags[flag])
                end
            end)

            cb(current)
        end

        function TabElements:CreateDropdown(Config)
            local dName = Config.Name or "Dropdown"
            local flag = getAutoFlag(dName)
            local options = Config.Options or {}
            local cb = Config.Callback or function() end

            local default = Astral.Flags[flag]
            if not default then default = Config.CurrentOption or options[1] or "" end
            Astral.Flags[flag] = default

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 45)
            f.BackgroundColor3 = C.colbg
            f.ClipsDescendants = true
            f.Parent = container
            corner(f, 6)
            strokeOf(f, C.border, 0)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 45)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = f

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 1, 0)
            lbl.Position = UDim2.fromOffset(10, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = FONTM
            lbl.Text = dName .. " : " .. default
            lbl.TextColor3 = C.text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = btn

            local icon = Instance.new("TextLabel")
            icon.Size = UDim2.new(0, 20, 0, 20)
            icon.Position = UDim2.new(1, -30, 0.5, -10)
            icon.BackgroundTransparency = 1
            icon.Font = FONTB
            icon.Text = "+"
            icon.TextColor3 = C.dim
            icon.TextSize = 16
            icon.Parent = btn

            local dropContainer = Instance.new("ScrollingFrame")
            dropContainer.Size = UDim2.new(1, -20, 1, -55)
            dropContainer.Position = UDim2.fromOffset(10, 45)
            dropContainer.BackgroundTransparency = 1
            dropContainer.ScrollBarThickness = 2
            dropContainer.ScrollBarImageColor3 = C.border
            dropContainer.Parent = f
            
            local list = Instance.new("UIListLayout")
            list.Padding = UDim.new(0, 4)
            list.Parent = dropContainer

            local isOpen = false
            btn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                icon.Text = isOpen and "-" or "+"
                local targetHeight = isOpen and math.clamp(#options * 34 + 55, 45, 150) or 45
                TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            end)

            for _, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, -10, 0, 30)
                optBtn.BackgroundColor3 = C.pill
                optBtn.Font = FONTM
                optBtn.Text = opt
                optBtn.TextColor3 = C.dim
                optBtn.TextSize = 12
                optBtn.Parent = dropContainer
                corner(optBtn, 4)
                strokeOf(optBtn, C.border, 0)

                optBtn.MouseButton1Click:Connect(function()
                    Astral.Flags[flag] = opt
                    lbl.Text = dName .. " : " .. opt
                    isOpen = false
                    icon.Text = "+"
                    TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                    cb(opt)
                    Astral:Save()
                end)
            end
            cb(default)
        end

        function TabElements:CreateTextbox(Config)
            local tName = Config.Name or "Textbox"
            local flag = getAutoFlag(tName)
            local placeholder = Config.PlaceholderText or "Input here..."
            local clearOnFocus = Config.RemoveTextAfterFocusLost or false
            local cb = Config.Callback or function() end

            local default = Astral.Flags[flag]
            if type(default) ~= "string" then default = "" end
            if not clearOnFocus then Astral.Flags[flag] = default end

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 45)
            f.BackgroundColor3 = C.colbg
            f.Parent = container
            corner(f, 6)
            strokeOf(f, C.border, 0)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -170, 1, 0)
            lbl.Position = UDim2.fromOffset(10, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = FONTM
            lbl.Text = tName
            lbl.TextColor3 = C.text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0, 150, 0, 30)
            box.Position = UDim2.new(1, -160, 0.5, -15)
            box.BackgroundColor3 = C.bg
            box.PlaceholderText = placeholder
            box.Text = ""
            box.Font = FONTM
            box.TextSize = 12
            box.TextColor3 = C.text
            box.ClearTextOnFocus = false
            box.Parent = f
            corner(box, 6)
            strokeOf(box, C.border, 0)

            if not clearOnFocus then
                box.Text = default
                cb(default)
            end

            box.FocusLost:Connect(function()
                if not clearOnFocus then
                    Astral.Flags[flag] = box.Text
                    Astral:Save()
                end
                cb(box.Text)
                if clearOnFocus then box.Text = "" end
            end)
        end

        function TabElements:CreateColorPicker(Config)
            local cName = Config.Name or "Color Picker"
            local flag = getAutoFlag(cName)
            local cb = Config.Callback or function() end

            local default = Config.CurrentColor or Color3.fromRGB(255, 255, 255)
            local saved = Astral.Flags[flag]
            
            if type(saved) == "table" and saved.R and saved.G and saved.B then
                default = Color3.new(saved.R, saved.G, saved.B)
            else
                Astral.Flags[flag] = {R = default.R, G = default.G, B = default.B}
            end

            local h, s, v = default:ToHSV()

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 45)
            f.BackgroundColor3 = C.colbg
            f.ClipsDescendants = true
            f.Parent = container
            corner(f, 6)
            strokeOf(f, C.border, 0)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -60, 0, 45)
            lbl.Position = UDim2.fromOffset(10, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = FONTM
            lbl.Text = cName
            lbl.TextColor3 = C.text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f

            local display = Instance.new("TextButton")
            display.Size = UDim2.new(0, 45, 0, 25)
            display.Position = UDim2.new(1, -55, 0, 10)
            display.BackgroundColor3 = default
            display.Text = ""
            display.AutoButtonColor = false
            display.Parent = f
            corner(display, 4)
            strokeOf(display, C.border, 0)

            local controlsArea = Instance.new("Frame")
            controlsArea.Size = UDim2.new(1, -20, 0, 110)
            controlsArea.Position = UDim2.fromOffset(10, 50)
            controlsArea.BackgroundTransparency = 1
            controlsArea.Parent = f

            -- SV 2D MAP
            local svMap = Instance.new("TextButton")
            svMap.Size = UDim2.new(1, -30, 1, 0)
            svMap.Position = UDim2.new(0, 0, 0, 0)
            svMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            svMap.Text = ""
            svMap.AutoButtonColor = false
            svMap.ClipsDescendants = true
            svMap.Parent = controlsArea
            corner(svMap, 4)
            strokeOf(svMap, C.border, 0)

            local satGradient = Instance.new("Frame")
            satGradient.Size = UDim2.new(1, 0, 1, 0)
            satGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            satGradient.BorderSizePixel = 0
            satGradient.Parent = svMap
            
            local uigSat = Instance.new("UIGradient")
            uigSat.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            uigSat.Parent = satGradient

            local valGradient = Instance.new("Frame")
            valGradient.Size = UDim2.new(1, 0, 1, 0)
            valGradient.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            valGradient.BorderSizePixel = 0
            valGradient.Parent = svMap
            
            local uigVal = Instance.new("UIGradient")
            uigVal.Rotation = 90
            uigVal.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0)
            })
            uigVal.Parent = valGradient

            local svCursor = Instance.new("Frame")
            svCursor.Size = UDim2.fromOffset(8, 8)
            svCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            svCursor.Position = UDim2.new(s, -4, 1 - v, -4)
            svCursor.Parent = svMap
            corner(svCursor, 4)
            strokeOf(svCursor, Color3.fromRGB(0, 0, 0), 0)

            -- VERTICAL HUE SLIDER
            local hueSlider = Instance.new("TextButton")
            hueSlider.Size = UDim2.new(0, 20, 1, 0)
            hueSlider.Position = UDim2.new(1, -20, 0, 0)
            hueSlider.Text = ""
            hueSlider.AutoButtonColor = false
            hueSlider.Parent = controlsArea
            corner(hueSlider, 4)
            strokeOf(hueSlider, C.border, 0)

            local hueGradient = Instance.new("UIGradient")
            hueGradient.Rotation = 90
            hueGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
            hueGradient.Parent = hueSlider

            local hueCursor = Instance.new("Frame")
            hueCursor.Size = UDim2.new(1, 0, 0, 4)
            hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            hueCursor.Position = UDim2.new(0, 0, 1 - h, -2)
            hueCursor.Parent = hueSlider
            strokeOf(hueCursor, Color3.fromRGB(0, 0, 0), 0)

            local function updateColor()
                local color = Color3.fromHSV(h, s, v)
                display.BackgroundColor3 = color
                svMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                Astral.Flags[flag] = {R = color.R, G = color.G, B = color.B}
                cb(color)
                Astral:Save()
            end

            local draggingSV = false
            local draggingHue = false

            local function handleSV(input)
                local pos = Vector2.new(
                    math.clamp((input.Position.X - svMap.AbsolutePosition.X) / svMap.AbsoluteSize.X, 0, 1),
                    math.clamp((input.Position.Y - svMap.AbsolutePosition.Y) / svMap.AbsoluteSize.Y, 0, 1)
                )
                s = pos.X
                v = 1 - pos.Y
                TweenService:Create(svCursor, TweenInfo.new(0.05), {Position = UDim2.new(s, -4, 1 - v, -4)}):Play()
                updateColor()
            end

            local function handleHue(input)
                local posY = math.clamp((input.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                h = 1 - posY
                TweenService:Create(hueCursor, TweenInfo.new(0.05), {Position = UDim2.new(0, 0, posY, -2)}):Play()
                updateColor()
            end

            svMap.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSV = true
                    handleSV(input)
                end
            end)

            hueSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingHue = true
                    handleHue(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSV = false
                    draggingHue = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    if draggingSV then handleSV(input) end
                    if draggingHue then handleHue(input) end
                end
            end)

            local isOpen = false
            display.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                    Size = isOpen and UDim2.new(1, 0, 0, 170) or UDim2.new(1, 0, 0, 45)
                }):Play()
            end)

            cb(default)
        end

        return TabElements
    end
    
    return WindowElements
end

return Astral
