-- + Made by Jimmy Hellp
-- + V7 for 0.1.0 and above
-- + Thank you GrandpaScout for helping with the library stuff!
-- + Automatically compatible with GSAnimBlend for automatic smooth animation blending
-- + Also includes Manuel's Run Later script

------------------------------------------------------------------------------------------------------------------------

local animsList = {
    exclu = {    
        "idle", -- idling
        "walk", -- walking
        "walkback", -- walking backwards

        "jumpup", -- jumping up caused via the jump key
        "jumpdown", -- jumping down after a jump up
        "fall", -- falling after a while

        "sprint", -- sprinting
        "sprintjumpup", -- sprinting and jumping up caused via the jump key
        "sprintjumpdown", -- sprinting and jumping down after a jump up

        "crouch", -- crouching
        "crouchwalk", -- crouching and walking
        "crouchwalkback", -- crouching and walking backwards
        "crouchjumpup", -- crouching and jumping up caused via the jump key
        "crouchjumpdown", -- crouching and jumping down after a jump up

        "elytra", -- elytra flying
        "elytradown", -- flying down/diving while elytra flying

        "trident",-- riptide trident lunging
        "sleep", -- sleeping
        "swim", -- while swimming

        "sit", -- while in any vehicle or modded sitting
        "sitmove", -- while in any vehicle and moving
        "sitmoveback", -- while in any vehicle and moving backwards
        "sitjumpup", -- while in any vehicle and jumping up
        "sitjumpdown", -- while in any vehicle and jumping down
        "sitpass", -- while in any vehicle as a passenger

        "crawl", -- crawling and moving
        "crawlstill", -- crawling and still

        "fly", -- creative flying
        "flywalk", -- flying and moving
        "flywalkback", -- flying and moving backwards
        "flysprint",  -- flying and sprinting
        "flyup", -- flying and going up
        "flydown", -- flying and going down

        "climb", -- climbing a ladder
        "climbstill", -- not moving on a ladder without crouching (hitting a ceiling usually)
        "climbdown", -- going down a ladder
        "climbcrouch", -- crouching on a ladder
        "climbcrouchwalk", -- crouching on a ladder and moving

        "water", -- being in water without swimming
        "waterwalk", -- in water and moving
        "waterwalkback", -- in water and moving backwards
        "waterup", -- in water and going up
        "waterdown", -- in water and going down
        "watercrouch", -- in water and crouching
        "watercrouchwalk", -- in water and crouching and walking
        "watercrouchwalkback", -- in water and crouching and walking backwards
        "watercrouchdown", -- in water and crouching and going down
        "watercrouchup", -- in water and crouching and going up. only possible in bubble columns

        "hurt", -- MUST BE IN PLAY ONCE LOOP MODE. when hurt
        "death", -- dying
    },
    inclu = {
        "attackR", -- MUST BE IN PLAY ONCE LOOP MODE. attacking with the right hand
        "attackL", -- MUST BE IN PLAY ONCE LOOP MODE. attacking with the left hand
        "mineR", -- MUST BE IN PLAY ONCE LOOP MODE. mining with the right hand
        "mineL", -- MUST BE IN PLAY ONCE LOOP MODE. mining with the left hand

        "eatR", -- eating from the right hand
        "eatL", -- eating from the left hand
        "drinkR", -- drinking from the right hand
        "drinkL", -- drinking from the left hand
        "blockR", -- blocking from the right hand
        "blockL", -- blocking from the left hand
        "bowR", -- drawing back a bow from the right hand
        "bowL", -- drawing back a bow from the left hand
        "loadR", -- loading a crossbow from the right hand
        "loadL", -- loading a crossbow from the left hand
        "crossbowR", -- holding a loaded crossbow in the right hand
        "crossbowL", -- holding a loaded crossbow in the left hand
        "spearR", -- holding up a trident in the right hand
        "spearL", -- holding up a trident in the left hand
        "spyglassR", -- holding up a spyglass from the right hand
        "spyglassL", -- holding up a spyglass from the left hand
        "hornR", -- using a horn in the right hand
        "hornL", -- using a horn in the left hand
        "brushR", -- using a brush in the right hand
        "brushL", -- using a brush in the left hand

        "holdR", -- holding an item in the right hand
        "holdL" -- holding an item in the left hand
    }
}

