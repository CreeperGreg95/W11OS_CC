-- ========================/usr/win11/desktop.lua====================
if inst.draw then inst.draw(winObj) end
end,
onEvent=function(ev,...) if inst.onEvent then return inst.onEvent(ev, ...) end end
}
if inst.onOpen then inst.onOpen(win) end
end


-- boucle d'événements
UI.reset()
WM.redraw()
while true do
local ev = { os.pullEvent() }
local name = ev[1]
if name=="mouse_click" then
local btn,x,y = ev[2], ev[3], ev[4]
local tbY = H - __WIN11__.taskbarHeight + 1
if y==tbY then
-- bouton Start
if x>=2 and x<12 then startOpen = not startOpen; WM.redraw()
else
-- icônes épinglées
for _,p in ipairs(pinned) do
if x>=p._x and x<p._x+p._w then startOpen=false; WM.redraw(); launch(p.app, p.label) end
end
end
elseif startOpen then
-- clic dans le menu démarrer
for _,item in ipairs(pinned) do
if y==item._sy and x>=item._sx and x<item._sx+item._sw then startOpen=false; WM.redraw(); launch(item.app, item.label) end
end
else
-- transmettre au WM
if not WM.dispatch(ev[1], ev[2],ev[3],ev[4],ev[5]) then
-- rien
end
end
else
if not WM.dispatch(ev[1], ev[2],ev[3],ev[4],ev[5]) then
-- redraw périodique pour l'horloge
if name=="timer" or name=="term_resize" then WM.redraw() end
end
end
end
end