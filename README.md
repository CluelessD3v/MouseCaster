# Mouse Caster
Roblox Utility ray casting module specifically for the mouse. I made this because I needed to filter multiple instances when ray casting from the mouse with the existing "legacy" [mouse API](https://developer.roblox.com/en-us/api-reference/class/Mouse)

I decided to make my own because current available modules intend to be either a wrapper or an enhanced Mouse API, **which is not my intention**; if you need that, please use this modules instead:

[starmaq Custom Mouse Module](https://devforum.roblox.com/t/custom-mouse-module/1051363)

[dark:sugnslaes PlayerMouse2, modern alternative to the legacy PlayerMouse](https://devforum.roblox.com/t/custom-mouse-module/1051363)

Both, in my opinion are great Player Mouse alternatives.


## Installation
Just copy paste the contents from the src/MouseCaster.lua into a module script. Put said module in Replicated storage.

## API

### Properties
`RayCastParams`  RayCastParams object

### Methods

`new(filterType?: Enum.RaycastFilterType, filteredInstancesList?: table): MouseCaster`

Constructs a new MouseCaster object, accepts **two** optional parameters:
- The ray cast filter type, either blacklist or whitelist, *defaults to blacklist*
- A table of instances to filter, *defaults to an empty table*

`SetFilterType(filterType: Enum.RayCastFilterType): void`

functional way to set the ray cast filter type, again either:
- blacklist
- whitelist

`SetTargetFilterList(filteredInstancesList: table): void`

functional way to set the Filter descendants list, **calling this on an existing filter list will overwrite it**.

`UpdateTargetFilter(newInclusionList:table): void`

Updates MouseCaster object RayCastParams.FilterDescendantsInstances w/o overwriting previous values 

`GetMouseTarget(theCurrentCamera: Camera, distanceScalar?: number): Instance`

Ray casting function, shoots a ray from the mouse position into a set distance, returns whatever it intercepted if anything.
*The distance scalar defaults to 1000 studs if not set*, this method **ignores the gui inset!** since it uses ScreenPointToRay to
get mouse location.


## Example usage
Simple, constant ray casting from the mouse that ignores the baseplate, if you wan’t to try this out, install the module and copy paste this code in a script in StarterCharacterScripts

```lua
local RunService = game:GetService('RunService')
local MouseCaster = require(game.ReplicatedStorage.MouseCaster)
local newMouseCaster = MouseCaster.new()

newMouseCaster:SetFilterType(Enum.RaycastFilterType.Blacklist)
newMouseCaster:SetTargetFilterList({workspace.Baseplate})
local camera = workspace.CurrentCamera

RunService.Heartbeat:Connect(function()
    print(newMouseCaster:GetMouseTarget(camera, 500))
end)

```
## TODO
- Add error throwing
- Add method to add instances with a collection service tag
- Add debug methods

## Disclaimer
This was done with a specific use in mind for my tile based RTS, basically I needed to ignore everything but the tiles, but that is not currently possible with the legacy API. Therefore don’t expect this module to be some sort wrapper or new mouse API in roids, it’s just a tool I found useful specifically for raycasting from the mouse and maybe you will too.

## Contact info: 
Discord: CluelessDev(Quique)#5459

Youtube: [CluelessDev](https://www.youtube.com/channel/UCViY5D5-aR-Gi-HBf4dg5zQ)
