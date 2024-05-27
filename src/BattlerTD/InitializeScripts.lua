function InitializeScripts()
    print("Initializing")

    InitializeHumanAI()

    round = 1
    playerUnitsArray = {}
    playerMilkMaids = {}
    playerBaseBuildings = {}
    playerBuildAreas = {}

    maxNumberBuildings = 50

    local baseSep = 950
    local maidHSep = 80
    local maidVSep = 340
    local maidVOffset = 35

    for player = 1, 6 do
        playerUnitsArray[player] = {}
        playerMilkMaids[player]  = {}

        for unitIndex = 1, maxNumberBuildings do
            playerUnitsArray[player][unitIndex] = {active = false, point = nil, unitType = nil}
        end  

        if GetPlayerSlotState(Player(player - 1)) == PLAYER_SLOT_STATE_PLAYING then
            local playerLoc = GetPlayerStartLocationLoc(Player(player - 1))

            -- Base Building
            print("Creating base building")
            local playerBase = CreateUnitAtLoc(Player(player - 1), FourCC("etrp"), playerLoc, 270)
            playerBaseBuildings[player] = playerBase

            local trigger = CreateTrigger()
            TriggerRegisterUnitInRangeSimple(trigger, 150, playerBase)
            TriggerAddAction(trigger, ReturnMilkEvent)
            
            -- Create Commander
            print("Creating commander")
            CreateCommanderForPlayer(player - 1)

            -- Worker Child
            print("Creating first child")
            local child = CreateUnitAtLoc(Player(player - 1), FourCC("nvlk"), playerLoc, 270)

            -- Start AI
            -- StartAIForPlayer(player - 1)

            -- Milk Maids
            local playerX = GetLocationX(playerLoc)
            local playerY = GetLocationY(playerLoc)
            local xSign = 1
            local points = {}

            if player < 4 then
                xSign = -1
            end 

            points[1] = {x = playerX + (baseSep - maidHSep) * xSign, y = playerY + maidVOffset}
            points[2] = {x = playerX + baseSep * xSign, y = playerY + maidVSep + maidVOffset}
            points[3] = {x = playerX + baseSep * xSign, y = playerY - maidVSep + maidVOffset}
            points[4] = {x = playerX + (baseSep - maidHSep * 5) * xSign, y = playerY + maidVSep * 2 + maidVOffset}
            points[5] = {x = playerX + (baseSep - maidHSep * 5) * xSign, y = playerY - maidVSep * 2 + maidVOffset}
            
            for j = 1, 5 do
                -- Spawn Milk Maid
                playerMilkMaids[player][j] = CreateUnit(Player(player - 1), FourCC("nvlw"), points[j].x, points[j].y, 90 + 90 * xSign)
                
                local trig = CreateTrigger()
                TriggerRegisterUnitInRangeSimple(trig, 80, playerMilkMaids[player][j])
                TriggerAddAction(trig, GatherMilkEvent)
            end

            -- Get initial milk harvesting started
            IssuePointOrderLoc(child, "move", GetUnitLoc(playerMilkMaids[player][1]))

            -- Define build areas
            playerBuildAreas[player] = Rect(playerX - 100 * xSign, playerY - 767, playerX - 1278 * xSign, playerY + 767)
        end
    end

    -- Ability Maps
    abilityCastTypeToAbility = {
        witchDoctor = {
            attackingGround = {
                [true] = "evileye", -- Is Base
                [false] = "stasistrap", -- Is NOT Base
            },
            allyAttackedGround = "healingward"
        },
        shaman = {
            attackingUnit = {
                [false] = "lightningshield" -- Is NOT Base
            }
        },
        priest = {
            attackingUnit = {
                [false] = "dispel"
            },
            allyAttackedUnit = "innerfire"
        },
        sorceress = {
            attackingUnit = {
                [false] = "polymorph"
            }
        }
    }

    abilityUnitTypeToCastType = {
        [FourCC("odoc")] = "witchDoctor",
        [FourCC("o000:odoc")] = "witchDoctor",
        [FourCC("o007:odoc")] = "witchDoctor",
        [FourCC("h00G:hhou")] = "priest",
        [FourCC("h00H:hhou")] = "priest",
        [FourCC("h00I:hsor")] = "sorceress"
    }

    print("Finished Initialization")
end

function CreateCommanderForPlayer(playerIndex)
    if GetPlayerSlotState(Player(playerIndex)) == PLAYER_SLOT_STATE_PLAYING then
        local playerLoc = GetPlayerStartLocationLoc(Player(playerIndex))
        if GetPlayerRace(Player(playerIndex)) == RACE_HUMAN then
            CreateUnit(Player(playerIndex), FourCC("uaco"), GetLocationX(playerLoc) + 200, GetLocationY(playerLoc), math.floor(playerIndex / 3) * 180)
        else
            CreateUnit(Player(playerIndex), FourCC("u000:uaco"), GetLocationX(playerLoc) + 200, GetLocationY(playerLoc), 0)
        end
    end
end

function printD(str, debugVar)
    if debugVar == nil or debugVar == false then
        return
    end

    print(str)
end