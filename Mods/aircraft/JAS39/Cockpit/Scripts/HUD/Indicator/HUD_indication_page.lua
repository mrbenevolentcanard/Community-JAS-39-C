-- TODO:
-- Make the Moving_Sides move smoother than FPM, sagging behind
addHUDSimple("Moving_Sides", nil, nil, "HUD_Base", nil, nil, {"HUDSidesX", "HUDSidesY"}, {{ctrl.moveX, 0, mult}, {ctrl.moveY, 1, mult}})


local leftSideX = -d2Mr(7.767) -- Distance from the Flight_Path_Vector/center to the right most element (ex: landing speed) of the speed tape column
local leftSideWidth = d2Mr(2.75)
local leftSideHeight = d2Mr(8.5)

addHUDBox( -- TODO: Make this clip out from the HUD Sphere
	"Left_Side", {leftSideX - leftSideWidth / 2}, nil, "Moving_Sides", nil, nil, {"HUDDeclutt"}, {{ctrl.compareNum, 0, 0}}, leftSideWidth,
	leftSideHeight, materials.HUDMask, true
)

addHUDText("AoA_@", {-17, 65}, "Left_Side", nil, nil, nil, nil, "@", nil, HUDStrdefs.alpha)
addHUDTextParam("AoA_Readout", {20, -1}, "AoA_@", nil, nil, nil, nil, "AoA", align.RC) -- {"-%2.2f"}

addHUDText("G_G", {-17, 50}, "Left_Side", nil, nil, nil, nil, "G")
addHUDTextParam(
	"G_Readout", {12}, "G_G", nil, nil, nil, nil, "CUR_G", align.LC,
	{"%.1f"}
)


local speedTapeHeight = d2Mr(5)
local speedTapeWidth = d2Mr(.7)

addHUDBox(
	"Speed_Tape_Mask", {leftSideWidth / 2 - speedTapeWidth / 2}, nil, "Left_Side", hcr.inc, HUDLvls.mask, nil, nil, speedTapeWidth,
	speedTapeHeight, materials.HUDMask2, true
)

addHUDSimpleLine(
	"Speed_Tape_Arrow", {-1}, nil, "Speed_Tape_Mask", nil, HUDLvls.mask, nil, nil, nil,
	{{-speedTapeWidth / 2, 3.25}, {0}, {-speedTapeWidth / 2, -3.25}}
)

addHUDSimpleLine(
	"Speed_Tape_Accelerate_Ind", {-speedTapeWidth / 2 + .25, 2.75}, nil, "Speed_Tape_Mask", nil, HUDLvls.mask, {"ONE", "ACC"},
	{{ctrl.inRange, 1, 0, 999}, {ctrl.setPoint, 1, 0, 1, 0, .0001203}}, nil, nil
)
addHUDSimpleLine(
	"Speed_Tape_Decelerate_Ind", {-speedTapeWidth / 2 + .25, -2.75}, nil, "Speed_Tape_Mask", nil, HUDLvls.mask, {"ONE", "DEACC"},
	{{ctrl.inRange, 1, 0, 999}, {ctrl.setPoint, 1, 0, 1, 0, -.0001203}}, nil, nil
)


addHUDSimple("Speed_Tape_Line_Base", nil, nil, "Speed_Tape_Mask", nil, nil, {"CAS"}, {{ctrl.moveY, 0, -.0001203}})

local speedTapeUpperLine = addHUDSimpleLine(
	nil, nil, nil, "Speed_Tape_Line_Base", nil, HUDLvls.mask, {"transonicUpper"},
	{{ctrl.moveY, 0, .0001203}}, nil, {{0, -.5}, {0, 200}}
)
addHUDSimpleLine(
	"Speed_Tape_Lower_Mask", nil, nil, "Speed_Tape_Line_Base", hcr.incIf, HUDLvls.mask, nil, nil,
	.6, {{0, -.5}, {0, -999}}, materials.HUDMask3, true
)
copyElement(speedTapeUpperLine, {"element_params", "vertices"}, {{"transonicLower", "HUDBrightness"}, {{0, -200}, {0}}})


for i = 0, 28, 1 do
	addHUDSimpleLine(
		"Speed_Tape_Mark_" .. i, {0, i * 10}, nil, "Speed_Tape_Line_Base", nil, HUDLvls.mask, nil, nil, nil,
		{{0}, {-speedTapeWidth / 4}}
	)
end

-- addHUDSimpleLine(
-- "Speed_Tape_Min_Speed", {0, -44.84}, nil, "Speed_Tape_Line_Base", hcr.decIf, HUDLvls.mask, nil, nil, .46,
-- {{0, 0}, {2.3, 0}, {4.6, 0}, {4.6, 4.6}}
-- )
-- addHUDSimpleLine(
-- "Speed_Tape_L_Speed", {0, -64.9}, nil, "Speed_Tape_Line_Base", hcr.decIf, HUDLvls.mask, {"ROTATE_SPEED"}, {{ctrl.moveY, 1, .0001203}},
-- .46, {{0, 0}, {2.3, 0}, {4.6, 0}, {4.6, 4.6}}
-- )


addHUDTextParam("CAS_Readout", {-(speedTapeWidth / 2 + 2.5)}, "Speed_Tape_Mask", nil, nil, nil, nil, "textCAS", align.RC)

