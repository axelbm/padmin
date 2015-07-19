local PLUGIN = {}
PLUGIN.Title = "test_sv"
PLUGIN.Description = "just a serverside test"
PLUGIN.Author = "Papate"
PLUGIN.ChatCommands = {
	["kick"] = {
		["category"] = "other",
		["args"] = {"p"}
	}
}
PLUGIN.Privileges = {"kick"}

PLUGIN.Commands = {}
PLUGIN.Hooks = {}

function PLUGIN.Commands.test(self, ply, args)
	local access = PAdmin.PlayerGetAccess(ply)

	if access then

	end
end

PAdmin.RegisterPlugin(PLUGIN) 