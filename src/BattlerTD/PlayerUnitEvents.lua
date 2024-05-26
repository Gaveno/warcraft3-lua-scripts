-- Player builds a unit
function AddBuildingToPlayer()
    -- print("A player built a unit")
    local unit = GetConstructingStructure()
    local player = GetPlayerId(GetOwningPlayer(unit)) + 1

    for unitIndex = 1, maxNumberBuildings do
        if (playerUnitsArray[player][unitIndex].active == false) then
            playerUnitsArray[player][unitIndex].active = true
            playerUnitsArray[player][unitIndex].unitType = GetUnitTypeId(unit)
            playerUnitsArray[player][unitIndex].point = GetUnitLoc(unit)

            SetUnitUserData(unit, unitIndex)
            -- print("Unit took slot: ")
            -- print(unitIndex)
            break
        end
    end
end

-- Player sells a unit
function RemoveUnitFromPlayer()
    local unit = GetTriggerUnit()
    local player = GetPlayerId(GetOwningPlayer(unit)) + 1
    local unitIndex = 0

    for i = 1, maxNumberBuildings do
        if GetLocationX(GetUnitLoc(unit)) == GetLocationX(playerUnitsArray[player][i].point) and GetLocationY(GetUnitLoc(unit)) == GetLocationY(playerUnitsArray[player][i].point) then
            unitIndex = i
            break
        end
    end

    SetPlayerState(GetOwningPlayer(unit), PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(GetOwningPlayer(unit), PLAYER_STATE_RESOURCE_LUMBER) + 1)
    -- SetPlayerState(GetOwningPlayer(unit), PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(GetOwningPlayer(unit), PLAYER_STATE_RESOURCE_LUMBER) + GetUnitWoodCost(playerUnitsArray[player][unitIndex].unitType))
    SetPlayerState(
        GetOwningPlayer(unit),
        PLAYER_STATE_RESOURCE_GOLD,
        math.floor(GetPlayerState(GetOwningPlayer(unit), PLAYER_STATE_RESOURCE_GOLD) + GetUnitGoldCost(playerUnitsArray[player][unitIndex].unitType) * 0.75)
    )
    playerUnitsArray[player][unitIndex].active = false
    RemoveUnit(unit)
end

-- Spawning units
function IsUnitBuilding()
    local unit = GetFilterUnit()
    return IsUnitType(unit, UNIT_TYPE_STRUCTURE) and GetUnitTypeId(unit) ~= FourCC("etrp")
end

function AddLocustFromCommanders()
    local commanders = GetUnitsInRectMatching(GetEntireMapRect(), Condition(function()
        local commander = GetFilterUnit()
        return (
            GetUnitTypeId(commander) == FourCC("u000:uaco") or   -- Orc
            GetUnitTypeId(commander) == FourCC("uaco")           -- Human
        )
    end))

    ForGroup(commanders, function()
        -- UnitAddSleepPerm(GetEnumUnit(), true)
        RemoveUnit(GetEnumUnit())
        -- UnitAddAbility(GetEnumUnit(), FourCC("Aloc"))
    end)
    DestroyGroup(commanders)
end

function ReplacePlayersUnits()
    local attackingUnits = GetUnitsInRectMatching(GetEntireMapRect(), Condition(IsUnitBuilding))

    if BlzGroupGetSize(attackingUnits) > 0 then
        AddLocustFromCommanders()

        -- Remove buildings and spawn units
        ForGroup(attackingUnits, function()
            local unit = GetEnumUnit()
            RemoveUnit(unit)
        end)

        for player = 1, 6 do
            SpawnPlayersUnits(player)
        end
    else
        StartTimerBJ(udg_roundTimer, false, 30)
    end

    MoveAttackAllUnitsToEnemyBase()
end

