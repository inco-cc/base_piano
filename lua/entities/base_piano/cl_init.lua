-- See LICENSE file for copyright and license details.

include("shared.lua")
include("cl_library_piano.lua")

function ENT:Initialize()
    debug.setmetatable(self, FindMetaTable("Piano"))
end
