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

PIANO_NOTE_MIN    = 0
PIANO_NOTE_MAX    = 87
PIANO_NOTE_COUNT  = 88
PIANO_NOTE_OFFSET = 9

PIANO_OCTAVE_MIN   = 0
PIANO_OCTAVE_MAX   = 8
PIANO_OCTAVE_COUNT = 9
PIANO_OCTAVE_NOTES = 12

PIANO_PEDAL_MIN       = 0
PIANO_PEDAL_MAX       = 2
PIANO_PEDAL_COUNT     = 3
PIANO_PEDAL_SOFT      = 0
PIANO_PEDAL_SOSTENUTO = 1
PIANO_PEDAL_SUSTAIN   = 2

module("piano", package.seeall)

local symbol = {
	{ { "" },       { "♮" } },
	{ { "#", "b" }, { "♯", "♭" } },
}

local noteSymbol = {
	[0]  = symbol[1],
	[1]  = symbol[2],
	[2]  = symbol[1],
	[3]  = symbol[2],
	[4]  = symbol[1],
	[5]  = symbol[1],
	[6]  = symbol[2],
	[7]  = symbol[1],
	[8]  = symbol[2],
	[9]  = symbol[1],
	[10] = symbol[2],
	[11] = symbol[1],
}

local noteLetter = {
	[0]  = { "C" },
	[1]  = { "C", "D" },
	[2]  = { "D" },
	[3]  = { "D", "E" },
	[4]  = { "E" },
	[5]  = { "F" },
	[6]  = { "F", "G" },
	[7]  = { "G" },
	[8]  = { "G", "A" },
	[9]  = { "A" },
	[10] = { "A", "B" },
	[11] = { "B" },
}

function GetNoteOctave(note)
	return math.floor((note + PIANO_NOTE_OFFSET) / PIANO_OCTAVE_NOTES)
end

function GetNoteFrequency(note, pitch)
	return 2 ^ ((note - 48) / PIANO_OCTAVE_NOTES) * (pitch || 440)
end

function IsNoteNatural(note)
	return noteSymbol[(note + PIANO_NOTE_OFFSET) % PIANO_OCTAVE_NOTES] == symbol[1]
end

function GetNoteSymbol(note, utf8)
	return unpack(noteSymbol[(note + PIANO_NOTE_OFFSET) % PIANO_OCTAVE_NOTES][utf8 && 2 || 1])
end

function GetNoteLetter(note)
	return unpack(noteLetter[(note + PIANO_NOTE_OFFSET) % PIANO_OCTAVE_NOTES])
end

function TranslateMidiNote(note, reverse)
	return note + (reverse && 21 || -21)
end

if CLIENT then
	local midiInputEnable   = CreateClientConVar("piano_midi_input_enable",    0,  true, false)
	local midiInputPortName = CreateClientConVar("piano_midi_input_port_name", "", true, false)

	function IsMidiInputEnabled()
		return midiInputEnable:GetBool()
	end

	function GetMidiInputPortName()
		return midiInputPortName:GetString()
	end
end