function GetSpawnUnitType(unitType)
    -----------------------------
    -- HUMAN
    -- Peasant check structure
    if unitType == FourCC("h001:hhou") then
        -- Spawn attacking unit
        return FourCC("h000:hpea")
    end

    -- Militia check structure
    if unitType == FourCC("h002:hhou") then
        -- Spawn attacking unit
        return FourCC("hmil")
    end

    -- Footman check structure
    if unitType == FourCC("h003:hhou") then
        -- Spawn attacking unit
        return FourCC("hfoo")
    end

    -- Rifleman check structure
    if unitType == FourCC("h004:hhou") then
        -- Spawn attacking unit
        return FourCC("hrif")
    end

    -- Priest check structure
    if unitType == FourCC("h005:hhou") then
        -- Spawn attacking unit
        return FourCC("hmpr")
    end

    -- Flying Machine check structure
    if unitType == FourCC("h006:hhou") then
        -- Spawn attacking unit
        return FourCC("hgyr")
    end

    -- Gryphon Rider check structure
    if unitType == FourCC("h008:hhou") then
        -- Spawn attacking unit
        return FourCC("hgry")
    end

    -- Storm Hammer Gryphon Rider check structure
    if unitType == FourCC("h009:hhou") then
        -- Spawn attacking unit
        return FourCC("h007:hgry")
    end

    -----------------------------
    -- ORC
    -- Peon check structure
    if unitType == FourCC("o001:hhou") then
        -- Spawn attacking unit
        return FourCC("opeo")
    end

    -- Grunt check structure
    if unitType == FourCC("o002:hhou") then
        -- Spawn attacking unit
        return FourCC("ogru")
    end

    -- Headhunter check structure
    if unitType == FourCC("o003:hhou") then
        -- Spawn attacking unit
        return FourCC("ohun")
    end

    -- Berserker check structure
    if unitType == FourCC("o004:hhou") then
        -- Spawn attacking unit
        return FourCC("otbk")
    end

    -- Shaman check structure
    if unitType == FourCC("o005:hhou") then
        -- Spawn attacking unit
        return FourCC("oshm")
    end

    -- Wind Rider check structure
    if unitType == FourCC("o006:hhou") then
        -- Spawn attacking unit
        return FourCC("owyv")
    end

    -- Novice Witch Doctor check structure
    if unitType == FourCC("h00A:hhou") then
        -- Spawn attacking unit
        return FourCC("odoc")
    end

    -- Adept Witch Doctor check structure
    if unitType == FourCC("h00B:hhou") then
        -- Spawn attacking unit
        return FourCC("o000:odoc")
    end

    -- Adept Witch Doctor check structure
    if unitType == FourCC("h00C:hhou") then
        -- Spawn attacking unit
        return FourCC("o007:odoc")
    end

    -- Batrider check structure
    if unitType == FourCC("h00D:hhou") then
        -- Spawn attacking unit
        return FourCC("otbr")
    end

    return nil
end

function SpawnPlayersUnits(player)
    for unitIndex = 1, maxNumberBuildings do
        local unitInfo = playerUnitsArray[player][unitIndex]
        local spawnUnitType = nil 

        if unitInfo.active == true then
            spawnUnitType = GetSpawnUnitType(unitInfo.unitType)

            if player <= 3 then
                local unit = CreateUnitAtLoc(Player(6), spawnUnitType, unitInfo.point, 0)
                -- IssuePointOrder(unit, "attack", 2040, GetLocationY(GetUnitLoc(unit)))
            else 
                local unit = CreateUnitAtLoc(Player(7), spawnUnitType, unitInfo.point, 180)
                -- IssuePointOrder(unit, "attack", -2040, GetLocationY(GetUnitLoc(unit)))
            end
        end
    end
end

function MoveAttackAllUnitsToEnemyBase()
    local units = GetUnitsInRectMatching(GetEntireMapRect(), Condition(function()
        local unit = GetFilterUnit()
        return GetOwningPlayer(unit) == Player(6) or GetOwningPlayer(unit) == Player(7)
    end))

    ForGroup(units, function()
        local unit = GetEnumUnit()
        local lane = GetLane(GetLocationY(GetUnitLoc(unit)))

        if GetOwningPlayer(unit) == Player(6) then
            IssuePointOrder(unit, "attack", 2040, GetLocationY(GetUnitLoc(playerBaseBuildings[lane])))
        else 
            IssuePointOrder(unit, "attack", -2040, GetLocationY(GetUnitLoc(playerBaseBuildings[lane])))
        end
    end)
end

