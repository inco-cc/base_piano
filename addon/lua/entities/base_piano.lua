--[[
	Modified BSD License

	Copyright (C) 2022 Brandon Little

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions
	are met:

	1. Redistributions of source code must retain the above copyright
	   notice, this list of conditions and the following disclaimer.

	2. Redistributions in binary form must reproduce the above copyright
	   notice, this list of conditions and the following disclaimer in the
	   documentation and/or other materials provided with the distribution.

	3. Neither the name of the copyright holder nor the names of its
	   contributors may be used to endorse or promote products derived
	   from this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL EXEMPLARY, OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
	THE POSSIBILITY OF SUCH DAMAGE.
]]

AddCSLuaFile()

include "includes/modules/piano.lua"
include "includes/classes/piano.lua"
include "includes/classes/entity/piano.lua"
include "includes/classes/player/piano.lua"

ENT.Type = "anim"
ENT.Base = "base_anim"

DEFINE_BASECLASS(ENT.Base)

function ENT:Initialize()
	BaseClass.Initialize(self)

	debug.setmetatable(self, FindMetaTable "Piano")

	self.m_tNotes  = {}
	self.m_tPedals = {}

	for note = PIANO_NOTE_MIN, PIANO_NOTE_MAX do
		self.m_tNotes[note] = {
			pressure = 0,
		}
	end

	for pedal = PIANO_PEDAL_MIN, PIANO_PEDAL_MAX do
		self.m_tPedals[pedal] = {
			pressure = 0,
		}
	end

	if SERVER then
		local bench = ents.Create "prop_vehicle_prisoner_pod"

		if IsValid(bench) then
			bench:SetOwner(self)
			bench:SetParent(self)

			self:DeleteOnRemove(bench)
			self:SetNW2Entity("m_pBench", bench)
		end
	end
end

function ENT:ShouldPressNote(note, pressure)
	return pressure > 0 && !self:IsNotePressed(note) && hook.Run("ShouldPianoPressNote", self, note, pressure) != false
end

function ENT:ShouldReleaseNote(note, pressure)
	return self:IsNotePressed(note) && hook.Run("ShouldPianoReleaseNote", self, note, pressure) != false
end

function ENT:OnNotePressed(note, pressure)
	hook.Run("OnPianoNotePressed", self, note, pressure)
end

function ENT:OnNoteReleased(note, pressure)
	hook.Run("OnPianoNoteReleased", self, note, pressure)
end

if CLIENT then
	if file.Find("lua/bin/gmcl_midi*.dll", "MOD")[1] then
		require "midi"
	end

	function ENT:OnMidiInputMessage(message, ...)
		if message == MIDI_MESSAGE_NOTE_ON then
			local note     = piano.TranslateMidiNote(select(1, ...))
			local pressure = select(2, ...) / 127

			if pressure > 0 then
				self:PressNote(note, pressure)
			else
				self:ReleaseNote(note)
			end
		end
	end

	hook.Add("OnMidiInputMessage", "base_piano", function(...)
		if piano.IsMidiInputEnabled() then
			local piano = LocalPlayer():GetPiano()

			if IsValid(piano) then
				piano:OnMidiInputMessage(...)
			end
		end
	end)
end