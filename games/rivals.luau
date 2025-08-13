local Environment : {[any] : any} = getgenv() or _G
local Script : {[any] : any} = Environment.Skeptical or Environment.Script 

local Interface : {[any] : any} = Script:LoadInterface("bitchbot-v1")
local Services : {[any] : any} = Script.Dependencies.Services
local Clients : {[any] : any} = Script.Dependencies.Clients
local Miscallaenous : {[any] : any} = Script.Dependencies.Miscallaenous

local Players = Services:Get("Players")
local ReplicatedStorage = Services:Get("ReplicatedStorage")

local Camera = workspace.CurrentCamera 
local LocalPlayer = Players.LocalPlayer 

local Modules : {[any] : any} = {}; do 
    local LoadTick = tick()
    for Index, Module in next, ReplicatedStorage.Modules do 
        Modules[Module.Name] = require(Module)
        local NewTick = tick()
        Interface:Notification("Loaded " .. Module.Name .. " in " .. NewTick - LoadTick)
        LoadTick = NewTick 
    end 
end 

-- // adding game support
Clients.IsFriendly = function(self, Player : Player)
    return Player:GetAttribute("Team") == LocalPlayer:GetAttribute("Team")
end

Clients.IsEnemy = function(self, Player : Player)
    return Player:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team")
end

local Window = Interface:Window({
    Name = "bitchbot"
}); do 
    local Page : {[any] : any}
    local Section : {[any] : any}
    local Pages = {
        Legit = Window:Page({Icon = "Legit", Columns = 3}),
        Rage = Window:Page({Icon = "Rage", Columns = 3}),
        Esp = Window:Page({Icon = "ESP", Columns = 3}),
        Visual = Window:Page({Icon = "Visual", Columns = 3}),
        Settings = Window:Page({Icon = "Settings", Columns = 3})
    }; do 
        Page = Pages.Legit 
        Section = Page:Section({Name = "Aim Assist", Side = 1})

        Section = Page:Section({Name = "Silent Aim", Side = 2})
        Section:Toggle({Name = "enabled", Flag = "silentAimEnabled"}):Keybind({Name = "Silent Aim", Flag = "silentAimKeybind"})
        Section:Dropdown({Name = "body priority", Flag = "silentAimTargets", Items = {"Head", "Torso", "Arms" ,"Legs"}, Multi = true, Default = {"Head", "Torso"}})
        Section:Slider({Name = "hit chance", Flag = "silentAimChance", Min = 0, Max = 100, Default = 100, Suffix = "%"})
        Section:Dropdown({Name = "validation checks", Flag = "silentAimChecks", Items = {"team", "behind wall", "invisibility"}, Multi = true, Default = {"Team", "Behind Wall"}})
        Section:Toggle({Name = "predict trajectory", Flag = "silentAimPredictionEnabled"})
        Section:Dropdown({Name = "prediction method", Flag = "silentAimPredictionMethod", Items = {"standard", "bow", "other guns idk"}})
        Section:Toggle({Name = "limit to fov", Flag = "silentAimLimit"})
        Section:Toggle({Name = "show fov", Flag = "silentAimVisual"}):Colorpicker({Name = "color", Flag = "silentAimColor"})
        Section:Slider({Name = "fov radius", Flag = "silentAimRadius", Min = 0, Max = 360, Default = 180, Suffix = "px"})
    end 
end 

local OldUtilityRaycast; OldUtilityRaycast = hookfunction(Modules["Utility"].Raycast, function(...)
    local Arguments = {...}

    if Interface.Flags.silentAimEnabled then 
        local Target, Magnitude, Data = Clients:GetClosestPlayer("Mouse", function(Player, Character, Humanoid, HumanoidRootPart, Health)
            if (table.find(Interface.Flags.silentAimChecks, "team") and Clients:IsFriendly(Player)) then 
                return false 
            end 

            if (table.find(Interface.Flags.silentAimChecks, "invisible") and Character.Head.Transparency == 1) then 
                return false 
            end 

            if table.find(Interface.Flags.silentAimChecks, "behind wall") then 
                return Miscallaenous:Raycast(HumanoidRootPart, Camera.Position)
            end 

            return true 
        end)

        if Target then 
            local BodyPart = Clients:GetClosestPart("Mouse", Data.Character, Clients:GetBodyParts(Character, HumanoidRootPart, false, Library.Flags.silentAimTargets))

            Arguments[3] = BodyPart.Position 
        end 
    end 
    
    return OldUtilityRaycast(table.unpack(Arguements))
end) 

