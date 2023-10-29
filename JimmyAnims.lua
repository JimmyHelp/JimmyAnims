-- + Made by Jimmy Hellp
-- + V4.1 for 0.1.0 and above
-- + Thank you GrandpaScout for helping with the library stuff!
-- + Automatically compatible with GSAnimBlend for automatic smooth animation blending
-- + Now with animation integration, as an alternative to using priority

--[[---------- YOU ARE NOT SUPPOSED TO EDIT THIS SCRIPT. DO SO AT YOUR OWN RISK. DELETE THE ERRORS AT YOUR OWN RISK. THEY'RE THERE TO TROUBLESHOOT PROBLEMS NOT TO INCONVENIENCE YOU --------

HOW TO USE: (THIS CODE DOES NOT RUN, DO NOT EDIT THIS AND EXPECT RESULTS, MOVE IT TO A DIFFERENT SCRIPT AS THE INSTRUCTIONS SAY)

In a DIFFERENT script put this code:

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
JimmyAnims has two "types" of animations: 'exclusive' animations and 'invlusive' animations.

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

------------------------------------------------------------------------------------------------------------------------

local avatarVer = "0.1.0"
assert(
  client.compareVersions(client.getFiguraVersion(), avatarVer) > -1,
  "§aCustom Script Warning: §4Your version of Figura is out of date for this animation template, the expected version is ".. avatarVer.." or newer. \n".." Update your Figura version to "..avatarVer.." or newer.§c"
)


local function errors(paths,dismiss)
    assert(
        next(paths),
        "§aCustom Script Warning: §4No blockbench models were found, or the blockbench model found contained no animations. \n" .." Check that there are no typos in the given bbmodel name, or that the bbmodel has animations by using this line of code at the top of your script: \n"
        .."§f logTable(animations.BBMODEL_NAME_HERE) \n ".."§4If this returns nil your bbmodel name is wrong or it has no animations. You can use \n".."§f logTable(models:getChildren()) \n".."§4 to get the name of every bbmodel in your avatar.§c"
    )

    for _, path in pairs(paths) do
        for _, anim in pairs(path) do
            if anim:getName():find("%.") and not dismiss then
                error(
                    "§aCustom Script Warning: §4The animation §b'"..anim:getName().."'§4 has a period ( . ) in its name, the handler can't use that animation and it must be renamed to fit the handler's accepted animation names. \n" ..
                " If the animation isn't meant for the handler, you can dismiss this error by adding §fanims.dismiss = true§4 after the require but before setting the bbmodel.§c")
            end
        end
    end
end

local allAnims = {}
local excluAnims = {}
local incluAnims = {}
local animsTable= {
    allVar = false,
    excluVar = false,
    incluVar = false
}
local excluState
local incluState

local holdRanims = {}
local holdLanims = {}
local attackRanims = {}
local attackLanims = {}
local mineRanims = {}
local mineLanims = {}

local hasJumped = false

local sleeping

local hp
local oldhp

local cFlying
local oldcFlying = cFlying
local flying = false
local flyTimer = 0

local dist
local oldDist = dist
local reach = 4.5

local jump
local oldJump = jump
local holdingJ = false

local grounded

-- wait code from Manuel
local timers = {}

local function wait(ticks,next)
    table.insert(timers,{t=world.getTime()+ticks,n=next})
end

events.TICK:register(function()
    for key,timer in pairs(timers) do
        if world.getTime() >= timer.t then
            timer.n()
            timers[key] = nil
        end
    end
end)
--

local rightActive
local leftActive
local rightPress
local leftPress
local rightSwing
local leftSwing
local targetEntity
local hitBlock
local rightMine
local leftMine
local handedness
local rightItem
local leftItem

function pings.JimmyAnims_cFly(x)
    flying = x
end

function pings.JimmyAnims_Distance(x)
    reach = x
end

function pings.JimmyAnims_Jump(x)
    holdingJ = x
end

local bbmodels = {} -- don't put things in here

function pings.JimmyAnims_Attacking(x)
    if not player:isLoaded() then return end
    leftPress = x
    targetEntity = type(player:getTargetedEntity()) == "PlayerAPI" or type(player:getTargetedEntity()) == "LivingEntityAPI"
    hitBlock = not (next(player:getTargetedBlock(true,reach):getTextures()) == nil)
    if not leftPress then return end
    wait(1,function()
        rightSwing = player:getSwingArm() == rightActive and not sleeping
        leftSwing = player:getSwingArm() == leftActive and not sleeping
        local rightAttack = rightSwing and (not hitBlock or targetEntity)
        local leftAttack = leftSwing and (not hitBlock or targetEntity)
        rightMine = rightSwing and hitBlock and not targetEntity
        leftMine = leftSwing and hitBlock and not targetEntity
        for _, path in pairs(bbmodels) do    
            if rightAttack and path.attackR and incluState then 
                path.attackR:play()
            end
            if leftAttack and path.attackL and incluState then 
                path.attackL:play()
            end
            if path.mineR and rightMine and incluState then
                path.mineR:play()
            end
            if path.mineL and leftMine and incluState then
                path.mineL:play()
            end
        end

        if rightAttack and incluState then
            for _, value in pairs(attackRanims) do
                if value:getName():find("ID_") then
                    if rightItem.id:find(value:getName():gsub("_attackR",""):gsub("ID_","")) then
                        value:play()
                    end
                elseif value:getName():find("Name_") then
                    if rightItem:getName():find(value:getName():gsub("_attackR",""):gsub("Name_","")) then
                        value:play()
                    end
                end
                if value:isPlaying() then
                    for _, path in pairs(bbmodels) do  
                        if path.attackR then path.attackR:stop() end
                    end
                end
            end
        end

        if leftAttack and incluState then
            for _, value in pairs(attackLanims) do
                if value:getName():find("ID_") then
                    if leftItem.id:find(value:getName():gsub("_attackL",""):gsub("ID_","")) then
                        value:play()
                    end
                elseif value:getName():find("Name_") then
                    if leftItem:getName():find(value:getName():gsub("_attackL",""):gsub("Name_","")) then
                        value:play()
                    end
                end
                if value:isPlaying() then
                    for _, path in pairs(bbmodels) do  
                        if path.attackL then path.attackL:stop() end
                    end
                end
            end
        end

        if rightMine and incluState then
            for _, value in pairs(mineRanims) do
                if value:getName():find("ID_") then
                    if rightItem.id:find(value:getName():gsub("_mineR",""):gsub("ID_","")) then
                        value:play()
                    end
                elseif value:getName():find("Name_") then
                    if rightItem:getName():find(value:getName():gsub("_mineR",""):gsub("Name_","")) then
                        value:play()
                    end
                end
                if value:isPlaying() then
                    for _, path in pairs(bbmodels) do  
                        if path.mineR then path.mineR:stop() end
                    end
                end
            end
        end

        if rightMine and incluState then
            for _, value in pairs(mineLanims) do
                if value:getName():find("ID_") then
                    if leftItem.id:find(value:getName():gsub("_mineL",""):gsub("ID_","")) then
                        value:play()
                    end
                elseif value:getName():find("Name_") then
                    if leftItem:getName():find(value:getName():gsub("_mineL",""):gsub("Name_","")) then
                        value:play()
                    end
                end
                if value:isPlaying() then
                    for _, path in pairs(bbmodels) do  
                        if path.mineL then path.mineL:stop() end
                    end
                end
            end
        end

    end)
end

function pings.JimmyAnims_Using(x)
    if not player:isLoaded() then return end
    rightPress = x
    if not rightPress then return end
    wait(1,function()
    for _, path in pairs(bbmodels) do    
        if path.useR and player:getSwingArm() == rightActive and not sleeping and incluState then
            path.useR:play()
        end
        if path.useL and player:getSwingArm() == leftActive and not sleeping and incluState then
            path.useL:play()
        end
    end
    end)
end

local attack = keybinds:newKeybind("Attack",keybinds:getVanillaKey("key.attack"))
attack.press = function() pings.JimmyAnims_Attacking(true) end
attack.release = function() pings.JimmyAnims_Attacking(false) end

local use = keybinds:newKeybind("Use",keybinds:getVanillaKey("key.use"))
use.press = function() pings.JimmyAnims_Using(true) end
use.release = function() pings.JimmyAnims_Using(false) end

function events.entity_init()
    hp = player:getHealth() + player:getAbsorptionAmount()
    oldhp = hp
end

local function anims()
    for _, value in ipairs(allAnims) do
        if value:isPlaying() then
            animsTable.allVar = true
            break
        else
            animsTable.allVar = false
        end
    end
    for _, value in ipairs(excluAnims) do
        if value:isPlaying() then
            animsTable.excluVar = true
            break
        else
            animsTable.excluVar = false
        end
    end

    for _, value in ipairs(incluAnims) do
        if value:isPlaying() then
            animsTable.incluVar = true
            break
        else
            animsTable.incluVar = false
        end
    end

    excluState = not animsTable.allVar and not animsTable.excluVar
    incluState = not animsTable.allVar and not animsTable.incluVar

    if host:isHost() then
        cFlying = host:isFlying()
        if cFlying ~= oldcFlying then
            pings.JimmyAnims_cFly(cFlying)
        end
        oldcFlying = cFlying

        flyTimer = flyTimer + 1
        if flyTimer % 200 == 0 then
            pings.JimmyAnims_cFly(cFlying)
            pings.JimmyAnims_Distance(dist)
        end

        dist = host:getReachDistance()
        if dist ~= oldDist then
            pings.JimmyAnims_Distance(dist)
        end
        oldDist = dist

        jump = host:isJumping()
        if jump ~= oldJump then
            pings.JimmyAnims_Jump(jump)
        end
        oldJump = jump
    end

    local velocity = player:getVelocity()
    local moving = velocity.xz:length() > 0.01
    local sprinty = player:isSprinting()
    local sitting = player:getVehicle() ~= nil
    local creativeFlying = flying and not sitting
    local pose = player:getPose()
    local standing = pose == "STANDING"
    local crouching = pose == "CROUCHING" and not creativeFlying
    local gliding = pose == "FALL_FLYING"
    local spin = pose == "SPIN_ATTACK"
    sleeping = pose == "SLEEPING"
    local swimming = pose == "SWIMMING"
    local inWater = player:isUnderwater()
    local inLiquid = player:isInWater() or player:isInLava()
    local liquidSwim = swimming and inLiquid
    local crawling = swimming and not inLiquid


    -- hasJumped stuff
    local yvel = velocity.y
    local hover = yvel == 0
    local goingUp = yvel > 0
    local goingDown =  yvel < 0
    local falling = yvel < -.6
    local playerGround = world.getBlockState(player:getPos():add(0,-.1,0))
    grounded = playerGround:isSolidBlock() or player:isOnGround()
    local pv = velocity:mul(1, 0, 1):normalize()
    local pl = models:partToWorldMatrix():applyDir(0,0,-1):mul(1, 0, 1):normalize()
    local fwd = pv:dot(pl)
    local backwards = fwd < -.8

    -- canJump stuff
    local webbed = world.getBlockState(player:getPos()).id == "minecraft:cobweb"
    local ladder = player:isClimbing() and not grounded and not flying

    local canJump = not (inLiquid or webbed)

    oldhp = hp
    hp = player:getHealth() + player:getAbsorptionAmount()

    if holdingJ and canJump then hasJumped = true end
    if grounded and not holdingJ then hasJumped = false end

    local neverJump = not (gliding or spin or sleeping or swimming or ladder or sitting)
    local jumpingUp = hasJumped and goingUp and neverJump
    local jumpingDown = hasJumped and goingDown and not falling and neverJump
    local isJumping = jumpingUp or jumpingDown or falling
    local sprinting = sprinty and standing and not inLiquid and not sitting
    local walking = moving and not sprinting and not isJumping and not sitting
    local forward = walking and not backwards
    local backward = walking and backwards

        -- we be holding items tho
        handedness = player:isLeftHanded()
        rightActive = handedness and "OFF_HAND" or "MAIN_HAND"
        leftActive = not handedness and "OFF_HAND" or "MAIN_HAND"
        local activeness = player:getActiveHand()
        local using = player:isUsingItem()
        rightSwing = player:getSwingArm() == rightActive and not sleeping
        leftSwing = player:getSwingArm() == leftActive and not sleeping
        targetEntity = type(player:getTargetedEntity()) == "PlayerAPI" or type(player:getTargetedEntity()) == "LivingEntityAPI"
        hitBlock = not (next(player:getTargetedBlock(true,reach):getTextures()) == nil)
        rightMine = rightSwing and hitBlock and not targetEntity
        leftMine = leftSwing and hitBlock and not targetEntity
    
        rightItem = player:getHeldItem(handedness)
        leftItem = player:getHeldItem(not handedness)
        local usingR = activeness == rightActive and rightItem:getUseAction()
        local usingL = activeness == leftActive and leftItem:getUseAction()
    
        local crossR = rightItem.tag and rightItem.tag["Charged"] == 1
        local crossL = leftItem.tag and leftItem.tag["Charged"] == 1
    
        local drinkRState = using and usingR == "DRINK"
        local drinkLState = using and usingL == "DRINK"
    
        local eatRState = using and usingR == "EAT"
        local eatLState = using and usingL == "EAT"
    
        local blockRState = using and usingR == "BLOCK"
        local blockLState = using and usingL == "BLOCK"
    
        local bowRState = using and usingR == "BOW"
        local bowLState = using and usingL == "BOW"
    
        local spearRState = using and usingR == "SPEAR"
        local spearLState = using and usingL == "SPEAR"
    
        local spyglassRState = using and usingR == "SPYGLASS"
        local spyglassLState = using and usingL == "SPYGLASS"
    
        local hornRState = using and usingR == "TOOT_HORN"
        local hornLState = using and usingL == "TOOT_HORN"
    
        local loadRState = using and usingR == "CROSSBOW"
        local loadLState = using and usingL == "CROSSBOW"
    
        local exclude = not (using or crossR or crossL)
        local rightHoldState = rightItem.id ~= "minecraft:air" and exclude
        local leftHoldState = leftItem.id ~= "minecraft:air" and exclude

    -- anim states
    for _, path in pairs(bbmodels) do

    local flywalkbackState = creativeFlying and backward
    local flysprintState = creativeFlying and sprinting and not isJumping and (not (goingDown or goingUp))
    local flyupState = creativeFlying and goingUp
    local flydownState = creativeFlying and goingDown
    local flywalkState = creativeFlying and forward and (not (goingDown or goingUp)) and not sleeping or (flysprintState and not path.flysprint) or (flywalkbackState and not path.flywalkback)
    or (flyupState and not path.flyup) or (flydownState and not path.flydown)
    local flyState = creativeFlying and not moving and standing and not isJumping and not sleeping or (flywalkState and not path.flywalk) 

    local watercrouchwalkbackState = inWater and crouching and backward and not goingDown
    local watercrouchwalkState = inWater and crouching and forward and not (goingDown or goingUp) or (watercrouchwalkbackState and not path.watercrouchwalkback)
    local watercrouchupState = inWater and crouching and goingUp
    local watercrouchdownState = inWater and crouching and goingDown or (watercrouchupState and not path.watercrouchup)
    local watercrouchState = inWater and crouching and not moving and not (goingDown or goingUp) or (watercrouchdownState and not path.watercrouchdown) or (watercrouchwalkState and not path.watercrouchwalk)

    local waterdownState = inWater and goingDown and standing and not creativeFlying
    local waterupState = inWater and goingUp and standing and not creativeFlying
    local waterwalkbackState = inWater and backward and hover and standing and not creativeFlying
    local waterwalkState = inWater and forward and hover and standing and not creativeFlying or (waterwalkbackState and not path.waterwalkback) or (waterdownState and not path.waterdown)
    or (waterupState and not path.waterup)
    local waterState = inWater and not moving and standing and hover and not creativeFlying or (waterwalkState and not path.waterwalk)
    
    local crawlstillState = crawling and not moving
    local crawlState = crawling and moving or (crawlstillState and not path.crawlstill)

    local swimState = liquidSwim or (crawlState and not path.crawl)

    local elytradownState = gliding and goingDown
    local elytraState = gliding and not goingDown or (elytradownState and not path.elytradown)

    local tridentState = spin
    local sleepState = sleeping
    local vehicleState = sitting

    local climbcrouchwalkState = ladder and crouching and (moving or yvel ~= 0)
    local climbcrouchState = ladder and crouching and hover and not moving or (climbcrouchwalkState and not path.climbcrouchwalk)
    local climbdownState = ladder and goingDown
    local climbstillState = ladder and not crouching and hover
    local climbState = ladder and goingUp and not crouching or (climbdownState and not path.climbdown) or (climbstillState and not path.climbstill)

    local crouchjumpdownState = crouching and jumpingDown and not ladder and not inWater
    local crouchjumpupState = crouching and jumpingUp and not ladder or (crouchjumpdownState and not path.crouchjumpdown)
    local crouchwalkbackState = backward and crouching and not ladder and not inWater
    local crouchwalkState = forward and crouching and not ladder and not inWater or (crouchwalkbackState and not path.crouchwalkback) or (crouchjumpupState and not path.crouchjumpup)
    local crouchState = crouching and not walking and not isJumping and not ladder and not inWater or (crouchwalkState and not path.crouchwalk) or (climbcrouchState and not path.climbcrouch) or (watercrouchState and not path.watercrouch)
    
    local fallState = falling and not gliding and not creativeFlying
    local jumpdownState = jumpingDown and not sprinting and not crouching and not creativeFlying and not inWater or (fallState and not path.fall)
    local jumpupState = jumpingUp and not sprinting and not crouching and not creativeFlying and not inWater or (jumpdownState and not path.jumpdown) or (tridentState and not path.trident)
    local sprintjumpdownState = jumpingDown and sprinting and not creativeFlying and not ladder
    local sprintjumpupState = jumpingUp and sprinting and not creativeFlying and not ladder or (sprintjumpdownState and not path.sprintjumpdown)

    local sprintState = sprinting and not isJumping and not creativeFlying and not ladder or (sprintjumpupState and not path.sprintjumpup)
    local walkbackState = backward and standing and not creativeFlying and not ladder and not inWater
    local walkState = forward and standing and not creativeFlying and not ladder and not inWater or (walkbackState and not path.walkback) or (sprintState and not path.sprint) or (climbState and not path.climb) 
    or (swimState and not path.swim) or (elytraState and not path.elytra) or (jumpupState and not path.jumpup) or (waterwalkState and (not path.waterwalk and not path.water)) or (flywalkState and not path.flywalk and not path.fly)
    or (crouchwalkState and not path.crouch)
    local idleState = not moving and standing and not isJumping and not sitting and not creativeFlying and not ladder and not inWater or (sleepState and not path.sleep) or (vehicleState and not path.vehicle)
    or ((waterState and not waterwalkState) and not path.water) or ((flyState and not flywalkState) and not path.fly) or ((crouchState and not crouchwalkState) and not path.crouch)

    local deadState = hp <= 0

    -- anim play testing
        if path.hurt and (oldhp > hp and hp ~= 0 and oldhp ~= 0) then
            path.hurt:restart()
        end

        if path.idle then path.idle:playing(excluState and idleState) end
        if path.walk then path.walk:playing(excluState and walkState) end
        if path.walkback then path.walkback:playing(excluState and walkbackState) end
        if path.sprint then path.sprint:playing(excluState and sprintState) end
        if path.sprintjumpup then path.sprintjumpup:playing(excluState and sprintjumpupState) end
        if path.sprintjumpdown then path.sprintjumpdown:playing(excluState and sprintjumpdownState) end
        if path.crouch then path.crouch:playing(excluState and crouchState) end
        if path.crouchwalk then path.crouchwalk:playing(excluState and crouchwalkState) end
        if path.crouchwalkback then path.crouchwalkback:playing(excluState and crouchwalkbackState) end
        if path.crouchjumpup then path.crouchjumpup:playing(excluState and crouchjumpupState) end
        if path.crouchjumpdown then path.crouchjumpdown:playing(excluState and crouchjumpdownState) end
        if path.jumpup then path.jumpup:playing(excluState and jumpupState) end
        if path.jumpdown then path.jumpdown:playing(excluState and jumpdownState) end
        if path.fall then path.fall:playing(excluState and fallState) end
        if path.elytra then path.elytra:playing(excluState and elytraState) end
        if path.elytradown then path.elytradown:playing(excluState and elytradownState) end
        if path.trident then path.trident:playing(excluState and tridentState) end
        if path.sleep then path.sleep:playing(excluState and sleepState) end
        if path.swim then path.swim:playing(excluState and swimState) end
        if path.vehicle then path.vehicle:playing(excluState and vehicleState) end
        if path.crawl then path.crawl:playing(excluState and crawlState) end
        if path.crawlstill then path.crawlstill:playing(excluState and crawlstillState) end
        if path.fly then path.fly:playing(excluState and flyState) end
        if path.flywalk then path.flywalk:playing(excluState and flywalkState) end
        if path.flywalkback then path.flywalkback:playing(excluState and flywalkbackState) end
        if path.flysprint then path.flysprint:playing(excluState and flysprintState) end
        if path.flyup then path.flyup:playing(excluState and flyupState) end
        if path.flydown then path.flydown:playing(excluState and flydownState) end
        if path.climb then path.climb:playing(excluState and climbState) end
        if path.climbstill then path.climbstill:playing(excluState and climbstillState) end
        if path.climbdown then path.climbdown:playing(excluState and climbdownState) end
        if path.climbcrouch then path.climbcrouch:playing(excluState and climbcrouchState) end
        if path.climbcrouchwalk then path.climbcrouchwalk:playing(excluState and climbcrouchwalkState) end
        if path.water then path.water:playing(excluState and waterState) end
        if path.waterwalk then path.waterwalk:playing(excluState and waterwalkState) end
        if path.waterwalkback then path.waterwalkback:playing(excluState and waterwalkbackState) end
        if path.waterup then path.waterup:playing(excluState and waterupState) end
        if path.waterdown then path.waterdown:playing(excluState and waterdownState) end
        if path.watercrouch then path.watercrouch:playing(excluState and watercrouchState) end
        if path.watercrouchwalk then path.watercrouchwalk:playing(excluState and watercrouchwalkState) end
        if path.watercrouchwalkback then path.watercrouchwalkback:playing(excluState and watercrouchwalkbackState) end
        if path.watercrouchdown then path.watercrouchdown:playing(excluState and watercrouchdownState) end
        if path.watercrouchup then path.watercrouchup:playing(excluState and watercrouchupState) end

        if path.death then path.death:playing(excluState and deadState) end

        if path.mineR and leftPress and rightMine and incluState then
            path.mineR:play()
        end
        if path.mineL and leftPress and leftMine and incluState then
            path.mineL:play()
        end
        
        if path.useR and rightPress and rightSwing and incluState then
            path.useR:play()
        end
        if path.useL and rightPress and leftSwing and incluState then
            path.useL:play()
        end

        if path.eatR then path.eatR:playing(incluState and eatRState or (drinkRState and not path.drinkR)) end
        if path.eatL then path.eatL:playing(incluState and eatLState or (drinkLState and not path.drinkL)) end
        if path.drinkR then path.drinkR:playing(incluState and drinkRState) end
        if path.drinkL then path.drinkL:playing(incluState and drinkLState) end
        if path.blockR then path.blockR:playing(incluState and blockRState) end
        if path.blockL then path.blockL:playing(incluState and blockLState) end
        if path.bowR then path.bowR:playing(incluState and bowRState) end
        if path.bowL then path.bowL:playing(incluState and bowLState) end
        if path.loadR then path.loadR:playing(incluState and loadRState) end
        if path.loadL then path.loadL:playing(incluState and loadLState) end
        if path.crossbowR then path.crossbowR:playing(incluState and crossR) end
        if path.crossbowL then path.crossbowL:playing(incluState and crossL) end
        if path.spearR then path.spearR:playing(incluState and spearRState) end
        if path.spearL then path.spearL:playing(incluState and spearLState) end
        if path.spyglassR then path.spyglassR:playing(incluState and spyglassRState) end
        if path.spyglassL then path.spyglassL:playing(incluState and spyglassLState) end
        if path.hornR then path.hornR:playing(incluState and hornRState) end
        if path.hornL then path.hornL:playing(incluState and hornLState) end

        if path.holdR then path.holdR:playing(incluState and rightHoldState) end
        if path.holdL then path.holdL:playing(incluState and leftHoldState) end
    end

    for _,value in pairs(mineRanims) do
        if value:getName():find("ID_") then
            if rightItem.id:find(value:getName():gsub("_mineR",""):gsub("ID_","")) and leftPress and rightMine and incluState then
                value:play()
            end
        elseif value:getName():find("Name_") then
            if rightItem:getName():find(value:getName():gsub("_mineR",""):gsub("Name_","")) and leftPress and rightMine and incluState then
                value:play()
            end
        end
        if value:isPlaying() then
            for _, path in pairs(bbmodels) do
                if path.mineR then path.mineR:stop() end
            end
        end
    end

    for _,value in pairs(mineLanims) do
        if value:getName():find("ID_") then
            if leftItem.id:find(value:getName():gsub("_mineL",""):gsub("ID_","")) and leftPress and leftMine and incluState then
                value:play()
            end
        elseif value:getName():find("Name_") then
            if leftItem:getName():find(value:getName():gsub("_mineL",""):gsub("Name_","")) and leftPress and leftMine and incluState then
                value:play()
            end
        end
        if value:isPlaying() then
            for _, path in pairs(bbmodels) do
                if path.mineL then path.mineL:stop() end
            end
        end
    end

    for _,value in pairs(holdRanims) do
        if value:getName():find("ID_") then
            value:setPlaying(rightItem.id:find(value:getName():gsub("_holdR",""):gsub("ID_","")) and incluState and exclude)
        elseif value:getName():find("Name_") then
            value:setPlaying(rightItem:getName():find(value:getName():gsub("_holdR",""):gsub("Name_","")) and incluState and exclude)
        end
        if value:isPlaying() then
            for _, path in pairs(bbmodels) do
                if path.holdR then path.holdR:stop() end
            end
        end
    end

    for _,value in pairs(holdLanims) do
        if value:getName():find("ID_") then
            value:setPlaying(leftItem.id:find(value:getName():gsub("_holdL",""):gsub("ID_","")) and incluState and exclude)
        elseif value:getName():find("Name_") then
            value:setPlaying(leftItem:getName():find(value:getName():gsub("_holdL",""):gsub("Name_","")) and incluState and exclude)
        end
        if value:isPlaying() then
            for _, path in pairs(bbmodels) do
                if path.holdL then path.holdL:stop() end
            end
        end
    end
end

local function animInit()
    for _, path in pairs(bbmodels) do
        for _,anim in pairs(path) do
            if anim:getName():find("_holdR") then
                holdRanims[#holdRanims+1] = anim
            end
            if anim:getName():find("_holdL") then
                holdLanims[#holdLanims+1] = anim
            end
            if anim:getName():find("_attackR") then
                attackRanims[#attackRanims+1] = anim
            end
            if anim:getName():find("_attackL") then
                attackLanims[#attackLanims+1] = anim
            end
            if anim:getName():find("_mineR") then
                mineRanims[#mineRanims+1] = anim
            end
            if anim:getName():find("_mineL") then
                mineLanims[#mineLanims+1] = anim
            end
        end
    end
end

local function tick()
    anims()
end

local GSAnimBlend
for _, key in ipairs(listFiles(nil,true)) do
    if key:find("GSAnimBlend$") then
        GSAnimBlend = require(key)
        break
    end
end
if GSAnimBlend then GSAnimBlend.safe = false end

local function blend(paths, time, itemTime)
    if not GSAnimBlend then return end
    for _, path in pairs(paths) do
        if path.walk then path.walk:blendTime(time) end
        if path.idle then path.idle:blendTime(time) end
        if path.crouch then path.crouch:blendTime(time) end
        if path.walkback then path.walkback:blendTime(time) end
        if path.sprint then path.sprint:blendTime(time) end
        if path.crouchwalk then path.crouchwalk:blendTime(time) end
        if path.crouchwalkback then path.crouchwalkback:blendTime(time) end
        if path.elytra then path.elytra:blendTime(time) end
        if path.elytradown then path.elytradown:blendTime(time) end
        if path.fly then path.fly:blendTime(time) end
        if path.flywalk then path.flywalk:blendTime(time) end
        if path.flywalkback then path.flywalkback:blendTime(time) end
        if path.flysprint then path.flysprint:blendTime(time) end
        if path.flyup then path.flyup:blendTime(time) end
        if path.flydown then path.flydown:blendTime(time) end
        if path.vehicle then path.vehicle:blendTime(time) end
        if path.sleep then path.sleep:blendTime(time) end
        if path.climb then path.climb:blendTime(time) end
        if path.climbstill then path.climbstill:blendTime(time) end
        if path.climbdown then path.climbdown:blendTime(time) end
        if path.climbcrouch then path.climbcrouch:blendTime(time) end
        if path.climbcrouchwalk then path.climbcrouchwalk:blendTime(time) end
        if path.swim then path.swim:blendTime(time) end
        if path.crawl then path.crawl:blendTime(time) end
        if path.crawlstill then path.crawlstill:blendTime(time) end
        if path.fall then path.fall:blendTime(time) end
        if path.jumpup then path.jumpup:blendTime(time) end
        if path.jumpdown then path.jumpdown:blendTime(time) end
        if path.sprintjumpup then path.sprintjumpup:blendTime(time) end
        if path.sprintjumpdown then path.sprintjumpdown:blendTime(time) end
        if path.crouchjumpup then path.crouchjumpup:blendTime(time) end
        if path.crouchjumpdown then path.crouchjumpdown:blendTime(time) end
        if path.trident then path.trident:blendTime(time) end
        if path.death then path.death:blendTime(time) end
        if path.water then path.water:blendTime(time) end
        if path.waterwalk then path.waterwalk:blendTime(time) end
        if path.waterwalkback then path.waterwalkback:blendTime(time) end
        if path.waterup then path.waterup:blendTime(time) end
        if path.waterdown then path.waterdown:blendTime(time) end
        if path.watercrouch then path.watercrouch:blendTime(time) end
        if path.watercrouchwalk then path.watercrouchwalk:blendTime(time) end
        if path.watercrouchwakback then path.watercrouchwakback:blendTime(time) end
        if path.watercrouchdown then path.watercrouchdown:blendTime(time) end
        if path.watercrouchup then path.watercrouchup:blendTime(time) end

        if path.eatR then path.eatR:blendTime(itemTime) end
        if path.eatL then path.eatL:blendTime(itemTime) end
        if path.drinkR then path.drinkR:blendTime(itemTime) end
        if path.drinkL then path.drinkL:blendTime(itemTime) end
        if path.blockR then path.blockR:blendTime(itemTime) end
        if path.blockL then path.blockL:blendTime(itemTime) end
        if path.bowR then path.bowR:blendTime(itemTime) end
        if path.bowL then path.bowL:blendTime(itemTime) end
        if path.crossbowR then path.crossbowR:blendTime(itemTime) end
        if path.crossbowL then path.crossbowL:blendTime(itemTime) end
        if path.loadR then path.loadR:blendTime(itemTime) end
        if path.loadL then path.loadL:blendTime(itemTime) end
        if path.spearR then path.spearR:blendTime(itemTime) end
        if path.spearL then path.spearL:blendTime(itemTime) end
        if path.spyglassR then path.spyglassR:blendTime(itemTime) end
        if path.spyglassL then path.spyglassL:blendTime(itemTime) end
        if path.hornR then path.hornR:blendTime(itemTime) end
        if path.hornL then path.hornL:blendTime(itemTime) end
        if path.attackR then path.attackR:blendTime(itemTime) end
        if path.attackL then path.attackL:blendTime(itemTime) end
        if path.mineR then path.mineR:blendTime(itemTime) end
        if path.mineL then path.mineL:blendTime(itemTime) end
        if path.useR then path.useR:blendTime(itemTime) end
        if path.useL then path.useL:blendTime(itemTime) end
        if path.holdR then path.holdR:blendTime(itemTime) end
        if path.holdL then path.holdL:blendTime(itemTime) end
    end
    for _,value in pairs(holdRanims) do
        value:blendTime(itemTime)
    end
    for _,value in pairs(holdLanims) do
        value:blendTime(itemTime)
    end
    for _,value in pairs(attackRanims) do
        value:blendTime(itemTime)
    end
    for _,value in pairs(attackLanims) do
        value:blendTime(itemTime)
    end
    for _,value in pairs(mineRanims) do
        value:blendTime(itemTime)
    end
    for _,value in pairs(mineLanims) do
        value:blendTime(itemTime)
    end
end

wait(20,function()
   assert(
    next(bbmodels),
   "§aCustom Script Warning: §4JimmyAnims isn't being required, or a blockbench model isn't being provided to it. \n".."§4 Put this code in a DIFFERENT script to use JimmyAnims: \n".."§flocal anims = require('JimmyAnims') \n"..
   "§fanims(animations.BBMODEL_NAME_HERE) \n".."§4 Where you replace BBMODEL_NAME_HERE with the name of your bbmodel. \n".."§4 Or go to the top of the script or to the top of the Discord forum for more complete instructions.".."§c") 
end)

local init = false
local animMT = {__call = function(self, ...)
    local paths = {...}
    local should_blend = true
    if self.autoBlend ~= nil then should_blend = self.autoBlend end

    errors(paths,self.dismiss)

    for _, v in ipairs(paths) do
        bbmodels[#bbmodels+1] = v
    end

    -- Init stuff.
    if init then return end
    animInit()
    if should_blend then blend(paths, self.excluBlendTime or 4, self.incluBlendTime or 4) end
    events.TICK:register(tick)
    init = true
end}

local function addAllAnims(...)
    for _, v in ipairs{...} do
        assert(
            type(v) == "Animation",
            "§aCustom Script Warning: §4addAllAnims was given something that isn't an animation, check its spelling for errors.§c")
      allAnims[#allAnims+1] = v
    end
end

local function addExcluAnims(...)
    for _, v in ipairs{...} do
        assert(
            type(v) == "Animation",
            "§aCustom Script Warning: §4addExcluAnims was given something that isn't an animation, check its spelling for errors.§c")
      excluAnims[#excluAnims+1] = v
    end
end

local function addIncluAnims(...)
    for _, v in ipairs{...} do
        assert(
            type(v) == "Animation",
            "§aCustom Script Warning: §4addIncluAnims was given something that isn't an animation, check its spelling for errors.§c")
      incluAnims[#incluAnims+1] = v
    end
end

-- If you're choosing to edit this script, don't put anything beneath the return line

return setmetatable(
    {
        animsList = animsList,
        addAllAnims = addAllAnims,
        addExcluAnims = addExcluAnims,
        addIncluAnims = addIncluAnims
    },
    animMT
)
