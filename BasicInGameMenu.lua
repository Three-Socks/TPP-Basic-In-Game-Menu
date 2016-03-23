local e={}
e.menu_level = 1
e.menu_last_selected={}
e.button_pressed={}
e.button_pressed_time={}
e.menu_skip_frame = 0

e.bm_changedToBB = false
e.bm_changedToBBoldType = PlayerType.SNAKE

function e.OnAllocate()end
function e.OnInitialize()end

function e.bm_changePlayerType()
	local bm_playerTypes={PlayerType.SNAKE, PlayerType.DD_MALE, PlayerType.DD_FEMALE, PlayerType.AVATAR}

	if (e.bm_playerType_face == nil) then
		e.bm_playerType_face = 0
	end

	if vars.playerFaceId ~= 0 and vars.playerFaceId ~= nil then
		e.bm_playerType_face = vars.playerFaceId
	end

	if ((vars.playerCamoType == PlayerCamoType.EVA_CLOSE or
		vars.playerCamoType == PlayerCamoType.EVA_OPEN or
		vars.playerCamoType == PlayerCamoType.BOSS_CLOSE or
		vars.playerCamoType == PlayerCamoType.BOSS_OPEN)
		and e.menu_item_highlighted == 2)
	then
		TppUiCommand.AnnounceLogDelayTime(0)
		TppUiCommand.AnnounceLogView("Cannot change player type to DD Male while using this camo")
	elseif ((vars.playerCamoType == PlayerCamoType.MGS3 or
		vars.playerCamoType == PlayerCamoType.MGS3_NAKED or
		vars.playerCamoType == PlayerCamoType.MGS3_SNEAKING or
		vars.playerCamoType == PlayerCamoType.MGS3_TUXEDO)
		and e.menu_item_highlighted == 3)
	then
		TppUiCommand.AnnounceLogDelayTime(0)
		TppUiCommand.AnnounceLogView("Cannot change player type to DD Female while using this camo")
	elseif (vars.playerCamoType == PlayerCamoType.SNEAKING_SUIT_GZ) then
		TppUiCommand.AnnounceLogDelayTime(0)
		TppUiCommand.AnnounceLogView("Cannot change player type while using Sneaking Suit GZ")
	else
		vars.playerType=bm_playerTypes[e.menu_item_highlighted]
		vars.playerFaceId=0

		if vars.playerType == PlayerType.DD_MALE or vars.playerType == PlayerType.DD_FEMALE then
			vars.playerFaceId = e.bm_playerType_face
		end
	end
	
	if (e.bm_changedToBB) then
		vars.playerPartsType = PlayerPartsType.NORMAL
		vars.playerFaceId = 0
		e.bm_changedToBB = false
	end
end

function e.bm_changePlayerFace(changeby)

	if changeby == nil then
		changeby = 0
	end

	local playerface = vars.playerFaceId + changeby
	
	if playerface < 0 then
		playerface = 0
	end

	if playerface > 9999 then
		playerface = 9999
	end
	
	vars.playerFaceId=playerface

	TppUiCommand.AnnounceLogDelayTime(0)
	TppUiCommand.AnnounceLogView(string.format("Face ID: %d", vars.playerFaceId))

end

function e.bm_changePlayerPart(playerpart)
	vars.playerPartsType=playerpart
end

function e.bm_toggleScarf()
	if (vars.playerPartsType ~= PlayerPartsType.NORMAL_SCARF) then
		vars.playerPartsType = PlayerPartsType.NORMAL_SCARF
	else
		vars.playerPartsType = PlayerPartsType.NORMAL
	end
end

function e.bm_changeCamoBB()
	vars.playerType = PlayerType.DD_MALE
	vars.playerFaceId = 400
	vars.playerPartsType = PlayerPartsType.NORMAL
	vars.playerPartsType = PlayerPartsType.SNEAKING_SUIT
	e.bm_changedToBB = true
	e.bm_changedToBBoldType = vars.playerType
end

