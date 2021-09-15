# Mouse Caster

**Collection service based** Roblox ray casting module specifically for the mouse. I am developing this library because the existing "legacy" [mouse API](https://developer.roblox.com/en-us/api-reference/class/Mouse) is a pain to work with in my current project.

Added to the above; I also think that not having a modern, convenient Mouse API is in my opinion no bueno, simple example is attempting to raycast with the mouse w/o using the legacy mouse API.

```lua
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local MouseLocation = UserInputService:GetMouseLocation()
local camera = workspace:CurrentCamera
local unitRay = camera:ScreenPointToRay(MouseLocation().X, MouseLocation().Y)

local distanceScalar = 500

local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = {workspace.Baseplate}

local target = nil

RunService.Heartbeat:Connect(function()
    target = workspace:Raycast(UnitRay.Origin, UnitRay.Direction * distanceScalar, raycastParams)
end)

```
Although this is some simple code, it is definitely not beginner friendly (although if you are here, you probably are not a beginner), and lazy developers like me dread having to write boiler plate code

Not only that, but having to write this much code, at least in my opinion is a regression when you can just do
`Mouse.Target` with the legacy API...

That said, I am not at all trying to make my own Mouse Wrapper, which takes us to.

<br>

## Disclaimer 
I wrote this module with a very specific use case in mind: Casting a ray from the mouse, and rapidly determine if an instance should be ignored or returned. This is achieved by checking if an instance is tagged with a collection service tag that should be ignored. 

*the module can change at any time depending in my project needs, if something is not working or just does not fly with me I will just delete it, there is no proper changelog and updates are not planned, they just come as I develop, I just made the the repo public cause maybe someone could find it useful*
<br>

if you need a full fledged mouse module, here are some options I found to be great:

<br>

## Full fledged mouse modules made by other developers
I decided to make my own because current available modules intend to be either a wrapper or an enhanced Mouse API, **which is not my intention**; if you need that, please use this modules instead:

[starmaq Custom Mouse Module](https://devforum.roblox.com/t/custom-mouse-module/1051363)

[dark:sugnslaes PlayerMouse2, modern alternative to the legacy PlayerMouse](https://devforum.roblox.com/t/custom-mouse-module/1051363)

Both, in my opinion are great Player Mouse alternatives.

## Installation
Just copy paste the contents from the src/Shared/MouseCaster.lua into a module script. Put said module in Replicated storage.

<br>

## Current Capabilities
- Raycast from the mouse using ScreenPointToRay (ignores Gui Inset)
- Capable of multiple instances at once.
- Coded specifically to work with Collection Service. instead of ignoring specific instances, it ignore tags; therefore the Ray cast function will ignore any instance with the given tags.
- Mimics legacy Mouse API: Call MouseCaster.Target() to ray cast
- Extremely easy to use.

<br>

## API

### Properties
`Camera: Camera` Reference to the workspace current camera.

`DistanceScalar: number` Max distance the ray can travel in studs, defaults to 1000.

`FilteredTags: table` the list tags the caster will check for to determine if an instance is ignored or returned by the ray cast function.

`Target(): Instance` Identical to Mouse.Target in functionality, shoots a ray using Workspace:Raycast() and returns whatever **Instance** it intercepts, the max distance set by the DistanceScalar property. **MUST CALL AS**: **MouseCaster.Target()** else it will error.

<br>

### Methods

`new(distanceScalar?:number filteredTags?: table): MouseCaster`

Constructs a new MouseCaster object, accepts **two** optional parameters:
- The Max distance the ray can travel in studs, *defaults to 1000 studs*
- A table of tags to filter, *defaults to an empty table*

<br>

`SetFilteredTags(filteredTagsTable:table)`: void

Sets the Filtered Tags list to the given table, if there was an existing one, then it will overwrite it.

<br>

`UpdatedFilteredTags(newTagsTable:table)`: void

Updates the FilteredTags list w/o overwriting existing values, it skip duplicates

<br>

`RemoveFilteredTag(RemovedTagsTable:table)`: void

Removes the given tags from the Filtered Tags list

<br>

## Example usage

**assuming you have Mouse caster installed in replicated storage, you can just copy paste these examples and they will work out of the box**

## Simple, constant ray casting from the mouse that ignores any object tagged with the "Ignored" tag 
```lua
local RunService = game:GetService('RunService')

local MouseCaster = require(game.ReplicatedStorage.MouseCaster)
local newMouseCaster = MouseCaster.new(1500, {"Ignored"}) 

RunService.Heartbeat:Connect(function()
    print(newMouseCaster.Target())
end)
```
## Pseudo RTS tile based map example in which assets are spawned on top of tiles, EVERYTHING BUT THE TILES are ignored by the ray cast in this example

```lua
-- Server Script
local CollectionService = game:GetService('CollectionService')


-- Generating 4x4 tile map
for x = 1, 4 do
    for z = 1, 4 do
        
        -- generate the tilemap and present it in the workspace
        local tile = Instance.new("Part")
        tile.Size = Vector3.new(4,1,4)
        tile.Name = "Tile"..tostring(x..z)
        tile.Name = "Tile"
        tile.Position = Vector3.new(tile.Size.X * x, 4, tile.Size.Z * z)
        tile.Anchored = true

        -- tag the tile with the "Tile" tag
        CollectionService:AddTag(tile, "Tile")
        tile.Parent = workspace
    end
end

-- Spawning props on top of tiles
for _, tile in ipairs(CollectionService:GetTagged("Tile")) do
    local Prop = Instance.new("Part")
    Prop.Size = Vector3.new(2,2,2)
    Prop.Name = "TestAsset"
    Prop.Anchored = true

    CollectionService:AddTag(Prop, "Prop")
    
    Prop.BrickColor = BrickColor.new("Really red")
    local yOffset = tile.Size.Y/2 + Prop.Size.Y/2 
    Prop.Position = tile.Position + Vector3.new(0, yOffset, 0) 
    Prop.Parent = tile
end

-- Local script
local RunService = game:GetService('RunService')
local MouseCaster = require(game.ReplicatedStorage.MouseCaster)

-- Create a new mousecaster instance.
local newMouseCaster = MouseCaster.new(1500)
newMouseCaster.SetFilteredTags({"Prop"})

local count = 0
RunService.Heartbeat:Connect(function()
    print(newMouseCaster.Target())

    count += 1
    -- when the count reaches 150, then the props will no longer be ignored.
    if count >= 150 then
        newMouseCaster:RemoveFilteredTag({"Prop"})
    end

end)



```
<br>

## TODO
- Add error throwing
- Add debug methods?
- Add more/better examples to doc?

<br>

## Credits
Credit to discord user Bearosama, he helped writing now removed code of the module.

## Contact info: 
Discord: CluelessDev(Quique)#5459

Youtube: [CluelessDev](https://www.youtube.com/channel/UCViY5D5-aR-Gi-HBf4dg5zQ)


