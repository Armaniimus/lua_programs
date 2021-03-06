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
local redstoneSide = arg[2]
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
	
	file = fs.open(StorageFileName, "r")
	itemCount = tonumber(file.readLine())
	file.close()
	
	--Check for redstone Signal and handle increment or decrement
	if event == "redstone" then
		
		--Handle RedstoneReader
		redstoneInput = redstone.getBundledInput(redstoneSide)
	
		-- test for incrementColor And decrementColor
		if(
			colors.test (redstoneInput, colors.black) and 
			colors.test (redstoneInput, colors.red)
		) then
			-- do Nothing
		
		-- test for incrementColor
		elseif(colors.test (redstoneInput, colors.black) ) then
			itemCount = itemCount + 1
		
		-- test for decrementColor
		elseif (colors.test (redstoneInput, colors.red) ) then
			itemCount = itemCount - 1
		
		--test for 64incrementColor And 64decrementColor
		elseif(
			colors.test (redstoneInput, colors.green) and 
			colors.test (redstoneInput, colors.orange)
		)then
		
		-- test for increment64Color
		elseif(colors.test (redstoneInput, colors.green) ) then
			itemCount = itemCount + 64
		
		-- test for decrement64Color
		elseif (colors.test (redstoneInput, colors.orange) ) then
			itemCount = itemCount - 64
		end

	--Handle ModemMessage
	elseif (message ~= nil) then
		no_error, varReturn = pcall(myModemEvent, message, monitor, modem, sendChannel, receiveChannel, StorageFileName, localItem, itemCount)
		
		if not no_error then
			print("function call Failed")
			print(varReturn)
			print()
		else
			itemCount = varReturn
		end
	end 
	
	
	--myModemReader
	function myModemEvent(message, monitor, modem, sendChannel, receiveChannel, StorageFileName, localItem, itemCount)
		
		if message == nil then
		
		elseif message ~= nil then
			message = textutils.unserialize(message)
		
			if (message[1] == nil ) then
			
			elseif (message[1] == localItem) then

				--get
				if (message[2] == "-get") then
					
					
					message = itemCount 
					modem.transmit(sendChannel, receiveChannel, message)
				
				--reset
				elseif (message[2] == "-reset") then
					
					itemCount = 0		
					message = localItem .. " Count reset" 
					modem.transmit(sendChannel, receiveChannel, message)			
				
				-- set				
				elseif ( 
					message[2] == "-set" and
					message[3] ~= nil
				)  then
				
					itemCount = message[3]			
					message = localItem .. " Count set to " .. itemCount
					
					modem.transmit(sendChannel, receiveChannel, message)
				
				--get itemCount + itemname
				else 
					message = itemCount .. " " .. localItem 
					modem.transmit(sendChannel, receiveChannel, message)
				end
				
				return itemCount
			end
		end
	end
	
	
	-- print to the screen
	monitor.clearLine()
	monitor.setCursorPos(1,1)
	monitor.write(localItem .. "Count = " .. itemCount)
	
	--write result back to the file
	file = fs.open(StorageFileName, "w")
	file.write(itemCount)
	file.close()
	
	--set localMemory right
	file = fs.open(StorageFileName,"r")
	itemCount = tonumber(file.readLine())
	file.close()
end