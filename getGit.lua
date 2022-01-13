print(http.get("https://raw.githubusercontent.com/Spansos/CCscripts/main/scripts/" .. script).readAll())
print("Checking settings...")
if(fs.exists("/.settings")) then
    print("Reading settings.txt...")
    script = settings.get("script")
    print("Checking if script can be found on GitHub...")
    if(http.checkURL(string.format("https://raw.githubusercontent.com/Spansos/CCscripts/main/scripts/%s", script))) then
        print("Downloading script...")
        in_file = http.get("https://raw.githubusercontent.com/Spansos/CCscripts/main/scripts/" .. script)
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
    print("No file for options")
    error()
end