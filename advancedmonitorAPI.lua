function getMonitorInstance(name)
	return peripheral.wrap(name);
end
function createScreen(instance)
	myScreenText = {}
	myScreenTextColor = {}
	myScreenBColor = {}
	myScreenButton = {}
	local length,width = instance.getSize();
	for i = 0,length*width, 1 do
		myScreenText[i] = " "
		myScreenTextColor[i] = colors.white
		myScreenBColor[i] = colors.black
		myScreenButton[i] = 
	end
	return myScreenText,myScreenTextColor,myScreenBColor
	
end
function getIndex(instance,x,y)
	local length,width = instance.getSize();
	return (y-1)*length + (x-1)
end	
function drawRect(instance,myScreenText,myScreenTextColor,myScreenBColor,myScreenButton,x1,y1,x2,y2,ncolor,func)
	-- Its ok for func = false;
	for y = y1,y2 do
		for x = x1,x2 do
			myScreenText[getIndex(instance,x,y)] = " "
			myScreenBColor[getIndex(instance,x,y)] = ncolor
			myScreenButton[getIndex(instance,x,y)] = func
		end
	
	end
	return myScreenText,myScreenTextColor,myScreenBColor,myScreenButton
end
function updateScreen(instance,myScreenText,myScreenTextColor,myScreenBColor)
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
end
			
function writePixel(instance,myScreenText,myScreenTextColor,myScreenBColor,x,y,color,bcolor,text)

	local length,width = instance.getSize();
	if (text == false) then
		myScreenText[(y-1)*length + (x-1)] = " "
	else
		myScreenText[(y-1)*length+(x-1)] = text
	end
	
	if (bcolor ~= false) then
		myScreenBColor[(y-1)*length +(x-1)] = bcolor
	end
	if(color ~= false) then
		myScreenTextColor[(y-1)*length + (x-1)]= color
	end
	
	return myScreenText,myScreenTextColor,myScreenBColor

end