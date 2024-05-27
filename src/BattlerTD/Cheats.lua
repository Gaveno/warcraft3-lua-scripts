function GivePlayerGold(playerIndex, amount)
    SetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(playerIndex - 1), PLAYER_STATE_RESOURCE_GOLD) + amount)
end