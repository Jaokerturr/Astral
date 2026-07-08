# Astral Library Documentation

## Booting the Library
local Astral = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL_HERE"))()

## Creating a Window
local Window = Astral:CreateWindow({
    Name = "Title of the library",
    ConfigName = "SaveName",
    ConfigFolder = "AstralConfigs"
})

## Creating a Tab
local Tab = Window:CreateTab("Tab 1")

## Creating a Paragraph
Tab:CreateParagraph({
    Title = "Paragraph",
    Content = "Paragraph Content"
})

## Creating a Divider
Tab:CreateDivider()

## Notifying the user
Window:Notify({
    Title = "Title!",
    Content = "Notification content..."
})

## Creating a Toggle
Tab:CreateToggle({
    Name = "This is a toggle!",
    Flag = "ToggleFlag",
    CurrentValue = false,
    Callback = function(Value)
        -- Logic here
    end
})

## Creating a Slider
Tab:CreateSlider({
    Name = "Slider",
    Flag = "SliderFlag",
    Range = {0, 100},
    CurrentValue = 50,
    Callback = function(Value)
        -- Logic here
    end
})

## Creating a Textbox
Tab:CreateTextbox({
    Name = "Textbox",
    Flag = "TextboxFlag",
    PlaceholderText = "Input here...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Value)
        -- Logic here
    end
})

## Creating a Color Picker
Tab:CreateColorPicker({
    Name = "Colorpicker",
    Flag = "ColorFlag",
    CurrentColor = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        -- Logic here
    end
})

## Flags and Saving
-- The 'Flag' argument is the ID used to save your data in the JSON file. 
-- Astral automatically saves to your specified 'ConfigFolder'.

-- Accessing flags manually:
print(Astral.Flags["ToggleFlag"])
