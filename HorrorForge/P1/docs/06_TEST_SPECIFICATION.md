# TEST SPECIFICATION

## Automated smoke tests
`src/server/Tests/SmokeTests.lua` ตรวจ:
- default health
- default class
- inventory add/has
- damage
- heal

## Offline static validation
รัน:

```text
python tools/validate_project.py
```

ตรวจ:
- required service files
- empty Lua files
- forbidden production placeholders
- remote manifest presence

## Runtime validation ที่ยังต้องทำใน Studio
- DataStore behavior in published/testable place
- Remote abuse/fuzz tests
- AI pathing against real maps
- mobile touch UI
- low-end device performance
- streaming behavior
- save/load/rejoin/disconnect recovery
- 1-player and 4-player encounter fairness
