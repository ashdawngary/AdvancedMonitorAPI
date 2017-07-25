last_instance = nil -- These are for speed improvements :D
last_mst = nil
last_mstc = nil
last_msbc = nil

function getMonitorInstance(name)
	return peripheral.wrap(name);
end
function createScreen(instance)
	if (instance == nil) then
		print("SoftError: The instance that was provided in args 1 is NIL")
		return nil
	end
	myScreenText = {}
	myScreenTextColor = {}
	myScreenBColor = {}
	myScreenButton = {}
	local length,width = instance.getSize();
	for i = 0,length*width, 1 do
		myScreenText[i] = " "
		myScreenTextColor[i] = colors.white
		myScreenBColor[i] = colors.black
		myScreenButton[i] = false;
	end
	return myScreenText,myScreenTextColor,myScreenBColor
	
end
function getIndex(instance,x,y)
	if (instance == nil) then
		print("SoftError: The instance that was provided in args 1 is NIL")
		return nil
	end
	local length,width = instance.getSize();
	if ((x  > length ) or (x < 1)) then-- For Animation Purposes.
		return -1
	end
	return (y-1)*length + (x-1)
end	
function writeText(instance,myScreenText,myScreenTextColor,myScreenBColor,myScreenButton,x1,y1,text,tColor,bColor)
	print("Writing Text: " .. text .. " to "..x1 .. ","..y1)
	if (instance == nil)then
		print("SoftError: The instance that was provided in args 1 is NIL")
		return nil
	end
	if ((tColor == nil ) or (bColor == nil)) then
		print("SoftError: The <COLOR|INT>Colors that was provided in args 1 is NIL")
		return nil
	end
	x = x1
	charnum = 0
	while (charnum < string.len(text)) do
		magicindex = getIndex(instance,x1+charnum,y1)
		myScreenText[magicindex] = string.sub(text,charnum+1,charnum + 1)
		myScreenTextColor[magicindex] = tColor
		myScreenBColor[magicindex] = bColor
		charnum = charnum + 1
	end
	return myScreenText,myScreenTextColor,myScreenBColor,myScreenButton
end
function drawRect(instance,myScreenText,myScreenTextColor,myScreenBColor,myScreenButton,x1,y1,x2,y2,ncolor,func)
	-- Its ok for func = false;
	for y = y1,y2 do
		for x = x1,x2 do
			myScreenText[getIndex(instance,x,y)] = " "
			myScreenBColor[getIndex(instance,x,y)] = ncolor
			--myScreenButton[getIndex(instance,x,y)] = func
		end
	
	end
	return myScreenText,myScreenTextColor,myScreenBColor,myScreenButton
end
function updateScreen(instance,myScreenText,myScreenTextColor,myScreenBColor)
	if (instance == nil)then
		print("SoftError: The instance that was provided in args 1 is NIL")
		return nil
	end
	if(myScreenText == nil) then
		print("SoftError: The text that was provided in args 2 is NIL")
		return nil
	end
	if(myScreenTextColor == nil) then
		print("SoftError: The <TABLE>TextColor that was provided in args 3 is NIL")
		return nil
	end
	if(myScreenBColor == nil) then
		print("SoftError: The <TABLE>BackgroundColor that was provided in args 4 is NIL")
		return nil
	end
	if (last_instance  == instance) then
		updateScreenv2(instance,myScreenText,myScreenTextColor,myScreenBColor)
		return nil
	end
	instance.setBackgroundColor(colors.black);
	instance.clear()
	local length,width = instance.getSize();
	for y = 1,width do
		for x = 1,length do
			--(cell x,y) is at (y-1)*width + (x-1)
			instance.setCursorPos(x,y)
			instance.setBackgroundColor(myScreenBColor[(y-1)*length + (x-1)])
			instance.setTextColor(myScreenTextColor[(y-1)*length + (x-1)])
			instance.write(myScreenText[(y-1)*length + (x-1)])
			
		end
	end
	last_instance = instance
	last_mst = myScreenText
	last_mstc = myScreenTextColor
	last_msbc = myScreenBColor
end		
function writePixel(instance,myScreenText,myScreenTextColor,myScreenBColor,myScreenButton,x,y,color,bcolor,text)
	if (instance == nil) then
		print("WritePixelSoftError: Instance is nil.")
		return -1
	elseif(myScreenText== nil) then
		print("WritePixelSoftError: MST is nil.")
		return -1
	elseif(x== nil) then
		print("WritePixelSoftError: X(int) is nil.")
		return -1
	elseif(y == nil) then
		print("WritePixelSoftError: Y(int) is nil.")
		return -1
	end
	local length,width = instance.getSize();
	
	if (text == false) then
		myScreenText[getIndex(instance,x,y)] = " "
	else
		myScreenText[getIndex(instance,x,y)] = text
	end
	
	if (bcolor ~= false) then
		myScreenBColor[getIndex(instance,x,y)] = bcolor
	end
	if(color ~= false) then
		myScreenTextColor[getIndex(instance,x,y)]= color
	end
	
	return myScreenText,myScreenTextColor,myScreenBColor,myScreenButton

end
function dumpData(instance,myScreenText,myScreenTextColor,myScreenBColor)
	local length,width = instance.getSize();
	print("Printing Requested Dump ----")
	for i=0,length*width do
		print(myScreenText[i].." "..myScreenTextColor[i].." "..myScreenBColor[i].." "..myScreenButton[i]);
	end
end
function updateScreenv2(instance,myScreenText,myScreenTextColor,myScreenBColor)
	
	--instance.setBackgroundColor(colors.black);
	--instance.clear()
	local edits = 0
	local length,width = instance.getSize();
	for y = 1,width do
		for x = 1,length do
			local magicnumber = (y-1)*length + (x-1)
			local nbc = myScreenBColor[magicnumber]
			local ntc = myScreenTextColor[magicnumber]
			local ntex = myScreenText[magicnumber]
			local obc = last_msbc[magicnumber]
			local otc = last_mstc[magicnumber]
			local otex = last_mst[magicnumber]
			if ((nbc ~= obc) or (ntc ~= otc) or (obc ~= nbc)) then
				edits = edits + 1
			--(cell x,y) is at (y-1)*width + (x-1)
				instance.setCursorPos(x,y)
				instance.setBackgroundColor(nbc)
				instance.setTextColor(ntc)
				instance.write(ntex)
			end
			
		end
	end
	local density = edits/(length * width)
	print("screen update density: "..density)
	last_instance = instance
	last_mst = myScreenText
	last_mstc = myScreenTextColor
	last_msbc = myScreenBColor
end		