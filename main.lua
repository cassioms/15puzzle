local composer = require("composer")

-- Hide status bar
display.setStatusBar(display.HiddenStatusBar)

-- Seed the random number generator
math.randomseed(os.time())

--No audio for now
--audio.setVolume( 0.3 )
-- Reserve channel 1 for background music
--audio.reserveChannels( 1 )
-- Reduce the overall volume of the channel
--audio.setVolume( 0.1, { channel=1 } )

-- Go to the menu screen
composer.gotoScene("scripts.menu")