addHUDText(
	"AT_Ind", {2, 10}, "CAS_Readout", nil, nil, {"AUTOTHROTTLE_ONOFF"},
	{{ctrl.inRange, 0, .9, 1.1}}, "AT  ", align.RC
)
local AT12 = addHUDText(
	nil, {-2}, "AT_Ind", nil, nil, {"AUTOTHROTTLE_MODE"},
	{{ctrl.inRange, 0, .4, .6}}, "  12", align.RC
)
copyElement(AT12, {"controllers", "value"}, {{{ctrl.inRange, 0, .8, 1.1}}, "  14"})


addHUDText("Mach_M", {-17, -53}, "Left_Side", nil, nil, {"machDecimals"}, {{ctrl.inRange, 0, 1, 999}}, "M")
addHUDTextParam(
	"Mach_Whole_Readout", {5.14}, "Mach_M", nil, nil, {"machWhole"}, {{ctrl.inRange, 0, .995, 9}}, "machWhole",
	align.LC, {"%.2f"}
)
addHUDText("Mach_Comma", {13.07}, "Mach_M", nil, nil, {"machDecimals"}, {{ctrl.inRange, 0, 1, 99.5}}, ".")
addHUDTextParam("Mach_Dec_Readout", {3}, "Mach_Comma", nil, nil, nil, nil, "machDecimals", align.LC, {"%.0f"})

addHUDText(
	"GS_GS", {-17, -64}, "Left_Side", nil, nil, {"weaponsMode", "CURRENT_PHASE"}, {{ctrl.compareNum, 0, -1}, {ctrl.inRange, 1, 6.9, 8.9}},
	"GS"
)
addHUDTextParam("GS_Readout", {30.5}, "GS_GS", nil, nil, nil, nil, "txtGS", align.RC)



-- TODO Altitude Scale:
-- (Add runway altitude box for future functionality.)
-- (If a runway is selected - show altitude readout under 10 000 ft, 100 ft resolution? (check panda vid))
-- (Make the altitude scale work with negative numbers (works until like -75 ft, good enough for now))
-- 77 should dissapear if ralt is over 30k ft, not if baro is over 30k ft.
-- Check mask width

local rightSideX = d2Mr(7.767) -- Distance from the Flight_Path_Vector/center to the right most element (ex: landing speed) of the speed scale column
local rightSideWidth = d2Mr(2.75)

addHUDSimple("Right_Side", {rightSideX + rightSideWidth / 2}, nil, "Moving_Sides", nil, nil, {"HUDRightSideX"}, {{ctrl.moveX, 0, mult}})


local altitudeScaleHeight = d2Mr(5)
local altitudeScaleWidth = rightSideWidth
local altitudeScaleMult = -altitudeScaleHeight * .0006

addHUDSimple(
	"Altitude_Scale_Base", {altitudeScaleWidth / 2 - rightSideWidth / 2}, nil, "Right_Side", nil, nil, {"altitudeDeclutt"},
	{{ctrl.compareNum, 0, 0}}
)

addHUDSimpleLine(
	"Alt_Scale_Mask_Big", nil, nil, "Altitude_Scale_Base", hcr.inc, HUDLvls.mask, {"HUDAltMaskTop", "HUDAltMaskBottom", "ONE"},
	{{ctrl.setPoint, 0, 2, 0, 0, -altitudeScaleMult}, {ctrl.setPoint, 1, 2, 1, 0, -altitudeScaleMult}}, altitudeScaleWidth / 2 + 2.5, nil, materials.HUDMask,
	true
)

addHUDSimpleLine(
	"Alt_Scale_Mask_Small", nil, nil, "Altitude_Scale_Base", hcr.inc, HUDLvls.mask2, nil, nil, altitudeScaleWidth / 2,
	{{0, -altitudeScaleHeight / 2}, {0, altitudeScaleHeight * .575}}, materials.HUDMask2, true
)

addHUDSimpleLine(
	"Alt_Scale_Arrow", {-18.5}, nil, "Alt_Scale_Mask_Small", nil, HUDLvls.mask2, nil, nil, nil,
	{{-speedTapeWidth / 2, 3.25}, {0}, {-speedTapeWidth / 2, -3.25}}
)
addHUDSimple("Alt_Scale_Readout_Base", {-8}, nil, "Alt_Scale_Arrow", nil, nil, {"HUDAltReadoutAvail"}, {{ctrl.compareNum, 0, 1}})
addHUDTextParam(
	"Alt_Scale_Readout_Low", nil, "Alt_Scale_Readout_Base", nil, nil, {"HUDAltReadout"}, {{ctrl.inRange, 0, -1000, 1000}},
	"HUDAltReadout", align.RC
)
addHUDTextParam(
	"Alt_Scale_Readout_High_Thousands", {-13.5}, "Alt_Scale_Readout_Base", nil, nil, {"HUDAltReadoutThousands"}, {{ctrl.inRange, 0, -100, 100}},
	"HUDAltReadoutThousands", align.RC
)
addHUDTextParam(
	"Alt_Scale_Readout_High_Hundreds", {0, -1.6}, "Alt_Scale_Readout_High_Thousands", nil, nil, nil, nil,
	"HUDAltReadoutHundreds", align.LC, {"%s"}, HUDStrdefs.hundreds
)
addHUDSimpleLine(
	"Alt_Scale_Readout_Box", {1}, nil, "Alt_Scale_Readout_Base", hcr.inc, nil, {"HUDAltReadout"}, {{ctrl.inRange, 0, -9999, 0}},
	nil, {{-36, -6}, {-36, 6}, {0, 6}, {0, -6}, {-36, -6}}
)

