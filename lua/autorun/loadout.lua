---Weapon Loadout Master -------------------------------------
util.AddNetworkString( "ttt_loadoutprimary" )
util.AddNetworkString( "ttt_loadoutsecondary" )
util.AddNetworkString( "ttt_loadoutequipment" )
util.AddNetworkString( "loadout_invisible" )

if file.Exists( "loadout/invisible.txt", "DATA" ) then
    invisibleWeapons = util.JSONToTable(file.Read("loadout/invisible.txt", "DATA"))
else
    invisibleWeapons = { "weapon_ttt_poison_dart", "weapon_tttbasegrenade" }
    file.Write( "loadout/invisible.txt", util.TableToJSON( invisibleWeapons, true ) )
end

hook.Add( "Tick", "sendInvisibles", function() 
	net.Start( "loadout_invisible" )
		net.WriteTable( invisibleWeapons )
	net.Broadcast()
end )

function sendLoadouts()
	for _, pl in pairs(player.GetAll()) do
		local identifier = pl:SteamID64()
		local primary = file.Read( "loadout/" .. identifier .. "/primary.txt", "DATA" )
		local secondary = file.Read( "loadout/" .. identifier .. "/pistol.txt", "DATA" )
		local equipment = file.Read( "loadout/" .. identifier .. "/equipment.txt", "DATA" )
        net.Start( "ttt_loadoutprimary" )
			net.WriteString( primary )
		net.Send( pl )
		net.Start( "ttt_loadoutsecondary" )
			net.WriteString( secondary )
		net.Send( pl )
		net.Start( "ttt_loadoutequipment" )
			net.WriteString( equipment )
		net.Send( pl )
    end
end

hook.Add( "Tick", "sendPlayerloads", sendLoadouts )

net.Receive( "ttt_loadoutprimary", function( length, player )
	local identifier = player:SteamID64()
	local weapon = net.ReadString()
	file.CreateDir( "loadout/" .. identifier )
	file.Write( "loadout/" .. identifier .. "/primary.txt", weapon )
end )

net.Receive( "ttt_loadoutsecondary", function( length, player )
	local identifier = player:SteamID64()
	local weapon = net.ReadString()
	file.CreateDir( "loadout/" .. identifier )
	file.Write( "loadout/" .. identifier .. "/pistol.txt", weapon )
end )

net.Receive( "ttt_loadoutequipment", function( length, player )
	local identifier = player:SteamID64()
	local weapon = net.ReadString()
	file.CreateDir( "loadout/" .. identifier )
	file.Write( "loadout/" .. identifier .. "/equipment.txt", weapon )
end )

if file.Exists( "loadout/allowedgroups.txt", "DATA" ) then
    loadoutValidRanks = util.JSONToTable(file.Read("loadout/allowedgroups.txt", "DATA"))
else
    loadoutValidRanks = { "superadmin", "admin", "donator2", "donator" }
    file.Write( "loadout/allowedgroups.txt", util.TableToJSON( loadoutValidRanks, true ) )
end

hook.Add( "PlayerSpawn", "loadout_masterhook", function( pl )
    if SERVER then
        timer.Simple( 0.1, function() --for _, pl in pairs(player.GetAll()) do
			if (table.HasValue(loadoutValidRanks, pl:GetUserGroup())) then
				local identifier = pl:SteamID64()
				
				if pl:IsSpec() ~= true then
					local identifier = pl:SteamID64()
									
					if file.Exists( "loadout/" .. identifier .. "/primary.txt", "DATA" ) then
						local weapon = file.Read( "loadout/" .. identifier .. "/primary.txt", "DATA" )
						local wep = weapons.Get( weapon )
						for _, k in pairs(pl:GetWeapons()) do
							local wepclass = k:GetClass()
							if weapons.Get( wepclass ).Kind == wep.Kind then
								pl:StripWeapon( wepclass )
							end
						end
						local ammoamt = wep.Primary.ClipMax
						local ammotype = wep.Primary.Ammo
						pl:Give( weapon )
						timer.Simple( 0.25, function() pl:SelectWeapon( weapon ) end )
						pl:SetAmmo( ammoamt, ammotype, true )
					end
									
					if file.Exists( "loadout/" .. identifier .. "/pistol.txt", "DATA" ) then
						local weapon = file.Read( "loadout/" .. identifier .. "/pistol.txt", "DATA" )
						local wep = weapons.Get( weapon )
						for _, k in pairs(pl:GetWeapons()) do
							local wepclass = k:GetClass()
							if weapons.Get( wepclass ).Kind == wep.Kind then
								pl:StripWeapon( wepclass )
							end
						end

						local ammoamt = wep.Primary.ClipMax
						local ammotype = wep.Primary.Ammo
						pl:Give( weapon )
						pl:SetAmmo( ammoamt, ammotype, true )
					end
									
					if file.Exists( "loadout/" .. identifier .. "/equipment.txt", "DATA" ) then
						local weapon = file.Read( "loadout/" .. identifier .. "/equipment.txt", "DATA" )
						local wep = weapons.Get( weapon )
						for _, k in pairs(pl:GetWeapons()) do
							local wepclass = k:GetClass()
							if weapons.Get( wepclass ).Kind == wep.Kind then
								pl:StripWeapon( wepclass )
							end
						end
						pl:Give( weapon )
					end			
					
					sound.Play( 'items/gift_pickup.wav', pl:GetPos() )
				end
			end
        --end
		end )
    end
end )

function fixreporting()
	if SERVER then
		for _, pl in pairs(player.GetAll()) do
			pl.CanReport = true
		end
	end
end

hook.Add( "Tick", "RDMManagerFix", fixreporting )