function e.bm_changeCamo(camo)
	if (camo == PlayerCamoType.SNEAKING_SUIT_GZ and vars.playerType ~= PlayerType.SNAKE) then
		TppUiCommand.AnnounceLogDelayTime(0)
		TppUiCommand.AnnounceLogView("Only the Snake player type can use this camo.")
		do return end
	end

	if ((camo == PlayerCamoType.MGS3 or
		camo == PlayerCamoType.MGS3_NAKED or
		camo == PlayerCamoType.MGS3_SNEAKING or
		camo == PlayerCamoType.MGS3_TUXEDO)
		and (vars.playerType == PlayerType.DD_FEMALE))
	then
		TppUiCommand.AnnounceLogDelayTime(0)
		TppUiCommand.AnnounceLogView("The DD Female player type cannot use this camo.")
		do return end
	end
	
	if ((camo == PlayerCamoType.EVA_CLOSE or
		camo == PlayerCamoType.EVA_OPEN or
		camo == PlayerCamoType.BOSS_CLOSE or
		camo == PlayerCamoType.BOSS_OPEN)
		and vars.playerType == PlayerType.DD_MALE)
	then
		TppUiCommand.AnnounceLogDelayTime(0)
		TppUiCommand.AnnounceLogView("The DD Male player type cannot use this camo.")
		do return end
	end
	
	vars.playerCamoType=camo

	if (vars.playerPartsType == PlayerPartsType.NORMAL_SCARF) then
		vars.playerPartsType = PlayerPartsType.NORMAL
		vars.playerPartsType = PlayerPartsType.NORMAL_SCARF
	else
		vars.playerPartsType = PlayerPartsType.NORMAL
	end

	vars.playerFaceEquipId = 0
	
	if (e.bm_changedToBB) then
		vars.playerType = e.bm_changedToBBoldType
		vars.playerPartsType = PlayerPartsType.NORMAL
		vars.playerFaceId = 0
		e.bm_changedToBB = false
	end
end

function e.bm_changeWeather()
	local bm_weather={TppDefine.WEATHER.SUNNY, TppDefine.WEATHER.CLOUDY, TppDefine.WEATHER.RAINY, TppDefine.WEATHER.SANDSTORM, TppDefine.WEATHER.FOGGY}

	if (e.menu_item_highlighted == 6) then
		TppWeather.CancelForceRequestWeather()
	else
		TppWeather.ForceRequestWeather(bm_weather[e.menu_item_highlighted], 0)
	end
end

function e.bm_changeTimescale(changeby)
	if changeby == nil then
		changeby = 0
	end

	if (e.bm_ClockTimeScale == nil or e.menu_item_highlighted == 5) then
		e.bm_ClockTimeScale = 20
	end

	e.bm_ClockTimeScale = e.bm_ClockTimeScale + changeby

	if e.bm_ClockTimeScale < 0 then
		e.bm_ClockTimeScale = 0
	end

	if e.bm_ClockTimeScale > 9999 then
		e.bm_ClockTimeScale = 9999
	end

	TppCommand.Weather.SetClockTimeScale(e.bm_ClockTimeScale)

	TppUiCommand.AnnounceLogDelayTime(0)
	TppUiCommand.AnnounceLogView(string.format("Timescale: %d", e.bm_ClockTimeScale))
end

function e.bm_changeTime(timeString)

	TppClock.SetTime(timeString)

	TppUiCommand.AnnounceLogDelayTime(0)
	TppUiCommand.AnnounceLogView(string.format("Time: %s", timeString))
end

function e.bm_padType()
	TppUiCommand.AnnounceLogDelayTime(0)
	TppUiCommand.AnnounceLogView(string.format("padType: %d", vars.padType))
	TppUiCommand.AnnounceLogDelayTime(0)
	TppUiCommand.AnnounceLogView(string.format("controlType: %d", cvars.controlType))
end

