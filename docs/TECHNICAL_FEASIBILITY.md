# Technical feasibility and known constraints

## What is established

- The game is built on the proprietary Foundation Engine. No public source tree for the complete game engine has been established for this project.
- The Linux release uses Vulkan; the macOS release uses Metal; Windows releases use Direct3D. Different platform renderers do not automatically make the engine portable to iOS.
- The Mac release is a useful research target because Metal is already used there, but its executable, frameworks, architecture, entitlement assumptions, and platform dependencies must be inspected. A macOS binary is not an iOS binary and cannot simply be copied into an IPA.
- The Linux build can provide useful information about data formats and platform abstractions, but Vulkan-to-Metal translation or a renderer rewrite would be substantial work.
- Middleware and platform dependencies (including audio, UI, and video components) need separate iOS compatibility and licensing checks.

## Main technical risks

1. **Engine access:** without source code or an authorized porting interface, a maintainable native port may not be feasible.
2. **Binary/platform compatibility:** macOS and iOS differ in ABI, SDK, frameworks, sandboxing, signing, and supported APIs.
3. **Graphics:** a Metal renderer must support the game's actual rendering features, shaders, resource formats, synchronization, and memory constraints.
4. **Memory and thermal limits:** a desktop/console game with large assets and high memory requirements may exceed iPhone/iPad budgets without substantial optimization.
5. **Middleware:** audio, video, UI, input, and other licensed dependencies may not have iOS builds.
6. **Legal rights:** owning a copy of the game does not automatically grant rights to redistribute its files or bypass platform protections. No copyrighted game data or proprietary binaries belong in this repository.

## Research sequence

1. Identify the exact edition and source platform available to the developer.
2. Inspect file inventory and executable metadata without uploading proprietary files.
3. Record CPU architecture, linked libraries, graphics API, and middleware versions.
4. Determine whether a source-based port, authorized SDK route, or other lawful implementation path exists.
5. Only then select a technical prototype.

## Stop condition

If the only available route would require redistributing proprietary engine code/assets or bypassing protections without authorization, do not implement that route. Keep this repository limited to lawful research and original platform-side code.