for i = 1, 2 do
	local zeroAltLine = addHUDSimpleLine(
		nil, {-17}, nil, "Alt_Scale_Mask_Small", nil, i == 1 and HUDLvls.mask2 or HUDLvls.mask, {"zeroAltLine"},
		{{ctrl.moveY, 0, -altitudeScaleMult}}, nil, {{0}, {6.5}}
	)
	addHUDBox(
		"Alt_Scale_Zero_Altitude_Vertical_Line", nil, nil, zeroAltLine, nil, i == 1 and HUDLvls.mask2 or HUDLvls.mask, nil, nil, 1,
		5
	)
	addHUDText("Alt_Scale_Zero_Text", {8}, zeroAltLine, nil, i == 1 and HUDLvls.mask2 or HUDLvls.mask, nil, nil, "0", align.LC)



	addHUDText(
		"Alt_Scale_Terrain_Height", {-20.8, -3.1}, "Alt_Scale_Mask_Small", nil, i == 1 and HUDLvls.mask2 or HUDLvls.mask, {"HUD77Avail", "HUD77Y"},
		{{ctrl.compareNum, 0, 1}, {ctrl.moveY, 1, -altitudeScaleMult}}, "77", nil, HUDStrdefs.seventyseven
	)
end

for i = 1, 9 do
	addHUDSimple(
		"Alt_Scale_Line_" .. i .. "_Base", {-17}, nil, "Alt_Scale_Mask_Small", nil, nil, {"HUDAltLineY_" .. i},
		{{ctrl.moveY, 0, -altitudeScaleMult}}
	)

	addHUDSimpleLine(
		"Alt_Scale_Line_" .. i .. "_Long", nil, nil, "Alt_Scale_Line_" .. i .. "_Base", nil, HUDLvls.mask2, {"HUDAltLineIsShort_" .. i},
		{{ctrl.compareNum, 0, 0}}, nil, {{0}, {6.5}}
	)
	addHUDSimpleLine(
		"Alt_Scale_Line_" .. i .. "_Short", nil, nil, "Alt_Scale_Line_" .. i .. "_Base", nil, HUDLvls.mask2, {"HUDAltLineIsShort_" .. i},
		{{ctrl.compareNum, 0, 1}}, nil, {{0}, {6.5 / 2}}
	)

	addHUDTextParam(
		"Alt_Scale_" .. i .. "_Text_Thousands_L", {21}, "Alt_Scale_Line_" .. i .. "_Base", nil, HUDLvls.mask2, {"HUDAltLineTextKAvail_" .. i},
		{{ctrl.compareNum, 0, 1}}, "HUDAltLineTextKL_" .. i, align.RC
	)
	addHUDTextParam(
		"Alt_Scale_" .. i .. "_Text_Thousands_S", {-32.5, -1.6}, "Alt_Scale_" .. i .. "_Text_Thousands_L", nil, HUDLvls.mask2, nil, nil,
		"HUDAltLineTextKS_" .. i, align.LC, {"%s"}, HUDStrdefs.hundreds
	)

	addHUDTextParam(
		"Alt_Scale_" .. i .. "_Text_Hundreds", {8.5}, "Alt_Scale_Line_" .. i .. "_Base", nil, HUDLvls.mask2, {"HUDAltLineTextHAvail_" .. i},
		{{ctrl.compareNum, 0, 1}}, "HUDAltLineTextH_" .. i, align.LC
	)
end

addHUDText(
	"Alt_Scale_RA_Ind", {-9, -11.25}, "Alt_Scale_Mask_Small", nil, HUDLvls.mask, {"altMode", "altRIndY"},
	{{ctrl.compareNum, 0, 2}, {ctrl.moveY, 1, -altitudeScaleMult}}, "R", align.LC
)


addHUDSimple("Declutt_Altitude_Base", {0, 7}, nil, "Right_Side", nil, nil, {"altitudeDeclutt"}, {{ctrl.compareNum, 0, 1}})
addHUDText("D_Alt_A", nil, "Declutt_Altitude_Base", nil, nil, {"altMode"}, {{ctrl.compareNum, 0, 1}}, "A")
addHUDText("D_Alt_RA", nil, "Declutt_Altitude_Base", nil, nil, {"altMode"}, {{ctrl.compareNum, 0, 2}}, "RA")
addHUDSimple("D_Alt_Readout_Base", {11, -12}, nil, "Declutt_Altitude_Base", nil, nil, {"HUDAltReadoutAvail"}, {{ctrl.compareNum, 0, 1}})
addHUDTextParam(
	"D_Alt_Readout_Low", nil, "D_Alt_Readout_Base", nil, nil, {"HUDAltReadout"}, {{ctrl.inRange, 0, -1000, 1000}},
	"HUDAltReadout", align.RC
)
addHUDTextParam(
	"D_Alt_Readout_High_Thousands", {-16}, "D_Alt_Readout_Base", nil, nil, {"HUDAltReadoutThousands"}, {{ctrl.inRange, 0, -100, 100}},
	"HUDAltReadoutThousands", align.RC
)
addHUDTextParam(
	"D_Alt_Readout_High_Hundreds", {0, -1.6}, "D_Alt_Readout_High_Thousands", nil, nil, nil, nil,
	"HUDAltReadoutHundreds", align.LC, nil, HUDStrdefs.hundreds
)
addHUDText( -- Such a bad way to fix it, but hey, it works.
	"D_Alt_Readout_High_Hundreds000", nil, "D_Alt_Readout_High_Hundreds", nil, nil, {"HUDAltReadoutHundreds"}, {{ctrl.compareNum, 0, 0}},
	"000", align.LC, HUDStrdefs.hundreds
)



