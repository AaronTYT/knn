--knn.lua
local composer = require( "composer" )
local scene = composer.newScene()

--Go back to menu.lua
function goToMenu(event)
	if(event.phase == "began") then
		homeButton.xScale = 0.85 
    	homeButton.yScale = 0.85
	else if(event.phase == "ended") then
		homeButton.xScale = 1
    	homeButton.yScale = 1
		
		--Remove texts and go back to the menu.lua screen
		anslbl.text = ""
		circleXlbl.text = ""
		circleYlbl.text = ""
		composer.gotoScene("menu", {effect="fade", time=500})
	else if(event.phase == "cancelled") then
		--do nothing
	end
	end
	end
end

--Color rgb for a type of green
local red = 60/255
local blue = 179/255
local green = 113/255

--Dataset for class A and B
a = {
	{x = 4, y = 3},
	{x = 1, y = 3},
	{x = 3, y = 3},
	{x = 3, y = 7},
	{x = 7, y = 4},
	{x = 4, y = 1},
	{x = 6, y = 5},
	{x = 5, y = 6},
	{x = 3, y = 7},
	{x = 6, y = 2}
}
b = {
	{x = 1, y = 1},
	{x = 2, y = 2},
	{x = 3, y = 3},
	{x = 4, y = 4},
	{x = 5, y = 5},
	{x = 6, y = 6},
	{x = 7, y = 7},
	{x = 8, y = 8},
	{x = 9, y = 9},
	{x = 10, y = 10},
	{x = 0, y = 0},
	{x = 8, y = 10},
	{x = 6, y = 10},
	{x = 7, y = 10},
	{x = 8, y = 10},
}

--Actual dots coordinates from the screen
circleX = {}
circleY = {}

--euclidean distances from white dot to their assigned class tables
distanceA = {}
distanceB = {}

--distance formulas
--Reference: https://dataaspirant.com/2015/04/11/five-most-popular-similarity-measures-implementation-in-python/
local function euclideanDistance(coordinateX, coordinateY)
	print("math.sqrt(("..circleX[1].."-"..coordinateX..") ^2 + ("..circleY[1].."-"..coordinateY..") ^ 2)")
	distance = math.sqrt((circleX[1] - coordinateX) ^ 2 + (circleY[1] - coordinateY) ^ 2)
	return distance
end

local function manhattanDistance(coordinateX, coordinateY)
	distance = coordinateX - circleX[1] + coordinateY - circleY[1]
	return math.abs(distance)
end

local function cosineSimilarity(coordinateX, coordinateY)
	distance = math.sqrt((coordinateX * circleX[1])+ (coordinateY * circleY[1]))
	return distance
end

local function chebyshevDistance(coordinateX, coordinateY)
	ans = math.max(circleX[1] - coordinateX, circleY[1] - coordinateY)
	return math.abs(ans)
end

--get class result function
local function getResults(k)
	countA = 0
	countB = 0
	
	print("Distances sortted")
	for i = 1, #distanceA do
		print("A: "..distanceA[i])
	end
	
	print("")
	
	for i = 1, #distanceB do
		print("B: "..distanceB[i])
	end
	--[[Compare distanceA and distanceB tables
		to check the smallest distance value
	]]
	c = 1
	for i = 1, k do
		--If distanceA's item is less then distanceB's item that add countA
		if distanceA[i] < distanceB[c] then
			countA = countA + 1
			print("A counts " .. countA)
			c = 1
		--If distanceB's item is less then distanceA's item that add countB
		else if(distanceA[i] > distanceB[c]) then	
			countB = countB + 1
			c = c + 1
			print("B counts "..countB)
		end
		end
	end
	
	--Return the class result based on the count value
	if countA > countB then
		return "A"
	else 
		return "B"
	end
end

k = 0
local function validation()
	--If the user does not put anything in the k value box then make k = 0
	k = tonumber(kTxt.text)
	if(k == nil) then
		k = 0
	end
	
	--If the user makes the k value more then 5 then display an error message
	if k > 5 then
		local alert = native.showAlert( "Error", "K value must be less then 6 ")
		return 1
	
	--If the user makes the k value 0 then display an error message
	else if k == 0 then
		local alert = native.showAlert( "Error", "K value cannot be empty or 0 ")
		return 1
	end
	end
end

