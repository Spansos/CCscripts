print("Getting script settings...")
script = settings.get("script", false)
if not script then
    print("No script option set.")
    error()
end
    
print("Downloading from GitHub...")
in_file = http.get("https://raw.githubusercontent.com/Spansos/CCscripts/main/"..script)
if not in_file then
    print("Script can't be found.")
    print("Trying possibly older version...")
    if not fs.exists("script.lua") then
        print("No offline script.")
        error()
    end
    shell.run("script.lua")
end
        
print("Writing script...")
out_file = io.open("script.lua", "w")
io.output(out_file)
io.write(in_file.readAll())
io.flush()
io.close(out_file)
in_file.close()
print("Running script...")
os.run({}, "script.lua")
