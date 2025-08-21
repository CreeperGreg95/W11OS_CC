-- monitors_config.lua
-- Gestion des monitors pour BIOS et OS (clic = déplacer, bouton Valider = exécuter, rafraîchissement écran)

local monitors_config = {}

-- Détection des monitors connectés
function monitors_config.detectMonitors()
    local monitors = {}
    if peripheral then
        for _, side in ipairs({"top","bottom","left","right","front","back"}) do
            if peripheral.isPresent(side) and peripheral.getType(side) == "monitor" then
                local mon = peripheral.wrap(side)
                mon.clear()
                mon.setCursorPos(1,1)
                table.insert(monitors, mon)
            end
        end
    end
    return monitors
end

-- Écriture sur tous les monitors et le terminal local
function monitors_config.writeAll(monitors, y, text)
    term.setCursorPos(1, y)
    print(text)
    for _, m in pairs(monitors) do
        m.setCursorPos(1, y)
        m.clearLine()
        m.write(text)
    end
end

-- Efface tout et met à jour l'affichage (rafraîchissement)
function monitors_config.refreshScreen(monitors)
    term.clear()
    term.setCursorPos(1,1)
    for _, m in pairs(monitors) do
        m.clear()
        m.setCursorPos(1,1)
    end
end

-- Menu interactif sur monitors et terminal
-- Renvoie l'option sélectionnée (clic = déplacer, bouton Valider = exécuter)
function monitors_config.menu(monitors, options)
    local choice = 1

    local function redraw()
        monitors_config.refreshScreen(monitors)

        -- Affichage des options
        for i, opt in ipairs(options) do
            local line = (i == choice) and ("> "..opt) or ("  "..opt)
            term.setCursorPos(1, i)
            print(line)
            for _, m in pairs(monitors) do
                m.setCursorPos(1, i)
                m.clearLine()
                m.write(line)
            end
        end

        -- Affichage bouton [ Valider ] en bas à droite
        for _, m in pairs(monitors) do
            local w, h = m.getSize()
            m.setCursorPos(w - 9, h) -- 9 = longueur du texte "[ Valider ]"
            m.clearLine()
            m.write("[ Valider ]")
        end

        -- Terminal local
        term.setCursorPos(1, #options + 2)
        print("[ Valider ] (Appuyez Enter pour valider)")
    end

    redraw()

    while true do
        local event, p1, p2, p3 = os.pullEvent()
        if event == "key" then
            if p1 == keys.up then
                choice = choice - 1
                if choice < 1 then choice = #options end
                redraw()
            elseif p1 == keys.down then
                choice = choice + 1
                if choice > #options then choice = 1 end
                redraw()
            elseif p1 == keys.enter then
                return choice
            end
        elseif event == "monitor_touch" then
            local side, x, y = p1, p2, p3
            if y >= 1 and y <= #options then
                choice = y
                redraw()
            else
                -- Vérifier si clic sur le bouton Valider
                local mon = peripheral.wrap(side)
                local w, h = mon.getSize()
                if y == h and x >= w - 9 then
                    return choice
                end
            end
        end
    end
end

return monitors_config
