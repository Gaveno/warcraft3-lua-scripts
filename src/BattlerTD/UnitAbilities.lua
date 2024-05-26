---------------------------
-- Witch Doctor
function UnitAbilitiesWitchDoctorEvent()
    local attacker = GetAttacker()
    local attackerType = GetUnitTypeId(attacker)
    local attacked = GetTriggerUnit()

    -- If Witch Doctor attacks something
    if attackerType == FourCC("odoc") or attackerType == FourCC("o000:odoc") or attackerType == FourCC("o007:odoc") then
        -- If Witch Doctor attacks a base structure
        if GetUnitTypeId(attacked) == FourCC("etrp") then
            -- Cast Sentry Ward
            IssuePointOrderByIdLoc(attacker, OrderId("evileye"), GetUnitLoc(attacked))
        else
            -- Cast Stasis Trap
            IssuePointOrderByIdLoc(attacker, OrderId("stasistrap"), GetUnitLoc(attacked))
        end
    end

    local lane = GetLane(GetLocationY(GetUnitLoc(attacked)))
    local mapRect = GetPlayableMapRect()
    local witchDocs = GetUnitsInRectMatching(
        Rect(
            GetRectMinX(mapRect),
            GetPlayerStartLocationY(Player(lane)) - 892,
            GetRectMaxX(mapRect),
            GetPlayerStartLocationY(Player(lane)) + 892
        ),
        Condition(function()
            local unitType = GetUnitTypeId(GetFilterUnit())
            return GetOwningPlayer(GetFilterUnit()) == GetOwningPlayer(attacked) and (
                unitType == FourCC("o000:odoc") or unitType == FourCC("o007:odoc")
            )
        end)
    )

    local witchDoc = GroupPickRandomUnit(witchDocs)

    if witchDoc ~= nil then
        -- Cast Healing Ward
        IssuePointOrderByIdLoc(witchDoc, OrderId("healingward"), GetUnitLoc(attacked))
    end
end

---------------------------
-- Unit Ability Triggers
function UnitAbilitiesEvent()
    local attacker      = GetAttacker()
    local attackerType  = GetUnitTypeId(attacker)
    local attacked      = GetTriggerUnit()

    -- Attacks something
    if abilityUnitTypeToCastType[attackerType] ~= nil then
        -- Attacks a base structure
        local isBase = GetUnitTypeId(attacked) == FourCC("etrp")

        -- Target ground
        pcall(function()
            print("Attempting ability on ground target")
            IssuePointOrderByIdLoc(attacker, OrderId(abilityCastTypeToAbility[abilityUnitTypeToCastType[attackerType]].attackingGround[isBase]), GetUnitLoc(attacked))
        end)

        -- Target the unit
        pcall(function()
            print("Attempting ability on unit target")
            IssueTargetOrderById(attacker, OrderId(abilityCastTypeToAbility[abilityUnitTypeToCastType[attackerType]].attackingUnit[isBase]), attacked)
        end)
    end

    -- Something is attacked
    local lane = GetLane(GetLocationY(GetUnitLoc(attacked)))
    local mapRect = GetPlayableMapRect()
    local witchDocs = GetUnitsInRectMatching(
        Rect(
            GetRectMinX(mapRect),
            GetPlayerStartLocationY(Player(lane)) - 892,
            GetRectMaxX(mapRect),
            GetPlayerStartLocationY(Player(lane)) + 892
        ),
        Condition(function()
            local unitType = GetUnitTypeId(GetFilterUnit())

            if abilityUnitTypeToCastType[unitType] ~= nil then
                return GetOwningPlayer(GetFilterUnit()) == GetOwningPlayer(attacked) and (
                    abilityCastTypeToAbility[abilityUnitTypeToCastType[unitType]].allyAttackedGround ~= nil or
                    abilityCastTypeToAbility[abilityUnitTypeToCastType[unitType]].allyAttackedUnit ~= nil
                )
            else
                return false
            end
        end)
    )

    local witchDoc = GroupPickRandomUnitCustom(witchDocs)

    if witchDoc ~= nil then
        if abilityUnitTypeToCastType[GetUnitTypeId(witchDoc)] ~= nil then
            -- Defensive skill
            pcall(function()
                print("Attempting defensive ability on unit target")
                IssuePointOrderByIdLoc(witchDoc, OrderId(abilityCastTypeToAbility[abilityUnitTypeToCastType[GetUnitTypeId(witchDoc)]].allyAttackedGround), GetUnitLoc(attacked))
            end)

            pcall(function()
                print("Attempting defensive ability on unit target")
                IssueTargetOrderById(witchDoc, OrderId(abilityCastTypeToAbility[abilityUnitTypeToCastType[GetUnitTypeId(witchDoc)]].allyAttackedUnit), attacked)
            end)
        end
    end
end

----------------------------
-- Helper Functions
function GetLane(y)
    -- Returns lane in range 1-3
    for player = 1,3 do
        if y > GetPlayerStartLocationY(Player(player - 1)) - 892 and y < GetPlayerStartLocationY(Player(player - 1)) + 892 then
            return player - 1
        end
    end
    return -1
end

-- ===========================================================================

--  Consider each unit, one at a time, keeping a "current pick".   Once all units
--  are considered, this "current pick" will be the resulting random unit.
--
--  The chance of picking a given unit over the "current pick" is 1/N, where N is
--  the number of units considered thusfar (including the current consideration).
--
function GroupPickRandomUnitEnumCustom()
	bj_groupRandomConsidered = bj_groupRandomConsidered + 1
	if (GetRandomInt(1, bj_groupRandomConsidered) == 1) then
		bj_groupRandomCurrentPick = GetEnumUnit()
	end
end

-- ===========================================================================

--  Picks a random unit from a group.
---@param whichGroup group
---@return unit
function GroupPickRandomUnitCustom(whichGroup)
	--  If the user wants the group destroyed, remember that fact and clear
	--  the flag, in case it is used again in the callback.

	bj_groupRandomConsidered = 0
	bj_groupRandomCurrentPick = -1
	ForGroup(whichGroup, GroupPickRandomUnitEnum)

	--  If the user wants the group destroyed, do so now.
	DestroyGroup(whichGroup)

    if bj_groupRandomCurrentPick ~= -1 then
	    return bj_groupRandomCurrentPick
    end
    
    return nil
end