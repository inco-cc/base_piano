-- See LICENSE file for copyright and license details.

AddCSLuaFile()

local registry = debug.getregistry()

if not istable(registry.Piano) then
    registry.Piano = {}
end

local Entity = registry.Entity
local Piano = registry.Piano

Piano.MetaName = "Piano"
Piano.MetaID = TYPE_ENTITY
Piano.MetaBaseClass = Entity
Piano.__newindex = Entity.__newindex

function Piano:__index(key)
    if Piano[key] ~= nil then
        return Piano[key]
    else
        return Entity.__index(self, key)
    end
end

function Piano:__tostring()
    return Entity.__tostring(self):Replace("Entity", "Piano")
end

function Piano:IsPiano()
    return true
end

function Piano:GetPod()
    return self:GetNW2Entity("Pod", NULL)
end

function Piano:SetPod(pod)
    self:SetNW2Entity("Pod", pod)
end