function e.menu_set()
	e.menu_title = "bm_main_title"

	if (e.menu_level == 1) then
		e.menu_addItem("bm_playertype")
		e.menu_addItem("bm_playerface")
		e.menu_addItem("bm_camo")
		e.menu_addItem("bm_weather")
		e.menu_addItem("bm_time")
		e.menu_addItem_action("bm_main_title", e.bm_padType)
	elseif (e.menu_level == 2) then
		if (e.menu_last_selected[1] == 1) then
			e.menu_title = "bm_playertype"
			e.menu_addItem_action("bm_playertype_snake", e.bm_changePlayerType)
			e.menu_addItem_action("bm_playertype_dd_male", e.bm_changePlayerType)
			e.menu_addItem_action("bm_playertype_dd_female", e.bm_changePlayerType)
			e.menu_addItem_action("bm_playertype_avatar", e.bm_changePlayerType)
		elseif (e.menu_last_selected[1] == 2) then
			e.menu_title = "bm_playerface"
			e.menu_addItem_action("bm_playerface_up_1", e.bm_changePlayerFace, 1)
			e.menu_addItem_action("bm_playerface_up_10", e.bm_changePlayerFace, 10)
			e.menu_addItem_action("bm_playerface_up_100", e.bm_changePlayerFace, 100)
			e.menu_addItem_action("bm_playerface_down_1", e.bm_changePlayerFace, -1)
			e.menu_addItem_action("bm_playerface_down_10", e.bm_changePlayerFace, -10)
			e.menu_addItem_action("bm_playerface_down_100", e.bm_changePlayerFace, -100)
		elseif (e.menu_last_selected[1] == 3) then
			e.menu_title = "bm_camo"
			e.menu_addItem("bm_camo_normal")
			e.menu_addItem("bm_camo_special")
			e.menu_addItem("bm_camo_fob")
			e.menu_addItem("bm_camo_dlc")
			
			if (vars.playerType == PlayerType.SNAKE or vars.playerType == PlayerType.AVATAR) then
				e.menu_addItem_action("bm_camo_scarf", e.bm_toggleScarf)
			end
		elseif (e.menu_last_selected[1] == 4) then
			e.menu_title = "bm_weather"
			e.menu_addItem_action("bm_weather_sunny", e.bm_changeWeather)
			e.menu_addItem_action("bm_weather_cloudy", e.bm_changeWeather)
			e.menu_addItem_action("bm_weather_rainy", e.bm_changeWeather)
			e.menu_addItem_action("bm_weather_sandstorm", e.bm_changeWeather)
			e.menu_addItem_action("bm_weather_foggy", e.bm_changeWeather)
			e.menu_addItem_action("bm_reset", e.bm_changeWeather)
		elseif (e.menu_last_selected[1] == 5) then
			e.menu_title = "bm_time"
			e.menu_addItem("bm_time")
			e.menu_addItem("bm_timescale")
		end
	elseif (e.menu_level == 3) then
		if (e.menu_last_selected[1] == 3) then
			e.menu_title = "bm_camo"

			if (e.menu_last_selected[2] == 1) then
				e.menu_addItem_action("bm_camo_olivedrab", e.bm_changeCamo, PlayerCamoType.OLIVEDRAB)
				e.menu_addItem_action("bm_camo_splitter", e.bm_changeCamo, PlayerCamoType.SPLITTER)
				e.menu_addItem_action("bm_camo_square", e.bm_changeCamo, PlayerCamoType.SQUARE)
				e.menu_addItem_action("bm_camo_tigerstripe", e.bm_changeCamo, PlayerCamoType.TIGERSTRIPE)
				e.menu_addItem_action("bm_camo_goldtiger", e.bm_changeCamo, PlayerCamoType.GOLDTIGER)
				e.menu_addItem_action("bm_camo_foxtrot", e.bm_changeCamo, PlayerCamoType.FOXTROT)
				e.menu_addItem_action("bm_camo_woodland", e.bm_changeCamo, PlayerCamoType.WOODLAND)
				e.menu_addItem_action("bm_camo_wetwork", e.bm_changeCamo, PlayerCamoType.WETWORK)
				e.menu_addItem_action("bm_camo_realtree", e.bm_changeCamo, PlayerCamoType.REALTREE)
				e.menu_addItem_action("bm_camo_panther", e.bm_changeCamo, PlayerCamoType.PANTHER)
			elseif (e.menu_last_selected[2] == 2) then
				e.menu_addItem_action("bm_camo_ss_gz", e.bm_changeCamo, PlayerCamoType.SNEAKING_SUIT_GZ)
				e.menu_addItem_action("bm_camo_ss_gz_bb", e.bm_changeCamoBB)
				e.menu_addItem_action("bm_camo_ss_tpp", e.bm_changeCamo, PlayerCamoType.SNEAKING_SUIT_TPP)
				e.menu_addItem_action("bm_camo_battledress", e.bm_changeCamo, PlayerCamoType.BATTLEDRESS)
				e.menu_addItem_action("bm_camo_parasite", e.bm_changeCamo, PlayerCamoType.PARASITE)
				e.menu_addItem_action("bm_camo_leather", e.bm_changeCamo, PlayerCamoType.LEATHER)
				e.menu_addItem_action("bm_camo_solid_snake", e.bm_changeCamo, PlayerCamoType.SOLIDSNAKE)
				e.menu_addItem_action("bm_camo_ninja", e.bm_changeCamo, PlayerCamoType.NINJA)
				e.menu_addItem_action("bm_camo_raiden", e.bm_changeCamo, PlayerCamoType.RAIDEN)
				
				if (vars.playerType == PlayerType.SNAKE or vars.playerType == PlayerType.AVATAR) then
					e.menu_addItem_action("bm_camo_gold", e.bm_changeCamo, PlayerCamoType.GOLD)
					e.menu_addItem_action("bm_camo_silver", e.bm_changeCamo, PlayerCamoType.SILVER)
				end
			elseif (e.menu_last_selected[2] == 3) then
				e.menu_addItem_action("bm_camo_woodland_fleck", e.bm_changeCamo, PlayerCamoType.C23)
				e.menu_addItem_action("bm_camo_ambush", e.bm_changeCamo, PlayerCamoType.C24)
				e.menu_addItem_action("bm_camo_solum", e.bm_changeCamo, PlayerCamoType.C27)
				e.menu_addItem_action("bm_camo_dead_leaf", e.bm_changeCamo, PlayerCamoType.C29)
				e.menu_addItem_action("bm_camo_lichen", e.bm_changeCamo, PlayerCamoType.C30)
				e.menu_addItem_action("bm_camo_stone", e.bm_changeCamo, PlayerCamoType.C35)
				e.menu_addItem_action("bm_camo_white", e.bm_changeCamo, PlayerCamoType.C38)
				e.menu_addItem_action("bm_camo_pink", e.bm_changeCamo, PlayerCamoType.C39)
				e.menu_addItem_action("bm_camo_red", e.bm_changeCamo, PlayerCamoType.C42)
				e.menu_addItem_action("bm_camo_blue", e.bm_changeCamo, PlayerCamoType.C46)
				e.menu_addItem_action("bm_camo_grey", e.bm_changeCamo, PlayerCamoType.C49)
				e.menu_addItem_action("bm_camo_tselinoyarsk", e.bm_changeCamo, PlayerCamoType.C52)
			elseif (e.menu_last_selected[2] == 4) then
				e.menu_addItem_action("bm_camo_mgs3", e.bm_changeCamo, PlayerCamoType.MGS3)
				e.menu_addItem_action("bm_camo_mgs3_naked", e.bm_changeCamo, PlayerCamoType.MGS3_NAKED)
				e.menu_addItem_action("bm_camo_mgs3_sneaking", e.bm_changeCamo, PlayerCamoType.MGS3_SNEAKING)
				e.menu_addItem_action("bm_camo_mgs3_tuxedo", e.bm_changeCamo, PlayerCamoType.MGS3_TUXEDO)
				e.menu_addItem_action("bm_camo_eva_close", e.bm_changeCamo, PlayerCamoType.EVA_CLOSE)
				e.menu_addItem_action("bm_camo_eva_open", e.bm_changeCamo, PlayerCamoType.EVA_OPEN)
				e.menu_addItem_action("bm_camo_boss_close", e.bm_changeCamo, PlayerCamoType.BOSS_CLOSE)
				e.menu_addItem_action("bm_camo_boss_open", e.bm_changeCamo, PlayerCamoType.BOSS_OPEN)
			end
		elseif (e.menu_last_selected[1] == 5) then
			if (e.menu_last_selected[2] == 1) then
				e.menu_title = "bm_time"
				e.menu_addItem("bm_time_group1")
				e.menu_addItem("bm_time_group2")
			elseif (e.menu_last_selected[2] == 2) then
				e.menu_title = "bm_timescale"
				e.menu_addItem_action("bm_timescale_up_10", e.bm_changeTimescale, 10)
				e.menu_addItem_action("bm_timescale_up_100", e.bm_changeTimescale, 100)
				e.menu_addItem_action("bm_timescale_down_10", e.bm_changeTimescale, -10)
				e.menu_addItem_action("bm_timescale_down_100", e.bm_changeTimescale, -100)	
				e.menu_addItem_action("bm_reset", e.bm_changeTimescale)
			end
		end
	elseif (e.menu_level == 4) then
		if (e.menu_last_selected[1] == 5) then
			if (e.menu_last_selected[2] == 1) then
				e.menu_title = "bm_time"

				if (e.menu_last_selected[3] == 1) then
					e.menu_addItem_action("bm_time_01", e.bm_changeTime, "01:00:00")
					e.menu_addItem_action("bm_time_02", e.bm_changeTime, "02:00:00")
					e.menu_addItem_action("bm_time_03", e.bm_changeTime, "03:00:00")
					e.menu_addItem_action("bm_time_04", e.bm_changeTime, "04:00:00")
					e.menu_addItem_action("bm_time_05", e.bm_changeTime, "05:00:00")
					e.menu_addItem_action("bm_time_06", e.bm_changeTime, "06:00:00")
					e.menu_addItem_action("bm_time_07", e.bm_changeTime, "07:00:00")
					e.menu_addItem_action("bm_time_08", e.bm_changeTime, "08:00:00")
					e.menu_addItem_action("bm_time_09", e.bm_changeTime, "09:00:00")
					e.menu_addItem_action("bm_time_10", e.bm_changeTime, "10:00:00")
					e.menu_addItem_action("bm_time_11", e.bm_changeTime, "11:00:00")
					e.menu_addItem_action("bm_time_12", e.bm_changeTime, "12:00:00")
				elseif (e.menu_last_selected[3] == 2) then
					e.menu_addItem_action("bm_time_13", e.bm_changeTime, "13:00:00")
					e.menu_addItem_action("bm_time_14", e.bm_changeTime, "14:00:00")
					e.menu_addItem_action("bm_time_15", e.bm_changeTime, "15:00:00")
					e.menu_addItem_action("bm_time_16", e.bm_changeTime, "16:00:00")
					e.menu_addItem_action("bm_time_17", e.bm_changeTime, "17:00:00")
					e.menu_addItem_action("bm_time_18", e.bm_changeTime, "18:00:00")
					e.menu_addItem_action("bm_time_19", e.bm_changeTime, "19:00:00")
					e.menu_addItem_action("bm_time_20", e.bm_changeTime, "20:00:00")
					e.menu_addItem_action("bm_time_21", e.bm_changeTime, "21:00:00")
					e.menu_addItem_action("bm_time_22", e.bm_changeTime, "22:00:00")
					e.menu_addItem_action("bm_time_23", e.bm_changeTime, "23:00:00")
					e.menu_addItem_action("bm_time_00", e.bm_changeTime, "00:00:00")
				end
			end
		end
	end
