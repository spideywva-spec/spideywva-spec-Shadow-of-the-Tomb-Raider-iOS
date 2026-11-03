# Native engine foundation

This is an original, minimal Metal-based engine prototype. It is not Crystal Dynamics' proprietary Foundation Engine and does not load Shadow of the Tomb Raider content.

## Implemented foundation
- Engine math: transforms and perspective projection.
- Scene graph: nodes, mesh data, and camera.
- Built-in indexed diagnostic cube mesh.
- Initial single-pointer drag input state.
- Metal render pipeline, indexed mesh submission, depth testing, and frame timing.

## Not implemented
- No game asset importer, skeletal animation, terrain, physics, AI, audio, streaming, save system, cinematics, or game scripting.
- No compatibility with proprietary SOTTR packages or encrypted/protected game data.
- No original Foundation Engine code or game assets are included.

## Next milestones
1. Validate the iOS device build and fix compiler/runtime issues.
2. Add robust multi-touch camera controls and controller input.
3. Add a documented open asset format pipeline (glTF 2.0), texture loading, and PBR materials.
4. Add lighting/shadows, terrain, animation, and profiling.
5. Investigate game-specific content only if a lawful, technically documented asset/engine path exists.
