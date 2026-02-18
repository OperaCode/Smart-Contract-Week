### Assignment 1

## requirements

- Where are your structs, mappings and arrays stored.
- How they behave when executed or called.
- Why don't you need to specify memory or storage with mappings

## Responses

Structs, mappings and arrays are reference data types in Solidity - this means unlike **value data** types (such as uint,address, bool) which are basic data types that stores data directly and are copied  directly wherever they are called or used. Reference types do not carry the exact data copies, rather they store data by referencing a data location, thereby making it possible for two different variables can point to the same data location (storage, memory, calldata).

## What are reference data types and how do they behave , especially when called or executed ?

Depending on how they are used, reference data types store data at different storage locations (storage, memory, calldata). When declared at contract level (state variables) like **Structs**, they are stored on the blockchain storage as a persistent state.
### Features of Storage
- They are Permanent, persisitent and written to the blockchain.
- They are shared across functions call
- They are the most expensive (high gas)
When used inside a function, they are stored temporarily in memory at function execution stage/level.
### Features of Memory
- They are temporary
- They are cleared after function ends
- They are cheaper than storage.
When used as calldata, and used as external function parameters
### Features of Calldata
- They are immutable
- They cannot be modified
- They are the cheapest of all storage locations

### Explicit Storage locations:
- State structs → storage
- State arrays → storage
- Mappings → storage only
- Local structs/arrays → memory
- External parameters → calldata


## Why is memory or Storage is not specified when using mappings ?
Mappings only exist in storage, this is because mappings use hash-based addressing and they do not have length or sequential structure, therefore, Solidity enforces storage-onlyn with no need to explicitly declare a storage location.  





### Assignment 2

## requirements

- Look up ERC20 standard `Understand it like your life depends on it, because it does.`
- Write in Code the complete ERC20 implementation from scratch without using any libraries.