local HttpService = game:GetService("HttpService")

local Vault = script.Parent
local Libs = Vault.Libs

local TypeDefs = require(Vault.TypeDefs)

local Item = {}
Item.__index = Item

function Item.new(ItemConfig: TypeDefs.ItemConfig): TypeDefs.InventoryItem
	local self = setmetatable({
		name = ItemConfig.name,
		meta = ItemConfig.meta,
		__id = ItemConfig.__id or HttpService:GenerateGUID(false),
	}, Item)

	return self
end

function Item.__tostring(item)
	return item.name .. "$-" .. item.__id
end

function Item:GetObjectInterpretation()
	return {
		id = self.__id,
		name = self.name,
		meta = self.meta,
	}
end

return table.freeze(Item)
