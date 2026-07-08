# Astral Library Documentation

## Booting the Library
```lua
local Astral = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL_HERE"))()
```

## Creating a Window
```lua
local Window = Astral:CreateWindow({
    Name = "Title of the library",
    ConfigName = "SaveName",
    ConfigFolder = "AstralConfigs"
})
```

## Creating a Tab
```lua
local Tab = Window:CreateTab("Tab 1")
```

## Creating a Paragraph
```lua
Tab:CreateParagraph({
    Title = "Paragraph",
    Content = "Paragraph Content"
})
```

## Creating a Divider
```lua
Tab:CreateDivider()
```

## Notifying the user
```lua
Window:Notify({
    Title = "Title!",
    Content = "Notification content..."
})
```

## Creating a Toggle
```lua
Tab:CreateToggle({
    Name = "This is a toggle!",
    Flag = "ToggleFlag",
    CurrentValue = false,
    Callback = function(Value)
        -- Logic here
    end
})
```

## Creating a Slider
```lua
Tab:CreateSlider({
    Name = "Slider",
    Flag = "SliderFlag",
    Range = {0, 100},
    CurrentValue = 50,
    Callback = function(Value)
        -- Logic here
    end
})
```

## Creating a Textbox
```lua
Tab:CreateTextbox({
    Name = "Textbox",
    Flag = "TextboxFlag",
    PlaceholderText = "Input here...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Value)
        -- Logic here
    end
})
```

## Creating a Color Picker
```lua
Tab:CreateColorPicker({
    Name = "Colorpicker",
    Flag = "ColorFlag",
    CurrentColor = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        -- Logic here
    end
})
```

## Flags and Saving
-- The 'Flag' argument is the ID used to save your data in the JSON file. 
-- Astral automatically saves to your specified 'ConfigFolder'.

-- Accessing flags manually:
```lua
print(Astral.Flags["ToggleFlag"])
```

## Example Script Using Astral lib

```lua
local Astral = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL_HERE"))()

local Window = Astral:CreateWindow({
    Name = "Example Title",
    ConfigName = "ExampleScriptSave",
    ConfigFolder = "AstralConfigs"
})

local PlayerTab = Window:CreateTab("Player")
local WorldTab = Window:CreateTab("World")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

PlayerTab:CreateParagraph({
    Title = "Local Player Modifications",
    Content = "Adjust your character settings below. Sliders apply immediately."
})

PlayerTab:CreateDivider()

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Flag = "WS_Slider",
    Range = {16, 250},
    CurrentValue = 16,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "JumpPower",
    Flag = "JP_Slider",
    Range = {50, 300},
    CurrentValue = 50,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end,
})

PlayerTab:CreateTextbox({
    Name = "Teleport to Player",
    Flag = "TP_Box",
    PlaceholderText = "Enter Username...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        local target
        for _, v in pairs(Players:GetPlayers()) do
            if string.sub(string.lower(v.Name), 1, string.len(Text)) == string.lower(Text) then
                target = v
                break
            end
        end

        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                Window:Notify({Title = "Teleported", Content = "Moved to " .. target.Name})
            end
        else
            Window:Notify({Title = "Error", Content = "Player not found."})
        end
    end,
})

WorldTab:CreateParagraph({
    Title = "Environment Settings",
    Content = "Change the look and feel of the map."
})

WorldTab:CreateToggle({
    Name = "Fullbright",
    Flag = "FullbrightToggle",
    CurrentValue = false,
    Callback = function(State)
        if State then
            Lighting.GlobalShadows = false
            Lighting.Brightness = 3
        else
            Lighting.GlobalShadows = true
            Lighting.Brightness = 1
        end
    end,
})

WorldTab:CreateColorPicker({
    Name = "Ambient Light Color",
    Flag = "AmbientColor",
    CurrentColor = Lighting.Ambient,
    Callback = function(Color)
        Lighting.Ambient = Color
        Lighting.OutdoorAmbient = Color
    end,
})
```
