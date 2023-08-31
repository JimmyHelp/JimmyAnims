-- + Made by Jimmy Hellp
-- + V2.4 for 0.1.0 and above
-- + Thank you GrandpaScout for helping with the library stuff!
-- + Automatically compatible with GSAnimBlend for automatic smooth animation blending

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

---------

The script will automatically error if it detects an animation name with a period in it. You can dismiss this using

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
anims.blendTime = 1.5
anims.itemBlendTime = 1.5
anims.autoBlend = true
anims(animations.NAME_HERE)

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

local animsList = {
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
}

------------------------------------------------------------------------------------------------------------------------

local avatarVer = "0.1.0"
assert(
  client.compareVersions(client.getFiguraVersion(), avatarVer) > -1,
  "§aCustom Script Warning: §4Your version of Figura is out of date for this animation template, the expected version is ".. avatarVer.." or newer. \n".." Update your Figura version to "..avatarVer.." or newer.§c"
)


local function errors(paths,x)
    assert(
        next(paths),
        "§aCustom Script Warning: §4No blockbench models were found, or the blockbench model found contained no animations. \n" .." Check that there are no typos in the given bbmodel name, or that the bbmodel has animations by using this line of code at the top of your script: \n"
        .."§f logTable(animations.BBMODEL_NAME_HERE) \n ".."§4If this returns nil your bbmodel name is wrong or it has no animations. You can use \n".."§f logTable(models:getChildren()) \n".."§4 to get the name of every bbmodel in your avatar.§c"
    )

    for _, path in pairs(paths) do
        for _, anim in pairs(path) do
            if anim:getName():find("%.") and not x then
                -- delete these three lines below to remove the error v
                error(
                    "§aCustom Script Warning: §4The animation §b'"..anim:getName().."'§4 has a period ( . ) in its name, the handler can't use that animation and it must be renamed to fit the handler's accepted animation names. \n" ..
                " If the animation isn't meant for the handler, you can dismiss this error by adding §fanims.dismiss = true§4 after the require but before setting the bbmodel.§c")
            end
        end
    end
end

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
            if rightAttack or (rightMine and not path.mineR) then
                if path.attackR then path.attackR:play() end
            end
            if leftAttack or (leftMine and not path.mineL) then
                if path.attackL then path.attackL:play() end
            end
            if path.mineR and rightMine then
                path.mineR:play()
            end
            if path.mineL and leftMine then
                path.mineL:play()
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
        if path.useR and player:getSwingArm() == rightActive and not sleeping then
            path.useR:play()
        end
        if path.useL and player:getSwingArm() == leftActive and not sleeping then
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

