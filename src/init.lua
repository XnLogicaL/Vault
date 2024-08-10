--/*
--/*    Vault v0.1a {Stable}
--/*
--/*    Author: @XnLogicaL (@CE0_OfTrolling on Roblox)
--/*  	License: MIT
--/*
--/*	This is a superset and/or remake of my original OpenInventory project which was unorganized, error prone and lacking in functionality.
--/*    With this project, I aim to bring you one of the best inventory managment resources.
--/*
--/*    There are a few things to watch out for during production;
--/*
--/*    ! DO NOT SAVE INVENTORIES AS RAW DATA, INSTEAD USE THE BUILT IN ENCODER/DECODER
--/*    ! DO NOT REFERENCE NON-PRIMITIVE (Including functions) TYPES IN META DATA
--/*
--/*	Simple API:
--/*
--/*	```lua
--/*	Vault.new(
--/*		_size,
--/*		_contents,
--/*		_meta
--/*	) -> InventoryInstance
--/*	```
--/*
--/*	Creates a new InventoryInstance
--/*
--/*	----------------------------------------
--/*
--/*	```lua
--/*	Vault.Is(object) -> bool
--/*	```
--/*
--/*	returns a boolean value that represents if the given object is an InventoryInstance.
--/*
--/*	----------------------------------------
--/*
--/*	```lua
--/*	Vault:Encode(object) -> string
--/*	```
--/*
--/*	returns a string interpretation of the given object [VERSION DEPENDENT]
--/*
--/*	----------------------------------------
--/*
--/*	```lua
--/*	Vault:DecodeAndWrap(object) -> InventoryInstance
--/*	```
--/*
--/*	Inverse of Vault:Encode()
--/*
--/*

local Info = {
	Version = "v0.1a",
	DisplayVersionMismatch = true,
}

local Defaults = {
	InventorySize = 15,
	InventoryContents = {},
	InventoryMetaData = {},
}

local HttpService = game:GetService("HttpService")

local Libs = script.Libs

local Signal = require(Libs.Signal)

local Registry = require(script.Registry)
local Utils = require(script.Util)
local TypeDefs = require(script.TypeDefs)
local Inventory = require(script.Inventory)
local Encoder = require(script.Encoder)
local Item = require(script.Item)

local Vault = {}
Vault.__index = Vault

Vault.Registry = Registry
Vault.Items = Item
Vault.Types = TypeDefs

function Vault.new(_size: number?, _contents: { any? }?, _meta: { any? }?): TypeDefs.InventoryInstance
	assert(Utils.ValidateConstructorArguments(_size, _contents, _meta))

	local self = setmetatable({
		_contents = _contents or Defaults.InventoryContents,
		_size = _size or Defaults.InventorySize,
		_meta = _meta or Defaults.InventoryMetaData,
		_id = HttpService:GenerateGUID(false),
		_link = nil,
		_locked = false,

		ItemAdded = Signal.new(),
		ItemRemoving = Signal.new(),
		Destroying = Signal.new(),
	}, Inventory)

	Registry:Register(self)

	return self
end

function Vault.Is(object: any)
	return
		type(object) == "table"
		and getmetatable(object) == Inventory
end

function Vault:DecodeAndWrap(obj: string)
	return self.new(
		Encoder:Decode(
			obj,
			Info.Version,
			Info.DisplayVersionMismatch
		)
	)
end

function Vault:Encode(obj: TypeDefs.InventoryInstance)
	return Encoder:Encode(obj, Info.Version)
end

return table.freeze(Vault)
