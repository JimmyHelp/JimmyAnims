# JimmyAnims
Off-Discord Location for Jimmy's (my) Animation Handler for Figura versions 0.1.0 and newer. All the information in the read me is also in JimmyAnims.lua. This read me is a WIP, I just wanted to get it onto GitHub before I forgot.

# How to Use:

In a DIFFERENT script put this code: (or use JimmyExample)

local anims = require("JimmyAnims")
anims(animations.BBMODEL_NAME_HERE)

Where you need to replace BBMODEL_NAME_HERE with the name of the bbmodel that contains the animations. If you wish to use multiple bbmodels add more as arguments.

If JimmyAnims is in a subfolder, the name of the subfolder is added to the script name like this:

local anims = require("subfolder.JimmyAnims")

Example of multiple bbmodels:

local anims = require("JimmyAnims")
anims(animations.BBMODEL_NAME_HERE,animations.EXAMPLE)

If you make a typo with one of the bbmodel names when using multiple bbmodels the script won't be able to warn you. You're gonna have to spellcheck it.

Example of all functions with their default values:

local anims = require('JimmyAnims')
anims.excluBlendTime = 4
anims.incluBlendTime = 4
anims.autoBlend = false
anims.dismiss = false
anims.addExcluAnims()
anims.addIncluAnims()
anims.addAllAnims()
anims(animations.BBMODEL_NAME_HERE)

There's an explanation on all of these below

---------
JimmyAnims has two "types" of animations: 'exclusive' animations and 'inclusive' animations.

Exclusive animations: Cannot play at the same time, these are the type of player states like idle, walk, swim, elytra gliding, etc

Inclusive animations: Can play at the same time alongside each other and exclusive animations, these are the types of animations like eatR (only exception is holdR\L which won't play while using items)

--------

Animation Integration:
You can use the custom addExcluAnims, addIncluAnims, and addAllAnims functions to stop their associated animation types.

Example usage:
anims.addExcluAnims(animations.BBMODEL.example,animations.BBMODEL.second)

This will make it so whenever any of the given animations are playing, all exclusive animations will be stopped. addIncluAnims stops inclusive animations, and addAllAnims stops every animation.

---------

The script will automatically error if it detects an animation name with a period in it (JimmyAnims doesn't accept animations with periods in them, so only use this if the animation isn't meant for the handler).

You can dismiss this using

anims.dismiss = true

This goes directly after the require like this:

local anims = require("JimmyAnims")
anims.dismiss = true
anims(animations.BBMODEL_NAME_HERE)

---------

This script is compatible with GSAnimBlend.
It will automatically apply blendTime values to every animation, you can stop this or change the blend times using a couple functions.

Example of changing GSAnimBlend compatbility:
local anims = require("JimmyAnims")
anims.excluBlendTime = 4
anims.incluBlendTime = 4
anims.autoBlend = true
anims(animations.NAME_HERE)

excluBlendTime is for all the animations that can't play alongside each other
incluBlendTime is for animations that deal with items and hands (like, eatR or attackR)- aka ones that can play alongside each other and exclusive animations
autoBlend can be set to false to turn off the automatic blending

If you want to change individual animation values but don't want to disable autoBlend, you can change the blendTime value like normal underneath the final setup for JimmyAnims.

Note: These must be ABOVE where you set the bbmodel, like in the example. A different order will mess it up.

---------

LIST OF ANIMATIONS:
REMEMBER: ALL ANIMATIONS ARE OPTIONAL. IF YOU DON'T WANT ONE, DON'T ADD IT, ANOTHER ANIMATION WILL PLAY IN ITS STEAD FOR ALL ANIMATIONS BUT IDLE, WALK, AND CROUCH
To access the list of animations run this line of code IN THE OTHER SCRIPT AND UNDERNEATH THE REQUIRE:
(sadly Figura scrambles the order of the list, you can also look below to see it in the script)

logTable(anims.animsList)

Or you can look below at animsList. The stuff on the right is the animation name, the stuff on the left is an explanation of when the animation plays If you're confused about when animations will play, try them out.]]

local animsList = {

    -- Exclusive Animations
    
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

    -- Inclusive Animations:

attackR = "MUST BE IN PLAY ONCE LOOP MODE. attacking with the right hand",

attackL = "MUST BE IN PLAY ONCE LOOP MODE. attacking with the left hand",

mineR = "MUST BE IN PLAY ONCE LOOP MODE. mining with the right hand",

mineL = "MUST BE IN PLAY ONCE LOOP MODE. mining with the left hand",

useR = "MUST BE IN PLAY ONCE LOOP MODE. placing blocks/using items/interacting with blocks/mobs/etc with the right hand",

useL = "MUST BE IN PLAY ONCE LOOP MODE. placing blocks/using items/interacting with blocks/mobs/etc with the left hand",



eatR = "eating from the right hand",

eatL = "eating from the left hand",

drinkR = "drinking from the right hand",

drinkL = "drinking from the left hand",

blockR = "blocking from the right hand",

blockL = "blocking from the left hand",

bowR = "drawing back a bow from the right hand",

bowL = "drawing back a bow from the left hand",

loadR = "loading a crossbow from the right hand",

loadL = "loading a crossbow from the left hand",

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
}

attackR/L, mineR/L, and holdR/L can be customized to play only with specific animations

For these special animations their names in blockbench are going to have three parts:

1. The first part identifies if the animation is for a specific item name or a specific item id

a. ID_ for id specific animations, and Name_ for name specific animations

2. the string you wish to match, for ids this will be a part of the id like sword or pickaxe. For names this should be the name of the item (spaces are fine however be aware of regex characters)

3. when this animation will play, right now the options are _holdR, _holdL, _attackR, _attackL, _mineR, and _mineL

Examples of animation names for these animations:

ID_sword_attackR - special right hand attacking animation for holding a sword

ID__axe_mineR - right hand mining with an axe, note the extra _ so it won't play with pickaxes

ID_bow$_holdR - right hand bow animation, note the regex $ so it doesn't play while holding bowls

Name_Shovel_mineR - right hand animation for an item with Shovel in its name

Name_Chaos Bringer_attackR - right hand attack for an item named Chaos Bringer