end

function e.menu_addItem(item)
	e.menu_count = e.menu_count + 1
	e.menu_items[e.menu_count] = item
end

function e.menu_addItem_action(item, func, param)
	e.menu_count = e.menu_count + 1
	e.menu_items[e.menu_count] = item
	e.menu_items_action[e.menu_count] = true
	e.menu_items_action_func[e.menu_count] = func
	e.menu_items_action_param[e.menu_count] = param
end

function e.menu_draw()
	local menu_item_highlight={}

	if not e.menu_item_highlighted then
		e.menu_item_highlighted = 1
	end

	for i,item in pairs(e.menu_items) do
		if (i == e.menu_item_highlighted) then
			table.insert(menu_item_highlight, "bm_item_highlight")
		else
			table.insert(menu_item_highlight, "bm_item_blank")
		end
	end

	TppUiCommand.SetStrongPrioTelopCast( true )
	TppUiCommand.RegistTelopCast("RightCenter", 9999, "bm_item_blank",
		menu_item_highlight[1],
		menu_item_highlight[2],
		menu_item_highlight[3],
		menu_item_highlight[4],
		menu_item_highlight[5],
		menu_item_highlight[6],
		0.8, 25.2
	)
	TppUiCommand.MoveTelopCast("RightCenter", 0, -100.5)
	TppUiCommand.RegistTelopCast("PageBreak",1)
	TppUiCommand.StartTelopCast()
	
	TppUiCommand.SetStrongPrioTelopCast( true )
	TppUiCommand.RegistTelopCast("RightUp", 9999, "bm_item_blank",
		menu_item_highlight[7],
		menu_item_highlight[8],
		menu_item_highlight[9],
		menu_item_highlight[10],
		menu_item_highlight[11],
		menu_item_highlight[12],
		0.8, -12.2
	)
	TppUiCommand.MoveTelopCast("RightUp", 0, -100.5)
	TppUiCommand.RegistTelopCast("PageBreak",1)
	TppUiCommand.StartTelopCast()

	TppUiCommand.SetStrongPrioTelopCast( false )
	TppUiCommand.RegistTelopCast("LeftUp", 9999, e.menu_title,
		e.menu_items[1],
		e.menu_items[2],
		e.menu_items[3],
		e.menu_items[4],
		e.menu_items[5],
		e.menu_items[6],
		0.8
	)
	TppUiCommand.RegistTelopCast("PageBreak",1)
	TppUiCommand.StartTelopCast()
	
	TppUiCommand.SetStrongPrioTelopCast( false )
	TppUiCommand.RegistTelopCast("LeftCenter", 9999, "bm_item_blank",
		e.menu_items[7],
		e.menu_items[8],
		e.menu_items[9],
		e.menu_items[10],
		e.menu_items[11],
		e.menu_items[12],
		0.8, 12.5
	)
	TppUiCommand.RegistTelopCast("PageBreak",1)
	TppUiCommand.StartTelopCast()
