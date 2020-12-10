/**********************************************************
 ** 
 ** File:      SAGA.txt
 ** Descr:     Vampire Chipset registers
 ** Update:    November 2019
 ** Copyright: (C) APOLLO-Team 2016-2020
 ** 
 **********************************************************/

#define VREG_FASTIDE    0xDD1020	// UBYTE. -W. Gayle IDE Speed mode

#define VREG_SDDATA     0xDE0000	// UBYTE. RW. SD Card DATA (Read Write)
#define VREG_SDCTL      0xDE0004	// UWORD. -W. SD Card CTL  (Chip Select)
#define VREG_SDSTAT     0xDE0006	// UWORD. R-. SD Card STAT (Card Detect)
#define VREG_SDCLKDIV   0xDE000C	// UBYTE. -W. SD Card Clock Divider

#define VREG_SHADOW     0xDFE000	// UWORD. R-. Amiga Chipset DFF000 Shadow registers

#define VREG_SPRPOSX    0xDFF1D0	// UWORD. -W. Video Sprite Position X
#define VREG_SPRPOSY    0xDFF1D2	// UWORD. -W. Video Sprite Position Y

#define VREG_BPLMOD     0xDFF1E6	// UWORD. -W. Video Bitplane Modulo
#define VREG_BPLPTR     0xDFF1EC	// ULONG. -W. Video Bitplane Pointer
#define VREG_BPLFMT     0xDFF1F4	// UWORD. -W. Video Bitplane Format & Flags

#define VREG_SPIWRITE   0xDFF1F8	// UWORD. -W. V2 SPI Write (Video PLL, S/N, Flash)
#define VREG_SPIREAD    0xDFF1FA	// UWORD. R-. V2 SPI Read  (Video PLL, S/N, Flash)

#define VREG_VPOSR      0xDFF204	// ULONG. R-. Video Vertical Beam Position

#define VREG_DMACONR    0xDFF202	// UWORD. R-. DMA Control Read
#define VREG_INTENAR    0xDFF21C	// UWORD. R-. Interrupt Enable Bits Read
#define VREG_INTREQR    0xDFF21E	// UWORD. R-. Interrupt Request Bits Read

#define VREG_DMACON     0xDFF296	// UWORD. -W. DMA Control Write (Clear or Set)
#define VREG_INTENA     0xDFF29A	// UWORD. -W. Interrupt Enable Bits (Clear or Set)
#define VREG_INTREQ     0xDFF29C	// UWORD. -W. Interrupt Request Bits (Clear or Set)

#define VREG_AUD0PTR    0xDFF2A0	// ULONG. -W. Audio Channel 0 (4) Location
#define VREG_AUD0LEN    0xDFF2A4	// UWORD. -W. Audio Channel 0 (4) Length
#define VREG_AUD0PER    0xDFF2A6	// UWORD. -W. Audio Channel 0 (4) Period
#define VREG_AUD0VOL    0xDFF2A8	// UWORD. -W. Audio Channel 0 (4) Volume
#define VREG_AUD0DAT    0xDFF2AA	// UWORD. -W. Audio Channel 0 (4) Data

#define VREG_AUD1PTR    0xDFF2B0	// ULONG. -W. Audio Channel 1 (5) Location
#define VREG_AUD1LEN    0xDFF2B4	// UWORD. -W. Audio Channel 1 (5) Length
#define VREG_AUD1PER    0xDFF2B6	// UWORD. -W. Audio Channel 1 (5) Period
#define VREG_AUD1VOL    0xDFF2B8	// UWORD. -W. Audio Channel 1 (5) Volume
#define VREG_AUD1DAT    0xDFF2BA	// UWORD. -W. Audio Channel 1 (5) Data

#define VREG_AUD2PTR    0xDFF2C0	// ULONG. -W. Audio Channel 2 (6) Location
#define VREG_AUD2LEN    0xDFF2C4	// UWORD. -W. Audio Channel 2 (6) Length
#define VREG_AUD2PER    0xDFF2C6	// UWORD. -W. Audio Channel 2 (6) Period
#define VREG_AUD2VOL    0xDFF2C8	// UWORD. -W. Audio Channel 2 (6) Volume
#define VREG_AUD2DAT    0xDFF2CA	// UWORD. -W. Audio Channel 2 (6) Data

#define VREG_AUD3PTR    0xDFF2D0	// ULONG. -W. Audio Channel 3 (7) Location
#define VREG_AUD3LEN    0xDFF2D4	// UWORD. -W. Audio Channel 3 (7) Length
#define VREG_AUD3PER    0xDFF2D6	// UWORD. -W. Audio Channel 3 (7) Period
#define VREG_AUD3VOL    0xDFF2D8	// UWORD. -W. Audio Channel 3 (7) Volume
#define VREG_AUD3DAT    0xDFF2DA	// UWORD. -W. Audio Channel 3 (7) Data 

