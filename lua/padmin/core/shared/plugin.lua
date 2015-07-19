
function PAdmin.LoadPlugins()
	PAdmin.Plugins = {}
	PAdmin.Commands = {}
	PAdmin.Hooks = {}

	local pluginfiles = file.Find( "padmin/plugins/*.lua", "LUA" )
	for _, pluginfile in pairs(pluginfiles) do
		local prefix = string.Left(pluginfile, 2)

		if SERVER then
			if prefix == "cl" or prefix == "sh" then
				AddCSLuaFile("padmin/plugins/" .. pluginfile)
			end
			if prefix != "cl" then
				include("padmin/plugins/" .. pluginfile)
			end
		elseif CLIENT then
			include("padmin/plugins/" .. pluginfile)
		end
	end
end

function PAdmin.RemovePlugin(pluginTitle)
	local plugin = PAdmin.Plugins[pluginTitle]

	if plugin.Commands then
		for name,_ in pairs(plugin.Commands) do
			PAdmin.Commands[name] = nil
		end
	end

	if plugin.Hooks then
		for name,_ in pairs(plugin.Hooks) do
			PAdmin.Hooks[name][plugin.Title] = nil
		end
	end

	PAdmin.Plugins[pluginTitle] = nil
end

function PAdmin.RegisterPlugin(plugin)
	if PAdmin.Plugins[plugin.Title] then
		PAdmin.RemovePlugin(plugin.Title)
	end

	PAdmin.Plugins[plugin.Title] = plugin

	if plugin.Commands then
		for name, func in pairs(plugin.Commands) do
			if PAdmin.Commands[name] == nil then
				PAdmin.Commands[name] = {
					["Title"] = plugin.Title,
					["Function"] = func
				}
			else
				PAdmin.Notify(PAdmin.Commands[name].title .. "is already using the " .. name .. " command.")
			end
		end
	end

	if plugin.Hooks then
		for name, func in pairs(plugin.Hooks) do
			if not PAdmin.Hooks[name] then PAdmin.Hooks[name] = {} end

			PAdmin.Hooks[name][plugin.Title] = func
		end
	end
end

if not PAdmin.HookCall then PAdmin.HookCall = hook.Call end
hook.Call = function( name, gm, ... )
	if PAdmin.Hooks[name] then
		for title, func in pairs(PAdmin.Hooks[name]) do
			local succ, err = pcall(func, PAdmin.Plugins[title], ...)

			if not succ then
				PAdmin.Notify("Hook '" .. name .. "' in plugin '" .. title .. "' failed with error:")
				PAdmin.Notify(err)
			elseif err != nil then
				return err
			end
		end
	end
	
	return PAdmin.HookCall( name, gm, ... )
end

PAdmin.LoadPlugins()


function PAdmin.RunCommand(ply, cmd, args, silently)
	if PAdmin.Commands[cmd] then
		local plugin = PAdmin.Plugins[PAdmin.Commands[cmd].Title]
		local succ, err = pcall(PAdmin.Commands[cmd].Function, plugin, ply, args)

		if not succ then
			PAdmin.Notify("Command '" .. cmd .. "' in plugin '" .. plugin.Title .. "' failed with error:")
			PAdmin.Notify(err)
		else
			PAdmin.Notify(ply:Name() .. " ran " .. cmd .. " in plugin " .. plugin.Title)
		end

		return true
	else
		PAdmin.Notify(ply, "Invalid command: " .. cmd)

		return false
	end
end
