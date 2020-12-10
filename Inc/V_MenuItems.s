************************************************************
*	
*	MENUITEMS FUNCTIONS
*	
************************************************************
*	
*	XDEF 
*	XDEF 
*	XDEF 
*	
************************************************************

	CNOP 0,4

MyNewMenu:
	MENUITEM NM_TITLE,StrMenu1
	MENUITEM  NM_ITEM,StrMenu1A,StrMenu1A_,MenuItem_Help
	MENUITEM  NM_ITEM,StrMenu1B,StrMenu1B_,MenuItem_Iconify
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu1C,StrMenu1C_,MenuItem_About
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu1D,StrMenu1D_,MenuItem_Quit
	MENUITEM NM_TITLE,StrMenu2
	MENUITEM  NM_ITEM,StrMenu2A
	MENUITEM   NM_SUB,StrMenu2A1,0,MenuItem_FPUSwitch
	MENUITEM   NM_SUB,StrMenu2A2,0,MenuItem_FPUSwitch
	MENUITEM  NM_ITEM,StrMenu2B
	MENUITEM   NM_SUB,StrMenu2B1,0,MenuItem_SuperScalar
	MENUITEM   NM_SUB,StrMenu2B2,0,MenuItem_SuperScalar
	MENUITEM  NM_ITEM,StrMenu2C
	MENUITEM   NM_SUB,StrMenu2C1,0,MenuItem_TurtleMode
	MENUITEM   NM_SUB,StrMenu2C2,0,MenuItem_TurtleMode
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu2D
	MENUITEM   NM_SUB,StrMenu2D1,0,MenuItem_FastIDE
	MENUITEM   NM_SUB,StrMenu2D2,0,MenuItem_FastIDE
	MENUITEM   NM_SUB,StrMenu2D3,0,MenuItem_FastIDE
	MENUITEM   NM_SUB,StrMenu2D4,0,MenuItem_FastIDE
	MENUITEM  NM_ITEM,StrMenu2E
	MENUITEM   NM_SUB,StrMenu2E1,0,MenuItem_SDClockDivider
	MENUITEM   NM_SUB,StrMenu2E2,0,MenuItem_SDClockDivider
	MENUITEM   NM_SUB,StrMenu2E3,0,MenuItem_SDClockDivider
	MENUITEM   NM_SUB,StrMenu2E4,0,MenuItem_SDClockDivider
	MENUITEM   NM_SUB,NM_BARLABEL
	MENUITEM   NM_SUB,StrMenu2E5,0,MenuItem_SDClockDivider
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu2F,0,MenuItem_SerialNumber
	MENUITEM NM_TITLE,StrMenu3
	MENUITEM  NM_ITEM,StrMenu3A
	MENUITEM   NM_SUB,StrMenu3A1,0,MenuItem_Setting_RefreshRate
	MENUITEM   NM_SUB,StrMenu3A2,0,MenuItem_Setting_RefreshRate
	MENUITEM   NM_SUB,StrMenu3A3,0,MenuItem_Setting_RefreshRate
	MENUITEM   NM_SUB,StrMenu3A4,0,MenuItem_Setting_RefreshRate
	MENUITEM   NM_SUB,StrMenu3A5,0,MenuItem_Setting_RefreshRate
	MENUITEM   NM_SUB,StrMenu3A6,0,MenuItem_Setting_RefreshRate
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu3B
	MENUITEM   NM_SUB,StrMenu3B1,0,MenuItem_Setting_Backdrop
	MENUITEM   NM_SUB,StrMenu3B2,0,MenuItem_Setting_Backdrop
	MENUITEM  NM_ITEM,StrMenu3C
	MENUITEM   NM_SUB,StrMenu3C1,0,MenuItem_Setting_Borderless
	MENUITEM   NM_SUB,StrMenu3C2,0,MenuItem_Setting_Borderless
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu3D
	MENUITEM   NM_SUB,StrMenu3D1,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D2,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D3,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D4,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D5,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D6,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D7,0,MenuItem_Setting_Skin
	MENUITEM   NM_SUB,StrMenu3D8,0,MenuItem_Setting_Skin
	MENUITEM  NM_ITEM,NM_BARLABEL
	MENUITEM  NM_ITEM,StrMenu3E,0,MenuItem_Setting_ForeColor
	MENUITEM  NM_ITEM,StrMenu3F,0,MenuItem_Setting_BackColor
	MENUITEM NM_END,0

