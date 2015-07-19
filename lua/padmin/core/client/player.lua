
function PAdmin.PlayerGetPlayedTime(ply)
	return ply.PAdmin.timeplayed + os.time() - ply.PAdmin.lastconnection
end



net.Receive("PAdmin_Player_Update_Client", function(len)
	local ply = net.ReadEntity()
	local tab = net.ReadTable()
	ply.PAdmin = tab
end)



hook.Add("InitPostEntity", "PAdmin_Initialize", function()

	print("test")
	net.Start("PAdmin_Init_Ply_Request")
		net.WriteString("Hi")
	net.SendToServer()
end)