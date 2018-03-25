-- arguments needed

--arg1 MonitorSide
--arg2 RedstoneInputSide
--arg3 modemSide

--arg4 modem receiveChannel
--arg5 modem sendChannel

--arg7 localItem
--arg7 FileStorageName
--arg8 [OPTIONAL] DbFolderName


local event,side,sendChan,replyChan,message,senDis
local itemCount = 0

-- set Provided Arguments
local arg = { ... }

--peripheral sides
local monitor = peripheral.wrap(arg[1])
local bundleInput = redstone.getBundledInput(arg[2])
local modem = peripheral.wrap(arg[3])

--set modem send and receivechannels
local receiveChannel = tonumber(arg[4]) 
local sendChannel = tonumber(arg[5]) 

--set names
local localItem = arg [6]
local StorageFileName = arg[7]
local dbFileName = arg[8]

--Set the DbFolderName
if dbFileName ~= nil and dbFileName ~= "" then
	--Stay the same

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
monitor.clear()
monitor.setCursorPos(1,1)
monitor.write(localItem .. " Count: " .. itemCount)

--open ModemConnection
modem.open(receiveChannel)


while true do
	event,side,sendChan,replyChan,message,senDis = os.pullEvent()
	
	--Check for redstone Signal and handle increment or decrement
	if event == "redstone" then
		
		-- test for incrementColor
		if(colors.test (bundleInput, colors.black) ) then
			itemCount = itemCount + 1
		end
		
		-- test for decrementColor
		if (colors.test (bundleInput, colors.red) ) then
			itemCount = itemCount - 1	  
		end
		
		
		-- print to the screen
		monitor.clearLine()
		monitor.setCursorPos(1,1)
		monitor.write(localItem .. "Count = " .. itemCount)
		
		--write result back to the file
		file = fs.open(StorageFileName, "w")
		file.write(itemCount)
		file.close()
	
	
	end
	
	--Handle ModemMessage
	if message == nil then
  
	elseif (message == localItem) then
		file = fs.open(StorageFileName,"r")
		Amount = tonumber(file.readLine())
		file.close()
		
		message = Amount .. " " .. localItem 
		
		--message
		modem.transmit(sendChannel, receiveChannel, message)
	
	elseif (message == localItem .. "-nr") then
		file = fs.open(StorageFileName,"r")
		Amount = tonumber(file.readLine())
		file.close()
		
		message = Amount 
		
		--message
		modem.transmit(sendChannel, receiveChannel, message)
	end
	
	
	
end