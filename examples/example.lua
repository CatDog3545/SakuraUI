local Sakura = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/CatDog3545/SakuraUI/refs/heads/main/Sakura.lua"
))()

local Window = Sakura:CreateWindow({
Title = "Sakura UI",
Theme = "Sakura"
})

local Tab = Window:CreateTab({
Title = "Main"
})

Tab:AddButton({
Title = "Hello",
Callback = function()
print("Hello world")
end
})

Tab:AddToggle({
Title = "Auto Farm",
Default = false,
Callback = function(v)
print(v)
end
})