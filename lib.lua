--[[
    Advanced UI Library
    
    A modern, feature-rich UI library for Roblox with:
    - Tabs
    - Sections
    - Toggles
    - Sliders
    - Color Pickers
    - Keybind Setters
    - Dropdowns
    - Buttons
    - Text Inputs
    
    Easy to use and customize!
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ========================================
-- LIBRARY TABLE
-- ========================================
local Library = {}

-- ========================================
-- UTILITY FUNCTIONS
-- ========================================

-- Create a tween animation
local function Tween(object, properties, duration, style, direction)
    duration = duration or 0.2
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Convert Color3 to Hex
local function ColorToHex(color)
    return string.format("#%02X%02X%02X", 
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255)
    )
end

-- Convert Hex to Color3
local function HexToColor(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
    )
end

-- ========================================
-- MAIN WINDOW CREATION
-- ========================================

--[[
    Creates the main window
    
    Parameters:
    - title: string - The title of the window
    
    Returns:
    - Window table with methods to add tabs
]]
function Library:CreateWindow(title)
    title = title or "UI Library"
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Window Frame
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Parent = ScreenGui
    MainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainWindow.BorderColor3 = Color3.fromRGB(50, 50, 50)
    MainWindow.BorderSizePixel = 1
    MainWindow.Position = UDim2.new(0.5, -300, 0.5, -250)
    MainWindow.Size = UDim2.new(0, 600, 0, 500)
    MainWindow.Active = true
    MainWindow.ClipsDescendants = true
    
    -- Make window draggable
    local dragging = false
    local dragInput, mousePos, framePos
    
    MainWindow.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = MainWindow.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    MainWindow.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            MainWindow.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Accent Line (Top border)
    local AccentLine = Instance.new("Frame")
    AccentLine.Name = "AccentLine"
    AccentLine.Parent = MainWindow
    AccentLine.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    AccentLine.BorderSizePixel = 0
    AccentLine.Size = UDim2.new(1, 0, 0, 2)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainWindow
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TitleBar.BorderSizePixel = 0
    TitleBar.Position = UDim2.new(0, 0, 0, 2)
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    
    -- Title Text
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Font = Enum.Font.Code
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Font = Enum.Font.Code
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    CloseButton.TextSize = 14
    
    -- Close button hover effect
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {TextColor3 = Color3.fromRGB(255, 100, 100)})
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {TextColor3 = Color3.fromRGB(200, 200, 200)})
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab Container (Left sidebar)
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainWindow
    TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 32)
    TabContainer.Size = UDim2.new(0, 140, 1, -32)
    
    -- Tab Separator Line
    local TabSeparator = Instance.new("Frame")
    TabSeparator.Name = "Separator"
    TabSeparator.Parent = TabContainer
    TabSeparator.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabSeparator.BorderSizePixel = 0
    TabSeparator.Position = UDim2.new(1, 0, 0, 0)
    TabSeparator.Size = UDim2.new(0, 1, 1, 0)
    
    -- Tab List Layout
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 0)
    
    -- Content Container (Right side)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainWindow
    ContentContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Position = UDim2.new(0, 141, 0, 32)
    ContentContainer.Size = UDim2.new(1, -141, 1, -32)
    ContentContainer.ClipsDescendants = true
    
    -- Parent to CoreGui
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Window object
    local Window = {
        ScreenGui = ScreenGui,
        MainWindow = MainWindow,
        TabContainer = TabContainer,
        ContentContainer = ContentContainer,
        Tabs = {},
        CurrentTab = nil
    }
    
    return Window
end

-- ========================================
-- TAB CREATION
-- ========================================

