local PLUGIN = {}
PLUGIN.Title = "commands"
PLUGIN.Description = ""
PLUGIN.Author = "Papate"

PLUGIN.Hooks = {}

function PLUGIN.Hooks.PlayerSay(self, ply, text)
	local prefix = string.Left(text, 1)
	text = string.Right(text, #text - 1) 

	if prefix == "!" or prefix == "/" or prefix == "@" then
		local args = string.Explode(" ", text)
		local cmd = table.remove(args, 1)

		local succ = PAdmin.RunCommand(ply, cmd, args, false)

		if succ then
			return ""
		end
	end
end


PAdmin.RegisterPlugin(PLUGIN) 