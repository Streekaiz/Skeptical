local Library: { [any]: any } = {}

Library.__index = Library

Library.CompareDistance = function(self, Part: Part, SecondPart: Part): number
	local Distance1: Vector3 = Part.Position
	local Distance2: Vector3 = SecondPart.Position
	local Magnitude: number = (Distance1 - Distance2).Magnitude

	return Magnitude, Distance1, Distance2
end

Library.Raycast = function(self, Part: Part, EndPoint: Vector3, Origin: Vector3, Distance: number, Ignore: { any })
	Ignore = Ignore or {}
	Distance = Distance or 2000

	local Direction: Vector3 = (EndPoint - Origin).Unit * Distance

	local RaycastParams: RaycastParams = RaycastParams.new()
	RaycastParams.FilterDescendantsInstances = Ignore
	RaycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local Result: RaycastResult<BasePart>? = workspace:Raycast(Origin, Direction, RaycastParams)

	return (Result and Result.Instance and Result.Instance:IsDescendantOf(Part)) == true, Result and Result.Instance
end

Library.MouseMove = function(self, Position: Vector2, Mouse: Vector2, SmoothingX: number, SmoothingY: number)
	SmoothingX = SmoothingX or 1
	SmoothingY = SmoothingY or 1

	mousemoverel((Position.X - Mouse.X) * (SmoothingX / 100), (Position.Y - Mouse.Y) * (SmoothingY / 100))
end

Library.Clamp = function(self, Number : number, Max : number, Min : number) : number
    if Number > Max then 
        return Max 
    elseif Number < Min then 
        return Min 
    end

    return Number 
end

Library.Thread = function(self, Function : (any), ... : any) -- more to this later i guess
    local Success, Content = pcall(Function, ...)

    return Success, Content 
end

return Library
