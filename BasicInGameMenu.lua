local e={}
e.menu_level = 1
e.menu_last_selected={}
e.button_pressed={}
e.button_pressed_time={}
e.menu_skip_frame = 0
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
	vars.playerPartsType=PlayerPartsType.NORMAL
	vars.playerFaceEquipId=0
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

function e.menu_set()
	e.menu_title = "bm_main_title"

	if (e.menu_level == 1) then
		e.menu_addItem("bm_playertype")
		e.menu_addItem("bm_playerface")
		e.menu_addItem("bm_camo")
		e.menu_addItem("bm_weather")
		e.menu_addItem("bm_timescale")
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
			e.menu_addItem_action("bm_camo_olivedrab", e.bm_changeCamo, PlayerCamoType.OLIVEDRAB)
			e.menu_addItem_action("bm_camo_splitter", e.bm_changeCamo, PlayerCamoType.SPLITTER)
			e.menu_addItem_action("bm_camo_square", e.bm_changeCamo, PlayerCamoType.SQUARE)
			e.menu_addItem_action("bm_camo_tigerstripe", e.bm_changeCamo, PlayerCamoType.TIGERSTRIPE)
			e.menu_addItem_action("bm_camo_goldtiger", e.bm_changeCamo, PlayerCamoType.GOLDTIGER)
			e.menu_addItem("bm_next")
		elseif (e.menu_last_selected[1] == 4) then
			e.menu_title = "bm_weather"
			e.menu_addItem_action("bm_weather_sunny", e.bm_changeWeather)
			e.menu_addItem_action("bm_weather_cloudy", e.bm_changeWeather)
			e.menu_addItem_action("bm_weather_rainy", e.bm_changeWeather)
			e.menu_addItem_action("bm_weather_sandstorm", e.bm_changeWeather)
			e.menu_addItem_action("bm_weather_foggy", e.bm_changeWeather)
			e.menu_addItem_action("bm_reset", e.bm_changeWeather)
		elseif (e.menu_last_selected[1] == 5) then
			e.menu_title = "bm_timescale"
			e.menu_addItem_action("bm_timescale_up_10", e.bm_changeTimescale, 10)
			e.menu_addItem_action("bm_timescale_up_100", e.bm_changeTimescale, 100)
			e.menu_addItem_action("bm_timescale_down_10", e.bm_changeTimescale, -10)
			e.menu_addItem_action("bm_timescale_down_100", e.bm_changeTimescale, -100)	
			e.menu_addItem_action("bm_reset", e.bm_changeTimescale)
		end
	elseif (e.menu_level == 3) then
		if (e.menu_last_selected[1] == 3 and e.menu_last_selected[2] == 6) then
			e.menu_title = "bm_camo"
			e.menu_addItem_action("bm_camo_foxtrot", e.bm_changeCamo, PlayerCamoType.FOXTROT)
			e.menu_addItem_action("bm_camo_woodland", e.bm_changeCamo, PlayerCamoType.WOODLAND)
			e.menu_addItem_action("bm_camo_wetwork", e.bm_changeCamo, PlayerCamoType.WETWORK)
			e.menu_addItem_action("bm_camo_ss_gz", e.bm_changeCamo, PlayerCamoType.SNEAKING_SUIT_GZ)
			e.menu_addItem_action("bm_camo_ss_tpp", e.bm_changeCamo, PlayerCamoType.SNEAKING_SUIT_TPP)
			e.menu_addItem("bm_next")
		end
	elseif (e.menu_level == 4) then
		if (e.menu_last_selected[1] == 3 and e.menu_last_selected[2] == 6) then
			e.menu_title = "bm_camo"
			e.menu_addItem_action("bm_camo_battledress", e.bm_changeCamo, PlayerCamoType.BATTLEDRESS)
			e.menu_addItem_action("bm_camo_parasite", e.bm_changeCamo, PlayerCamoType.PARASITE)
			e.menu_addItem_action("bm_camo_leather", e.bm_changeCamo, PlayerCamoType.LEATHER)
			e.menu_addItem_action("bm_camo_solid_snake", e.bm_changeCamo, PlayerCamoType.SOLIDSNAKE)
			e.menu_addItem_action("bm_camo_ninja", e.bm_changeCamo, PlayerCamoType.NINJA)
			e.menu_addItem("bm_next")
		end
	elseif (e.menu_level == 5) then
		if (e.menu_last_selected[1] == 3 and e.menu_last_selected[2] == 6) then
			e.menu_title = "bm_camo"
			e.menu_addItem_action("bm_camo_raiden", e.bm_changeCamo, PlayerCamoType.RAIDEN)
			e.menu_addItem_action("bm_camo_realtree", e.bm_changeCamo, PlayerCamoType.REALTREE)
			e.menu_addItem_action("bm_camo_panther", e.bm_changeCamo, PlayerCamoType.PANTHER)
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
	TppUiCommand.RegistTelopCast("LeftCenter", 9999, "bm_item_blank",
		menu_item_highlight[1],
		menu_item_highlight[2],
		menu_item_highlight[3],
		menu_item_highlight[4],
		menu_item_highlight[5],
		menu_item_highlight[6],
		0.8, 25.2
	)
	TppUiCommand.MoveTelopCast("LeftCenter", 0, -1.4)
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
end

