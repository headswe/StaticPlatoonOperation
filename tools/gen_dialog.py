#!/usr/bin/env python3
"""Generates ui/missionDialog.hpp from tools/missionDialog.template.hpp.

Usage: python3 tools/gen_dialog.py tools/missionDialog.template.hpp > ui/missionDialog.hpp
Positions are fractions of the safe zone."""
import sys

def X(v): return f'"{v:.4f} * safezoneW + safezoneX"'
def Y(v): return f'"{v:.4f} * safezoneH + safezoneY"'
def W(v): return f'"{v:.4f} * safezoneW"'
def H(v): return f'"{v:.4f} * safezoneH"'

out = []
def ctrl(name, base, idc, x, y, w, h, **props):
    out.append(f"\t\tclass {name}: {base}\n\t\t{{")
    out.append(f"\t\t\tidc = {idc};")
    out.append(f"\t\t\tx = {X(x)};\n\t\t\ty = {Y(y)};\n\t\t\tw = {W(w)};\n\t\t\th = {H(h)};")
    for k, v in props.items():
        k = k.replace("__", "[]")
        out.append(f"\t\t\t{k} = {v};")
    out.append("\t\t};")

L, T, R, B = 0.15, 0.12, 0.85, 0.88   # dialog bounds
HEADER_B, FOOTER_T = 0.185, 0.83
C1, C2, C3 = 0.16, 0.38, 0.60          # column lefts
CW1, CW2, CW3 = 0.21, 0.21, 0.24       # column widths
LBL, ROW = 0.022, 0.026                # label / input heights

def call(case): return f"\"['{case}', _this] call spo_fnc_missionSettingsDialog\""

# background
bg = []
out.append("\tclass ControlsBackground\n\t{")
ctrl("spoBody", "spo_RscBack", -1, L, HEADER_B, R - L, FOOTER_T - HEADER_B, colorBackground__="SPO_COL_BODY")
ctrl("spoHeader", "spo_RscBack", -1, L, T, R - L, HEADER_B - T, colorBackground__="SPO_COL_DARK")
ctrl("spoHeaderStripe", "spo_RscBack", -1, L, T, 0.004, HEADER_B - T, colorBackground__="SPO_COL_ACCENT")
ctrl("spoHeaderLine", "spo_RscBack", -1, L, HEADER_B - 0.002, R - L, 0.002, colorBackground__="SPO_COL_ACCENT")
ctrl("spoFooter", "spo_RscBack", -1, L, FOOTER_T, R - L, B - FOOTER_T, colorBackground__="SPO_COL_DARK")
# preview backdrops
PV_Y, PV_H, PV_W = 0.256, 0.34, 0.1025
ctrl("spoPreviewBackBlu", "spo_RscBack", -1, C2, PV_Y, PV_W, PV_H, colorBackground__="SPO_COL_DARK")
ctrl("spoPreviewBackOp", "spo_RscBack", -1, C2 + PV_W + 0.005, PV_Y, PV_W, PV_H, colorBackground__="SPO_COL_DARK")
out.append("\t};")

out.append("\tclass Controls\n\t{")
# header
ctrl("spoTitle", "spo_RscTitle", -1, L + 0.012, T + 0.004, 0.4, 0.038, text='"STATIC PLATOON OPS"')
ctrl("spoSubtitle", "spo_RscLabel", -1, L + 0.013, T + 0.039, 0.3, LBL, text='"MISSION SETUP"')
ctrl("spoStatus", "spo_RscText", 1002, R - 0.36, T + 0.02, 0.35, 0.03, style=1, text='""')

# column 1: factions
def faction_block(name, label, y, list_idc, edit_idc, list_h):
    ctrl(f"{name}Label", "spo_RscLabel", -1, C1, y, CW1, LBL, text=f'"{label}"')
    ctrl(f"{name}Search", "spo_RscEdit", edit_idc, C1, y + LBL + 0.002, CW1, ROW,
         tooltip='"Type to filter by name or category"', onKeyUp=call("filter"))
    ctrl(f"{name}List", "spo_RscListBox", list_idc, C1, y + LBL + ROW + 0.006, CW1, list_h,
         onLBSelChanged=call("select"))
    return y + LBL + ROW + 0.006 + list_h + 0.01

y = HEADER_B + 0.008
y = faction_block("playerFaction", "PLAYER FACTION", y, 2100, 2110, 0.15)
y = faction_block("enemyFaction", "ENEMY FACTION", y, 2101, 2111, 0.15)
vy = y
y = faction_block("vehicleFaction", "ENEMY VEHICLES FROM FACTION", y, 2102, 2112, FOOTER_T - 0.01 - (y + LBL + ROW + 0.006))
# config scan progress, shown over the vehicle list until the server has read CfgVehicles
scan_y = vy + LBL + ROW + 0.03
ctrl("scanText", "spo_RscText", 1003, C1, scan_y, CW1, 0.03, style=2, text='"Reading vehicle configs..."')
ctrl("scanBar", "spo_RscProgress", 1004, C1 + 0.02, scan_y + 0.035, CW1 - 0.04, 0.012)

