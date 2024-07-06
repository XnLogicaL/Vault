local ERR_UNREG_UNREG = "attempt to unregister unregistered object %s"
local ERR_REG_REG = "attempt to register object %s twice"

local Vault = script.Parent
local Libs = Vault.Libs

local Util = require(Vault.Util)
local TypeDefs = require(Vault.TypeDefs)

local t = require(Libs.t)
local Promise = require(Libs.Promise)

local Registry = {}
Registry.__index = Registry
Registry.r = {}
Registry.ir = {}

function Registry:GetObjectById(id: string): TypeDefs.InventoryInstance?
	return self.r[id] or self.ir[id]
end

function Registry:GetObjectByLink(player: Player): TypeDefs.InventoryInstance?
	assert(t.Instance(player))
	return self:GetObjectById(self.r[player])
end

function Registry:Register(object: any)
	return Promise.new(function(resolve, reject)
		assert(t.inventory(object))
		assert(self.r[object._id] == nil, ERR_REG_REG:format(tostring(object)))
		self.r[object._id] = object
		resolve()
	end)
		:catch(warn)
		:await()
end

function Registry:Unregister(object: any)
	return Promise.new(function(resolve, reject)
		assert(t.inventory(object))
		assert(self:GetObjectById(object._id) ~= nil, ERR_UNREG_UNREG:format(tostring(object)))
		self.r[object._id] = nil
		resolve()
	end)
		:catch(warn)
		:await()
end

function Registry:RegisterItem(object: any)
	return Promise.new(function(resolve, reject)
		assert(t.item(object))
		assert(self.ir[object.__id] == nil, ERR_REG_REG:format(tostring(object)))
		self.ir[object.__id] = object
		resolve()
	end)
		:catch(warn)
		:await()
end

function Registry:UnregisterItem(object: any)
	return Promise.new(function(resolve, reject)
		assert(t.item(object))
		assert(self:GetObjectById(object.__id) ~= nil, ERR_UNREG_UNREG:format(tostring(object)))
		self.ir[object.__id] = nil
		resolve()
	end)
		:catch(warn)
		:await()
end

return Registry