local function bodyAnims()
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
    local grounded = playerGround:isSolidBlock() or player:isOnGround()
    local pv = velocity:mul(1, 0, 1):normalize()
    local pl = models:partToWorldMatrix():applyDir(0,0,-1):mul(1, 0, 1):normalize()
    local fwd = pv:dot(pl)
    local backwards = fwd < -.8

    -- canJump stuff
    local webbed = world.getBlockState(player:getPos()).id == "minecraft:cobweb"
    local ladder = player:isClimbing() and not grounded

    local canJump = not (inLiquid or webbed)

    oldhp = hp
    hp = player:getHealth() + player:getAbsorptionAmount()

    if holdingJ and canJump then hasJumped = true end
    if grounded and not holdingJ then hasJumped = false end

    local neverJump = not (gliding or spin or sleeping or swimming or ladder or sitting)
    local jumpingUp = hasJumped and goingUp and neverJump
    local jumpingDown = hasJumped and goingDown and not falling and neverJump
    local isJumping = jumpingUp or jumpingDown or falling
    local sprinting = sprinty and standing and not inLiquid
    local walking = moving and not sprinting and not isJumping and not sitting
    local forward = walking and not backwards
    local backward = walking and backwards

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
    local idleState = not moving and standing and not isJumping and not sitting and not creativeFlying and not ladder and not inWater or (sleepState and not path.sleep) or (vehicleState and not path.vehicle)
    or ((waterState and not waterwalkState) and not path.water) or ((flyState and not flywalkState) and not path.fly)

    local deadState = hp <= 0

    -- anim play testing
        if path.hurt and (oldhp > hp and hp ~= 0 and oldhp ~= 0) then
            path.hurt:restart()
        end

        if path.idle then path.idle:playing(idleState) end
        if path.walk then path.walk:playing(walkState) end
        if path.walkback then path.walkback:playing(walkbackState) end
        if path.sprint then path.sprint:playing(sprintState) end
        if path.sprintjumpup then path.sprintjumpup:playing(sprintjumpupState) end
        if path.sprintjumpdown then path.sprintjumpdown:playing(sprintjumpdownState) end
        if path.crouch then path.crouch:playing(crouchState) end
        if path.crouchwalk then path.crouchwalk:playing(crouchwalkState) end
        if path.crouchwalkback then path.crouchwalkback:playing(crouchwalkbackState) end
        if path.crouchjumpup then path.crouchjumpup:playing(crouchjumpupState) end
        if path.crouchjumpdown then path.crouchjumpdown:playing(crouchjumpdownState) end
        if path.jumpup then path.jumpup:playing(jumpupState) end
        if path.jumpdown then path.jumpdown:playing(jumpdownState) end
        if path.fall then path.fall:playing(fallState) end
        if path.elytra then path.elytra:playing(elytraState) end
        if path.elytradown then path.elytradown:playing(elytradownState) end
        if path.trident then path.trident:playing(tridentState) end
        if path.sleep then path.sleep:playing(sleepState) end
        if path.swim then path.swim:playing(swimState) end
        if path.vehicle then path.vehicle:playing(vehicleState) end
        if path.crawl then path.crawl:playing(crawlState) end
        if path.crawlstill then path.crawlstill:playing(crawlstillState) end
        if path.fly then path.fly:playing(flyState) end
        if path.flywalk then path.flywalk:playing(flywalkState) end
        if path.flywalkback then path.flywalkback:playing(flywalkbackState) end
        if path.flysprint then path.flysprint:playing(flysprintState) end
        if path.flyup then path.flyup:playing(flyupState) end
        if path.flydown then path.flydown:playing(flydownState) end
        if path.climb then path.climb:playing(climbState) end
        if path.climbstill then path.climbstill:playing(climbstillState) end
        if path.climbdown then path.climbdown:playing(climbdownState) end
        if path.climbcrouch then path.climbcrouch:playing(climbcrouchState) end
        if path.climbcrouchwalk then path.climbcrouchwalk:playing(climbcrouchwalkState) end
        if path.water then path.water:playing(waterState) end
        if path.waterwalk then path.waterwalk:playing(waterwalkState) end
        if path.waterwalkback then path.waterwalkback:playing(waterwalkbackState) end
        if path.waterup then path.waterup:playing(waterupState) end
        if path.waterdown then path.waterdown:playing(waterdownState) end
        if path.watercrouch then path.watercrouch:playing(watercrouchState) end
        if path.watercrouchwalk then path.watercrouchwalk:playing(watercrouchwalkState) end
        if path.watercrouchwalkback then path.watercrouchwalkback:playing(watercrouchwalkbackState) end
        if path.watercrouchdown then path.watercrouchdown:playing(watercrouchdownState) end
        if path.watercrouchup then path.watercrouchup:playing(watercrouchupState) end

        if path.death then path.death:playing(deadState) end
    end
end