--[[
    Creates a new tab in the window
    
    Parameters:
    - Window: table - The window object
    - name: string - The name of the tab
    
    Returns:
    - Tab table with methods to add elements
]]
function Library:CreateTab(Window, name)
    name = name or "Tab"
    
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = Window.TabContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, 0, 0, 36)
    TabButton.Font = Enum.Font.Code
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(160, 160, 160)
    TabButton.TextSize = 13
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Tab Button Padding
    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabButton
    TabPadding.PaddingLeft = UDim.new(0, 15)
    
    -- Tab Indicator (Left accent line)
    local TabIndicator = Instance.new("Frame")
    TabIndicator.Name = "Indicator"
    TabIndicator.Parent = TabButton
    TabIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    TabIndicator.BorderSizePixel = 0
    TabIndicator.Position = UDim2.new(0, 0, 0, 0)
    TabIndicator.Size = UDim2.new(0, 0, 1, 0)
    
    -- Tab Content Container
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = Window.ContentContainer
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    TabContent.Visible = false
    
    -- Tab Content Padding
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.Parent = TabContent
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingTop = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    
    -- Tab Content Layout
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = TabContent
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    
    -- Update canvas size when content changes
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 30)
    end)
    
    -- Tab hover effects
    TabButton.MouseEnter:Connect(function()
        if TabIndicator.Size.X.Offset == 0 then
            Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(22, 22, 22)})
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if TabIndicator.Size.X.Offset == 0 then
            Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(18, 18, 18)})
        end
    end)
    
    -- Tab click handler
    TabButton.MouseButton1Click:Connect(function()
        -- Deselect all tabs
        for _, tab in pairs(Window.Tabs) do
            tab.Button.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            tab.Button.TextColor3 = Color3.fromRGB(160, 160, 160)
            tab.Indicator.Size = UDim2.new(0, 0, 1, 0)
            tab.Content.Visible = false
        end
        
        -- Select this tab
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        Tween(TabIndicator, {Size = UDim2.new(0, 3, 1, 0)}, 0.15)
        TabContent.Visible = true
        
        Window.CurrentTab = Tab
    end)
    
    -- Tab object
    local Tab = {
        Button = TabButton,
        Indicator = TabIndicator,
        Content = TabContent,
        Layout = ContentLayout,
        Elements = {}
    }
    
    -- Add to window tabs
    table.insert(Window.Tabs, Tab)
    
    -- Select first tab automatically
    if #Window.Tabs == 1 then
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        TabIndicator.Size = UDim2.new(0, 3, 1, 0)
        TabContent.Visible = true
        Window.CurrentTab = Tab
    end
    
    return Tab
end

-- ========================================
-- SECTION HEADER
-- ========================================

--[[
    Creates a section header to organize elements
    
    Parameters:
    - Tab: table - The tab object
    - text: string - The section title
    
    Returns:
    - Section frame
]]
function Library:CreateSection(Tab, text)
    text = text or "Section"
    
    -- Section Frame
    local Section = Instance.new("Frame")
    Section.Name = text
    Section.Parent = Tab.Content
    Section.BackgroundTransparency = 1
    Section.Size = UDim2.new(1, 0, 0, 26)
    
    -- Section Label
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Parent = Section
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Size = UDim2.new(1, 0, 1, 0)
    SectionLabel.Font = Enum.Font.Code
    SectionLabel.Text = text
    SectionLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
    SectionLabel.TextSize = 14
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Section Underline
    local Underline = Instance.new("Frame")
    Underline.Parent = Section
    Underline.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Underline.BorderSizePixel = 0
    Underline.Position = UDim2.new(0, 0, 1, -1)
    Underline.Size = UDim2.new(1, 0, 0, 1)
    
    return Section
end

-- ========================================
-- TOGGLE (CHECKBOX)
-- ========================================