#define VREG_HPIXEL     0xDFF300	// UWORD. -W. Video Modeline Hor. Pixels
#define VREG_HSSTRT     0xDFF302	// UWORD. -W. Video Modeline Hor. Sync Start
#define VREG_HSSTOP     0xDFF304	// UWORD. -W. Video Modeline Hor. Sync Stop
#define VREG_HTOTAL     0xDFF306	// UWORD. -W. Video Modeline Hor. Total
#define VREG_VPIXEL     0xDFF308	// UWORD. -W. Video Modeline Ver. Pixels
#define VREG_VSSTRT     0xDFF30A	// UWORD. -W. Video Modeline Ver. Sync Start
#define VREG_VSSTOP     0xDFF30C	// UWORD. -W. Video Modeline Ver. Sync Stop
#define VREG_VTOTAL     0xDFF30E	// UWORD. -W. Video Modeline Ver. Total
#define VREG_HVSYNC     0xDFF310	// UWORD. -W. Video Modeline H/V. Sync

#define VREG_SPRCOLOR0  0xDFF3A2	// UWORD. -W. Video Sprite ARGB Color [0]
#define VREG_SPRCOLOR1  0xDFF3A4	// UWORD. -W. Video Sprite ARGB Color [1]
#define VREG_SPRCOLOR2  0xDFF3A6	// UWORD. -W. Video Sprite ARGB Color [2]

#define VREG_SNLO       0xDFF3F0	// ULONG. R-. V4 Serial-Number Low
#define VREG_SNHI       0xDFF3F4	// ULONG. R-. V4 Serial-Number High

#define VREG_PIXCLK     0xDFF3F8	// ULONG. -W. Video Pixel-Clock

#define VREG_BOARD      0xDFF3FC	// UWORD. R-. Board Model & Multiplier
#define VREG_MAPROM     0xDFF3FE	// UWORD. -W. MapROM Control

