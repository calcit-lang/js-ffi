# Validate public-check definition identities

CodeRabbit noted that matching only `checked_definition_ids.length` against
`definitions_selected` could accept a malformed report containing a duplicate
checked ID while omitting another selected definition.

`parsePublicCheckReport` now compares the unique checked IDs with the IDs in the
selected definition records, rejects duplicates, and still verifies the reported
selection count. The envelope regression test now covers the duplicate-and-omitted
case.
