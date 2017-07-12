local composer = require("composer")

local scenes = {
    transition = {
        time = 800,
        effect = "crossFade"
    }
}


function scenes.goToMenu()
    composer.gotoScene("scripts.menu", scenes.transition)
end

function scenes.gotoGame()
    composer.gotoScene("scripts.game", scenes.transition)
end

function scenes.gotoBestTimes()
    composer.gotoScene("scripts.besttimes", scenes.transition)
end

return scenes
