# IMPORT GUIDE — HORRORFORGE-X100

## วิธีติดตั้งแบบไฟล์ตรง
1. สร้าง Roblox place ใหม่
2. สร้างโครงตาม `default.project.json` หรือสร้าง Folder/ModuleScript ตาม `manifests/FILE_MANIFEST.json`
3. วาง `src/shared` ใต้ `ReplicatedStorage/Shared`
4. วาง `src/server` ใต้ `ServerScriptService/HORRORFORGE_SERVER`
5. วาง `src/client` ใต้ `StarterPlayer/StarterPlayerScripts/HORRORFORGE_CLIENT`
6. สร้าง `ServerStorage/EntityTemplates` และเพิ่ม Models ที่มีชื่อตรงกับ Entity Definition เมื่อเริ่มใส่ Asset จริง
7. สร้าง Workspace folders: `Map`, `Interactive`, `SpawnPoints`, `EntitySpawns`, `Extraction`, `Runtime`
8. เปิด Play แล้วตรวจ Output หา `[HF-BOOT-001]`, `[HF-CLIENT-BOOT-001]` หรือ `[HF-CLIENT-BOOT-002]`

## Rojo
`default.project.json` เป็น mapping สำหรับ Rojo. Rojo เป็น offline/build tooling และไม่ใช่ dependency ของ runtime code

## Runtime gate
แพ็กเกจนี้ยังไม่มีหลักฐานว่า code ได้รันใน Roblox Studio จริงใน environment ปัจจุบัน จึงต้องใช้สถานะ `IMPLEMENTED — RUNTIME VALIDATION PENDING` จนกว่าจะมี Play/Test telemetry
