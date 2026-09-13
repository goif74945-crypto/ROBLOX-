# HORRORFORGE P1 — FORENSIC REPAIR REPORT

## STATUS
`BLOCKED`

## Repairs applied
- Server/shared dependency references normalized to `ReplicatedStorage/Shared`.
- Evidence hut south wall opened with a 4-stud entrance.
- FILE_MANIFEST regenerated from every current Lua file.
- FINAL_VALIDATION / P1_STATIC_STATS / VALIDATOR_OUTPUT regenerated from the same current source state.
- Death recovery now performs bounded loss on eligible carried consumables/materials and preserves permanent knowledge/evidence; route hint is the temporary route-state advantage and is cleared on death.
- Profile data is hydrated into Inventory/Knowledge/Progression/Reputation/Achievement/Challenge runtime state.
- Sprint trace classification derives from server-observed displacement speed; client WalkSpeed is no longer trusted for TRACE.
- Evidence SearchDuration is enforced server-side with cancellation and final validation.
- Every Client→Server request remote has a server handler; out-of-P1 remotes are explicit scope-deny handlers.
- E01 signature timing is implemented through server-generated `AudioCue` events and existing noise/LOS counterplay.

## Evidence boundaries
The GDD defines the death loss as a bounded percentage but does not specify a numeric percentage; this package uses `BoundedLossFraction = 0.25` as an implementation parameter pending balance evidence, not as a new canon statement.

The GDD requires E01's signature of three irregular knocks followed by silence and counterplay based on reducing noise, breaking line-of-sight, and avoiding repeated door interactions. The code implements the timed three-cue signal plus noise/LOS counterplay. P1 contains no door interaction content, so door-specific counterplay remains **INCOMPLETE BY P1 CONTENT EVIDENCE** rather than being invented.

## Runtime boundary
No Roblox Studio or Luau runtime execution evidence exists in this environment. Therefore no runtime claim is made for player traversal, live AI movement, actual audio playback, multiplayer behavior, exploit fuzzing, device performance, or acceptance execution.
