# InventoryInstance

---

The structure that the inventory stores item data:

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

---

## Properties

---

### ItemAdded

```lua
InventoryInstance.ItemAdded<InventoryItem>
```

An RBXScriptSignal replica that gets fired every time `Inventory:AddItem(item)` is used.

Fires attached with the item that is being added to the inventory.

---

### ItemRemoving

```lua
InventoryInstance.ItemRemoving<InventoryItem>
```

An RBXScriptSignal replica that gets fired every time `Inventory:RemoveItem(...)` is used.

Fires attached with the item that is being removed from the inventory.

---

### Destroying

```lua
InventoryInstance.Destroying
```

An RBXScriptSignal replica that gets fired when the destructor method `Inventory:Destroy()` is called.


## Methods

---

### Link

```lua
InventoryInstance:Link(
    player: Player
) -> ()
```

Links the inventory to the given player ONLY if the player does not have a linked inventory already.

This method serves the purpose of making the inventory more unique and abstract.

---

### GetLinked

```lua
InventoryInstance:GetLinked() -> Player?
```

Returns the linked player if there is one.

---

### SetSize

```lua
InventoryInstance:SetSize(
    size: int
) -> ()
```

Sets the maximum number of items that can simultaneously be present inside the contents of an inventory.

---

### GetSize

```lua
InventoryInstance:GetSize() -> int
```

Returns the maximum number of items that can simultaneously be present inside the contents of an inventory.

---

### GetId

```lua
InventoryInstance:GetId() -> string
```

Returns the universeally unique id of the InventoryInstance.

---

### IsLocked

```lua
InventoryInstance:IsLocked() -> bool
```

Returns if wether or not the private property of `Inventory._locked` is true.

!!! note
    If locked, an inventory essentially becomes uneditable unless unlocked.

---

### SetLocked

```lua
InventoryInstance:SetLocked(
    locked: bool
) -> ()
```

Sets the private `Inventory._locked` property to the given value.

---

### IsFull

```lua
InventoryInstance:IsFull() -> bool
```

Surveys the inventory to return if wether or not it's full.

### IsEmpty

```lua
InventoryInstance:IsEmpty() -> bool
```

Surveys the inventory to return if wether or not it's completely empty.

---

### RetrieveItemNames

```lua
InventoryInstance:RetrieveItemNames() -> {string?}
```

Internal method used to retrieve the names of every present item inside the contents of the inventory.

`O(n)` operation.

---

### RetrieveItemIds

```lua
InventoryInstance:RetrieveItemIds() -> {string?}
```

Internal method used to retrieve the Ids of every present item inside the contents of the inventory.

`O(n)` operation.

---

### Reconcile

```lua
InventoryInstance:Reconcile() -> ()
```

Safety method that checks for item overflow (# of items being larger than the maximum capacity) and corrects it.

Starts deleting from the bottom of the contents until the overflow is fixed.

---

### GetMetaData

```lua
InventoryInstance:GetMetaData() -> {any?}
```

Returns the meta data that is attached to the table.

---

### SetMetaData

```lua
InventoryInstance:SetMetaData(
    data: {any?}
) -> ()
```

Sets the attached meta data to the given value.

---

### RemoveContents

```lua
InventoryInstance:RemoveContents() -> ()
```

Irreversible operation that wipes the contents of the inventory.

---

### GetItemById

```lua
InventoryInstance:GetItemById(
    id: string
) -> InventoryItem?
```

Internal method used to fetch an item using it's id.

---

### GetFirstItemByName

```lua
InventoryInstance:GetFirstItemByName(
    name: string
) -> InventoryItem?
```

Internal method that fetches the first item with give name.

---

### HasItem

```lua
InventoryInstance:HasItem(
    item: InventoryItem
) -> bool
```

Returns true if the given item is present inside the inventory.

---

### HasItemWithId

```lua
InventoryInstance:HasItemWithId(
    id: string
) -> bool
```

Returns true if an item with an id equievelant to the given id is present inside the inventory.

---

### HasItemWithName

```lua
InventoryInstance:HasItemWithName(
    name: string
) -> bool
```

Returns true if at least 1 item with the given name is present inside the inventory.

---