-- TODO:
-- Check if vert lines are the correct size
-- Lift up the lines so the arrow touches the bottom of them.
local headingTapeWidth = d2Mr(5.5) / 2
local headingScaleMaskHeight = (d2Mr(1.175) + speedTapeWidth / 2) / 2

addHUDSimple(
	"Heading_Scale_Base", {0, d2Mr(6) - headingScaleMaskHeight}, nil, "Moving_Sides", nil, nil, {"aimingMode"},
	{{ctrl.compareNum, 0, 0}}
)

addHUDMeshPoly(
	"Hdg_Scale_Mask", {0, -speedTapeWidth / 4}, nil, "Heading_Scale_Base", hcr.inc, HUDLvls.mask, nil,
	nil, {{-headingTapeWidth, -headingScaleMaskHeight}, {headingTapeWidth, -headingScaleMaskHeight}, {headingTapeWidth, headingScaleMaskHeight}, {-headingTapeWidth, headingScaleMaskHeight}},
	{0, 1, 2, 0, 2, 3}, materials.HUDMask, true
)

addHUDSimple("Hdg_Scale_Moving_Base", nil, nil, "Heading_Scale_Base", nil, nil, {"HEADING"}, {{ctrl.moveX, 0, -.00193735}})

local headingLineSpacing = math.rad(.925) * 1000
local headinglineThickness = .46

for i = -4, 76 do -- make 4 extra lines on each side of north, north is 0. 34 <18> 02
	local j
	local hdgLineHeight

	if i < 0 then
		j = 36 + (i / 2)
	elseif i > 70 then
		j = (i - 72) / 2
	else
		j = i / 2
	end

	if j < 10 then
		j = "0" .. j
	end

	if i % 2 == 0 then
		hdgLineHeight = math.rad(.25) * 1000

		addHUDText("Hdg_Digit_" .. j, {headingLineSpacing * i, 5}, "Hdg_Scale_Moving_Base", nil, HUDLvls.mask, nil, nil, j)
	else
		hdgLineHeight = math.rad(.125) * 1000
	end


	addHUDMeshPoly(
		"Hdg_Line_" .. j, {headingLineSpacing * i, -10}, nil, "Hdg_Scale_Moving_Base", nil, HUDLvls.mask, nil, nil,
		{{-headinglineThickness, hdgLineHeight}, {headinglineThickness, hdgLineHeight}, {headinglineThickness, 0}, {-headinglineThickness, 0}}, {0, 1, 2, 0, 2, 3}
	)
end

addHUDSimpleLine(
	"Hdg_Scale_Arrow", {0, -headingScaleMaskHeight + speedTapeWidth / 2}, nil, "Heading_Scale_Base", nil, HUDLvls.mask, nil, nil, nil,
	{{-3.25, -speedTapeWidth / 2}, {0}, {3.25, -speedTapeWidth / 2}}
)

addHUDSimple(
	"Hdg_Scale_POI_Base", {0, (-headingScaleMaskHeight + speedTapeWidth / 2) - (speedTapeWidth / 2) * 1.5}, nil, "Hdg_Scale_Moving_Base", nil, nil,
	{"CURRENT_PHASE", "nextWPHeadingClampedHUD"}, {{ctrl.inRange, 0, 6.9, 8.9}, {ctrl.moveX, 1, .00193735}}
)

for i = -1, 1 do
	local firstVert = {0, ((speedTapeWidth / 2) + (speedTapeWidth / 2) / 2.5) / 2.5} -- I don't wanna talk about it...

	if i == 0 then
		firstVert = {0, (speedTapeWidth / 2) + (speedTapeWidth / 2) / 2.5}
	end

	addHUDSimpleLine(
		"Hdg_Scale_POI_Line_" .. i, {i * (6.5 / 3 + .75)}, nil, "Hdg_Scale_POI_Base", nil, HUDLvls.mask, nil, nil, nil,
		{firstVert, {0}}
	)
end


addHUDText("Hdg_Mode_T", {headingTapeWidth + 8, 5}, "Heading_Scale_Base", nil, nil, {"headingMode"}, {{ctrl.compareNum, 0, 1}}, "T")
addHUDText("Hdg_Mode_M", {-headingTapeWidth - 8, 5}, "Heading_Scale_Base", nil, nil, {"headingMode"}, {{ctrl.compareNum, 0, 2}}, "M")



