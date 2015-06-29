---Weapon Loadout Master -------------------------------------
if SERVER then
util.AddNetworkString( "ttt_loadoutprimary" )
util.AddNetworkString( "ttt_loadoutsecondary" )
util.AddNetworkString( "ttt_loadoutequipment" )
util.AddNetworkString( "ttt_loadoutprimarycl" )
util.AddNetworkString( "ttt_loadoutsecondarycl" )
util.AddNetworkString( "ttt_loadoutequipmentcl" )
util.AddNetworkString( "loadout_invisible" )

if file.Exists( "loadout/invisible.txt", "DATA" ) then
    invisibleWeapons = util.JSONToTable(file.Read("loadout/invisible.txt", "DATA"))
else
    invisibleWeapons = { "weapon_ttt_poison_dart", "weapon_tttbasegrenade" }
    file.Write( "loadout/invisible.txt", util.TableToJSON( invisibleWeapons, true ) )
end

hook.Add( "Tick", "sendInvisibles", function() 
    timer.Simple( 0.1, function()
        net.Start( "loadout_invisible" )
            net.WriteTable( invisibleWeapons )
        net.Broadcast()
    end )
end )

function sendLoadouts()
    timer.Simple( 0.1, function()
        for _, pl in pairs(player.GetAll()) do
            local identifier = pl:SteamID64()
			if file.Exists( "loadout/" .. identifier .. "/primary.txt", "DATA" ) then
				local primary = file.Read( "loadout/" .. identifier .. "/primary.txt", "DATA" )
				net.Start( "ttt_loadoutprimarycl" )
					net.WriteString( primary )
				net.Send( pl )
			end
			
			if file.Exists( "loadout/" .. identifier .. "/pistol.txt", "DATA" ) then
				local secondary = file.Read( "loadout/" .. identifier .. "/pistol.txt", "DATA" )
				net.Start( "ttt_loadoutsecondarycl" )
					net.WriteString( secondary )
				net.Send( pl )
			end
				
			if file.Exists( "loadout/" .. identifier .. "/equipment.txt", "DATA" ) then
				local equipment = file.Read( "loadout/" .. identifier .. "/equipment.txt", "DATA" )
				net.Start( "ttt_loadoutequipmentcl" )
					net.WriteString( equipment )
				net.Send( pl )
			end
        end
    end )
end

hook.Add( "Tick", "sendPlayerloads", sendLoadouts )

net.Receive( "ttt_loadoutprimary", function( length, player )
	local identifier = player:SteamID64()
	local weapon = net.ReadString()
	file.CreateDir( "loadout/" .. identifier )
	file.Write( "loadout/" .. identifier .. "/primary.txt", weapon )
	--PrintMessage( HUD_PRINTTALK, player:Nick() .. " has set themself to spawn with " .. weapon )
end )

net.Receive( "ttt_loadoutsecondary", function( length, player )
	local identifier = player:SteamID64()
	local weapon = net.ReadString()
	file.CreateDir( "loadout/" .. identifier )
	file.Write( "loadout/" .. identifier .. "/pistol.txt", weapon )
    --PrintMessage( HUD_PRINTTALK, player:Nick() .. " has set themself to spawn with " .. weapon )
end )

net.Receive( "ttt_loadoutequipment", function( length, player )
	
	local identifier = player:SteamID64()
	local weapon = net.ReadString()
	file.CreateDir( "loadout/" .. identifier )
	file.Write( "loadout/" .. identifier .. "/equipment.txt", weapon )
    --PrintMessage( HUD_PRINTTALK, player:Nick() .. " has set themself to spawn with " .. weapon )
end )

if file.Exists( "loadout/allowedgroups.txt", "DATA" ) then
    loadoutValidRanks = util.JSONToTable(file.Read("loadout/allowedgroups.txt", "DATA"))
else
    loadoutValidRanks = { "superadmin", "admin", "donator2", "donator" }
    file.Write( "loadout/allowedgroups.txt", util.TableToJSON( loadoutValidRanks, true ) )
end

hook.Add( "PlayerSpawn", "loadout_masterhook", function( pl )
   --PrintMessage( HUD_PRINTTALK, pl:Nick() .. " has spawned" )
    if SERVER then
        timer.Simple( 0.1, function() --for _, pl in pairs(player.GetAll()) do
            --PrintMessage( HUD_PRINTTALK, pl:Nick() .. " has spawned and the timer is started" )
			if (table.HasValue(loadoutValidRanks, pl:GetUserGroup())) then
                --PrintMessage( HUD_PRINTTALK, pl:Nick() .. " is able to use loadout" )
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
                                --PrintMessage( HUD_PRINTTALK, pl:Nick() .. " had " .. wepclass .. " stripped from them")
							end
						end
						local ammoamt = wep.Primary.ClipMax
						local ammotype = wep.Primary.Ammo
						pl:Give( weapon )
                        --PrintMessage( HUD_PRINTTALK, pl:Nick() .. " was given " .. weapon )
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
                                --PrintMessage( HUD_PRINTTALK, pl:Nick() .. " had " .. wepclass .. " stripped from them")
							end
						end

						local ammoamt = wep.Primary.ClipMax
						local ammotype = wep.Primary.Ammo
						pl:Give( weapon )
                        --PrintMessage( HUD_PRINTTALK, pl:Nick() .. " was given " .. weapon )
						pl:SetAmmo( ammoamt, ammotype, true )
					end
									
					if file.Exists( "loadout/" .. identifier .. "/equipment.txt", "DATA" ) then
						local weapon = file.Read( "loadout/" .. identifier .. "/equipment.txt", "DATA" )
						local wep = weapons.Get( weapon )
						for _, k in pairs(pl:GetWeapons()) do
							local wepclass = k:GetClass()
							if weapons.Get( wepclass ).Kind == wep.Kind then
								pl:StripWeapon( wepclass )
                                --PrintMessage( HUD_PRINTTALK, pl:Nick() .. " had " .. wepclass .. " stripped from them")
							end
						end
						pl:Give( weapon )
                        --PrintMessage( HUD_PRINTTALK, pl:Nick() .. " was given " .. weapon )
					end			
					
					sound.Play( 'items/gift_pickup.wav', pl:GetPos() )
				end
			end
        --end
		end )
    end
end )

function fixreporting()
    timer.Simple( 0.1, function()
        if SERVER then
            for _, pl in pairs(player.GetAll()) do
                pl.CanReport = true
            end
        end
    end )
end

hook.Add( "Tick", "RDMManagerFix", fixreporting )

end