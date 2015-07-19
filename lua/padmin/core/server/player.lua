
util.AddNetworkString("PAdmin_Player_Update_Client")
util.AddNetworkString("PAdmin_Init_Ply_Request")

function PAdmin.NewPlayer(ply)
	local plyinfo = {
		nickname = ply:Nick(),
		rank = PAdmin.GetDefaultRank(),
		group = "",
		timeplayed = 0,
		lastconnection = os.time(),
		baninfo = {},
		variables = {}
	}

	PAdmin.Database.AddPlayer(ply:SteamID(), plyinfo.nickname, plyinfo.rank, plyinfo.variables)

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

function PAdmin.PlayerGetPlayedTime(ply)
	return ply.PAdmin.timeplayed + os.time() - ply.PAdmin.lastconnection
end

function PAdmin.PlayerUpdateTime(ply)
	ply.PAdmin.timeplayed = PAdmin.PlayerGetPlayedTime(ply)
	ply.PAdmin.lastconnection = os.time()

	PAdmin.Database.SavePlayer(ply)
end

function PAdmin.SendPlayerInfoToClients(ply)
	local plyinfo = {
		nickname = ply:Nick(),
		rank = ply.PAdmin.rank,
		group = ply.PAdmin.group,
		timeplayed = ply.PAdmin.timeplayed,
		lastconnection = ply.PAdmin.lastconnection
	}

	net.Start("PAdmin_Player_Update_Client")
		net.WriteEntity(ply)
		net.WriteTable(plyinfo)
	net.Send(player.GetAll())
end

function PAdmin.SendClientsToPlayer(ply)

	for _,pl in pairs(player.GetAll()) do
		if not ply == pl then
			local plyinfo = {
				nickname = pl:Nick(),
				rank = pl.PAdmin.rank,
				group = pl.PAdmin.group,
				timeplayed = pl.PAdmin.timeplayed,
				lastconnection = pl.PAdmin.lastconnection
			}

			net.Start("PAdmin_Player_Update_Client")
				net.WriteEntity(pl)
				net.WriteTable(plyinfo)
			net.Send(ply)
		end
	end
end

//////////////////////////////////////////////////////////////////////////////

hook.Add("PlayerInitialSpawn", "PAdmin_LoadPlayer", function(ply)
	PAdmin.LoadPlayer(ply)
	print("player " .. ply:Nick() .. " loaded.")
	
	ply.PAdmin.lastconnection = os.time()
end)

net.Receive("PAdmin_Init_Ply_Request", function(len, ply)
	PAdmin.SendPlayerInfoToClients(ply)
	PAdmin.SendClientsToPlayer(ply)
end)

timer.Create("PAdmin_PlayerTimeAutoUpdater", 30, 0, function()
	for k,ply in pairs(player.GetAll()) do
		PAdmin.PlayerUpdateTime(ply)
	end
end)

hook.Add("PlayerDisconnected", "PAdmin_PlayerTimeDisconnectUpdater", function(ply)
	PAdmin.PlayerUpdateTime(ply)
end)