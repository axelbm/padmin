
local function hasValue(tab)
	for k,v in pairs(tab) do
		return true
	end
	return false
end

local function GetDefaultRanks()
	local ranks = {}
	ranks.user = {
		group = "",
		privileges = {noclip = {target = 0}, god = {target = 0}},
		restrictions = {tools = {"dynamite", "emitter", "duplicator"}, models = {"models/props_c17/oildrum001_explosive.mdl"}},
		limits = {sbox_maxprops = 150},
		variables = {team = "user", immunity = 0, defaultrank = true, default = true}}

	ranks.admin = {
		group = "",
		privileges = {noclip = {target = 2}, god = {target = 2}, goto = {target = 3}, kick = {target = 1}, ban = {target = 1, maxtime = 20160}},
		restrictions = {},
		limits = {sbox_maxprops = 400},
		variables = {team = "admin", immunity = 50, defaultrank = true, admin = true}}

	ranks.superadmin = {
		group = "",
		privileges = {noclip = {target = 2}, god = {target = 2}, goto = {target = 3}, kick = {target = 2}, ban = {target = 1, prema = true}},
		restrictions = {},
		limits = {sbox_maxprops = -1},
		variables = {team = "superadmin", immunity = 100, defaultrank = true, admin = true, superadmin = true}}

	return ranks 
end

function PAdmin.LoadRanks() 
	local ranks = PAdmin.Database.GetRanks()
	if ranks and hasValue(ranks) then
		PAdmin.Ranks = ranks
		print("rank")
	else
		PAdmin.Ranks = GetDefaultRanks()

		for name,rank in pairs(PAdmin.Ranks) do
			PAdmin.Database.AddRank(name, rank.group, rank.privileges, rank.restrictions, rank.limits, rank.variables)
		end
		print("norank")
	end
end

function PAdmin.GetDefaultRank()
	for rankid,rank in pairs(PAdmin.Ranks) do
		if rank.variables.default then
			return rankid
		end
	end
	return nil
end

function PAdmin.SetRank(ply, rank)
	ply.PAdmin.rank = rank
	PAdmin.Database.SavePlayer(ply)
end

function PAdmin.PlyBetterThan(pl1, pl2)
	if PAdmin.Ranks[pl1.PAdmin.rank].variables.immunity > PAdmin.Ranks[pl2.PAdmin.rank].variables.immunity then
		return true
	end
	return false
end

function PAdmin.PlyBetterThanOrEqual(pl1, pl2)
	if PAdmin.Ranks[pl1.PAdmin.rank].variables.immunity >= PAdmin.Ranks[pl2.PAdmin.rank].variables.immunity then
		return true
	end
	return false
end

function PAdmin.PlayerGetAccess(ply, priv)
	local access = PAdmin.Ranks[ply.PAdmin.rank].privileges[priv]

	if access then
		return access
	end
	return false
end

function PAdmin.PlayerCanTarget(pl1, pl2, privlvl)
	if privlvl == 0 then
		if pl1 == pl2 then 
			return true
		end
	elseif privlvl == 1 then
		if PAdmin.PlyBetterThan(pl1, pl2) then
			return true
		end
	elseif privlvl == 2 then
		if PAdmin.PlyBetterThanOrEqual(pl1, pl2) then
			return true
		end
	elseif privlvl == 3 then
		return true
	end
	return false
end

//////////////////////////////////////////////////////////////////////////////

PAdmin.LoadRanks()