local function knnButtonListener(event)
	if(event.phase == "began") then
		--do nothing until the user released the button then do something
	else if("ended" == event.phase) then
		--Once the user clicks on find class button
		--Find the class code shown below
		if(validation() == 1) then
			--Do not proceed the next block of code of the k value is either 0, nil or more then 5
		else
			--If the user does not place the white dot in the green area (from the start of the program) then
			--shows an error message
			if(circleX[1] ==  nil and circleY[1] == nil) then
				local alert = native.showAlert( "Error", "Please place your white dot somewhere")
			else
				--Display metric results in the console line
				print("Distance/metric results")
				print("Circle X's actual coordinate: ".. circleX[1])
				print("Circle Y's: actual coordinate " .. circleY[1])
				print("A distances from white dot:")
				for i = 1, #a do
					print("Red dot #"..i)
					dE = euclideanDistance(a[i]["x"], a[i]["y"])
					print("Euclidean distance: "..dE.."\n")
					table.insert(distanceA, dE)	
				end
				
				print("")
				
				print("Circle X's actual coordinate: ".. circleX[1])
				print("Circle Y's: actual coordinate " .. circleY[1])
				print("B distances:")
				for i = 1, #b do
					print("Blue dot #"..i)
					dE = euclideanDistance(b[i]["x"], b[i]["y"])
					print("Euclidean distance: "..dE.."\n")
					table.insert(distanceB, dE)
				end
				--End displaying metric results in the console line
				
				table.sort(distanceA)
				table.sort(distanceB)
				
				ansClass = getResults(k)
				
				--Checking what command needs to do if ansClass has been resulted
				if anslbl.text == "Its belongs to class A" and ansClass == "B" then
					anslbl.text = "Its belongs to class B"
					anslbl:setFillColor(0, 0, 1)
				else if anslbl.text == "Its belongs to class B" and ansClass == "A" then
					anslbl.text = "Its belongs to class A"
					anslbl:setFillColor(1, 0, 0)
				else
					if ansClass == "A" then
						anslbl.text = "Its belongs to class A"
						anslbl:setFillColor(1, 0, 0)
					else if ansClass == "B" then
						anslbl.text = "Its belongs to class B"
						anslbl:setFillColor(0, 0, 1)
					end
					end
				end
				end
				
				--[[clear all distanceA and distanceB data once it has been executed
				Since the user has to replace the white dot and new distance data
				must be rerecorded again--]]
				for i = 1, #distanceA do
					distanceA[i] = nil
				end
				
				for i = 1, #distanceB do
					distanceB[i] = nil
				end
			end
		end
	end
	end
end

local function mListener(event)
	if(event.phase == "began") then
		--do nothing until the user released the button then do something
	else if("ended" == event.phase) then
		--Once the user clicks on find class button
		--Find the class code shown below
		if(validation() == 1) then
			--Do not proceed the next block of code of the k value is either 0, nil or more then 5
		else
			--If the user does not place the white dot in the green area (from the start of the program) then
			--shows an error message
			if(circleX[1] ==  nil and circleY[1] == nil) then
				local alert = native.showAlert( "Error", "Please place your white dot somewhere")
			else
				--Display metric results in the console line
				print("Distance/metric results")
				print("Circle X's actual coordinate: ".. circleX[1])
				print("Circle Y's: actual coordinate " .. circleY[1])
				print("A distances from white dot:")
				for i = 1, #a do
					print("Red dot #"..i)
					dM = manhattanDistance(a[i]["x"], a[i]["y"])
					print("Manhattan distance: "..dM.."\n")
					table.insert(distanceA, dM)	
				end
				
				print("")
				
				print("Circle X's actual coordinate: ".. circleX[1])
				print("Circle Y's: actual coordinate " .. circleY[1])
				print("B distances:")
				for i = 1, #b do
					print("Blue dot #"..i)
					dM = manhattanDistance(b[i]["x"], b[i]["y"])
					print("Manhattan distance: "..dM.."\n")
					table.insert(distanceB, dM)
				end
				--End displaying metric results in the console line
				
				table.sort(distanceA)
				table.sort(distanceB)
				
				ansClass = getResults(k)
				
				--Checking what command needs to do if ansClass has been resulted
				if anslbl.text == "Its belongs to class A" and ansClass == "B" then
					anslbl.text = "Its belongs to class B"
					anslbl:setFillColor(0, 0, 1)
				else if anslbl.text == "Its belongs to class B" and ansClass == "A" then
					anslbl.text = "Its belongs to class A"
					anslbl:setFillColor(1, 0, 0)
				else
					if ansClass == "A" then
						anslbl.text = "Its belongs to class A"
						anslbl:setFillColor(1, 0, 0)
					else if ansClass == "B" then
						anslbl.text = "Its belongs to class B"
						anslbl:setFillColor(0, 0, 1)
					end
					end
				end
				end
				
				--[[clear all distanceA and distanceB data once it has been executed
				Since the user has to replace the white dot and new distance data
				must be rerecorded again--]]
				for i = 1, #distanceA do
					distanceA[i] = nil
				end
				
				for i = 1, #distanceB do
					distanceB[i] = nil
				end
			end
		end
	end
	end
