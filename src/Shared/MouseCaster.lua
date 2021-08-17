-------------------- Services --------------------
local UserInputService = game:GetService('UserInputService')


-------------------- Constructor --------------------
local MouseCaster = {} 
MouseCaster.__index = MouseCaster

function MouseCaster.new()
    local self = setmetatable({}, MouseCaster)    
    self.RayCastParams = RaycastParams.new()
    self.RayCastParams.FilterType = Enum.RaycastFilterType.Whitelist
    self.RayCastParams.FilterDescendantsInstances = {}
    return self
end

-------------------- Public Methods --------------------
--> functioncal way to get the FilterDescendantsInstances () 
function MouseCaster:GetFilteredInstancesList()
    return self.RayCastParams.FilterDescendantsInstances 
end

--> functioncal way to set the raycast filter type
function MouseCaster:SetFilterType(aFilterType)
    self.RayCastParams.FilterType = aFilterType
end


--> functional way to set the Filter descendants list, calling this on an existing filter list will overwrite it.
function MouseCaster:SetTargetFilterList(filterList: table)
    self.RayCastParams.FilterDescendantsInstances = filterList
end


--> Updates RayCastParams.FilterDescendantsInstances w/o overwriting previous values 
function MouseCaster:UpdateTargetFilter(newInclusionList:table)
    local currentFilterList = self.RayCastParams.FilterDescendantsInstances

    for i, instance in ipairs(newInclusionList) do
        table.insert(currentFilterList, instance)
    end

    self.RayCastParams.FilterDescendantsInstances = currentFilterList
end


--> returns the instance intercepted by the ray
function MouseCaster:GetMouseTarget(theCurrentCamera: Camera, distanceScalar: number)
    local UnitRay = theCurrentCamera:ScreenPointToRay(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    distanceScalar = distanceScalar or 1000
    return workspace:Raycast(UnitRay.Origin, UnitRay.Direction *  distanceScalar, self.RayCastParams)    
end

    

return MouseCaster