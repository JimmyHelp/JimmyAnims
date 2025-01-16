-- V1 for 0.1.0 and above
-- Made by JimmyHelp
-- Contains Manuel's runLater

local anims = {}

local controller = {}
local controllerMT = {__index = controller}

local objects = {}

local aList = {
    idling = {active = false,list = {},type = "excluAnims"},
    walking = {active = false,list = {},type = "excluAnims"},
    walkingback = {active = false,list = {},type = "excluAnims"},
    jumpingup = {active = false,list = {},type = "excluAnims"},
    jumpingdown = {active = false,list = {},type = "excluAnims"},
    falling = {active = false,list = {},type = "excluAnims"},
    sprinting = {active = false,list = {},type = "excluAnims"},
    sprintjumpup = {active = false,list = {},type = "excluAnims"},
    sprintjumpdown = {active = false,list = {},type = "excluAnims"},
    crouching = {active = false,list = {},type = "excluAnims"},
    crouchwalk = {active = false,list = {},type = "excluAnims"},
    crouchwalkback = {active = false,list = {},type = "excluAnims"},
    crouchjumpup = {active = false,list = {},type = "excluAnims"},
    crouchjumpdown = {active = false,list = {},type = "excluAnims"},
    elytra = {active = false,list = {},type = "excluAnims"},
    elytradown = {active = false,list = {},type = "excluAnims"},
    trident = {active = false,list = {},type = "excluAnims"},
    sleeping = {active = false,list = {},type = "excluAnims"},
    swimming = {active = false,list = {},type = "excluAnims"},
    sitting = {active = false,list = {},type = "excluAnims"},
    sitmove = {active = false,list = {},type = "excluAnims"},
    sitmoveback = {active = false,list = {},type = "excluAnims"},
    sitjumpup = {active = false,list = {},type = "excluAnims"},
    sitjumpdown = {active = false,list = {},type = "excluAnims"},
    sitpass = {active = false,list = {},type = "excluAnims"},
    crawling = {active = false,list = {},type = "excluAnims"},
    crawlstill = {active = false,list = {},type = "excluAnims"},
    flying = {active = false,list = {},type = "excluAnims"},
    flywalk = {active = false,list = {},type = "excluAnims"},
    flywalkback = {active = false,list = {},type = "excluAnims"},
    flysprint = {active = false,list = {},type = "excluAnims"},
    flyup = {active = false,list = {},type = "excluAnims"},
    flydown = {active = false,list = {},type = "excluAnims"},
    climbing = {active = false,list = {},type = "excluAnims"},
    climbstill = {active = false,list = {},type = "excluAnims"},
    climbdown = {active = false,list = {},type = "excluAnims"},
    climbcrouch = {active = false,list = {},type = "excluAnims"},
    climbcrouchwalking = {active = false,list = {},type = "excluAnims"},
    water = {active = false,list = {},type = "excluAnims"},
    waterwalk = {active = false,list = {},type = "excluAnims"},
    waterwalkback = {active = false,list = {},type = "excluAnims"},
    waterup = {active = false,list = {},type = "excluAnims"},
    waterdown = {active = false,list = {},type = "excluAnims"},
    watercrouch = {active = false,list = {},type = "excluAnims"},
    watercrouchwalk = {active = false,list = {},type = "excluAnims"},
    watercrouchwalkback = {active = false,list = {},type = "excluAnims"},
    watercrouchup = {active = false,list = {},type = "excluAnims"},
    watercrouchdown = {active = false,list = {},type = "excluAnims"},
    hurt = {active = false,list = {},type = "excluAnims"},
    death = {active = false,list = {},type = "excluAnims"},

    attackR = {active = false,list = {},type = "incluAnims"},
    attackL = {active = false,list = {},type = "incluAnims"},
    mineR = {active = false,list = {},type = "incluAnims"},
    mineL = {active = false,list = {},type = "incluAnims"},
    holdR = {active = false,list = {},type = "incluAnims"},
    holdL = {active = false,list = {},type = "incluAnims"},
    eatR = {active = false,list = {},type = "incluAnims"},
    eatL = {active = false,list = {},type = "incluAnims"},
    drinkR = {active = false,list = {},type = "incluAnims"},
    drinkL = {active = false,list = {},type = "incluAnims"},
    blockR = {active = false,list = {},type = "incluAnims"},
    blockL = {active = false,list = {},type = "incluAnims"},
    bowR = {active = false,list = {},type = "incluAnims"},
    bowL = {active = false,list = {},type = "incluAnims"},
    loadR = {active = false,list = {},type = "incluAnims"},
    loadL = {active = false,list = {},type = "incluAnims"},
    crossbowR = {active = false,list = {},type = "incluAnims"},
    crossbowL = {active = false,list = {},type = "incluAnims"},
    spearR = {active = false,list = {},type = "incluAnims"},
    spearL = {active = false,list = {},type = "incluAnims"},
    spyglassR = {active = false,list = {},type = "incluAnims"},
    spyglassL = {active = false,list = {},type = "incluAnims"},
    hornR = {active = false,list = {},type = "incluAnims"},
    hornL = {active = false,list = {},type = "incluAnims"},
    brushR = {active = false,list = {},type = "incluAnims"},
    brushL = {active = false,list = {},type = "incluAnims"},
}

