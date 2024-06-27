-- See LICENSE file for copyright and license details.

local Piano = FindMetaTable("Piano")

function Piano:GetKeyPressure(key)
    if self:IsKeyValid(key) then
        return self.KeyPressure[key] or 0
    else
        return -1
    end
end

function Piano:GetPedalPressure(pedal)
    if self:IsPedalValid(pedal) then
        return self.PedalPressure[pedal] or 0
    else
        return -1
    end
end

function Piano:IsKeyPressed(key)
    return self:GetKeyPressure(key) > 0
end

function Piano:IsPedalPressed(pedal)
    return self:GetPedalPressure(pedal) > 0
end
