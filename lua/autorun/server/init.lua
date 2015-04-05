PAdmin = {}

AddCSLuaFile("autorun/client/cl_init.lua")

include("padmin/core/server/sql.lua")
PAdmin.Database.Create()

include("padmin/core/server/rank.lua")