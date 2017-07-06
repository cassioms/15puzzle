local composer = require("composer")
local bgLoader = require("scripts.background")
local defaults = require("scripts.defaults")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
    composer.gotoScene("scripts.game", {time=800, effect="crossFade"})
end

local function gotoBestTimes()
    composer.gotoScene("scripts.besttimes", {time=800, effect="crossFade"})
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

    bgLoader.loadBackground(sceneGroup)

    local title = display.newText(sceneGroup, "15 puzzle", display.contentCenterX, 200, native.systemFont, defaults.font.size)
    title:setFillColor(defaults.font.color.red, defaults.font.color.green, defaults.font.color.blue)

    local playButton = display.newText(sceneGroup, "Play", display.contentCenterX, 700, native.systemFont, defaults.font.size)
    playButton:setFillColor(defaults.font.color.red, defaults.font.color.green, defaults.font.color.blue)

    local highScoresButton = display.newText(sceneGroup, "Best times", display.contentCenterX, 810, native.systemFont, defaults.font.size)
    highScoresButton:setFillColor(defaults.font.color.red, defaults.font.color.green, defaults.font.color.blue)

    playButton:addEventListener("tap", gotoGame)
    highScoresButton:addEventListener("tap", gotoBestTimes)
end


-- show()
function scene:show(event)

	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif (phase == "did") then
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

	end
end


-- destroy()
function scene:destroy(event)

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
