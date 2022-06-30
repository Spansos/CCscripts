turtle.suckDown(1)
turtle.refuel()
while true do
    if not turtle.forward() then
        turtle.dig()
    end
end