#define VREG_COLOR000   0xDFF400	// ULONG. -W. Video CLUT AARRGGBB Color [000]
#define VREG_COLOR001   0xDFF404	// ULONG. -W. Video CLUT AARRGGBB Color [001]
#define VREG_COLOR002   0xDFF408	// ULONG. -W. Video CLUT AARRGGBB Color [002]
#define VREG_COLOR003   0xDFF40C	// ULONG. -W. Video CLUT AARRGGBB Color [003]
#define VREG_COLOR004   0xDFF410	// ULONG. -W. Video CLUT AARRGGBB Color [004]
#define VREG_COLOR005   0xDFF414	// ULONG. -W. Video CLUT AARRGGBB Color [005]
#define VREG_COLOR006   0xDFF418	// ULONG. -W. Video CLUT AARRGGBB Color [006]
#define VREG_COLOR007   0xDFF41C	// ULONG. -W. Video CLUT AARRGGBB Color [007]
#define VREG_COLOR008   0xDFF420	// ULONG. -W. Video CLUT AARRGGBB Color [008]
#define VREG_COLOR009   0xDFF424	// ULONG. -W. Video CLUT AARRGGBB Color [009]
#define VREG_COLOR010   0xDFF428	// ULONG. -W. Video CLUT AARRGGBB Color [010]
#define VREG_COLOR011   0xDFF42C	// ULONG. -W. Video CLUT AARRGGBB Color [011]
#define VREG_COLOR012   0xDFF430	// ULONG. -W. Video CLUT AARRGGBB Color [012]
#define VREG_COLOR013   0xDFF434	// ULONG. -W. Video CLUT AARRGGBB Color [013]
#define VREG_COLOR014   0xDFF438	// ULONG. -W. Video CLUT AARRGGBB Color [014]
#define VREG_COLOR015   0xDFF43C	// ULONG. -W. Video CLUT AARRGGBB Color [015]
#define VREG_COLOR016   0xDFF440	// ULONG. -W. Video CLUT AARRGGBB Color [016]
#define VREG_COLOR017   0xDFF444	// ULONG. -W. Video CLUT AARRGGBB Color [017]
#define VREG_COLOR018   0xDFF448	// ULONG. -W. Video CLUT AARRGGBB Color [018]
#define VREG_COLOR019   0xDFF44C	// ULONG. -W. Video CLUT AARRGGBB Color [019]
#define VREG_COLOR020   0xDFF450	// ULONG. -W. Video CLUT AARRGGBB Color [020]
#define VREG_COLOR021   0xDFF454	// ULONG. -W. Video CLUT AARRGGBB Color [021]
#define VREG_COLOR022   0xDFF458	// ULONG. -W. Video CLUT AARRGGBB Color [022]
#define VREG_COLOR023   0xDFF45C	// ULONG. -W. Video CLUT AARRGGBB Color [023]
#define VREG_COLOR024   0xDFF460	// ULONG. -W. Video CLUT AARRGGBB Color [024]
#define VREG_COLOR025   0xDFF464	// ULONG. -W. Video CLUT AARRGGBB Color [025]
#define VREG_COLOR026   0xDFF468	// ULONG. -W. Video CLUT AARRGGBB Color [026]
#define VREG_COLOR027   0xDFF46C	// ULONG. -W. Video CLUT AARRGGBB Color [027]
#define VREG_COLOR028   0xDFF470	// ULONG. -W. Video CLUT AARRGGBB Color [028]
#define VREG_COLOR029   0xDFF474	// ULONG. -W. Video CLUT AARRGGBB Color [029]
#define VREG_COLOR030   0xDFF478	// ULONG. -W. Video CLUT AARRGGBB Color [030]
#define VREG_COLOR031   0xDFF47C	// ULONG. -W. Video CLUT AARRGGBB Color [031]
#define VREG_COLOR032   0xDFF480	// ULONG. -W. Video CLUT AARRGGBB Color [032]
#define VREG_COLOR033   0xDFF484	// ULONG. -W. Video CLUT AARRGGBB Color [033]
#define VREG_COLOR034   0xDFF488	// ULONG. -W. Video CLUT AARRGGBB Color [034]
#define VREG_COLOR035   0xDFF48C	// ULONG. -W. Video CLUT AARRGGBB Color [035]
#define VREG_COLOR036   0xDFF490	// ULONG. -W. Video CLUT AARRGGBB Color [036]
#define VREG_COLOR037   0xDFF494	// ULONG. -W. Video CLUT AARRGGBB Color [037]
#define VREG_COLOR038   0xDFF498	// ULONG. -W. Video CLUT AARRGGBB Color [038]
#define VREG_COLOR039   0xDFF49C	// ULONG. -W. Video CLUT AARRGGBB Color [039]
#define VREG_COLOR040   0xDFF4A0	// ULONG. -W. Video CLUT AARRGGBB Color [040]
#define VREG_COLOR041   0xDFF4A4	// ULONG. -W. Video CLUT AARRGGBB Color [041]
#define VREG_COLOR042   0xDFF4A8	// ULONG. -W. Video CLUT AARRGGBB Color [042]
#define VREG_COLOR043   0xDFF4AC	// ULONG. -W. Video CLUT AARRGGBB Color [043]
#define VREG_COLOR044   0xDFF4B0	// ULONG. -W. Video CLUT AARRGGBB Color [044]
#define VREG_COLOR045   0xDFF4B4	// ULONG. -W. Video CLUT AARRGGBB Color [045]
#define VREG_COLOR046   0xDFF4B8	// ULONG. -W. Video CLUT AARRGGBB Color [046]
#define VREG_COLOR047   0xDFF4BC	// ULONG. -W. Video CLUT AARRGGBB Color [047]
#define VREG_COLOR048   0xDFF4C0	// ULONG. -W. Video CLUT AARRGGBB Color [048]
#define VREG_COLOR049   0xDFF4C4	// ULONG. -W. Video CLUT AARRGGBB Color [049]
#define VREG_COLOR050   0xDFF4C8	// ULONG. -W. Video CLUT AARRGGBB Color [050]
#define VREG_COLOR051   0xDFF4CC	// ULONG. -W. Video CLUT AARRGGBB Color [051]
#define VREG_COLOR052   0xDFF4D0	// ULONG. -W. Video CLUT AARRGGBB Color [052]
#define VREG_COLOR053   0xDFF4D4	// ULONG. -W. Video CLUT AARRGGBB Color [053]
#define VREG_COLOR054   0xDFF4D8	// ULONG. -W. Video CLUT AARRGGBB Color [054]
#define VREG_COLOR055   0xDFF4DC	// ULONG. -W. Video CLUT AARRGGBB Color [055]
#define VREG_COLOR056   0xDFF4E0	// ULONG. -W. Video CLUT AARRGGBB Color [056]
#define VREG_COLOR057   0xDFF4E4	// ULONG. -W. Video CLUT AARRGGBB Color [057]
#define VREG_COLOR058   0xDFF4E8	// ULONG. -W. Video CLUT AARRGGBB Color [058]
#define VREG_COLOR059   0xDFF4EC	// ULONG. -W. Video CLUT AARRGGBB Color [059]
#define VREG_COLOR060   0xDFF4F0	// ULONG. -W. Video CLUT AARRGGBB Color [060]
#define VREG_COLOR061   0xDFF4F4	// ULONG. -W. Video CLUT AARRGGBB Color [061]
#define VREG_COLOR062   0xDFF4F8	// ULONG. -W. Video CLUT AARRGGBB Color [062]
#define VREG_COLOR063   0xDFF4FC	// ULONG. -W. Video CLUT AARRGGBB Color [063]
#define VREG_COLOR064   0xDFF500	// ULONG. -W. Video CLUT AARRGGBB Color [064]
#define VREG_COLOR065   0xDFF504	// ULONG. -W. Video CLUT AARRGGBB Color [065]
#define VREG_COLOR066   0xDFF508	// ULONG. -W. Video CLUT AARRGGBB Color [066]
#define VREG_COLOR067   0xDFF50C	// ULONG. -W. Video CLUT AARRGGBB Color [067]
#define VREG_COLOR068   0xDFF510	// ULONG. -W. Video CLUT AARRGGBB Color [068]
#define VREG_COLOR069   0xDFF514	// ULONG. -W. Video CLUT AARRGGBB Color [069]
#define VREG_COLOR070   0xDFF518	// ULONG. -W. Video CLUT AARRGGBB Color [070]
#define VREG_COLOR071   0xDFF51C	// ULONG. -W. Video CLUT AARRGGBB Color [071]
#define VREG_COLOR072   0xDFF520	// ULONG. -W. Video CLUT AARRGGBB Color [072]
#define VREG_COLOR073   0xDFF524	// ULONG. -W. Video CLUT AARRGGBB Color [073]
#define VREG_COLOR074   0xDFF528	// ULONG. -W. Video CLUT AARRGGBB Color [074]
#define VREG_COLOR075   0xDFF52C	// ULONG. -W. Video CLUT AARRGGBB Color [075]
#define VREG_COLOR076   0xDFF530	// ULONG. -W. Video CLUT AARRGGBB Color [076]
#define VREG_COLOR077   0xDFF534	// ULONG. -W. Video CLUT AARRGGBB Color [077]
#define VREG_COLOR078   0xDFF538	// ULONG. -W. Video CLUT AARRGGBB Color [078]
#define VREG_COLOR079   0xDFF53C	// ULONG. -W. Video CLUT AARRGGBB Color [079]
#define VREG_COLOR080   0xDFF540	// ULONG. -W. Video CLUT AARRGGBB Color [080]
#define VREG_COLOR081   0xDFF544	// ULONG. -W. Video CLUT AARRGGBB Color [081]
#define VREG_COLOR082   0xDFF548	// ULONG. -W. Video CLUT AARRGGBB Color [082]
#define VREG_COLOR083   0xDFF54C	// ULONG. -W. Video CLUT AARRGGBB Color [083]
#define VREG_COLOR084   0xDFF550	// ULONG. -W. Video CLUT AARRGGBB Color [084]
#define VREG_COLOR085   0xDFF554	// ULONG. -W. Video CLUT AARRGGBB Color [085]
#define VREG_COLOR086   0xDFF558	// ULONG. -W. Video CLUT AARRGGBB Color [086]
#define VREG_COLOR087   0xDFF55C	// ULONG. -W. Video CLUT AARRGGBB Color [087]
#define VREG_COLOR088   0xDFF560	// ULONG. -W. Video CLUT AARRGGBB Color [088]
#define VREG_COLOR089   0xDFF564	// ULONG. -W. Video CLUT AARRGGBB Color [089]
#define VREG_COLOR090   0xDFF568	// ULONG. -W. Video CLUT AARRGGBB Color [090]
#define VREG_COLOR091   0xDFF56C	// ULONG. -W. Video CLUT AARRGGBB Color [091]
#define VREG_COLOR092   0xDFF570	// ULONG. -W. Video CLUT AARRGGBB Color [092]
#define VREG_COLOR093   0xDFF574	// ULONG. -W. Video CLUT AARRGGBB Color [093]
#define VREG_COLOR094   0xDFF578	// ULONG. -W. Video CLUT AARRGGBB Color [094]
#define VREG_COLOR095   0xDFF57C	// ULONG. -W. Video CLUT AARRGGBB Color [095]
#define VREG_COLOR096   0xDFF580	// ULONG. -W. Video CLUT AARRGGBB Color [096]
#define VREG_COLOR097   0xDFF584	// ULONG. -W. Video CLUT AARRGGBB Color [097]
#define VREG_COLOR098   0xDFF588	// ULONG. -W. Video CLUT AARRGGBB Color [098]
#define VREG_COLOR099   0xDFF58C	// ULONG. -W. Video CLUT AARRGGBB Color [099]
#define VREG_COLOR100   0xDFF590	// ULONG. -W. Video CLUT AARRGGBB Color [100]
#define VREG_COLOR101   0xDFF594	// ULONG. -W. Video CLUT AARRGGBB Color [101]
#define VREG_COLOR102   0xDFF598	// ULONG. -W. Video CLUT AARRGGBB Color [102]
#define VREG_COLOR103   0xDFF59C	// ULONG. -W. Video CLUT AARRGGBB Color [103]
#define VREG_COLOR104   0xDFF5A0	// ULONG. -W. Video CLUT AARRGGBB Color [104]
#define VREG_COLOR105   0xDFF5A4	// ULONG. -W. Video CLUT AARRGGBB Color [105]
#define VREG_COLOR106   0xDFF5A8	// ULONG. -W. Video CLUT AARRGGBB Color [106]
#define VREG_COLOR107   0xDFF5AC	// ULONG. -W. Video CLUT AARRGGBB Color [107]
#define VREG_COLOR108   0xDFF5B0	// ULONG. -W. Video CLUT AARRGGBB Color [108]
#define VREG_COLOR109   0xDFF5B4	// ULONG. -W. Video CLUT AARRGGBB Color [109]
#define VREG_COLOR110   0xDFF5B8	// ULONG. -W. Video CLUT AARRGGBB Color [110]
#define VREG_COLOR111   0xDFF5BC	// ULONG. -W. Video CLUT AARRGGBB Color [111]
#define VREG_COLOR112   0xDFF5C0	// ULONG. -W. Video CLUT AARRGGBB Color [112]
#define VREG_COLOR113   0xDFF5C4	// ULONG. -W. Video CLUT AARRGGBB Color [113]
#define VREG_COLOR114   0xDFF5C8	// ULONG. -W. Video CLUT AARRGGBB Color [114]
#define VREG_COLOR115   0xDFF5CC	// ULONG. -W. Video CLUT AARRGGBB Color [115]
#define VREG_COLOR116   0xDFF5D0	// ULONG. -W. Video CLUT AARRGGBB Color [116]
#define VREG_COLOR117   0xDFF5D4	// ULONG. -W. Video CLUT AARRGGBB Color [117]
#define VREG_COLOR118   0xDFF5D8	// ULONG. -W. Video CLUT AARRGGBB Color [118]
#define VREG_COLOR119   0xDFF5DC	// ULONG. -W. Video CLUT AARRGGBB Color [119]
#define VREG_COLOR120   0xDFF5E0	// ULONG. -W. Video CLUT AARRGGBB Color [120]
#define VREG_COLOR121   0xDFF5E4	// ULONG. -W. Video CLUT AARRGGBB Color [121]
#define VREG_COLOR122   0xDFF5E8	// ULONG. -W. Video CLUT AARRGGBB Color [122]
#define VREG_COLOR123   0xDFF5EC	// ULONG. -W. Video CLUT AARRGGBB Color [123]
#define VREG_COLOR124   0xDFF5F0	// ULONG. -W. Video CLUT AARRGGBB Color [124]
#define VREG_COLOR125   0xDFF5F4	// ULONG. -W. Video CLUT AARRGGBB Color [125]
#define VREG_COLOR126   0xDFF5F8	// ULONG. -W. Video CLUT AARRGGBB Color [126]
#define VREG_COLOR127   0xDFF5FC	// ULONG. -W. Video CLUT AARRGGBB Color [127]
#define VREG_COLOR128   0xDFF600	// ULONG. -W. Video CLUT AARRGGBB Color [128]
#define VREG_COLOR129   0xDFF604	// ULONG. -W. Video CLUT AARRGGBB Color [129]
#define VREG_COLOR130   0xDFF608	// ULONG. -W. Video CLUT AARRGGBB Color [130]
#define VREG_COLOR131   0xDFF60C	// ULONG. -W. Video CLUT AARRGGBB Color [131]
#define VREG_COLOR132   0xDFF610	// ULONG. -W. Video CLUT AARRGGBB Color [132]
#define VREG_COLOR133   0xDFF614	// ULONG. -W. Video CLUT AARRGGBB Color [133]
#define VREG_COLOR134   0xDFF618	// ULONG. -W. Video CLUT AARRGGBB Color [134]
#define VREG_COLOR135   0xDFF61C	// ULONG. -W. Video CLUT AARRGGBB Color [135]
#define VREG_COLOR136   0xDFF620	// ULONG. -W. Video CLUT AARRGGBB Color [136]
#define VREG_COLOR137   0xDFF624	// ULONG. -W. Video CLUT AARRGGBB Color [137]
#define VREG_COLOR138   0xDFF628	// ULONG. -W. Video CLUT AARRGGBB Color [138]
#define VREG_COLOR139   0xDFF62C	// ULONG. -W. Video CLUT AARRGGBB Color [139]
#define VREG_COLOR140   0xDFF630	// ULONG. -W. Video CLUT AARRGGBB Color [140]
#define VREG_COLOR141   0xDFF634	// ULONG. -W. Video CLUT AARRGGBB Color [141]
#define VREG_COLOR142   0xDFF638	// ULONG. -W. Video CLUT AARRGGBB Color [142]
#define VREG_COLOR143   0xDFF63C	// ULONG. -W. Video CLUT AARRGGBB Color [143]
#define VREG_COLOR144   0xDFF640	// ULONG. -W. Video CLUT AARRGGBB Color [144]
#define VREG_COLOR145   0xDFF644	// ULONG. -W. Video CLUT AARRGGBB Color [145]
#define VREG_COLOR146   0xDFF648	// ULONG. -W. Video CLUT AARRGGBB Color [146]
#define VREG_COLOR147   0xDFF64C	// ULONG. -W. Video CLUT AARRGGBB Color [147]
#define VREG_COLOR148   0xDFF650	// ULONG. -W. Video CLUT AARRGGBB Color [148]
#define VREG_COLOR149   0xDFF654	// ULONG. -W. Video CLUT AARRGGBB Color [149]
#define VREG_COLOR150   0xDFF658	// ULONG. -W. Video CLUT AARRGGBB Color [150]
#define VREG_COLOR151   0xDFF65C	// ULONG. -W. Video CLUT AARRGGBB Color [151]
#define VREG_COLOR152   0xDFF660	// ULONG. -W. Video CLUT AARRGGBB Color [152]
#define VREG_COLOR153   0xDFF664	// ULONG. -W. Video CLUT AARRGGBB Color [153]
#define VREG_COLOR154   0xDFF668	// ULONG. -W. Video CLUT AARRGGBB Color [154]
#define VREG_COLOR155   0xDFF66C	// ULONG. -W. Video CLUT AARRGGBB Color [155]
#define VREG_COLOR156   0xDFF670	// ULONG. -W. Video CLUT AARRGGBB Color [156]
#define VREG_COLOR157   0xDFF674	// ULONG. -W. Video CLUT AARRGGBB Color [157]
#define VREG_COLOR158   0xDFF678	// ULONG. -W. Video CLUT AARRGGBB Color [158]
#define VREG_COLOR159   0xDFF67C	// ULONG. -W. Video CLUT AARRGGBB Color [159]
#define VREG_COLOR160   0xDFF680	// ULONG. -W. Video CLUT AARRGGBB Color [160]
#define VREG_COLOR161   0xDFF684	// ULONG. -W. Video CLUT AARRGGBB Color [161]
#define VREG_COLOR162   0xDFF688	// ULONG. -W. Video CLUT AARRGGBB Color [162]
#define VREG_COLOR163   0xDFF68C	// ULONG. -W. Video CLUT AARRGGBB Color [163]
#define VREG_COLOR164   0xDFF690	// ULONG. -W. Video CLUT AARRGGBB Color [164]
#define VREG_COLOR165   0xDFF694	// ULONG. -W. Video CLUT AARRGGBB Color [165]
#define VREG_COLOR166   0xDFF698	// ULONG. -W. Video CLUT AARRGGBB Color [166]
#define VREG_COLOR167   0xDFF69C	// ULONG. -W. Video CLUT AARRGGBB Color [167]
#define VREG_COLOR168   0xDFF6A0	// ULONG. -W. Video CLUT AARRGGBB Color [168]
#define VREG_COLOR169   0xDFF6A4	// ULONG. -W. Video CLUT AARRGGBB Color [169]
#define VREG_COLOR170   0xDFF6A8	// ULONG. -W. Video CLUT AARRGGBB Color [170]
#define VREG_COLOR171   0xDFF6AC	// ULONG. -W. Video CLUT AARRGGBB Color [171]
#define VREG_COLOR172   0xDFF6B0	// ULONG. -W. Video CLUT AARRGGBB Color [172]
#define VREG_COLOR173   0xDFF6B4	// ULONG. -W. Video CLUT AARRGGBB Color [173]
#define VREG_COLOR174   0xDFF6B8	// ULONG. -W. Video CLUT AARRGGBB Color [174]
#define VREG_COLOR175   0xDFF6BC	// ULONG. -W. Video CLUT AARRGGBB Color [175]
#define VREG_COLOR176   0xDFF6C0	// ULONG. -W. Video CLUT AARRGGBB Color [176]
#define VREG_COLOR177   0xDFF6C4	// ULONG. -W. Video CLUT AARRGGBB Color [177]
#define VREG_COLOR178   0xDFF6C8	// ULONG. -W. Video CLUT AARRGGBB Color [178]
#define VREG_COLOR179   0xDFF6CC	// ULONG. -W. Video CLUT AARRGGBB Color [179]
#define VREG_COLOR180   0xDFF6D0	// ULONG. -W. Video CLUT AARRGGBB Color [180]
#define VREG_COLOR181   0xDFF6D4	// ULONG. -W. Video CLUT AARRGGBB Color [181]
#define VREG_COLOR182   0xDFF6D8	// ULONG. -W. Video CLUT AARRGGBB Color [182]
#define VREG_COLOR183   0xDFF6DC	// ULONG. -W. Video CLUT AARRGGBB Color [183]
#define VREG_COLOR184   0xDFF6E0	// ULONG. -W. Video CLUT AARRGGBB Color [184]
#define VREG_COLOR185   0xDFF6E4	// ULONG. -W. Video CLUT AARRGGBB Color [185]
#define VREG_COLOR186   0xDFF6E8	// ULONG. -W. Video CLUT AARRGGBB Color [186]
#define VREG_COLOR187   0xDFF6EC	// ULONG. -W. Video CLUT AARRGGBB Color [187]
#define VREG_COLOR188   0xDFF6F0	// ULONG. -W. Video CLUT AARRGGBB Color [188]
#define VREG_COLOR189   0xDFF6F4	// ULONG. -W. Video CLUT AARRGGBB Color [189]
#define VREG_COLOR190   0xDFF6F8	// ULONG. -W. Video CLUT AARRGGBB Color [190]
#define VREG_COLOR191   0xDFF6FC	// ULONG. -W. Video CLUT AARRGGBB Color [191]
#define VREG_COLOR192   0xDFF700	// ULONG. -W. Video CLUT AARRGGBB Color [192]
#define VREG_COLOR193   0xDFF704	// ULONG. -W. Video CLUT AARRGGBB Color [193]
#define VREG_COLOR194   0xDFF708	// ULONG. -W. Video CLUT AARRGGBB Color [194]
#define VREG_COLOR195   0xDFF70C	// ULONG. -W. Video CLUT AARRGGBB Color [195]
#define VREG_COLOR196   0xDFF710	// ULONG. -W. Video CLUT AARRGGBB Color [196]
#define VREG_COLOR197   0xDFF714	// ULONG. -W. Video CLUT AARRGGBB Color [197]
#define VREG_COLOR198   0xDFF718	// ULONG. -W. Video CLUT AARRGGBB Color [198]
#define VREG_COLOR199   0xDFF71C	// ULONG. -W. Video CLUT AARRGGBB Color [199]
#define VREG_COLOR200   0xDFF720	// ULONG. -W. Video CLUT AARRGGBB Color [200]
#define VREG_COLOR201   0xDFF724	// ULONG. -W. Video CLUT AARRGGBB Color [201]
#define VREG_COLOR202   0xDFF728	// ULONG. -W. Video CLUT AARRGGBB Color [202]
#define VREG_COLOR203   0xDFF72C	// ULONG. -W. Video CLUT AARRGGBB Color [203]
#define VREG_COLOR204   0xDFF730	// ULONG. -W. Video CLUT AARRGGBB Color [204]
#define VREG_COLOR205   0xDFF734	// ULONG. -W. Video CLUT AARRGGBB Color [205]
#define VREG_COLOR206   0xDFF738	// ULONG. -W. Video CLUT AARRGGBB Color [206]
#define VREG_COLOR207   0xDFF73C	// ULONG. -W. Video CLUT AARRGGBB Color [207]
#define VREG_COLOR208   0xDFF740	// ULONG. -W. Video CLUT AARRGGBB Color [208]
#define VREG_COLOR209   0xDFF744	// ULONG. -W. Video CLUT AARRGGBB Color [209]
#define VREG_COLOR210   0xDFF748	// ULONG. -W. Video CLUT AARRGGBB Color [210]
#define VREG_COLOR211   0xDFF74C	// ULONG. -W. Video CLUT AARRGGBB Color [211]
#define VREG_COLOR212   0xDFF750	// ULONG. -W. Video CLUT AARRGGBB Color [212]
#define VREG_COLOR213   0xDFF754	// ULONG. -W. Video CLUT AARRGGBB Color [213]
#define VREG_COLOR214   0xDFF758	// ULONG. -W. Video CLUT AARRGGBB Color [214]
#define VREG_COLOR215   0xDFF75C	// ULONG. -W. Video CLUT AARRGGBB Color [215]
#define VREG_COLOR216   0xDFF760	// ULONG. -W. Video CLUT AARRGGBB Color [216]
#define VREG_COLOR217   0xDFF764	// ULONG. -W. Video CLUT AARRGGBB Color [217]
#define VREG_COLOR218   0xDFF768	// ULONG. -W. Video CLUT AARRGGBB Color [218]
#define VREG_COLOR219   0xDFF76C	// ULONG. -W. Video CLUT AARRGGBB Color [219]
#define VREG_COLOR220   0xDFF770	// ULONG. -W. Video CLUT AARRGGBB Color [220]
#define VREG_COLOR221   0xDFF774	// ULONG. -W. Video CLUT AARRGGBB Color [221]
#define VREG_COLOR222   0xDFF778	// ULONG. -W. Video CLUT AARRGGBB Color [222]
#define VREG_COLOR223   0xDFF77C	// ULONG. -W. Video CLUT AARRGGBB Color [223]
#define VREG_COLOR224   0xDFF780	// ULONG. -W. Video CLUT AARRGGBB Color [224]
#define VREG_COLOR225   0xDFF784	// ULONG. -W. Video CLUT AARRGGBB Color [225]
#define VREG_COLOR226   0xDFF788	// ULONG. -W. Video CLUT AARRGGBB Color [226]
#define VREG_COLOR227   0xDFF78C	// ULONG. -W. Video CLUT AARRGGBB Color [227]
#define VREG_COLOR228   0xDFF790	// ULONG. -W. Video CLUT AARRGGBB Color [228]
#define VREG_COLOR229   0xDFF794	// ULONG. -W. Video CLUT AARRGGBB Color [229]
#define VREG_COLOR230   0xDFF798	// ULONG. -W. Video CLUT AARRGGBB Color [230]
#define VREG_COLOR231   0xDFF79C	// ULONG. -W. Video CLUT AARRGGBB Color [231]
#define VREG_COLOR232   0xDFF7A0	// ULONG. -W. Video CLUT AARRGGBB Color [232]
#define VREG_COLOR233   0xDFF7A4	// ULONG. -W. Video CLUT AARRGGBB Color [233]
#define VREG_COLOR234   0xDFF7A8	// ULONG. -W. Video CLUT AARRGGBB Color [234]
#define VREG_COLOR235   0xDFF7AC	// ULONG. -W. Video CLUT AARRGGBB Color [235]
#define VREG_COLOR236   0xDFF7B0	// ULONG. -W. Video CLUT AARRGGBB Color [236]
#define VREG_COLOR237   0xDFF7B4	// ULONG. -W. Video CLUT AARRGGBB Color [237]
#define VREG_COLOR238   0xDFF7B8	// ULONG. -W. Video CLUT AARRGGBB Color [238]
#define VREG_COLOR239   0xDFF7BC	// ULONG. -W. Video CLUT AARRGGBB Color [239]
#define VREG_COLOR240   0xDFF7C0	// ULONG. -W. Video CLUT AARRGGBB Color [240]
#define VREG_COLOR241   0xDFF7C4	// ULONG. -W. Video CLUT AARRGGBB Color [241]
#define VREG_COLOR242   0xDFF7C8	// ULONG. -W. Video CLUT AARRGGBB Color [242]
#define VREG_COLOR243   0xDFF7CC	// ULONG. -W. Video CLUT AARRGGBB Color [243]
#define VREG_COLOR244   0xDFF7D0	// ULONG. -W. Video CLUT AARRGGBB Color [244]
#define VREG_COLOR245   0xDFF7D4	// ULONG. -W. Video CLUT AARRGGBB Color [245]
#define VREG_COLOR246   0xDFF7D8	// ULONG. -W. Video CLUT AARRGGBB Color [246]
#define VREG_COLOR247   0xDFF7DC	// ULONG. -W. Video CLUT AARRGGBB Color [247]
#define VREG_COLOR248   0xDFF7E0	// ULONG. -W. Video CLUT AARRGGBB Color [248]
#define VREG_COLOR249   0xDFF7E4	// ULONG. -W. Video CLUT AARRGGBB Color [249]
#define VREG_COLOR250   0xDFF7E8	// ULONG. -W. Video CLUT AARRGGBB Color [250]
#define VREG_COLOR251   0xDFF7EC	// ULONG. -W. Video CLUT AARRGGBB Color [251]
#define VREG_COLOR252   0xDFF7F0	// ULONG. -W. Video CLUT AARRGGBB Color [252]
#define VREG_COLOR253   0xDFF7F4	// ULONG. -W. Video CLUT AARRGGBB Color [253]
#define VREG_COLOR254   0xDFF7F8	// ULONG. -W. Video CLUT AARRGGBB Color [254]
#define VREG_COLOR255   0xDFF7FC	// ULONG. -W. Video CLUT AARRGGBB Color [255]

