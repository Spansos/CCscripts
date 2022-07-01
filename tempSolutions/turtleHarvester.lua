while true do
    local bIs, tInfo = turtle.inspect()
    if tInfo['name'] == 'minecraft:turtle_normal' then
        turtle.dig()
        turtle.dropDown()