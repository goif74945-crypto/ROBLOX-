# HORRORFORGE-X100 — TECHNICAL ARCHITECTURE

## สถานะ
`IMPLEMENTED — RUNTIME VALIDATION PENDING`

### Authority boundary
Server เป็นแหล่งความจริงสำหรับ inventory, damage, health, objectives, quest progression, entity decisions, loot, crafting, economy, extraction, death/revive, progression, persistence และ ability legality

Client รับผิดชอบ input, UI, camera, presentation, local audio และ cosmetic VFX

### Network rule
Client ส่ง request ที่แคบและมี semantic ชัดเจน; Server ตรวจ type, state, ownership, permission, distance, cooldown และ rate limit ก่อนเปลี่ยน state

### Persistence
SaveService ใช้ DataStoreService และ UpdateAsync เพื่อเขียน profile; callback ของ UpdateAsync ไม่ yield

### AI
AIService ใช้ state machine + PathfindingService.CreatePath และคิดตาม state-dependent interval ไม่คำนวณ chase ทุก frame

### Streaming/performance
Project ถูกออกแบบให้รองรับ Instance Streaming สำหรับโลกขนาดใหญ่ แต่การตั้งค่า Workspace และ device budgets ต้องยืนยันใน Roblox Studio telemetry จริง

### Error policy
Startup dependency failure หยุด boot; request validation failure ตกลงเป็น error code และไม่เปลี่ยน state; data failure ใช้ default profile พร้อม telemetry/log
