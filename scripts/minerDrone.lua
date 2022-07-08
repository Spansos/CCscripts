local function get_divs(n)
    for i=math.floor(n/2), 1, -1 do
        local t_n = n/i
        if math.floor(t_n) == t_n then
            return i, n/i
        end
    end
end

local function calc_pos_and_size(root, size, tot_n, n)
    local div1, div2 = get_divs(tot_n)
    local base_size = {math.ceil(size[1]/div1), math.ceil(size[2]/div2)}
    local grid_pos = {((n-1)%div1), math.floor((n-1)/div1)}
    local new_pos = {grid_pos[1]*base_size[1]+root[1], root[2], grid_pos[2]*base_size[2]+root[3]}
    local new_size = {
        math.min(math.abs(root[1]+size[1]-1-new_pos[1]), base_size[1]),
        math.min(math.abs(root[3]+size[2]-1-new_pos[3]), base_size[2])
    }
    return new_pos, new_size
end

local function config_turtle()
    local args_file = fs.open('args', 'r')
    local args = textutils.unserialise(args_file.readAll())
    args_file.close()
    local config = {}
    config['minePos'], config['mineDims'] = calc_pos_and_size(args['message']['pos'], args['message']['dims'], args['tot_n'], args['n'])
    config['moveY'] = args['message']['my'] or 100
    config['mineY'] = config['minePos'][2]
    config['pos'] = args['pos']
    config['dir'] = args['dir'] --config['dir'] is int, 1=north, 2=east, etc
    return config
end

local function get_save()
    local save_file = fs.open('save', 'r')
    local save = textutils.unserialise(save_file.readAll())
    save_file.close()
    return save
end

local function set_save(data)
    local save_file = fs.open('save', 'w')
    local save_str = textutils.serialize(data)
    save_file.write(save_str)
    save_file.close()
end

local function get_state()
    local save = get_save()
    return save['state']
end

local function set_state(state)
    local save = get_save()
    save['state'] = state
    set_save(save)
end

local function vec_from_dir(dir)
    local r_vec = {}
    local dir_to_vec_table = {[1]={0, -1}, [2]={1, 0}, [3]={0, 1}, [4]={-1,0}}
    local dir_vec = dir_to_vec_table[dir]
    r_vec[1], r_vec[2] = dir_vec[1], dir_vec[2]
    return r_vec, r_vec[1], r_vec[2]
end

local function get_direction()
    local pos1 = vector.new(gps.locate())
    while not turtle.forward() do
        turtle.turnRight()
    end
    local pos2 = vector.new(gps.locate())
    turtle.back()
    local r_vec = pos2 - pos1
    return {r_vec.x, r_vec.y, r_vec.z}
end

local function make_move_vec(vec)
    local r_vec = {}
    r_vec[1] = vec[1]~=0 and vec[1]/math.abs(vec[1]) or 0
    r_vec[2] = vec[1]==0 and vec[2]~=0 and vec[2]/math.abs(vec[2]) or 0
    return r_vec
end

local function vec_to_dir(vec)
    if vec == {0, 0} then
        return 1
    end
    local m_vec = make_move_vec(vec)
    local vec_to_dir_table = {['{0,-1,}']=1, ['{1,0,}']=2, ['{0,1,}']=3, ['{-1,0,}']=4}
    local vec_str = textutils.serialise(m_vec, {compact=true})
    local r_dir = vec_to_dir_table[vec_str]
    return r_dir
end


local function turnto(cur_dir_vec, dest_dir_vec)
    while vec_to_dir(cur_dir_vec) ~= vec_to_dir(dest_dir_vec) do
        local n_vec = vec_from_dir((vec_to_dir(cur_dir_vec) % 4) + 1)
        cur_dir_vec[1] = n_vec[1]
        cur_dir_vec[2] = n_vec[2]
        turtle.turnRight()
    end
end


local function go_to_y(cur_pos, dest_y)
    local d_y = dest_y - cur_pos[2]
    if d_y > 0 then
        while d_y ~= 0 and turtle.up() do
            cur_pos[2] = cur_pos[2] + 1
            d_y = dest_y - cur_pos[2]
        end
    else
        if d_y < 0 then
            while d_y ~= 0 and turtle.down() do
                cur_pos[2] = cur_pos[2] - 1
                d_y = dest_y - cur_pos[2]
            end
        end
    end
end


