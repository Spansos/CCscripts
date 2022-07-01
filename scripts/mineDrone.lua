local function get_config()
    local con_file = fs.open('config.txt')
    local pre_config = textutils.unserialise(con_file.readAll())
    local config = {}
    config['minePos'] = pre_config['pos']
    config['mineDims'] = pre_config['dims']
    return config


local function moveto(desired_y)
    local cur_pos = {gps.locate()}