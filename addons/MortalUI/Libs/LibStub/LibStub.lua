-- LibStub is a simple versioning stub meant for use in WoW addon development
-- It allows multiple addons to share the same library without conflicts
-- Version: 1.0

local LIBSTUB_MAJOR, LIBSTUB_MINOR = "LibStub", 2
local LibStub = _G[LIBSTUB_MAJOR]

if not LibStub then
    LibStub = {}
else
    if LibStub.minor < LIBSTUB_MINOR then
        LibStub.minor = LIBSTUB_MINOR
    end
    return
end

LibStub.minor = LIBSTUB_MINOR
LibStub.libs = {}
LibStub.libnames = {}

function LibStub:NewLibrary(major, minor)
    assert(type(major) == "string", "Bad argument #2 to `NewLibrary' (string expected)")
    minor = assert(tonumber(strmatch(minor, "%d+")), "Minor version must be a number")
    
    local oldminor = self.libs[major]
    if oldminor and oldminor >= minor then
        return nil
    end
    
    self.libs[major] = minor
    self.libnames[major] = true
    
    return self.libs[major], oldminor
end

function LibStub:GetLibrary(major, silent)
    if not self.libs[major] and not silent then
        error(("Cannot find a library instance of %q."):format(tostring(major)), 2)
    end
    return self.libs[major], self.libnames[major]
end

function LibStub:IterateLibraries()
    return pairs(self.libs)
end

_G[LIBSTUB_MAJOR] = LibStub