************************************************************

	CNOP 0,4

StrMenu1:         DC.B "Project",0
StrMenu1A:        DC.B "Help...",0
StrMenu1A_:       DC.B "H",0
StrMenu1B:        DC.B "Iconify",0
StrMenu1B_:       DC.B "I",0
StrMenu1C:        DC.B "About...",0
StrMenu1C_:       DC.B "?",0
StrMenu1D:        DC.B "Quit",0
StrMenu1D_:       DC.B "Q",0

StrMenu2:         DC.B "Edit",0
StrMenu2A:        DC.B "FPU switch",0
StrMenu2A1:       DC.B "0: Disable",0
StrMenu2A2:       DC.B "1: Enable",0
StrMenu2B:        DC.B "SuperScalar",0
StrMenu2B1:       DC.B "0: Disable",0
StrMenu2B2:       DC.B "1: Enable",0
StrMenu2C:        DC.B "Turtle mode",0
StrMenu2C1:       DC.B "0: Disable",0
StrMenu2C2:       DC.B "1: Enable",0
StrMenu2D:        DC.B "FastIDE speed",0
StrMenu2D1:       DC.B "0: Slow",0
StrMenu2D2:       DC.B "1: Fast",0
StrMenu2D3:       DC.B "2: Faster",0
StrMenu2D4:       DC.B "3: Fastest",0
StrMenu2E:        DC.B "MicroSD speed",0
StrMenu2E1:       DC.B "0: Fastest",0
StrMenu2E2:       DC.B "1: Faster",0
StrMenu2E3:       DC.B "2: Slow",0
StrMenu2E4:       DC.B "3: Slower",0
StrMenu2E5:       DC.B "Set Divider value...",0
StrMenu2F:        DC.B "Get Serial-Number...",0

StrMenu3:         DC.B "Settings",0
StrMenu3A:        DC.B "Refresh rate",0
StrMenu3A1:       DC.B "Hz / (2^0) (slowest)",0
StrMenu3A2:       DC.B "Hz / (2^1)",0
StrMenu3A3:       DC.B "Hz / (2^2)",0
StrMenu3A4:       DC.B "Hz / (2^3)",0
StrMenu3A5:       DC.B "Hz / (2^4)",0
StrMenu3A6:       DC.B "Hz / (2^5) (fastest)",0
StrMenu3B:        DC.B "Backdrop",0
StrMenu3B1:       DC.B "0: Disable",0
StrMenu3B2:       DC.B "1: Enable",0
StrMenu3C:        DC.B "Borderless",0
StrMenu3C1:       DC.B "0: Disable",0
StrMenu3C2:       DC.B "1: Enable",0
StrMenu3D:        DC.B "Skin...",0
StrMenu3D1:       DC.B "Skin Black",0
StrMenu3D2:       DC.B "Skin Blue",0
StrMenu3D3:       DC.B "Skin Orange",0
StrMenu3D4:       DC.B "Skin Red",0
StrMenu3D5:       DC.B "Skin Grey dark",0
StrMenu3D6:       DC.B "Skin Grey light",0
StrMenu3D7:       DC.B "Skin White",0
StrMenu3D8:       DC.B "Skin Yellow",0
StrMenu3E:        DC.B "Foreground Color...",0
StrMenu3F:        DC.B "Background Color...",0

************************************************************

	CNOP 0,4




