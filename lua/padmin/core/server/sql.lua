local Database = {}

function Database.Create()
	if not sql.TableExists("padmin_settings") then
		sql.Query("CREATE TABLE padmin_settings (name TEXT PRIMARY KEY, variables TEXT);")
		print("PAdmin settings database settup.")
	end
	if not sql.TableExists("padmin_ranks") then
		sql.Query("CREATE TABLE padmin_ranks (rankid TEXT PRIMARY KEY, privileges TEXT, restrictions TEXT, limits TEXT, variables TEXT);")
		print("PAdmin ranks database settup.")
	end
	if not sql.TableExists("padmin_teams") then
		sql.Query("CREATE TABLE padmin_teams (teamid TEXT PRIMARY KEY, teamname TEXT, variables TEXT);")
		print("PAdmin teams database settup.")
	end
	if not sql.TableExists("padmin_players") then
		sql.Query("CREATE TABLE padmin_players (steamid TEXT PRIMARY KEY, rank TEXT, team TEXT, baninfo TEXT, variables Text);")
		print("PAdmin players database settup.")
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

function Database.RemoveRank(rankid)
	sql.Query("DELETE FROM padmin_ranks WHERE rankid='" .. rankid .. "';")
end

// Players

function Database.GetPlayer(steamid)
	return sql.Query("SELECT * FROM padmin_players WHERE steamid='" .. steamid .. "'")
end

function Database.AddPlayer(steamid, rank, team, variables)
	sql.Query("INSERT INTO padmin_players VALUES ('" .. steamid .. "', '" .. rank .. "', '" .. team .. "', '', '" .. util.TableToJSON(variables) .. "');")
end

function Database.UpdatePlayer(steamid, rank, team, baninfo, variables)
	sql.Query("UPDATE padmin_players rank='" .. rank .. "', team='" .. team .. "', baninfo='" .. baninfo .. "', variables='" .. util.TableToJSON(variables) .. "' WHERE steamid='" .. steamid .. "';")
end

function Database.RemovePlayer(steamid)
	sql.Query("DELETE FRMO padmin_players WHERE steamid='" .. steamid .. "'")
end


PAdmin.Database = Database