end

local function csListener(event)
	if(event.phase == "began") then
		--do nothing until the user released the button then do something
	else if("ended" == event.phase) then
		--Once the user clicks on find class button
		--Find the class code shown below
		if(validation() == 1) then
			--Do not proceed the next block of code of the k value is either 0, nil or more then 5
		else
			--If the user does not place the white dot in the green area (from the start of the program) then
			--shows an error message
			if(circleX[1] ==  nil and circleY[1] == nil) then
				local alert = native.showAlert( "Error", "Please place your white dot somewhere")
			else
				--Display metric results in the console line
				print("Distance/metric results")
				print("Circle X's actual coordinate: ".. circleX[1])
				print("Circle Y's: actual coordinate " .. circleY[1])
				print("A distances from white dot:")
				for i = 1, #a do
					print("Red dot #"..i)
					dCS = cosineSimilarity(a[i]["x"], a[i]["y"])
					print("Cosine Similarity distance: "..dCS.."\n")
					table.insert(distanceA, dCS)	
				end
				
				print("")
				
				print("Circle X's actual coordinate: ".. circleX[1])
				print("Circle Y's: actual coordinate " .. circleY[1])
				print("B distances:")
				for i = 1, #b do
					print("Blue dot #"..i)
					dCS = cosineSimilarity(b[i]["x"], b[i]["y"])
					print("Cosine Similarity distance: "..dCS.."\n")
					table.insert(distanceB, dCS)
				end
				--End displaying metric results in the console line
				
				table.sort(distanceA)
				table.sort(distanceB)
				
				ansClass = getResults(k)
				
				--Checking what command needs to do if ansClass has been resulted
				if anslbl.text == "Its belongs to class A" and ansClass == "B" then
					anslbl.text = "Its belongs to class B"
					anslbl:setFillColor(0, 0, 1)
				else if anslbl.text == "Its belongs to class B" and ansClass == "A" then
					anslbl.text = "Its belongs to class A"
					anslbl:setFillColor(1, 0, 0)
				else
					if ansClass == "A" then
						anslbl.text = "Its belongs to class A"
						anslbl:setFillColor(1, 0, 0)
					else if ansClass == "B" then
						anslbl.text = "Its belongs to class B"
						anslbl:setFillColor(0, 0, 1)
					end
					end
				end
				end
				
				--[[clear all distanceA and distanceB data once it has been executed
				Since the user has to replace the white dot and new distance data
				must be rerecorded again--]]
				for i = 1, #distanceA do
					distanceA[i] = nil
				end
				
				for i = 1, #distanceB do
					distanceB[i] = nil
				end
			end
		end
	end
	end
end