#define VREG_SPRIMG00   0xDFF800	// ULONG. -W. Video Sprite Image [00]
#define VREG_SPRIMG01   0xDFF804	// ULONG. -W. Video Sprite Image [01]
#define VREG_SPRIMG02   0xDFF808	// ULONG. -W. Video Sprite Image [02]
#define VREG_SPRIMG03   0xDFF80C	// ULONG. -W. Video Sprite Image [03]
#define VREG_SPRIMG04   0xDFF810	// ULONG. -W. Video Sprite Image [04]
#define VREG_SPRIMG05   0xDFF814	// ULONG. -W. Video Sprite Image [05]
#define VREG_SPRIMG06   0xDFF818	// ULONG. -W. Video Sprite Image [06]
#define VREG_SPRIMG07   0xDFF81C	// ULONG. -W. Video Sprite Image [07]
#define VREG_SPRIMG08   0xDFF820	// ULONG. -W. Video Sprite Image [08]
#define VREG_SPRIMG09   0xDFF824	// ULONG. -W. Video Sprite Image [09]
#define VREG_SPRIMG10   0xDFF828	// ULONG. -W. Video Sprite Image [10]
#define VREG_SPRIMG11   0xDFF82C	// ULONG. -W. Video Sprite Image [11]
#define VREG_SPRIMG12   0xDFF830	// ULONG. -W. Video Sprite Image [12]
#define VREG_SPRIMG13   0xDFF834	// ULONG. -W. Video Sprite Image [13]
#define VREG_SPRIMG14   0xDFF838	// ULONG. -W. Video Sprite Image [14]
#define VREG_SPRIMG15   0xDFF83C	// ULONG. -W. Video Sprite Image [15]

