# Mouse Caster
Roblox Utility ray casting module specifically for the mouse. I made this because I needed to filter multiple instances when ray casting from the mouse with the existing "legacy" [mouse API](https://developer.roblox.com/en-us/api-reference/class/Mouse)


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
*The distance scalar defaults to 1000 if not set*, this method **ignores the gui inset!** since it uses ScreenPointToRay to
get mouse location.

### TODO
- Add error throwing
- Add method to add instances with a collection service tag
- Add debug methods
  
## Contact info: 
Discord: CluelessDev(Quique)#5459

Youtube: [CluelessDev](https://www.youtube.com/channel/UCViY5D5-aR-Gi-HBf4dg5zQ)
