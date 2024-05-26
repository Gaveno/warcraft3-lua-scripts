function ProcessAIForPlayersEvent()
    for player = 1, 6 do
        -- if GetPlayerController(Player(player)) == MAP_CONTROL_COMPUTER then
            ProcessAIOrderForPlayer(player)
        -- end
    end
end

function ProcessAIOrderForPlayer(playerIndex)
    print("Processing AI for player" .. playerIndex)

    if humanBuildPriorities[playerAIOrders[playerIndex]] == nil then
        return
    end

    local orderType = humanBuildPriorities[playerAIOrders[playerIndex]].type
    print("Order type: " .. orderType)

    if orderType == "worker" then
        print("Processing worker order type")

        if GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_GOLD) >= GetUnitGoldCost(FourCC("nvlk")) then
            IssueImmediateOrderById(playerBaseBuildings[playerIndex], FourCC("nvlk"))
            -- playerAIOrders[playerIndex] = playerAIOrders[playerIndex] + 1
        end
        return
    end

    if orderType == "building" then
        print("Processing building order type")

        if GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_GOLD) >= GetUnitGoldCost(FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].building)) and
           GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_LUMBER) >= GetUnitWoodCost(FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].building)) then

            local commanderGroup = GetUnitsOfPlayerMatching(Player(playerIndex - 1), Condition(function()
                local com = GetUnitTypeId(GetFilterUnit())
                return com == FourCC("u000:uaco") or com == FourCC("uaco")
            end))

            ForGroup(commanderGroup, function()
                print("Issuing build order for commander")

                IssueBuildOrderById(
                    GetEnumUnit(),
                    FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].building),
                    GetRandomInt(GetRectMinX(playerBuildAreas[playerIndex]), GetRectMaxX(playerBuildAreas[playerIndex])),
                    GetRandomInt(GetRectMinY(playerBuildAreas[playerIndex]), GetRectMaxY(playerBuildAreas[playerIndex]))
                )
            end)
            
            -- playerAIOrders[playerIndex] = playerAIOrders[playerIndex] + 1
        end
        return
    end

    if orderType == "upgrade" then
        print("Processing upgrade order type")

        IssueImmediateOrderById(playerBaseBuildings[playerIndex], FourCC(humanBuildPriorities[playerAIOrders[playerIndex]].upgrade))
            -- playerAIOrders[playerIndex] = playerAIOrders[playerIndex] + 1
        return
    end
end

function IncrementAIOrderEvent(player)
    playerAIOrders[GetPlayerId(player) + 1] = playerAIOrders[GetPlayerId(player) + 1] + 1
    print("Incremended order for " .. GetPlayerId(player) + 1 .. " new order " .. playerAIOrders[GetPlayerId(player) + 1])
end GetOwningPlayer(GetTriggerUnit())