AddCSLuaFile()

local Player = FindMetaTable "Player"

function Player:GetPiano()
	local vehicle = self:GetVehicle()

	if IsValid(vehicle) then
		local owner = vehicle:GetOwner()

		if IsValid(owner) && owner:IsPiano() then
			return owner
		else
			return NULL
		end
	else
		return NULL
	end
end