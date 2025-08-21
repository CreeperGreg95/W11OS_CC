-- =========================/usr/win11/ui.lua========================
term.clear()
term.setCursorPos(1,1)
end


function UI.size() return term.getSize() end


function UI.fill(x,y,w,h,bg)
local oldBg = term.getBackgroundColor()
term.setBackgroundColor(bg)
for j=0,h-1 do term.setCursorPos(x,y+j) term.write(string.rep(" ", w)) end
term.setBackgroundColor(oldBg)
end


function UI.frame(x,y,w,h,title,bg,fg)
bg = bg or colors.gray
fg = fg or colors.white
local oldBg, oldFg = term.getBackgroundColor(), term.getTextColor()
term.setBackgroundColor(bg) term.setTextColor(fg)
-- barre de titre
term.setCursorPos(x,y) term.write(string.rep(" ", w))
term.setCursorPos(x+1,y) term.write(title or "")
-- bordures latérales + contenu
for j=1,h-1 do term.setCursorPos(x,y+j) term.write(" ") term.setCursorPos(x+w-1,y+j) term.write(" ") end
term.setBackgroundColor(oldBg) term.setTextColor(oldFg)
end


function UI.text(x,y,text,fg,bg)
local oldBg, oldFg = term.getBackgroundColor(), term.getTextColor()
if bg then term.setBackgroundColor(bg) end
if fg then term.setTextColor(fg) end
term.setCursorPos(x,y) term.write(text)
term.setBackgroundColor(oldBg) term.setTextColor(oldFg)
end


function UI.button(x,y,w,label,active)
local bg = active and colors.blue or colors.lightGray
local fg = active and colors.white or colors.black
UI.fill(x,y,w,1,bg)
UI.text(x+math.floor((w-#label)/2), y, label, fg)
end


function UI.withWindow(x,y,w,h)
local win = window.create(term.current(), x, y, w, h, true)
local old = term.redirect(win)
return win, function() term.redirect(old) end
end