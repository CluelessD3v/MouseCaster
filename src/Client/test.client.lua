local MouseCaster = require(game.ReplicatedStorage.MouseCaster)

local RunService = game:GetService('RunService')

local newMouseCaster = MouseCaster.new()

newMouseCaster:SetFilterType(Enum.RaycastFilterType.Blacklist)
newMouseCaster:SetTargetFilterList({workspace.Baseplate})
local camera = workspace.CurrentCamera
RunService.Heartbeat:Connect(function()
    print(newMouseCaster:GetMouseTarget(camera, 1000))
end)




 
 