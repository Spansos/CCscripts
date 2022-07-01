while true do
    local bIs, tInfo = turtle.inspect()
    if tInfo['name'] == 'computercraft:turtle_normal' then
        turtle.dig()
        turtle.dropDown()
    end
end