local function get_item_slot(item, bDisplay_name)
    for i=1, 16 do
        local item_info = turtle.getItemDetail(i, display_name)
        local item_name = item_info[bDisplay_name and "displayName" or "name"]
        if item_name == name then
            return i
        end
    end
end


local function place_turtle(slot)
    if not turtle.detect() then
        turtle.select(slot)
        turtle.place()
        local per = peripheral.wrap("front")
        per.turnOn()
    end
end

local function make_script(script_name)
    local code = http.get("https://raw.githubusercontent.com/Spansos/CCscripts/main/scripts"..script_name)
    local file = fs.open(script_name, 'w')
    file.write(code.readAll())
    file.close()
end

local function config_turtle(slot, script_name)
    if not fs.exists(script_name) then
        make_script(script_name)
    end
    turtle.select(slot)
    turtle.dropDown()
    delete_files('drive/', {})
    fs.copy(script_name, 'drive/startup.lua')
    turtle.suckDown()
end

local function suck_turtle()
    while not get_item_slot(config['turtle_type'], true) do
        turtle.suckUp()
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
        if not fs.isDir(file) and not table_contains(excludes, file) then
            fs.delete(file)
        end
    end
end

settings.set('shell.allow_disk_startup', false)
delete_files('', {'.settings', 'script.lua', 'startup.lua'})
local config = settings.get("station_config")

local sender_id, message, protocol = rednet.receive("release")

for i=1, message[3] do
    suck_turtle()
    slot = get_item_slot(message[1], true)
    config_turtle(slot, message[2])
    place_turtle(slot)
end
