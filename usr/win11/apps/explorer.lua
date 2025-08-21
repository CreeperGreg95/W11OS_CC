-- =====================/usr/win11/apps/explorer.lua=================
end
end


local function open(idx)
local name = items[idx]
if not name then return end
local path = fs.combine(cwd, name)
if fs.isDir(path) then cwd=path; scroll=0; refresh() else
-- ouvrir dans Bloc-notes
local ok, app = pcall(dofile, "/usr/win11/apps/notepad.lua")
if ok then
local inst = app()
local WM = __WIN11__.WM
WM.create{title="Bloc-notes - "..name, w=math.floor(W*0.7), h=math.floor(H*0.7), x=6, y=4,
draw=function()
term.setCursorPos(2,2)
local f=fs.open(path,"r"); local data=f.readAll() f.close()
local lines = {}
for s in (data.."\n"):gmatch("(.-)\n") do table.insert(lines,s) end
local maxH = select(2, term.getSize())-4
for i=1, math.min(#lines, maxH) do
term.setCursorPos(2,1+i)
term.write(lines[i])
end
end,
onEvent=function() end
}
end
end
end


return {
title = "Explorateur",
draw = function() draw() end,
onEvent = function(ev,a,b,c)
if ev=="mouse_scroll" then scroll = math.max(0, math.min(scroll + (a>0 and 1 or -1), math.max(0,#items- (select(2,term.getSize())-4))) ); __WIN11__.WM.redraw(); return true
elseif ev=="mouse_click" then
local _,x,y = a,b,c
local idx = (y-3)+1+scroll
open(idx)
__WIN11__.WM.redraw(); return true
end
end
}
end