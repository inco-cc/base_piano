-- See LICENSE file for copyright and license details.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_library_piano.lua")

include("shared.lua")

function ENT:Initialize()
    debug.setmetatable(self, FindMetaTable("Piano"))

    local pod = ents.Create("prop_vehicle_prisoner_pod")

    if pod:IsValid() then
        pod:SetOwner(self)
        pod:SetParent(self)

        self:SetPod(pod)
        self:DeleteOnRemove(pod)
    end
end
