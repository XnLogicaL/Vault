local Vault = script.Parent
local Libs = Vault.Libs

local t = require(Libs.t)

local Util = {}

function Util.ValidateMetatable(obj, meta)
	return getmetatable(obj) == meta, string.format("bad metatable: %s expected, got %s", meta, getmetatable(obj))
end

function Util.ValidateConstructorArguments(a, b, c)
	return t.tuple(t.optional(t.integer), t.optional(t.table), t.optional(t.table))(a, b, c)
end

function Util.FixMetaData(data)
	local isTypeLegal = t.union(t.number, t.string, t.table, t.integer, t.none)
	local illegalTypeMarker = "*illegal_value*"
	for k, v in data do
		if not select(1, isTypeLegal(v)) then
			data[k] = illegalTypeMarker
		elseif t.table(v) then
			data[k] = Util.FixMetaData(data[k])
		end
	end
end

function Util.GetKeys(t)
	local keys = {}
	for k, _ in t do
		table.insert(keys, k)
	end
	return keys
end

function Util.CountKeys(t)
	return #Util.GetKeys(t)
end

function Util.Log(err)
	assert(t.string(err))
	warn("[Vault]: " .. err)
end

function Util.AssertWarn(cond, msg)
	if not cond then
		warn(msg)
	end
	return not cond
end

return Util
