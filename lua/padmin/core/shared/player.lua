
function PAdmin.FindPlayersByName(name)
	local plys = {}

	for _,pl in pairs(player.GetAll()) do
		if string.find(pl:Name(), name) then
			table.insert(plys, pl)
		end
	end

	return plys
end

function PAdmin.FindPlayers(ply, name)
	local plys = {}

	
end