# Shadow of the Tomb Raider — iOS port research

An independent research and engineering project investigating whether a native ARM64 iOS port of **Shadow of the Tomb Raider: Definitive Edition** is technically possible.

## Target

- Native execution on iPhone and iPad (not cloud streaming or remote desktop).
- ARM64 iOS application distributed as an IPA for installation through a compatible sideloading workflow.
- Metal as the native graphics API, subject to proving that the original renderer and engine can be ported.
- Touch controls and external controller support.
- Original game data is not included. The user must provide legally obtained game files where licensing permits.

## Important status

**This repository is at the feasibility/research stage. It does not contain the game engine, a working port, or an IPA.** The Foundation Engine is proprietary; this project must not imply that the original engine source is available. A native port depends on obtaining a lawful, technically usable engine codebase or establishing a legitimate binary/platform-porting route. A Mac build using Metal is a useful reference, not proof that its renderer or binaries can run on iOS.

See:
- [Technical feasibility](docs/TECHNICAL_FEASIBILITY.md)
- [Porting plan](docs/PORTING_PLAN.md)

## Non-goals

- No cloud game streaming, remote PC execution, or browser video stream.
- No redistribution of game executables, proprietary engine code, or copyrighted game assets.
- No changes to the separate Generals iOS project.

## Current milestone

M0 — repository setup and technical feasibility. No native game runtime has been implemented or validated yet.
