function move()
    is_block, block_data = turtle.inspect()
    if(is_block and block_data.name == "minecraft:oak_leaves") then
        turtle.dig()
    end
    turtle.suck()
    r = turtle.forward()
    return r
end

function select_sapling()
    for i=1, 16 do
        inf = turtle.getItemDetail(i, false)
        if(inf ~= nil and inf.name == "minecraft:oak_sapling") then
            turtle.select(i)
            return 1
        end
    end
    return 0
end

function go_back()
    repeat
        is_block, block_data = turtle.inspectDown()
        if(block_data.name ~= "minecraft:cobblestone_slab" and block_data.name ~= "minecraft:cobblestone" and block_data.name ~= "minecraft:dirt" and block_data.name ~= "minecraft:grass_block") then
            turtle.digDown()
            turtle.down()
        end
    until(block_data.name == "minecraft:cobblestone_slab" or block_data.name == "minecraft:cobblestone" or block_data.name == "minecraft:dirt" or block_data.name == "minecraft:grass_block")
    while(true) do
        is_block, block_data = turtle.inspectDown()
        if(block_data.name == "minecraft:cobblestone" or block_data.name == "minecraft:cobblestone_slab") then
            break
        else
            if(not move()) then
                turtle.turnRight()
            end
        end
    end
    repeat
        if(not move()) then
            turtle.turnRight()
        end
        is_block, block_data = turtle.inspectDown()
        if(not (block_data.name == "minecraft:cobblestone" or block_data.name == "minecraft:cobblestone_slab")) then
            turtle.turnRight()
            turtle.turnRight()
            move()
            turtle.turnLeft()
        end
        is_block, block_data = turtle.inspect()
    until(block_data.name == "minecraft:chest")
end

function chop()
    turtle.dig()
    move()
    repeat
        turtle.digUp()
        turtle.up()
        is_block, block_data = turtle.inspectUp()
    until(block_data.name == "minecraft:cobblestone")
    repeat
        turtle.down()
        is_block, block_data = turtle.inspectDown()
    until(block_data.name == "minecraft:dirt" or block_data.name == "minecraft:grass_block")
    turtle.turnRight()
    turtle.turnRight()
    move()
    turtle.turnRight()
    turtle.turnRight()
end

function action()
    is_block, block_data = turtle.inspectDown()
    if(block_data.name == "minecraft:cobblestone_slab") then
        turtle.turnRight()
        turtle.suck()
        is_block, block_data = turtle.inspect()
        if(block_data.name == "minecraft:oak_log") then
            chop()
        end
        if(not is_block) then
            if select_sapling() == 1 then
                turtle.place()
            end
        end
        turtle.turnRight()
        turtle.turnRight()
        turtle.suck()
        is_block, block_data = turtle.inspect()
        if(block_data.name == "minecraft:oak_log") then
            chop()
        end
        if(not is_block) then
            if select_sapling() == 1 then
                turtle.place()
            end
        end
        turtle.turnRight()
    end
end

function wait(n)
    for i=1, n do
        os.sleep(1)
        print(string.format("%d/%d", i, n))
    end
end

function dump()
    fuels = {"minecraft:charcoal", "minecraft:coal"}
    for i=1, 16 do
        item_data = turtle.getItemDetail(i, false)
        turtle.select(i)
        if(item_data and fuels[item_data.name]) then
            turtle.turnLeft()
            turtle.drop()
            turtle.turnRight()
        else
            turtle.drop()
        end
    end
end

function fuel()
    turtle.turnLeft()
    turtle.select(1)
    while(turtle.getFuelLevel() < 3000) do
        turtle.suck()
        turtle.refuel()
    end
    turtle.turnRight()
end

function over_all()
    turtle.turnRight()
    turtle.turnRight()
    move()
    n = 1
    while(true) do
        is_block, block_data = turtle.inspectDown()
        if(block_data.name == "minecraft:cobblestone") then
            if(n%2 == 1) then
                turtle.turnLeft()
                for i=1, 3 do
                    if(not move()) then
                        return
                    end
                end
                turtle.turnLeft()
            else
                turtle.turnRight()
                for i=1, 3 do
                    if(not move()) then
                        return
                    end
                end
                turtle.turnRight()
            end
            move()
            n = n + 1
        else
            action()
            move()
        end
    end
end

while(true) do
    go_back()
    dump()
    fuel()
    wait(0)
    over_all()
end