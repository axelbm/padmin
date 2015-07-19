local PLUGIN = {}
PLUGIN.Title = "test_cl"
PLUGIN.Description = "just a clientside test"
PLUGIN.Author = "Papate"
PLUGIN.ChatCommand = "test"
PLUGIN.Privileges = {"test"}

PLUGIN.Hooks = {}

function PLUGIN.Hooks.PlayerSpawn(self, ply)
	print(ply)
end


PAdmin.RegisterPlugin(PLUGIN) 