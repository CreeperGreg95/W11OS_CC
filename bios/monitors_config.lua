-- monitors_config.lua
-- Gestion des monitors pour BIOS et OS (clic gauche = déplacer, double-clic = exécuter)

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
        m.write(text)
    end
end

-- Menu interactif sur monitors et terminal
-- callback(option_index) est appelé si l'option est exécutée (double-clic)
function monitors_config.menu(monitors, options, callback)
    local choice = 1
    local lastClick = 0
    local lastY = 0

    local function redraw()
        term.clear()
        term.setCursorPos(1,1)
        for _, m in pairs(monitors) do m.clear() end
        for i, opt in ipairs(options) do
            local line = (i == choice) and ("> "..opt) or ("  "..opt)
            term.setCursorPos(1, i)
            print(line)
            for _, m in pairs(monitors) do
                m.setCursorPos(1, i)
                m.write(line)
            end
        end
    end

    redraw()

    while true do
        local event, p1, p2, p3 = os.pullEvent()
        
        if event == "key" then
            if p1 == keys.up then
                choice = choice - 1
                if choice < 1 then choice = #options end
            elseif p1 == keys.down then
                choice = choice + 1
                if choice > #options then choice = 1 end
            elseif p1 == keys.enter and callback then
                return callback(choice)
            end
            redraw()

        elseif event == "monitor_touch" then
            local side, x, y = p1, p2, p3
            if y >= 1 and y <= #options then
                choice = y -- Déplacer le curseur d'abord
                local now = os.clock()
                if lastY == y and (now - lastClick) < 0.5 and callback then
                    return callback(choice) -- Exécuter l'option correcte
                end
                lastClick = now
                lastY = y
                redraw()
            end
        end
    end
end

return monitors_config
