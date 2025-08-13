-- ignore this for now
-- can be a base

local Environment : {[any] : any} = getgenv() or _G or {}
local Author : string = "Streekaiz"
local Repository : string = "Skeptical"
local LoadTick : number = tick()

local Notification : {[any] : any}

Environment["Skeptical"] = {
    ["Dependencies"] = {
        ["Library"] = {},
        ["Clients"] = {},
        ["Instances"] = {},
        ["Miscallaenous"] = {},
        ["Services"] = {},
        ["Signals"] = {},
        ["String"] = {}
    }
}

local Games : {[number] : string} = {
    [17574618959] = "Baseplate"
}

for Index, Dependency in pairs({
    "Interface",
    "Clients",
    "Instances",
    "Miscallaenous",
    "Services",
    "Signals",
    "String"
}) do 
    local Success : boolean = false 
    local Source : ((any) -> any) 
    local ContinueLoading : boolean = true 
    local AnsweredPrompt : boolean = false 
    
    Success, Source = pcall(function(...)  
        return loadstring(
            game:HttpGet(
                string.format(
                    "https://raw.githubusercontent.com/%s/%s/main/Dependencies/%s.luau", 
                    Author, 
                    Repository, 
                    string.lower(Dependency)
                )
            ),
            Dependency
        )
    end)

    if not Success then
        warn("failed to load " .. Dependency .. ", error: " .. Source)
    end

    Environment["Skeptical"]["Dependencies"][Dependency] = Source() 
end  

local Game = nil 

for i, v in next, Games do 
    if i == game.PlaceId then 
        Game = v 
        break
    end
end

loadstring(game:HttpGet(
    string.format(
        "https://raw.githubusercontent.com/%s/%s/main/Games/%s.luau",
        Author,
        Repository,
        (Game ~= nil and Game) or "Universal"
    )
), "Skeptical")