local function moveto(dest_pos, cur_pos, desired_y, dir_vec)
    local loc_pos = {gps.locate()}
    cur_pos[1] = loc_pos[1]
    cur_pos[2] = loc_pos[2]
    cur_pos[3] = loc_pos[3]
    local d_x, d_z = dest_pos[1]-cur_pos[1], dest_pos[3]-cur_pos[3]
    go_to_y(cur_pos, desired_y)
    if d_x ~= 0 then
        turnto(dir_vec, make_move_vec({d_x, 0}))
        while d_x ~= 0 do
            while not turtle.forward() do
                if turtle.up() then
                   cur_pos[2] = cur_pos[2] + 1 
                end
            end
            cur_pos[1], cur_pos[3] = cur_pos[1]+dir_vec[1], cur_pos[3]+dir_vec[2]
            d_x, d_z = dest_pos[1]-cur_pos[1], dest_pos[3]-cur_pos[3]
            go_to_y(cur_pos, desired_y)
        end
    end
    if d_z ~= 0 then
        turnto(dir_vec, make_move_vec({0, d_z}))
        while d_z ~= 0 do
            while not turtle.forward() do
                if turtle.up() then
                    cur_pos[2] = cur_pos[2] + 1
                 end
            end
            cur_pos[1], cur_pos[3] = cur_pos[1]+dir_vec[1], cur_pos[3]+dir_vec[2]
            d_x, d_z = dest_pos[1]-cur_pos[1], dest_pos[3]-cur_pos[3]
            go_to_y(cur_pos, desired_y)
        end
    end
    go_to_y(cur_pos, dest_pos[2])
end

local function turn(bLeft, dir_vec)
    if bLeft then
        _, dir_vec[1], dir_vec[2] = vec_from_dir((vec_to_dir(dir_vec) - 2) % 4 + 1)
        turtle.turnLeft()
    else
        _, dir_vec[1], dir_vec[2] = vec_from_dir((vec_to_dir(dir_vec) % 4) + 1)
        turtle.turnRight()
    end
end

local function mine_line(len, pos, dir_vec)
    for i=1, len do
        while turtle.digUp() do end
        while turtle.digDown() do end
        while i ~= len and not turtle.forward() do
            turtle.dig()
        end
        if i ~= len then
            pos[1] = pos[1] + dir_vec[1]
            pos[3] = pos[3] + dir_vec[2]
        end
    end
end


local function mine_plane(mine_size, pos, dir_vec)
    local l = false
    for i=1, mine_size[1] do
        mine_line(mine_size[2], pos, dir_vec)
        if i ~= mine_size[1] then
            turn(l, dir_vec)
            mine_line(2, pos, dir_vec)
            turn(l, dir_vec)
            l = not l
        end
    end
end

local function dig_down(pos, n)
    n = n or 1
    for i=1, n do
        while not turtle.down() do
            turtle.digDown()
        end
        pos[2] = pos[2] - 1
    end
end

local function mine(root_pos, mine_size, pos, dir_vec)
    while get_save()['mineY'] > 55 do
        local mineY = get_save()['mineY']
        moveto({root_pos[1], mineY, root_pos[3]}, pos, mineY, dir_vec)
        turnto(dir_vec, {0, 1})
        dig_down(pos, 3)
        mine_plane(mine_size, pos, dir_vec)
        local new_save = get_save()
        new_save['mineY'] = pos[2]
        set_save(new_save)
    end
end

while turtle.getFuelLevel() < 1000 do
    turtle.suckDown(1)
    turtle.refuel()
end

if fs.exists('args') then
    local config = config_turtle()
    config['state'] = 'move_mine'
    set_save(config)
    fs.delete('args')
else
    local config = get_save()
    local dir = vec_to_dir(get_direction())
    config['dir'], config['pos'] = dir, {gps.locate()}
    set_save(config)
end
local config = get_save()
local cur_pos, dir_vec, moveY = config['pos'], vec_from_dir(config['dir']), config['moveY']

repeat
    local state = get_state()
    if state == 'move_mine' then
        moveto(config['minePos'], cur_pos, moveY, dir_vec)
        set_state('do_mine')
    elseif state == 'do_mine' then
        mine(config['minePos'], config['mineDims'], cur_pos, dir_vec)
        set_state('move_end')
    elseif state == 'move_end' then
        moveto({-185, 63, -30}, cur_pos, moveY, dir_vec)
        set_state('end')
    end
until state == 'end'