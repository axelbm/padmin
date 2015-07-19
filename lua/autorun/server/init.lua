PAdmin = {}

AddCSLuaFile("autorun/client/cl_init.lua")

include("padmin/core/server/sql.lua")

include("padmin/core/server/rank.lua")

include("padmin/core/server/player.lua")
include("padmin/core/shared/player.lua")
AddCSLuaFile("padmin/core/client/player.lua")
AddCSLuaFile("padmin/core/shared/player.lua")

include("padmin/core/shared/notify.lua")
AddCSLuaFile("padmin/core/shared/notify.lua")

include("padmin/core/shared/plugin.lua")
AddCSLuaFile("padmin/core/shared/plugin.lua")


