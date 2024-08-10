local HttpService = game:GetService("HttpService")

local Vault = script.Parent
local Libs = Vault.Libs

local TypeDefs = require(Vault.TypeDefs)
local Item = require(Vault.Item)

local Promise = require(Libs.Promise)

local versionBodySeperator = "$-"

local Encoder = {}
Encoder.__index = Encoder

function Encoder.EncodeItem(item: TypeDefs.InventoryItem)
	return HttpService:JSONEncode({
		n = item.name,
		m = item.meta,
	})
end

function Encoder.DecodeItem(item: string)
	local itemInfo = HttpService:JSONDecode(item)
	return select(
		2,
		Promise.new(function(resolve)
			resolve(Item.new({
				name = itemInfo.n,
				meta = itemInfo.m,
				__id = HttpService:GenerateGUID(false),
			}))
		end)
			:catch(warn)
			:await()
	)
end

function Encoder:Encode(object: TypeDefs.InventoryInstance, version: string)
	local toSerialize = {}
	local encodedContents = {}

	for _, item in object._contents do
		encodedContents[item.__id] = self.EncodeItem(item)
	end

	toSerialize._c = encodedContents
	toSerialize._s = object._size
	toSerialize._m = HttpService:JSONEncode(object._meta)

	return string.format("%s%s%s", version, versionBodySeperator, HttpService:JSONEncode(toSerialize))
end

function Encoder:Decode(object: string, version: string, doWarning: boolean)
	local objectComponents = object:split(versionBodySeperator)
	local objectVersion = objectComponents[1]
	local object = HttpService:JSONDecode(objectComponents[2])

	if objectVersion ~= version and doWarning then
		warn(table.concat({
			"version mismatch\n Object version: ",
			objectVersion,
			"\n Vault version: ",
			version,
			"\n action may be required\n",
			"to disable this warning, change the 'DisplayVersionMismatch' property to false inside the core module",
		}))
	end

	local meta = HttpService:JSONDecode(object._m)
	local size = tonumber(object._s)
	local decodedContents = {}

	for _, item in HttpService:JSONDecode(object._c) do
		local decodedItem = self.DecodeItem(item)
		decodedContents[decodedItem.__id] = decodedItem
	end

	return size, decodedContents, meta
end

return Encoder