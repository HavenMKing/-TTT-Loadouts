---Weapon Loadout - Master -----------------------------------
local ValidRanks = {
	"donator",
	"donator2",
	"director"
}

hook.Add( "TTTBeginRound", "loadout_masterhook", function()
    if SERVER then
        for _, pl in pairs(player.GetAll()) do
			if (table.HasValue(ValidRanks, pl:GetUserGroup())) then
				local identifier = pl:SteamID64()
				local primary = pl:GetInfo( "ttt_loadout_primary" )
				local secondary = pl:GetInfo( "ttt_loadout_secondary" )
				local equipment = pl:GetInfo( "ttt_loadout_equipment" )
				
				file.CreateDir( "loadout/" .. identifier )
				file.Write( "loadout/" .. identifier .. "/primary.txt", primary )
				file.Write( "loadout/" .. identifier .. "/pistol.txt", secondary )
				file.Write( "loadout/" .. identifier .. "/equipment.txt", equipment )
				
				if pl:IsSpec() ~= true and pl:SteamID() == "STEAM_0:1:41036632" then
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
						pl:SelectWeapon( weapon )
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
						pl:SetAmmo( ammoamt, ammotype, true )
					end
					
					sound.Play( 'items/gift_pickup.wav', pl:GetPos() )
				end
			end
        end
    end
end )

