# Basic Usage

---

Once you've installed Vault using your preffered method, we can actually get started with using Vault.

!!! warning
    This article asumes familiarity with Lua and/or Luau.


## Requiring

---

Once you have setup your workspace/file system, go ahead and create a *Server* script.
In this script, require Vault using the `require()` function as shown below:

```lua
-- example.lua
local Vault = require(path.to.Vault)
```

## Creating a Basic System

---

After you've completed the previous step, now we can actually start implementing some features.
Start with creating a function that is intended to be called once a player joins:

```lua
-- example.lua
local Vault = require(path.to.Vault)

local function onPlayerAdded(player: Player)
    local playerInventory = Vault.new()
    playerInventory:Link(player)
end
```

The `:Link()` function is another way to make the inventory universally unique, as each player can only have a single attached inventory.

Next step is to actually connect the function to the `.PlayerAdded` event, so let's do it!

```lua
-- example.lua
local Players = game:GetService("Players")

local Vault = require(path.to.Vault)

local function onPlayerAdded(player: Player)
    local playerInventory = Vault.new()
    playerInventory:Link(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
```

Now that out of the way, we can do some customizing.
Let's say we want the default inventory size to be 20, we can do that by utilizing the `:SetSize(value)` function.

Additionally, we can attach meta data to an inventory, by using the `:SetMetaData(data)` function.

```lua
-- example.lua
local Players = game:GetService("Players")

local Vault = require(path.to.Vault)

local function onPlayerAdded(player: Player)
    local playerInventory = Vault.new()
    playerInventory:Link(player)
    playerInventory:SetSize(20)
    playerInventory:SetMetaData({
        foo = "bar"
    })
end

Players.PlayerAdded:Connect(onPlayerAdded)
```

### Items

---

Doing great so far! Now we'll look into the concept of an item object, which is basically a table with 3 properties:

- Meta Data
- Item Name
- Item ID

When using the built-in constructor, Item ID is automatically generated, whilst the other 2 properties can be customized.

!!! note
    The `name` property of an item is what classifies it inside the inventory index.

#### Creating an Item

---

First, we'll need to include a reference to the Item object constructor. We can do that by reading the `Vault.Item` property.

```lua
-- example.lua
local Players = game:GetService("Players")

local Vault = require(path.to.Vault)
local Item = Vault.Item

local function onPlayerAdded(player: Player)
    local playerInventory = Vault.new()
    playerInventory:Link(player)
    playerInventory:SetSize(20)
    playerInventory:SetMetaData({
        foo = "bar"
    })

    local myItem = Item.new({
        name = "myItem";
        meta = {};
    })
end

Players.PlayerAdded:Connect(onPlayerAdded)
```

Now we can use the `:AddItem(item)` and `:RemoveItem(bool, query)` methods to manage the inventory.

!!! note
    The `:RemoveItem()` function takes in 2 arguments, first one is a boolean which determines if the removal will be conducted by ItemId or by ItemName.
    The query argument represents the input required in each scenario.

We can implement this by providing the item we created to the `:AddItem()` function

```lua
-- example.lua
local Players = game:GetService("Players")

local Vault = require(path.to.Vault)
local Item = Vault.Item

local function onPlayerAdded(player: Player)
    local playerInventory = Vault.new()
    playerInventory:Link(player)
    playerInventory:SetSize(20)
    playerInventory:SetMetaData({
        foo = "bar"
    })

    local myItem = Item.new({
        name = "myItem";
        meta = {
            "myMetaData"
        };
    })

    playerInventory:AddItem(myItem)

    print(playerInventory:GetContents())
end

Players.PlayerAdded:Connect(onPlayerAdded)
```

=== "Output"
```
{
    ["myItem"] = {
        ["${__ItemId__}"] = { "myMetaData" }
    }
}
```

This tutorial was to show off the basic features of Vault, the code provided is not intended to be used in production.