local states = {}

local function errors(paths,dismiss)
    assert(
        next(paths),
        "§aCustom Script Warning: §6No blockbench models were found, or the blockbench model found contained no animations. \n" .." Check that there are no typos in the given bbmodel name, or that the bbmodel has animations by using this line of code at the top of your script: \n"
        .."§f logTable(animations.BBMODEL_NAME_HERE) \n ".."§6If this returns nil your bbmodel name is wrong or it has no animations. You can use \n".."§f logTable(models:getChildren()) \n".."§6 to get the name of every bbmodel in your avatar.§c"
    )

    if type(paths[1])=="ModelPart" then error("You need to do animations.BBMODEL_NAME not models.BBMODEL_NAME",3) end

    for _, path in pairs(paths) do
        for _, anim in pairs(path) do
            if anim:getName():find("%.") and not dismiss then
                error(
                    "§aCustom Script Warning: §6The animation §b'"..anim:getName().."'§6 has a period ( . ) in its name, the handler can't use that animation and it must be renamed to fit the handler's accepted animation names. \n" ..
                " If the animation isn't meant for the handler, you can dismiss this error by adding §fanims.dismiss = true§6 after the require but before setting the bbmodel.§c",3)
            end
        end
    end
end

local setAllOnVar = true
local setIncluOnVar = true
local setExcluOnVar = true

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
local oneJump = false

local rightResult
local leftResult

local cFlying = false
local oldcFlying = cFlying
local flying = false
local updateTimer = 0
local flyinit = false
local distinit = false

local dist = 4.5
local oldDist = dist
local reach = 4.5

local yvel
local cooldown

local grounded
local oldgrounded

local fallVel = -0.6

local targetBlock
local hitBlock
local blockSuccess
local blockResult
local oldhitBlock

---- Run Later by manuel_2867 ----
local tmrs={}
local t=0
---Schedules a function to run after a certain amount of ticks
---@param ticks number|function Amount of ticks to wait, or a predicate function to check each tick until it returns true
---@param next function Function to run after amount of ticks, or after the predicate function returned true
local function wait(ticks,next)
    local x=type(ticks)=="number"
    table.insert(tmrs,{t=x and t+ticks,p=x and function()end or ticks,n=next})
end
function events.TICK()
    t=t+1
    for key,timer in pairs(tmrs) do
        if timer.p()or(timer.t and t >= timer.t)then
            timer.n()
            tmrs[key]=nil
        end
    end
end

local bbmodels = {} -- don't put things in here

function pings.JimmyAnims_cFly(x)
    flying = x
end

function pings.JimmyAnims_Distance(x)
    reach = x
end

function pings.JimmyAnims_Update(fly,dis)
    flying = fly
    reach = dis
end

local prev
local function JimmyAnims_Swing(anim)
    -- test how this works with multiple bbmodels
    for _,path in pairs(bbmodels) do
        if path[prev] then path[prev]:stop() end
        if path[anim] then path[anim]:play() end
        prev = anim
    end
end

