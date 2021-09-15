local UserInputService = game:GetService('UserInputService')
local CollectionService = game:GetService('CollectionService')

-------------------- Constructor --------------------
local MouseCaster = {} 
MouseCaster.__index = MouseCaster

function MouseCaster.new(distanceScalar: number, filteredTags: table)
    local self = setmetatable({}, MouseCaster)
    self.Camera = workspace.CurrentCamera
    self.DistanceScalar = distanceScalar or 1000    
    self.FilteredTags = filteredTags or {}

    self.Target = function()
        local UnitRay = self.Camera:ScreenPointToRay(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        distanceScalar = distanceScalar or 1000
        local target = workspace:Raycast(UnitRay.Origin, UnitRay.Direction *  self.DistanceScalar, self.RayCastParams)

        if target then
            local targetTagsList = CollectionService:GetTags(target.Instance)
            
            -- check if the target has a filtered tag
            for _, targetTag in ipairs(targetTagsList) do
                if table.find(self.FilteredTags, targetTag) then
                    return
                end
            end
            
            -- no filtered tag? return me the instance
            return target.Instance
        end
    end
    
    return self
end

-------------------- Public routines ------------------

-- Sets the Filtered Tags list to the given table, if there was an existing one, then it will overwrite it.
function MouseCaster:SetFilteredTags(filteredTagsTable:table)
    self.FilteredTags = filteredTagsTable
end

-- Updates the FilteredTags list w/o overwriting existing values, it skip duplicates
function MouseCaster:UpdatedFilteredTags(newTagsTable:table)
    for _, tag in ipairs(newTagsTable) do
        local duplicatedTag = table.find(self.FilteredTags, tag)

        -- the tag is already being filtered? then skip it to avoid duplicates
        if duplicatedTag then 
            warn(tag, "tag is already being filtered") 
            continue
        else
            table.insert(self.FilteredTags, tag)
        end
    end
end

-- removes the given tags from the Filtered Tags list
function MouseCaster:RemoveFilteredTag(RemovedTagsTable:table)
    for _, tagToRemove in ipairs(RemovedTagsTable) do
        local removedTag = table.find(self.FilteredTags, tagToRemove)

        -- the tag is not in the filtered tags list? Then probably a typo was made, warn and skip it

        if removedTag == nil then 
            warn("Tag was not found!")
            continue
        else
            self.FilteredTags[removedTag] = nil
        end
    end 
    
end


return MouseCaster