function e.menu_reset()
	e.menu_count = 0
	e.menu_items={"bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank", "bm_item_blank"}
	e.menu_items_action={}
	e.menu_items_action_func={}
	e.menu_items_action_param={}
end

function e.GetButtonJustReleased(button)

	if (e.button_pressed[button] and bit.band(PlayerVars.scannedButtonsDirect,button)~=button and os.clock() - e.button_pressed_time[button] > 0.23) then
		e.button_pressed[button] = false
		return true
	end

	if (bit.band(PlayerVars.scannedButtonsDirect,button)==button) then
		e.button_pressed[button] = true
		e.button_pressed_time[button] = os.clock()

		vars.playerDisableActionFlag=PlayerDisableAction.OPEN_EQUIP_MENU

		--Player.RequestToSetTargetStance(PlayerStance.STAND)
		
		Player.SetPadMask {
			settingName	= "bm_disableStance",
			except		= false,
			buttons		= PlayerPad.STANCE + PlayerPad.PRIMARY_WEAPON + PlayerPad.SECONDARY_WEAPON,
		}

		e.disable_equip_action = true
	end

	return false
end

function e.menu_shutdown()
	TppUiCommand.StopTelopCast()
	TppUiCommand.AllResetTelopCast()
	e.menu_drawn = false
	e.menu_skip_frame = os.clock()
end

function e.Update()
	if e.disable_equip_action then
		vars.playerDisableActionFlag=PlayerDisableAction.NONE
		Player.ResetPadMask {
			settingName	= "bm_disableStance", 
		}
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

				TppUiCommand.EraseTelopCast("LeftCenter")
				e.menu_drawn = false
			end

			if (e.GetButtonJustReleased(PlayerPad.DOWN)) then
				if (e.menu_item_highlighted < e.menu_count) then
					e.menu_item_highlighted = e.menu_item_highlighted + 1
				else
					e.menu_item_highlighted = 1
				end
				
				TppUiCommand.EraseTelopCast("LeftCenter")
				e.menu_drawn = false
				
			end
		end

		if (not e.menu_drawn) then
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

		if (Time.GetRawElapsedTimeSinceStartUp() - e.hold_pressed > 2) then

			e.hold_pressed = Time.GetRawElapsedTimeSinceStartUp()

			if (bit.band(PlayerVars.scannedButtonsDirect,PlayerPad.PRIMARY_WEAPON)==PlayerPad.PRIMARY_WEAPON) then
				e.menu_shutdown()
				e.menu_open = not e.menu_open
				e.menu_not_holding_open = false
			end
		end
	else
		e.hold_pressed = Time.GetRawElapsedTimeSinceStartUp()
	end

end
function e.OnTerminate()end
return e