local function handAnims()
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

    local rightItem = player:getHeldItem(handedness)
    local leftItem = player:getHeldItem(not handedness)
    local usingR = activeness == rightActive and rightItem:getUseAction()
    local usingL = activeness == leftActive and leftItem:getUseAction()

    local crossR = rightItem.tag and rightItem.tag["Charged"] == 1
    local crossL = leftItem.tag and leftItem.tag["Charged"] == 1

    local drinkingRState = using and usingR == "DRINK"
    local drinkingLState = using and usingL == "DRINK"

    local eatingRState = (using and usingR == "EAT")
    local eatingLState = (using and usingL == "EAT")

    local blockingRState = using and usingR == "BLOCK"
    local blockingLState = using and usingL == "BLOCK"

    local bowRState = using and usingR == "BOW"
    local bowLState = using and usingL == "BOW"

    local spearRState = using and usingR == "SPEAR"
    local spearLState = using and usingL == "SPEAR"

    local spyglassRState = using and usingR == "SPYGLASS"
    local spyglassLState = using and usingL == "SPYGLASS"

    local hornRState = using and usingR == "TOOT_HORN"
    local hornLState = using and usingL == "TOOT_HORN"

    local loadingRState = using and usingR == "CROSSBOW"
    local loadingLState = using and usingL == "CROSSBOW"

    local rightHoldState = rightItem.id ~= "minecraft:air" and not (using or crossR or crossL)
    local leftHoldState = leftItem.id ~= "minecraft:air" and not (using or crossL or crossR)

    local swingDuration = player:getSwingDuration()

    for _, path in pairs(bbmodels) do
        if path.mineR and leftPress and rightMine then
            path.mineR:play()
        elseif path.attackR and leftPress and rightMine then
            path.attackR:play()
        end
        if path.mineL and leftPress and leftMine then
            path.mineL:play()
        elseif path.attackL and leftPress and leftMine then
            path.attackL:play()
        end
        
        if path.useR and rightPress and rightSwing then
            path.useR:play()
        end
        if path.useL and rightPress and leftSwing then
            path.useL:play()
        end

        if path.useR then path.useR:speed((path.useR:getLength()*20)/swingDuration) end
        if path.useL then path.useL:speed((path.useL:getLength()*20)/swingDuration) end
        if path.attackR then path.attackR:speed((path.attackR:getLength()*20)/swingDuration) end
        if path.attackL then path.attackL:speed((path.attackL:getLength()*20)/swingDuration) end
        if path.mineR then path.mineR:speed((path.mineR:getLength()*20)/swingDuration) end
        if path.mineL then path.mineL:speed((path.mineL:getLength()*20)/swingDuration) end

        if path.eatingR then path.eatingR:playing(eatingRState or (drinkingRState and not path.drinkingR)) end
        if path.eatingL then path.eatingL:playing(eatingLState or (drinkingLState and not path.drinkingL)) end
        if path.drinkingR then path.drinkingR:playing(drinkingRState) end
        if path.drinkingL then path.drinkingL:playing(drinkingLState) end
        if path.blockingR then path.blockingR:playing(blockingRState) end
        if path.blockingL then path.blockingL:playing(blockingLState) end
        if path.bowR then path.bowR:playing(bowRState) end
        if path.bowL then path.bowL:playing(bowLState) end
        if path.loadingR then path.loadingR:playing(loadingRState) end
        if path.loadingL then path.loadingL:playing(loadingLState) end
        if path.crossbowR then path.crossbowR:playing(crossR) end
        if path.crossbowL then path.crossbowL:playing(crossL) end
        if path.spearR then path.spearR:playing(spearRState) end
        if path.spearL then path.spearL:playing(spearLState) end
        if path.spyglassR then path.spyglassR:playing(spyglassRState) end
        if path.spyglassL then path.spyglassL:playing(spyglassLState) end
        if path.hornR then path.hornR:playing(hornRState) end
        if path.hornL then path.hornL:playing(hornLState) end
        if path.holdR then path.holdR:playing(rightHoldState) end
        if path.holdL then path.holdL:playing(leftHoldState) end
    end
end

local function tick()
    bodyAnims()
    handAnims()
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

        if path.eatingR then path.eatingR:blendTime(itemTime) end
        if path.eatingL then path.eatingL:blendTime(itemTime) end
        if path.drinkingR then path.drinkingR:blendTime(itemTime) end
        if path.drinkingL then path.drinkingL:blendTime(itemTime) end
        if path.blockingR then path.blockingR:blendTime(itemTime) end
        if path.blockingL then path.blockingL:blendTime(itemTime) end
        if path.bowR then path.bowR:blendTime(itemTime) end
        if path.bowL then path.bowL:blendTime(itemTime) end
        if path.crossbowR then path.crossbowR:blendTime(itemTime) end
        if path.crossbowL then path.crossbowL:blendTime(itemTime) end
        if path.loadingR then path.loadingR:blendTime(itemTime) end
        if path.loadingL then path.loadingL:blendTime(itemTime) end
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

    if should_blend then blend(paths, self.blendTime or 1.5, self.itemBlendTime or 1.5) end

    for _, v in ipairs(paths) do
        bbmodels[#bbmodels+1] = v
    end

    -- Init stuff.
    if init then return end
    events.TICK:register(tick)
    init = true
end}

-- If you're choosing to edit this script, don't put anything beneath the return line

return setmetatable({animsList = animsList}, animMT)