--[[
    Creates a toggle/checkbox element
    
    Parameters:
    - Tab: table - The tab object
    - text: string - The toggle label
    - default: boolean - Default state (true/false)
    - callback: function - Function called when toggled, receives boolean value
    
    Returns:
    - Toggle object with methods
    
    Example:
    local toggle = Library:CreateToggle(tab, "Enable Feature", false, function(value)
        print("Toggle is now:", value)
    end)
]]
function Library:CreateToggle(Tab, text, default, callback)
    text = text or "Toggle"
    default = default or false
    callback = callback or function() end
    
    -- Toggle Frame
    local Toggle = Instance.new("Frame")
    Toggle.Name = text
    Toggle.Parent = Tab.Content
    Toggle.BackgroundTransparency = 1
    Toggle.Size = UDim2.new(1, 0, 0, 22)
    
    -- Toggle Checkbox
    local ToggleBox = Instance.new("TextButton")
    ToggleBox.Name = "Box"
    ToggleBox.Parent = Toggle
    ToggleBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToggleBox.BorderColor3 = default and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(50, 50, 50)
    ToggleBox.BorderSizePixel = 1
    ToggleBox.Size = UDim2.new(0, 14, 0, 14)
    ToggleBox.Position = UDim2.new(0, 0, 0, 4)
    ToggleBox.Text = ""
    
    -- Checkmark
    local Checkmark = Instance.new("Frame")
    Checkmark.Name = "Checkmark"
    Checkmark.Parent = ToggleBox
    Checkmark.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Checkmark.BorderSizePixel = 0
    Checkmark.Position = UDim2.new(0.5, -5, 0.5, -5)
    Checkmark.Size = UDim2.new(0, 10, 0, 10)
    Checkmark.Visible = default
    
    -- Toggle Label
    local Label = Instance.new("TextLabel")
    Label.Parent = Toggle
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Font = Enum.Font.Code
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Toggle state
    local toggled = default
    
    -- Toggle click handler
    ToggleBox.MouseButton1Click:Connect(function()
        toggled = not toggled
        Checkmark.Visible = toggled
        ToggleBox.BorderColor3 = toggled and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(50, 50, 50)
        callback(toggled)
    end)
    
    -- Hover effects
    ToggleBox.MouseEnter:Connect(function()
        Tween(ToggleBox, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
    end)
    
    ToggleBox.MouseLeave:Connect(function()
        Tween(ToggleBox, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
    end)
    
    -- Toggle object with methods
    local ToggleObj = {
        Frame = Toggle,
        Box = ToggleBox,
        Checkmark = Checkmark,
        Label = Label,
        Value = toggled,
        
        -- Method to set toggle state programmatically
        SetValue = function(self, value)
            toggled = value
            self.Value = value
            Checkmark.Visible = value
            ToggleBox.BorderColor3 = value and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(50, 50, 50)
            callback(value)
        end,
        
        -- Method to get current value
        GetValue = function(self)
            return toggled
        end
    }
    
    return ToggleObj
end

-- ========================================
-- SLIDER
-- ========================================

--[[
    Creates a slider element
    
    Parameters:
    - Tab: table - The tab object
    - text: string - The slider label
    - min: number - Minimum value
    - max: number - Maximum value
    - default: number - Default value
    - callback: function - Function called when value changes, receives number value
    
    Returns:
    - Slider object with methods
    
    Example:
    local slider = Library:CreateSlider(tab, "Speed", 0, 100, 50, function(value)
        print("Slider value:", value)
    end)
]]
function Library:CreateSlider(Tab, text, min, max, default, callback)
    text = text or "Slider"
    min = min or 0
    max = max or 100
    default = default or min
    callback = callback or function() end
    
    -- Slider Frame
    local Slider = Instance.new("Frame")
    Slider.Name = text
    Slider.Parent = Tab.Content
    Slider.BackgroundTransparency = 1
    Slider.Size = UDim2.new(1, 0, 0, 45)
    
    -- Slider Label
    local Label = Instance.new("TextLabel")
    Label.Parent = Slider
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -50, 0, 18)
    Label.Font = Enum.Font.Code
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Value Label
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = Slider
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -50, 0, 0)
    ValueLabel.Size = UDim2.new(0, 50, 0, 18)
    ValueLabel.Font = Enum.Font.Code
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    -- Slider Background
    local SliderBack = Instance.new("Frame")
    SliderBack.Parent = Slider
    SliderBack.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SliderBack.BorderColor3 = Color3.fromRGB(50, 50, 50)
    SliderBack.BorderSizePixel = 1
    SliderBack.Position = UDim2.new(0, 0, 0, 24)
    SliderBack.Size = UDim2.new(1, 0, 0, 16)
    
    -- Slider Fill (Progress bar)
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBack
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    -- Slider Button (Draggable handle)
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderBack
    SliderButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    SliderButton.BorderSizePixel = 0
    SliderButton.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    SliderButton.Size = UDim2.new(0, 14, 0, 14)
    SliderButton.Text = ""
    
    -- Current value
    local currentValue = default
    
    -- Dragging state
    local dragging = false
    
    -- Update slider value
    local function UpdateSlider(input)
        local mouse = input.Position
        local barPos = SliderBack.AbsolutePosition.X
        local barSize = SliderBack.AbsoluteSize.X
        local relativePos = math.clamp(mouse.X - barPos, 0, barSize)
        local percentage = relativePos / barSize
        local value = math.floor(min + (max - min) * percentage)
        
        currentValue = value
        ValueLabel.Text = tostring(value)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        SliderButton.Position = UDim2.new(percentage, -7, 0.5, -7)
        callback(value)
    end
    
    -- Mouse down on slider button
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    -- Mouse down on slider background (click to set)
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    -- Mouse up anywhere
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Mouse move while dragging
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input)
        end
    end)
    
    -- Hover effects
    SliderButton.MouseEnter:Connect(function()
        Tween(SliderButton, {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
    end)
    
    SliderButton.MouseLeave:Connect(function()
        Tween(SliderButton, {BackgroundColor3 = Color3.fromRGB(200, 200, 200)})
    end)
    
    -- Slider object with methods
    local SliderObj = {
        Frame = Slider,
        Value = currentValue,
        
        -- Method to set slider value programmatically
        SetValue = function(self, value)
            value = math.clamp(value, min, max)
            currentValue = value
            self.Value = value
            local percentage = (value - min) / (max - min)
            ValueLabel.Text = tostring(value)
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            SliderButton.Position = UDim2.new(percentage, -7, 0.5, -7)
            callback(value)
        end,
        
        -- Method to get current value
        GetValue = function(self)
            return currentValue
        end
    }
    
    return SliderObj
end

-- ========================================
-- COLOR PICKER
-- ========================================

--[[
    Creates a color picker element
    
    Parameters:
    - Tab: table - The tab object
    - text: string - The color picker label
    - default: Color3 - Default color
    - callback: function - Function called when color changes, receives Color3 value
    
    Returns:
    - ColorPicker object with methods
    
    Example:
    local picker = Library:CreateColorPicker(tab, "Box Color", Color3.fromRGB(255, 0, 0), function(color)
        print("Color:", color)
    end)
]]
function Library:CreateColorPicker(Tab, text, default, callback)
    text = text or "Color Picker"
    default = default or Color3.fromRGB(255, 255, 255)
    callback = callback or function() end
    
    -- Color Picker Frame
    local Picker = Instance.new("Frame")
    Picker.Name = text
    Picker.Parent = Tab.Content
    Picker.BackgroundTransparency = 1
    Picker.Size = UDim2.new(1, 0, 0, 22)
    
    -- Label
    local Label = Instance.new("TextLabel")
    Label.Parent = Picker
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.Font = Enum.Font.Code
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Color Display Button
    local ColorDisplay = Instance.new("TextButton")
    ColorDisplay.Parent = Picker
    ColorDisplay.BackgroundColor3 = default
    ColorDisplay.BorderColor3 = Color3.fromRGB(50, 50, 50)
    ColorDisplay.BorderSizePixel = 1
    ColorDisplay.Position = UDim2.new(1, -28, 0, 3)
    ColorDisplay.Size = UDim2.new(0, 28, 0, 16)
    ColorDisplay.Text = ""
    
    -- Current color
    local currentColor = default
    
    -- Color Picker Window (Hidden by default)
    local PickerWindow = Instance.new("Frame")
    PickerWindow.Name = "PickerWindow"
    PickerWindow.Parent = Picker
    PickerWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    PickerWindow.BorderColor3 = Color3.fromRGB(50, 50, 50)
    PickerWindow.BorderSizePixel = 1
    PickerWindow.Position = UDim2.new(1, -220, 1, 5)
    PickerWindow.Size = UDim2.new(0, 220, 0, 200)
    PickerWindow.Visible = false
    PickerWindow.ZIndex = 10
    
    -- Color Canvas (Saturation/Value picker)
    local ColorCanvas = Instance.new("ImageButton")
    ColorCanvas.Parent = PickerWindow
    ColorCanvas.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ColorCanvas.BorderSizePixel = 0
    ColorCanvas.Position = UDim2.new(0, 10, 0, 10)
    ColorCanvas.Size = UDim2.new(1, -50, 1, -60)
    ColorCanvas.Image = "rbxassetid://4155801252" -- Gradient overlay
    
    -- Hue Slider
    local HueSlider = Instance.new("ImageButton")
    HueSlider.Parent = PickerWindow
    HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueSlider.BorderSizePixel = 0
    HueSlider.Position = UDim2.new(1, -30, 0, 10)
    HueSlider.Size = UDim2.new(0, 20, 1, -60)
    HueSlider.Image = "rbxassetid://3641079629" -- Hue gradient
    
    -- RGB Input Fields
    local RGBFrame = Instance.new("Frame")
    RGBFrame.Parent = PickerWindow
    RGBFrame.BackgroundTransparency = 1
    RGBFrame.Position = UDim2.new(0, 10, 1, -40)
    RGBFrame.Size = UDim2.new(1, -20, 0, 30)
    
    -- R Input
    local RLabel = Instance.new("TextLabel")
    RLabel.Parent = RGBFrame
    RLabel.BackgroundTransparency = 1
    RLabel.Size = UDim2.new(0, 15, 0, 20)
    RLabel.Font = Enum.Font.Code
    RLabel.Text = "R:"
    RLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    RLabel.TextSize = 12
    RLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local RInput = Instance.new("TextBox")
    RInput.Parent = RGBFrame
    RInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    RInput.BorderColor3 = Color3.fromRGB(50, 50, 50)
    RInput.BorderSizePixel = 1
    RInput.Position = UDim2.new(0, 20, 0, 0)
    RInput.Size = UDim2.new(0, 40, 0, 20)
    RInput.Font = Enum.Font.Code
    RInput.Text = tostring(math.floor(default.R * 255))
    RInput.TextColor3 = Color3.fromRGB(200, 200, 200)
    RInput.TextSize = 12
    RInput.PlaceholderText = "0"
    
    -- G Input
    local GLabel = Instance.new("TextLabel")
    GLabel.Parent = RGBFrame
    GLabel.BackgroundTransparency = 1
    GLabel.Position = UDim2.new(0, 65, 0, 0)
    GLabel.Size = UDim2.new(0, 15, 0, 20)
    GLabel.Font = Enum.Font.Code
    GLabel.Text = "G:"
    GLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    GLabel.TextSize = 12
    GLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local GInput = Instance.new("TextBox")
    GInput.Parent = RGBFrame
    GInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    GInput.BorderColor3 = Color3.fromRGB(50, 50, 50)
    GInput.BorderSizePixel = 1
    GInput.Position = UDim2.new(0, 85, 0, 0)
    GInput.Size = UDim2.new(0, 40, 0, 20)
    GInput.Font = Enum.Font.Code
    GInput.Text = tostring(math.floor(default.G * 255))
    GInput.TextColor3 = Color3.fromRGB(200, 200, 200)
    GInput.TextSize = 12
    GInput.PlaceholderText = "0"
    
    -- B Input
    local BLabel = Instance.new("TextLabel")
    BLabel.Parent = RGBFrame
    BLabel.BackgroundTransparency = 1
    BLabel.Position = UDim2.new(0, 130, 0, 0)
    BLabel.Size = UDim2.new(0, 15, 0, 20)
    BLabel.Font = Enum.Font.Code
    BLabel.Text = "B:"
    BLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    BLabel.TextSize = 12
    BLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local BInput = Instance.new("TextBox")
    BInput.Parent = RGBFrame
    BInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    BInput.BorderColor3 = Color3.fromRGB(50, 50, 50)
    BInput.BorderSizePixel = 1
    BInput.Position = UDim2.new(0, 150, 0, 0)
    BInput.Size = UDim2.new(0, 40, 0, 20)
    BInput.Font = Enum.Font.Code
    BInput.Text = tostring(math.floor(default.B * 255))
    BInput.TextColor3 = Color3.fromRGB(200, 200, 200)
    BInput.TextSize = 12
    BInput.PlaceholderText = "0"
    
    -- Update color from RGB inputs
    local function UpdateFromRGB()
        local r = math.clamp(tonumber(RInput.Text) or 0, 0, 255)
        local g = math.clamp(tonumber(GInput.Text) or 0, 0, 255)
        local b = math.clamp(tonumber(BInput.Text) or 0, 0, 255)
        
        currentColor = Color3.fromRGB(r, g, b)
        ColorDisplay.BackgroundColor3 = currentColor
        callback(currentColor)
    end
    
    -- RGB input handlers
    RInput.FocusLost:Connect(UpdateFromRGB)
    GInput.FocusLost:Connect(UpdateFromRGB)
    BInput.FocusLost:Connect(UpdateFromRGB)
    
    -- Toggle picker window
    ColorDisplay.MouseButton1Click:Connect(function()
        PickerWindow.Visible = not PickerWindow.Visible
    end)
    
    -- Hover effect
    ColorDisplay.MouseEnter:Connect(function()
        ColorDisplay.BorderColor3 = Color3.fromRGB(100, 100, 255)
    end)
    
    ColorDisplay.MouseLeave:Connect(function()
        ColorDisplay.BorderColor3 = Color3.fromRGB(50, 50, 50)
    end)
    
    -- ColorPicker object with methods
    local PickerObj = {
        Frame = Picker,
        Value = currentColor,
        
        -- Method to set color programmatically
        SetValue = function(self, color)
            currentColor = color
            self.Value = color
            ColorDisplay.BackgroundColor3 = color
            RInput.Text = tostring(math.floor(color.R * 255))
            GInput.Text = tostring(math.floor(color.G * 255))
            BInput.Text = tostring(math.floor(color.B * 255))
            callback(color)
        end,
        
        -- Method to get current color
        GetValue = function(self)
            return currentColor
        end
    }
    
    return PickerObj
end

-- ========================================
-- KEYBIND SETTER
-- ========================================

--[[
    Creates a keybind setter element
    
    Parameters:
    - Tab: table - The tab object
    - text: string - The keybind label
    - default: Enum.KeyCode - Default keybind
    - callback: function - Function called when key is pressed, receives KeyCode
    
    Returns:
    - Keybind object with methods
    
    Example:
    local keybind = Library:CreateKeybind(tab, "Toggle ESP", Enum.KeyCode.E, function(key)
        print("Key pressed:", key.Name)
    end)
]]
function Library:CreateKeybind(Tab, text, default, callback)
    text = text or "Keybind"
    default = default or Enum.KeyCode.E
    callback = callback or function() end
    
    -- Keybind Frame
    local Keybind = Instance.new("Frame")
    Keybind.Name = text
    Keybind.Parent = Tab.Content
    Keybind.BackgroundTransparency = 1
    Keybind.Size = UDim2.new(1, 0, 0, 22)
    
    -- Label
    local Label = Instance.new("TextLabel")
    Label.Parent = Keybind
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Size = UDim2.new(1, -80, 1, 0)
    Label.Font = Enum.Font.Code
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Keybind Button
    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Parent = Keybind
    KeybindButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    KeybindButton.BorderColor3 = Color3.fromRGB(50, 50, 50)
    KeybindButton.BorderSizePixel = 1
    KeybindButton.Position = UDim2.new(1, -75, 0, 3)
    KeybindButton.Size = UDim2.new(0, 75, 0, 16)
    KeybindButton.Font = Enum.Font.Code
    KeybindButton.Text = default.Name
    KeybindButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    KeybindButton.TextSize = 12
    
    -- Current keybind
    local currentKey = default
    local listening = false
    
    -- Click to set new keybind
    KeybindButton.MouseButton1Click:Connect(function()
        if listening then return end
        
        listening = true
        KeybindButton.Text = "..."
        KeybindButton.BorderColor3 = Color3.fromRGB(100, 100, 255)
        
        -- Wait for key press
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                -- Update keybind
                currentKey = input.KeyCode
                KeybindButton.Text = input.KeyCode.Name
                KeybindButton.BorderColor3 = Color3.fromRGB(50, 50, 50)
                listening = false
                connection:Disconnect()
            end
        end)
    end)
    
    -- Listen for keybind press
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == currentKey and not listening then
            callback(currentKey)
        end
    end)
    
    -- Hover effects
    KeybindButton.MouseEnter:Connect(function()
        if not listening then
            Tween(KeybindButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
        end
    end)
    
    KeybindButton.MouseLeave:Connect(function()
        if not listening then
            Tween(KeybindButton, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
        end
    end)
    
    -- Keybind object with methods
    local KeybindObj = {
        Frame = Keybind,
        Button = KeybindButton,
        Value = currentKey,
        
        -- Method to set keybind programmatically
        SetValue = function(self, keycode)
            currentKey = keycode
            self.Value = keycode
            KeybindButton.Text = keycode.Name
        end,
        
        -- Method to get current keybind
        GetValue = function(self)
            return currentKey
        end
    }
    
    return KeybindObj
end

-- ========================================
-- DROPDOWN
-- ========================================

--[[
    Creates a dropdown element
    
    Parameters:
    - Tab: table - The tab object
    - text: string - The dropdown label
    - options: table - Array of option strings
    - default: string - Default selected option
    - callback: function - Function called when option changes, receives string value
    
    Returns:
    - Dropdown object with methods
    
    Example:
    local dropdown = Library:CreateDropdown(tab, "Select Mode", {"Option 1", "Option 2", "Option 3"}, "Option 1", function(value)
        print("Selected:", value)
    end)
]]
function Library:CreateDropdown(Tab, text, options, default, callback)
    text = text or "Dropdown"
    options = options or {"Option 1", "Option 2"}
    default = default or options[1]
    callback = callback or function() end
    
    -- Dropdown Frame
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = text
    Dropdown.Parent = Tab.Content
    Dropdown.BackgroundTransparency = 1
    Dropdown.Size = UDim2.new(1, 0, 0, 22)
    Dropdown.ClipsDescendants = false
    
    -- Label
    local Label = Instance.new("TextLabel")
    Label.Parent = Dropdown
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Size = UDim2.new(1, 0, 0, 22)
    Label.Font = Enum.Font.Code
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Dropdown Button
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Parent = Dropdown
    DropdownButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    DropdownButton.BorderColor3 = Color3.fromRGB(50, 50, 50)
    DropdownButton.BorderSizePixel = 1
    DropdownButton.Position = UDim2.new(0, 0, 0, 26)
    DropdownButton.Size = UDim2.new(1, 0, 0, 22)
    DropdownButton.Font = Enum.Font.Code
    DropdownButton.Text = default
    DropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    DropdownButton.TextSize = 12
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    
    local ButtonPadding = Instance.new("UIPadding")
    ButtonPadding.Parent = DropdownButton
    ButtonPadding.PaddingLeft = UDim.new(0, 8)
    ButtonPadding.PaddingRight = UDim.new(0, 8)
    
    -- Arrow Indicator
    local Arrow = Instance.new("TextLabel")
    Arrow.Parent = DropdownButton
    Arrow.BackgroundTransparency = 1
    Arrow.Position = UDim2.new(1, -20, 0, 0)
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Font = Enum.Font.Code
    Arrow.Text = "▼"
    Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
    Arrow.TextSize = 10
    
    -- Options Container
    local OptionsContainer = Instance.new("Frame")
    OptionsContainer.Parent = Dropdown
    OptionsContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    OptionsContainer.BorderColor3 = Color3.fromRGB(50, 50, 50)
    OptionsContainer.BorderSizePixel = 1
    OptionsContainer.Position = UDim2.new(0, 0, 0, 49)
    OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
    OptionsContainer.Visible = false
    OptionsContainer.ClipsDescendants = true
    OptionsContainer.ZIndex = 5
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.Parent = OptionsContainer
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Current selection
    local currentOption = default
    local isOpen = false
    
    -- Create option buttons
    for _, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = OptionsContainer
        OptionButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        OptionButton.BorderSizePixel = 0
        OptionButton.Size = UDim2.new(1, 0, 0, 22)
        OptionButton.Font = Enum.Font.Code
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptionButton.TextSize = 12
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.ZIndex = 6
        
        local OptionPadding = Instance.new("UIPadding")
        OptionPadding.Parent = OptionButton
        OptionPadding.PaddingLeft = UDim.new(0, 8)
        
        -- Option click handler
        OptionButton.MouseButton1Click:Connect(function()
            currentOption = option
            DropdownButton.Text = option
            OptionsContainer.Visible = false
            isOpen = false
            Arrow.Text = "▼"
            Dropdown.Size = UDim2.new(1, 0, 0, 48)
            callback(option)
        end)
        
        -- Hover effect
        OptionButton.MouseEnter:Connect(function()
            OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end)
        
        OptionButton.MouseLeave:Connect(function()
            OptionButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end)
    end
    
    -- Toggle dropdown
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        OptionsContainer.Visible = isOpen
        Arrow.Text = isOpen and "▲" or "▼"
        
        if isOpen then
            local optionCount = #options
            OptionsContainer.Size = UDim2.new(1, 0, 0, optionCount * 22)
            Dropdown.Size = UDim2.new(1, 0, 0, 48 + optionCount * 22)
        else
            Dropdown.Size = UDim2.new(1, 0, 0, 48)
        end
    end)
    
    -- Hover effect
    DropdownButton.MouseEnter:Connect(function()
        Tween(DropdownButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
    end)
    
    DropdownButton.MouseLeave:Connect(function()
        Tween(DropdownButton, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
    end)
    
    -- Set initial size
    Dropdown.Size = UDim2.new(1, 0, 0, 48)
    
    -- Dropdown object with methods
    local DropdownObj = {
        Frame = Dropdown,
        Button = DropdownButton,
        Value = currentOption,
        
        -- Method to set selected option programmatically
        SetValue = function(self, value)
            currentOption = value
            self.Value = value
            DropdownButton.Text = value
            callback(value)
        end,
        
        -- Method to get current selection
        GetValue = function(self)
            return currentOption
        end
    }
    
    return DropdownObj
end

-- ========================================
-- BUTTON
-- ========================================

--[[
    Creates a button element
    
    Parameters:
    - Tab: table - The tab object
    - text: string - The button text
    - callback: function - Function called when button is clicked
    
    Returns:
    - Button object
    
    Example:
    local button = Library:CreateButton(tab, "Click Me", function()
        print("Button clicked!")
    end)
]]
function Library:CreateButton(Tab, text, callback)
    text = text or "Button"
    callback = callback or function() end
    
    -- Button Frame
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = text
    ButtonFrame.Parent = Tab.Content
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.Size = UDim2.new(1, 0, 0, 28)
    
    -- Button
    local Button = Instance.new("TextButton")
    Button.Parent = ButtonFrame
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Button.BorderColor3 = Color3.fromRGB(50, 50, 50)
    Button.BorderSizePixel = 1
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Font = Enum.Font.Code
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 13
    
    -- Click handler
    Button.MouseButton1Click:Connect(function()
        callback()
        
        -- Click animation
        Button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        task.wait(0.1)
        Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end)
    
    -- Hover effects
    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
    end)
    
    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
    end)
    
    -- Button object
    local ButtonObj = {
        Frame = ButtonFrame,
        Button = Button
    }
    
    return ButtonObj
end

-- ========================================
-- TEXT INPUT
-- ========================================

--[[
    Creates a text input element
    
    Parameters:
    - Tab: table - The tab object
    - text: string - The input label
    - placeholder: string - Placeholder text
    - default: string - Default value
    - callback: function - Function called when text changes, receives string value
    
    Returns:
    - TextInput object with methods
    
    Example:
    local input = Library:CreateTextInput(tab, "Player Name", "Enter name...", "", function(value)
        print("Input:", value)
    end)
]]
function Library:CreateTextInput(Tab, text, placeholder, default, callback)
    text = text or "Text Input"
    placeholder = placeholder or "Enter text..."
    default = default or ""
    callback = callback or function() end
    
    -- Input Frame
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = text
    InputFrame.Parent = Tab.Content
    InputFrame.BackgroundTransparency = 1
    InputFrame.Size = UDim2.new(1, 0, 0, 48)
    
    -- Label
    local Label = Instance.new("TextLabel")
    Label.Parent = InputFrame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 18)
    Label.Font = Enum.Font.Code
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Text Input Box
    local TextBox = Instance.new("TextBox")
    TextBox.Parent = InputFrame
    TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TextBox.BorderColor3 = Color3.fromRGB(50, 50, 50)
    TextBox.BorderSizePixel = 1
    TextBox.Position = UDim2.new(0, 0, 0, 24)
    TextBox.Size = UDim2.new(1, 0, 0, 24)
    TextBox.Font = Enum.Font.Code
    TextBox.Text = default
    TextBox.PlaceholderText = placeholder
    TextBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    TextBox.TextSize = 12
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.ClearTextOnFocus = false
    
    local TextPadding = Instance.new("UIPadding")
    TextPadding.Parent = TextBox
    TextPadding.PaddingLeft = UDim.new(0, 8)
    TextPadding.PaddingRight = UDim.new(0, 8)
    
    -- Current value
    local currentValue = default
    
    -- Text changed handler
    TextBox.FocusLost:Connect(function()
        currentValue = TextBox.Text
        callback(currentValue)
    end)
    
    -- Focus effects
    TextBox.Focused:Connect(function()
        TextBox.BorderColor3 = Color3.fromRGB(100, 100, 255)
    end)
    
    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        if TextBox:IsFocused() then
            return
        end
    end)
    
    TextBox.FocusLost:Connect(function()
        TextBox.BorderColor3 = Color3.fromRGB(50, 50, 50)
    end)
    
    -- TextInput object with methods
    local InputObj = {
        Frame = InputFrame,
        TextBox = TextBox,
        Value = currentValue,
        
        -- Method to set text programmatically
        SetValue = function(self, value)
            currentValue = value
            self.Value = value
            TextBox.Text = value
            callback(value)
        end,
        
        -- Method to get current text
        GetValue = function(self)
            return TextBox.Text
        end
    }
    
    return InputObj