end

function e.menu_reset()
	e.menu_count = 0
	e.menu_items={"bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank"}
	e.menu_items_action={}
	e.menu_items_action_func={}
	e.menu_items_action_param={}
end

function e.GetButtonJustReleased(button)

	if (e.button_pressed[button] and bit.band(PlayerVars.scannedButtonsDirect,button)~=button and os.clock() - e.button_pressed_time[button] > 0.23) then
		e.button_pressed[button] = false
		--Player.RequestToSetTargetStance(PlayerStance.STAND)
		return true
	end

	if (bit.band(PlayerVars.scannedButtonsDirect,button)==button) then
		e.button_pressed[button] = true
		e.button_pressed_time[button] = os.clock()

		vars.playerDisableActionFlag=PlayerDisableAction.OPEN_EQUIP_MENU

		e.disable_equip_action = true
	end

	return false
end

function e.menu_shutdown()
	Player.ResetPadMask {
		settingName	= "bm_disableStance", 
	}
	TppUiCommand.StopTelopCast()
	TppUiCommand.AllResetTelopCast()
	e.menu_drawn = false
	e.menu_skip_frame = os.clock()
end

function e.Update()
	if e.disable_equip_action then
		vars.playerDisableActionFlag=PlayerDisableAction.NONE
		e.disable_equip_action = false
	end

	if (e.menu_open and not TppUiCommand.IsMbDvcTerminalOpened()) then
		if e.menu_not_holding_open then
			if (e.GetButtonJustReleased(PlayerPad.STANCE)) then
				if not e.menu_items_action[e.menu_item_highlighted] then
					e.menu_last_selected[e.menu_level] = e.menu_item_highlighted
					e.menu_level = e.menu_level + 1
					e.menu_item_highlighted = 1

					e.menu_shutdown()
				else
					e.menu_items_action_func[e.menu_item_highlighted](e.menu_items_action_param[e.menu_item_highlighted])
				end
			end

			if (e.GetButtonJustReleased(PlayerPad.RELOAD)) then
				if (e.menu_level ~= 1) then
					e.menu_level = e.menu_level - 1
					e.menu_item_highlighted = e.menu_last_selected[e.menu_level]

					e.menu_shutdown()
				else
					e.menu_shutdown()
					e.menu_open = false
				end
			end

			if (e.GetButtonJustReleased(PlayerPad.PRIMARY_WEAPON)) then
				if (e.menu_item_highlighted > 1) then
					e.menu_item_highlighted = e.menu_item_highlighted - 1
				else
					e.menu_item_highlighted = e.menu_count
				end

				TppUiCommand.EraseTelopCast("RightCenter")
				TppUiCommand.EraseTelopCast("RightUp")
				e.menu_drawn = false
			end

			if (e.GetButtonJustReleased(PlayerPad.DOWN)) then
				if (e.menu_item_highlighted < e.menu_count) then
					e.menu_item_highlighted = e.menu_item_highlighted + 1
				else
					e.menu_item_highlighted = 1
				end
				
				TppUiCommand.EraseTelopCast("RightCenter")
				TppUiCommand.EraseTelopCast("RightUp")
				e.menu_drawn = false
				
			end
		end

		if (not e.menu_drawn) then
			Player.SetPadMask {
				settingName	= "bm_disableStance",
				except		= false,
				buttons		= PlayerPad.STANCE + PlayerPad.PRIMARY_WEAPON + PlayerPad.SECONDARY_WEAPON,
			}

			if (e.menu_skip_frame > 0) then
				if (os.clock() - e.menu_skip_frame > 0.30) then
					e.menu_reset()

					e.menu_set()
					e.menu_draw()

					e.menu_drawn = true
					e.menu_skip_frame = 0
				end
			else
				e.menu_reset()

				e.menu_set()
				e.menu_draw()

				e.menu_drawn = true
			end
		end
		
		if (bit.band(PlayerVars.scannedButtonsDirect,PlayerPad.RELOAD)~=PlayerPad.RELOAD and bit.band(PlayerVars.scannedButtonsDirect,PlayerPad.PRIMARY_WEAPON)~=PlayerPad.PRIMARY_WEAPON) then
			e.menu_not_holding_open = true
		end
	end

	if (bit.band(PlayerVars.scannedButtonsDirect,PlayerPad.RELOAD)==PlayerPad.RELOAD) then

		if (Time.GetRawElapsedTimeSinceStartUp() - e.menu_hold_pressed > 2) and not(e.menu_unload_hold_pressed) then

			e.menu_hold_pressed = Time.GetRawElapsedTimeSinceStartUp()
			e.menu_unload_hold_pressed = true

			if (bit.band(PlayerVars.scannedButtonsDirect,PlayerPad.PRIMARY_WEAPON)==PlayerPad.PRIMARY_WEAPON) then
				e.menu_shutdown()
				e.menu_open = not e.menu_open
				e.menu_not_holding_open = false
			end
		end
	else
		e.menu_unload_hold_pressed = false
		e.menu_hold_pressed = Time.GetRawElapsedTimeSinceStartUp()
	end

end
function e.OnTerminate()end
return e