# Naming Conventions

## Guiding Rules

| Usage    | Guideline                               | Good Example                  | Bad Examples                     |
|----------|------------------------------------------|-------------------------------|----------------------------------|
| OO Class | Use role in the suffix                   | `OrderBuilder`, `*Setter`, `*Manager` | `OrderOO`, `OrderProcessing`, `ApiOnlineOrders` |
| Variable | Precise, intent-reveal, no disinformation | `Integer totalAmount`, `String productType` | `objOO`, `strItems`, `idCLPAgr` |
| List/Set | Plural nouns, no `List`, `Set` suffixes   | `accountIds`                  | `accountIdList`, `accountIdSet`, `myAccount` |
| Map      | Semantic map naming                      | `IdToAccount`, `itemsByType`, `accountLookup`, `accountMap` | `map`, `dataMap`, `resultMap` |

## Calibrated OO Suffixes

The validator accepts these OO suffixes:

- `Builder`
- `Setter`
- `Manager`
- `Validator`
- `Enricher`
- `Mapper`
- `Provider`
- `Factory`
- `Handler`
- `Processor`
