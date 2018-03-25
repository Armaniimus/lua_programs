-- arguments needed
--arg1 + or -
--arg2 FileStorageName
--arg3 MonitorSide
--arg4 RedstoneInputSide
--arg5 [OPTIONAL] DbFolderName


local event,param1,param2,param3
local itemCount = 0

-- set Provided Arguments
local arg = { ... }
local op = arg[1]
local StorageFileName = arg[2]
local monitorSide = arg[3]
local redstoneInputSide = arg[4]

--Set the DbFolderName
if arg[5] ~= nil and arg[5] ~= "" then
	dbFileName = arg[5]

else
	dbFileName = "db"
end

-- set working directory to db
if not fs.exists(dbFileName) then
	fs.makeDir(dbFileName)

else
	shell.setDir(dbFileName)
	
end

StorageFileName = dbFileName .. "/" .. StorageFileName

--Set StorageFile 
--or Get data from StorageFile
if not fs.exists(StorageFileName) then
  file = fs.open(StorageFileName,"w")
  file.write(itemCount)
  file.close()

else
  file = fs.open(StorageFileName,"r")
  itemCount = tonumber(file.readLine())
  file.close()
end


-- Set inital Monitor message
monitor = peripheral.wrap(monitorSide)
monitor.clear()
monitor.setCursorPos(1,1)
monitor.write("Items passed: "..itemCount)

--active script
while true do
  event,param1,param2,param3 = os.pullEvent()
  if event == "redstone" then
	
	-- Increment or decrement itemCount
	if rs.getInput(redstoneInputSide) == true then
	
		if op == "+" then
			itemCount = itemCount + 1
		
		elseif op == "-" then
		
			itemCount = itemCount - 1
		end
	  
	end
	-- print to the screen
	monitor.clearLine()
	monitor.setCursorPos(1,1)
	monitor.write("Items passed: " .. itemCount)
	
	--write result back to the file
	file = fs.open(StorageFileName,"w")
	file.write(itemCount)
	file.close()
  end
end