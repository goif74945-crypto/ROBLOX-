# P1 TEST RUNBOOK

## Test 01 — Start
1. เปิด Place ผ่าน Rojo/Studio
2. Play Solo
3. ตรวจ Output ต้องเห็น `P1 Core Loop initialized`
4. ผู้เล่นต้องเกิดที่ `R1_ENTRY_SPAWN`

## Test 02 — Evidence
1. เดินไป `P1_EVIDENCE_CRATE`
2. ใช้ปุ่ม `ตรวจ`
3. Server ต้องตรวจ object + distance + interaction id
4. ได้ `EVIDENCE_CAPSULE` ใน evidence inventory
5. Objective เปลี่ยนเป็นกลับจุดสกัด

## Test 03 — Trace
1. เดิน/วิ่งใน R1
2. ตรวจว่า Listener เปลี่ยนจาก IDLE ไป INVESTIGATE/TRACK หลังพบสัญญาณ
3. เดินหลบและหยุดสร้าง trace
4. Listener ต้องสามารถค้นหาต่อแล้วกลับพื้นที่ต้นทางได้

## Test 04 — Extraction
1. หลังเก็บหลักฐาน กลับ `MAIN_EXTRACTION`
2. กดสกัด
3. อยู่ในพื้นที่ต่อเนื่องจน commit ครบ
4. Run เปลี่ยน `COMPLETE`
5. XP/Knowledge ถูกเพิ่ม

## Test 05 — Extraction Cancel
1. เริ่มสกัด
2. เดินออกจาก zone ก่อน commit ครบ
3. Server ต้องยกเลิกการสกัด
4. Run ยังไม่สำเร็จ

## Test 06 — Death/Recovery
1. เข้าเขต Listener จนถูกโจมตี
2. Health ต้องถึง Downed
3. Run เปลี่ยน Recovery
4. หลัง delay ผู้เล่นกลับ spawn
5. health/light reset
6. expedition inventory/evidence ถูก reset ตาม P1 rule
7. run id ใหม่

## Test 07 — Remote Abuse
พยายามส่ง:
- object ที่อยู่นอก workspace
- object ที่ไม่ใช่ evidence crate
- interaction id ปลอม
- extraction ขณะ objective ยังไม่ครบ
- extraction นอก zone
- repeated spam
Expected: request ถูกปฏิเสธโดย server

## Test 08 — Multiplayer
1. 2 players
2. ทั้งคู่สร้าง traces
3. Listener ต้องตอบสนองต่อ trace ที่มีอยู่จริง
4. การเก็บ evidence ของแต่ละคนไม่ควรเปลี่ยน inventory ของอีกคน
5. extraction ของหนึ่งคนไม่ควร grant inventory ให้คนอื่นโดยตรง

## Test 09 — Performance
บันทึก:
- Script time
- Memory
- Network
- Physics
- Entity count
- Active traces
- Remote requests

ใช้ MicroProfiler และ Developer Console ใน Studio/Client test

## Test 10 — Acceptance
P1 จะไม่ถูกทำเครื่องหมาย `VERIFIED` จนกว่า Test 01–09 จะมี evidence จริง
