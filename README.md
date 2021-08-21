# Mouse Caster
Roblox Utility ray casting module specifically for the mouse. I am developing this library because I could not filter multiple instances when ray casting from the mouse with the existing "legacy" [mouse API](https://developer.roblox.com/en-us/api-reference/class/Mouse)

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

Now, that said, I am not at all trying to make my own Mouse Wrapper, which takes us to.

<br>

## Disclaimer 
I wrote this module with a very specific use case in mind, which is current project, a tile based RTS, I needed a ray cast function that allowed me to Ignore everything but Tiles. hence why this is not an attempt of a new Mouse API in roids (but it can very well end up being that, it all depends in the needs of my game) or something like that, I don’t think I’m nearly as good of a scripter to pull that off, if you need a full fledged mouse module, here are some options I found to be great:

**This Module is actively in development as I add features to my game, but right now is very uncooked.**

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
- Capable of filtering either multiple or single instances
- support for CollectionService tags, mass filter tagged instances (Note: this is off course, more expensive)
- Mimics legacy Mouse API: Call MouseCaster.Target() to ray cast

<br>

## TODO
- Add error throwing
- Add debug methods?
- Add method to remove instances from the target filter
- Add more examples to API

<br>

## API

### Properties
`Camera: Camera` Reference to the workspace current camera

`DistanceScalar: number` Max distance the ray can travel in studs, defaults to 1000


`RayCastParams: function`  RayCastParams object


`Target(): Instance` Identical to Mouse.Target in functionality, shoots a ray with and returns whatever **Instance** it intercepts, distance set by DistanceScalar property. Call as: **MouseCaster.Target()** else it will error.

<br>

### Methods

`new(filterType?: Enum.RaycastFilterType, filteredInstancesList?: table): MouseCaster`

Constructs a new MouseCaster object, accepts **two** optional parameters:
- The ray cast filter type, either blacklist or whitelist, *defaults to blacklist*
- A table of instances to filter, *defaults to an empty table*

<br>

`SetFilterType(filterType: Enum.RayCastFilterType): void`

functional way to set the ray cast filter type, again either:
- blacklist
- whitelist

<br>

`SetTargetFilter(filteredInstancesList: table): void`

functional way to set the Filter descendants list, **calling this on an existing filter list will overwrite it**.

<br>

`UpdateTargetFilter(newInclusionList:table): void`

Updates MouseCaster object RayCastParams.FilterDescendantsInstances w/o overwriting previous values, **this method ignores duplicated values Automatically**

<br>

`GetRaycastResult(theCurrentCamera: Camera, distanceScalar?: number): RaycastResult`

Ray casting function, shoots a ray from the mouse position into a set distance, returns whatever it intercepted if anything.
*The distance scalar defaults to 1000 studs if not set*, this method **ignores the gui inset!** since it uses ScreenPointToRay to
get mouse location.

<br>

### CollectionService oriented methods

NOTE: *you can mimic these methods by spam calling UpdateTargetFilter() and passing CollectionService:GetTagged() tables to it.* **also; table values must be strings for these methods!**


`SetTargetFilterFromTags(tagsList: table)`

Adds all instances with the given tags of the tag list in the ray cast filter, calling this on an existing filter list will overwrite it. 

<br>

`UpdateTargetFilterFromTags(tagsList: table): void`

A more lazier, albeit expensive way to update the instance filter by Adding all instances with the given tags of the tag list in the ray cast filter w/o overwriting previous values
**this method ignores duplicated values Automatically**

<br>

## Example usage

## Simple, constant ray casting from the mouse that ignores **EVERYTHING BUT THE BasePlate**, 
```lua
local RunService = game:GetService('RunService')
local MouseCaster = require(game.ReplicatedStorage.MouseCaster)
local newMouseCaster = MouseCaster.new(1500, Enum.RaycastFilterType.Whitelist, {workspace.Baseplate})

RunService.Heartbeat:Connect(function()
    print(newMouseCaster.Target())
end)
```
## Tile map example in which assets are spawned on top of tiles, and they are ignored

```lua
-- Server
local CollectionService = game:GetService('CollectionService')


-- Generating 4x4 tile map
for x = 1, 4 do
    for z = 1, 4 do
        local tile = Instance.new("Part")
        tile.Size = Vector3.new(4,1,4)
        -- tile.Name = "Tile"..tostring(x..z)
        tile.Name = "Tile"
        tile.Position = Vector3.new(tile.Size.X * x, 4, tile.Size.Z * z)
        tile.Anchored = true
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
local newMouseCaster = MouseCaster.new(1500)
local localPlayer = game:GetService('Players').LocalPlayer

-- show casing usage of filtering API: note that you can combine both CS and regular filter methods w/o problem

-- Adding default scene instances and character to the target filter
newMouseCaster:SetTargetFilter({workspace.Baseplate, workspace.SpawnLocation, localPlayer.Character }) 
newMouseCaster:UpdateTargetFilterFromTags({"Prop"}) --> ignoring props so only tiles are detected

-- Will ignore everything but the tiles
RunService.Heartbeat:Connect(function()
    print(newMouseCaster.Target())
end)

```



While I come up with more examples, keep in mind that most methods are just filter methods that behave exactly like  `self.RayCastParams.FilterDescendantsInstances`, just pass a table of instances to the filter methods and you are set

<br>

## Contact info: 
Discord: CluelessDev(Quique)#5459

Youtube: [CluelessDev](https://www.youtube.com/channel/UCViY5D5-aR-Gi-HBf4dg5zQ)


