local Library: { [any]: any } = {}

Library.__index = Library

local CloneReference : (any) = cloneref or function(...: any)
	return ...
end

Library.Get = function(self, Name: string): ServiceProvider
	local Service: ServiceProvider = CloneReference(game:GetService(Name))
	Library[Name] = Service
	return Service
end

Library.Fetch = function(self, Name: string): ServiceProvider
	return Library[Name]
end

Library.Insert = function(self, Service: ServiceProvider): ServiceProvider
	Library[Service.Name] = Service

	return Service
end

return Library
