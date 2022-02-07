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

local Piano = {}

Piano.MetaName      = "Piano"
Piano.MetaBaseClass = FindMetaTable "Entity"

function Piano:__newindex(key, value)
	return Piano.MetaBaseClass.__newindex(self, key, value)
end

function Piano:__index(key)
	if Piano[key] != nil then
		return Piano[key]
	else
		return Piano.MetaBaseClass.__index(self, key)
	end
end

function Piano:__tostring()
	return Piano.MetaBaseClass.__tostring(self):Replace(Piano.MetaBaseClass.MetaName, Piano.MetaName)
end

function Piano:IsPiano()
	return true
end

function Piano:GetNotePressure(note)
	return self.m_tNotes[note].pressure
end

function Piano:IsNotePressed(note)
	return self:GetNotePressure(note) > 0
end

function Piano:GetPressedNotes()
	local notes = {}

	for note, data in pairs(self.m_tNotes) do
		if self:IsNotePressed(note) then
			table.insert(notes, note)
		end
	end

	return notes
end

function Piano:GetReleasedNotes()
	local notes = {}

	for note, data in pairs(self.m_tNotes) do
		if !self:IsNotePressed(note) then
			table.insert(notes, note)
		end
	end

	return notes
end

function Piano:PressNote(note, pressure)
	if !self:ShouldPressNote(note, pressure) then
		return false
	end

	self.m_tNotes[note].pressure = math.Clamp(pressure, 0, 1)

	self:OnNotePressed(note, pressure)

	return true
end

function Piano:ReleaseNote(note)
	local pressure = self:GetNotePressure(note)

	if !self:ShouldReleaseNote(note, pressure) then
		return false
	end

	self.m_tNotes[note].pressure = 0

	self:OnNoteReleased(note, pressure)

	return true
end

function Piano:ReleaseAllNotes()
	for note = PIANO_NOTE_MIN, PIANO_NOTE_MAX do
		self:ReleaseNote(note)
	end
end

function Piano:GetBench()
	return self:GetNW2Entity "m_pBench"
end

function Piano:GetPlayer()
	local bench = self:GetBench()

	if IsValid(bench) then
		return bench:GetDriver()
	else
		return NULL
	end
end

debug.getregistry().Piano = Piano