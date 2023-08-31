# JimmyAnims
Off-Discord Location for Jimmy's (my) Animation Handler for Figura versions 0.1.0 and newer. All the information in the read me is also in JimmyAnims.lua. This read me is a WIP, I just wanted to get it onto GitHub before I forgot.

# How to Use:

HOW TO USE: Download JimmyAnims.lua and (optionally) JimmyExample.lua

(THIS CODE DOES NOT RUN, DO NOT EDIT THIS AND EXPECT RESULTS, MOVE IT TO A DIFFERENT SCRIPT AS THE INSTRUCTIONS SAY)

In a DIFFERENT script put this code:

```lua
local anims = require("JimmyAnims")

anims(animations.BBMODEL_NAME_HERE)
```

Where you need to replace BBMODEL_NAME_HERE with the name of the bbmodel that contains the animations. If you wish to use multiple bbmodels add more as arguments.

If JimmyAnims is in a subfolder, the name of the subfolder is added to the script name like this:

```lua
local anims = require("subfolder.JimmyAnims")

Example of multiple bbmodels:

local anims = require("JimmyAnims")

anims(animations.BBMODEL_NAME_HERE,animations.EXAMPLE)
```

If you make a typo with one of the bbmodel names when using multiple bbmodels the script won't be able to warn you. You're gonna have to spellcheck it.

---------

The script will automatically error if it detects an animation name with a period in it. You can dismiss this using

```lua
anims.dismiss = true
```

This goes directly after the require like this:

```lua
local anims = require("JimmyAnims")

anims.dismiss = true

anims(animations.BBMODEL_NAME_HERE)
```

---------

This script is compatible with GSAnimBlend.
It will automatically apply blendTime values to every animation, you can stop this or change the blend times using a couple functions.

Example of changing GSAnimBlend compatbility:

```lua
local anims = require("JimmyAnims")

anims.blendTime = 1.5

anims.itemBlendTime = 1.5

anims.autoBlend = true

anims(animations.NAME_HERE)
```

blendTime is for the main bulk of animations

itemBlendTime is for animations that deal with items and hands (like, eatingR or attackR)

autoBlend can be set to false to turn off the automatic blending

If you want to change individual animation values but don't want to disable autoBlend, you can change the blendTime value like normal underneath the require for JimmyAnims.

Note: These must be ABOVE where you set the bbmodel, like in the example. A different order will mess it up.

---------

LIST OF ANIMATIONS:
REMEMBER: ALL ANIMATIONS ARE OPTIONAL. IF YOU DON'T WANT ONE, DON'T ADD IT, ANOTHER ANIMATION WILL PLAY IN ITS STEAD FOR ALL ANIMATIONS BUT IDLE, WALK, AND CROUCH

To access the list of animations run this line of code IN THE OTHER SCRIPT AND UNDERNEATH THE REQUIRE:

(sadly Figura scrambles the order of the list, you can also look below to see it in the script)

logTable(animsList)

Or you can look below at animsList. The stuff on the right is the animation name, the stuff on the left is an explanation of when the animation plays If you're confused about when animations will play, try them out.]]


idle="idling",

walk="walking",

walkback="walking backwards",

jumpup="jumping up caused via the jump key",

jumpdown="jumping down after a jump up",

fall="falling after a while",


sprint = "sprinting",

sprintjumpup="sprinting and jumping up caused via the jump key",

sprintjumpdown="sprinting and jumping down after a jump up",


crouch = "crouching",

crouchwalk = "crouching and walking",

crouchwalkback = "crouching and walking backwards",

crouchjumpup = "crouching and jumping up caused via the jump key",

crouchjumpdown = "crouching and jumping down after a jump up",

elytra = "elytra flying",

elytradown = "flying down/diving while elytra flying",

trident = "riptide trident lunging",

sleep = "sleeping",

vehicle = "while in any vehicle",

swim = "while swimming",

crawl = "crawling and moving",

crawlstill = "crawling and still",

fly = "creative flying",

flywalk = "flying and moving",

flywalkback = "flying and moving backwards",

flysprint  = "flying and sprinting",

flyup = "flying and going up",

flydown = "flying and going down",


climb = "climbing a ladder",

climbstill = "not moving on a ladder without crouching (hitting a ceiling usually)",

climbdown = "going down a ladder",

climbcrouch = "crouching on a ladder",

climbcrouchwalk = "crouching on a ladder and moving",


water = "being in water without swimming",

waterwalk = "in water and moving",

waterwalkback = "in water and moving backwards",

waterup = "in water and going up",

waterdown = "in water and going down",

watercrouch = "in water and crouching",

watercrouchwalk = "in water and crouching and walking",

watercrouchwalkback = "in water and crouching and walking backwards",

watercrouchdown = "in water and crouching and going down",

watercrouchup = "in water and crouching and going up. only possible in bubble columns",


hurt = "MUST BE IN PLAY ONCE LOOP MODE. when hurt",

death = "dying",


attackR = "MUST BE IN PLAY ONCE LOOP MODE. attacking with the right hand",

attackL = "MUST BE IN PLAY ONCE LOOP MODE. attacking with the left hand",

mineR = "MUST BE IN PLAY ONCE LOOP MODE. mining with the right hand",

mineL = "MUST BE IN PLAY ONCE LOOP MODE. mining with the left hand",

useR = "MUST BE IN PLAY ONCE LOOP MODE. placing blocks/using items/interacting with blocks/mobs/etc with the right hand",

useL = "MUST BE IN PLAY ONCE LOOP MODE. placing blocks/using items/interacting with blocks/mobs/etc with the left hand",


eatingR = "eating from the right hand",

eatingL = "eating from the left hand",

drinkingR = "drinking from the right hand",

drinkingL = "drinking from the left hand",

blockingR = "blocking from the right hand",

blockingL = "blocking from the left hand",

bowR = "drawing back a bow from the right hand",

bowL = "drawing back a bow from the left hand",

loadingR = "loading a crossbow from the right hand",

loadingL = "loading a crossbow from the left hand",

crossbowR = "holding a loaded crossbow in the right hand",

crossbowL = "holding a loaded crossbow in the left hand",

spearR = "holding up a trident in the right hand",

spearL = "holding up a trident in the left hand",

spyglassR = "holding up a spyglass from the right hand",

spyglassL = "holding up a spyglass from the left hand",

hornR = "using a horn in the right hand",
hornL = "using a horn in the left hand",

holdR = "holding an item in the right hand",
holdL = "holding an item in the left hand",
