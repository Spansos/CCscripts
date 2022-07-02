local function config_turtle()
    local args_file = fs.open('args', 'r')
    local args = textutils.unserialise(args_file.readAll())
    args_file.close()
    local config = {}
    config['minePos'] = args['message']['pos']
    config['mineDims'] = args['message']['dims']
    direction = args['direction']
    return config, direction --direction is int, 1=north, 2=east, etc
end


local function dir_to_vector(dir)
    local dir_to_vec_table = {[1]={0, -1}, [2]={1, 0}, [3]={0, 1}, [4]={-1,0}}
    return dir_to_vec_table[dir]
end


local function vector_to_dir(vec)
    if vec == {0, 0} then
        return 1
    end
    vec[1] = vec[1]==0 and vec[1]/math.abs(vec[1]) or 0
    vec[2] = vec[2]==0 and vec[2]/math.abs(vec[2]) or 0
    local vec_to_dir_table = {['{0,-1,}']=1, ['{1,0,}']=2, ['{0,1,}']=3, ['{-1,0,}']=4}
    local vec_str = textutils.serialise(vec, {compact=true})
    return vec_to_dir_table[vec_str], vec
end


local function turnto(cur_dir, dest_dir)
    while cur_dir ~= dest_dir do
        cur_dir = (cur_dir % 4) + 1
        turtle.turnRight()
        print(cur_dir, dest_dir)
    end
    return cur_dir
end


local function go_to_y(cur_y, dest_y)
    local d_y = dest_y - cur_y
    if d_y > 0 then
        while d_y ~= 0 and turtle.up() do
            cur_y = cur_y + 1
            d_y = dest_y - cur_y
        end
    else
        if d_y < 0 then
            while d_y ~= 0 and turtle.down() do
                cur_y = cur_y - 1
                d_y = dest_y - cur_y
            end
        end
    end
    return cur_y
end


local function moveto(dest_pos, desired_y, direction)
    local cur_pos, dir = {gps.locate()}, direction
    local d_x, d_z = dest_pos[1]-cur_pos[1], dest_pos[3]-cur_pos[3]
    cur_pos[2] = go_to_y(cur_pos[2], desired_y)
    if d_x ~= 0 then
        local move_to_dir, move_vec = vector_to_dir({d_x, 0})
        dir = turnto(dir, move_to_dir)
        while d_x ~= 0 do
            while not turtle.forward() do
                turtle.up()
            end
            cur_pos[1], cur_pos[3] = cur_pos[1]+move_vec[1], cur_pos[3]+move_vec[2]
            d_x, d_z = dest_pos[1]-cur_pos[1], dest_pos[3]-cur_pos[3]
            cur_pos[2] = go_to_y(cur_pos[2], desired_y)
        end
    end
    if d_z ~= 0 then
        local move_to_dir, move_vec = vector_to_dir({0, d_z})
        dir = turnto(dir, move_to_dir)
        while d_z ~= 0 do
            while not turtle.forward() do
                turtle.up()
            end
            cur_pos[1], cur_pos[3] = cur_pos[1]+move_vec[1], cur_pos[3]+move_vec[2]
            d_x, d_z = dest_pos[1]-cur_pos[1], dest_pos[3]-cur_pos[3]
            cur_pos[2] = go_to_y(cur_pos[2], desired_y)
        end
    end
end

turtle.suckDown()
turtle.refuel()

config, direction = config_turtle()
pos = gps.locate()
moveto(config['minePos'], 70, direction)