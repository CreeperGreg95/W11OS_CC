-- monitors_config.lua
-- Gestion des monitors pour BIOS et OS

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
function monitors_config.menu(monitors, options)
    local choice = 1
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
        local event, param1, param2, param3 = os.pullEvent()
        if event == "key" then
            if param1 == keys.up then
                choice = choice - 1
                if choice < 1 then choice = #options end
            elseif param1 == keys.down then
                choice = choice + 1
                if choice > #options then choice = 1 end
            elseif param1 == keys.enter then
                return choice
            end
        elseif event == "monitor_touch" then
            local side, x, y = param1, param2, param3
            if y >= 1 and y <= #options then
                choice = y
            end
        end
        redraw()
    end
end

return monitors_config
