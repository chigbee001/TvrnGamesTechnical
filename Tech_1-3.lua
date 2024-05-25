-- Q1 - Fix or improve the implementation of the below methods

-- Magic numbers moved to local variables to improve readability
local STORAGE_KEY = 1000
local RESET_VALUE = -1
local DELAY = 1000

-- Function to release storage for the player by setting the storage value to RESET_VALUE
local function releaseStorage(player)
    -- Check if the player object is valid
    if player then
        -- Error handling with pcall to catch and print any errors
        local success, err = pcall(function() player:setStorageValue(STORAGE_KEY, RESET_VALUE) end)
        -- Print error message in case of failure
        if not success then
            print("Error setting storage value: " .. tostring(err))
        end
    else
        -- Print message for nil player case
        print("releaseStorage called with nil player")
    end
end

-- Function that gets called when a player logs out
function onLogout(player)
    -- Check if the player object is valid
    if player then
        -- Get the storage value for the given key
        local storageValue = player:getStorageValue(STORAGE_KEY)
        -- Check if the storage value is 1
        if storageValue == 1 then
            -- Schedule the releaseStorage function to be called after DELAY milliseconds
            addEvent(releaseStorage, DELAY, player)
        end
    else
        -- Print message for nil player case
        print("onLogout called with nil player")
    end
    return true -- Always return true to indicate successful logout handling
end

--Q2 - Fix or improve the implementation of the below method

-- Function to print names of all guilds that have fewer than memberCount max members
function printSmallGuildNames(memberCount)
    -- Construct the SQL query to select guild names with max_members less than memberCount
    local selectGuildQuery = string.format("SELECT name FROM guilds WHERE max_members < %d", memberCount)
    -- Execute the query and store the result
    local resultId = db.storeQuery(selectGuildQuery)

    -- Check if the query returned any results
    if resultId then
        -- Loop through all results
        repeat
            -- Get the guild name from the current result row
            local guildName = result.getString(resultId, "name")
            -- Print the guild name
            print(guildName)
        -- Move to the next result row, if any
        until not result.next(resultId)
        -- Free the result to avoid memory leaks
        result.free(resultId)
    else
        -- Print a message if no guilds were found
        print("No guilds found with member count less than " .. memberCount)
    end
end

--Q3 - Fix or improve the name and the implementation of the below method

-- Function to remove a member from a player's party based on the member's name
function removePlayerFromParty(playerId, memberName)
    -- Get the player object by playerId
    local player = Player(playerId)
    -- Check if the player object is valid
    if not player then
        print("Player not found for playerId: " .. tostring(playerId))
        return
    end

    -- Get the player's party
    local party = player:getParty()
    -- Check if the party object is valid
    if not party then
        print("Player does not have a party.")
        return
    end

    -- Iterate through all members of the party
    for _, member in pairs(party:getMembers()) do
        -- Check if the member's name matches the specified memberName
        if member:getName() == memberName then
            -- Remove the member from the party
            party:removeMember(member)
            print("Member " .. memberName .. " removed from the party.")
            return -- Exit the function after removing the member
        end
    end

    -- If the loop completes, the member was not found in the party
    print("Member " .. memberName .. " not found in the party.")
end