local function anims()
    for _, value in ipairs(allAnims) do
        local exists, hold = pcall(value.isHolding,value)
        if value:isPlaying() or (exists and hold) then
            animsTable.allVar = true
            break
        else
            animsTable.allVar = false or not setAllOnVar
        end
    end
    if next(allAnims) == nil then
        animsTable.allVar = not setAllOnVar
    end

    for _, value in ipairs(excluAnims) do
        local exists, hold = pcall(value.isHolding,value)
        if value:isPlaying() or (exists and hold) then
            animsTable.excluVar = true
            break
        else
            animsTable.excluVar = false or not setExcluOnVar
        end
    end
    if next(excluAnims) == nil then
        animsTable.excluVar = not setExcluOnVar
    end

    for _, value in ipairs(incluAnims) do
        local exists, hold = pcall(value.isHolding,value)
        if value:isPlaying() or (exists and hold) then
            animsTable.incluVar = true
            break
        else
            animsTable.incluVar = false or not setIncluOnVar
        end
    end
    if next(incluAnims) == nil then
        animsTable.incluVar = not setIncluOnVar
    end

    excluState = not animsTable.allVar and not animsTable.excluVar
    incluState = not animsTable.allVar and not animsTable.incluVar

    if host:isHost() then
        if flyinit and not distinit then
            cFlying = host:isFlying()
            if cFlying ~= oldcFlying then
                pings.JimmyAnims_cFly(cFlying)
            end
            oldcFlying = cFlying

            updateTimer = updateTimer + 1
            if updateTimer % 200 == 0 then
                pings.JimmyAnims_cFly(cFlying)
            end
        elseif distinit and not flyinit then
            dist = host:getReachDistance()
            if dist ~= oldDist then
                pings.JimmyAnims_Distance(dist)
            end
            oldDist = dist

            updateTimer = updateTimer + 1
            if updateTimer % 200 == 0 then
                pings.JimmyAnims_Distance(dist)
            end
        elseif distinit and flyinit then
            cFlying = host:isFlying()
            if cFlying ~= oldcFlying then
                pings.JimmyAnims_cFly(cFlying)
            end
            oldcFlying = cFlying

            dist = host:getReachDistance()
            if dist ~= oldDist then
                pings.JimmyAnims_Distance(dist)
            end
            oldDist = dist

            updateTimer = updateTimer + 1
            if updateTimer % 200 == 0 then
                pings.JimmyAnims_Update(cFlying,dist)
            end
        end
    end

    local pose = player:getPose()
    local velocity = player:getVelocity()
    local moving = velocity.xz:length() > 0.01
    local sprinty = player:isSprinting()
    local vehicle = player:getVehicle()
    local sitting = vehicle ~= nil or pose == "SITTING" -- if you're reading this code and see this, "SITTING" isn't a vanilla pose, this is for mods
    local passenger = vehicle and vehicle:getControllingPassenger() ~= player
    local creativeFlying = flying and not sitting
    local standing = pose == "STANDING"
    local crouching = pose == "CROUCHING" and not creativeFlying
    local gliding = pose == "FALL_FLYING"
    local spin = pose == "SPIN_ATTACK"
    local sleeping = pose == "SLEEPING"
    local swimming = pose == "SWIMMING"
    local inWater = player:isUnderwater() and not sitting
    local inLiquid = player:isInWater() or player:isInLava()
    local liquidSwim = swimming and inLiquid
    local crawling = swimming and not inLiquid

    -- hasJumped stuff
    
    yvel = velocity.y
    local hover = yvel < .01 and yvel > -.01
    local goingUp = yvel > .01
    local goingDown =  yvel < -.01
    local falling = yvel < fallVel
    local playerGround = world.getBlockState(player:getPos():add(0,-.1,0))
    local vehicleGround = sitting and world.getBlockState(vehicle:getPos():add(0,-.1,0))
    oldgrounded = grounded
    grounded = playerGround:isSolidBlock() or player:isOnGround() or (sitting and vehicleGround:isSolidBlock() or sitting and vehicle:isOnGround())

    local pv = velocity:mul(1, 0, 1):normalize()
    local pl = models:partToWorldMatrix():applyDir(0,0,-1):mul(1, 0, 1):normalize()
    local fwd = pv:dot(pl)
    local backwards = fwd < -.8
    --local sideways = pv:cross(pl)
    --local right = sideways.y > .6
    --local left = sideways.y < -.6

    -- canJump stuff
    local webbed = world.getBlockState(player:getPos()).id == "minecraft:cobweb"
    local ladder = player:isClimbing() and not grounded and not flying

    local canJump = not (inLiquid or webbed or grounded)

    local hp = player:getHealth() + player:getAbsorptionAmount()

    if oldgrounded ~= grounded and not grounded and yvel > 0 then
        cooldown = true
        wait(10,function() cooldown = false end)
    end

    if (oldgrounded ~= grounded and not grounded and yvel > 0) and canJump then hasJumped = true end
    if (grounded and (yvel <= 0 and yvel > -0.1)) or (gliding or inLiquid) then hasJumped = false end

    local neverJump = not (gliding or spin or sleeping or swimming or ladder)
    local jumpingUp = hasJumped and goingUp and neverJump
    local jumpingDown = hasJumped and goingDown and not falling and neverJump or (cooldown and not jumpingUp)
    local isJumping = jumpingUp or jumpingDown or falling
    local sprinting = sprinty and standing and not inLiquid and not sitting
    local walking = moving and not sprinting and not isJumping and not sitting
    local forward = walking and not backwards
    local backward = walking and backwards

    -- we be holding items tho
    local handedness = player:isLeftHanded()
    local rightActive = handedness and "OFF_HAND" or "MAIN_HAND"
    local leftActive = not handedness and "OFF_HAND" or "MAIN_HAND"
    local activeness = player:getActiveHand()
    local using = player:isUsingItem()
    local rightSwing = player:getSwingArm() == rightActive and not sleeping
    local leftSwing = player:getSwingArm() == leftActive and not sleeping
    local swingTime = player:getSwingTime() == 1
    local targetEntity = type(player:getTargetedEntity()) == "PlayerAPI" or type(player:getTargetedEntity()) == "LivingEntityAPI"
    local rightMine = rightSwing and oldhitBlock and not targetEntity
    local leftMine = leftSwing and oldhitBlock and not targetEntity
    local rightAttack = rightSwing and (not oldhitBlock or targetEntity)
    local leftAttack = leftSwing and (not oldhitBlock or targetEntity)
    local rightItem = player:getHeldItem(handedness)
    local leftItem = player:getHeldItem(not handedness)
    local rightSuccess = pcall(rightItem.getUseAction,rightItem)
    if rightSuccess then rightResult = rightItem:getUseAction() else rightResult = "NONE" end
    local usingR = activeness == rightActive and rightResult
    local leftSuccess = pcall(leftItem.getUseAction,leftItem)
    if leftSuccess then leftResult = leftItem:getUseAction() else leftResult = "NONE" end
    local usingL = activeness == leftActive and leftResult
    local rTag= rightItem.tag
    local lTag = leftItem.tag

    local crossbowRState = rTag and (rTag["Charged"] == 1 or (rTag["ChargedProjectiles"] and next(rTag["ChargedProjectiles"])~= nil))
    local crossbowLState = lTag and (lTag["Charged"] == 1 or (lTag["ChargedProjectiles"] and next(lTag["ChargedProjectiles"])~= nil))

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

    local brushRState = using and usingR == "BRUSH"
    local brushLState = using and usingL == "BRUSH"

    local exclude = not (using or crossbowRState or crossbowLState)
    local rightHoldState = rightItem.id ~= "minecraft:air" and exclude
    local leftHoldState = leftItem.id ~= "minecraft:air" and exclude

    -- anim states
    for key, path in pairs(bbmodels) do
        states[key] = {}
        states[key]["exclu"] = {}
        local ex = states[key]["exclu"]
        ex.flywalkbackState = creativeFlying and backward and (not (goingDown or goingUp))
        ex.flysprintState = creativeFlying and sprinting and not isJumping and (not (goingDown or goingUp))
        ex.flyupState = creativeFlying and goingUp
        ex.flydownState = creativeFlying and goingDown
        ex.flywalkState = creativeFlying and forward and (not (goingDown or goingUp)) and not sleeping or (ex.flysprintState and not path.flysprint) or (ex.flywalkbackState and not path.flywalkback)
        or (ex.flyupState and not path.flyup) or (ex.flydownState and not path.flydown)
        ex.flyState = creativeFlying and not sprinting and not moving and standing and not isJumping and (not (goingDown or goingUp)) and not sleeping or (ex.flywalkState and not path.flywalk) 

        ex.watercrouchwalkbackState = inWater and crouching and backward and not goingDown
        ex.watercrouchwalkState = inWater and crouching and forward and not (goingDown or goingUp) or (ex.watercrouchwalkbackState and not path.watercrouchwalkback)
        ex.watercrouchupState = inWater and crouching and goingUp
        ex.watercrouchdownState = inWater and crouching and goingDown or (ex.watercrouchupState and not path.watercrouchup)
        ex.watercrouchState = inWater and crouching and not moving and not (goingDown or goingUp) or (ex.watercrouchdownState and not path.watercrouchdown) or (ex.watercrouchwalkState and not path.watercrouchwalk)

        ex.waterdownState = inWater and goingDown and not falling and standing and not creativeFlying
        ex.waterupState = inWater and goingUp and standing and not creativeFlying
        ex.waterwalkbackState = inWater and backward and hover and standing and not creativeFlying
        ex.waterwalkState = inWater and forward and hover and standing and not creativeFlying or (ex.waterwalkbackState and not path.waterwalkback) or (ex.waterdownState and not path.waterdown)
        or (ex.waterupState and not path.waterup)
        ex.waterState = inWater and not moving and standing and hover and not creativeFlying or (ex.waterwalkState and not path.waterwalk)
        
        ex.crawlstillState = crawling and not moving
        ex.crawlState = crawling and moving or (ex.crawlstillState and not path.crawlstill)

        ex.swimState = liquidSwim or (ex.crawlState and not path.crawl)

        ex.elytradownState = gliding and goingDown
        ex.elytraState = gliding and not goingDown or (ex.elytradownState and not path.elytradown)

        ex.sitpassState = passenger and standing
        ex.sitjumpdownState = sitting and not passenger and standing and (jumpingDown or falling)
        ex.sitjumpupState = sitting and not passenger and jumpingUp and standing or (ex.sitjumpdownState and not path.sitjumpdown)
        ex.sitmovebackState = sitting and not passenger and not isJumping and backwards and standing
        ex.sitmoveState = velocity:length() > 0 and not passenger and not backwards and standing and sitting and not isJumping or (ex.sitmovebackState and not path.sitmoveback) or (ex.sitjumpupState and not path.sitjumpup)
        ex.sitState = sitting and not passenger and velocity:length() == 0 and not isJumping and standing or (ex.sitmoveState and not path.sitmove) or (ex.sitpassState and not path.sitpass)

        ex.tridentState = spin
        ex.sleepState = sleeping

        ex.climbcrouchwalkState = ladder and crouching and (moving or yvel ~= 0)
        ex.climbcrouchState = ladder and crouching and hover and not moving or (ex.climbcrouchwalkState and not path.climbcrouchwalk)
        ex.climbdownState = ladder and goingDown
        ex.climbstillState = ladder and not crouching and hover
        ex.climbState = ladder and goingUp and not crouching or (ex.climbdownState and not path.climbdown) or (ex.climbstillState and not path.climbstill)

        ex.crouchjumpdownState = crouching and jumpingDown and not ladder and not inWater
        ex.crouchjumpupState = crouching and jumpingUp and not ladder or (not oneJump and (ex.crouchjumpdownState and not path.crouchjumpdown))
        ex.crouchwalkbackState = backward and crouching and not ladder and not inWater or (ex.watercrouchwalkbackState and not path.watercrouchwalkback and not path.watercrouchwalk and not path.watercrouch)
        ex.crouchwalkState = forward and crouching and not ladder and not inWater or (ex.crouchwalkbackState and not path.crouchwalkback) or (not oneJump and (ex.crouchjumpupState and not path.crouchjumpup)) or ((ex.watercrouchwalkState and not ex.watercrouchwalkbackState) and not path.watercrouchwalk and not path.watercrouch)
        ex.crouchState = crouching and not walking and not isJumping and not ladder and not inWater and not cooldown or (ex.crouchwalkState and not path.crouchwalk) or (ex.climbcrouchState and not path.climbcrouch) or ((ex.watercrouchState and not ex.watercrouchwalkState) and not path.watercrouch)
        
        ex.fallState = falling and not gliding and not creativeFlying and not sitting
        
        ex.sprintjumpdownState = jumpingDown and sprinting and not creativeFlying and not ladder
        ex.sprintjumpupState = jumpingUp and sprinting and not creativeFlying and not ladder or (not oneJump and (ex.sprintjumpdownState and not path.sprintjumpdown))
        ex.jumpdownState = jumpingDown and not sprinting and not crouching and not sitting and not sleeping and not gliding and not creativeFlying and not spin and not inWater or (ex.fallState and not path.fall) or (oneJump and (ex.sprintjumpdownState and not path.sprintjumpdown)) or (oneJump and (ex.crouchjumpdownState and not path.crouchjumpdown))
        ex.jumpupState = jumpingUp and not sprinting and not crouching and not sitting and not creativeFlying and not inWater or (ex.jumpdownState and not path.jumpdown) or (ex.tridentState and not path.trident) or (oneJump and (ex.sprintjumpupState and not path.sprintjumpup)) or (oneJump and (ex.crouchjumpupState and not path.crouchjumpup))

        ex.sprintState = sprinting and not isJumping and not creativeFlying and not ladder and not cooldown or (not oneJump and (ex.sprintjumpupState and not path.sprintjumpup))
        ex.walkbackState = backward and standing and not creativeFlying and not ladder and not inWater or (ex.flywalkbackState and not path.flywalkback and not path.flywalk and not path.fly)
        ex.walkState = forward and standing and not creativeFlying and not ladder and not inWater and not cooldown or (ex.walkbackState and not path.walkback) or (ex.sprintState and not path.sprint) or (ex.climbState and not path.climb) 
        or (ex.swimState and not path.swim) or (ex.elytraState and not path.elytra) or (ex.jumpupState and not path.jumpup) or (ex.waterwalkState and (not path.waterwalk and not path.water)) or ((ex.flywalkState and not ex.flywalkbackState) and not path.flywalk and not path.fly)
        or (ex.crouchwalkState and not (path.crouchwalk or path.crouch))
        ex.idleState = not moving and not sprinting and standing and not isJumping and not sitting and not creativeFlying and not ladder and not inWater or (ex.sleepState and not path.sleep) or (ex.sitState and not path.sit)
        or ((ex.waterState and not ex.waterwalkState) and not path.water) or ((ex.flyState and not ex.flywalkState) and not path.fly) or ((ex.crouchState and not ex.crouchwalkState) and not path.crouch)

        ex.deathState = hp <= 0

        for _, value in pairs(animsList.exclu) do
            if path[value] then path[value]:setPlaying(excluState and ex[value.."State"]) end
        end

    -- anim play testing
        if path.hurt and player:getNbt().HurtTime == 9 then
            path.hurt:restart()
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
        if path.crossbowR then path.crossbowR:playing(incluState and crossbowRState) end
        if path.crossbowL then path.crossbowL:playing(incluState and crossbowLState) end
        if path.spearR then path.spearR:playing(incluState and spearRState) end
        if path.spearL then path.spearL:playing(incluState and spearLState) end
        if path.spyglassR then path.spyglassR:playing(incluState and spyglassRState) end
        if path.spyglassL then path.spyglassL:playing(incluState and spyglassLState) end
        if path.hornR then path.hornR:playing(incluState and hornRState) end
        if path.hornL then path.hornL:playing(incluState and hornLState) end
        if path.brushR then path.brushR:playing(incluState and brushRState) end
        if path.brushL then path.brushL:playing(incluState and brushLState) end

        if path.holdR then path.holdR:playing(incluState and rightHoldState) end
        if path.holdL then path.holdL:playing(incluState and leftHoldState) end
    end

    if swingTime then
        local specialAttack = false
        if rightAttack and incluState then
            for _, value in pairs(attackRanims) do
                if value:getName():find("ID_") then
                    if rightItem.id:find(value:getName():gsub("_attackR",""):gsub("ID_","")) then
                        JimmyAnims_Swing(value:getName())
                        specialAttack = true
                    end
                elseif value:getName():find("Name_") then
                    if rightItem:getName():find(value:getName():gsub("_attackR",""):gsub("Name_","")) then
                        JimmyAnims_Swing(value:getName())
                        specialAttack = true
                    end
                end
            end
            if not specialAttack then
                JimmyAnims_Swing("attackR")
            end
        elseif leftAttack and incluState then
            for _, value in pairs(attackLanims) do
                if value:getName():find("ID_") then
                    if leftItem.id:find(value:getName():gsub("_attackL",""):gsub("ID_","")) then
                        JimmyAnims_Swing(value:getName())
                        specialAttack = true
                    end
                elseif value:getName():find("Name_") then
                    if leftItem:getName():find(value:getName():gsub("_attackL",""):gsub("Name_","")) then
                        JimmyAnims_Swing(value:getName())
                        specialAttack = true
                    end
                end
            end
            if specialAttack == false then
                JimmyAnims_Swing("attackL")
            end
        elseif rightMine and incluState then
            for _, value in pairs(mineRanims) do
                if value:getName():find("ID_") then
                    if rightItem.id:find(value:getName():gsub("_mineR",""):gsub("ID_","")) then
                        JimmyAnims_Swing(value:getName())
                        specialAttack = true
                    end
                elseif value:getName():find("Name_") then
                    if rightItem:getName():find(value:getName():gsub("_mineR",""):gsub("Name_","")) then
                        JimmyAnims_Swing(value:getName())
                        specialAttack = true
                    end
                end
            end
            if not specialAttack then
                JimmyAnims_Swing("mineR")
            end
        elseif leftMine and incluState then
            for _, value in pairs(mineLanims) do
                if value:getName():find("ID_") then
                    if leftItem.id:find(value:getName():gsub("_mineL",""):gsub("ID_","")) then
                        JimmyAnims_Swing(value:getName())
                        specialAttack = true
                    end
                elseif value:getName():find("Name_") then
                    if leftItem:getName():find(value:getName():gsub("_mineL",""):gsub("Name_","")) then
                        JimmyAnims_Swing(value:getName())
                        specialAttack = true
                    end
                end
            end
            if not specialAttack then
                JimmyAnims_Swing("mineL")
            end
        end
    end 

    for _,value in pairs(holdRanims) do
        if value:getName():find("ID_") then
            value:setPlaying(rightItem.id:find(value:getName():gsub("_holdR",""):gsub("ID_","")) and incluState and exclude)
        elseif value:getName():find("Name_") then
            value:setPlaying(rightItem:getName():find(value:getName():gsub("_holdR",""):gsub("Name_","")) and incluState and exclude)
        end
        local exists, hold = pcall(value.isHolding,value)
        if value:isPlaying() or (exists and hold) then
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
        local exists, hold = pcall(value.isHolding,value)
        if value:isPlaying() or (exists and hold) then
            for _, path in pairs(bbmodels) do
                if path.holdL then path.holdL:stop() end
            end
        end
    end
    oldhitBlock = hitBlock
    targetBlock = player:getTargetedBlock(true, reach)
    blockSuccess, blockResult = pcall(targetBlock.getTextures, targetBlock)
    if blockSuccess then hitBlock = not (next(blockResult) == nil) else hitBlock = true end
