if not game:IsLoaded() then 
    game.Loaded:Wait()
end

local Script : {[any] : any} = {
    Interface = loadstring(game:HttpGet("https://raw.githubusercontent.com/Streekaiz/Skeptical/refs/heads/main/dependencies/library.luau"))(),
    Window = nil,
    CurrentTween = nil 
};
Script.__index = Script 

Script.GetService = function(self, Name : string) : Instance
    return cloneref and cloneref(game:GetService(Name)) or game:GetService(Name)
end

local Workspace = workspace
local Players = Script:GetService("Players")
local TweenService = Script:GetService("TweenService")
local ReplicatedStorage = Script:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer 
local Character = LocalPlayer.Character 
local Humanoid = Character.Humanoid

local NetworkRemote = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent
local SellArea = Workspace.Worlds["The Overworld"]:FindFirstChild("Sell")

Script.Tween = function(self, Part : BasePart, Properties : {[any] : any}, Info : TweenInfo) : Tween
    Info = Info or TweenInfo.new(
        1, 
        Enum.EasingStyle.Linear, 
        Enum.EasingDirection.In
    )
    local Tween = TweenService:Create(Part, Info, Properties); Tween:Play()
    return Tween 
end

Script.Window = Script.Interface:window({
    name = "Skeptical",
    suffix = "Hub",
    gameInfo = "Bubble Gum Simulator infinity"
}); do 
    local Collumn : {[any] : any}
    local Section : {[any] : any}

    local Autofarm, Autosell, Autobuy = Script.Window:tab({
        name = "Main",
        tabs = {"Auto Farm", "Auto Sell", "Auto Buy"}
    });

    Collumn = Autofarm:column({})
    Section = Collumn:section({name = "Auto Farm", default = true}); do -- // autoblow buble
        Section:toggle({name = "Enabled", flag = "AutoFarmEnabled"})
        Section:slider({name = "speed or smth idk?", min = 0, max = 10, interval = 1})
    end 

    Collumn = Autofarm:column({})
    Section = Collumn:section({name = "Auto Sell", default = true, callback = function(State : boolean)
        Character.HumanoidRootPart.Anchored = State
        if not State and Script.CurrentTween ~= nil then 
            Script.CurrentTween:Pause()
            Script.CurrentTween = nil 
        end
    end}); do -- // autoblow buble
        Section:toggle({name = "Enabled", flag = "AutoSellEnabled"})
    end 
end

task.spawn(function()
    while task.wait() do
        if Script.Interface.flags.AutoFarmEnabled then 
            NetworkRemote:FireServer("BlowBubble")
        end
        if Script.Interface.flags.AutoSellEnabled then 
            Script.CurrentTween = Script:Tween(Character.HumanoidRootPart, {CFrame = SellArea.Root.CFrame}) 
        end
    end
end)

