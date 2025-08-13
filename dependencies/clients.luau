--[[
    @author Streekaiz
    @description Client module for BingeBot
]]


local Library : {[any] : any} = {}

local Workspace : workspace = workspace
local Players : Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local UserInputService : UserInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")

local Camera : Camera = Workspace.CurrentCamera 
local LocalPlayer : Player = Players.LocalPlayer 

local FindFirstChild : (any) = Workspace.FindFirstChild 
local FindFirstChildOfClass : (any) = Workspace.FindFirstChildOfClass
local TableFind : (any) = table.find 

Library.GetCharacter = function(self, Player : Player) : Model 
    return Player.Character 
end 

Library.GetHumanoid = function(self, Character : Model) : Humanoid 
    return FindFirstChildOfClass(Character, "Humanoid") 
end 

Library.GetRoot = function(self, Character : Model) : BasePar
    return FindFirstChild(Character, "HumanoidRootPart") 
end

Library.GetHealth = function(self, Humanoid : Humanoid) : number  
    return Humanoid.Health, Humanoid.MaxHealth  
end 

Library.IsAlive = function(self, Player : Player) : boolean
    local Character : Model = Library:GetCharacter(Player)
    if not Character then 
        return false 
    end 

    local Humanoid : Humanoid = Library:GetHumanoid(Character)
    local HumanoidRootPart : BasePart = Library:GetRoot(Character)

    if not Humanoid or not HumanoidRootPart then 
        return false 
    end 
    local Health : number
    local MaxHealth : number 
    Health, MaxHealth = Library:GetHealth(Humanoid)

    if Health < 0 then 
        return false 
    end 

    return true, Character, Humanoid, HumanoidRootPart, Health 
end 

Library.IsFriendly = function(self, Player : Player) : boolean 
    return Player.Team == LocalPlayer.Team 
end 

Library.IsEnemy = function(self, Player : Player) : boolean 
    return Player.Team ~= LocalPlayer.Team 
end 

Library.GetBodyParts = function(self, Character: Model, RootPart: BasePart, Indexes: boolean, Hitboxes: { string }) : {BasePart}
    local Parts: { [any]: any } = {}
    local BodyParts: { string } = Hitboxes or { "Head", "Torso", "Arms", "Legs" }

    for Index, Part in pairs(Character:GetChildren()) do
        if Part:IsA("BasePart") and Part ~= RootPart then
            if TableFind(BodyParts, "Head") and Part.Name:lower():find("head") then
                Parts[Indexes and Part.Name or #Parts + 1] = Part
            elseif TableFind(BodyParts, "Torso") and Part.Name:lower():find("torso") then
                Parts[Indexes and Part.Name or #Parts + 1] = Part
            elseif TableFind(BodyParts, "Arms") and Part.Name:lower():find("arm") then
                Parts[Indexes and Part.Name or #Parts + 1] = Part
            elseif TableFind(BodyParts, "Legs") and Part.Name:lower():find("leg") then
                Parts[Indexes and Part.Name or #Parts + 1] = Part
            elseif
                (TableFind(BodyParts, "Arms") and Part.Name:lower():find("hand"))
                or (TableFind(BodyParts, "Legs") and Part.Name:lower():find("foot"))
            then
                Parts[Indexes and Part.Name or #Parts + 1] = Part
            end
        end
    end

    return Parts
end

Library.GetClosestPlayer = function(self, Mode : string, Validation : (any)) : Player 
    Mode = Mode or "Mouse" -- // Mouse, Character 
    Validation = Validation or function() 
        return true 
    end

    local Mouse : Vector2 = UserInputService:GetMouseLocation()

    local Target : Player = nil 
    local Magnitude : number = math.huge  
    local Data : {[any] : any}

    for Index, Player in next, Players:GetPlayers() do 
        if Player == LocalPlayer then
            continue 
        end 

        local Alive, Character, Humanoid, HumanoidRootPart, Health = Library:IsAlive(Player)
        if not Alive then 
            continue 
        end 
            
        local ScreenPosition : Vector2 = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
        local MousePosition : Vector2 = Vector2.new(Mouse.X, Mouse.Y)
        local PlayerMagnitude : number = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - MousePosition).Magnitude

        if not Validation(Player, Character, Humanoid, HumanoidRootPart, Health) then 
            continue 
        end 
    
        if PlayerMagnitude < Magnitude then 
            Target = Player 
            Magnitude = PlayerMagnitude 
            Data = {Character, Humanoid, HumanoidRootPart, Health}
        end 
    end

    return Target, Magnitude, Data 
end 

Library.GetClosestPart = function(self, Mode : string, Character : Model) : BasePart 
    Mode = Mode or "Mouse" -- // Mouse, Character 
    Validation = Validation or function() 
        return true 
    end

    local Mouse : Vector2 = UserInputService:GetMouseLocation()

    local Target : Player = nil 
    local Magnitude : number = math.huge  
    local Data : {[any] : any}

    for Index, Part in next, Character:GetChildren() do 
        if not Part:IsA("BasePart") then 
            continue 
        end 

        local Positon = Camera:WorldToViewportPoint(Part.Position)
        local PartMagnitude = (Vector2.new(Position.X, Position.Y) - Mouse).Magnitude

        if Magnitude > PartMagnitude and TableFind(List, Object) then
			Target = Part
			Magnitude = PartMagnitude
		end
    end 

    return Target, Magnitude 
end 

return Library
