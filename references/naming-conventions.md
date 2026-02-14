# Naming Conventions

## Guiding Rules

| Usage    | Guideline                               | Good Example                  | Bad Examples                     |
|----------|------------------------------------------|-------------------------------|----------------------------------|
| OO Class | Use role in the suffix                   | `OrderBuilder`, `*Setter`, `*Manager` | `OrderOO`, `OrderProcessing`, `ApiOnlineOrders` |
| Variable | Precise, intent-reveal, no disinformation | `Integer totalAmount`, `String productType` | `objOO`, `strItems`, `idCLPAgr` |
| List/Set | Plural nouns, no `List`, `Set` suffixes   | `accountIds`                  | `accountIdList`, `accountIdSet`, `myAccount` |
| Map      | Use lower camelCase `AtoB` naming (pluralize `B` when value is a collection) | `idToAccount`, `idToAccounts` | `IdToAccount`, `IdToAccounts`, `itemsByType`, `accountLookup`, `accountMap`, `map`, `dataMap`, `resultMap` |

## OO Class Naming: Singular vs Plural

| OO Class Handles | Naming | Good Example | Bad Example |
|-----------------|---------|--------------|-------------|
| Single record/value | Singular | `OrderBuilder`, `OrderNameNormalizer` | `OrdersBuilder` |
| Collection (List/Set/Map) | Plural | `OrdersProcessor`, `OrdersValidator` | `OrderProcessor` |

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