end

local attackinit = true
local function animInit()
    for _, path in pairs(bbmodels) do
        for _,anim in pairs(path) do
            if (anim:getName():find("attackR") or anim:getName():find("attackL") or anim:getName():find("mineR") or anim:getName():find("mineL")) and attackinit then
                attackinit = false
                distinit = true
            end
            if anim:getName():find("^fly") then
                flyinit = true
            end
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
        for _,name in pairs(animsList.exclu) do
           if path[name] then 
              path[name]:blendTime(time)
           end
        end
        for _,name in pairs(animsList.inclu) do
            if path[name] then 
               path[name]:blendTime(itemTime)
            end
         end
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
   "§aCustom Script Warning: §6JimmyAnims isn't being required, or a blockbench model isn't being provided to it. \n".."§6 Put this code in a DIFFERENT script to use JimmyAnims: \n".."§flocal anims = require('JimmyAnims') \n"..
   "§fanims(animations.BBMODEL_NAME_HERE) \n".."§6 Where you replace BBMODEL_NAME_HERE with the name of your bbmodel. \n".."§6 Or go to the top of the script or to the top of the Discord forum for more complete instructions.".."§c") 
end)

local init = false
local animMT = {__call = function(self, ...)
    local paths = {...}
    local should_blend = true
    if self.autoBlend ~= nil then should_blend = self.autoBlend end
    if self.fall ~= nil then fallVel = self.fall end

    errors(paths,self.dismiss)

    for _, v in ipairs(paths) do
        bbmodels[#bbmodels+1] = v
    end
    if #bbmodels >= 64 then
        error(
            "§aCustom Script Warning: §6You've reached the max limit of 64 bbmodels that can be added to JimmyAnims. To save your FPS the script has been stopped. \n"..
            "To prevent this from happening accidentally you should move the function call out of any function it is in.§c"
            ,2
        )
    end

    -- Init stuff.
    if init then return end
    animInit()
    if should_blend then blend(paths, self.excluBlendTime or 4, self.incluBlendTime or 4) end
    events.TICK:register(tick)
    init = true
end}

local function addAllOverrider(...)
    if #allAnims >= 1024 then
        error(
            "§aCustom Script Warning: §6You've reached the max limit of 1024 animations that can be added to the addAllOverrider. To save your FPS the script has been stopped. \n"..
            "To prevent this from happening accidentally you should move the function call out of any function it is in.§c"
            ,2
        )
    end
    for _, v in ipairs{...} do
        assert(
            type(v) == "Animation",
            "§aCustom Script Warning: §6addAllOverrider was given something that isn't an animation, check its spelling for errors.§c")
      allAnims[#allAnims+1] = v
    end
end

local function addExcluOverrider(...)
    if #excluAnims >= 1024 then
        error(
            "§aCustom Script Warning: §6You've reached the max limit of 1024 animations that can be added to the addExcluOverrider. To save your FPS the script has been stopped. \n"..
            "To prevent this from happening accidentally you should move the function call out of any function it is in.§c"
            ,2
        )
    end
    for _, v in ipairs{...} do
        assert(
            type(v) == "Animation",
            "§aCustom Script Warning: §6addExcluOverrider was given something that isn't an animation, check its spelling for errors.§c")
      excluAnims[#excluAnims+1] = v
    end
end

local function addIncluOverrider(...)
    if #incluAnims >= 1024 then
        error(
            "§aCustom Script Warning: §6You've reached the max limit of 1024 animations that can be added to the addIncluOverrider. To save your FPS the script has been stopped. \n"..
            "To prevent this from happening accidentally you should move the function call out of any function it is in.§c"
            ,2
        )
    end
    for _, v in ipairs{...} do
        assert(
            type(v) == "Animation",
            "§aCustom Script Warning: §6addIncluOverrider was given something that isn't an animation, check its spelling for errors.§c")
      incluAnims[#incluAnims+1] = v
    end
end

local function setAllOn(x)
    setAllOnVar = x
end

local function setExcluOn(x)
    setExcluOnVar = x
end

local function setIncluOn(x)
    setIncluOnVar = x
end

local function oneJumpFunc(x)
    oneJump = x
end

-- If you're choosing to edit this script, don't put anything beneath the return line

return setmetatable(
    {
        animsList = animsList,
        addAllOverrider = addAllOverrider,
        addExcluOverrider = addExcluOverrider,
        addIncluOverrider = addIncluOverrider,
        setAllOn = setAllOn,
        setExcluOn = setExcluOn,
        setIncluOn = setIncluOn,
        oneJump = oneJumpFunc,
    },
    animMT
)
