print("run programlog \n")

modem = peripheral.wrap("top")
monitor = peripheral.wrap("right")
cX,cY = monitor.getCursorPos()
modem.open(2)

function startEvent()
  event,Sside,sendChan,replyChan,mess,senDis = os.pullEvent()
  handleEvent()
end

function handleEvent()
  if mess == nil then
  
  else
  
	monitor.scroll(-1)
    txt = "run =>"..mess
    monitor.write(txt)
    monitor.setCursorPos(1,cY)   
  end
end


while 1 == 1 do
  startEvent()
end