addHUDSimple("Flight_Path_Vector", nil, nil, "HUD_Base", nil, nil, {"FPMHUDY", "FPMHUDX"}, {{ctrl.moveY, 0, mult}, {ctrl.moveX, 1, mult}})
-- TODO: 
-- Make the code for the wings nicer.
addHUDMeshPoly(
	"FPM_Horizontal_Wings_Unlimited", nil, nil, "Flight_Path_Vector", nil, nil, {"CURRENT_PHASE", "FPMLimited", "aimingMode"},
	{{ctrl.inRange, 0, 5.9, 9.9}, {ctrl.compareNum, 1, 0}, {ctrl.compareNum, 2, 0}},
	{{-19, -.5}, {-5.4, -.5}, {-19, .5}, {-5.4, .5},
		{19,  -.5}, {5.4, -.5}, {19, .5}, {5.4, .5}},
	{0, 1, 2, 3, 2, 1,
		4, 5, 6, 7, 6, 5}
)
addHUDCircle("FPM_Circle", nil, nil, "FPM_Horizontal_Wings_Unlimited", nil, nil, nil, nil, 5.5, 4.5, 360, 25)
addHUDSimpleLine(
	"FPM_Vertical_Fin", {0, -16.8}, nil, "Flight_Path_Vector", nil, nil, {"velvecY", "velvecBlink", "aimingMode", "FPMUpLim"},
	{{ctrl.moveY, 0, 14.3 * .001}, {ctrl.inRange, 1, -.1, .5}, {ctrl.compareNum, 2, 0}, {ctrl.compareNum, 3, 0}}, nil, {{0, 4.075}, {0, 14.075}}
)

addHUDMeshPoly(
	"FPM_Horizontal_Lines_Limited", nil, nil, "Flight_Path_Vector", nil, nil, {"FPMLimited", "aimingMode"},
	{{ctrl.compareNum, 0, 1}, {ctrl.compareNum, 1, 0}},
	{{-19, -.5}, {-8, -.5}, {-19, .5}, {-8, .5},
		{19,  -.5}, {8, -.5}, {19, .5}, {8, .5}},
	{0, 1, 2, 3, 2, 1,
		4, 5, 6, 7, 6, 5}
)
addHUDTextParam(
	"FPM_Limited_AoA_Readout", nil, "FPM_Horizontal_Lines_Limited", nil, nil, {"CURRENT_PHASE"}, {{ctrl.inRange, 0, 6.9, 8.9}},
	"AoA"
)


addHUDCircle(
	"Aiming_Circle_Middle", nil, nil, "Flight_Path_Vector", nil, nil, {"aimingMode"}, {{ctrl.inRange, 0, .9, 9.1}}, .5,
	0, 360, 8
)

for i = 0, 360, 30 do
	local radius = 35
	local angle = math.rad(i + 90)

	-- TODO:
	-- Make the circle change radius if aiming mode is whatever that aiming mode is for the gun.
	addHUDCircle(
		"AC_Dot_" .. i, {radius * math.cos(angle), radius * math.sin(angle)}, nil, "Aiming_Circle_Middle", nil, nil, nil, nil,
		.5, 0, 360, 8
	)

	if i == 90 then
		addHUDSimpleLine("AC_Left_Line", nil, nil, "AC_Dot_" .. i, nil, nil, nil, nil, nil, {{0}, {-9.5}})
	elseif i == 270 then
		addHUDSimpleLine("AC_Right_Line", nil, nil, "AC_Dot_" .. i, nil, nil, nil, nil, nil, {{0}, {9.5}})
	end
end

local startAngle = math.rad(180)
addHUDSimpleLine("AC_Min_Range", {35 * math.cos(startAngle), 35 * math.sin(startAngle)}, {-90}, "Aiming_Circle_Middle", nil, nil, nil, nil, nil, {{0, -1}, {0, -4.8}, {2.5, -4.8}})

