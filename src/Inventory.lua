--!strict
--[=[

	Inventory contents structure:
	
	contents: {
		[*name]: {
			[*id]: *meta or {};
		}
	}
	
	Variables with an aterisk (*) represent a certain property of an item (respectfully)
	
	name = Name
	id = Universally Unique Identifier
	meta = Meta Data
	
	-----------------------------------
	
	* Getting the quantity of an item:
		`#contents[*name]`
		
	* Getting the metadata of an item:
		`contents[*name][*id]`
		
	* Getting the size of the inventory.
		`#contents`
<
]=]
local SIZE_NULL_ERR = "size cannot be less than 0"
local INV_LOCKED_ERR = "this inventory is locked"
local INV_FULL_ERR = "attempt to append item to full inventory"
local ITEM_PRESENCE_ERR = "%s is not a valid member of inventory %s"
local OVERFLOW_DETECTED = "overflow detected (%s), attempting to fix..."
local EMPTY_CATEGORY_DETECTED = "empty item category detected (%s), attempting to fix..."

local Vault = script.Parent
local Libs = Vault.Libs

local Registry = require(Vault.Registry)
local Util = require(Vault.Util)
local Item = require(Vault.Item)
local TypeDef = require(Vault.TypeDefs)

local Promise = require(Libs.Promise)
local t = require(Libs.t)

--/* Class
local Inventory = {}
Inventory.__index = Inventory

--/* Metamethods
function Inventory.__len(t)
	return Util.CountKeys(t._contents)
end
function Inventory.__tostring(t)
	return "Object " .. t._id
end
function Inventory.__newindex(t, k, v)
	Util.Log(string.format("attempt to set new key (%s) to locked metatable", k))
end
function Inventory.__eq(t, other)
	return false
end

--/* One-Liners (not meant to obfuscate lol)
function Inventory:GetLinked()
	return self._link
end
function Inventory:GetSize()
	return self._size
end
function Inventory:GetId()
	return self._id
end
function Inventory:IsLocked()
	return self._locked
end
function Inventory:SetLocked(v: boolean)
	self._locked = v
end
function Inventory:IsFull()
	return #self._contents == self._size
end
function Inventory:IsEmpty()
	return #self._contents == 0
end
function Inventory:GetMetaData()
	return self._meta
end
function Inventory:GetContents()
	return self._contents
end

--/* Functions
function Inventory:Link(player: Player)
	if Registry:GetObjectByLink(player) then
		return
	end
	Registry[player] = self._id
	rawset(self, "_link", player)
end

function Inventory:SetSize(size: number)
	assert(t.integer(size))
	assert(size >= 0, SIZE_NULL_ERR)
	rawset(self, "_size", size)
end

function Inventory:RemoveContents()
	assert(not self:IsLocked(), INV_LOCKED_ERR)
	table.clear(self._contents)
end

function Inventory:HasItemWithId(itemId: string)
	return self:GetItemById(itemId) ~= nil
end

function Inventory:HasItem(item: TypeDef.InventoryItem)
	return self:HasItemWithName(item.name) and self:HasItemWithId(item.__id)
end

function Inventory:HasItemWithName(itemName: string)
	local itemCell = self._contents[itemName]
	return itemCell and #itemCell > 0
end

function Inventory:Reconcile()
	return select(
		2,
		Promise.new(function(resolve, reject)
			local overflow = Util.CountKeys(self._contents) - self._size
			local itemNames = Util.GetKeys(self._contents)
			if overflow > 0 then
				Util.Log(OVERFLOW_DETECTED:format(overflow))
				for i = 1, overflow do
					local item = self:GetFirstItemByName(itemNames[#itemNames])
					local name, id = next(item)
					self:RemoveItem(true, id)
				end
			end
			for itemName, itemCell in self._contents do
				if Util.CountKeys(itemCell) == 0 then
					-- Commented because it floods the console
					-- Util.Log(EMPTY_CATEGORY_DETECTED:format(itemName))
					self._contents[itemName] = nil
				end
			end
			resolve()
		end)
			:catch(Util.Log)
			:await()
	)
end

function Inventory:SetMetaData(data: { any? })
	assert(not self:IsLocked(), INV_LOCKED_ERR)
	assert(t.table(data))
	self._meta = Util.FixMetaData(data)
end

function Inventory:GetItemById(itemId: string)
	for itemName, itemCell in self._contents do
		local meta = itemCell[itemId]
		if not meta then
			continue
		end
		return Item.new({
			name = itemName,
			__id = itemId,
			meta = meta,
		})
	end
	return nil -- Type checker is drunk for some reason
end

function Inventory:GetFirstItemByName(itemName: string)
	local itemCategory = self._contents[itemName]
	local keys = Util.GetKeys(itemCategory)
	return itemCategory[keys[1]]
end

function Inventory:AddItem(item: TypeDef.InventoryItem)
	assert(not self:IsLocked(), INV_LOCKED_ERR)
	assert(t.item(item))

	if Util.AssertWarn(not self:IsFull(), "cannot append to full inventory") then
		return
	end

	if self:HasItemWithName(item.name) then
		self._contents[item.name][item.__id] = item.meta
	else
		self._contents[item.name] = { [item.__id] = item.meta }
	end

	self:Reconcile()

	self.ItemAdded:Fire(item)
end

function Inventory:RemoveItemWithId(itemId: string)
	assert(not self:IsLocked(), INV_LOCKED_ERR)
	local meta, name

	local item = self:GetItemById(itemId)
	local contents = self._contents

	assert(item ~= nil, ITEM_PRESENCE_ERR:format(itemId, self:__tostring()))

	local category = contents[item.name]

	name, meta = item.name, category[itemId]
	category[itemId] = nil

	self:Reconcile()

	self.ItemRemoving:Fire(Item.new({
		meta = meta,
		name = name,
		__id = itemId,
	}))
end

function Inventory:RemoveItemWithName(itemName: string)
	assert(not self:IsLocked(), INV_LOCKED_ERR)
	assert(self._contents[itemName], ITEM_PRESENCE_ERR:format(itemName, self:__tostring()))

	local id, meta

	local contents = self._contents
	local category = contents[itemName]
	local keys = Util.GetKeys(contents)
	-- Used # op because it is a O(1) Constant operation compared to Util.CountKeys() which is a O(n) Linear operation
	local len = #keys

	id, meta = keys[len], category[keys[len]]
	category[itemName][keys[len]] = nil

	self:Reconcile()

	self.ItemRemoving:Fire(Item.new({
		meta = meta,
		name = itemName,
		__id = id,
	}))
end

function Inventory:Destroy()
	self.Destroying:Fire()
	Registry:Unregister(self)
	self.ItemRemoving:DisconectAll()
	self.ItemAdded:DisconnectAll()
	table.clear(self)
	setmetatable(self, nil)
end

return Inventory