end

-- ========================================
-- LABEL (INFO TEXT)
-- ========================================

--[[
    Creates a label element for displaying information
    
    Parameters:
    - Tab: table - The tab object
    - text: string - The label text
    
    Returns:
    - Label object with methods
    
    Example:
    local label = Library:CreateLabel(tab, "This is some information")
    label:SetText("Updated text")
]]
function Library:CreateLabel(Tab, text)
    text = text or "Label"
    
    -- Label Frame
    local LabelFrame = Instance.new("Frame")
    LabelFrame.Name = "Label"
    LabelFrame.Parent = Tab.Content
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.Size = UDim2.new(1, 0, 0, 20)
    
    -- Label Text
    local Label = Instance.new("TextLabel")
    Label.Parent = LabelFrame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Font = Enum.Font.Code
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(150, 150, 150)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    
    -- Label object with methods
    local LabelObj = {
        Frame = LabelFrame,
        Label = Label,
        
        -- Method to update label text
        SetText = function(self, newText)
            Label.Text = newText
        end,
        
        -- Method to get current text
        GetText = function(self)
            return Label.Text
        end
    }
    
    return LabelObj
end

-- ========================================
-- EXAMPLE USAGE
-- ========================================

--[[
    Here's how to use the library:
    
    -- Create a window
    local Window = Library:CreateWindow("My Script")
    
    -- Create tabs
    local Tab1 = Library:CreateTab(Window, "Main")
    local Tab2 = Library:CreateTab(Window, "Settings")
    
    -- Add elements to Tab1
    Library:CreateSection(Tab1, "Features")
    
    local toggle = Library:CreateToggle(Tab1, "Enable ESP", false, function(value)
        print("ESP:", value)
    end)
    
    local slider = Library:CreateSlider(Tab1, "Speed", 0, 100, 50, function(value)
        print("Speed:", value)
    end)
    
    local colorPicker = Library:CreateColorPicker(Tab1, "Color", Color3.fromRGB(255, 0, 0), function(color)
        print("Color:", color)
    end)
    
    local keybind = Library:CreateKeybind(Tab1, "Toggle Key", Enum.KeyCode.E, function(key)
        print("Key pressed:", key.Name)
    end)
    
    local dropdown = Library:CreateDropdown(Tab1, "Mode", {"Mode 1", "Mode 2", "Mode 3"}, "Mode 1", function(value)
        print("Selected:", value)
    end)
    
    local button = Library:CreateButton(Tab1, "Click Me", function()
        print("Button clicked!")
    end)
    
    local input = Library:CreateTextInput(Tab1, "Name", "Enter name...", "", function(value)
        print("Name:", value)
    end)
    
    local label = Library:CreateLabel(Tab1, "This is a label")
    
    -- Add elements to Tab2
    Library:CreateSection(Tab2, "Configuration")
    Library:CreateLabel(Tab2, "Configure your settings here")
    
    -- You can also use methods on elements:
    toggle:SetValue(true)
    slider:SetValue(75)
    colorPicker:SetValue(Color3.fromRGB(0, 255, 0))
    keybind:SetValue(Enum.KeyCode.Q)
    dropdown:SetValue("Mode 2")
    input:SetValue("Player123")
    label:SetText("Updated label text")
]]

-- Return the library so it can be used
return Library
