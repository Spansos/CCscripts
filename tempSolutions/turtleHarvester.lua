while true do
    local bIs, tInfo = turtle.inspect()
    if tInfo['name'] == 'computercraft:turtle_normal' then
        turtle.dig()
        turtle.dropDown()
    else
        os.sleep(1)
    end
end