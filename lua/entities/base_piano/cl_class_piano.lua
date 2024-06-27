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

function Piano:SetKeyPressure(key, pressure)
    self.KeyPressure[key] = pressure
end

function Piano:SetPedalPressure(pedal, pressure)
    self.PedalPressure[pedal] = pressure
end

function Piano:PressKey(key, pressure)
    local should = self:ShouldPressKey(key, pressure)

    if should then
        self:SetKeyPressure(key, pressure)
        self:OnKeyPressed(key, pressure)
    end

    return should
end

function Piano:PressPedal(pedal, pressure)
    local should = self:ShouldPressPedal(pedal, pressure)

    if should then
        self:SetPedalPressure(pedal, pressure)
        self:OnPedalPressed(pedal, pressure)
    end

    return should
end

function Piano:ReleaseKey(key)
    local should = self:ShouldReleaseKey(key)

    if should then
        self:SetKeyPressure(key)
        self:OnKeyReleased(key)
    end

    return should
end

function Piano:ReleasePedal(pedal)
    local should = self:ShouldReleasePedal(pedal)

    if should then
        self:SetPedalPressure(pedal)
        self:OnPedalReleased(pedal)
    end

    return should
end
