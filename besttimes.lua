local composer = require("composer")
local scene = composer.newScene()
local json = require("json")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables
local scoresTable = {}
local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)

local function loadScores()
    local file = io.open(filePath, "r")

    if file then
        local contents = file:read("*a")
        io.close(file)
        scoresTable = json.decode(contents)
    end

    if (scoresTable == nil or #scoresTable == 0) then
        scoresTable = { }
    end
end

local function saveScores()
    for i = #scoresTable, 11, -1 do
        table.remove(scoresTable, i)
    end

    local file = io.open(filePath, "w")

    if file then
        file:write(json.encode(scoresTable))
        io.close(file)
    end
end

local function gotoMenu()
    composer.gotoScene("menu", {time=800, effect="crossFade"})
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

    -- Load the previous scores
    loadScores()

    -- Insert the saved score from the last game into the table, then reset it
    local finalTime = composer.getVariable("finalTime")
    if (finalTime ~= nil) then
        table.insert(scoresTable, finalTime)
    end
    composer.setVariable("finalTime", nil)

    -- Sort the table entries from lowest to highest
    local function compare( a, b )
        return a < b
    end

    table.sort(scoresTable, compare)

    -- Save the scores
    saveScores()

    local header = display.newText(sceneGroup, "Best times", display.contentCenterX, 100, native.systemFont, 44)

    for i=1, #scoresTable do
        local yPos = 150 + ((#scoresTable - i + 1) * 56)

        local rankNum = display.newText(sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 36)
        rankNum:setFillColor(0.8)
        rankNum.anchorX = 1

        local thisScore = display.newText(sceneGroup, scoresTable[i], display.contentCenterX-30, yPos, native.systemFont, 36)
        thisScore.anchorX = 0
    end

    local menuButton = display.newText(sceneGroup, "Menu", display.contentCenterX, 810, native.systemFont, 44)
    menuButton:setFillColor(0.75, 0.78, 1)
    menuButton:addEventListener("tap", gotoMenu)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide(event)

	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		-- Code here runs when the scene is on screen (but is about to go off screen)
	elseif (phase == "did") then
		-- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("besttimes")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene