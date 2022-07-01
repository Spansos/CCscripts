turtle.suckDown(1)
turtle.refuel()
turtle.turnLeft()
while true do
    if not turtle.forward() then
        turtle.dig()
    end
end