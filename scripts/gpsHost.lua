local function getModem()
    local modems = {peripheral.find("modem")}
    for i, mod in ipairs(modems) do
        if(mod.isWireless()) then
            return mod
        end
    end
    return nil
end

local function open(mod)
    if(not mod.isOpen(65534)) then
        mod.open(65534)
    end
end

local function host(mod)
    local x, y, z = settings.get("x"), settings.get("y"), settings.get("z")
    while true do
        local _, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        if message == "PING" then
            --rednet.send(sender, textutils.serialize({x, y, z}))
            mod.transmit(replyChannel, 65534, textutils.serialize({x, y, z}))
        end
    end
end

mod = getModem()
open(mod)
host(mod)