-- HUD_Aiming_Circle_Range_R = add_text_hud("R", 40, 0, "Text_Bar", "Gripen_Font_green", HUD_Normal_Size)
-- HUD_Aiming_Circle_Range_R.element_params = {"HUDBrightness", "RADAR_STT_RANGE_NM"}
-- HUD_Aiming_Circle_Range_R.controllers    = {{ctrl.opacity,0}, {ctrl.inRange,1, 0, 999}}
-- HUD_Aiming_Circle_Range                = add_text_hud_param(45, 0, "HUDBrightness", "RADAR_STT_RANGE_NM", "%.1f", "Text_Bar", HUD_Normal_Size, "Gripen_Font_green", "LeftCenter")
-- HUD_Aiming_Circle_Range.element_params = {"HUDBrightness", "RADAR_STT_RANGE_NM"}
-- HUD_Aiming_Circle_Range.controllers    = {{ctrl.opacity,0}, {ctrl.inRange,1, 0, 999}, {ctrl.text,1}}
--[[
local aimingCircleLeftGunLine = addHUDSimpleLine(
	nil, nil, nil, aimingCircle, nil, nil, {"weaponsMode", "rollRad"},
	{{ctrl.compareNum, 0, 3}, {ctrl.rotate, 1, 1}}, nil, {{-17.5, -7}, {-17.5, 7}}
)
copyElement(aimingCircleLeftGunLine, {"vertices"}, {{{17.5, -7}, {17.5, 7}}})
copyElement(
	aimingCircleLeftGunLine, {"parent_element", "element_params", "controllers"}, {"HUD_Base", {"HUDBrightness", "weaponsMode", "WS_GUN_PIPER_AZIMUTH", "WS_GUN_PIPER_ELEVATION", "FPMHUDY", "FPMHUDX"},
		{{ctrl.opacity, 0}, {ctrl.compareNum, 1, 3}, {ctrl.setPoint, 0, 5, 4, mult, mult}, {ctrl.setPoint, 1, 2, 3, mult, mult}}}
)



get_param_handle("RADAR_STT_RANGE_CARROT_RANGE"):set(.6)
for i = 0, 999, 1 do
	addHUDCircle(nil, nil, {90, 180}, aimingCircle, nil, nil, {"RADAR_STT_RANGE_CARROT_RANGE"}, {{ctrl.inRange, 0, (i - 1) / 180, i / 180}}, 41 - 5, 39.1 - 5, i, 186)
end

addHUDSimple(
	"Aiming_Circle_Carret_Range", nil, {-90}, aimingCircle, nil, nil, {"RADAR_STT_RANGE_CARROT_RANGE"},
	{{ctrl.rotate, 0, math.rad(360) / 2}}
)
copyElement(
	aimingCircleMinRange, {"init_pos", "init_rot", "vertices"}, {
		{0}, {0},
		{
			{-2 + (35 * math.sin(math.rad(180))), 7 + (35 * math.cos(math.rad(180)))}, {0 + (35 * math.sin(math.rad(180))), 2.1 + (35 * math.cos(math.rad(180)))},
			{2 + (35 * math.sin(math.rad(180))),  7 + (35 * math.cos(math.rad(180)))}
		}
	}
)

local innerOuterRange = 163
local angleIORange = math.rad(180 + innerOuterRange)
copyElement(
	aimingCircleMinRange, {"init_pos", "init_rot", "vertices"}, {{35 * math.cos(angleIORange), 35 * math.sin(angleIORange)}, {-90 + innerOuterRange}, {
		{0, -1}, {0, -4.8}, {-2.5, -4.8}, {2.5, -4.8}
	}}
)

addHUDTextParam(
	nil, {0, -65}, aimingCircle, nil, nil, {"RADAR_STT_RANGE_NM"}, {{ctrl.inRange, 0, 0, 999}}, "RADAR_STT_RANGE_NM",
	nil, {"%.1f"}
)
addHUDText(nil, {25, -80}, aimingCircle, nil, nil, {"triggerSafe"}, {{ctrl.compareNum, 0, 0}}, "SAFE")

addHUDTextParam(
	nil, {-25, -80}, aimingCircle, nil, nil, {"selectedPylon"}, {{ctrl.inRange, 0, -.9, 10.9}}, "selectedPylonName",
	nil, {"%s"}
)
addHUDText(nil, {-10, -80}, aimingCircle, nil, nil, {"selectedPylon"}, {{ctrl.compareNum, 0, 11}}, "G   ", align.RC)
addHUDTextParam(nil, {-10, -80}, aimingCircle, nil, nil, {"selectedPylon"}, {{ctrl.compareNum, 0, 11}}, "ammoCount", align.RC)
--]]


local horizonGap = d2Mr(8) / 2 -- Half

local apAltBoxesW = d2Mr(.5) / 2 -- Half
local apAltBoxesH = d2Mr(1.5)

addHUDSimple("Autopilot_Altitude_Half_Boxes_Base", {0}, nil, "Flight_Path_Vector", nil, nil, {"rollRad"}, {{ctrl.rotate, 0, 1}})

for i = -1, 1, 2 do
	-- TODO:
	-- Have the horizon gap follow the FPM, not the X-AX
	addHUDSimpleLine(
		"Horizon_Line_" .. i, nil, nil, "HUD_Pitch", nil, nil, nil, nil,
		nil, {{999 * i}, {horizonGap * i}}
	)


	addHUDSimpleLine(
		"Ap_Alt_Half_Box_" .. i, {66 * i}, nil, "Autopilot_Altitude_Half_Boxes_Base", nil, nil, {"AutoPilotMode"}, {{ctrl.compareNum, 0, -2}},
		nil, {{0}, {apAltBoxesW * i}, {apAltBoxesW * i, -apAltBoxesH}, {0, -apAltBoxesH}}
	)
	addHUDSimpleLine(
		"Ap_Alt_Box_" .. i, {66 * i}, nil, "HUD_Pitch", nil, nil, {"AutoPilotMode"}, {{ctrl.compareNum, 0, 2}},
		nil, {{apAltBoxesW}, {-apAltBoxesW}, {-apAltBoxesW, -apAltBoxesH}, {apAltBoxesW, -apAltBoxesH}, {apAltBoxesW}}
	)


	-- TODO:
	-- Add dot in the middle of the glideslope 
	-- Make the glideslope follow the FPM, not X-AX
	-- Correct size relative to FPM size (make a var for horizontal size of FPM)
	addHUDSimpleLine(
		"Glide_Slope_Line" .. i, nil, nil, "HUD_Pitch", nil, nil, {"LANDING_MODE", "glideSlopeY"}, {{ctrl.compareNum, 0, 1}, {ctrl.moveY, 1, mult}},
		nil, {{90 * i}, {19.75 * i}}
	)
end


--[[ A relic from the old times :P

local HorizonLineHeadingDots                        = add_text_hud("!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!", 0, 0, HUD_PITCH , "Gripen_Font_green", HUD_HorizonLineHeading, "CenterCenter")
--lol
HorizonLineHeadingDots.init_pos                        = {0.03025, 0.0110,0.1}
HorizonLineHeadingDots.element_params        = {"HEADING_HUD"}
HorizonLineHeadingDots.controllers                = { {"move_left_right_using_parameter",0, -0.0110555}  }

--]]

addHUDText(
	"Horizon_Line_Dots", {5.67, 2.5}, "HUD_Pitch", nil, nil, {"HEADING"}, {{ctrl.moveX, 0, -.0104546}},
	"!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!,,,,!",
	-- lol
	nil, HUDStrdefs.headingLine
)













