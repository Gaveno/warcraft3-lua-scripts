function InitializeScripts()
    print("Initializing")

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
            playerBuildAreas[player] = Rect(playerX - 100 * xSign, PlayerY - 767, playerX - 1278 * xSign, PlayerY + 767)
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
        }
    }

    abilityUnitTypeToCastType = {
        [FourCC("odoc")] = "witchDoctor",
        [FourCC("o000:odoc")] = "witchDoctor",
        [FourCC("o007:odoc")] = "witchDoctor"
    }

    print("Finished Initialization")
end

function CreateCommanderForPlayer(playerIndex)
    local playerLoc = GetPlayerStartLocationLoc(Player(playerIndex))
    if GetPlayerRace(Player(playerIndex)) == RACE_HUMAN then
        CreateUnitAtLoc(Player(playerIndex), FourCC("uaco"), playerLoc, 270)
    else
        CreateUnitAtLoc(Player(playerIndex), FourCC("u000:uaco"), playerLoc, 270)
    end
end

-- function StartAIForPlayer(playerIndex)
--     if GetPlayerController(Player(playerIndex)) == MAP_CONTROL_COMPUTER then
--         if GetPlayerRace(Player(playerIndex)) == RACE_HUMAN then
--             StartCampaignAI(Player(playerIndex), "HumanBattler.ai")
--         end
--     end
-- end