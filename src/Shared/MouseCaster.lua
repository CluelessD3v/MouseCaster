-------------------- Services --------------------
local UserInputService = game:GetService('UserInputService')
local CollectionService = game:GetService('CollectionService')

-------------------- Constructor --------------------
local MouseCaster = {} 
MouseCaster.__index = MouseCaster

function MouseCaster.new(distanceScalar: number, filterType, filteredInstancesList: table)
    local self = setmetatable({}, MouseCaster)
    self.Camera = workspace.CurrentCamera
    self.DistanceScalar = distanceScalar or 1000

    self.RayCastParams = RaycastParams.new()
    self.RayCastParams.FilterType = filterType or Enum.RaycastFilterType.Whitelist
    self.RayCastParams.FilterDescendantsInstances = filteredInstancesList or {}
    
    
    self.Target = function()
        local UnitRay = self.Camera:ScreenPointToRay(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        distanceScalar = distanceScalar or 1000
        local target = workspace:Raycast(UnitRay.Origin, UnitRay.Direction *  self.DistanceScalar, self.RayCastParams)
        if target then
            return target.Instance
        end
    end
    
    return self
end

-------------------- Public Methods --------------------
--> functioncal way to get the FilterDescendantsInstances () 
function MouseCaster:PrintFilteredInstancesList()
    print(self.RayCastParams.FilterDescendantsInstances) 
end

--> functional way to set the ray cast filter type
function MouseCaster:SetFilterType(aFilterType)
    self.RayCastParams.FilterType = aFilterType
end


--> functional way to set the Filter descendants list, calling this on an existing filter list will overwrite it.
function MouseCaster:SetTargetFilterList(filterList: table)
    self.RayCastParams.FilterDescendantsInstances = filterList
end

--> Adds all instances with the given tags of the tag list in the ray cast filter, calling this on an existing filter list will overwrite it.
function MouseCaster:SetTargetFilterListFromTags(taglist: table)
    local filterList = {}

    for _, tag in ipairs(taglist) do
        local taggedInstances = CollectionService:GetTagged(tag)

        for _, instance in ipairs(taggedInstances) do
            table.insert(filterList, instance)
        end
    end
    
    self.RayCastParams.FilterDescendantsInstances = filterList
end

--> Updates RayCastParams.FilterDescendantsInstances w/o overwriting previous values 
function MouseCaster:UpdateTargetFilter(newInclusionList:table)
    local currentFilterList = self.RayCastParams.FilterDescendantsInstances

    for _, instance in ipairs(newInclusionList) do
        table.insert(currentFilterList, instance)
    end

    self.RayCastParams.FilterDescendantsInstances = currentFilterList --> I think these are redundant AF... //TODO FIXCON3 TEST THIS 
end


--> Updates the instance filter by Adding all instances with the given tags of the tag list in the ray cast filter w/o overwriting previous values
function MouseCaster:UpdateTargetFilterFromTags(taglist: table)
    local currentFilterList = self.RayCastParams.FilterDescendantsInstances

    for _, tag in ipairs(taglist) do
        local taggedInstances = CollectionService:GetTagged(tag)

        for _, instance in ipairs(taggedInstances) do
            table.insert(currentFilterList, instance)
        end
    end
    
    self.RayCastParams.FilterDescendantsInstances = currentFilterList
end

--> returns Raycast result (if any)
function MouseCaster:GetRaycastResult()
    local UnitRay = self.Camera:ScreenPointToRay(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    return workspace:Raycast(UnitRay.Origin, UnitRay.Direction *  self.DistanceScalar, self.RayCastParams)
end
    

return MouseCaster