-- copyElement(
	-- aimingCircleLeftGunLine, {"parent_element", "element_params", "controllers", "vertices"}, {
		-- "HUD_Base",
		-- {"HUDBrightness", "RADAR_MODE", "RADAR_STT_ELEVATION", "RADAR_STT_AZIMUTH", "rollRad"}, {{ctrl.opacity, 0}, {ctrl.compareNum, 1, 3}, {ctrl.moveY, 2, mult}, {ctrl.moveX, 3, mult}, {ctrl.rotate, 4, 1}},
		-- {{-6, 2},         {-6, 8},      {6, 8},                {6, 2}}
	-- }
-- )

addHUDSimpleLine( -- TODO: Fix
	nil, nil, nil, "HUD_Base", hcr.rw, nil, {"rollRad", "WS_IR_MISSILE_TARGET_AZIMUTH", "WS_IR_MISSILE_TARGET_ELEVATION"},
	{{ctrl.rotate, 0, 0}, {ctrl.moveX, 1, mult}, {ctrl.moveY, 2, mult}}, nil, {{-5, 0}, {-3, -6.25}, {3, -6.25}, {5, 0}}
)
addHUDSimpleLine( -- TODO: Fix
	nil, nil, nil, "HUD_Base", hcr.rw, nil, {"rollRad", "WS_IR_MISSILE_TARGET_AZIMUTH", "WS_IR_MISSILE_TARGET_ELEVATION"},
	{{ctrl.rotate, 0, 0}, {ctrl.moveX, 1, mult}, {ctrl.moveY, 2, mult}}, nil, {{0, -5}, {0, 5}}
)



addHUDMeshPoly(
	"Trigger_X", {0, -57.5}, {45}, "Moving_Sides", nil, nil, {"trigger"}, {{ctrl.compareNum, 0, 1}},
	{{-.5, -110}, {.5, -110}, {-.5, 110}, {.5, 110}, {-110, -.5}, {-110, .5}, {110, -.5}, {110, .5}}, {0, 1, 2, 3, 2, 1, 4, 5, 6, 7, 6, 5}
)



addHUDMeshPoly(
	"Takeoff_Lines", nil, nil, "HUD_Pitch", nil, nil, {"CURRENT_PHASE_CO", "CURRENT_PHASE_PAL", "LANDING_MODE"},
	{{ctrl.compareNum, 0, 0}, {ctrl.compareNum, 1, 0}, {ctrl.compareNum, 2, 0}},
	{{-67.4, .5}, {-66, .5}, {-67.4, math.rad(4300)}, {-66, math.rad(4300)}, -- Left line.
		{67.4,  .5}, {66, .5}, {67.4, math.rad(4300)}, {66, math.rad(4300)}}, -- Right line.
	{0, 1, 2, 3, 2, 1,
		4, 5, 6, 7, 6, 5}
)











addHUDSimple(
	"Text_Bar", {0, -d2Mr(15) + 5}, nil, "HUD_Base", nil, nil, {"HUDTextBarState", "HUDTextBarUp"},
	{{ctrl.compareNum, 0, 1}, {ctrl.moveY, 1, .175}}
)

addHUDText("Landing_Mode_Ind", {-138}, "Text_Bar", nil, nil, {"LANDING_MODE"}, {{ctrl.compareNum, 0, 1}}, "L")

addHUDText("Radar_Guidance_Ind", {-20}, "Text_Bar", nil, nil, {"RADAR_MODE"}, {{ctrl.inRange, 0, .9, 3.1}}, "RDR")
addHUDText("Radar_Search_Ind", {25}, "Radar_Guidance_Ind", nil, nil, {"RADAR_MODE"}, {{ctrl.compareNum, 0, 1}}, "LP")
addHUDText("Radar_STT_Ind", {25}, "Radar_Guidance_Ind", nil, nil, {"RADAR_MODE"}, {{ctrl.inRange, 0, 1.9, 3.1}}, "ST")


addHUDTextParam(
	nil, {100}, "Text_Bar", nil, nil, {"selectedPylon"}, {{ctrl.inRange, 0, -.9, 10.9}}, "selectedPylonName",
	nil, {"%s"}
)
addHUDText(nil, {115}, "Text_Bar", nil, nil, {"selectedPylon"}, {{ctrl.compareNum, 0, 11}}, "G   ", align.RC)
addHUDTextParam(nil, {115}, "Text_Bar", nil, nil, {"selectedPylon"}, {{ctrl.compareNum, 0, 11}}, "ammoCount", align.RC)



addHUDSimple("Alt_Declutt_Base", {.33 * fov2MilRad, -.25 * fov2MilRad}, nil, "Moving_Sides", nil, nil, {"HUDDeclutt"}, {{ctrl.compareNum, 0, 1}})

addHUDText("Alt_Declutt_Alt", {0, -.1 * fov2MilRad}, "Alt_Declutt_Base", nil, nil, {"altMode"}, {{ctrl.compareNum, 0, 1}}, "ALT")
addHUDTextParam(
	"Alt_Declutt_Alt_Readout", {0, -.16 * fov2MilRad}, "Alt_Declutt_Base", nil, nil, {"altMode"}, {{ctrl.compareNum, 0, 1}},
	"TEXT_ALT"
)