local oldList = {}

for key, _ in pairs(aList) do
    oldList[key] = {active = false}
end

local GSAnimBlend
for _, key in ipairs(listFiles(nil,true)) do
    if key:find("GSAnimBlend$") then
        GSAnimBlend = require(key)
        break
    end
end
if GSAnimBlend then GSAnimBlend.safe = false end

local function setBlendTime(ex,inc,o)
    for _,list in pairs(o.aList) do
        for _,value in pairs(list.list) do
            value:setBlendTime(list.type == "excluAnims" and ex or inc)
        end
    end
end

---@param ex? number
---@param inc? number
function controller:setBlendTimes(ex,inc)
    if not GSAnimBlend then error("GSAnimBlend was not found in the avatar, and this function is for interacting with GSAnimBlend.",2) end
    if type(ex) ~= "number" and ex ~= nil then
        error("The first arg is a non-number value ("..type(ex).."), must be a number or nil.",2)
    end
    if type(inc) ~= "number" and inc ~= nil then
        error("The first arg is a non-number value ("..type(inc).."), must be a number or nil.",2)
    end
    if ex == nil then
        ex = 0
    end
    if inc == nil then
        inc = ex
    end
    setBlendTime(ex,inc,self)
    return self
end

local function deep_copy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = deep_copy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

