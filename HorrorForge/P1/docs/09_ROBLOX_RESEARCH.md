# ROBLOX RESEARCH REGISTER

## R-ROB-001 — Client-server security
แหล่ง: Roblox Creator Hub — Securing the client-server boundary

ข้อค้นพบที่ใช้กับโค้ด: ข้อมูลทุกชิ้นจาก client ต้องผ่าน server validation; state-changing remotes ควรตรวจ context/permission, ระยะ, state และ rate limit และไม่ควรให้ client ระบุ arbitrary instance/path เพื่อแก้ state

Source: https://create.roblox.com/docs/scripting/security/client-server-boundary

## R-ROB-002 — Remote events
RemoteEvent เหมาะกับการสื่อสาร one-way ที่ไม่ต้อง yield; RemoteFunction เป็น two-way และ yield ได้ จึงเลือก RemoteEvent สำหรับ gameplay requests ใน baseline

Source: https://create.roblox.com/docs/scripting/events/remote

## R-ROB-003 — DataStore
DataStoreService ใช้ UpdateAsync สำหรับการเปลี่ยน stored value และ callback ของ UpdateAsync ต้องไม่ yield

Source: https://create.roblox.com/docs/cloud-services/data-stores

## R-ROB-004 — Pathfinding
PathfindingService.CreatePath() รองรับ agent parameters และ path computation; implementation baseline ใช้ CreatePath + ComputeAsync + waypoint movement

Source: https://create.roblox.com/docs/reference/engine/classes/PathfindingService/CreatePath

## R-ROB-005 — Input
ContextActionService ใช้ bind contextual actions และสร้าง touch buttons ได้; UserInputService เป็น client-side input API จึงแยก input controller เป็น client

Sources:
https://create.roblox.com/docs/reference/engine/classes/ContextActionService
https://create.roblox.com/docs/reference/engine/classes/UserInputService

## R-ROB-006 — Streaming / performance
Roblox ระบุว่า Instance Streaming สามารถลด memory/load burden สำหรับโลกขนาดใหญ่ และการทำงานที่หนักทุก frame สามารถ overload task scheduler; baseline จึงหลีกเลี่ยง unbounded per-frame gameplay loops

Sources:
https://create.roblox.com/docs/performance-optimization/improve
https://create.roblox.com/docs/performance-optimization/microprofiler/task-scheduler

หมายเหตุ: ค่า performance budget ของเกมนี้ยังเป็น DESIGN TARGET จนกว่าจะวัดจริงใน Studio/device
