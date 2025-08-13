local Library: { [any]: any } = {}

Library.__index = Library 

Library.Case = function(self, Text: string, Casing: string): string
	if Casing == "lowercase" then
		return string.lower(Text)
	elseif Casing == "uppercase" then
		return string.upper(Text)
	else
		return Text
	end
end

Library.Surround = function(self, Text: string, Front: string, Behind: string): string
	return string.format("%s%s%s", Front, Text, Behind)
end

return Library
