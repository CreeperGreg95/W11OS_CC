-- boot_manager.lua
-- Gère le choix et le lancement des OS installés

local monitors_config = dofile("/bios/monitors_config.lua")

local boot_manager = {}

function boot_manager.run(monitors)
    local os_list = dofile("/bios/os_config/os_installed.lua")

    -- Construire les options
    local options = {}
    if #os_list == 0 then
        table.insert(options, "Aucun OS installé")
    else
        for _, os_entry in ipairs(os_list) do
            table.insert(options, os_entry.name)
        end
    end
    table.insert(options, "Retour")

    -- Afficher le menu
    local choice = monitors_config.menu(monitors, options)

    -- Cas spécial : aucun OS installé → seul "Retour" est valide
    if #os_list == 0 then
        if choice == #options then
            local menu = dofile("/bios/menu.lua")
            menu.run(monitors)
        else
            -- Si l'utilisateur clique sur "Aucun OS installé"
            monitors_config.refreshScreen(monitors)
            monitors_config.writeAll(monitors, 1, "Impossible de lancer : aucun OS installé.")
            sleep(2)
            boot_manager.run(monitors) -- Retour au menu OS
        end
        return
    end

    -- Si retour choisi
    if choice == #options then
        local menu = dofile("/bios/menu.lua")
        menu.run(monitors)
    else
        -- Lancer l'OS sélectionné
        local selectedOS = os_list[choice]
        monitors_config.refreshScreen(monitors)
        monitors_config.writeAll(monitors, 1, "Démarrage de "..selectedOS.name.."...")
        sleep(1)
        shell.run(selectedOS.path)
    end
end

return boot_manager
