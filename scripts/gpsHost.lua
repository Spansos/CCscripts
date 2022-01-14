local function getModem()
    local modems = {peripheral.find("modem")}
    for i, mod in ipairs(modems) do
        if(mod.isWireless()) then
            return mod
        end
    end
    return nil
end

x, y, z = settings.get("position")
mod = getModem()
modName  = peripheral.getName(mod)
rednet.open(modName)
while true do
    sender, message, distance = rednet.receive()
    if message == "PING" then
        rednet.send(sender, textutils.serialize({x,y,z}))
    end
end