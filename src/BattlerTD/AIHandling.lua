function ProcessAIForPlayersEvent()
    for player = 1, 6 do
        if GetPlayerSlotState(Player(player - 1)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(player - 1)) == MAP_CONTROL_COMPUTER then
        -- if GetPlayerController(Player(player)) == MAP_CONTROL_COMPUTER then
            ProcessAIOrderForPlayer(player)
        -- end
        end
    end
end

function ProcessAIOrderForPlayer(playerIndex)
    debugAIOrder = true
    printD("Build order for player " .. playerIndex .. " before " .. playerAIOrders[playerIndex], debugAIOrder)
    -- Base upgrades
    if GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_GOLD) > 200 and TimerGetRemaining(udg_roundTimer) <= 0 then
        IssueImmediateOrderById(playerBaseBuildings[playerIndex], FourCC("Resw"))
        IssueImmediateOrderById(playerBaseBuildings[playerIndex], FourCC("Rerh"))
    end

    if humanBuildPriorities[playerAIOrders[playerIndex]] == nil then
        return
    end

    local orderType = humanBuildPriorities[playerAIOrders[playerIndex]].type

    if orderType == "worker" then
        if GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_GOLD) >= GetUnitGoldCost(FourCC("nvlk")) then
            if GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_FOOD_USED) < GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_FOOD_CAP) then
                local res = IssueImmediateOrderById(playerBaseBuildings[playerIndex], FourCC("nvlk"))
                if res == true then
                    playerAIOrders[playerIndex] = playerAIOrders[playerIndex] + 1
                end
            else
                playerAIOrders[playerIndex] = playerAIOrders[playerIndex] + 1
            end
        end
        return
    end

    if orderType == "building" then
        if GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_GOLD) >= GetUnitGoldCost(FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].building)) and
           GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_LUMBER) >= GetUnitWoodCost(FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].building)) then

            local commanderGroup = GetUnitsOfPlayerMatching(Player(playerIndex - 1), Condition(function()
                local com = GetUnitTypeId(GetFilterUnit())
                return com == FourCC("u000:uaco") or com == FourCC("uaco") or (IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE) and com ~= FourCC("etrp"))
            end))

            foundBuilder = false
            ForGroup(commanderGroup, function()
                if foundBuilder == false then
                    local res = IssueBuildOrderById(
                        GetEnumUnit(),
                        FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].building),
                        GetRandomInt(GetRectMinX(playerBuildAreas[playerIndex]), GetRectMaxX(playerBuildAreas[playerIndex])),
                        GetRandomInt(GetRectMinY(playerBuildAreas[playerIndex]), GetRectMaxY(playerBuildAreas[playerIndex]))
                    )

                    if res == false then
                        local secondRes = IssueImmediateOrderById(GetEnumUnit(), FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].building))

                        if res == true then
                            foundBuilder = true
                        end
                    else
                        foundBuilder = true
                    end
                end
            end)

            if foundBuilder == true then
                playerAIOrders[playerIndex] = playerAIOrders[playerIndex] + 1
            end
        end
        return
    end

    if orderType == "upgrade" then
        local currentLevel = GetPlayerTechCountSimple(FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].upgrade), Player(playerIndex - 1))
        local upgradeFrom = humanBuildPriorities[playerAIOrders[playerIndex]].level

        if currentLevel == upgradeFrom then
            local res = IssueImmediateOrderById(playerBaseBuildings[playerIndex], FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].upgrade))
            if res == true then
                playerAIOrders[playerIndex] = playerAIOrders[playerIndex] + 1
            end
        else
            playerAIOrders[playerIndex] = playerAIOrders[playerIndex] + 1
        end
        return
    end

    printD("Build order for player " .. playerIndex .. " after " .. playerAIOrders[playerIndex], debugAIOrder)
end

function IncrementAIOrderEvent(player)
    playerAIOrders[GetPlayerId(player) + 1] = playerAIOrders[GetPlayerId(player) + 1] + 1
end GetOwningPlayer(GetTriggerUnit())