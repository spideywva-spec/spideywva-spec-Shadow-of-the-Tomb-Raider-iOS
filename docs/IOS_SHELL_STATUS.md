# iOS Metal shell — prototype status

## What this prototype contains

- A SwiftUI iOS application entry point.
- A UIViewRepresentable host for MTKView backed by the device's default Metal device.
- A minimal runtime-compiled Metal shader that draws a colored triangle.
- An XcodeGen project definition targeting iOS 16.0 and iPhone/iPad (ARM64).
- A macOS GitHub Actions workflow that compiles the app for a generic iOS device without code signing and uploads the app bundle and build log.

## What it does not contain

- No Foundation Engine implementation or game code.
- No Shadow of the Tomb Raider assets, executable, shaders, levels, audio, or cinematics.
- No gameplay, touch mapping, save system, or controller integration yet.
- No signed IPA and no SideStore-installable package.

## Validation status

The source has been committed, but it is **not build-verified until the GitHub Actions workflow completes successfully**. A successful unsigned compile proves only that this original iOS shell compiles for the iOS device SDK. It does not prove that the game engine can run on iOS.

## Next technical gate

Before attempting to port the actual game, establish a lawful and technically viable route to the proprietary Foundation Engine. The user's Steam ownership alone does not provide the engine source or establish rights to bypass protections or redistribute game files.
