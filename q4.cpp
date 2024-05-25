//Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    // Try to get the player by name
    Player* player = g_game.getPlayerByName(recipient);
    bool playerWasCreated = false;

    if (!player) {
        // If the player doesn't exist, create a new player instance
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            // If the player can't be loaded, clean up and return
            delete player;
            return;
        }
        playerWasCreated = true;
    }

    // Create the item
    Item* item = Item::CreateItem(itemId);
    if (!item) {
        // If the item creation fails, clean up and return
        if (playerWasCreated) {
            delete player;
        }
        return;
    }

    // Add the item to the player's inbox
    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    // If the player was created by this function and is offline, save and delete the player
    if (playerWasCreated && player->isOffline()) {
        IOLoginData::savePlayer(player);
        delete player;
    }
}