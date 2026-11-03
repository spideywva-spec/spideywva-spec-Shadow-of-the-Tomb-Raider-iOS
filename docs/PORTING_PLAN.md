# Native iOS port — engineering plan

## M0 — feasibility gate (current)

1. Establish which legally available game build and files the developer owns.
2. Inventory the Mac and Linux game distributions: executable formats, architectures, dynamic libraries, renderer interfaces, middleware, and data layout.
3. Determine whether any engine source code or authorized porting SDK is available. Do not assume the proprietary Foundation Engine source is public.
4. Identify licensing restrictions for reverse engineering, modification, and use of platform binaries.
5. Define a minimal proof of concept only after the above checks.

**Exit criteria:** a documented, lawful implementation route and a buildable minimal target. If no lawful engine implementation route exists, stop rather than presenting a shell or asset viewer as a game port.

## M1 — iOS platform shell

Only after M0 passes:
- Xcode project targeting ARM64 iOS and the minimum supported iOS version.
- App lifecycle, file access, save-data locations, logging, crash reporting, and controller discovery.
- Metal device/command queue/swapchain and a simple test scene.
- IPA packaging and repeatable CI build.

## M2 — engine/platform adaptation

- Replace or adapt platform services (windowing, input, filesystem, threading, audio, video, networking).
- Port the renderer to Metal only if the source/authorized interfaces make this possible.
- Audit third-party middleware licenses and iOS availability (audio, UI, video, codecs).
- Keep game data external; never commit proprietary assets or binaries.

## M3 — gameplay and performance

- Input mapping for touch and controllers.
- GPU/CPU profiling on real target devices.
- Memory, thermal, storage, and background/foreground lifecycle work.
- Validate save/load, audio, cinematics, and gameplay systems.

## M4 — release validation

- Device matrix, clean-install tests, long-session stability, and performance targets.
- Verify all distribution and asset-license requirements.
- Produce a signed/unsigned IPA workflow appropriate to the user's installation method.

## Required evidence before claiming progress

A feature is not complete because a project file or stub exists. Record the exact device/simulator, Xcode version, build command, build result, logs, and runtime test. Never describe an unbuilt scaffold as a playable port.
