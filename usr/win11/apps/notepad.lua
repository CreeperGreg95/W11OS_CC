-- =====================/usr/win11/apps/notepad.lua==================
-- Bloc-notes simple: lecture d'un fichier (édition basique optionnelle)
return function()
local content = {"(Ouvre un fichier via l'Explorateur)", ""}
local cursor = {x=1,y=1}


local function draw()
local W,H = term.getSize()
for i=1,H-2 do
term.setCursorPos(2,i+1)
term.write(string.rep(" ", W-2))
if content[i] then term.setCursorPos(2,i+1) term.write(content[i]) end
end
end


return {
title = "Bloc-notes",
draw = draw,
onEvent = function(ev,a,b,c)
-- (Edition complète non incluse pour rester compact)
return false
end
}
end