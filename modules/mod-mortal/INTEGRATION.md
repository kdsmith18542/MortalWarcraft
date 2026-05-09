# AzerothCore Integration Guide - mod-mortal

## Status: INTEGRATED

The prepared statements have been registered directly in `azerothcore/`:
- `CharacterDatabase.h` — enum entries added before `MAX_CHARACTERDATABASE_STATEMENTS`
- `CharacterDatabase.cpp` — `PrepareStatement()` calls added at end of `DoPrepareStatements()`

The module wrapper function `Addmod_mortalScripts()` calls `AddSC_mod_mortal()`.

### Building

```bash
cd azerothcore
mkdir build && cd build
cmake .. -DMODULES=dynamic
make -j$(nproc)
```

### Submodule note

AC source edits live inside the `azerothcore/` submodule. If you fork AC, push those changes to your fork and update `.gitmodules`:

```bash
cd azerothcore
git remote add myfork https://github.com/YOUR_USER/azerothcore-wotlk.git
git add -A
git commit -m "feat: add mortal-warcraft prepared statements"
git push myfork
cd ..
# Update .gitmodules to point to your fork
```
