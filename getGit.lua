print("Checking turtle_info.txt...")
if(fs.exists("/turtle_info.txt")) then
    print("Reading turtle_info.txt...")
    t_inf = {}
    for l in io.lines("/turtle_info.txt") do
        func = string.gmatch(l, "([^:]+)")
        key = func()
        value = func()
        t_inf[key] = value
    end
    print("Checking if script can be found on GitHub...")
    if(http.checkURL(string.format("https://raw.githubusercontent.com/Spansos/CCscripts/main/scripts/%s", t_inf.script))) then
        print("Downloading script...")
        in_file = http.get("https://raw.githubusercontent.com/Spansos/CCscripts/main/scripts/" .. t_inf.script)
        print("Writing script...")
        out_file = io.open("script.lua", "w")
        io.output(out_file)
        io.write(in_file.readAll())
        io.flush()
        io.close(out_file)
        in_file.close()
        print("Running script...")
        os.run({}, "script.lua")
    else
        print("Script can't be accessed.")
        print("Launching possibly older version...")
        if(fs.exists("script.lua")) then
            os.run({}, "script.lua")
        else
            print("No offline script.")
            error()
        end
    end
else
    print("No file turtle_info.txt")
    error()
end