local flyinit
local function addAnims(bb,o)
    for animlist,_ in pairs(o.aList) do
        for _, animss in pairs(bb) do
            for key,anim in pairs(animss) do
                if key:find(animlist.."$") then
                    o.aList[animlist].list[#o.aList[animlist].list + 1] = anim
                    if key:find("fly") then flyinit = true end
                end
            end
        end
    end
    if GSAnimBlend then setBlendTime(4,4,o) end
end

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

local fallVel = -0.6
---@param vel? number
function anims:setFallVel(vel)
    if type(vel) ~= "number" and vel ~= nil then
        error("Tried to set the velocity to a non-number value ("..type(vel)..").")
    end
    fallVel = vel or -0.6
    return self
end

local oneJump = false
---@param state? boolean
function anims:setOneJump(state)
    oneJump = state or false
    return self
end

local function getPlay(anim)
    local exists, hold = pcall(anim.isHolding,anim)
    return anim:isPlaying() or (exists and hold)
end

local function getOverriders(type,o)
    return o.overrideStates[type] or o.overrideStates.allAnims
end

local function addOverriders(self,type,...)
    for _, value in pairs({...}) do
        self.overriders[type][#self.overriders[type]+1] = value
        if #self.overriders[type] == 64 then
            error("The max amount of overriding animations for "..type.." (64) was reached. Do not put the code for adding overriding animations in a function, it will infinitely add animations.",3)
        end
    end
end

---@param state? boolean
function controller:setAllOff(state)
    self.setOverrides.allAnims = state
    return self
end

---@param state? boolean
function controller:setExcluOff(state)
    self.setOverrides.excluAnims = state
    return self
end

---@param state? boolean
function controller:setIncluOff(state)
    self.setOverrides.incluAnims = state
    return self
end

---@param ... Animation
function controller:addExcluOverrider(...)
    addOverriders(self,"excluAnims",...)
    return self
end

---@param ... Animation
function controller:addIncluOverrider(...)
    addOverriders(self,"incluAnims",...)
    return self
end

---@param ... Animation
function controller:addAllOverrider(...)
    addOverriders(self,"allAnims",...)
    return self
end

---@param exState? string
---@param inState? string
function controller:setState(exState,inState)
    if type(exState) ~= "string" and exState ~= nil then
        error("The first arg is a non-string value ("..type(exState).."), must be a string or nil.",2)
    end
    if type(inState) ~= "string" and inState ~= nil then
        error("The first arg is a non-string value ("..type(inState).."), must be a string or nil.",2)
    end
    self.toggleState = {excluAnims = exState or "",incluAnims = inState or exState or ""}
    return self
end

local function getStates(type,o)
    return o.toggleState[type]
end

---@param spec? string
function controller:getAnimationStates(spec)
    if type(spec) ~= "string" and spec ~= nil then
        error("The animation state is a non-string value ("..type(spec).."), must be a string or nil.",2)
    end
    local states = {}
    for k,v in pairs(self.aList) do
        states[k] = v.active
    end
    if spec then return self.aList[spec].active else return states end
end

local function setAnimation(anim,override,state,o)
    local saved = o.aList[anim]
    local exists = true
    for _,value in pairs(saved.list) do
        if value:getName() == state..anim then
            value:setPlaying(saved.active and not override)
            exists = false
        else
            value:stop()
        end
    end
    for _,value in pairs(saved.list) do
        if exists and value:getName() == anim then
            value:setPlaying(saved.active and not override)
        end
    end
end

local flying
function pings.JimmyAnims_cFly(x)
    flying = x
end

local diff = false
local rightResult, leftResult, targetEntity, rightMine, leftMine, rightAttack, leftAttack, oldhitBlock, targetBlock, blockSuccess, blockResult, hitBlock
local yvel, grounded, oldgrounded, cooldown, hasJumped, cFlying, oldcFlying
local updateTimer  = 0
local toggleDiff
local function getInfo()
    if host:isHost() then
        if flyinit then
            cFlying = host:isFlying()
            if cFlying ~= oldcFlying then
                pings.JimmyAnims_cFly(cFlying)
            end
            oldcFlying = cFlying

            updateTimer = updateTimer + 1
            if updateTimer % 200 == 0 then
                pings.JimmyAnims_cFly(cFlying)
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
    local creativeFlying = (flying or false) and not sitting
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

    local handedness = player:isLeftHanded()
    local rightItem = player:getHeldItem(handedness)
    local leftItem = player:getHeldItem(not handedness)
    local rightActive = handedness and "OFF_HAND" or "MAIN_HAND"
    local leftActive = not handedness and "OFF_HAND" or "MAIN_HAND"
    local activeness = player:getActiveHand()
    local using = player:isUsingItem()
    local rightSuccess = pcall(rightItem.getUseAction,rightItem)
    if rightSuccess then rightResult = rightItem:getUseAction() else rightResult = "NONE" end
    local usingR = using and activeness == rightActive and rightResult
    local leftSuccess = pcall(leftItem.getUseAction,leftItem)
    if leftSuccess then leftResult = leftItem:getUseAction() else leftResult = "NONE" end
    local usingL = using and activeness == leftActive and leftResult
    local swing = player:getSwingTime()
    local arm = swing > 0 and player:getSwingArm() and not sleeping
    local rTag= rightItem.tag
    local lTag = leftItem.tag
    local crossR = rTag and (rTag["Charged"] == 1 or (rTag["ChargedProjectiles"] and next(rTag["ChargedProjectiles"])~= nil)) or false
    local crossL = lTag and (lTag["Charged"] == 1 or (lTag["ChargedProjectiles"] and next(lTag["ChargedProjectiles"])~= nil)) or false
    local exclude = not (crossR or crossL or using)
    local game = player:getGamemode()
    local reach = game and 6 or 3

    if swing == 1 then
        targetEntity = type(player:getTargetedEntity(reach)) == "PlayerAPI" or type(player:getTargetedEntity(reach)) == "LivingEntityAPI"
        rightMine = oldhitBlock and not targetEntity
        leftMine = oldhitBlock and not targetEntity
        rightAttack = (not oldhitBlock or targetEntity)
        leftAttack = (not oldhitBlock or targetEntity)
    end

    for _,o in pairs(objects) do

        o.diff = false
        for types, tabs in pairs(o.overriders) do
           o.overrideStates[types] = o.setOverrides[types] or false
            for _, value in pairs(tabs) do
                if getPlay(value) then
                    o.overrideStates[types] = true
                    break
                end
            end
            if o.oldoverStates[types] ~= o.overrideStates[types] then
                o.diff = true
            end
            o.oldoverStates[types] = o.overrideStates[types]
        end

        local ob = o.aList
    
        ob.flywalkback.active = creativeFlying and backward and (not (goingDown or goingUp))
        ob.flysprint.active = creativeFlying and sprinting and not isJumping and (not (goingDown or goingUp))
        ob.flyup.active = creativeFlying and goingUp
        ob.flydown.active = creativeFlying and goingDown
        ob.flywalk.active = creativeFlying and forward and (not (goingDown or goingUp)) and not sleeping or (ob.flysprint.active and next(ob.flysprint.list)==nil) or (flywalkback and next(ob.flywalkback.list)==nil)
        or (ob.flyup.active and next(ob.flyup.list)==nil) or (ob.flydown.active and next(ob.flydown.list)==nil)
        ob.flying.active = creativeFlying and not sprinting and not moving and standing and not isJumping and (not (goingDown or goingUp)) and not sleeping or (ob.flywalk.active and next(ob.flywalk.list)==nil)

        ob.watercrouchwalkback.active = inWater and crouching and backward and not goingDown
        ob.watercrouchwalk.active = inWater and crouching and forward and not (goingDown or goingUp) or (ob.watercrouchwalkback.active and next(ob.watercrouchwalkback.list)==nil)
        ob.watercrouchup.active = inWater and crouching and goingUp
        ob.watercrouchdown.active = inWater and crouching and goingDown or (ob.watercrouchup.active and next(ob.watercrouchup.list)==nil)
        ob.watercrouch.active = inWater and crouching and not moving and not (goingDown or goingUp) or (ob.watercrouchdown.active and next(ob.watercrouchdown.list)==nil) or (ob.watercrouchwalk.active and next(ob.watercrouchwalk.list)==nil)

        ob.waterdown.active = inWater and goingDown and not falling and standing and not creativeFlying
        ob.waterup.active = inWater and goingUp and standing and not creativeFlying
        ob.waterwalkback.active = inWater and backward and hover and standing and not creativeFlying
        ob.waterwalk.active = inWater and forward and hover and standing and not creativeFlying or (ob.waterwalkback.active and next(ob.waterwalkback.list)==nil) or (ob.waterdown.active and next(ob.waterdown.list)==nil)
        or (ob.waterup.active and next(ob.waterup.list)==nil)
        ob.water.active = inWater and not moving and standing and hover and not creativeFlying or (ob.waterwalk.active and next(ob.waterwalk.list)==nil)
        


        ob.crawlstill.active = crawling and not moving
        ob.crawling.active = crawling and moving or (ob.crawlstill.active and next(ob.crawlstill.list)==nil)

        ob.swimming.active = liquidSwim or (ob.crawling.active and next(ob.crawling.list)==nil)

        ob.elytradown.active = gliding and goingDown
        ob.elytra.active = gliding and not goingDown or (ob.elytradown.active and next(ob.elytradown.list)==nil)

        ob.sitpass.active = passenger and standing or false
        ob.sitjumpdown.active = sitting and not passenger and standing and (jumpingDown or falling)
        ob.sitjumpup.active = sitting and not passenger and jumpingUp and standing or (ob.sitjumpdown.active and next(ob.sitjumpdown.list)==nil)
        ob.sitmoveback.active = sitting and not passenger and not isJumping and backwards and standing
        ob.sitmove.active = velocity:length() > 0 and not passenger and not backwards and standing and sitting and not isJumping or (ob.sitmoveback.active and not next(ob.sitmoveback.list)==nil) or (ob.sitjumpup.active and next(ob.sitjumpup.list)==nil)
        ob.sitting.active = sitting and not passenger and velocity:length() == 0 and not isJumping and standing or (ob.sitmove.active and next(ob.sitmove.list)==nil) or (ob.sitpass.active and next(ob.sitpass.list)==nil) or false

        ob.trident.active = spin
        ob.sleeping.active = sleeping

        ob.climbcrouchwalking.active = ladder and crouching and (moving or yvel ~= 0)
        ob.climbcrouch.active = ladder and crouching and hover and not moving or (ob.climbcrouchwalking.active and next(ob.climbcrouchwalking.list)==nil)
        ob.climbdown.active = ladder and goingDown
        ob.climbstill.active = ladder and not crouching and hover
        ob.climbing.active = ladder and goingUp and not crouching or (ob.climbdown.active and next(ob.climbdown.list)==nil) or (ob.climbstill.active and next(ob.climbstill.list)==nil)

        ob.crouchjumpdown.active = crouching and jumpingDown and not ladder
        ob.crouchjumpup.active = crouching and jumpingUp and not ladder or (not oneJump and (ob.crouchjumpdown.active and next(ob.crouchjumpdown.list)==nil))
        ob.crouchwalkback.active = backward and crouching and not ladder or (ob.watercrouchwalkback.active and next(ob.watercrouchwalkback.list)==nil and next(ob.watercrouchwalk.list)==nil and next(ob.watercrouch.list)==nil)
        ob.crouchwalk.active = forward and crouching and not ladder or (ob.crouchwalkback.active and next(ob.crouchwalkback.list)==nil) or (not oneJump and (ob.crouchjumpup.active and next(ob.crouchjumpup).list)==nil) or ((ob.watercrouchwalk.active and not ob.watercrouchwalkback.active) and next(ob.watercrouchwalk.list)==nil and next(ob.watercrouch.list)==nil)
        ob.crouching.active = crouching and not walking and not isJumping and not ladder and not cooldown or (ob.crouchwalk.active and next(ob.crouchwalk.list)==nil) or (ob.climbcrouch.active and next(ob.climbcrouch.list)==nil) or ((ob.watercrouch.active and not ob.watercrouchwalk.active) and next(ob.watercrouch.list)==nil)
        
        ob.falling.active = falling and not gliding and not creativeFlying and not sitting
        
        ob.sprintjumpdown.active = jumpingDown and sprinting and not creativeFlying and not ladder or false
        ob.sprintjumpup.active = jumpingUp and sprinting and not creativeFlying and not ladder or (not oneJump and (ob.sprintjumpdown.active and next(ob.sprintjumpdown.list)==nil)) or false
        ob.jumpingdown.active = jumpingDown and not sprinting and not crouching and not sitting and not sleeping and not gliding and not creativeFlying and not spin and not inWater or (ob.falling.active and next(ob.falling.list)==nil) or (oneJump and (ob.sprintjumpdown.active and next(ob.sprintjumpdown.list)==nil)) or (oneJump and (ob.crouchjumpdown.active and next(ob.crouchjumpdown.list)==nil))
        ob.jumpingup.active = jumpingUp and not sprinting and not crouching and not sitting and not creativeFlying and not inWater or (ob.jumpingdown.active and next(ob.jumpingdown.list)==nil) or (ob.trident.active and next(ob.trident.list)==nil) or (oneJump and (ob.sprintjumpup.active and next(ob.sprintjumpup.list)==nil)) or (oneJump and (ob.crouchjumpup.active and next(ob.crouchjumpup.list)==nil))

        ob.sprinting.active = sprinting and not isJumping and not creativeFlying and not ladder and not cooldown and not inWater or (not oneJump and (ob.sprintjumpup.active and next(ob.sprintjumpup.list)==nil)) or false
        ob.walkingback.active = backward and standing and not creativeFlying and not ladder and not inWater or (ob.flywalkback.active and next(ob.flywalkback.list)==nil and next(ob.flywalk.list)==nil and next(ob.flying.list)==nil)
        ob.walking.active = forward and standing and not creativeFlying and not ladder and not cooldown and not inWater or (ob.walkingback.active and next(ob.walkingback.list)==nil) or (ob.sprinting.active and next(ob.sprinting.list)==nil) or (ob.climbing.active and next(ob.climbing.list)==nil)
        or (ob.swimming.active and next(ob.swimming.list)==nil) or (ob.elytra.active and next(ob.elytra.list)==nil) or (ob.jumpingup.active and next(ob.jumpingup.list)==nil) or (ob.waterwalk.active and (next(ob.waterwalk.list)==nil and next(ob.water.list)==nil)) or ((ob.flywalk.active and not ob.flywalkback.active) and next(ob.flywalk.list)==nil and next(ob.flying.list)==nil)
        or (ob.crouchwalk.active and (next(ob.crouchwalk)==nil or next(ob.crouching.list)==nil))
        ob.idling.active = not moving and not sprinting and standing and not isJumping and not sitting and not inWater and not creativeFlying and not ladder or (ob.sleeping.active and next(ob.sleep.list)==nil) or (ob.sitting.active and next(ob.sitting.list)==nil)
        or ((ob.water.active and not ob.waterwalk.active) and next(ob.water.list)==nil) or ((ob.flying.active and not ob.flywalk.active) and next(ob.flying.list)==nil) or ((ob.crouching.active and not ob.crouchwalk.active) and next(ob.crouching.list)==nil)

        ob.death.active = hp <= 0
        ob.hurt.active = player:getNbt().HurtTime > 0 and hp > 0

        ob.attackR.active = arm == rightActive and rightAttack
        ob.attackL.active = arm == leftActive and leftAttack
        ob.mineR.active = arm == rightActive and rightMine
        ob.mineL.active = arm == leftActive and leftMine
        ob.holdR.active = rightItem.id~="minecraft:air" and exclude
        ob.holdL.active = leftItem.id~="minecraft:air" and exclude
        ob.eatR.active = usingR == "EAT"
        ob.eatL.active = usingL == "EAT"
        ob.drinkR.active = usingR == "DRINK"
        ob.drinkL.active = usingL == "DRINK"
        ob.blockR.active = usingR == "BLOCK"
        ob.blockL.active = usingL == "BLOCK"
        ob.bowR.active = usingR == "BOW"
        ob.bowL.active = usingL == "BOW"
        ob.loadR.active = usingR == "CROSSBOW"
        ob.loadL.active = usingL == "CROSSBOW"
        ob.crossbowR.active = crossR
        ob.crossbowL.active = crossL
        ob.spearR.active = usingR == "SPEAR"
        ob.spearL.active = usingL == "SPEAR"
        ob.spyglassR.active = usingR == "SPEAR"
        ob.spyglassL.active = usingL == "SPEAR"
        ob.hornR.active = usingR == "TOOT_HORN"
        ob.hornL.active = usingL == "TOOT_HORN"
        ob.brushR.active = usingR == "BRUSH"
        ob.brushL.active = usingL == "BRUSH"

        for key,value in pairs(o.aList) do
            if (value.active ~= o.oldList[key].active) or o.toggleDiff or o.diff then
                setAnimation(key,getOverriders(value.type,o),getStates(value.type,o),o)
            end
            o.oldList[key].active = value.active
        end

        o.toggleDiff = false
        for key,_ in pairs(o.toggleState) do
            if o.oldToggle[key] ~= o.toggleState[key] then
                o.toggleDiff = true
            end
            o.oldToggle[key] = o.toggleState[key]
        end
    end
    oldhitBlock = hitBlock
    targetBlock = player:getTargetedBlock(true, game and 5 or 4.5)
    blockSuccess, blockResult = pcall(targetBlock.getTextures, targetBlock)
    if blockSuccess then hitBlock = not (next(blockResult) == nil) else hitBlock = true end
end

function events.tick()
    getInfo()
end

local function getBBModels()
    local bbmodels = {}
    for _,layer in pairs(models:getChildren()) do
        local name = layer:getName()
        if animations[name] then
            bbmodels[name] = animations[name]
        else
            for _,layer2 in pairs(layer:getChildren()) do
                local name2 = name.."."..layer2:getName()
                bbmodels[name2] = animations[name2]
            end
        end
    end

    if next(bbmodels) == nil then
        error("No blockbench models containing animations were found.")
    end

    local o = setmetatable(
    {
        bbmodels=bbmodels,
        aList=deep_copy(aList),
        oldList=deep_copy(oldList),
        toggleState = {excluAnims="",incluAnims=""},
        oldToggle = {excluAnims="",incluAnims=""},
        toggleDiff = toggleDiff,
        overriders = {excluAnims = {},incluAnims = {}, allAnims = {}},
        overrideStates = {excluAnims = false,incluAnims = false, allAnims = false},
        oldoverStates = {excluAnims = false,incluAnims = false, allAnims = false},
        setOverrides = {excluAnims = false,incluAnims = false, allAnims = false},
        diff = diff
    }, 
    controllerMT)
    objects[1] = o
    addAnims(bbmodels,o)
end

getBBModels()

local firstRun = true
---@param ... table
function anims:addBBmodel(...)
    local bbmodels = {}
    if firstRun then
        firstRun = false
        if GSAnimBlend then setBlendTime(0,0,objects[1]) end
        objects = {}
        for _,list in pairs(aList) do
            list.list = {}
        end
    end

    for _,value in pairs({...}) do
        bbmodels[#bbmodels + 1] = value
    end

    if next(bbmodels) == nil then
        error("The blockbench model provided couldn't be found because it has no animations, or because of a typo or some other mistake.",2)
    end

    local o = setmetatable(
    {
        bbmodels=bbmodels,aList=deep_copy(aList),
        oldList=deep_copy(oldList),toggleState = {excluAnims="",incluAnims=""},
        oldToggle = {excluAnims="",incluAnims=""},
        toggleDiff = toggleDiff,
        overriders = {excluAnims = {},incluAnims = {}, allAnims = {}},
        overrideStates = {excluAnims = false,incluAnims = false, allAnims = false},
        oldoverStates = {excluAnims = false,incluAnims = false, allAnims = false},
        setOverrides = {excluAnims = false,incluAnims = false, allAnims = false},
        diff = diff
    }, 
    controllerMT)
    objects[#objects+1] = o 
    if #objects == 16 then
        error("The max amount of blockbench models (16) was reached. Do not put the code for adding blockbench models in a function, it will infinitely add blockbench models.",3)
    end
    addAnims(bbmodels,o)
    return o
end

anims.controller = controller
return anims

--[[ things left to implement:
    - instance it or use objects or whatever
]]