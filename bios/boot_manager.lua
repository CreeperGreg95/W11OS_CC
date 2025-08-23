-- boot_manager.lua
-- Gère le choix et le lancement des OS installés

local monitors_config = dofile("/bios/monitors_config.lua")

local boot_manager = {}

function boot_manager.run(monitors)
    local os_list = dofile("/bios/os_config/os_installed.lua")

    -- Si aucun OS n’est installé
    if #os_list == 0 then
        monitors_config.refreshScreen(monitors)
        monitors_config.writeAll(monitors, 1, "Aucun OS installé")

        -- Menu avec uniquement "Retour"
        local choice = monitors_config.menu(monitors, {"Retour"})
        if choice == 1 then
            local menu = dofile("/bios/menu.lua")
            menu.run(monitors)
        end
        return
    end

    -- Sinon, construire la liste des OS installés
    local options = {}
    for _, os_entry in ipairs(os_list) do
        table.insert(options, os_entry.name)
    end
    table.insert(options, "Retour")

    -- Afficher le menu avec la liste des OS
    local choice = monitors_config.menu(monitors, options)

    if choice == #options then
        -- Retour
        local menu = dofile("/bios/menu.lua")
        menu.run(monitors)
    else
        -- Lancer l’OS choisi
        local selectedOS = os_list[choice]
        monitors_config.refreshScreen(monitors)
        monitors_config.writeAll(monitors, 1, "Démarrage de "..selectedOS.name.."...")
        sleep(1)
        shell.run(selectedOS.path)
    end
end

return boot_manager
