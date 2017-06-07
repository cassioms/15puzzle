
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Configure image sheet
local sheetOptions =
{
    frames =
    {
        {   -- 1)
            x = 0,
            y = 0,
            width = 128,
            height = 128
        },
        {   -- 2)
            x = 128,
            y = 0,
            width = 128,
            height = 128
        },
        {   -- 3)
            x = 0,
            y = 128,
            width = 128,
            height = 128
        },
        {   -- 4)
            x = 128,
            y = 128,
            width = 128,
            height = 128
        },
        {   -- 5)
            x = 0,
            y = 256,
            width = 128,
            height = 128
        },
        {   -- 6)
            x = 128,
            y = 256,
            width = 128,
            height = 128
        },
        {   -- 7)
            x = 0,
            y = 384,
            width = 128,
            height = 128
        },
        {   -- 8)
            x = 128,
            y = 384,
            width = 128,
            height = 128
        },
        {   -- 9)
            x = 0,
            y = 512,
            width = 128,
            height = 128
        },
        {   -- 10)
            x = 128,
            y = 512,
            width = 128,
            height = 128
        },
        {   -- 11)
            x = 0,
            y = 640,
            width = 128,
            height = 128
        },
        {   -- 12)
            x = 128,
            y = 640,
            width = 128,
            height = 128
        },
        {   -- 13)
            x = 0,
            y = 768,
            width = 128,
            height = 128
        },
        {   -- 14)
            x = 128,
            y = 768,
            width = 128,
            height = 128
        },
        {   -- 15)
            x = 0,
            y = 896,
            width = 128,
            height = 128
        }
    },
}

local objectSheet = graphics.newImageSheet( "design/tileset.png", sheetOptions )

-- Initialize variables
local done = false

local tileTable

local timeText
local timeElapsed
local mainGroup
local gameLoopTimer
local timeTextDisplay

local function updateText()
    timeText.text = "Time in seconds: " .. timeElapsed
end

local function randomTileTable()
    tileTable = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}

    local iterations = #tileTable
    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        tileTable[i], tileTable[j] = tileTable[j], tileTable[i]
    end
end

local function checkGameDone()
    for i = 0, 16, 1 do
        if (tileTable[i] != i) then
            return
        end
    end

    done = true
end

local function fireLaser()
    -- Play fire sound!
    audio.play( fireSound )

    local newLaser = display.newImageRect( mainGroup, objectSheet, 5, 14, 40 )
    physics.addBody( newLaser, "dynamic", { isSensor=true } )
    newLaser.isBullet = true
    newLaser.myName = "laser"

    newLaser.x = ship.x
    newLaser.y = ship.y
    newLaser:toBack()

    transition.to( newLaser, { y=-40, time=500,
        onComplete = function() display.remove( newLaser ) end
    } )
end

local function dragShip( event )
    local ship = event.target
    local phase = event.phase
    if ( "began" == phase ) then
        -- Set touch focus on the ship
        display.currentStage:setFocus( ship )
        -- Store initial offset position
        ship.touchOffsetX = event.x - ship.x
    elseif ( "moved" == phase ) then
        -- Move the ship to the new touch position
        ship.x = event.x - ship.touchOffsetX
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the ship
        display.currentStage:setFocus( nil )
    end
end

local function gameLoop()
    timeElapsed = timeElapsed + 1
    updateText()
end

local function restoreShip()

    ship.isBodyActive = false
    ship.x = display.contentCenterX
    ship.y = display.contentHeight - 100

    -- Fade in the ship
    transition.to( ship, { alpha=1, time=4000,
        onComplete = function()
            ship.isBodyActive = true
            died = false
        end
    } )
end

local function endGame()
    composer.setVariable( "finalTime", timeElapsed )
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

    -- Display timer
    timeElapsed = 0
    timeText = display.newText( mainGroup, "Time in seconds: " .. timeElapsed, 200, 80, native.systemFont, 36 )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        gameLoopTimer = timer.performWithDelay( 1000, gameLoop, 0 )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( gameLoopTimer )
	elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene( "game" )
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
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
