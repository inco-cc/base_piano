-- See LICENSE file for copyright and license details.

AddCSLuaFile()

include("sh_class_entity.lua")
include("sh_class_player.lua")
include("sh_class_piano.lua")

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.KeyCount = 88
ENT.PedalCount = 3

function ENT:GetKeyCount()
    return self.KeyCount
end

function ENT:GetPedalCount()
    return self.PedalCount
end
