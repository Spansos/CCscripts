local function getModem()
    local modems = {peripheral.find("modem")}
    for i, mod in ipairs(modems) do
        if(mod.isWireless()) then
            return mod
        end
    end
    return nil
end

local function host(mod, position)
    while true do
        local sender, message, distance = rednet.receive()
        if message == "PING" then
            rednet.send(sender, textutils.serialize(position))
        end
    end
end

host(getModem, settings.get("position"))