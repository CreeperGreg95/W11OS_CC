-- /usr/win11/boot.lua
return function()
    _G.__WIN11__ = _G.__WIN11__ or {}
    local cfgPath = "/usr/win11/config.lua"

    -- Charger la config
    if fs.exists(cfgPath) then
        local ok, res = pcall(dofile, cfgPath)
        if ok and type(res) == "table" then __WIN11__.config = res end
    end
    __WIN11__.config = __WIN11__.config or {
        wallpaper = {bg=colors.lightBlue, accent=colors.blue},
        taskbar = {autoHide=false, height=1},
    }

    function __WIN11__.saveConfig()
        local f = fs.open(cfgPath, "w")
        f.write("return ")
        local function ser(t)
            if type(t) == "table" then
                local parts = {"{"}
                for k,v in pairs(t) do
                    local key = (type(k)=="string" and k:match("^[_%a][_%w]*$") and k) and k or string.format("[%q]",k)
                    table.insert(parts, key.."="..ser(v)..", ")
                end
                table.insert(parts, "}")
                return table.concat(parts)
            elseif type(t)=="string" then return string.format("%q", t)
            elseif type(t)=="number" or type(t)=="boolean" then return tostring(t)
            else return "nil" end
        end
        f.write(ser(__WIN11__.config))
        f.close()
    end

    -- Charger UI et WM
    __WIN11__.UI = dofile("/usr/win11/ui.lua")
    __WIN11__.WM = dofile("/usr/win11/wm.lua")

    -- Créer Desktop **après** UI et WM
    local Desktop = dofile("/usr/win11/desktop.lua")
    __WIN11__.Desktop = Desktop.init()

    -- Boucle principale
    while true do
        __WIN11__.Desktop:draw()
        local ev = {os.pullEvent()}
        __WIN11__.Desktop:handle(ev)
    end
end
