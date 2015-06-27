CreateClientConVar("ttt_avoid_detective", "0", true, true)
CreateClientConVar("ttt_loadout_primary", "0", true, true)
CreateClientConVar("ttt_loadout_secondary", "0", true, true)
CreateClientConVar("ttt_loadout_equipment", "0", true, true)

local invisibleweapons = {
	"weapon_ttt_jum9",
	"weapon_ttt_poison_dart",
	"weapon_ttt_bump",
	"weapon_ttt_rollerb",
	"weapon_zm_molotov2",
	"weapon_zm_molotov3",
	"weapon_ttt_confgrenade2",
	"weapon_ttt_confgrenade3",
	"weapon_ttt_smokegrenade2",
	"weapon_ttt_smokegrenade3",
	"weapon_ttt_zombgren",
	"weapon_tttbasegrenade",
    "weapon_ttt_medkit_20",
    "weapon_ttt_medkit_15",
    "weapon_ttt_medkit_5"
}

hook.Add( "TTTSettingsTabs", "LoadoutTTTSettingsTab", function(dtabs)

	local padding = dtabs:GetPadding()

	padding = padding * 2
	

	local dsettings = vgui.Create("DPanelList", dtabs)
	dsettings:StretchToParent(0,0,padding,0)
	dsettings:EnableVerticalScrollbar(true)
	dsettings:SetPadding(10)
	dsettings:SetSpacing(10)

	local donatorHelp = vgui.Create( "DLabel", dsettings )
	donatorHelp:SetText( "You will only receive your weapons if you are in the proper group." )
	donatorHelp:SetDark( true )
    dsettings:AddItem(donatorHelp)
  local lprimary = vgui.Create("DForm", dsettings)
   lprimary:SetName("Primaries")
   

   local lprimarydropbox = vgui.Create("DComboBox", lprimary)

   if file.Exists( "loadout/primary.txt", "DATA" ) then 
    primaryClass = file.Read( "loadout/primary.txt", "DATA" )
   end
   
   if file.Exists( "loadout/secondary.txt", "DATA" ) then 
    secondaryClass = file.Read( "loadout/secondary.txt", "DATA" )
   end
   
   if file.Exists( "loadout/equipment.txt", "DATA" ) then 
    equipmentClass = file.Read( "loadout/equipment.txt", "DATA" )
   end
   
   for _, v in pairs( weapons.GetList() ) do 
      if v.Kind == WEAPON_HEAVY and (!table.HasValue(invisibleweapons, v.ClassName)) then
	  local weapon = v.ClassName
	  local printname = v.PrintName
      if weapon == primaryClass then
        lprimarydropbox:AddChoice(weapon, weapon, true)
      else
        lprimarydropbox:AddChoice(weapon, weapon, false)
      end
	  end
   end

   lprimarydropbox.OnSelect = function(idx, val, data)
                       file.Write( "loadout/primary.txt", data )
                       RunConsoleCommand("ttt_loadout_primary", data )
                    end
   lprimarydropbox.Think = lprimarydropbox.ConVarStringThink

   lprimary:AddItem(lprimarydropbox)

   dsettings:AddItem(lprimary)
--
   local lsecondary = vgui.Create("DForm", dsettings)
   lsecondary:SetName("Pistols")

   local lsecondarydropbox = vgui.Create("DComboBox", lsecondary)

   for _, v in pairs( weapons.GetList() ) do 
      if v.Kind == WEAPON_PISTOL and (!table.HasValue(invisibleweapons, v.ClassName)) then
	  local weapon = v.ClassName
	  local printname = v.PrintName
      if weapon == secondaryClass then
        lsecondarydropbox:AddChoice(weapon, weapon, true)
      else
        lsecondarydropbox:AddChoice(weapon, weapon, false)
      end
	  end
   end

   lsecondarydropbox.OnSelect = function(idx, val, data)
                       file.Write( "loadout/secondary.txt", data )
                       RunConsoleCommand("ttt_loadout_secondary", data )
                    end
   lsecondarydropbox.Think = lsecondarydropbox.ConVarStringThink

   lsecondary:AddItem(lsecondarydropbox)

   dsettings:AddItem(lsecondary)
--
   local lequipment = vgui.Create("DForm", dsettings)
   lequipment:SetName("Equipment")

   local lequipmentdropbox = vgui.Create("DComboBox", lequipment)

   for _, v in pairs( weapons.GetList() ) do 
      if v.Kind == WEAPON_NADE and (!table.HasValue(invisibleweapons, v.ClassName)) then
	  local weapon = v.ClassName
	  local printname = v.PrintName
      if weapon == equipmentClass then
        lequipmentdropbox:AddChoice(weapon, weapon, true)
      else
        lequipmentdropbox:AddChoice(weapon, weapon, false)
      end
	  end
   end

   lequipmentdropbox.OnSelect = function(idx, val, data)
                        file.Write( "loadout/equipment.txt", data )
                       RunConsoleCommand("ttt_loadout_equipment", data )
                    end
   lequipmentdropbox.Think = lequipmentdropbox.ConVarStringThink

   lequipment:AddItem(lequipmentdropbox)
--
   dsettings:AddItem(lequipment)
   
   dtabs:AddSheet("Loadouts", dsettings, nil, false, false, "Damagelog menu settings")
end )
	