# column 2: loadout preview and vehicle types
y = HEADER_B + 0.008
ctrl("previewLabel", "spo_RscLabel", -1, C2, y, CW2, LBL, text='"LOADOUT PREVIEW"')
ctrl("previewRole", "spo_RscCombo", 2007, C2, y + LBL + 0.002, CW2, ROW, onLBSelChanged=call("role"))
ctrl("previewBlu", "spo_RscPicture", 1200, C2, PV_Y, PV_W, PV_H,
     text='"#(argb,512,1024,1)r2t(spo_rtt_blu,0.5)"')
ctrl("previewOp", "spo_RscPicture", 1201, C2 + PV_W + 0.005, PV_Y, PV_W, PV_H,
     text='"#(argb,512,1024,1)r2t(spo_rtt_op,0.5)"')
cy = PV_Y + PV_H + 0.004
ctrl("previewBluSide", "spo_RscLabel", -1, C2, cy, PV_W, LBL, style=2, text='"FRIENDLY"', colorText__="SPO_COL_BLU")
ctrl("previewOpSide", "spo_RscLabel", -1, C2 + PV_W + 0.005, cy, PV_W, LBL, style=2, text='"ENEMY"', colorText__="SPO_COL_OP")
ctrl("previewBluName", "spo_RscSmall", 1210, C2, cy + LBL, PV_W, LBL, style=2, text='""')
ctrl("previewOpName", "spo_RscSmall", 1211, C2 + PV_W + 0.005, cy + LBL, PV_W, LBL, style=2, text='""')

y = cy + 2 * LBL + 0.02
ctrl("vehicleTypesLabel", "spo_RscLabel", -1, C2, y, CW2, LBL, text='"ENEMY VEHICLE TYPES"')
y += LBL + 0.004
boxes = [("Cars", 2201, "Cars and trucks"), ("Apcs", 2202, "APCs and IFVs"),
         ("Tanks", 2203, "Tanks and tracked AA"), ("Helis", 2204, "Armed helicopters")]
for i, (name, idc, label) in enumerate(boxes):
    bx = C2 + (i % 2) * (CW2 / 2)
    by = y + (i // 2) * 0.032
    ctrl(f"vehicle{name}Box", "spo_RscCheckBox", idc, bx, by, 0.014, ROW)
    ctrl(f"vehicle{name}Text", "spo_RscText", -1, bx + 0.016, by, CW2 / 2 - 0.018, ROW, text=f'"{label}"')
y += 2 * 0.032
ctrl("vehicleTypesHint", "spo_RscSmall", -1, C2, y, CW2, LBL, text='"Unticked types never spawn."')

# column 3: objective map and mission options
y = HEADER_B + 0.008
ctrl("mapLabel", "spo_RscLabel", -1, C3, y, CW3, LBL, text='"OBJECTIVE - CLICK THE MAP TO PLACE IT"')
ctrl("aoMAP", "RscMapControl", 1801, C3, y + LBL + 0.002, CW3, 0.25, onMouseButtonClick=call("mapClick"))
y += LBL + 0.002 + 0.25 + 0.01

def combo(name, label, idc, y, **props):
    ctrl(f"{name}Label", "spo_RscLabel", -1, C3, y, CW3, LBL, text=f'"{label}"')
    ctrl(f"{name}Combo", "spo_RscCombo", idc, C3, y + LBL + 0.002, CW3, ROW, **props)
    return y + LBL + ROW + 0.012

y = combo("mission", "MISSION TYPE", 2004, y)
ctrl("ratioLabel", "spo_RscLabel", -1, C3, y, CW3, LBL, text='"ENEMY STRENGTH (AI PER PLAYER)"')
ctrl("ratioSlider", "spo_RscSlider", 1900, C3, y + LBL + 0.002, CW3 - 0.08, ROW, onSliderPosChanged=call("ratio"))
ctrl("ratioValue", "spo_RscText", 1901, C3 + CW3 - 0.078, y + LBL + 0.002, 0.078, ROW, style=1, text='""')
y += LBL + ROW + 0.012
y = combo("time", "TIME OF DAY", 2005, y)
y = combo("weather", "WEATHER", 2006, y)

# footer
ctrl("footerHint", "spo_RscSmall", -1, L + 0.012, FOOTER_T + 0.014, 0.4, 0.025,
     text='"Esc closes without changes. Settings are locked once the mission starts."')
ctrl("cancelButton", "spo_RscButton", 1601, R - 0.205, FOOTER_T + 0.01, 0.085, 0.032, text='"CANCEL"',
     onButtonClick='"closeDialog 2"')
ctrl("goButton", "spo_RscButtonAccent", 1600, R - 0.11, FOOTER_T + 0.01, 0.1, 0.032, text='"LAUNCH"',
     onButtonClick=call("done"))
out.append("\t};")

body = "\n".join(out)
sys.stdout.write(open(sys.argv[1]).read().replace("//@CONTROLS@", body))
