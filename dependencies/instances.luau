local Library: { [any]: any } = {}

Library.__index = Library

Library.Create = function(self, ClassName: string, Properties: {}?, Name: string?): { Instance: Instance, ClassName: string, Properties: { [string]: any }, Name: string }
	Properties = Properties or {}
	Name = Name or tostring(math.random(1, 1000))

	local Data = setmetatable({
		Instance = Instance.new(ClassName),
		ClassName = ClassName,
		Properties = Properties,
		Name = Name,
	}, Library)

	for Index, Value in next, Data.Properties do
		Data:Set(Index, Value)
	end

	if self.Instance then
		Data:Set("Parent", self.Instance)
	end

	return Data
end

Library.Set = function(self, Index: string, Value: any, UpdateProperties: boolean): { any }?
	if not self.Instance then
		return
	end

	self.Instance[Index] = Value

	if UpdateProperties then
		self.Properties[Index] = Value
	end

	return self
end

Library.Clean = function(self)
	if not self.Instance then
		return
	end

	self.Instance:Destroy()
	self = nil
end

return Library
