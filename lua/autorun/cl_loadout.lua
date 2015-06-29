net.Receive( "loadout_invisible", function()
	invisibleweapons = net.ReadTable() 
end )

net.Receive( "ttt_loadoutprimarycl", function()
	primaryClass = net.ReadString()
end )

net.Receive( "ttt_loadoutsecondarycl", function()
	secondaryClass = net.ReadString()
end )

net.Receive( "ttt_loadoutequipmentcl", function()
	equipmentClass = net.ReadString()
end )

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
						net.Start( "ttt_loadoutprimary" )
							net.WriteString( data )
						net.SendToServer()
					   print( data )
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
						net.Start( "ttt_loadoutsecondary" )
							net.WriteString( data )
						net.SendToServer()
					   print( data )
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
						net.Start( "ttt_loadoutequipment" )
							net.WriteString( data )
						net.SendToServer()
					   print( data )
                    end
   lequipmentdropbox.Think = lequipmentdropbox.ConVarStringThink

   lequipment:AddItem(lequipmentdropbox)
--
   dsettings:AddItem(lequipment)
   
   dtabs:AddSheet("Loadouts", dsettings, "icon16/bomb.png", false, false, "Damagelog menu settings")
end )
	