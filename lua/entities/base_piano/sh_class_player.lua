-- See LICENSE file for copyright and license details.

AddCSLuaFile()

local Player = FindMetaTable("Player")

function Player:GetPiano()
    local vehicle = self:GetVehicle()

    if vehicle:IsValid() then
        local owner = vehicle:GetOwner()

        if owner:IsValid() and owner:IsPiano() then
            return owner
        end
    end

    return NULL
end

function Player:IsUsingPiano()
    return self:GetPiano():IsValid()
end
