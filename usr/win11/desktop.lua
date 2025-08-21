-- ========================/usr/win11/desktop.lua====================
local UI = dofile("/usr/win11/ui.lua")
local WM = dofile("/usr/win11/wm.lua")

local Desktop = {}

local taskbarHeight = 2
local pinned = {
    {label="App1", app="/usr/win11/apps/app1.lua"},
    {label="App2", app="/usr/win11/apps/app2.lua"}
}
local startOpen = false

function Desktop.init()
    local self = {}
    local w, h = term.getSize()

    local function launch(path, label)
        if fs.exists(path) then
            WM.spawn(label, function() dofile(path) end)
        end
    end

    function self:draw()
        term.setBackgroundColor(__WIN11__.config.wallpaper.bg or colors.lightBlue)
        term.clear()
        UI.text(2,1,"Win11OS Desktop", colors.white)

        -- Barre des tâches
        UI.fill(1, h-taskbarHeight+1, w, taskbarHeight, colors.gray)
        UI.text(2, h-taskbarHeight+1, "Start", colors.white)

        -- Icônes épinglées
        local x = 12
        for _,p in ipairs(pinned) do
            p._x = x
            p._w = #p.label + 2
            UI.text(x, h-taskbarHeight+1, p.label, colors.white)
            x = x + p._w + 1
        end

        WM.draw()
    end

    function self:handle(ev)
        local name = ev[1]
        if name == "mouse_click" then
            local btn, x, y = ev[2], ev[3], ev[4]
            local tbY = h - taskbarHeight + 1

            if y == tbY then
                if x >=2 and x < 12 then
                    startOpen = not startOpen
                    self:draw()
                    return
                end

                for _,p in ipairs(pinned) do
                    if x >= p._x and x < p._x + p._w then
                        startOpen = false
                        self:draw()
                        launch(p.app, p.label)
                        return
                    end
                end
            end
        end
        WM.handle(ev)
    end

    return self
end

return Desktop
