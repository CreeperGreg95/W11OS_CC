-- ====================/usr/win11/apps/settings.lua==================
-- Paramètres: changer couleur du fond & accent, sauvegarder
return function()
local cfg = __WIN11__.config
local opts = {
{label="Fond: lightBlue", key="wallpaper.bg", val=colors.lightBlue},
{label="Fond: black", key="wallpaper.bg", val=colors.black},
{label="Accent: blue", key="wallpaper.accent", val=colors.blue},
{label="Accent: magenta", key="wallpaper.accent", val=colors.magenta},
}
local sel = 1


local function draw()
term.setCursorPos(2,2) print("Paramètres → Apparence")
for i,o in ipairs(opts) do
local mark = (i==sel) and "> " or " "
term.setCursorPos(2,2+i) term.write(mark..o.label)
end
term.setCursorPos(2, 4+#opts) term.write("Clique pour appliquer. S pour sauvegarder.")
end


local function apply(o)
if o.key=="wallpaper.bg" then cfg.wallpaper.bg = o.val end
if o.key=="wallpaper.accent" then cfg.wallpaper.accent = o.val end
__WIN11__.WM.redraw()
end


return {
title="Paramètres",
draw = draw,
onEvent = function(ev,a,b,c)
if ev=="mouse_click" then
local _,x,y = a,b,c
local i = y-2
if opts[i] then sel=i; apply(opts[i]); return true end
elseif ev=="key" then
if a==keys.up then sel=math.max(1,sel-1); __WIN11__.WM.redraw(); return true end
if a==keys.down then sel=math.min(#opts,sel+1); __WIN11__.WM.redraw(); return true end
if a==keys.enter then apply(opts[sel]); return true end
if a==keys.s then __WIN11__.saveConfig(); return true end
end
return false
end
}
end