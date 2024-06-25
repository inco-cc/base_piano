-- See LICENSE file for copyright and license details.

module("piano", package.seeall)

function GetLocal()
    return LocalPlayer():GetPiano()
end
