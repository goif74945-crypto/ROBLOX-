# CODE CONTRACTS

ทุก service ที่กระทบ gameplay ต้องมีแนวคิด contract:
- Input
- Validation
- State transition
- Output
- Failure code
- Recovery
- Persistence touchpoint
- Network boundary
- Performance constraint
- Test

## ตัวอย่าง Ability
`Client -> RequestAbility(abilityId) -> SecurityService -> AbilityService:CanUse -> state/cooldown/resource/class checks -> execute -> Notify`

## ตัวอย่าง Inventory
`Client intent -> server item ownership validation -> Add/Remove -> snapshot -> UI presentation`

ไม่มี remote ที่รับ arbitrary DataModel path หรือ arbitrary server state
