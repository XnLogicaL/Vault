local Vault = script.Parent
local Libs = Vault.Libs

local Signal = require(Libs.Signal)

export type Signal = Signal.Signal
export type Connection = Signal.Connection

export type InventoryItem = {
	name: string,
	__id: string,
	meta: { any? },
}

export type ItemConfig = {
	name: string,
	meta: { any? },
}

export type InventoryInstance = {
	ItemAdded: Signal.Signal<InventoryItem>,
	ItemRemoving: Signal.Signal<InventoryItem>,
	Destroying: Signal.Signal,

	Link: (self: InventoryInstance, player: Player) -> (),
	SetMetaData: (self: InventoryInstance, data: { any? }) -> (),
	GetMetaData: (self: InventoryInstance) -> { any? },
	SetSize: (self: InventoryInstance, size: number) -> (),
	GetSize: (self: InventoryInstance) -> number,
	IsLocked: (self: InventoryInstance) -> boolean,
	IsFull: (self: InventoryInstance) -> boolean,
	IsEmpty: (self: InventoryInstance) -> boolean,
	RetrieveItemNames: (self: InventoryInstance) -> { string },
	Reconcile: (self: InventoryInstance) -> (),
	RemoveContents: (self: InventoryInstance) -> (),
	HasItem: (self: InventoryInstance, item: InventoryItem) -> boolean,
	HasItemWithId: (self: InventoryInstance, itemId: string) -> boolean,
	HasItemWithName: (self: InventoryInstance, itemName: string) -> boolean,
	GetItemById: (self: InventoryInstance, itemId: string) -> InventoryItem?,
	GetFirstItemByName: (self: InventoryInstance, itemName: string) -> InventoryItem?,
	AddItem: (self: InventoryInstance, item: InventoryItem) -> (),
	RemoveItem: (self: InventoryInstance, fromId: boolean, query: string) -> (),
}

return {}