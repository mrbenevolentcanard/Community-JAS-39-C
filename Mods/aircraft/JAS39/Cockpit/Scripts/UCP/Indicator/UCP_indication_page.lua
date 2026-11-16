dofile(LockOn_Options.script_path .. "MFD/Indicator/MFD_def.lua")

UCP_BASE                = CreateElement "ceSimple"
UCP_BASE.name           = create_guid_string()
UCP_BASE.element_params = {"Electric_Main_bus_A_115200VAC"}
UCP_BASE.controllers    = {{"parameter_compare_with_number", 0, 1}}
AddElement(UCP_BASE)

GlowEffect                 = CreateElement "ceMeshPoly"
GlowEffect.name            = create_guid_string()
GlowEffect.primitivetype   = "triangles"
GlowEffect.vertices        = {{-1.0, 1.5}, {1.0, 1.5}, {1.0, -1.5}, {-1.0, -1.5}}
GlowEffect.indices         = {0, 1, 2, 0, 2, 3}
GlowEffect.init_pos        = {0, 0, 0}
GlowEffect.material        = MakeMaterial(nil, {0, 255, 0, 4}) -- RGBA
GlowEffect.parent_element  = UCP_BASE.name
GlowEffect.h_clip_relation = h_clip_relations.REWRITE_LEVEL
GlowEffect.level           = UCP_DEFAULT_LEVEL
-- GlowEffect.change_opacity	= false
-- GlowEffect.collimated 		= false
GlowEffect.isvisible       = true
Add(GlowEffect)



local RowMargin = -0.5

for i = -6, -1 do
	local j = math.abs(i)

	text_param_with_opacity(-1, 1.6 - RowMargin * i, "UCP_BRIGHTNESS", "UCPRow" .. j, "%0.23s", UCP_BASE, ucp_strdefs_digit, "Gripen_Font_UCP", "LeftLeft")
end

local lightW = .85 / 2
local lightH = .4 / 2

local RDRCover           = CreateElement "ceMeshPoly"
RDRCover.name            = create_guid_string()
RDRCover.primitivetype   = "triangles"
RDRCover.vertices        = {{-lightW, lightH}, {lightW, lightH}, {lightW, -lightH}, {-lightW, -lightH}}
RDRCover.indices         = {0, 1, 2, 0, 2, 3}
RDRCover.init_pos        = {-3.665, -1.95, .03}
RDRCover.material        = MakeMaterial(nil, {0, 0, 0, 255})
RDRCover.parent_element  = UCP_BASE.name
RDRCover.h_clip_relation = h_clip_relations.REWRITE_LEVEL
RDRCover.level           = UCP_DEFAULT_LEVEL
RDRCover.isvisible       = true
RDRCover.element_params  = {"RADAR_MODE"}
RDRCover.controllers     = {{"parameter_compare_with_number", 0, 0}}
Add(RDRCover)