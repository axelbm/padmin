


function PAdmin.NewPlayer(ply)
	plyinfo = {
			nickname = ply:Nick(),
			rank = PAdmin.GetDefaultRank(),
			team = "",
			lastconnection = os.time(),
			baninfo = {},
			variables = {playtime = 0}}

	PAdmin.Database.AddPlayer(ply:SteamID(), plyinfo.nickname, plyinfo.rank, plyinfo.team, plyinfo.variables)

	return plyinfo
end

function PAdmin.LoadPlayer(ply)
	local plyinfo = PAdmin.Database.GetPlayer(ply:SteamID())

	if not plyinfo then
		plyinfo = PAdmin.NewPlayer(ply)
	end

	ply.PAdmin = plyinfo

	PAdmin.SetRank(ply, plyinfo.rank)
end

function PAdmin.PlayerUpdateTime(ply)
	ply.PAdmin.variables.playtime = ply.PAdmin.variables.playtime + os.time() - ply.PAdmin.lastconnection
	ply.PAdmin.lastconnection = os.time()

	PAdmin.Database.SavePlayer(ply)
end

//////////////////////////////////////////////////////////////////////////////

hook.Add("PlayerInitialSpawn", "PAdmin_LoadPlayer", function(ply)
	PAdmin.LoadPlayer(ply)
	print("player " .. ply:Nick() .. " loaded.")
	
	ply.PAdmin.lastconnection = os.time()
end)

timer.Create("PAdmin_PlayerTimeAutoUpdater", 30, 0, function()
	for k,ply in pairs(player.GetAll()) do
		PAdmin.PlayerUpdateTime(ply)
	end
end)

hook.Add("PlayerDisconnected", "PAdmin_PlayerTimeDisconnectUpdater", function(ply)
	PAdmin.PlayerUpdateTime(ply)
end)