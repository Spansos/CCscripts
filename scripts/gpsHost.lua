local function getModem()
    local modems = {peripheral.find("modem")}
    for i, mod in ipairs(modems) do
        if(mod.isWireless()) then
            return mod
        end
    end
    return nil
end

local function host(mod)
    local x, y, z = settings.get("x"), settings.get("y"), settings.get("z")
    while true do
        local sender, message, distance = rednet.receive()
        if message == "PING" then
            rednet.send(sender, textutils.serialize({x, y, z}))
        end
    end
end

host(getModem)