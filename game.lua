
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

local tileTable
local tileObjects = {}
local zeroPosition = {}

local timeText
local timeElapsed
local mainGroup
local gameLoopTimer
local timeTextDisplay
local offsetWidth = (768 - 512) / 2
local offsetHeight = (1024 - 512) / 2

local function updateText()
    timeText.text = "Time in seconds: " .. timeElapsed
end

local function printTable()
    for i = 1, #tileTable, 1 do
        print("Tile table[" .. i .. "] = " .. tileTable[i])
    end
end

local function randomTileTable()
    tileTable = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}

    local iterations = #tileTable
    local j

    for i = iterations, 2, -1 do
        j = math.random(i)
        tileTable[i], tileTable[j] = tileTable[j], tileTable[i]
    end

    printTable()
end

local function checkGameDone()
    local done = true
    for i = 1, 16, 1 do
        if (tileTable[i] ~= i - 1) then
            done = false
            break
        end
    end

    if (done) then
        timer.cancel( gameLoopTimer )
        timeText = display.newText( mainGroup, "You win!", display.contentCenterX, display.contentCenterY, native.systemFont, 36 )
        timer.performWithDelay( 2000, endGame )
    end
end

local function gameLoop()
    timeElapsed = timeElapsed + 1
    updateText()
end

local function endGame()
    composer.setVariable( "finalTime", timeElapsed )
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

local function swap(x)
    local xIndex = 1
    local zeroIndex = 1
    for i = 1, #tileTable, 1 do
        if (x == tileTable[i]) then
            xIndex = i
            break
        end
    end

    for i = 1, #tileTable, 1 do
        if (tileTable[i] == 0) then
            zeroIndex = i
            break
        end
    end

    tileTable[xIndex], tileTable[zeroIndex] = tileTable[zeroIndex], tileTable[xIndex]
end

local function moveObject(event)
    local numberObj = event.target
    local oldX = numberObj.x
    local oldY = numberObj.y

    local number = numberObj.myValue
    transition.to( numberObj, {
        x = zeroPosition.x, y = zeroPosition.y, time = 500
    } )

    swap(number)
    zeroPosition.x = oldX
    zeroPosition.y = oldY

    printTable()
    checkGameDone()
end

local function showTableOnScreen()
    local line = 0
    local column = 0
    for i = 1, #tileTable, 1 do
        if (tileTable[i] ~= 0) then
            local newTile = display.newImageRect( mainGroup, objectSheet, tileTable[i], 128, 128 )
            newTile.x = offsetWidth + 64 + (column * 128)
            newTile.y = offsetHeight + 64 + (line * 128)
            newTile.myValue = tileTable[i]
            table.insert(tileObjects, newTile)

            --TODO adicionar evento somente para objetos perto do tile vazio '0'
            newTile:addEventListener( "tap", moveObject )
        else
            zeroPosition.x = offsetWidth + 64 + (column * 128)
            zeroPosition.y = offsetHeight + 64 + (line * 128)
        end

        column = column + 1
        if (column % 4 == 0) then
            column = 0
            line = line + 1
        end
    end
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
    timeText = display.newText( mainGroup, "Time in seconds: " .. timeElapsed, display.contentCenterX, 80, native.systemFont, 36 )
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
        randomTileTable()
        showTableOnScreen()
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
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
