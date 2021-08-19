# Mouse Caster
Roblox Utility ray casting module specifically for the mouse. I made this because I could not filter multiple instances when ray casting from the mouse with the existing "legacy" [mouse API](https://developer.roblox.com/en-us/api-reference/class/Mouse)

<br>

## Disclaimer 

This was done with a specific use in mind for my tile based RTS, basically I needed to ignore everything but the tiles, but that is not currently possible with the legacy API. Therefore don’t expect this module to be some sort wrapper or new mouse API in roids, it’s just a tool I found useful specifically for raycasting from the mouse and maybe you will too.

**This Module is actively in development as I add features to my game, but right now is very uncooked.**

<br>

## Similar modules
I decided to make my own because current available modules intend to be either a wrapper or an enhanced Mouse API, **which is not my intention**; if you need that, please use this modules instead:

[starmaq Custom Mouse Module](https://devforum.roblox.com/t/custom-mouse-module/1051363)

[dark:sugnslaes PlayerMouse2, modern alternative to the legacy PlayerMouse](https://devforum.roblox.com/t/custom-mouse-module/1051363)

Both, in my opinion are great Player Mouse alternatives.


## Installation
Just copy paste the contents from the src/Shared/MouseCaster.lua into a module script. Put said module in Replicated storage.

## API

### Properties
`DistanceScalar: number` Max distance the ray can travel in studs, defaults to 1000


`RayCastParams: function`  RayCastParams object


`Target: Instance` Identical to Mouse.Target in functionality, shoots a ray with and returns whatever **Instance** it intercepts, distance set by DistanceScalar property.

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

`SetTargetFilterList(filteredInstancesList: table): void`

functional way to set the Filter descendants list, **calling this on an existing filter list will overwrite it**.

<br>

`UpdateTargetFilter(newInclusionList:table): void`

Updates MouseCaster object RayCastParams.FilterDescendantsInstances w/o overwriting previous values 

<br>

`UpdateTargetFilterFromTags(tagsList: table): void`

updates the instance filter by Adding all instances with the given tags of the tag list in the ray cast filter w/o overwriting previous values

**values must be strings!**

<br>

`GetRaycastResult(theCurrentCamera: Camera, distanceScalar?: number): RaycastResult`

Ray casting function, shoots a ray from the mouse position into a set distance, returns whatever it intercepted if anything.
*The distance scalar defaults to 1000 studs if not set*, this method **ignores the gui inset!** since it uses ScreenPointToRay to
get mouse location.

<br>

## Example usage

### Simple, constant ray casting from the mouse that ignores **EVERYTHING BUT THE BasePlate**, 
```lua
local RunService = game:GetService('RunService')
local MouseCaster = require(game.ReplicatedStorage.MouseCaster)
local newMouseCaster = MouseCaster.new(1500, Enum.RaycastFilterType.Whitelist, {workspace.Baseplate})

RunService.Heartbeat:Connect(function()
    print(newMouseCaster.Target())
end)
```
<br>

## TODO
- Add error throwing
- Add debug methods
- Add method to remove instances from the target filter

## Contact info: 
Discord: CluelessDev(Quique)#5459

Youtube: [CluelessDev](https://www.youtube.com/channel/UCViY5D5-aR-Gi-HBf4dg5zQ)
