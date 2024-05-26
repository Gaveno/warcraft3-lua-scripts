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
    if humanBuildPriorities[playerAIOrders[playerIndex]] == nil then
        return
    end

    local orderType = humanBuildPriorities[playerAIOrders[playerIndex]].type

    if orderType == "worker" then
        if GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_GOLD) >= GetUnitGoldCost(FourCC("nvlk")) then
            if GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_FOOD_USED) < GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_FOOD_CAP) then
                IssueImmediateOrderById(playerBaseBuildings[playerIndex], FourCC("nvlk"))
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

            ForGroup(commanderGroup, function()
                if IssueBuildOrderById(
                    GetEnumUnit(),
                    FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].building),
                    GetRandomInt(GetRectMinX(playerBuildAreas[playerIndex]), GetRectMaxX(playerBuildAreas[playerIndex])),
                    GetRandomInt(GetRectMinY(playerBuildAreas[playerIndex]), GetRectMaxY(playerBuildAreas[playerIndex]))
                ) == false then
                    IssueImmediateOrderById(GetEnumUnit(), FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].building))
                end
            end)
        end
        return
    end

    if orderType == "upgrade" then
        local currentLevel = GetPlayerTechCountSimple(FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].upgrade), Player(playerIndex - 1))
        local upgradeFrom = humanBuildPriorities[playerAIOrders[playerIndex]].level

        if currentLevel == upgradeFrom then
            IssueImmediateOrderById(playerBaseBuildings[playerIndex], FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].upgrade))
        else
            playerAIOrders[playerIndex] = playerAIOrders[playerIndex] + 1
        end
        return
    end
end

function IncrementAIOrderEvent(player)
    playerAIOrders[GetPlayerId(player) + 1] = playerAIOrders[GetPlayerId(player) + 1] + 1
end GetOwningPlayer(GetTriggerUnit())