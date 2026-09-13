# CODE ARCHITECTURE

## Layers
1. Shared Definitions / Config / Utility
2. Server Services
3. Client Controllers / UI
4. Tests
5. Offline Validator

## Dependency rule
Bootstrap loads services in an explicit order. Services obtain dependencies through the ServiceContainer or direct ModuleScript requires only for stable shared definitions.

## Data-driven rule
Classes, Items, Abilities, Entities, Quests, Recipes, Events และ StatusEffects ถูกประกาศใน Shared Definitions เพื่อให้ balance เปลี่ยนโดยไม่ย้าย core logic

## File IDs
Generated FILE_MANIFEST uses stable path-derived IDs. A production revision must preserve IDs when renaming is avoided; intentional rename requires manifest revision.
