lu = require("luaunit")
package.path = package.path .. ";/mnt/c/Users/DavidBatten/AppData/Roaming/Factorio/mods/train-city/ui/?.lua"
require("station_behavior")

test_when_parsing_fluid_selection = {}

function test_when_parsing_fluid_selection:test_it_parses_empty_fluid()
	lu.assertEquals(string.gsub("when_parsing", "^when_", "wee"), "weeparsing")
	lu.assertEquals(station_behavior.woot("batten"), "woot, batten")
end

os.exit(lu.LuaUnit.run())
