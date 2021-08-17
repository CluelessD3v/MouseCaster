
for x = 1, 4 do
    for z = 1, 4 do
        local tile = Instance.new("Part")
        tile.Size = Vector3.new(4,2,4)

        tile.Position = Vector3.new(tile.Size.X * x, 4, tile.Size.Z * z )
        tile.Anchored = true
        tile.Parent = workspace
    end
end