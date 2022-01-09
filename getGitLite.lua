args = {...}
code = http.get("https://raw.githubusercontent.com/Spansos/CCscripts/main/"..args[1])
out = io.open(args[2], "w")
io.output(out)
io.write(code.readAll()) 
io.flush()
code.close()
io.close()