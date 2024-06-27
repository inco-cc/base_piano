-- See LICENSE file for copyright and license details.

include("shared.lua")
include("cl_class_piano.lua")
include("cl_library_piano.lua")

function ENT:Initialize()
    debug.setmetatable(self, FindMetaTable("Piano"))

    self.KeyPressure = {}
    self.PedalPressure = {}
end

function ENT:ShouldPressKey(key, pressure)
    if not self:IsKeyValid(key) or pressure <= 0 then
        return false
    elseif hook.Run("ShouldPressPianoKey", self, key, pressure) == false then
        return false
    end

    return true
end

function ENT:ShouldPressPedal(pedal, pressure)
    if not self:IsPedalValid(pedal) or pressure <= 0 then
        return false
    elseif hook.Run("ShouldPressPianoPedal", self, pedal, pressure) == false then
        return false
    end

    return true
end

function ENT:ShouldReleaseKey(key)
    if not self:IsKeyPressed(key) then
        return false
    elseif hook.Run("ShouldReleasePianoKey", self, key) == false then
        return false
    end

    return true
end

function ENT:ShouldReleasePedal(pedal)
    if not self:IsPedalPressed(pedal) then
        return false
    elseif hook.Run("ShouldReleasePianoPedal", self, pedal) == false then
        return false
    end

    return true
end

function ENT:OnKeyPressed(key, pressure)
    hook.Run("OnPianoKeyPressed", self, key, pressure)
end

function ENT:OnPedalPressed(pedal, pressure)
    hook.Run("OnPianoPedalPressed", self, pedal, pressure)
end

function ENT:OnKeyReleased(key)
    hook.Run("OnPianoKeyReleased", self, key)
end

function ENT:OnPedalReleased(pedal)
    hook.Run("OnPianoPedalReleased", self, pedal)
end