local function cListener(event)
	if(event.phase == "began") then
		--do nothing until the user released the button then do something
	else if("ended" == event.phase) then
		--Once the user clicks on find class button
		--Find the class code shown below
		if(validation() == 1) then
			--Do not proceed the next block of code of the k value is either 0, nil or more then 5
		else
			--If the user does not place the white dot in the green area (from the start of the program) then
			--shows an error message
			if(circleX[1] ==  nil and circleY[1] == nil) then
				local alert = native.showAlert( "Error", "Please place your white dot somewhere")
			else
				--Display metric results in the console line
				print("Distance/metric results")
				print("Circle X's actual coordinate: ".. circleX[1])
				print("Circle Y's: actual coordinate " .. circleY[1])
				print("A distances from white dot:")
				for i = 1, #a do
					print("Red dot #"..i)
					dc = chebyshevDistance(a[i]["x"], b[i]["y"])
					print("Chebyshev Distance distance: "..dc.."\n")
					table.insert(distanceA, dc)	
				end
				
				print("")
				
				print("Circle X's actual coordinate: ".. circleX[1])
				print("Circle Y's: actual coordinate " .. circleY[1])
				print("B distances:")
				for i = 1, #b do
					print("Blue dot #"..i)
					dc = chebyshevDistance(b[i]["x"], b[i]["y"])
					print("Chebyshev Distance: "..dc.."\n")
					table.insert(distanceB, dc)
				end
				--End displaying metric results in the console line
				
				table.sort(distanceA)
				table.sort(distanceB)
				
				ansClass = getResults(k)
				
				--Checking what command needs to do if ansClass has been resulted
				if anslbl.text == "Its belongs to class A" and ansClass == "B" then
					anslbl.text = "Its belongs to class B"
					anslbl:setFillColor(0, 0, 1)
				else if anslbl.text == "Its belongs to class B" and ansClass == "A" then
					anslbl.text = "Its belongs to class A"
					anslbl:setFillColor(1, 0, 0)
				else
					if ansClass == "A" then
						anslbl.text = "Its belongs to class A"
						anslbl:setFillColor(1, 0, 0)
					else if ansClass == "B" then
						anslbl.text = "Its belongs to class B"
						anslbl:setFillColor(0, 0, 1)
					end
					end
				end
				end
				
				--[[clear all distanceA and distanceB data once it has been executed
				Since the user has to replace the white dot and new distance data
				must be rerecorded again--]]
				for i = 1, #distanceA do
					distanceA[i] = nil
				end
				
				for i = 1, #distanceB do
					distanceB[i] = nil
				end
			end
		end
	end
	end
end

