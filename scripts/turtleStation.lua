local function get_item_slot(item, bDisplay_name)
    for i=1, 16 do
        local item_info = turtle.getItemDetail(i, bDisplay_name)
        if item_info then
            local item_name = item_info[bDisplay_name and "displayName" or "name"]
            if item_name == item then
                return i
            end
        end
    end
end


local function table_contains(table, item)
    for _, v in ipairs(table) do
        if v == item then
            return true
        end
    end
    return false
end


local function delete_files(path, excludes)
    for _, file in ipairs(fs.list(path)) do
        if not table_contains(excludes, file) then
            fs.delete(fs.combine(path, file))
        end
    end
end


local function place_turtle(slot)
    while turtle.detect() do
        os.sleep(1)
    end
    turtle.select(slot)
    turtle.place()
    local per = peripheral.wrap("front")
    if per then
        per.turnOn()
    end
end


local function make_script(script_name)
    local code = http.get("https://raw.githubusercontent.com/Spansos/CCscripts/main/"..script_name)
    local file = fs.open(script_name, 'w')
    file.write(code.readAll())
    file.close()
end



local function config_turtle(slot, script_name, drone_args)
    if not fs.exists(script_name) then
        make_script(script_name)
    end
    turtle.select(slot)
    turtle.dropDown()
    delete_files('disk', {'rom'})
    fs.copy(script_name, 'disk/startup.lua')
    local args_file = fs.open('disk/args', 'w')
    args_file.write(textutils.serialise(drone_args))
    args_file.close()
    turtle.suckDown()
end


local function suck_turtle(turtle_type)
    while not get_item_slot(turtle_type, true) do
        turtle.suckUp()
    end
end


settings.set('shell.allow_disk_startup', false)
delete_files('', {'rom', '.settings', 'script.lua', 'startup.lua'})
local config = settings.get("station_config")

rednet.open("left")

while true do
    local sender_id, message, protocol = rednet.receive("release")
    local turtle_type, turtle_script, amount = message['turtle'], message['script'], message['n']

    for i=1, amount do
        suck_turtle(turtle_type)
        local slot = get_item_slot(turtle_type, true)
        config_turtle(slot, turtle_script, {tot_n=amount, n=i, direction=settings.get('direction'), message=message})
        place_turtle(slot)
    end
end