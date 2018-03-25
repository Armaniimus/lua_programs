print("run DistantFunctionCall \n")

--wrap peripherals
modem = peripheral.wrap("top")
modem.open(1)


--eventListenerFunction
function startEvent()
  event,side,sendChan,replyChan,message,senDis = os.pullEvent()
  handleEvent()
end

--HandleFunction 
-- message needs to be a function name thats available on this computer
function handleEvent()
  if message == nil then
  
  else
    shell.run(message)
    modem.transmit(replyChan,sendChan,message)
  end
end

-- starts the EventListener and restarts it after first message is received
while 1 == 1 do
  startEvent()
end
