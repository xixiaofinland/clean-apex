# SOQL and Dependency Injection

SOQL that happens in the OO layer should live in methods of a selector/query class
and be defined as an OO class property so OO unit tests can mock it via dependency
injection.

## Testing Consequence

OO class tests must not use DML. When SOQL is needed, inject a selector/query
dependency to substitute out SOQL during OO unit tests.
