# HORRORFORGE P1 — CORE LOOP / REPAIRED CONTRACT

P1 scope remains locked to one region (`R1_ENTRY_MARSH`), one entity (`E01_LISTENER`), one objective (`P1_COLLECT_EVIDENCE`), one evidence interaction (`P1_SEARCH_EVIDENCE`), one extraction (`MAIN_EXTRACTION`), and the existing trace channels.

The evidence interaction is now server-timed: start -> active search -> cancellation on repeat interaction or failed final validation -> completion only after `SearchDuration`. Extraction is server-timed with final in-zone revalidation.

Death recovery applies bounded loss only to eligible carried consumables/materials, clears the temporary route hint, and leaves persistent knowledge/evidence state intact.

Runtime validation is still required in Roblox Studio.
