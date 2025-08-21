-- =========================/usr/win11/wm.lua========================
-- Window Manager: gestion des fenêtres, titres, boutons
local WM = {}
__WIN11__.WM = WM

WM.windows = {}
WM.active  = nil

function WM.spawn(title,app)
  local w,h = term.getSize()
  local win = window.create(term.current(), 2, 3, w-2, h-5, true)
  local obj = {title=title, win=win, x=2, y=3, w=w-2, h=h-5, app=app}
  table.insert(WM.windows, obj)
  WM.active = obj
  return obj
end

function WM.draw()
  for i,obj in ipairs(WM.windows) do
    -- barre de titre
    __WIN11__.UI.frame(obj.x,obj.y,obj.w,obj.h,obj.title,colors.gray,colors.white)
    -- boutons
    __WIN11__.UI.text(obj.x+obj.w-4,obj.y,"_",colors.white,colors.gray)
    __WIN11__.UI.text(obj.x+obj.w-2,obj.y,"X",colors.white,colors.gray)
    -- contenu
    obj.win.setVisible(true)
  end
end

function WM.close(obj)
  for i,v in ipairs(WM.windows) do
    if v==obj then
      table.remove(WM.windows,i)
      break
    end
  end
end

function WM.handle(ev)
  if ev[1]=="mouse_click" then
    local _,btn,x,y = table.unpack(ev)
    for _,obj in ipairs(WM.windows) do
      if y==obj.y and x>=obj.x+obj.w-4 and x<=obj.x+obj.w-2 then
        -- bouton fermer
        WM.close(obj)
        return true
      end
    end
  end
  return false
end
