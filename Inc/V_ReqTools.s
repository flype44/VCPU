************************************************************
*	
*	REQTOOLS FUNCTIONS
*	
************************************************************
*	
*	XDEF 
*	XDEF 
*	
************************************************************

	CNOP 0,4

ReqAboutTags:
	DC.L RT_Window,0
	DC.L RT_LockWindow,1
	DC.L RT_Underscore,'_'
	DC.L RT_ReqPos,REQPOS_CENTERSCR
	DC.L RTEZ_DefaultResponse,1
	DC.L RTEZ_Flags,EZREQF_CENTERTEXT
	DC.L RTEZ_ReqTitle,ReqAboutTitle
	DC.L TAG_DONE

ReqAboutTitle:
	DC.B "About",0

ReqAboutBody:
	DC.B "%s %s (%s)",10,10
	DC.B "%s",10
	DC.B "Written by %s",10,10
	DC.B "%s",10,10
	DC.B "Copyright %s",10,10
	DC.B "Enjoy your Vampire :)",0

ReqAboutGads:
	DC.B "_Okay",0

************************************************************

	CNOP 0,4

ReqSDSelectTags:
	DC.L RT_Window,0
	DC.L RT_LockWindow,1
	DC.L RT_Underscore,'_'
	DC.L RT_ReqPos,REQPOS_CENTERSCR
	DC.L RTGL_Min,0
	DC.L RTGL_Max,255
	DC.L RTGL_TextFmt,ReqSDSelectText
	DC.L TAG_DONE

ReqSDAcceptTags:
	DC.L RT_Window,0
	DC.L RT_LockWindow,1
	DC.L RT_Underscore,'_'
	DC.L RT_ReqPos,REQPOS_CENTERSCR
	DC.L RTEZ_DefaultResponse,1
	DC.L RTEZ_ReqTitle,ReqSDTitle
	DC.L TAG_DONE

ReqSDTitle:
	DC.B "MicroSD Speed",0

ReqSDSelectText:
	DC.B "To modify the speed of the MicroSD port,",10
	DC.B "Enter a new value for the SDClockDivider.",10,10
	DC.B "The lowest value (0), the fastest.",10
	DC.B "The highest value (255), the slowest.",10,10

ReqSDAcceptBody:
	DC.B "WARNING:",10
	DC.B "A value of '0' may NOT work on your media !",10
	DC.B "Always test with read operations before you",10
	DC.B "start write any data to your SDCard media.",10,10
	DC.B "No warranty is provided,",10
	DC.B "use this feature at your own risk.",0

ReqSDAcceptGads:
	DC.B "_Accept|_Cancel",0

************************************************************

	CNOP 0,4

ReqFPUTags:
	DC.L RT_Window,0
	DC.L RT_LockWindow,1
	DC.L RT_Underscore,'_'
	DC.L RT_ReqPos,REQPOS_CENTERSCR
	DC.L RTEZ_DefaultResponse,1
	DC.L RTEZ_ReqTitle,ReqFPUTitle
	DC.L RTEZ_Flags,EZREQF_CENTERTEXT
	DC.L TAG_DONE

ReqFPUTitle:
	DC.B "Request",0

ReqFPUBody:
	DC.B "In order to %s the Floating-Point Unit,",10
	DC.B "AmigaOS Exec needs to be fully reinitialized.",10,10
	DC.B "Please wait until all disk activity has ended !",0

ReqFPUGads:
	DC.B "_Reboot|_Cancel",0

************************************************************

	CNOP 0,4

ReqSNTags:
	DC.L RT_Window,0
	DC.L RT_LockWindow,1
	DC.L RT_Underscore,'_'
	DC.L RT_ReqPos,REQPOS_CENTERSCR
	DC.L RTEZ_DefaultResponse,1
	DC.L RTEZ_Flags,EZREQF_CENTERTEXT
	DC.L RTEZ_ReqTitle,ReqSNTitle
	DC.L TAG_DONE

ReqSNBuffer:
	DC.B "0000000000000000-0",0

ReqSNTitle:
	DC.B "Hardware information",0

ReqSNBody:
	DC.B "Serial-Number of your Vampire",10,10,"0x%s",0

ReqSNGads:
	DC.B "_Okay|_Copy to clipboard",0

************************************************************

	CNOP 0,4

ReqPaletteTags:
	DC.L RT_Window,0
	DC.L RT_LockWindow,1
	DC.L RT_Underscore,'_'
	DC.L RT_ReqPos,REQPOS_CENTERSCR
	DC.L RTPA_Color,1
	DC.L TAG_DONE

************************************************************

