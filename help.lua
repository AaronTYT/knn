--help.lua
local composer = require( "composer" )
local scene = composer.newScene()

--Go to menu.lua
local function home(event)
	if(event.phase == "began") then
		homeButton.xScale = 0.85 
    	homeButton.yScale = 0.85
	else if(event.phase == "ended") then
		homeButton.xScale = 1
    	homeButton.yScale = 1
		composer.gotoScene("menu", {effect="fade", time=500})
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
	
	local text = display.newText("What is KNN?", display.contentCenterX, display.contentCenterY-175, "Arial", 30)
	text:setFillColor(1, 0, 0)
	sceneGroup:insert(text)
	
	homeButton = display.newImageRect("home.png", 40, 40)
	homeButton.x = display.contentCenterX - 120
	homeButton.y = 0
	
	sceneGroup:insert(homeButton)
	homeButton:addEventListener("touch", home)
	
	--Descriptions display manually
	local description = display.newText("KNN stands for k-Nearest Neighbours.",  display.contentCenterX, display.contentCenterY-125, "Arial", 15)
	sceneGroup:insert(description)
	
	local description2 = display.newText("A machine learning algorihtm",  display.contentCenterX, display.contentCenterY-105, "Arial", 15)
	sceneGroup:insert(description2)
	
	local description3 = display.newText("to find out which dot belongs to which class",  display.contentCenterX, display.contentCenterY-90, "Arial", 15)
	sceneGroup:insert(description3)
	
	local description4 = display.newText("A classic example shown below: ",  display.contentCenterX, display.contentCenterY-70, "Arial", 15)
	sceneGroup:insert(description4)
	
	local image = display.newImageRect("knn.png", 230, 230)
	image.x = 170
	image.y = 325
	sceneGroup:insert(image)	
end
scene:addEventListener( "create", scene )
return scene