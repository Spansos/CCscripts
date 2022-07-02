function select_item(item)
    for i=1, 16 do
        item_data = turtle.getItemDetail(i, false)
        if(item_data ~= nil and item_data.name == item) then
            turtle.select(i)
            break
        end
    end
end

function return_to_chest()
    while(true) do
        while(not turtle.detect()) do
                turtle.forward()
        end
        is_block, block_data = turtle.inspect()
        if(block_data.name == "minecraft:chest") then
            turtle.turnLeft()
            turtle.turnLeft()
            break
        end
        turtle.turnLeft()
    end
end

function action()
    is_block, block_data = turtle.inspectDown()
    if((not is_block) or ((block_data.name == "minecraft:wheat") and (block_data.state.age == 7))) then
        turtle.digDown()
        select_item("minecraft:wheat_seeds")
        turtle.placeDown()
    end
end

function go_over()
    n = 1
    while(not turtle.detect()) do
        while(not turtle.detect()) do
            action()
            turtle.forward()
        end
        if(n%2 == 1) then
            action()
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
        else
            action()
            turtle.turnLeft()
            turtle.forward()
            turtle.turnLeft()
        end
        n = n + 1
    end
end

function wait(n)
    for i=1, n do
        sleep(1)
        print(string.format("%d/%d", i, n))
    end
end

function dump()
    fuels = {"minecraft:charcoal", "minecraft:coal"}
    turtle.turnLeft()
    turtle.turnLeft()
    for i=1, 16 do
        item_data = turtle.getItemDetail(i, false)
        turtle.select(i)
        if(item_data and fuels[item_data.name]) then
            turtle.dropUp()
        else
            turtle.drop()
        end
    end
    turtle.turnLeft()
    turtle.turnLeft()
end

function fuel()
    turtle.select(1)
    while(turtle.getFuelLevel() < 3000) do
        turtle.suckUp()
        turtle.refuel()
    end
end

while(true) do
    return_to_chest()
    dump()
    wait(300)
    fuel()
    go_over()
end