-- All attacking units have died
function SpawnPlayersBuildings()
    print("A unit died")
    local unit = GetDyingUnit()

    if GetOwningPlayer(unit) == Player(6) or GetOwningPlayer(unit) == Player(7) then
        print("Unit belongs to attacker group")
        -- Unit bounty
        local killingPlayer = GetOwningPlayer(GetKillingUnit())
        local mult = 1

        if killingPlayer ~= Player(6) and killingPlayer ~= Player(7) then
            mult = 0.75 -- Reduce bounty when killer is a player base
        end

        if GetOwningPlayer(unit) == Player(6) then
            -- Grant to right side
            for player = 4, 6 do
                SetPlayerState(
                    Player(player - 1),
                    PLAYER_STATE_RESOURCE_GOLD,
                    math.floor(GetPlayerState(Player(player - 1), PLAYER_STATE_RESOURCE_GOLD) + (GetUnitPointValue(unit) * mult))
                )
            end
        else
            -- Grant to left side
            for player = 1, 3 do
                SetPlayerState(
                    Player(player - 1),
                    PLAYER_STATE_RESOURCE_GOLD,
                    math.floor(GetPlayerState(Player(player - 1), PLAYER_STATE_RESOURCE_GOLD) + (GetUnitPointValue(unit) * mult))
                )
            end
        end

        -- RemoveUnit(unit) -- Remove unit so the group has an accurate count
        local attackerGroup1 = GetUnitsOfPlayerMatching(Player(6), Condition(CheckAlive))
        local attackerGroup2 = GetUnitsOfPlayerMatching(Player(7), Condition(CheckAlive))

        print("Attacker group 1 size " .. BlzGroupGetSize(attackerGroup1))
        print("Attacker group 2 size " .. BlzGroupGetSize(attackerGroup2)) 

        if BlzGroupGetSize(attackerGroup1) + BlzGroupGetSize(attackerGroup2) <= 0 and TimerGetRemaining(udg_roundTimer) <= 0 then
            print("Attacker groups are empty")

            RemoveLocustFromCommanders()
            StartTimerBJ(udg_roundTimer, false, 30)

            for player = 1, 6 do
                -- Grant round gold
                round = round + 1  

                -- Spawn player buildings
                for unitIndex = 1, maxNumberBuildings do
                    local unitInfo = playerUnitsArray[player][unitIndex]

                    if unitInfo.active == true then
                        CreateUnitAtLoc(Player(player - 1), unitInfo.unitType, unitInfo.point, 0)
                    end
                end
            end
        end
    end
end

function RemoveLocustFromCommanders()
    for player = 1, 6 do
        CreateCommanderForPlayer(player - 1)
    end
end

function CheckAlive()
    local unit = GetFilterUnit()

    return (UnitAlive(unit) and
            GetUnitTypeId(unit) ~= FourCC("ohwd") and -- Healing Ward
            GetUnitTypeId(unit) ~= FourCC("oeye") and -- Sentry Ward
            GetUnitTypeId(unit) ~= FourCC("otot")) -- Stasis Trap
end

-- Upgrading a unit
function UpgradingUnit()
    local unit = GetTriggerUnit()
    local player = GetPlayerId(GetOwningPlayer(unit)) + 1
    local unitIndex = 0
    
    for i = 1, maxNumberBuildings do
        if GetLocationX(GetUnitLoc(unit)) == GetLocationX(playerUnitsArray[player][i].point) and GetLocationY(GetUnitLoc(unit)) == GetLocationY(playerUnitsArray[player][i].point) then
            unitIndex = i
            break
        end
    end

    playerUnitsArray[player][unitIndex].unitType = GetUnitTypeId(unit)
    playerUnitsArray[player][unitIndex].point = GetUnitLoc(unit)

    SetUnitUserData(unit, unitIndex)
    print("Unit took slot: ")
    print(unitIndex)
end

------------------------------
-- Milk Maids
function GatherMilkEvent()
    local child = GetEnteringUnit()

    if GetUnitTypeId(child) == FourCC("nvlk") and UnitItemInSlot(child, 0) == nil then
        local timer = CreateTimer()

        IssueImmediateOrder(child, "stop")
        TimerStart(timer, 2, false, function ()
            local player = GetOwningPlayer(child)
            local playerId = GetPlayerId(player)
            local playerLoc = GetPlayerStartLocationLoc(player)
            local offset = 120

            if playerId < 3 then
                offset = -120
            end

            UnitAddItemById(child, FourCC("afac"))
            IssuePointOrderLoc(child, "move", Location(GetLocationX(playerLoc) + offset, GetLocationY(playerLoc)))
            DestroyTimer(timer)
        end)
    end
end

function ReturnMilkEvent()
    local child = GetEnteringUnit()
    local item = UnitItemInSlot(child, 0)
    local player = GetOwningPlayer(child)

    if GetUnitTypeId(child) == FourCC("nvlk") and item ~= nil then
        if GetItemTypeId(item) == FourCC("afac") then
            RemoveItem(item)
            -- UnitRemoveItem(child, item)
            UnitAddItemById(child, FourCC("gold"))
            IssuePointOrderLoc(child, "move", GetUnitLoc(playerMilkMaids[GetPlayerId(player) + 1][GetRandomInt(1, 5)]))
        end
    end
end

function NewChildEvent()
    local child = GetEnteringUnit()
    local player = GetOwningPlayer(child)

    if GetUnitTypeId(child) == FourCC("nvlk") then
        IssuePointOrderLoc(child, "move", GetUnitLoc(playerMilkMaids[GetPlayerId(player) + 1][GetRandomInt(1, 5)]))
    end
end 