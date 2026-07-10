# Astral Library Documentation

## Booting the Library
```lua
local Astral = loadstring(game:HttpGet("[https://raw.githubusercontent.com/Jaokerturr/Astral/refs/heads/main/astral.lua](https://raw.githubusercontent.com/Jaokerturr/Astral/refs/heads/main/astral.lua)"))()
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

## Creating a button
```lua
Tab:CreateButton({
    Name = "Click Me!",
    Callback = function()
        -- Logic here
        print("Button clicked!")
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

## Creating a DropDown
```lua
Tab:CreateDropdown({
    Name = "Dropdown",
    Flag = "DropdownFlag",
    Options = {"Option 1", "Option 2", "Option 3"},
    Callback = function(Value)
        -- Logic here
        print("Selected: " .. Value)
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
 The 'Flag' argument is the ID used to save your data in the JSON file. 
 Astral automatically saves to your specified 'ConfigFolder'.

 Accessing flags manually:
```lua
print(Astral.Flags["ToggleFlag"])
```

## Example Script Using Astral lib
```lua
local Astral = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jaokerturr/Astral/refs/heads/main/astral.lua"))()

local Window = Astral:CreateWindow({
    Name = "Example Title",
    ConfigName = "ExampleScriptSave",
    ConfigFolder = "AstralConfigs"
})

local PlayerTab = Window:CreateTab("Player")
local WorldTab = Window:CreateTab("World")

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SelectedUsername = nil

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

local function GetPlayerList()
    local Options = {}
    for _, Player in pairs(Players:GetPlayers()) do
        table.insert(Options, Player.DisplayName .. " (" .. Player.Name .. ")")
    end
    return Options
end

PlayerTab:CreateDropdown({
    Name = "Select Player",
    Flag = "TP_Dropdown",
    Options = GetPlayerList(),
    Callback = function(Value)
        local Username = string.match(Value, "%((.+)%)$")
        SelectedUsername = Username
    end
})

PlayerTab:CreateButton({
    Name = "Teleport to Player",
	Flag = "TpBtn",
    Callback = function()
        if SelectedUsername then
            local Target = Players:FindFirstChild(SelectedUsername)
            
            if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
                    Window:Notify({Title = "Teleported", Content = "Moved to " .. Target.Name})
                end
            else
                Window:Notify({Title = "Error", Content = "Player not found or character missing."})
            end
        else
            Window:Notify({Title = "Error", Content = "Please select a player first."})
        end
    end
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
