# TRACEABILITY

`SYSTEM_CODE_MATRIX.json` เชื่อม System -> File
`FILE_MANIFEST.json` เชื่อม File ID -> path -> run context -> status
`REMOTE_MANIFEST.json` เชื่อม Remote -> direction -> validation contract

Trace example:

`REQ-ABILITY-001`
→ `HF-SYS-ABILITY`
→ `src/server/Services/AbilityService.lua`
→ `src/client/Controllers/AbilityController.lua`
→ `RequestAbility`
→ `Smoke/Runtime validation`