--Create the knn.lua scene
function scene:create( event )
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Assign "self.view" to local variable "sceneGroup" for easy reference
    local sceneGroup = self.view
	
	--Display labels and other stuff for presentation layout
	local text = display.newText("KNN", display.contentCenterX, display.contentCenterY-250, "Arial", 40)
	sceneGroup:insert(text)
	
	homeButton = display.newImageRect("home.png", 40, 40)
	homeButton.x = display.contentCenterX - 120
	homeButton.y = 0
	
	sceneGroup:insert(homeButton)
	homeButton:addEventListener("touch", goToMenu)
	
	local classAlbl = display.newText("Class A", display.contentCenterX, display.contentCenterY-200, "Arial", 20)
	local classBlbl = display.newText("Class B", display.contentCenterX, display.contentCenterY-175, "Arial", 20)
	
	redCircle = display.newCircle(display.contentCenterX + 50, display.contentCenterY-200, 5)
	redCircle:setFillColor(1, 0, 0)
	sceneGroup:insert(redCircle)
	
	blueCircle = display.newCircle(display.contentCenterX + 50, display.contentCenterY-175, 5)
	blueCircle:setFillColor(0, 0, 1)
	sceneGroup:insert(blueCircle)
	
	classAlbl:setFillColor(1, 0, 0)
	classBlbl:setFillColor(0, 0, 1)
	sceneGroup:insert(classAlbl)
	sceneGroup:insert(classBlbl)
	
	--Manhattan
	local widget = require("widget")
	local mButton = widget.newButton
	{
		id = "mButton",
		label = "M",
		shape= "roundedRect",
		onEvent = mListener,
		width = 50, 
		height = 25, 
		cornerRadius = 20
	}
	mButton.x = display.contentCenterX + 110
	mButton.y = 0
	
	sceneGroup:insert(mButton)
	mButton:addEventListener("touch")
	
	--Cosine Similarity
	local csButton = widget.newButton
	{
		id = "csButton",
		label = "CS",
		shape= "roundedRect",
		onEvent = csListener,
		width = 50, 
		height = 25, 
		cornerRadius = 20
	}
	
	csButton.x = display.contentCenterX + 110
	csButton.y = 30
	
	sceneGroup:insert(csButton)
	csButton:addEventListener("touch")
	
	--Chebyshev
	local cButton = widget.newButton
	{
		id = "cButton",
		label = "C",
		shape= "roundedRect",
		onEvent = cListener,
		width = 50, 
		height = 25, 
		cornerRadius = 20
	}
	cButton.x = display.contentCenterX + 110
	cButton.y = 60
	
	sceneGroup:insert(cButton)
	cButton:addEventListener("touch")
	
	--Answer class
	anslbl = display.newText("", display.contentCenterX, display.contentCenterY -150, "Arial", 15)

	x = "nil"
	circleXlbl = display.newText("x: "..x, display.contentCenterX-20, display.contentCenterY-120, "Arial", 15)
	y = "nil"
	circleYlbl = display.newText("y: "..y, display.contentCenterX+20, display.contentCenterY-120, "Arial", 15)
	
	local klbl = display.newText("K=", display.contentCenterX-20, display.contentCenterY + 210, "Arial", 25)
	sceneGroup:insert(klbl)
	
	size = 35
	kTxt = native.newTextField(display.contentCenterX+15, display.contentCenterY + 210, size, size)
	kTxt.inputType = "number"
	
	local knnButton = widget.newButton
	{
		id = "knnButton",
		label = "Find class",
		shape= "roundedRect",
		onEvent = knnButtonListener,
		width = 150, 
		height = 30, 
		cornerRadius = 20
	}
	knnButton.x = display.contentCenterX
	knnButton.y = display.contentCenterY + 250
	
	sceneGroup:insert(knnButton)
	knnButton:addEventListener("touch")
	
	--Define a background image(a grid picture) to move the object throughout the screen
	local image = display.newImageRect("background.png", 230, 230)
	image.x = 160
	image.y = 280
	image.xScale = 1.3;image.yScale = 1.3
	sceneGroup:insert(image)
	
	--[[make an invisible box to prevent the user from
	placing the white dot outside the grid
	]]--
	local invisibleBox = display.newRect(168,285,251,251)
	invisibleBox.strokeWidth = 3
	invisibleBox:setStrokeColor(0, 0, 0)
	invisibleBox.alpha = 0.01
	sceneGroup:insert(invisibleBox)
	
	--Display dots
	
	for i = 1, #a do
		--Adjust coordinates to spread and even the screen
		ax = a[i]["x"] * 200 / 8 - 116
		ay = a[i]["y"] * 200 / 8 - 80
		
		aCircle = display.newCircle(display.contentCenterX + ax, display.contentCenterY + ay, 5)
		aCircle:setFillColor(1, 0, 0)
		
		sceneGroup:insert(aCircle)
		
	end 
	
	for i = 1, #b do
		--Adjust coordinates to spread and even the screen
		bx = b[i]["x"] * 200 / 8 - 116
		by = b[i]["y"] * 200 / 8 - 80
		
		print(by)
		bCircle = display.newCircle(display.contentCenterX + bx, display.contentCenterY + by, 5)
		bCircle:setFillColor(0, 0, 1)
		sceneGroup:insert(bCircle)
	end 
	
	-- Define a circle object (white dot for the user) to allow movement within an invisible box
	local circleObj = display.newCircle(display.contentCenterX, display.contentCenterY, 10 )      
	circleObj:setFillColor(1, 1, 1) -- fill the circle with color	 
	circleObj.strokeWidth = 4 -- Sets the width of the border of circle
	circleObj:setStrokeColor(0, 0, 0) -- Sets the border color
	sceneGroup:insert(circleObj);
	
	--Function that move the circle
	function moveCircle(event)   
		 -- Set the cordinates of the circle
		circleObj.x,  circleObj.y =  event.x, event.y
		
		--Scale the actual x and actual y for the white dot to display the scaled x and y shown on the grid
		--Make the user easier to compare the x and y coordinate to the grid we provided.
		displayCX = math.round(circleObj.x / 25 - 1.5)
		displayCY = math.round(circleObj.y / 25 - 6)
		
		--Checking if the length of circleX table is none then insert the actual X of the white dot's x coordinate to the circleX table
		if #circleX == 0 then
			table.insert(circleX, displayCX)
		else
			--removes the exisiting data from circleX since the circleObj.x obtained a new x coordinate in order to update it.
			table.remove(circleX, 1)
			table.insert(circleX, displayCX)
		end
		
		--Checking if the length of circleY table is none then insert the actual Y of the white dot's y coordinate to the circleY table
		if #circleY == 0 then
			table.insert(circleY, displayCY)
		else
			--removes the exisiting data from circleY since the circleObj.y obtained a new y coordinate in order to update it.
			table.remove(circleY, 1)
			table.insert(circleY, displayCY)
		end
		
		--Display scaled x and y coordinates to the screen every time the user wants to move the white circle
		circleXlbl.text = "x: "..string.format("%u",displayCX)
		circleYlbl.text = "y: "..string.format("%u",displayCY)	 
		return true
	end
	 
	--Touch event that will fired when the user touch the screen (in a invisiblebox)
	invisibleBox:addEventListener("touch",  moveCircle)
end
scene:addEventListener( "create", scene )
return scene