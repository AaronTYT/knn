--menu.lua (main)
local composer = require( "composer" )
local scene = composer.newScene()

--Go to knn.lua to use the KNN app
local function gotoKnn(event)
	if(event.phase == "began") then
		goButton.xScale = 0.85 
    	goButton.yScale = 0.85
	else if(event.phase == "ended") then
		goButton.xScale = 1
    	goButton.yScale = 1
		composer.gotoScene("knn", {effect="fade", time=500})
	else if(event.phase == "cancelled") then
		--do nothing
	end
	end
	end
end

--Go to help.lua if the user wants to understand how knn works
local function gotoHelp(event)
	if(event.phase == "began") then
		helpButton.xScale = 0.85 
    	helpButton.yScale = 0.85
	else if(event.phase == "ended") then
		helpButton.xScale = 1
    	helpButton.yScale = 1
		composer.gotoScene("help", {effect="fade", time=500})
	else if(event.phase == "cancelled") then
		--do nothing
	end
	end
	end
end

--Exit out the program
local function exitProgram(event)
	if(event.phase == "began") then
		exitButton.xScale = 0.85 
    	exitButton.yScale = 0.85
	else if(event.phase == "ended") then
		exitButton.xScale = 1
    	exitButton.yScale = 1
		if system.getInfo("platformName")=="Android" then
        native.requestExit()
		else
			os.exit() 
		end
	else if(event.phase == "cancelled") then
		--do nothing
	end
	end
	end
end

local red = 60/255
local blue = 179/255
local green = 113/255

--Start here
function scene:create( event )
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Assign "self.view" to local variable "sceneGroup" for easy reference
    local sceneGroup = self.view
	local bg = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
	
	--rgb not in 255 format, in a 0 to 1 format eg red is (1, 0, 0) not (255, 0, 0)
	bg:setFillColor(red, blue, green)
	sceneGroup:insert(bg)
	
	local text = display.newText("KNN Algorithm App", display.contentCenterX, display.contentCenterY-175, "", 30)
	text:setFillColor(1, 0, 0)
	sceneGroup:insert(text)
	
	local image = display.newImageRect("knn2.png", 180, 110)
	image.x = display.contentCenterX
	image.y = display.contentCenterY - 100
	sceneGroup:insert(image)
	
	--Display go, help and exit buttons
	local widget = require("widget")
	goButton = widget.newButton({label="Go", shape="roundedRect", width = 200, height = 40, cornerRadius = 20})
	goButton.x = display.contentCenterX
	goButton.y = display.contentCenterY - 20
	sceneGroup:insert(goButton)
	goButton:addEventListener("touch", gotoKnn)
	
	helpButton = widget.newButton({label="Help", shape="roundedRect", width = 200, height = 40, cornerRadius = 20, onEvent=gotoHelp})
	helpButton.x = display.contentCenterX
	helpButton.y = display.contentCenterY + 60
	sceneGroup:insert(helpButton)
	
	exitButton = widget.newButton({label="Exit", shape="roundedRect", width = 125, height = 40, cornerRadius = 20, onEvent=exitProgram})
	exitButton.x = display.contentCenterX
	exitButton.y = display.contentCenterY + 180
	exitButton:addEventListener("tap", exitProgram)
	sceneGroup:insert(exitButton)
end
scene:addEventListener( "create", scene )
return scene