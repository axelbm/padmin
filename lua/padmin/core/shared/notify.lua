
PAdmin.Colors = {}

PAdmin.Colors.black		=	Color(0,0,0)
PAdmin.Colors.white		=	Color(255,255,255)
PAdmin.Colors.red		=	Color(255,0,0)
PAdmin.Colors.lime		=	Color(0,255,0)
PAdmin.Colors.blue		=	Color(0,0,255)
PAdmin.Colors.yellow	=	Color(255,255,0)
PAdmin.Colors.cyan 		=	Color(0,255,255)
PAdmin.Colors.magenta	=	Color(255,0,255)
PAdmin.Colors.silver	=	Color(192,192,192)
PAdmin.Colors.gray		=	Color(128,128,128)
PAdmin.Colors.maroon	=	Color(128,0,0)
PAdmin.Colors.olive		=	Color(128,128,0)
PAdmin.Colors.green		=	Color(0,128,0)
PAdmin.Colors.purple	=	Color(128,0,128)
PAdmin.Colors.teal		=	Color(0,128,128)
PAdmin.Colors.navy		=	Color(0,0,128)

local TimeN = {1, 60, 60*60, 60*60*24, 60*60*24*7, 60*60*24*30, 60*60*24*365}
local TimeS = {"second", "minute", "hour", "day", "week", "month", "year"}

function PAdmin.TimeInString(time, max)
	local str = ""
	local count = 0
	local tab = {}

	for i = 1, 7 do
		if math.floor(time/TimeN[7]) > 0 or (i > 1 and math.floor((time%TimeN[9-i])/TimeN[8-i]) > 0) then
			local t = 0

			if i == 1 then 	
				t = math.floor(time/TimeN[8-i]) else
				t = math.floor((time%TimeN[9-i])/TimeN[8-i]) end

			if t > 1 then
				table.insert(tab, t .. " " .. TimeS[8-i] .. "s") else
				table.insert(tab, "one " .. TimeS[8-i]) end

			count = count + 1

			if count >= max then
				break end
		end
	end

	for i = 1, #tab do
		if i == 1 then
			str = tab[i]
		elseif i == #tab then 
			str = str .. " and " .. tab[i] else
			str = str .. ", " .. tab[i] end
	end

	return str
end

function PAdmin.PlayersInString(plys)
	local str = ""

	for i = 1, #plys do
		
		if i == 1 then
			str = plys[i]:Name()
		elseif i == #plys then
			str = str .. " and " .. plys[i]:Name()
		else
			str = str .. ", " .. plys[i]:Name()
		end
	end

	return str
end

function PAdmin.PlayersInNotifTab(plys)
	local tab = {}

	for i = 1, #plys do
		local pl = plys[i]

		if i == 1 then
			// table.insert(tab, PAdmin.Groups[PAdmin.PlayerGetGroup(pl)].Color)
			table.insert(tab, pl:Name())
		elseif i == #plys then
			table.insert(tab, "#white")
			table.insert(tab, " and ")

			// table.insert(tab, PAdmin.Groups[PAdmin.PlayerGetGroup(pl)].Color)
			table.insert(tab, pl:Name())
		else
			table.insert(tab, "#white")
			table.insert(tab, ", ")

			// table.insert(tab, PAdmin.Groups[PAdmin.PlayerGetGroup(pl)].Color)
			table.insert(tab, pl:Name())
		end
	end
end


if SERVER then
	util.AddNetworkString("PAdmin_Notify")

	function PAdmin.Notify(...)
		local arg = {...}

		local ply = {}
		if type(arg[1]) == "Player" then
			table.insert(ply, arg[1])
			table.remove(arg, 1)
		elseif type(var) == "table" then
			for _,var in pairs(arg[1]) do
				if isentity(var) and var then
					table.insert(ply, pl)
				end
			end
			table.remove(arg, 1)
		end

		if #ply == 0 then
			ply = player.GetAll()
		end

		net.Start("PAdmin_Notify")
			net.WriteTable(arg)
		net.Send(ply)
	end
else
	function PAdmin.Notify(...)
		local arg = {...}

		local tab = {}
		for _, var in pairs(arg) do
			if type(var) == "table" then
				table.insert(tab, var)
			elseif type(var) == "string" then
				if string.Left(var, 1) == "#" and PAdmin.Colors[string.Right(var, #var - 1)] then
					table.insert(tab, PAdmin.Colors[string.Right(var, #var - 1)])
				else
					table.insert(tab, var)
				end
			end
		end

		chat.AddText(unpack(tab))
	end

	net.Receive("PAdmin_Notify", function(len)
		local arg = net.ReadTable()
		PrintTable(arg)
		PAdmin.Notify(unpack(arg))
	end)
end

