local Database = {}

function Database.Create()
	if not sql.TableExists("padmin_settings") then
		sql.Query("CREATE TABLE padmin_settings (name TEXT PRIMARY KEY, variables TEXT);")
	end
	if not sql.TableExists("padmin_ranks") then
		sql.Query("CREATE TABLE padmin_ranks (rankid TEXT PRIMARY KEY, privileges TEXT, restrictions TEXT, limits TEXT, variables TEXT);")
	end
	if not sql.TableExists("padmin_teams") then
		sql.Query("CREATE TABLE padmin_teams (teamid TEXT PRIMARY KEY, teamname TEXT, variables TEXT);")
	end
	if not sql.TableExists("padmin_players") then
		sql.Query("CREATE TABLE padmin_players (steamid TEXT PRIMARY KEY, nickname TEXT, rank TEXT, team TEXT, lastconnection INTEGER, baninfo TEXT, variables Text);")
	end
end

function Database.DeleteAll()
	sql.Query("DROP TABLE padmin_settings")
	sql.Query("DROP TABLE padmin_ranks")
	sql.Query("DROP TABLE padmin_teams")
	sql.Query("DROP TABLE padmin_players")
end

//Settins

function Database.GetSetting(name)
	local query = sql.QueryValue("SELECT * FROM padmin_settings WHERE name='" .. name .. "';")
	return util.JSONToTable(query)
end

function Database.AddSetting(name, value)
	sql.Query("INSERT INTO padmin_settings VALUES ('" .. name .. "', '" .. util.TableToJSON(value) .. "');")
end

function Database.UpdateSetting(name, value)
	sql.Query("UPDATE padmin_settings SET variables='" .. util.TableToJSON(value) .. "' WHERE name='" .. name .. "';")
end

function Database.RemoveSetting(name)
	sql.Query("DELETE FROM padmin_settings WHERE name='" .. name .. "';")
end

//Ranks

function Database.GetRanks()
	local query = sql.Query("SELECT * FROM padmin_ranks;")
	
	if query then
		local ranks = {}
		for _,rank in pairs(query) do
			local tab = {
				privileges = util.JSONToTable(rank.privileges),
				restrictions = util.JSONToTable(rank.restrictions),
				limits = util.JSONToTable(rank.limits),
				variables = util.JSONToTable(rank.variables)}
	
			ranks[rank.rankid] = tab
		end
	
		return ranks
	end
	return {}
end

function Database.AddRank(rankid, privileges, restrictions, limits, variables)
	sql.Query("INSERT INTO padmin_ranks VALUES ('" .. rankid .. "', '" .. util.TableToJSON(privileges) .. "', '" .. util.TableToJSON(restrictions) .. "', '" .. util.TableToJSON(limits) .. "', '" .. util.TableToJSON(variables) .. "');")
end

function Database.UpdateRank(rankid, privileges, restrictions, limits, variables)
	sql.Query("UPDATE padmin_ranks SET privileges='" .. util.TableToJSON(privileges) .. "', restrictions='" .. util.TableToJSON(restrictions) .. "', limits='" .. util.TableToJSON(limits) .. "', variables='" .. util.TableToJSON(variables) .. "' WHERE rankid='" .. util.TableToJSON(rankid) .. "';")
end

function Database.SaveRank(rankid, rank)
	sql.Query("UPDATE padmin_ranks SET privileges='" .. util.TableToJSON(rank.privileges) .. "', restrictions='" .. util.TableToJSON(rank.restrictions) .. "', limits='" .. util.TableToJSON(rank.limits) .. "', variables='" .. util.TableToJSON(rank.variables) .. "' WHERE rankid='" .. util.TableToJSON(rankid) .. "';")
end

function Database.RemoveRank(rankid)
	sql.Query("DELETE FROM padmin_ranks WHERE rankid='" .. rankid .. "';")
end



// Players

function Database.GetPlayer(steamid)
	local plyinfo = sql.QueryRow("SELECT * FROM padmin_players WHERE steamid='" .. steamid .. "'", 1)

	if plyinfo then
		local padminply = {
			nickname = plyinfo.nickname,
			rank = plyinfo.rank,
			team = plyinfo.team,
			lastconnection = plyinfo.lastconnection,
			baninfo = util.JSONToTable(plyinfo.baninfo),
			variables = util.JSONToTable(plyinfo.variables)}

		return padminply
	end
	return nil
end
function Database.AddPlayer(steamid, nickname, rank, team, variables)
	sql.Query("INSERT INTO padmin_players VALUES ('" .. steamid .. "', '" .. nickname .. "', '" .. rank .. "', '" .. team .. "', '" .. os.time() .. "', '" .. "{}" .. "', '" .. util.TableToJSON(variables) .. "');")
end

function Database.UpdatePlayer(steamid, nickname, rank, team, lastconnection, baninfo, variables)
	sql.Query("UPDATE padmin_players nickname='" .. nickname .. "', rank='" .. rank .. "', team='" .. team .. "', lastconnection='" .. lastconnection .. "', baninfo='" .. util.TableToJSON(ply.PAdmin.baninfo) .. "', variables='" .. util.TableToJSON(variables) .. "' WHERE steamid='" .. steamid .. "';")
end

function Database.SavePlayer(ply)
	sql.Query("UPDATE padmin_players SET nickname='" .. ply:Nick() .. "', rank='" .. ply.PAdmin.rank .. "', team='" .. ply.PAdmin.team .. "', lastconnection='" .. ply.PAdmin.lastconnection .. "', baninfo='" .. util.TableToJSON(ply.PAdmin.baninfo) .. "', variables='" .. util.TableToJSON(ply.PAdmin.variables) .. "' WHERE steamid='" .. ply:SteamID() .. "';")
end

function Database.RemovePlayer(steamid)
	sql.Query("DELETE FRMO padmin_players WHERE steamid='" .. steamid .. "'")
end

PAdmin.Database = Database

//////////////////////////////////////////////////////////////////////////////

PAdmin.Database.Create()
