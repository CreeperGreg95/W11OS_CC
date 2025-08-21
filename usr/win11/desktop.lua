-- ========================/usr/win11/desktop.lua====================
local UI = __WIN11__.UI
local WM = __WIN11__.WM

local Desktop = {}
__WIN11__.Desktop = Desktop

-- Paramètres du bureau
local taskbarHeight = 2
local pinned = {
    {label="App1", app="/usr/win11/apps/app1.lua"},
    {label="App2", app="/usr/win11/apps/app2.lua"}
}

local startOpen = false

-- Initialisation du Desktop
function Desktop.init()
    local self = {}

    local w, h = term.getSize()

    -- Fonction pour lancer une application
    local function launch(path, label)
        if fs.exists(path) then
            WM.spawn(label, function()
                dofile(path)
            end)
        end
    end

    -- Redessiner le bureau
    function self:draw()
        -- Fond du bureau
        term.setBackgroundColor(colors.lightBlue)
        term.clear()

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

        -- Fenêtres
        WM.draw()
    end

    -- Gestion des événements
    function self:handle(ev)
        local name = ev[1]
        if name == "mouse_click" then
            local btn, x, y = ev[2], ev[3], ev[4]
            local tbY = h - taskbarHeight + 1

            if y == tbY then
                -- Bouton Start
                if x >=2 and x < 12 then
                    startOpen = not startOpen
                    self:draw()
                    return
                end

                -- Icônes épinglées
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

        -- Envoyer les autres événements au WM
        WM.handle(ev)
    end

    return self
end