addHUDText("Alt_Declutt_Ralt", {0, -.1 * fov2MilRad}, "Alt_Declutt_Base", nil, nil, {"altMode"}, {{ctrl.compareNum, 0, 2}}, "RALT")
addHUDTextParam(
	"Alt_Declutt_Ralt_Readout", {0, -.16 * fov2MilRad}, "Alt_Declutt_Base", nil, nil, {"altMode"}, {{ctrl.compareNum, 0, 2}},
	"TEXT_RALT"
)


addHUDTextParam("Declutted_CAS_Readout", {-.66 * fov2MilRad, -.16 * fov2MilRad}, "Alt_Declutt_Base", nil, nil, nil, nil, "textCAS")

addHUDText(
	"Declutted_AT_Ind", {-.7 * fov2MilRad, -.1 * fov2MilRad}, "Alt_Declutt_Base", nil, nil, {"AUTOTHROTTLE_ONOFF"},
	{{ctrl.inRange, 0, .9, 1.1}}, "AT"
)
addHUDText(
	"Declutted_AT_12_Ind", {-.63 * fov2MilRad, -.1 * fov2MilRad}, "Alt_Declutt_Base", nil, nil, {"AUTOTHROTTLE_MODE"},
	{{ctrl.inRange, 0, .4, .6}}, "12"
)
addHUDText(
	"Declutted_AT_12_Ind", {-.63 * fov2MilRad, -.1 * fov2MilRad}, "Alt_Declutt_Base", nil, nil, {"AUTOTHROTTLE_MODE"},
	{{ctrl.inRange, 0, .9, 1.1}}, "14"
)


addHUDTextParam(
	"Declutted_AoA_Readout", {-.724 * fov2MilRad, -1.255 * fov2MilRad}, "HUD_Base", nil, nil, {"HUDDeclutt"}, {{ctrl.compareNum, 0, 1}},
	"AoA"
)
addHUDText("Declutted_AoA_@", {-.81 * fov2MilRad, -1.255 * fov2MilRad}, "HUD_Base", nil, nil, {"HUDDeclutt"}, {{ctrl.compareNum, 0, 1}},
		   "@"
)

addHUDTextParam(
	"Declutted_G_Readout", {-.724 * fov2MilRad, -305.9}, "HUD_Base", nil, nil, {"HUDDeclutt"}, {{ctrl.compareNum, 0, 1}},
	"CUR_G", nil, {"%.1f"}
)
addHUDText("Declutted_G_G", {-.81 * fov2MilRad, -305.9}, "HUD_Base", nil, nil, {"HUDDeclutt"}, {{ctrl.compareNum, 0, 1}},
		   "G"
)



addHUDSimple(
	"GCW_Base", nil, nil, "FPM_Vertical_Fin", hcr.decIf, HUDLvls.mask, {"rollRad", "PULLUPQUE", "CURRENT_PHASE"},
	{{ctrl.rotate, 0, 1}, {ctrl.moveY, 1, -.0004}, {ctrl.inRange, 2, 5.9, 9.9}}
)
local GCWLeftGround = addHUDSimpleLine(
	nil, nil, nil, "GCW_Base", nil, nil, {"GROUNDSYMB"}, {{ctrl.compareNum, 0, 0}}, nil,
	{{-54, 4.2}, {-54, 0}, {-33.17, 0}}
)
copyElement(GCWLeftGround, {"vertices"}, {{{12.25, 0}, {-12.25, 0}}})
copyElement(GCWLeftGround, {"vertices"}, {{{54, 4.2}, {54, 0}, {33.17, 0}}})
local GCWLeftLeft = copyElement(
	GCWLeftGround, {"element_params", "controllers", "vertices"},
	{{"HUDBrightness", "GROUNDSYMB", "PULLUPQUE", "PULLMORE"}, {{ctrl.opacity, 0}, {ctrl.compareNum, 1, 0}, {ctrl.inRange, 2, -10000, 0}, {ctrl.inRange, 3, -.99, .5}}, {{54, 4.2}, {54, 0}, {33.17, 0}}}
)
copyElement(GCWLeftLeft, {"vertices"}, {{{-47, 40}, {-47, 4.2}, {-33.17, 4.2}}})
copyElement(GCWLeftLeft, {"vertices"}, {{{12.25, 4.2}, {-12.25, 4.2}}})
copyElement(GCWLeftLeft, {"vertices"}, {{{47, 40}, {47, 4.2}, {33.17, 4.2}}})
copyElement(GCWLeftLeft, {"vertices"}, {{{54, 40}, {54, 4.2}}})
local GCWLeftArrow = copyElement(
	GCWLeftLeft, {"init_pos", "element_params", "controllers", "vertices"},
	{
		{0,                 -2}, {"HUDBrightness", "GROUNDSYMB", "PULLUPQUE", "PULLMORE"},
		{{ctrl.opacity, 0}, {ctrl.compareNum, 1, 0}, {ctrl.inRange, 2, -10000, 0}, {ctrl.moveY, 2, -.00001}, {ctrl.inRange, 3, -.99, .5}}, {{-56, 35}, {-5.5, 50}, {-45, 35}, {-56, 35}}
	}
)
copyElement(GCWLeftArrow, {"vertices"}, {{{56, 35}, {5.5, 50}, {45, 35}, {56, 35}}})








dofile(LockOn_Options.script_path .. "HUD/Indicator/HUD_Sphere.lua")
-- TODO:
-- Fix sphere being always being aligned with magnetic heading even when true heading is selected