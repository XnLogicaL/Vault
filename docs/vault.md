# API Reference

---

This page references the root namespace.

## Properties

---

### Registry :material-alert-decagram:{ .mdx-pulse title="Read Only" }

```lua
Vault.Registry
```

Registry object containing essential methods for registering objects. 
Further documentation can be found [here](registry.md)

---

### Items :material-alert-decagram:{ .mdx-pulse title="Read Only" }

```lua
Vault.Items 
```

Items object containing a constructor method for creating items

---

### Types 

```lua
Vault.Types
```

A filler module containing types that are used throughout Vault. 
Further documentation can be found [here](types.md)

## Methods

---

### new

```lua
Vault.new(
    _size?: int,
    _contents?: {Item},
    _meta?: {any?}
) -> InventoryInstance
```

Constructs a new InventoryInstance with or without the parameters.

The given inventory object will be, no matter what, universally unique.

---

### Is

```lua
Vault.Is(
    object: any
) -> boolean
```

Checks if the given object is a valid InventoryInstance.

---

### DecodeAndWrap

```lua
Vault:DecodeAndWrap(
    obj: string
) -> InventoryInstance
```

Returns a new InventoryInstance with a name and meta data inherited from the encoded input and a unique id.

Is the inverse function of `Vault:Encode(InventoryInstance)`.

---

### Encode

```lua
Vault:Encode(
    obj: InventoryInstance
) -> string
```

Encodes the input InventoryInstance into a packed string with unique data that can be decoded.