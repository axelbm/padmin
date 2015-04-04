local Database = {}

function Database.Create()
	if sql.TableExists("padmin_settings") then
		sql.Query("CREATE TABLE padmin_settings (name TEXT PRIMARY KEY, variables TEXT);")
	end
	if sql.TableExists("padmin_ranks") then
		sql.Query("CREATE TABLE padmin_ranks (rankid TEXT PRIMARY KEY, team TEXT, privileges TEXT, restrictions TEXT, limits TEXT, variables TEXT);")
	end
	if sql.TableExists("padmin_teams") then
		sql.Query("CREATE TABLE padmin_teams (teamid TEXT PRIMARY KEY, teamname TEXT, variables TEXT);")
	end
	if sql.TableExists("padmin_players") then
		sql.Query("CREATE TABLE padmin_players (steamid TEXT PRIMARY KEY, rank TEXT, baninfo TEXT, timeplayed INT, variables Text);")
	end
end

function Database.DeleteAll()
	sql.Query("DROP TABLE padmin_settings")
	sql.Query("DROP TABLE padmin_ranks")
	sql.Query("DROP TABLE padmin_teams")
	sql.Query("DROP TABLE padmin_players")
end

//Settins

function Database.AddSetting(name, value)
	sql.Query("INSERT padmin_settings VALUES ('" .. name .. "', '" .. util.TableToJSON(value) .. "');")
end

function Database.GetSetting(name)
	return  sql.Query("SELECT * FROM padmin_settings WHERE name='" .. name .. "';")
end

function Database.UpdateSetting(name, value)
	sql.Query("UPDATE INTO padmin_settings SET variables='" .. util.TableToJSON(value) .. "' WHERE name='" .. name .. "';")
end

function Database.RemoveSetting(name)
	sql.Query("DELETE FROM padmin_settings WHERE name='" .. name .. "'")
end

//Ranks

