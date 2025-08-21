-- =========================/usr/win11/wm.lua========================
restore()
end
end
__WIN11__.drawTaskbar()
end


local dragging = nil


function WM.dispatch(ev, p1,p2,p3,p4)
if ev=="mouse_click" then
local btn,x,y = p1,p2,p3
-- barre de titre / boutons
for i=#WM.windows,1,-1 do
local w = WM.windows[i]
if not w.minimized and x>=w.x and x<w.x+w.w and y>=w.y and y<w.y+w.h then
WM.raise(w.id)
if y==w.y then
if x==w.x+w.w-1 then WM.close(w.id) return true
elseif x==w.x+w.w-3 then WM.minToggle(w.id) return true
else dragging = {w=w, dx=x-w.x, dy=y-w.y} return true end
else
if w.onEvent then w.onEvent(ev, btn, x-w.x+1, y-w.y+1) end
return true
end
end
end
elseif ev=="mouse_drag" and dragging then
local _,x,y = p1,p2,p3
local w = dragging.w
w.x = math.max(1, math.min(x - dragging.dx, term.getSize()))
w.y = math.max(1, math.min(y - dragging.dy, term.getSize()))
WM.redraw()
return true
elseif ev=="mouse_up" and dragging then dragging = nil return true
else
-- route vers fenêtre focussée
for i=#WM.windows,1,-1 do local w=WM.windows[i]; if not w.minimized and w.id==WM.focused and w.onEvent then
if w.onEvent(ev,p1,p2,p3,p4) then return true end
end end
end
end