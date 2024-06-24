-- See LICENSE file for copyright and license details.

include("shared.lua")

function ENT:Initialize()
    debug.setmetatable(self, FindMetaTable("Piano"))
end
