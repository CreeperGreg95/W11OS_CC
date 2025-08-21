-- ==========================/startup.lua============================
-- Bootloader: prépare l'arborescence et lance le bureau. Placez CE
-- bloc dans /startup.lua
local function ensureDirs()
local dirs = {"/usr", "/usr/win11", "/usr/win11/apps"}
for _,d in ipairs(dirs) do if not fs.exists(d) then fs.makeDir(d) end end
end
ensureDirs()


local function panic(msg)
term.setBackgroundColor(colors.black) term.setTextColor(colors.red)
term.clear() term.setCursorPos(1,1)
print("Kernel panic: "..tostring(msg))
print("Retour à CraftOS dans 5s…")
sleep(5)
shell.run("/rom/programs/shell.lua")
end


local ok, err = pcall(function()
dofile("/usr/win11/boot.lua")()
end)
if not ok then panic(err) end