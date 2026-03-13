-- Sakura UI Library
-- Version 1.0
-- by SakuraUI

local Sakura = {}
Sakura.__index = Sakura

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

------------------------------------------------
-- THEMES
------------------------------------------------

local Themes = {

Dark = {
Background = Color3.fromRGB(24,24,24),
Secondary = Color3.fromRGB(35,35,35),
Accent = Color3.fromRGB(255,120,180),
Text = Color3.fromRGB(255,255,255)
},

Light = {
Background = Color3.fromRGB(240,240,240),
Secondary = Color3.fromRGB(220,220,220),
Accent = Color3.fromRGB(255,120,180),
Text = Color3.fromRGB(0,0,0)
},

Sakura = {
Background = Color3.fromRGB(28,24,28),
Secondary = Color3.fromRGB(45,35,45),
Accent = Color3.fromRGB(255,150,200),
Text = Color3.fromRGB(255,255,255)
}

}

------------------------------------------------
-- UTILS
------------------------------------------------

local function Create(class,props)

local obj = Instance.new(class)

for i,v in pairs(props) do
obj[i] = v
end

return obj

end

local function Tween(obj,time,props)

local t = TweenService:Create(
obj,
TweenInfo.new(time,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
props
)

t:Play()

end

------------------------------------------------
-- WINDOW
------------------------------------------------

function Sakura:CreateWindow(config)

local self = setmetatable({},Sakura)

self.Theme = Themes[config.Theme or "Sakura"]

------------------------------------------------

local ScreenGui = Create("ScreenGui",{
Name = "SakuraUI",
Parent = game.CoreGui
})

------------------------------------------------

local Main = Create("Frame",{
Parent = ScreenGui,
Size = config.Size or UDim2.new(0,520,0,420),
Position = UDim2.new(0.5,-260,0.5,-210),
BackgroundColor3 = self.Theme.Background
})

Create("UICorner",{Parent=Main,CornerRadius=UDim.new(0,12)})

------------------------------------------------
-- TITLE BAR
------------------------------------------------

local Top = Create("Frame",{
Parent = Main,
Size = UDim2.new(1,0,0,40),
BackgroundTransparency = 1
})

local Title = Create("TextLabel",{
Parent = Top,
Text = config.Title or "Sakura UI",
Font = Enum.Font.GothamBold,
TextSize = 18,
TextColor3 = self.Theme.Text,
BackgroundTransparency = 1,
Position = UDim2.new(0,10,0,0),
Size = UDim2.new(1,0,1,0),
TextXAlignment = Enum.TextXAlignment.Left
})

------------------------------------------------
-- TABS BAR
------------------------------------------------

local Tabs = Create("Frame",{
Parent = Main,
Size = UDim2.new(0,140,1,-40),
Position = UDim2.new(0,0,0,40),
BackgroundColor3 = self.Theme.Secondary
})

Create("UICorner",{Parent=Tabs})

local TabLayout = Create("UIListLayout",{
Parent = Tabs,
Padding = UDim.new(0,4)
})

------------------------------------------------
-- PAGES
------------------------------------------------

local Pages = Create("Frame",{
Parent = Main,
Size = UDim2.new(1,-140,1,-40),
Position = UDim2.new(0,140,0,40),
BackgroundTransparency = 1
})

self.Pages = Pages
self.Tabs = Tabs

------------------------------------------------
-- DRAG WINDOW
------------------------------------------------

do

local dragging = false
local dragInput
local dragStart
local startPos

Top.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

dragging = true
dragStart = input.Position
startPos = Main.Position

end

end)

UIS.InputChanged:Connect(function(input)

if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

local delta = input.Position - dragStart

Main.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)

end

end)

UIS.InputEnded:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = false
end

end)

end

------------------------------------------------
-- CREATE TAB
------------------------------------------------

function self:CreateTab(tab)

local Button = Create("TextButton",{
Parent = Tabs,
Size = UDim2.new(1,0,0,36),
Text = tab.Title,
BackgroundColor3 = self.Theme.Secondary,
TextColor3 = self.Theme.Text,
Font = Enum.Font.Gotham,
TextSize = 14
})

Create("UICorner",{Parent=Button})

local Page = Create("ScrollingFrame",{
Parent = Pages,
Size = UDim2.new(1,0,1,0),
CanvasSize = UDim2.new(0,0,0,0),
BackgroundTransparency = 1,
Visible = false
})

local Layout = Create("UIListLayout",{
Parent = Page,
Padding = UDim.new(0,6)
})

Button.MouseButton1Click:Connect(function()

for _,v in pairs(Pages:GetChildren()) do
if v:IsA("ScrollingFrame") then
v.Visible = false
end
end

Page.Visible = true

Tween(Button,.2,{
BackgroundColor3 = self.Theme.Accent
})

end)

------------------------------------------------
-- TAB OBJECT
------------------------------------------------

local Tab = {}

------------------------------------------------
-- BUTTON
------------------------------------------------

function Tab:AddButton(cfg)

local Btn = Create("TextButton",{
Parent = Page,
Size = UDim2.new(1,-10,0,36),
Position = UDim2.new(0,5,0,0),
Text = cfg.Title,
BackgroundColor3 = self.Theme.Secondary,
TextColor3 = self.Theme.Text,
Font = Enum.Font.Gotham
})

Create("UICorner",{Parent=Btn})

Btn.MouseEnter:Connect(function()
Tween(Btn,.15,{BackgroundColor3=self.Theme.Accent})
end)

Btn.MouseLeave:Connect(function()
Tween(Btn,.15,{BackgroundColor3=self.Theme.Secondary})
end)

Btn.MouseButton1Click:Connect(function()

Tween(Btn,.08,{Size=UDim2.new(1,-10,0,32)})
task.wait(.08)
Tween(Btn,.08,{Size=UDim2.new(1,-10,0,36)})

if cfg.Callback then
cfg.Callback()
end

end)

end

------------------------------------------------
-- TOGGLE
------------------------------------------------

function Tab:AddToggle(cfg)

local State = cfg.Default or false

local Frame = Create("Frame",{
Parent = Page,
Size = UDim2.new(1,-10,0,36),
Position = UDim2.new(0,5,0,0),
BackgroundColor3 = self.Theme.Secondary
})

Create("UICorner",{Parent=Frame})

local Text = Create("TextLabel",{
Parent = Frame,
Text = cfg.Title,
BackgroundTransparency = 1,
TextColor3 = self.Theme.Text,
Size = UDim2.new(.7,0,1,0)
})

local Toggle = Create("Frame",{
Parent = Frame,
Size = UDim2.new(0,40,0,18),
Position = UDim2.new(1,-50,0.5,-9),
BackgroundColor3 = Color3.fromRGB(60,60,60)
})

Create("UICorner",{Parent=Toggle})

Toggle.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

State = not State

if State then
Tween(Toggle,.2,{BackgroundColor3=self.Theme.Accent})
else
Tween(Toggle,.2,{BackgroundColor3=Color3.fromRGB(60,60,60)})
end

if cfg.Callback then
cfg.Callback(State)
end

end

end)

end

------------------------------------------------

return Tab

end

------------------------------------------------

return self

end

return Sakura