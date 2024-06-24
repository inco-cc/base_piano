-- See LICENSE file for copyright and license details.

AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
    debug.setmetatable(self, FindMetaTable("Piano"))
end
