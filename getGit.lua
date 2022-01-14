print("Getting script settings...")
script = settings.get("script", false)
if script then
    print("Downloading from GitHub...")
    in_file = http.get("https://raw.githubusercontent.com/Spansos/CCscripts/main/"..script)
    if in_file then
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
        print("Script can't be found.")
        print("Launching possibly older version...")
        if(fs.exists("script.lua")) then
            os.run({}, "script.lua")
        else
            print("No offline script.")
            error()
        end
    end
else
    print("No script option set.")
    error()
end