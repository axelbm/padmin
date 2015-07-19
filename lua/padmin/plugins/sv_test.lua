local PLUGIN = {}
PLUGIN.Title = "test_sv"
PLUGIN.Description = "just a serverside test"
PLUGIN.Author = "Papate"
PLUGIN.ChatCommands = {
	["test"] = {
		["category"] = "other",
		["args"] = {"p","n;min=0;max=100"}
	},
	["testeux"] = {
		["category"] = "other",
		["args"] = {"p","n"}
	}
}
PLUGIN.Privileges = {"test"}

PLUGIN.Commands = {}
PLUGIN.Hooks = {}

function PLUGIN.Commands.test(self, ply, args)
	ply:Spawn()
end

function PLUGIN.Hooks.PlayerSpawn(self, ply)
	
end


PAdmin.RegisterPlugin(PLUGIN) 