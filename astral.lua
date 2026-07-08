local Astral = {Flags = {}, ConfigName = "", ConfigFolder = "AstralConfigs"}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local C = {
    bg = Color3.fromRGB(17, 17, 20),
    header = Color3.fromRGB(23, 23, 27),
    colbg = Color3.fromRGB(24, 24, 29),
    border = Color3.fromRGB(44, 44, 51),
    hover = Color3.fromRGB(34, 34, 40),
    text = Color3.fromRGB(233, 233, 238),
    dim = Color3.fromRGB(150, 150, 160),
    blue = Color3.fromRGB(72, 130, 248),
    trackOff = Color3.fromRGB(58, 58, 66),
    pill = Color3.fromRGB(33, 33, 40),
    knob = Color3.fromRGB(240, 240, 245)
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
    if self.ConfigName == "" then return end
    if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end
    local data = HttpService:JSONEncode(self.Flags)
    writefile(self.ConfigFolder .. "/" .. self.ConfigName .. ".json", data)
end

function Astral:Load()
    if self.ConfigName == "" then return end
    local path = self.ConfigFolder .. "/" .. self.ConfigName .. ".json"
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
    self.ConfigName = Config.ConfigName or ""
    self.ConfigFolder = Config.ConfigFolder or "AstralConfigs"
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
        task.delay(3, function() NFrame:Destroy() end)
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
            local flag = Config.Flag or tName
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
            lbl.TextSize = 14 
            lbl.TextXAlignment = Enum.TextXAlignment.Left 
            lbl.Parent = btnRow 
            
            local track = Instance.new("Frame") 
            track.Size = UDim2.fromOffset(38, 20) 
            track.Position = UDim2.new(1, -48, 0.5, -10) 
            track.BackgroundColor3 = default and C.blue or C.trackOff 
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
                TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = st and C.blue or C.trackOff}):Play() 
                TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                    Position = st and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }):Play() 
                cb(st)
                Astral:Save()
            end)
            cb(st)
        end

        function TabElements:CreateSlider(Config)
            local sName = Config.Name or "Slider"
            local flag = Config.Flag or sName
            local min = Config.Range[1] or 0
            local max = Config.Range[2] or 100
            local cb = Config.Callback or function() end

            local default = Astral.Flags[flag]
            if type(default) ~= "number" then default = Config.CurrentValue or min end
            Astral.Flags[flag] = default
            local current = default

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 50)
            f.BackgroundTransparency = 1
            f.Parent = container

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -40, 0, 20)
            lbl.Position = UDim2.fromOffset(10, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = FONTM
            lbl.Text = sName
            lbl.TextColor3 = C.text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f

            local valLbl = Instance.new("TextLabel")
            valLbl.Size = UDim2.new(0, 40, 0, 20)
            valLbl.Position = UDim2.new(1, -50, 0, 0)
            valLbl.BackgroundTransparency = 1
            valLbl.Font = FONTM
            valLbl.Text = tostring(current)
            valLbl.TextColor3 = C.dim
            valLbl.TextSize = 13
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Parent = f

            local track = Instance.new("TextButton")
            track.Size = UDim2.new(1, -20, 0, 6)
            track.Position = UDim2.new(0, 10, 0, 30)
            track.BackgroundColor3 = C.colbg
            track.Text = ""
            track.AutoButtonColor = false
            track.Parent = f
            corner(track, 3)
            strokeOf(track, C.border, 0)

            local fill = Instance.new("Frame")
            local startSize = math.clamp((current - min) / (max - min), 0, 1)
            fill.Size = UDim2.new(startSize, 0, 1, 0)
            fill.BackgroundColor3 = C.blue
            fill.Parent = track
            corner(fill, 3)

            local dragging = false
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + ((max - min) * pos))
                fill.Size = UDim2.new(pos, 0, 1, 0)
                valLbl.Text = tostring(value)
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
            cb(current)
        end

        function TabElements:CreateTextbox(Config)
            local tName = Config.Name or "Textbox"
            local flag = Config.Flag or tName
            local placeholder = Config.PlaceholderText or "Input here..."
            local clearOnFocus = Config.RemoveTextAfterFocusLost or false
            local cb = Config.Callback or function() end

            local default = Astral.Flags[flag]
            if type(default) ~= "string" then default = "" end
            if not clearOnFocus then Astral.Flags[flag] = default end

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 40)
            f.BackgroundTransparency = 1
            f.Parent = container

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -160, 1, 0)
            lbl.Position = UDim2.fromOffset(10, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = FONTM
            lbl.Text = tName
            lbl.TextColor3 = C.text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0, 140, 0, 30)
            box.Position = UDim2.new(1, -150, 0.5, -15)
            box.BackgroundColor3 = C.pill
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
            local flag = Config.Flag or cName
            local cb = Config.Callback or function() end

            local default = Config.CurrentColor or Color3.fromRGB(255, 255, 255)
            local saved = Astral.Flags[flag]
            if type(saved) == "table" and saved.R and saved.G and saved.B then
                default = Color3.new(saved.R, saved.G, saved.B)
            else
                Astral.Flags[flag] = {R = default.R, G = default.G, B = default.B}
            end

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 40)
            f.BackgroundTransparency = 1
            f.Parent = container

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -60, 1, 0)
            lbl.Position = UDim2.fromOffset(10, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = FONTM
            lbl.Text = cName
            lbl.TextColor3 = C.text
            lbl.TextSize = 13
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = f

            local display = Instance.new("TextButton")
            display.Size = UDim2.new(0, 40, 0, 24)
            display.Position = UDim2.new(1, -50, 0.5, -12)
            display.BackgroundColor3 = default
            display.Text = ""
            display.AutoButtonColor = false
            display.Parent = f
            corner(display, 4)
            strokeOf(display, C.border, 0)

            local dropdown = Instance.new("Frame")
            dropdown.Size = UDim2.new(1, 0, 0, 100)
            dropdown.BackgroundColor3 = C.colbg
            dropdown.Visible = false
            dropdown.Parent = container
            corner(dropdown, 6)

            local function makeRgbSlider(name, yPos, colorComponent, baseValue)
                local slbl = Instance.new("TextLabel")
                slbl.Size = UDim2.new(0, 20, 0, 20)
                slbl.Position = UDim2.new(0, 10, 0, yPos)
                slbl.BackgroundTransparency = 1
                slbl.Text = name
                slbl.TextColor3 = C.dim
                slbl.Font = FONTB
                slbl.TextSize = 12
                slbl.Parent = dropdown

                local t = Instance.new("TextButton")
                t.Size = UDim2.new(1, -50, 0, 6)
                t.Position = UDim2.new(0, 40, 0, yPos + 7)
                t.BackgroundColor3 = C.bg
                t.Text = ""
                t.AutoButtonColor = false
                t.Parent = dropdown
                corner(t, 3)

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(baseValue, 0, 1, 0)
                fill.BackgroundColor3 = colorComponent
                fill.Parent = t
                corner(fill, 3)
                return t, fill
            end

            local rT, rF = makeRgbSlider("R", 10, Color3.fromRGB(255, 50, 50), default.R)
            local gT, gF = makeRgbSlider("G", 40, Color3.fromRGB(50, 255, 50), default.G)
            local bT, bF = makeRgbSlider("B", 70, Color3.fromRGB(50, 150, 255), default.B)

            local currentColor = default
            local function updateColor()
                display.BackgroundColor3 = currentColor
                Astral.Flags[flag] = {R = currentColor.R, G = currentColor.G, B = currentColor.B}
                cb(currentColor)
                Astral:Save()
            end

            local function attachSlider(btn, fill, channel)
                local dragging = false
                btn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local pos = math.clamp((input.Position.X - btn.AbsolutePosition.X) / btn.AbsoluteSize.X, 0, 1)
                        fill.Size = UDim2.new(pos, 0, 1, 0)
                        local r, g, b = currentColor.R, currentColor.G, currentColor.B
                        if channel == "R" then r = pos elseif channel == "G" then g = pos else b = pos end
                        currentColor = Color3.new(r, g, b)
                        updateColor()
                    end
                end)
            end

            attachSlider(rT, rF, "R")
            attachSlider(gT, gF, "G")
            attachSlider(bT, bF, "B")

            display.MouseButton1Click:Connect(function()
                dropdown.Visible = not dropdown.Visible
                f.Size = dropdown.Visible and UDim2.new(1, 0, 0, 145) or UDim2.new(1, 0, 0, 40)
            end)
            cb(currentColor)
        end

        return TabElements
    end
    
    return WindowElements
end

return Astral
