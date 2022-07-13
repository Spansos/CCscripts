local function try_empty()
    for i=1, 16 do
        turtle.select(i)
        turtle.dropUp()
    end
end

local function inv_full()
    for i=1, 16 do
        if turtle.getItemCount(i) == 0 then
            return false
        end
    end
    return true
end

local function try_break()
    if inv_full() then return end
    local is_block, block_data = turtle.inspect()
    if is_block and block_data['name'] == 'computercraft:turtle_normal' then
        turtle.dig()
    end
end

while true do
    try_empty()
    try_break()
    sleep(.5)
end