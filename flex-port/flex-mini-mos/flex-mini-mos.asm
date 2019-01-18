		include "../../includes/hardware.inc"
		include "../../includes/common.inc"
**		include "../../includes/mosrom.inc"
		include "../../includes/noice.inc"
		include "../../includes/oslib.inc"
		include "./gen-version.inc"
		include "mini-mos.inc"



;==============================================================================
; A cut down version of the MOS to service Flex VDU and keyboard requests
;==============================================================================

M_ENTEROS	MACRO
		JSR	_ENTEROS
		ENDM

M_EXITOS	MACRO
		PULS	DP,PC
		ENDM
		
DEBUGPR		MACRO
		SECTION	"tables_and_strings"
1		FCB	\1,0
__STR		SET	1B
		CODE
		PSHS	X
		LEAX	__STR,PCR
		JSR	debug_printX
		JSR	debug_print_newl
		PULS	X
		ENDM

DEBUGPR2	MACRO
		SECTION	"tables_and_strings"
1		FCB	\1,0
__STR		SET	1B
		CODE
		PSHS	X
		LEAX	__STR,PCR
		JSR	debug_printX
		PULS	X
		ENDM


ASSERT		MACRO
		DEBUGPR	\1
	IF NOICE
		SWI
	ELSE
		ORCC	#$FF
		CWAI	#$FF				; wait for NMI!
	ENDIF
		ENDM

TODO		MACRO
		jsr	prTODO
		ASSERT	\1
		ENDM

TODOSKIP	MACRO
		DEBUGPR	\1
		ENDM

DEBUG_INFO	MACRO
	IF NOICE = 1 
		DEBUGPR \1
	ENDIF
		ENDM


		; NOTE: MOS only runs on a 6309 and uses 6309 extra registers
		; NOTE: currently doesn't support native mode!

		CODE
		ORG	MOSROMBASE
		setdp	MOSROMSYS_DP/256
		SECTION	"tables_and_strings"
		ORG	MOSSTRINGS


NATIVE		equ	0

		CODE

mostbl_chardefs
		FCB	$00,$00,$00,$00,$00,$00,$00,$00
		FCB	$18,$18,$18,$18,$18,$00,$18,$00
		FCB	$6C,$6C,$6C,$00,$00,$00,$00,$00
		FCB	$36,$36,$7F,$36,$7F,$36,$36,$00
		FCB	$0C,$3F,$68,$3E,$0B,$7E,$18,$00
		FCB	$60,$66,$0C,$18,$30,$66,$06,$00
		FCB	$38,$6C,$6C,$38,$6D,$66,$3B,$00
		FCB	$0C,$18,$30,$00,$00,$00,$00,$00
		FCB	$0C,$18,$30,$30,$30,$18,$0C,$00
		FCB	$30,$18,$0C,$0C,$0C,$18,$30,$00
		FCB	$00,$18,$7E,$3C,$7E,$18,$00,$00
		FCB	$00,$18,$18,$7E,$18,$18,$00,$00
		FCB	$00,$00,$00,$00,$00,$18,$18,$30
		FCB	$00,$00,$00,$7E,$00,$00,$00,$00
		FCB	$00,$00,$00,$00,$00,$18,$18,$00
		FCB	$00,$06,$0C,$18,$30,$60,$00,$00
		FCB	$3C,$66,$6E,$7E,$76,$66,$3C,$00
		FCB	$18,$38,$18,$18,$18,$18,$7E,$00
		FCB	$3C,$66,$06,$0C,$18,$30,$7E,$00
		FCB	$3C,$66,$06,$1C,$06,$66,$3C,$00
		FCB	$0C,$1C,$3C,$6C,$7E,$0C,$0C,$00
		FCB	$7E,$60,$7C,$06,$06,$66,$3C,$00
		FCB	$1C,$30,$60,$7C,$66,$66,$3C,$00
		FCB	$7E,$06,$0C,$18,$30,$30,$30,$00
		FCB	$3C,$66,$66,$3C,$66,$66,$3C,$00
		FCB	$3C,$66,$66,$3E,$06,$0C,$38,$00
		FCB	$00,$00,$18,$18,$00,$18,$18,$00
		FCB	$00,$00,$18,$18,$00,$18,$18,$30
		FCB	$0C,$18,$30,$60,$30,$18,$0C,$00
		FCB	$00,$00,$7E,$00,$7E,$00,$00,$00
		FCB	$30,$18,$0C,$06,$0C,$18,$30,$00
		FCB	$3C,$66,$0C,$18,$18,$00,$18,$00
		FCB	$3C,$66,$6E,$6A,$6E,$60,$3C,$00
		FCB	$3C,$66,$66,$7E,$66,$66,$66,$00
		FCB	$7C,$66,$66,$7C,$66,$66,$7C,$00
		FCB	$3C,$66,$60,$60,$60,$66,$3C,$00
		FCB	$78,$6C,$66,$66,$66,$6C,$78,$00
		FCB	$7E,$60,$60,$7C,$60,$60,$7E,$00
		FCB	$7E,$60,$60,$7C,$60,$60,$60,$00
		FCB	$3C,$66,$60,$6E,$66,$66,$3C,$00
		FCB	$66,$66,$66,$7E,$66,$66,$66,$00
		FCB	$7E,$18,$18,$18,$18,$18,$7E,$00
		FCB	$3E,$0C,$0C,$0C,$0C,$6C,$38,$00
		FCB	$66,$6C,$78,$70,$78,$6C,$66,$00
		FCB	$60,$60,$60,$60,$60,$60,$7E,$00
		FCB	$63,$77,$7F,$6B,$6B,$63,$63,$00
		FCB	$66,$66,$76,$7E,$6E,$66,$66,$00
		FCB	$3C,$66,$66,$66,$66,$66,$3C,$00
		FCB	$7C,$66,$66,$7C,$60,$60,$60,$00
		FCB	$3C,$66,$66,$66,$6A,$6C,$36,$00
		FCB	$7C,$66,$66,$7C,$6C,$66,$66,$00
		FCB	$3C,$66,$60,$3C,$06,$66,$3C,$00
		FCB	$7E,$18,$18,$18,$18,$18,$18,$00
		FCB	$66,$66,$66,$66,$66,$66,$3C,$00
		FCB	$66,$66,$66,$66,$66,$3C,$18,$00
		FCB	$63,$63,$6B,$6B,$7F,$77,$63,$00
		FCB	$66,$66,$3C,$18,$3C,$66,$66,$00
		FCB	$66,$66,$66,$3C,$18,$18,$18,$00
		FCB	$7E,$06,$0C,$18,$30,$60,$7E,$00
		FCB	$7C,$60,$60,$60,$60,$60,$7C,$00
		FCB	$00,$60,$30,$18,$0C,$06,$00,$00
		FCB	$3E,$06,$06,$06,$06,$06,$3E,$00
		FCB	$18,$3C,$66,$42,$00,$00,$00,$00
		FCB	$00,$00,$00,$00,$00,$00,$00,$FF
		FCB	$1C,$36,$30,$7C,$30,$30,$7E,$00
		FCB	$00,$00,$3C,$06,$3E,$66,$3E,$00
		FCB	$60,$60,$7C,$66,$66,$66,$7C,$00
		FCB	$00,$00,$3C,$66,$60,$66,$3C,$00
		FCB	$06,$06,$3E,$66,$66,$66,$3E,$00
		FCB	$00,$00,$3C,$66,$7E,$60,$3C,$00
		FCB	$1C,$30,$30,$7C,$30,$30,$30,$00
		FCB	$00,$00,$3E,$66,$66,$3E,$06,$3C
		FCB	$60,$60,$7C,$66,$66,$66,$66,$00
		FCB	$18,$00,$38,$18,$18,$18,$3C,$00
		FCB	$18,$00,$38,$18,$18,$18,$18,$70
		FCB	$60,$60,$66,$6C,$78,$6C,$66,$00
		FCB	$38,$18,$18,$18,$18,$18,$3C,$00
		FCB	$00,$00,$36,$7F,$6B,$6B,$63,$00
		FCB	$00,$00,$7C,$66,$66,$66,$66,$00
		FCB	$00,$00,$3C,$66,$66,$66,$3C,$00
		FCB	$00,$00,$7C,$66,$66,$7C,$60,$60
		FCB	$00,$00,$3E,$66,$66,$3E,$06,$07
		FCB	$00,$00,$6C,$76,$60,$60,$60,$00
		FCB	$00,$00,$3E,$60,$3C,$06,$7C,$00
		FCB	$30,$30,$7C,$30,$30,$30,$1C,$00
		FCB	$00,$00,$66,$66,$66,$66,$3E,$00
		FCB	$00,$00,$66,$66,$66,$3C,$18,$00
		FCB	$00,$00,$63,$6B,$6B,$7F,$36,$00
		FCB	$00,$00,$66,$3C,$18,$3C,$66,$00
		FCB	$00,$00,$66,$66,$66,$3E,$06,$3C
		FCB	$00,$00,$7E,$0C,$18,$30,$7E,$00
		FCB	$0C,$18,$18,$70,$18,$18,$0C,$00
		FCB	$18,$18,$18,$00,$18,$18,$18,$00
		FCB	$30,$18,$18,$0E,$18,$18,$30,$00
		FCB	$31,$6B,$46,$00,$00,$00,$00,$00
		FCB	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF


			ORG	MOSROMSYS_DP	
zp_mos_keynumlast	RMB	1
zp_mos_OS_wksp		RMB	1
zp_mos_OS_wksp2		RMB	1
zp_vdu_status		RMB	1
zp_mos_OSBW_A		RMB	1			; OSBYTE/OSWORD A reg value
	***** NOTE: zp_mos_OSBW_Y&X swapped for endiannedss
zp_mos_OSWORD_X		
zp_mos_OSBW_Y		RMB	1	; OSBYTE/OSWORD Y reg value
zp_mos_OSBW_X		RMB	1	; OSBYTE/OSWORD X reg value
zp_mos_ESC_flag		RMB	1
zp_vdu_txtcolourOR	RMB	1	; Text colour OR mask
zp_vdu_txtcolourEOR	RMB	1	; Text colour EOR mask
zp_vdu_top_scanline	RMB	2	; Top scan line
zp_vdu_wksp		RMB	7	; MINIMOS - larger than MOS for OSBYTE 135



a_h		FILL 	$FF, (256-(a_h & $FF)) & $FF	; align 256


mos_vars	
sysvar_IRQV		RMB	2			; IRQ vector
sysvar_SWI3V		RMB	2			; SWI3 vector
sysvar_KEYB_STATUS	RMB	1
sysvar_KEYB_TAB_CHAR	RMB	1


			ORG	MOSCODEBASE
;========================================================
; V D U - taken from main MOS
;========================================================

mostbl_byte_mask_4col
		FCB	$00,$11,$22,$33,$44,$55,$66,$77 ;	C31F
		FCB	$88,$99,$AA,$BB,$CC,$DD,$EE,$FF ;	C327
mostbl_byte_mask_16col
		FCB	$00,$55,$AA,$FF			;	C32F
mostbl_vdu_entry_points
		FDB	LC511RTS			; VDU 0
		FDB	LC511RTS			; VDU 1
		FDB	LC511RTS			; VDU 2
		FDB	LC511RTS			; VDU 3
		FDB	LC511RTS			; VDU 4
		FDB	LC511RTS			; VDU 5
		FDB	LC511RTS			; VDU 6
		FDB	LC511RTS			; VDU 7

		FDB	mos_VDU_8			; VDU 8
		FDB	mos_VDU_9			; VDU 9
		FDB	mos_VDU_10			; VDU 10
		FDB	mos_VDU_11			; VDU 11
		FDB	mos_VDU_12			; VDU 12
		FDB	mos_VDU_13
		FDB	mos_VDU_14
		FDB	mos_VDU_15

		FDB	LC511RTS
		FDB	mos_VDU_17
		FDB	mos_VDU_18
		FDB	mos_VDU_19
		FDB	mos_VDU_20
		FDB	mos_VDU_21
		FDB	mos_VDU_22
		FDB	mos_VDU_23

		FDB	LC511RTS
		FDB	LC511RTS
		FDB	mos_VDU_26
		FDB	LC511RTS
		FDB	mos_VDU_28
		FDB	LC511RTS
		FDB	mos_VDU_30
		FDB	mos_VDU_31

		FDB	mos_VDU_127

mostbl_vdu_q_lengths	; 2's complement
		FCB	$00,$FF,$00,$00,$00,$00,$00,$00	; 0-7
		FCB	$00,$00,$00,$00,$00,$00,$00,$00 ; 8-15
		FCB	$00,$FF,$FE,$FB,$00,$00,$FF,$F7 ; 16-23
		FCB	$F8,$FB,$00,$00,$FC,$FC,$00,$FE ; 24-31
		FCB	$00

; TEXT WINDOW -BOTTOM ROW LOOK UP TABLE
mostbl_vdu_window_bottom
		FCB	$C0,$1F,$1F,$1F,$18,$1F,$1F,$18 ;	C3E6
		FCB	$18				;	C3EE
; TEXT WINDOW -RIGHT HAND COLUMN LOOK UP TABLE
mostbl_vdu_window_right
		FCB	$4F,$27,$13,$4F,$27,$13,$27,$27 ;	C3EF
mostbl_VDU_VIDPROC_CTL_by_mode
		FCB	$9C,$D8,$F4,$9C,$88,$C4,$88,$4B ;	C3F7
mostbl_VDU_bytes_per_char
		FCB	$08,$10,$20,$08,$08,$10,$08,$01 ;	C3FF
mostbl_VDU_pix_mask_16colour				
		FCB	$AA,$55				;	C407
mostbl_VDU_pix_mask_4colour
		FCB	$88,$44,$22,$11			;	C409
mostbl_VDU_pix_mask_2colour
		FCB	$80,$40,$20,$10,$08,$04,$02	;	C40D
mostbl_VDU_mode_colours_m1			; - spills into next table
		FCB	$01,$03,$0F,$01,$01,$03,$01,$00 ;	C414
; GCOL PLOT OPTIONS PROCESSING LOOK UP TABLE
mostbl_GCOL_options_proc
		FCB	$FF,$00,$00,$FF,$FF,$FF,$FF,$00 ;	C41C
; 2 COLOUR MODES PARAMETER LOOK UP TABLE
mostbl_2_colour_pixmasks
		FCB	$00,$FF				;	C424
; 4 COLOUR MODES PARAMETER LOOK UP TABLE
mostbl_4_colour_pixmasks
		FCB	$00,$0F,$F0,$FF			;	C426
; 16 COLOUR MODES PARAMETER LOOK UP TABLE
mostbl_16_colour_pixmasks
		FCB	$00,$03,$0C,$0F,$30,$33,$3C,$3F ;	C42A
		FCB	$C0,$C3,$CC,$CF,$F0,$F3,$FC,$FF ;	C432
mostbl_leftmost_pixels
		FCB	$80,$88,$AA
; modes 3,6,7 are 0 but get set to $7 in vdu_init
mostbl_VDU_pixels_per_byte_m1
		FCB	$07,$03,$01,$00,$07,$03		;	C43A
; mode size
mostbl_VDU_mode_size				; note first two entries shared by previous tbl
		FCB	$00,$00,$00,$01,$02,$02,$03,$04 ;	C440
; SOUND PITCH OFFSET BY CHANNEL LOOK UP TABLE ???CHECK
mostbl_SOUND_PITCH_OFFSET_BY_CHANNEL_LOOK_UP_TABLE
		FCB	$00,$06,$02			;	C448
	IF MACH_BEEB
; sent direct to orb of SYSVIA dependent on mode_size
mostbl_VDU_hwscroll_offb1
		FCB	$0D,$05,$0D,$05			;	C44B
; sent direct to orb of SYSVIA dependent on mode_size
mostbl_VDU_hwscroll_offb2
		FCB	$04,$04,$0C,$0C,$04		;	C44F
	ENDIF
	IF MACH_CHIPKIT
; new scroll offset table for 6809 hardware offset
mostbl_VDU_hwscroll_offs
		FCB	$06,$08,$0B,$0C,$F;			TODO: mode 7 doesn't work!
	ENDIF
; where to jump to in CLS unwound
;;;mostbl_VDU_cls_vecjmp
;;;	FDB	cls_Mode_012_entry_point
;;;	FDB	cls_Mode_3_entry_point
;;;	FDB	cls_Mode_45_entry_point
;;;	FDB	cls_Mode_6_entry_point
;;;	FDB	cls_Mode_7_entry_point
mostbl_VDU_screensize_h
		FCB	$50,$40,$28,$20,$04		;	C459
mostbl_VDU_screebot_h
		FCB	$30,$40,$58,$60,$7C		;	C45E
mostbl_VDU_bytes_per_row_low
		FCB	$28,$40,$80			;	C463
; pointers to tables of 6845 values that follow this by
mostbl_VDU_ptr_end_6845tab
		FCB	$0B + 1
		FCB	$17 + 1
		FCB	$23 + 1
		FCB	$2F + 1
		FCB	$3B + 1
mostbl_VDU_6845_mode_012
		FCB	$7F,$50,$62,$28,$26,$00,$20,$22,$01,$07,$67,$08
mostbl_VDU_6845_mode_3
		FCB	$7F,$50,$62,$28,$1E,$02,$19,$1B,$01,$09,$67,$09
mostbl_VDU_6845_mode_45
		FCB	$3F,$28,$31,$24,$26,$00,$20,$22,$01,$07,$67,$08
mostbl_VDU_6845_mode_6
		FCB	$3F,$28,$31,$24,$1E,$02,$19,$1B,$01,$09,$67,$09
mostbl_VDU_6845_mode_7
		FCB	$3F,$28,$33,$24,$1E,$02,$19,$1B,$93,$12,$72,$13

;; TELETEXT CHARACTER CONVERSION TABLE
mostbl_TTX_CHAR_CONV
		FCB	$23,$5F,$60,$23			;	C4B6


prTODO
		DEBUGPR2	"TODO HALT: ", 1
		rts


;; ----------------------------------------------------------------------------
mos_VDU_WRCH
		ldb	sysvar_VDU_Q_LEN		;	C4C0
		bne	mos_VDU_WRCH_add_to_Q		;	C4C3
	IF CPU_6809
		ldb	zp_vdu_status
		andb	#$40
	ELSE
		tim	#$40, zp_vdu_status
	ENDIF
;;	ldb	#$40
;;	bitb	zp_vdu_status				;	C4C5
		beq	mos_VDU_WRCH_sk_nocurs
		jsr	x_start_curs_edit		;	C4C9
		jsr	x_set_up_write_cursor		;	C4CC
		bmi	mos_VDU_WRCH_sk_nocurs		;	C4CF
		cmpa	#$0D				;	C4D1
		bne	mos_VDU_WRCH_sk_nocurs		;	C4D3
		jsr	x_cancel_cursor_edit		;	C4D5
mos_VDU_WRCH_sk_nocurs
		cmpa	#$7F				;	C4D8
		beq	x_read_linkaddresses_and_number_of_parameters1;	C4DA
		cmpa	#$20				;	C4DC
		blo	x_read_linkaddresses_and_number_of_parameters2;	C4DE
		tst	zp_vdu_status			;	C4E0
		bmi	mos_VDU_WRCH_sk_novdu				;	C4E2
		jsr	render_char				;	C4E4
		jsr	mos_VDU_9			;	C4E7
mos_VDU_WRCH_sk_novdu
		jmp	x_main_exit_routine		;	LC4EA
;; ----------------------------------------------------------------------------
;; read linkFDBesses and number of parameters???
x_read_linkaddresses_and_number_of_parameters1
		lda	#$20				;	C4ED
;; read linkFDBesses and number of parameters???
x_read_linkaddresses_and_number_of_parameters2
		tfr	A,B				;	C4EF
		ldx	#mostbl_vdu_q_lengths
		lda	B,X
		aslb
		ldx	#mostbl_vdu_entry_points
		ldx	B,X
		;;lsrb
		tsta
		beq	x_vdu_no_q
		sta	sysvar_VDU_Q_LEN
		stx	vduvar_VDU_VEC_JMP
	IF CPU_6809
		ldb	#$40
		bitb	zp_vdu_status
	ELSE
		tim	#$40, zp_vdu_status
	ENDIF
		bne	LC52F				; cursor editing in force
		CLC
LC511RTS
		rts
;; ----------------------------------------------------------------------------
;; B, sysvar_VDU_Q_LEN are 2's complement of number of parameters. **{NETV=>vduvar_Q+5-$100}
mos_VDU_WRCH_add_to_Q
		ldx	#vduvar_VDU_Q_END
		sta	B,X				;	C512
		incb					;	C515
		stb	sysvar_VDU_Q_LEN		;	C516
		bne	LC532				;	C519
	IF CPU_6809
		pshs	B
		ldb	zp_vdu_status			;	C51B
		bitb	#$C0
		puls	B				; TODO get rid of push/pop?
	ELSE
		tim	#$C0, zp_vdu_status
	ENDIF
;;		bmi	mos_exec_vdu1			; bit 7 set - VDU disabled
		bne	LC526				; bit 6 set - cursor editing in force
		jsr	[vduvar_VDU_VEC_JMP]
		CLC					;	C524
		rts					;	C525
; ----------------------------------------------------------------------------
LC526		jsr	x_start_curs_edit		;	C526
		jsr	x_set_up_write_cursor		;	C529
		jsr	[vduvar_VDU_VEC_JMP]
LC52F		jsr	x_cursor_editing_routines	;	C52F
LC532		CLC					;	C532
		rts					;	C533
;; ----------------------------------------------------------------------------
;; if explicit linkFDBess found, no parameters
;x_if_explicit_linkFDBess_found_no_parameters:
x_vdu_no_q
		stx	vduvar_VDU_VEC_JMP		;	C545

		; set C if char > 8 and < 13

		eorb	#$FF
		cmpb	#$F7
		eorb	#$FF
		bcc	LC553
		cmpb	#$13

LC553		tst	zp_vdu_status			;	C553
		bmi	x_reenable_vdu_if_vdu6		;	vdu disabled
		pshs	CC
		jsr	[vduvar_VDU_VEC_JMP]
		puls	CC				;	C55B
		bcc	LC561				;	C55C
;; main exit routine
x_main_exit_routine
		lda	zp_vdu_status			;	C55E
		lsra					;	C560
LC561		
	IF CPU_6809
		pshs	B
		ldb	#$40
		bitb	zp_vdu_status
		puls	B				; TODO : get rid?
	ELSE
		tim	#$40, zp_vdu_status
	ENDIF
		beq	LC511RTS			;	C563
;; cursor editing routines
x_cursor_editing_routines
		jsr	x_start_cursor_edit_qry		;	C565

x_start_curs_edit					;LC568
		pshs	A,CC
		ldx	#$318				;	C56A
		ldy	#$364				;	C56C
		jsr	x_exchange_2atY_with_2atX	;	C56E
		jsr	x_set_up_displayaddress		;	C571
		ldx	zp_vdu_top_scanline
		jsr	x_set_cursor_position_X		;	C574
		lda	zp_vdu_status			;	C577
		eora	#$02				; toggle scrolling disabled
		sta	zp_vdu_status			;	C57B
		puls	A,CC,PC

;; ----------------------------------------------------------------------------
x_reenable_vdu_if_vdu6	
		eorb	#$06
		bne	LC5ACrts
		lda	#$7F
		bra	mos_VDU_and_A_vdustatus

;; ----------------------------------------------------------------------------
;; SET PAGED MODE  VDU 14;  
mos_VDU_14
		clr	sysvar_SCREENLINES_SINCE_PAGE	;	C58F
		lda	#$04				;	C592
		bra	x_ORA_with_vdu_status				;	C594

mos_VDU_21
		lda	#$80
x_ORA_with_vdu_status
		ora	zp_vdu_status			;	C59D
		bra	LC5AA				;	C59F
;; VDU 15 paged mode off	  No parameters
mos_VDU_15
		lda	#~$04
mos_VDU_and_A_vdustatus
		anda	zp_vdu_status			;	C5A8
LC5AA		sta	zp_vdu_status			;	C5AA
LC5ACrts	
		rts					;	C5AC
;; VDU 8	 CURSOR LEFT	 NO PARAMETERS
mos_VDU_8
		dec	vduvar_TXT_CUR_X		;	C5CA
		ldb	vduvar_TXT_CUR_X		;	C5CD
		cmpb	vduvar_TXT_WINDOW_LEFT		;	C5D0
		bmi	x_execute_wraparound_left_up	;	C5D3
		ldb	vduvar_6845_CURSOR_ADDR	+ 1	;	C5D5
		subb	vduvar_BYTES_PER_CHAR		;	C5D9
		lda	vduvar_6845_CURSOR_ADDR		;	C5DD
		sbca	#$00				;	C5E0
		cmpa	vduvar_SCREEN_BOTTOM_HIGH	;	C5E2
		bhs	LC5EA				;	C5E5
		adda	vduvar_SCREEN_SIZE_HIGH		;	C5E7
LC5EA		tfr	D,X				;	C5EA
		jmp	mos_set_cursor_X		;	C5EB
;; ----------------------------------------------------------------------------
;; execute wraparound left-up
x_execute_wraparound_left_up
		lda	vduvar_TXT_WINDOW_RIGHT		;	C5EE
		sta	vduvar_TXT_CUR_X		;	C5F1
;; cursor up
x_cursor_up
		dec	sysvar_SCREENLINES_SINCE_PAGE	;	C5F4
		bpl	LC5FC				;	C5F7
		inc	sysvar_SCREENLINES_SINCE_PAGE	;	C5F9
LC5FC		ldb	vduvar_TXT_CUR_Y		;	C5FC
		cmpb	vduvar_TXT_WINDOW_TOP		;	C5FF
		beq	x_cursor_at_top_of_window	;	C602
		dec	vduvar_TXT_CUR_Y		;	C604
		jmp	x_setup_displayaddress_and_cursor_position
;; ----------------------------------------------------------------------------
;; cursor at top of window
x_cursor_at_top_of_window
		CLC
		jsr	x_move_text_cursor_to_next_line ;	C60B
	IF CPU_6809
		lda	#$08				;	C60E
		bita	zp_vdu_status			;	C610
	ELSE
		tim	#$08, zp_vdu_status
	ENDIF
		bne	LC619				;	C612
		jsr	x_adjust_screen_RAM_addresses	;	C614
		bne	LC61C				;	C617
LC619		jsr	LCDA4				;	C619
LC61C		jmp	x_clear_a_line_then_setup_displayaddress_and_cursor_position				;	C61C

;; ----------------------------------------------------------------------------
;; VDU 11 Cursor Up    No Parameters
mos_VDU_11
		bra	x_cursor_up			;	C65E
;; VDU 9 Cursor right	No parameters
mos_VDU_9
		ldb	vduvar_TXT_CUR_X		;	C66A
		cmpb	vduvar_TXT_WINDOW_RIGHT		;	C66D
		bhs	x_text_cursor_down_and_right	;	C670
		inc	vduvar_TXT_CUR_X		;	C672
		ldx	vduvar_6845_CURSOR_ADDR
		ldb	vduvar_BYTES_PER_CHAR		;	C678
		abx
		jmp	mos_set_cursor_X		;	C681
;; ----------------------------------------------------------------------------
;; : text cursor down and right
x_text_cursor_down_and_right
		lda	vduvar_TXT_WINDOW_LEFT
		sta	vduvar_TXT_CUR_X
;; : text cursor down
x_text_cursor_down
		CLC
		jsr	x_control_scrolling_in_paged_mode_2
		ldb	vduvar_TXT_CUR_Y
		cmpb	vduvar_TXT_WINDOW_BOTTOM
		bhs	LC69B
		inc	vduvar_TXT_CUR_Y
		bra	x_setup_displayaddress_and_cursor_position
LC69B		jsr	x_move_text_cursor_to_next_line
	IF CPU_6809
		lda	#$08
		bita	zp_vdu_status
	ELSE
		tim	#$08, zp_vdu_status
	ENDIF
		bne	LC6A9
		jsr	x_adjust_screen_RAM_addresses_one_line_scroll
		bra	x_clear_a_line_then_setup_displayaddress_and_cursor_position
LC6A9		jsr	x_execute_upward_scroll
x_clear_a_line_then_setup_displayaddress_and_cursor_position
		jsr	x_clear_a_line
x_setup_displayaddress_and_cursor_position
		jsr	x_set_up_displayaddress
		ldx	zp_vdu_top_scanline
		jmp	x_set_cursor_position_X

;; ----------------------------------------------------------------------------
;; VDU 10  Cursor down	  No parameters
mos_VDU_10
		bra	x_text_cursor_down		;	C6F3
;; ----------------------------------------------------------------------------
;; VDU 28   define text window	      4 parameters; parameters are set up thus ; 0320  P1 left margin ; 0321  P2 bottom margin ; 0322  P3 right margin ; 0323  P4 top margin ; Note that last parameter is always in 0323 
mos_VDU_28
		ldb	vduvar_MODE
		ldx	#mostbl_vdu_window_bottom+1
		lda	vduvar_VDU_Q_END - 3
		cmpa	vduvar_VDU_Q_END - 1
		blo	LC758rts
		cmpa	b,x
		bhi	LC758rts
		lda	vduvar_VDU_Q_END - 2
		ldx	#mostbl_vdu_window_right
		cmpa	b,x
		bhi	LC758rts
		suba	vduvar_VDU_Q_END - 4
		bmi	LC758rts
		jsr	LCA88_newAPI
		lda	#$08
		jsr	x_ORA_with_vdu_status
		ldx	#vduvar_VDU_Q_END - 4
		ldy	#vduvar_TXT_WINDOW_LEFT
		jsr	copy4fromXtoY
		jsr	x_check_text_cursor_in_window_setup_display_addr
		bcs	mos_VDU_30
LC732_set_cursor_position
		ldx	zp_vdu_top_scanline				; CHECK!
		jmp	x_set_cursor_position_X
;; ----------------------------------------------------------------------------
;; OSWORD 9    read a pixel; on entry &EF=A=9 ; &F0=X=low byte of parameter blockFDBess ; &F1=Y=high byte of parameter blockFDBess ; PARAMETER BLOCK ; bytes 0,1 X coordinate, bytes 2,3 Y coordinate ; EXIT with result in byte 4 =&FF if point was of screen
;mos_OSWORD_9:
;	ldy	#$03				;	C735
;LC737:	lda	(zp_mos_OSBW_X),y		;	C737
;	sta	vduvar_TEMP_8,y		;	C739
;	dey					;	C73C
;	bpl	LC737				;	C73D
;	lda	#$28				;	C73F
;	jsr	x_pixel_reading			;	C741
;	ldy	#$04				;	C744
;	bne	LC750				;	C746
;; OSWORD 11	  read pallette; on entry &EF=A=11 ; &F0=X=low byte of parameter blockFDBess ; &F1=Y=high byte of parameter blockFDBess ; PARAMETER BLOCK ; bytes 0,logical colour to read		       ; EXIT with result in  4 bytes:-0 logical colour,1
;mos_OSWORD_11:
;	and	vduvar_COL_COUNT_MINUS1		;	C748
;	tax					;	C74B
;	lda	vduvar_PALLETTE,x		;	C74C
;LC74F:	iny					;	C74F
;LC750:	sta	(zp_mos_OSBW_X),y		;	C750
;	lda	#$00				;	C752
;	cpy	#$04				;	C754
;	bne	LC74F				;	C756
LC758rts
		rts					;	C758
;; ----------------------------------------------------------------------------
;; VDU 12  Clear text Screen		  0 parameters;	 
mos_VDU_12
		lda	zp_vdu_status
		anda	#$08
		lbeq	LCBC1_clear_whole_screen
LC767		ldb	vduvar_TXT_WINDOW_TOP
LC76A		stb	vduvar_TXT_CUR_Y
		jsr	x_clear_a_line
		ldb	vduvar_TXT_CUR_Y
		cmpb	vduvar_TXT_WINDOW_BOTTOM
		incb
		bcc	LC76A
;; VDU 30  Home cursor			  0  parameters
mos_VDU_30
LC781		clr	vduvar_VDU_Q_END - 1
		clr	vduvar_VDU_Q_END - 2
;; VDU 31  Position text cursor		  2  parameters; 0322 = X coordinate ; 0323 = Y coordinate 
mos_VDU_31
		jsr	LC7A8
		lda	vduvar_VDU_Q_END - 2
		adda	vduvar_TXT_WINDOW_LEFT
		sta	vduvar_TXT_CUR_X
		lda	vduvar_VDU_Q_END - 1
		adda	vduvar_TXT_WINDOW_TOP
		sta	vduvar_TXT_CUR_Y
		jsr	x_check_text_cursor_in_window_setup_display_addr
		bcc	LC732_set_cursor_position
LC7A8		ldx	#vduvar_TXT_CUR_X
		ldy	#vduvar_TEMP_8
		jmp	x_exchange_2atY_with_2atX
;; ----------------------------------------------------------------------------
;; VDU  13	  Carriage  Return	  0 parameters
mos_VDU_13
		beq	LC7B7				;	C7B2
LC7B7		jsr	x_cursor_to_window_left				;	C7B7
		jmp	x_setup_displayaddress_and_cursor_position				;	C7BA


;; ----------------------------------------------------------------------------
;; COLOUR; parameter in &0323 
mos_VDU_17	; COLOUR
		ldb	#$00				;	C7F9
		bra	LC7FF				;	C7FB
;; GCOL; parameters in 323,322 
mos_VDU_18	; GCOL
		ldb	#$02
LC7FF		lda	vduvar_VDU_Q_END - 1
		bpl	LC805
		incb
LC805		anda	vduvar_COL_COUNT_MINUS1
		sta	zp_vdu_wksp
		lda	vduvar_COL_COUNT_MINUS1
		beq	LC82B
		anda	#$07
		adda	zp_vdu_wksp
		ldx	#mostbl_2_colour_pixmasks-1
		lda	a,x
		ldy	#vduvar_TXT_FORE
		sta	b,y
		cmpb	#$02
		bhs	LC82C
		lda	vduvar_TXT_FORE
		coma
		sta	zp_vdu_txtcolourEOR
		eora	vduvar_TXT_BACK
		sta	zp_vdu_txtcolourOR
LC82B		rts
LC82C		lda	vduvar_VDU_Q_END - 2
		ldy	vduvar_GRA_FORE
		sta	b,y
		rts
;; ----------------------------------------------------------------------------
LC833		lda	#$20				;	C833
		sta	vduvar_TXT_BACK			;	C835
		rts					;	C838
;; ----------------------------------------------------------------------------
;; VDU 20	  Restore default colours	  0 parameters;	 
mos_VDU_20
		ldb	#$05				;	C839
		lda	#$00				;	C83B
		ldx	#vduvar_TXT_FORE
LC83D		sta	b,x				;	C83D
		decb					;	C840
		bpl	LC83D				;	C841
		ldb	vduvar_COL_COUNT_MINUS1		;	C843
		beq	LC833				;	C846
		lda	#$FF				;	C848
		cmpb	#$0F				;	C84A
		bne	LC850				;	C84C
		lda	#$3F				;	C84E
LC850		sta	vduvar_TXT_FORE			;	C850
		sta	vduvar_GRA_FORE			;	C853
		eora	#$FF				;	C856
		sta	zp_vdu_txtcolourOR		;	C858
		sta	zp_vdu_txtcolourEOR		;	C85A
		stb	vduvar_VDU_Q_END - 5		;	C85C
		cmpb	#$03				;	C85F
		beq	x_4_colour_mode			;	C861
		blo	LC885				;	C863
		stb	vduvar_VDU_Q_END - 4		;	C865
LC868		jsr	mos_VDU_19			;	C868
		dec	vduvar_VDU_Q_END - 4		;	C86B
		dec	vduvar_VDU_Q_END - 5		;	C86E
		bpl	LC868				;	C871
		rts					;	C873
;; ----------------------------------------------------------------------------
;; 4 colour mode
x_4_colour_mode
		ldb	#$07				;	C874
		stb	vduvar_VDU_Q_END - 4		;	C876
LC879		jsr	mos_VDU_19			;	C879
		lsr	vduvar_VDU_Q_END - 4		;	C87C
		dec	vduvar_VDU_Q_END - 5		;	C87F
		bpl	LC879				;	C882
		rts					;	C884
; ----------------------------------------------------------------------------
LC885		ldb	#$07				;	C885
		jsr	LC88F				;	C887
		ldb	#$00				;	C88A
		stb	vduvar_VDU_Q_END - 5;	C88C
LC88F		stb	vduvar_VDU_Q_END - 4			;	C88F
; VDU 19   define logical colours		  5 parameters; &31F=first parameter logical colour ; &320=second physical colour 
mos_VDU_19
		pshs	CC				; save flags
		SEI					; and disable interrupts
		ldb	vduvar_VDU_Q_END - 5		; b <= logical colour
		andb	vduvar_COL_COUNT_MINUS1		; 
		pshs	B
		lda	vduvar_VDU_Q_END - 4		; a <= physical colour
LC89E		anda	#$0F				; 
		ldx	#vduvar_PALLETTE		;
		sta	b,x				; store in saved palette TODO: where to store RGB? Don't store?

		ldb	vduvar_COL_COUNT_MINUS1		; a <= colours - 1


	IF MACH_BEEB
		stb	zp_mos_OS_wksp2			; wksp2 <= colours - 1
		cmpb	#$03				; compare to 3 
		;TODO - this is a bit of a kludge
;	exg	CC,A
;	eora	#CC_C
;	exg	A,CC					; swap Carry so its like on a 6502 and C=1 when a >= 3
		puls	B
		pshs	CC				; store Carry on the stack
							;	2 col		4 col		16 col
LC8AD		rorb					; 
		ror	zp_mos_OS_wksp2			;
		bcs	LC8AD				;
							; b=	$80		$C0		$F0
		asl	zp_mos_OS_wksp2			; wksp2=X0000000	XX000000	XXXX0000
							; a <= phys colour
		ora	zp_mos_OS_wksp2			; a <= LLLLPPPP
		sta	zp_mos_OS_wksp2

		clrb
LC8BA		puls	CC				; get back C,Z for COL_COUNT_MINUS1 <= 3
		pshs	CC				;	C8BB
		bne	mos_VDU19_sk1			;	C8BC
		anda	#$60				;	C8BE
		beq	LC8CB				;	C8C0
		cmpa	#$60				;	C8C2
		beq	LC8CB				;	C8C4
		lda	zp_mos_OS_wksp2
		eora	#$60				;	C8C7
		bne	mos_VDU19_sk1			;	C8C9
LC8CB		lda	zp_mos_OS_wksp2
mos_VDU19_sk1
		jsr	write_pallette_reg				; LC8CC
		addb	vduvar_COL_COUNT_MINUS1		;	C8D1
		incb
		lda	zp_mos_OS_wksp2
		adda	#$10				;	C8D6
		sta	zp_mos_OS_wksp2
		cmpb	#$10				;	C8D9
		blo	LC8BA				;	C8DB
		leas	1,S
		puls	CC,PC				;	C8DE	ENDIF
	ENDIF

	IF MACH_CHIPKIT
		; get left most pixel mask for this mode
		lda	#$80
		asrb
		asrb
		bcc	1F
		ora	#$08
		asrb
		bcc	1F
		ora	#$22

1		ldb	vduvar_COL_COUNT_MINUS1			; a <= colours - 1
		andb	#$07
		addb	,S+					; get back logical colour from stack
		ldx	#mostbl_2_colour_pixmasks-1
		anda	b,x					; palette entry to set
		sta	sheila_RAMDAC_ADDR_WR


		lda	vduvar_VDU_Q_END - 4			; a <= physical colour
		bita	#$10
		bne	mos_VDU_19_RGB

		jsr	onepalent				; normal colour
		lda	vduvar_VDU_Q_END - 4			; a <= physical colour
		bita	#$8
		beq	1F
		coma						; make flash colour complement
1		jsr	onepalent

		puls	CC,PC					;	C8DE
mos_VDU_19_RGB
		ldb	#2
		bita	#$01
		beq	1F					; if set then do flash only
		decb
		inc	sheila_RAMDAC_ADDR_WR
1		ldx	#vduvar_VDU_Q_END - 3
		jsr	2F
		jsr	2F
		jsr	2F
		decb
		bne	1B
		puls CC,PC
2		lda	,X+
		asra
		asra
		sta	sheila_RAMDAC_VAL
		rts
onepalent
		ldb	#3
		sta	zp_mos_OS_wksp2
1		clra
		ror	zp_mos_OS_wksp2
		bcc	2F
		deca
2		sta	sheila_RAMDAC_VAL
		decb
		bne	1B
		rts
	ENDIF

;; ----------------------------------------------------------------------------
;; OSWORD 12    WRITE PALLETTE; on entry X=&F0:Y=&F1:YX points to parameter block ; byte 0 = logical colour;  byte 1 physical colour; bytes 2-4=0 
;mos_OSWORD_12:
;	php					;	C8E0
;	and	vduvar_COL_COUNT_MINUS1		;	C8E1
;	tax					;	C8E4
;	iny					;	C8E5
;	lda	(zp_mos_OSBW_X),y		;	C8E6
;	jmp	LC89E				;	C8E8
;; ----------------------------------------------------------------------------
;; VDU	  22		  Select Mode	1 parameter; parameter in &323 
mos_VDU_22
		lda	vduvar_VDU_Q_END - 1			;	C8EB
		jmp	mos_VDU_set_mode		;	C8EE
;; ----------------------------------------------------------------------------
;; VDU 23 Define characters		  9 parameters; parameters are:- ; 31B character to define ; 31C to 323 definition 
mos_VDU_23
		TODOSKIP	"VDU 23"
		rts
;	lda	vduvar_VDU_Q_END - 9;	C8F1
;	cmp	#$20				;	C8F4
;	bcc	x_set_CRT_controller		;	C8F6
;	pha					;	C8F8
;	lsr	a				;	C8F9
;	lsr	a				;	C8FA
;	lsr	a				;	C8FB
;	lsr	a				;	C8FC
;	lsr	a				;	C8FD
;	tax					;	C8FE
;	lda	mostbl_VDU_pix_mask_2colour,x	;	C8FF
;	bit	vduvar_EXPLODE_FLAGS		;	C902
;	bne	LC927				;	C905
;	ora	vduvar_EXPLODE_FLAGS		;	C907
;	sta	vduvar_EXPLODE_FLAGS		;	C90A
;	txa					;	C90D
;	and	#$03				;	C90E
;	clc					;	C910
;	adc	#$BF				;	C911
;	sta	zp_vdu_wksp+5			;	C913
;	lda	vduvar_EXPLODE_FLAGS,x		;	C915
;	sta	zp_vdu_wksp+3			;	C918
;	ldy	#$00				;	C91A
;	sty	zp_vdu_wksp+2			;	C91C
;	sty	zp_vdu_wksp+4			;	C91E
;LC920:	lda	(zp_vdu_wksp+4),y		;	C920
;	sta	(zp_vdu_wksp+2),y		;	C922
;	dey					;	C924
;	bne	LC920				;	C925
;LC927:	pla					;	C927
;	jsr	x_calc_pattern_addr_for_given_char;	C928
;	ldy	#$07				;	C92B
;LC92D:	lda	$031C,y				;	C92D
;	sta	(zp_vdu_wksp+4),y		;	C930
;	dey					;	C932
;	bpl	LC92D				;	C933
;	rts					;	C935
;; ----------------------------------------------------------------------------
;	pla					;	C936
;LC937:	rts					;	C937
;; ----------------------------------------------------------------------------
;; VDU EXTENSION
x_VDU_EXTENSION
		lda	vduvar_VDU_Q_END - 5		;	C938
		CLC					;	C93B

jmp_VDUV					; LC93C
		jmp	[VDUV]				;	C93C
;; ----------------------------------------------------------------------------
;; set CRT controller
x_set_CRT_controller
		cmpa	#$01				;	C93F
		blo	LC958				; VDU 23,0,R,X - set (R)eg to (X) in CRTC
		bne	jmp_VDUV			;	C943
		ASSERT "Unexpected in x_set_CRT_controller"
;	jsr	x_check_text_cursor_in_use	;	C945
;	bne	LC937				;	C948
;	lda	#$20				;	C94A
;	ldy	vduvar_VDU_Q_END - 8		;	C94C
;	beq	x_crtc_set_cursor		;	C94F
x_crtc_reset_cursor				; LC951
		lda	vduvar_CUR_START_PREV		;	C951
x_crtc_set_cursor
		ldb	#$0A				;	C954
		bra	LC985				;	C956
LC958
		lda	vduvar_VDU_Q_END - 7		;	C958
		ldb	vduvar_VDU_Q_END - 8		;	C95B
mos_set_6845_regBtoA
		cmpb	#$07				;	C95E
		blo	LC985				;	C960
		bne	LC967				;	C962
		adda	oswksp_VDU_VERTADJ		;	C964
LC967		cmpb	#$08				;	C967
		bne	LC972				;	C969
		tsta					;	C96B
		bmi	LC972				;	C96D
		eora	oswksp_VDU_INTERLACE		;	C96F
LC972		cmpb	#$0A				;	C972
		bne	LC985				;	C974
		sta	vduvar_CUR_START_PREV		;	C976
		tfr	a,b				;	C979
		lda	zp_vdu_status			;	C97A
		anda	#$20				;	C97C
		pshs	CC				;	C97E
		tfr	b,a				;	C97F
		ldb	#$0A				;	C980
		puls	CC				;	C982
		bne	LC98B				;	C983
LC985		stb	sheila_CRTC_reg			;	C985
		sta	sheila_CRTC_rw			;	C988
LC98B		rts					;	C98B
;; adjust screen RAMFDBesses
x_adjust_screen_RAM_addresses
		ldd	vduvar_6845_SCREEN_START	
		jsr	x_subtract_bytes_per_line_from_D
		bcc	LC9B3
		adda	vduvar_SCREEN_SIZE_HIGH
		bcc	LC9B3
x_adjust_screen_RAM_addresses_one_line_scroll	
		ldd	vduvar_BYTES_PER_ROW
		addd	vduvar_6845_SCREEN_START
		bpl	LC9B3
		suba	vduvar_SCREEN_SIZE_HIGH
LC9B3		std	vduvar_6845_SCREEN_START
		tfr	D,X
		lda	#$0C
		bra	x_set_6845_screenstart_from_X
;; VDU 26  set default windows		  0 parameters
mos_VDU_26
		clra
		ldb	#$2C
		ldx	#vduvar_GRA_WINDOW_LEFT
LC9C1		sta	b,x
		decb					;	C9C4
		bpl	LC9C1				;	C9C5
		lda	vduvar_MODE			;	C9C7
		m_tax
		lda	mostbl_vdu_window_right,x	;	C9CA
		sta	vduvar_TXT_WINDOW_RIGHT		;	C9CD
		jsr	LCA88_newAPI			;	C9D0
		lda	mostbl_vdu_window_bottom+1,x	;	C9D3
		sta	vduvar_TXT_WINDOW_BOTTOM	;	C9D6
		ldb	#$03				;	C9D9
		stb	vduvar_VDU_Q_END - 1			;	C9DB
		incb					;	C9DE
		stb	vduvar_VDU_Q_END - 3			;	C9DF
		dec	vduvar_VDU_Q_END - 2			;	C9E2
		dec	vduvar_VDU_Q_END - 4			;	C9E5
;;		jsr	mos_VDU_24			;	C9E8
		lda	#$F7				;	C9EB
		jsr	mos_VDU_and_A_vdustatus		;	C9ED
		ldx	vduvar_6845_SCREEN_START	;	C9F0
mos_set_cursor_X
		stx	vduvar_6845_CURSOR_ADDR		;	C9F6
		cmpx	#$8000
		blo	x_set_cursor_position_X
		pshs	D
		tfr	X,D
		suba	vduvar_SCREEN_SIZE_HIGH
		tfr	D,X
		puls	D
;; set cursor position
x_set_cursor_position_X
		stx	zp_vdu_top_scanline
		ldx	vduvar_6845_CURSOR_ADDR
		lda	#$0E
x_set_6845_screenstart_from_X			; LCA0E
		ldb	vduvar_MODE
		cmpb	#$07
		bhs	LCA27
		exg	X,D
		lsra
		rorb
		lsra
		rorb
		lsra
		rorb
		exg	X,D
		bra	mos_stx_6845rA			;	CA24
;; ----------------------------------------------------------------------------
LCA27		
		exg	X,D
		suba	#$74				;	CA27
		eora	#$20				;	CA29
		exg	D,X
mos_stx_6845rA
		pshs	X
		ldb	,S+
		std	sheila_CRTC_reg
		inca
		ldb	,S+
		std	sheila_CRTC_reg
		puls	PC				;	CA38

db_endian_vdu_q_swap
		***********************************************
		* BODGE: endianness swap for VDU drivers      *
		* This is subject to change                   *
		*                                             *
		* workspace vars are all in big endian        *
		* Q is in little endian so swap all the bytes *
		* Y contain number of 16 bit params at end of *
		* Q to swap				      *
		***********************************************
		ldx	#vduvar_VDU_Q_END
1		ldd	,--X
		exg	A,B
		std	,X
		leay	-1,Y
		bne	1B
		rts



;; ----------------------------------------------------------------------------
LCA88_newAPI
		; old API (y == window width in chars - 1)
		; new API (a == window width in chars - 1)
		inca
		ldb	vduvar_BYTES_PER_CHAR
		mul
		std	vduvar_TXT_WINDOW_WIDTH_BYTES
LCAA1		rts					;	CAA1
;; ----------------------------------------------------------------------------
;; VDU 32  (&7F)	  Delete			  0 parameters
mos_VDU_127					; LCAAC
		jsr	mos_VDU_8			;cursor left
		ldb	vduvar_COL_COUNT_MINUS1		;number of logical colours less 1
		beq	LCAC2				;if mode 7 CAC2
		ldd	#mostbl_chardefs
		std	zp_vdu_wksp+4			;store in &DF (&DE) now points to C300 SPACE pattern
		jmp	LCFBF_renderchar2		;display a space
;; ----------------------------------------------------------------------------
LCAC2		lda	#$20				;A=&20
		jmp	x_convert_teletext_characters	;and return to display a space
;; ----------------------------------------------------------------------------
;; control scrolling in paged mode
x_control_scrolling_in_paged_mode		; LCAE0
		jsr	x_zero_paged_mode_counter
x_control_scrolling_in_paged_mode_2
		jsr	mos_OSBYTE_118
		bcc	LCAEA
		bmi	x_control_scrolling_in_paged_mode
LCAEA		lda	zp_vdu_status
		eora	#$04
		anda	#$46
		bne	LCB1Crts
		lda	sysvar_SCREENLINES_SINCE_PAGE
		bmi	LCB19
		lda	vduvar_TXT_CUR_Y
		cmpa	vduvar_TXT_WINDOW_BOTTOM
		blo	LCB19
		lsra
		lsra
		SEC
		adca	sysvar_SCREENLINES_SINCE_PAGE
		adca	vduvar_TXT_WINDOW_TOP
		cmpa	vduvar_TXT_WINDOW_BOTTOM
		blo	LCB19
		CLC
LCB0E		jsr	mos_OSBYTE_118
		SEC
		bpl	LCB0E
;; zero paged mode  counter
x_zero_paged_mode_counter
		lda	#$FF				;	CB14
		sta	sysvar_SCREENLINES_SINCE_PAGE	;	CB16
LCB19		inc	sysvar_SCREENLINES_SINCE_PAGE	;	CB19
LCB1Crts
		rts




;; ----------------------------------------------------------------------------
;; Set vdu vars to 0, called with mode in A
mos_VDU_init					; LCB1D
		pshs	A				;	CB1D
		ldb	#$7F				;	CB1E
		clra				;	CB20
		sta	zp_vdu_status			;	CB22
		ldx	#vduvars_start
; clear vdu vars block
1		sta	,X+				;	CB24
		decb
		bne	1B				;	CB28
;; no explode status always all at E100
;;		clr	zp_mos_OSBW_X
;;		jsr	mos_OSBYTE_20			;	CB2A
		puls	A				;	CB2D
		ldb	#$7F				;	CB2E
		stb	vduvar_MO7_CUR_CHAR		;	CB30

mos_VDU_set_mode
		; TODO remove this
;;	tst	sysvar_RAM_AVAIL		;	CB33
;;	bmi	mos_VDU_set_mode_gt16Ksk	;	CB36
;;	ora	#$04				;	CB38
;;;; Skip if > 16k memory available
;;mos_VDU_set_mode_gt16Ksk
		anda	#$07
	IF MACH_CHIPKIT
		; TODO - remove this bodge for chipkit mk1 (no mode 7!) see also mos_OSBYTE_133
		cmpa	#7
		bne	1F
		lda	#6
1		
	ENDIF
		sta	vduvar_MODE
		ldx	#mostbl_VDU_mode_colours_m1
		ldb	a,x
		stb	vduvar_COL_COUNT_MINUS1
		ldx	#mostbl_VDU_bytes_per_char
		ldb	a,x
		stb	vduvar_BYTES_PER_CHAR
		ldx	#mostbl_VDU_pixels_per_byte_m1
		ldb	a,x
		stb	vduvar_PIXELS_PER_BYTE_MINUS1
		bne	mos_VDU_set_mode_bmsk1
		ldb	#$07
		;; bytes per pixel 1 => 8?
mos_VDU_set_mode_bmsk1
		aslb
		ldx	#mostbl_VDU_pix_mask_16colour - 1
		lda	b,x;	CB58	
		sta	vduvar_RIGHTMOST_PIX_MASK	;	CB5B
		;; shunt bitmask to leftmost
1		asla
		bpl	1B				;	CB5F
		sta	vduvar_LEFTMOST_PIX_MASK	;	CB61
		ldx	#mostbl_VDU_mode_size
		lda	vduvar_MODE
		ldb	a,x
		stb	vduvar_MODE_SIZE
		clra
		tfr	D,X
	IF MACH_BEEB
		lda	mostbl_VDU_hwscroll_offb2,x
		jsr	mos_poke_SYSVIA_orb
		lda	mostbl_VDU_hwscroll_offb1,x
		jsr	mos_poke_SYSVIA_orb		;	CB6D
	ENDIF
	IF MACH_CHIPKIT
		lda	mostbl_VDU_hwscroll_offs,x
		sta	SHEILA_MEMC_SCROFF
	ENDIF
		lda	mostbl_VDU_screensize_h,x	;	CB76
		sta	vduvar_SCREEN_SIZE_HIGH		;	CB79
		lda	mostbl_VDU_screebot_h,x		;	CB7C
		sta	vduvar_SCREEN_BOTTOM_HIGH	;	CB7F
;; A=((y+2)^7)>>1; 0=>2; 1=>2; 2=>1; 3=>1; 4=>0
;;	lda	vduvar_MODE_SIZE		;	CB82
		addb	#$02				;	CB83
		eorb	#$07				;	CB85
		lsrb					;	CB87
		clra
		tfr	D,X
		stb	vduvar_BYTES_PER_ROW
		lda	mostbl_VDU_bytes_per_row_low,x
		sta	vduvar_BYTES_PER_ROW + 1
		lda	#$43				;	CB9B

	IF MACH_CHIPKIT
		; Setup RAMDAC / VIDC stuff
		lda	#$FF
		sta	sheila_RAMDAC_PIXMASK

		ldb	vduvar_COL_COUNT_MINUS1		; a <= colours - 1

		; get left most pixel mask for this mode
		lda	#$80
		asrb
		asrb
		bcc	1F
		ora	#$08
		asrb
		bcc	1F
		ora	#$22
1		; a now contains a left most pixel mask

		; store in RAMDAC pixel mask (TODO: move to MODE change/boot?)
		sta	sheila_VIDULA_pixand
	ENDIF

		jsr	mos_VDU_and_A_vdustatus		;	CB9D
		lda	vduvar_MODE			;	CBA0
		ldx	#mostbl_VDU_VIDPROC_CTL_by_mode
		lda	a,x				;	CBA3
		jsr	mos_VIDPROC_set_CTL		;	CBA6
		pshs	CC				;	CBA9
		; Send commands from table for current mode size to 6845
mos_send6845
		SEI			; interrupts off
		ldx	#mostbl_VDU_ptr_end_6845tab
		ldb	vduvar_MODE_SIZE
		ldb	b,x
		ldx	#mostbl_VDU_6845_mode_012
		abx
		ldb	#$0B				
mos_send6845lp					; LCBB0
		lda	,-x				;	CBB0
		jsr	mos_set_6845_regBtoA		;	CBB3
		decb					;	CBB7
		bpl	mos_send6845lp			;	CBB8
		puls	CC				; interrupts back
		jsr	mos_VDU_20			; default logical colours
		jsr	mos_VDU_26			; default windows
LCBC1_clear_whole_screen
		lda	vduvar_SCREEN_BOTTOM_HIGH
		sta	vduvar_6845_SCREEN_START
		clrb
		tfr	D,X
		stx	vduvar_6845_SCREEN_START
		jsr	mos_set_cursor_X		;	CBCC
		lda	#$0C				;	CBCF
		jsr	mos_stx_6845rA			;	CBD1

		ldb	sheila_ROMCTL_MOS
		pshs	B
		andb	#~ROMCTL_BITS_FLEX
		stb	sheila_ROMCTL_MOS


;;	lda	vduvar_TXT_BACK			;	CBD4
		ldb	vduvar_MODE_SIZE		;	CBD7
;;;	aslb
		clr	sysvar_SCREENLINES_SINCE_PAGE	;	CBE7
		clr	vduvar_TXT_CUR_X		;	CBEA
		clr	vduvar_TXT_CUR_Y		;	CBED
		ldx	#mostbl_VDU_screensize_h


	IF CPU_6809
		; TODO: make this quicker?
		lda	B,X				; get # bytes to clear (high in A)
		clrb
		tfr	D,Y
		lda	vduvar_TXT_BACK
		ldx	vduvar_6845_SCREEN_START
1		sta	,X+
		leay	-1,Y
		bne	1B
	ELSE
		pshsw
		lde	B,X				; get # bytes to clear (high in E)
		clrf
		;decw
		ldx	vduvar_6845_SCREEN_START
		ldy	#vduvar_TXT_BACK
		tfm	Y,X+
		pulsw
	ENDIF

		puls	B
		stb	sheila_ROMCTL_MOS

		rts
;; ----------------------------------------------------------------------------
;; subtract bytes per line from X/A
; note new API, address in D instead of X/A and carry flag is opposite sense
x_subtract_bytes_per_line_from_D
		subd	vduvar_BYTES_PER_ROW
		cmpa	vduvar_SCREEN_BOTTOM_HIGH
LCD06		rts					;	CD06

;; ----------------------------------------------------------------------------
;; :move text cursor to next line (direction up/down depends on CC_C)
x_move_text_cursor_to_next_line
		lda	zp_vdu_status
		bita	#$02
		bne	LCD47				; scrolling disabled
		bita	#$40
		beq	LCD65rts			; curor editing
LCD47		ldb	vduvar_TXT_WINDOW_BOTTOM	; if carry set on entry get TOP else get BOTTOM
		bcc	LCD4F				
		ldb	vduvar_TXT_WINDOW_TOP		
LCD4F		bita	#$40
		bne	LCD59				; if cursor editing
		stb	vduvar_TXT_CUR_Y		
		leas	2,S				; skip return and setup address and cursor
		jmp	x_setup_displayaddress_and_cursor_position
;; ----------------------------------------------------------------------------
LCD59		pshs	CC				;	CD59
		cmpb	vduvar_TEXT_IN_CUR_Y		;	CD5A
		beq	1F				;	CD5D
		puls	CC				;	CD5F
		bcc	LCD66				;	CD60
		dec	vduvar_TEXT_IN_CUR_Y		;	CD62
LCD65rts
		rts
1		puls	CC,PC
;; ----------------------------------------------------------------------------
LCD66		inc	vduvar_TEXT_IN_CUR_Y		;	CD66
		rts					;	CD69
;; ----------------------------------------------------------------------------
;; set up write cursor
x_set_up_write_cursor
		pshs	A,B,CC,X
		ldb	vduvar_BYTES_PER_CHAR
		decb
		ldx	zp_vdu_top_scanline
		bne	LCD8F				; it's not MO.7
		lda	vduvar_GRA_WKSP+8
		sta	,X				; restore original MO.7 character?
		puls	A,B,CC,X,PC

;;	php					;	CD6A
;;	pha					;	CD6B
;;	ldy	vduvar_BYTES_PER_CHAR		;	CD6C
;;	dey					;	CD6F
;;	bne	LCD8F				;	CD70
;;	lda	vduvar_GRA_WKSP+8		;	CD72
;;	sta	(zp_vdu_top_scanline),y		;	CD75

;;LCD77:	pla					;	CD77
;;LCD78:	plp					;	CD78
;;LCD79:	rts					;	CD79
;; ----------------------------------------------------------------------------
x_start_cursor_edit_qry	
		pshs	A,B,CC,X
		ldx	zp_vdu_top_scanline
		ldb	vduvar_BYTES_PER_CHAR			;bytes per character
		decb						;
		bne	LCD8F					;if not mode 7
		lda	,x					;get cursor from top scan line
		sta	vduvar_GRA_WKSP+8			;store it
		lda	vduvar_MO7_CUR_CHAR			;mode 7 write cursor character
		sta	,x					;store it at scan line
		puls	A,B,CC,X,PC				;and exit

;; ----------------------------------------------------------------------------
LCD8F		lda	#$FF					;A=&FF =cursor
		cmpb	#$1F					;except in mode 2 (Y=&1F)
		bne	x_produce_white_block_write_cursor	;if not CD97
		lda	#$3F					;load cursor byte mask
;; produce white block write cursor
x_produce_white_block_write_cursor
		sta	zp_vdu_wksp			;	CD97
1		lda	,x				;	CD99
		eora	zp_vdu_wksp			;	CD9B
		sta	,x+				;	CD9D
		decb					;	CD9F
		bpl	1B				;	CDA0
;;;	bmi	LCD77				;	CDA2
		puls	A,B,CC,X,PC


LCDA4
		jsr	x_exchange_TXTCUR_wksp_doublertsifwindowempty ; also saves height in wksp+4
		lda	vduvar_TXT_WINDOW_BOTTOM	;	CDA7
		sta	vduvar_TXT_CUR_Y		;	CDAA
		jsr	x_set_up_displayaddress	;	CDAD
LCDB0		jsr	x_subtract_bytes_per_line_from_D;	CDB0
		bcc	LCDB8				;	CDB3
		adda	vduvar_SCREEN_SIZE_HIGH		;	CDB5
LCDB8		std	zp_vdu_wksp			;	CDB8
		sta	zp_vdu_wksp+2			;	CDBC
		bcs	LCDC6				;	CDBE
LCDC0		jsr	LCE73				;	CDC0
		bra	LCDCE
;; ----------------------------------------------------------------------------
LCDC6		jsr	x_subtract_bytes_per_line_from_D;	CDC6
		bcs	LCDC0				;	CDC9
		jsr	x_copy_routines			;	CDCB
LCDCE		lda	zp_vdu_wksp+2			;	CDCE
		ldb	zp_vdu_wksp+1			;	CDD0
		std	zp_vdu_top_scanline		;	CDD2
		dec	zp_vdu_wksp+4
		bne	LCDB0

x_exchange_TXT_CUR_with_BITMAP_READ		; LCDDA
		ldx	#vduvar_TEMP_8
		ldy	#vduvar_TXT_CUR_X
x_exchange_2atY_with_2atX			; LCDDE
		ldb	#$02				;	CDDE TODO: this is a straigh 16 bit copy do something better?
		bra	x_exchange_B_atY_with_B_atX	;	CDE0
x_exg4atGRACURINTwithGRACURINTOLD			; LCDE2
		ldx	#vduvar_GRA_CUR_INT		;	CDE2
x_exg4atGRACURINTOLDwithX				; LCDE4
		ldy	#vduvar_GRA_CUR_INT_OLD		;	CDE4
x_exchange_4atY_with_4atX
		ldb	#$04				;	CDE6
;; exchange (300/300+A)+Y with (300/300+A)+X
x_exchange_B_atY_with_B_atX
		stb	zp_vdu_wksp			;	CDE8
LCDEA		lda	,x
		ldb	,y
		sta	,y+
		stb	,x+
		dec	zp_vdu_wksp			;	CDFA
		bne	LCDEA				;	CDFC
		rts					;	CDFE
;; ----------------------------------------------------------------------------
;; execute upward scroll;  
x_execute_upward_scroll
		TODO	"x_execute_upward_scroll"
;	jsr	x_exchange_TXTCUR_wksp_doublertsifwindowempty				;	CDFF
;	ldy	vduvar_TXT_WINDOW_TOP		;	CE02
;	sty	vduvar_TXT_CUR_Y		;	CE05
;	jsr	x_set_up_displayaddress	;	CE08
;LCE0B:	jsr	x_Add_number_of_bytes_in_a_line_to_XA;	CE0B
;	bpl	LCE14				;	CE0E
;	sec					;	CE10
;	sbc	vduvar_SCREEN_SIZE_HIGH		;	CE11
;LCE14:	sta	zp_vdu_wksp+1			;	CE14
;	stx	zp_vdu_wksp			;	CE16
;	sta	zp_vdu_wksp+2			;	CE18
;	bcc	LCE22				;	CE1A
;LCE1C:	jsr	LCE73				;	CE1C
;	jmp	LCE2A				;	CE1F
;; ----------------------------------------------------------------------------
;LCE22:	jsr	x_Add_number_of_bytes_in_a_line_to_XA;	CE22
;	bmi	LCE1C				;	CE25
;	jsr	x_copy_routines			;	CE27
;LCE2A:	lda	zp_vdu_wksp+2			;	CE2A
;	ldx	zp_vdu_wksp			;	CE2C
;	sta	zp_vdu_top_scanline+1		;	CE2E
;	stx	zp_vdu_top_scanline		;	CE30
;	dec	zp_vdu_wksp+4			;	CE32
;	bne	LCE0B				;	CE34
;	beq	x_exchange_TXT_CUR_with_BITMAP_READ				;	CE36
;; copy routines
x_copy_routines
		ldd	vduvar_TXT_WINDOW_WIDTH_BYTES
		ldx	zp_vdu_wksp
		ldy	zp_vdu_top_scanline
1		lda	,x+
		sta	,y+
		subd	#1
		bne	1B
		rts					;	CE5A
;; ----------------------------------------------------------------------------
x_exchange_TXTCUR_wksp_doublertsifwindowempty	
		jsr	x_exchange_TXT_CUR_with_BITMAP_READ
		lda	vduvar_TXT_WINDOW_BOTTOM	;	CE5F
		suba	vduvar_TXT_WINDOW_TOP		;	CE62
		sta	zp_vdu_wksp+4			;	CE65
		bne	x_cursor_to_window_left				;	CE67
		leas	2,S
		jmp	x_exchange_TXT_CUR_with_BITMAP_READ	; if no text window pull return address, put back cursor and exit parent subroutine
;; ----------------------------------------------------------------------------
x_cursor_to_window_left	
		lda	vduvar_TXT_WINDOW_LEFT		
		bra	LCEE3_sta_TXT_CUR_X_setC_rts

LCE73
		TODO "LCE73"
;LCE73:	lda	zp_vdu_wksp			;	CE73 TODO copy lines of text - scroll window?
;	pha					;	CE75
;	sec					;	CE76
;	lda	vduvar_TXT_WINDOW_RIGHT		;	CE77
;	sbc	vduvar_TXT_WINDOW_LEFT		;	CE7A
;	sta	zp_vdu_wksp+5			;	CE7D
;LCE7F:	ldy	vduvar_BYTES_PER_CHAR		;	CE7F
;	dey					;	CE82
;LCE83:	lda	(zp_vdu_wksp),y			;	CE83
;	sta	(zp_vdu_top_scanline),y		;	CE85
;	dey					;	CE87
;	bpl	LCE83				;	CE88
;	ldx	#$02				;	CE8A
;LCE8C:	clc					;	CE8C
;	lda	zp_vdu_top_scanline,x		;	CE8D
;	adc	vduvar_BYTES_PER_CHAR		;	CE8F
;	sta	zp_vdu_top_scanline,x		;	CE92
;	lda	zp_vdu_top_scanline+1,x		;	CE94
;	adc	#$00				;	CE96
;	bpl	LCE9E				;	CE98
;	sec					;	CE9A
;	sbc	vduvar_SCREEN_SIZE_HIGH		;	CE9B
;LCE9E:	sta	zp_vdu_top_scanline+1,x		;	CE9E
;	dex					;	CEA0
;	dex					;	CEA1
;	beq	LCE8C				;	CEA2
;	dec	zp_vdu_wksp+5			;	CEA4
;	bpl	LCE7F				;	CEA6
;	pla					;	CEA8
;	sta	zp_vdu_wksp			;	CEA9
;	rts					;	CEAB
;; ----------------------------------------------------------------------------
;; clear a line
x_clear_a_line
		lda	vduvar_TXT_CUR_X
		pshs	A
		jsr	x_cursor_to_window_left
		jsr	x_set_up_displayaddress
		lda	vduvar_TXT_WINDOW_RIGHT
		suba	vduvar_TXT_WINDOW_LEFT
		sta	zp_vdu_wksp+2
		ldx	zp_vdu_top_scanline
		lda	vduvar_TXT_BACK
		ldb	sheila_ROMCTL_MOS
		pshs	B
		andb	#~ROMCTL_BITS_FLEX
		stb	sheila_ROMCTL_MOS

LCEBF		ldb	vduvar_BYTES_PER_CHAR
LCEC5		sta	,X+
		decb
		bne	LCEC5
		cmpx	#$8000
		blo	LCEDA
		lda	vduvar_SCREEN_SIZE_HIGH
		nega
		clrb
		leax	D,X
		lda	vduvar_TXT_BACK
LCEDA		dec	zp_vdu_wksp+2
		bpl	LCEBF
		puls	B
		stb	sheila_ROMCTL_MOS
		stx	zp_vdu_top_scanline
		puls	A
LCEE3_sta_TXT_CUR_X_setC_rts	
		sta	vduvar_TXT_CUR_X
LCEE6_setC_rts
		SEC
		rts
;; ----------------------------------------------------------------------------
x_check_text_cursor_in_window_setup_display_addr
		ldb	vduvar_TXT_CUR_X
		cmpb	vduvar_TXT_WINDOW_LEFT
		bmi	LCEE6_setC_rts
		cmpb	vduvar_TXT_WINDOW_RIGHT
		beq	LCEF7
		bpl	LCEE6_setC_rts
LCEF7		ldb	vduvar_TXT_CUR_Y
		cmpb	vduvar_TXT_WINDOW_TOP
		bmi	LCEE6_setC_rts
		cmpb	vduvar_TXT_WINDOW_BOTTOM
		beq	x_set_up_displayaddress
		bpl	LCEE6_setC_rts
;; set up displayaddressess
; 
; Mode 0: (0319)*640+(0318)* 8 		0
; Mode 1: (0319)*640+(0318)*16 		0
; Mode 2: (0319)*640+(0318)*32 		0
; Mode 3: (0319)*640+(0318)* 8 		1
; Mode 4: (0319)*320+(0318)* 8 		2
; Mode 5: (0319)*320+(0318)*16 		2
; Mode 6: (0319)*320+(0318)* 8 		3
; Mode 7: (0319)* 40+(0318)  		4
 ;this gives a displacement relative to the screen RAM start address
 ;which is added to the calculated number and stored in in 34A/B
 ;if the result is less than &8000, the top of screen RAM it is copied into X/A
 ;and D8/9.  
 ;if the result is greater than &7FFF the hi byte of screen RAM size is
 ;subtracted to wraparound the screen. X/A, D8/9 are then set from this

x_set_up_displayaddress
		lda	vduvar_TXT_CUR_Y
		ldb	vduvar_MODE_SIZE
		cmpb	#4
		beq	x_set_up_displayaddress_mo7
		cmpb	#2
		bhs	x_set_up_displayaddress_320
		ldb	#160
		mul
		aslb
		rola
x_set_up_displayaddress_sk1
		aslb
		rola
x_set_up_displayaddress_sk2
		addd	vduvar_6845_SCREEN_START
		std	zp_vdu_top_scanline
		lda	vduvar_TXT_CUR_X
		ldb	vduvar_BYTES_PER_CHAR
		mul
		addd	zp_vdu_top_scanline
		std	vduvar_6845_CURSOR_ADDR
		bpl	x_set_up_displayaddress_nowrap
		suba	vduvar_SCREEN_SIZE_HIGH
x_set_up_displayaddress_nowrap
		std	zp_vdu_top_scanline

		rts
x_set_up_displayaddress_320
		ldb	#160
		mul
		bra	x_set_up_displayaddress_sk1
x_set_up_displayaddress_mo7
		ldb	#40
		mul
		bra	x_set_up_displayaddress_sk2



render_char
		ldb	vduvar_COL_COUNT_MINUS1
		beq	x_convert_teletext_characters
		jsr	x_calc_pattern_addr_for_given_char
LCFBF_renderchar2
;;		lda	zp_vdu_status			;	CFC2
;;		anda	#$20				;	CFC4
;;		bne	x_Graphics_cursor_display_routine;	CFC6
		ldx	zp_vdu_wksp + 4
render_logo2

		; MINIMOS - page in screen memory
		ldb	sheila_ROMCTL_MOS
		pshs	B
		andb	#~ROMCTL_BITS_FLEX
		stb	sheila_ROMCTL_MOS


		ldb	#7
		ldy	zp_vdu_top_scanline
		lda	vduvar_COL_COUNT_MINUS1		;	CFBF
		cmpa	#$03				;	CFCA
		beq	render_char_4colour		;	CFCC
		lbhi	render_char_16colour		;	CFCE
*LCFD0	lda	B,X						;4+1		2
*	ora	zp_vdu_txtcolourOR				;4		2
*	eora	zp_vdu_txtcolourEOR				;4		2
*	sta	B,Y						;4+1		2
*	decb							;2		1
*	bpl	LCFD0						;3		2
*								;23		11
*								;x8=184

		ldd	,X++						;5+1		2
		ora	zp_vdu_txtcolourOR				;4		2
		eora	zp_vdu_txtcolourEOR				;4		2
		orb	zp_vdu_txtcolourOR				;4		2
		eorb	zp_vdu_txtcolourEOR				;4		2
		std	,Y++						;5+1		2

		ldd	,X++						;5+1		2
		ora	zp_vdu_txtcolourOR				;4		2
		eora	zp_vdu_txtcolourEOR				;4		2
		orb	zp_vdu_txtcolourOR				;4		2
		eorb	zp_vdu_txtcolourEOR				;4		2
		std	,Y++						;5+1		2

		ldd	,X++						;5+1		2
		ora	zp_vdu_txtcolourOR				;4		2
		eora	zp_vdu_txtcolourEOR				;4		2
		orb	zp_vdu_txtcolourOR				;4		2
		eorb	zp_vdu_txtcolourEOR				;4		2
		std	,Y++						;5+1		2

		ldd	,X++						;5+1		2
		ora	zp_vdu_txtcolourOR				;4		2
		eora	zp_vdu_txtcolourEOR				;4		2
		orb	zp_vdu_txtcolourOR				;4		2
		eorb	zp_vdu_txtcolourEOR				;4		2
		std	,Y++						;5+1		2

		puls	b
		stb	sheila_ROMCTL_MOS

		rts					;	CFDB
;;render_logox4
;;		jsr	render_logox2
;;render_logox2
;;		jsr	render_logo
;;render_logo
;;		pshs	X
;;		jsr	render_logo2
;;		jsr	mos_VDU_9
;;		puls	X
;;		leax	8,X
;;		rts
;; ----------------------------------------------------------------------------
;; convert teletext characters; mode 7 
x_convert_teletext_characters
		ldb	#$02
		ldx	#mostbl_TTX_CHAR_CONV
LCFDE		cmpa	B,X
		beq	LCFE9				;	CFE1
		decb					;	CFE3
		bpl	LCFDE				;	CFE4
LCFE6		sta	[zp_vdu_top_scanline]
		rts					;	CFE8
;; ----------------------------------------------------------------------------
LCFE9		incb
		lda	B,X
		decb
		bra	LCFE6
;; four colour modes
render_char_4colour
		pshs	U
		ldu	#mostbl_byte_mask_4col
1
		lda	b,x
		lsra
		lsra
		lsra
		lsra
		lda	a,U
		ora	zp_vdu_txtcolourOR
		eora	zp_vdu_txtcolourEOR
		sta	b,y
		lda	b,x
		addb	#8
		anda	#$0F
		lda	a,U
		ora	zp_vdu_txtcolourOR
		eora	zp_vdu_txtcolourEOR
		sta	b,y
		subb	#9
		bpl	1B
LD017rts
		puls	U

		puls	b
		stb	sheila_ROMCTL_MOS

		rts
;; ----------------------------------------------------------------------------
LD018		subb	#$21
		bmi	LD017rts				;	D01B
		bra	rc16csk1
;; 16 COLOUR MODES
render_char_16colour
		pshs	U
		ldu	#mostbl_byte_mask_16col
rc16csk1
		lda	B,X
		sta	zp_vdu_wksp+2
		SEC
LD023		lda	#0				; cant use clra here as we need the carry set
		rol	zp_vdu_wksp+2
		beq	LD018
		rola
		asl	zp_vdu_wksp+2
		rola
		lda	A,U
		ora	zp_vdu_txtcolourOR
		eora	zp_vdu_txtcolourEOR
		sta	B,y
		addb	#$08
		bra	LD023

x_calc_pattern_addr_for_given_char
;;		pshs	D,X
		pshs	D
		ldb	#8				; 2	2
		mul					; 1	11
;;		stb	zp_vdu_wksp + 5			; 2	4		a contains "char defs page offset"
		adda	#(mostbl_chardefs/256)-1	; MINIMOS - always whole font at base of ROM
		std	zp_vdu_wksp + 4
		puls	D,PC
;; 		ldx	#mostbl_VDU_pix_mask_2colour	; 3	3		convert to a bit mask
;; 		ldb	a,x				; 2	5
;; 		bitb	vduvar_EXPLODE_FLAGS		; 3	5		check if that bit is set in explosion bitmask
;; 		bne	x_cpa_sk_exploded		; 2	3		if it is use that address
;; 		adda	#(mostbl_chardefs/256) - 1	; 2	2		space is at 32 remember!
;; 1		sta	zp_vdu_wksp + 4			; 2	6		store whole address
;; 						; 19	41
;; 		puls	D,X,PC
;; x_cpa_sk_exploded
;; 		ldx	#vduvar_EXPLODE_FLAGS
;; 		lda	a,x				;	get explode address from table
;; 		bra	1B


copy2fromXtoY
		ldb	#$04				; LD48A
copy8fromXtoY
		ldb	#$08				; LD47C
		bra	x_copy_B_bytes_from_XtoY
copy4fromXtoY
		ldb	#$04				; LD48A
x_copy_B_bytes_from_XtoY			; LDF8C
		lda	,x+
		sta	,y+
		decb
		bne	x_copy_B_bytes_from_XtoY
		rts



LD8CBclrArts	
		clra
		rts	

;; ----------------------------------------------------------------------------
x_cursor_start					; LD8CE
		pshs	A				; Push A
		ldb	sysvar_VDU_Q_LEN		; X=number of items in VDU queque
		bne	LD916pulsArts			; if not 0 D916
	IF CPU_6809
		lda	#$A0				; A=&A0
		bita	zp_vdu_status			; else check VDU status byte
	ELSE
		tim	#$A0, zp_vdu_status
	ENDIF
		bne	LD916pulsArts			; if either VDU is disabled or plot to graphics
						; cursor enabled then D916
	IF CPU_6809
		lda	#$40
		bita	zp_vdu_status
	ELSE
		tim	#$40, zp_vdu_status
	ENDIF
		bne	1F				; if cursor editing enabled D8F5
		lda	vduvar_CUR_START_PREV		; else get 6845 register start setting
		anda	#$9F				; clear bits 5 and 6
		ora	#$40				; set bit 6 to modify last cursor size setting
		jsr	x_crtc_set_cursor		; change write cursor format
		ldx	#vduvar_TXT_CUR_X		; X=&18
		ldy	#vduvar_TEXT_IN_CUR_X		; Y=&64
		jsr	copy2fromXtoY			; set text input cursor from text output cursor
		jsr	x_start_cursor_edit_qry		; modify character at cursor poistion
		lda	#$02				; A=2
		jsr	x_ORA_with_vdu_status		; bit 1 of VDU status is set to bar scrolling
1
		lda	#$BF				;A=&BF
		jsr	mos_VDU_and_A_vdustatus		;bit 6 of VDU status =0 
		puls	A				;Pull A
		anda	#$7F				;clear hi bit (7)
		jsr	mos_VDU_WRCH			; exec up down left or right?
		lda	#$40				;A=&40
		jmp	x_ORA_with_vdu_status		;exit 
;; ----------------------------------------------------------------------------
x_cursor_COPY					; LD905
;;	lda	#$20				;A=&20
;;	bita	zp_vdu_status			
;;	bvc	LD8CBclrArts			;if bit 6 cursor editing is set
;;	bne	LD8CBclrArts			;or bit 5 is set exit &D8CB
	IF CPU_6809
		lda	#$40
		bita	zp_vdu_status
	ELSE
		tim	#$40, zp_vdu_status
	ENDIF
		beq	LD8CBclrArts			; not cursor editing
	IF CPU_6809
		lda	#$20
		bita	zp_vdu_status
	ELSE
		tim	#$20, zp_vdu_status
	ENDIF
		bne	LD8CBclrArts			; VDU5
		pshs	B,X,Y
		lda	#135
		jsr	OSBYTE				;read a character from the screen - note changed this to use
		tfr	X,D				;OSBYTE instead of direct jump to allow 135 to be intercepted
		tfr	B,A				;in VNULA utils ROM
		puls	B,X,Y
		tsta
		beq	LD917rts			;if A=0 on return exit via D917
		pshs	A				;else store A
		jsr	mos_VDU_9			;perform cursor right
LD916pulsArts	
		puls	A				;	D916
LD917rts	
		rts					;	D917
;; ----------------------------------------------------------------------------


x_cancel_cursor_edit				; LD918
		lda	#$BD				;	D918
		jsr	mos_VDU_and_A_vdustatus		;	D91A
		jsr	x_crtc_reset_cursor				;	D91D
		lda	#$0D				;	D920
		rts	













;========================================================
; R E S E T
;========================================================


mos_handle_res	
		ORCC	#CC_I + CC_F
		lds	#STACKTOP			; stack

		ldb	#1
		stb	sheila_ROMCTL_SWR

		ldb	#$11
		stb	sheila_ROMCTL_MOS		; SWMOS

		jsr	noice_handle_res

		ldb	#1
		stb	sheila_ROMCTL_SWR		; use bank #1 for ram at $8000-BFFF


;========================================================
; Setup sys vars
;========================================================
		lda	#9
		sta	sysvar_KEYB_TAB_CHAR
		lda	#$24
		sta	sysvar_KEYB_STATUS	

;========================================================
; Setup hardware
;========================================================
		lda	#$7F
		sta	sheila_SYSVIA_ier		; disable all interrupts

		lda	#$0F
		sta	sheila_SYSVIA_ddrb		; setup latches

		jsr	x_Turn_on_Keyboard_indicators

;;; ;========================================================
;;; ; Setup screen hardware
;;; ;========================================================
;;; 
;;; 		lda	mostbl_VDU_VIDPROC_CTL_by_mode + 7
;;; 		jsr	mos_VIDPROC_set_CTL
;;; 
;;; 		ldx	#mostbl_VDU_6845_mode_7
;;; 		ldb	#$0D
;;; 1		lda	B,X
;;; 		jsr	mos_set_6845_regBtoA		
;;; 		decb					
;;; 		bpl	1B			

;;; ;========================================================
;;; ; CLS
;;; ;========================================================
;;; 		ldx	#40*25
;;; 		lda	#' '
;;; 1		jsr	mos_OSWRCH
;;; 		leax	-1,X
;;; 		bne	1B
;;; 		ldx	#$7C00
;;; 		stx	mos_dp_mo7ptr

		clra					; mode 0
		jsr	mos_VDU_init

		clr	zp_mos_ESC_flag

		ldx	#str_mini_mos
		jsr	PRSTR

1		jsr	mos_OSRDCH
		cmpa	#' '
		bhs	2F

		pshs	A
		lda	#'|'
		jsr	_OSWRCH
		puls	A

		jsr	PRHEXA
		bra	1B
2		jsr	_OSASCI
		bra	1B

		swi

	IF NOICE=0
mos_handle_swi	rti
mos_handle_nmi	rti
	ENDIF

mos_handle_irq	rti
mos_handle_swi2 rti
mos_handle_swi3 rti
mos_handle_firq rti


*************************************************************************
*                                                                       *
*       OSBYTE 154 (&9A) SET VIDEO ULA                                  *       
*                                                                       *
*************************************************************************
mos_OSBYTE_154
		m_txa					;osbyte entry! X transferred to A thence to
mos_VIDPROC_set_CTL
		pshs	CC				;save flags
		SEI					;disable interupts
		sta	sheila_VIDULA_ctl		;write to control register
		puls	CC				;get back status
		rts					;and return



FILL1
		FILL	$FF,NOICE_CODE_BASE-FILL1
		ORG	NOICE_CODE_BASE
	IF NOICE==0
		FILL	$FF,NOICE_CODE_LEN
	ELSE
	 IF MACH_BEEB
	  IF NOICE_MY
	   IF CPU_6809
		error "no matching noice target"
	   ELSE
		error "no matching noice target"
	   ENDIF
	  ELSE
	   IF CPU_6809
		error "no matching noice target"
	   ELSE
		includebin "../../mos/noice/noice/mon-noice-6309-beeb-flex-ovr.ovr"
	   ENDIF
	  ENDIF
	 ENDIF
FILLNOICE		FILL	$FF,NOICE_CODE_BASE+NOICE_CODE_LEN-FILLNOICE
	ENDIF


		SECTION	"tables_and_strings"
str_mini_mos	FCB	"MINIMOS 2018 Dossytronics",13,13,"SWI",13,13,0


KEYV_test_shift_ctl
		lda	sysvar_KEYB_STATUS		;read keyboard status;     
							;Bit 7  =1 shift enabled   
							;Bit 6  =1 control pressed 
							;bit 5  =0 shift lock      
							;Bit 4  =0 Caps lock       
							;Bit 3  =1 shift pressed   
		anda	#$B7				;zero bits 3 and 6
		ldb	#0				;zero B to test for shift key press
							;NB: DON'T use CLRB here need to preserve carry
		jsr	keyb_check_key_code_API		;interrogate keyboard X=&80 if key determined by
							;X on entry is pressed 
		stb	zp_mos_OS_wksp2			;save X
		bpl	1F				;if no key press (X=0) then EF2A else
		ora	#$08				;set bit 3 to indicate Shift was pressed
1		incb					;check the control key
		jsr	keyb_check_key_code_API		;via keyboard interrogate
		bpl	1F				;if key not pressed goto EF30
		ora	#$40				;or set CTRL pressed bit in keyboard status byte in A
1		sta	sysvar_KEYB_STATUS		;save status byte
		jsr	x_Turn_on_Keyboard_indicators
		rts

x_Turn_on_Keyboard_indicators				; LEEEB
		pshs	B,A,CC				;save flags
		lda	sysvar_KEYB_STATUS		;read keyboard status;
							;Bit 7  =1 shift enabled
							;Bit 6  =1 control pressed
							;bit 5  =0 shift lock
							;Bit 4  =0 Caps lock
							;Bit 3  =1 shift pressed    
		lsra					;shift Caps bit into bit 3
		anda	#$18				;mask out all but 4 and 3
		ora	#$06				;returns 6 if caps lock OFF &E if on
		sta	sheila_SYSVIA_orb		;turn on or off caps light if required
		lsra					;bring shift bit into bit 3
		ora	#$07				;
		sta	sheila_SYSVIA_orb		;turn on or off shift  lock light
;;;		jsr	keyb_hw_enable_scan		;set keyboard counter
		clra
		puls	CC				; have some bodgery to do here to make 
							; Entry N=>control, A==8=>shift, CC_C=>C
							; into 6809 A(7) = control, A(6) = shift, A(0) carry on entry
		bcc	1F
		ora	#$01
1		bpl	1F
		ora	#$80
1		
	IF CPU_6809
		ldb	#8
		bitb	,S+
	ELSE
		tim	#$08, ,S+
	ENDIF
		beq	1F
		ora	#$40
1		puls	B,PC				;get back flags	in A! and return

;;; *************************************************************************
;;; *        Scan Keyboard C=1, V=0 entry via KEYV (or from CLC above)      *
;;; *************************************************************************
;;; Heavily edited to not use interrupts always start scan from $10, return first key in B (no rollover)
KEYV_keyboard_scan_ge_16
		ldb	#$10
KEYV_keyboard_scan_ge_B
		stb	zp_mos_OS_wksp

;;		m_txa					;if X is +ve goto F0D9
;;		bpl	LF0D9				;
;;		tfr	A,B
;;		jsr	keyb_check_key_code_API		;else interrogate keyboard
;;LF0D7		bcs	keyb_hw_enable_scan2		;if carry set F12E to set Auto scan else
LF0D9		
;;		pshs	CC				;push flags
;;		bcc	LF0DE				;if carry clear goto FODE 
;;							;else (keep Y passed in to clc_then_mos_OSBYTE_122)
;;		ldy	#$EE				;set Y so next operation saves to 2cd
;;LF0DE		sta	mosvar_KEYB_TWOKEY_ROLLOVER-zp_mos_keynumlast,y
;;							;can be: 	2cb (mosvar_KEYB_TWOKEY_ROLLOVER)
;;							;	,	2cc (+1)
;;							;	or 	2cd (+2)
		ldb	#$09				;set X to 9
LF0E3
;;		jsr	keyb_enable_scan_IRQonoff	;select auto scan 
		lda	#$7F				;set port A for input on bit 7 others outputs
		sta	sheila_SYSVIA_ddra		;
		lda	#$03				;stop auto scan
		sta	sheila_SYSVIA_orb		;
		lda	#$0F				;select non-existent keyboard column F (0-9 only!)
		sta	sheila_SYSVIA_ora_nh		;
		lda	#$01				;cancel keyboard interrupt
		sta	sheila_SYSVIA_ifr		;
		stb	sheila_SYSVIA_ora_nh		;select column X (9 max)
		bita	sheila_SYSVIA_ifr		;if bit 1 =0 there is no keyboard interrupt so
		beq	LF123				;goto F123
		tfr	B,A				;else put column address in A
LF103		
;;		cmpa	mosvar_KEYB_TWOKEY_ROLLOVER-zp_mos_keynumlast,y	;compare with 1DF+Y
		cmpa	zp_mos_OS_wksp
		blo	LF11E				;if less then F11E
		sta	sheila_SYSVIA_ora_nh		;else select column again 
		tst	sheila_SYSVIA_ora_nh		;and if bit 7 is 0

		bmi	LF127				; DB: minimos just return first
;;		bpl	LF11E				;then F11E
;;		puls	CC				;else push and pull flags
;;		pshs	CC				;
;;		bcs	LF127				;and if carry set goto F127
;;		pshs	A				;else Push A
;;		eora	,y				;EOR with EC,ED, or EE depending on Y value
;;		asla					;shift left  
;;		cmpa	#$01				;clear? carry if = or greater than number holds EC,ED,EE
;;		puls	A				;get back A
;;		bcc	LF127				;if carry set F127

LF11E		adda	#$10				;add 16
		bpl	LF103				;and do it again if 0=<result<128

LF123		decb					;decrement X
		bpl	LF0E3				;scan again if greater than 0
		rts				;
LF127		tfr	A,B
;;		m_tax_se				;
;;		puls	CC				;pull flags
;;keyb_enable_scan_IRQonoff				; LF129
;;		jsr	keyb_hw_enable_scan		;call autoscan
;;		CLI					;allow interrupts 
;;		SEI					;disable interrupts
;;;; Enable counter scan of keyboard columns; called from &EEFD, &F129 
;;		
;;keyb_hw_enable_scan
;;		pshs	B
;;		ldb	#$0B				;	F12E
;;		stb	sheila_SYSVIA_orb		;	F130
;;		puls	B,PC				; return with B in X
;;keyb_hw_enable_scan2
;;		tfr	B,A
;;		m_tax_se
;;		bra	keyb_hw_enable_scan
		rts
;; ----------------------------------------------------------------------------
;; Interrogate Keyboard routine;
		; NOTE: API change B now contains key code to scan, A is preserved
		; NB: needs to preserve carry!
keyb_check_key_code_API
		pshs	A
		lda	#$03				;stop Auto scan
		sta	sheila_SYSVIA_orb		;by writing to system VIA
		lda	#$7F				;set bits 0 to 6 of port A to input on bit 7
						;output on bits 0 to 6
		sta	sheila_SYSVIA_ddra		;
		stb	sheila_SYSVIA_ora_nh		;write X to Port A system VIA
		ldb	sheila_SYSVIA_ora_nh		;read back &80 if key pressed (M set)
		puls	A,PC				;and return
;; ----------------------------------------------------------------------------

*************************************************************************
 *                                                                       *
 *       KEY TRANSLATION TABLES                                          *
 *                                                                       *
 *       7 BLOCKS interspersed with unrelated code                       *
 *************************************************************************
                                         
 *key data block 1
key2ascii_tab					; LF03B
		FCB	$71,$33,$34,$35,$84,$38,$87,$2D,$5E,$8C
		;	 q , 3 , 4 , 5 , f4, 8 , f7, - , ^ , <-

		RMB	6	; TODO - spare gap in key2ascii map

*key data block 2
 
LF04B		FCB	$80,$77,$65,$74,$37,$69,$39,$30,$5F,$8E
		;	 f0, w , e , t , 7 , i , 9 , 0 , _ ,lft

		RMB	6	; TODO - spare gap in key2ascii map

 *key data block 3
 
LF05B		FCB	$31,$32,$64,$72,$36,$75,$6F,$70,$5B,$8F
		;	 1 , 2 , d , r , 6 , u , o , p , [ , dn

		RMB	6	; TODO - spare gap in key2ascii map

*key data block 4
 
LF06B		FCB	$01,$61,$78,$66,$79,$6A,$6B,$40,$3A,$0D
		;	 CL, a , x , f , y , j , k , @ , : ,RET		N.B CL=CAPS LOCK

*speech routine data
LF075		FCB	$00,$FF,$01,$02,$09,$0A

*key data block 5

F07B	FCB	$02,$73,$63,$67,$68,$6E,$6C,$3B,$5D,$7F
		;	 SL, s , c , g , h , n , l , ; , ] ,DEL		N.B. SL=SHIFT LOCK

		RMB	6	; TODO - spare gap in key2ascii map

 *key data block 6
 
F08B	FCB	$00,$7A,$20,$76,$62,$6D,$2C,$2E,$2F,$8B
		;	TAB, Z ,SPC, v , b , m , , , . , / ,CPY

		RMB	6	; TODO - spare gap in key2ascii map

*key data block 7
F09B	FCB	$1B,$81,$82,$83,$85,$86,$88,$89,$5C,$8D
		;	ESC, f1, f2, f3, f5, f6, f8, f9, \ , ->


;; ----------------------------------------------------------------------------
;; CHECK FOR ALPHA CHARACTER; ENTRY  character in A ; exit with carry set if non-Alpha character 
mos_CHECK_FOR_ALPHA_CHARACTER			; LE4E3
		PSHS	A				;Save A
		anda	#$DF				;convert lower to upper case
		cmpa	#'Z'				;is it less than eq 'Z'
		bhi	LE4EE				;if so exit with carry clear
		cmpa	#'A'				;is it 'A' or greater ??
		bhs	LE4EF				;if not exit routine with carry set
LE4EE		SEC					;else clear carry
LE4EF		puls	A,PC				;get back original value of A
		rts					;and Return


;; ----------------------------------------------------------------------------
;; get ASCII code; on entry B=key pressed internal number 
x_get_ASCII_code
		ldx	#key2ascii_tab - $10
		andb	#$7F
		lda	B,X				;get code from look up table
		bne	1F				;if not zero goto EF99 else TAB pressed
		lda	sysvar_KEYB_TAB_CHAR		;get TAB character
1		ldb	sysvar_KEYB_STATUS		;get keyboard status
		stb	zp_mos_OS_wksp2			;store it in &FA
		rol	zp_mos_OS_wksp2			;rotate to get CTRL pressed into bit 7
		bpl	LEFA9				;if CTRL NOT pressed EFA9

;;		ldb	zp_mos_keynumfirst		;get no. of previously pressed key
;;LEFA4		bne	LEF4A				;if not 0 goto EF4A to reset repeat system etc.
		jsr	x_Implement_CTRL_codes		;else perform code changes for CTRL

LEFA9		rol	zp_mos_OS_wksp2			;move shift lock into bit 7
LEFAB		bmi	LEFB5				;if not effective goto EFB5 else
		jsr	x_Modify_code_as_if_SHIFT	;make code changes for SHIFT

		rol	zp_mos_OS_wksp2			;move CAPS LOCK into bit 7
		bra	LEFC1				;and Jump to EFC1

LEFB5		rol	zp_mos_OS_wksp2			;move CAPS LOCK into bit 7
		bmi	LEFC6				;if not effective goto EFC6
		jsr	mos_CHECK_FOR_ALPHA_CHARACTER	;else make changes for CAPS LOCK on, return with 
							;C clear for Alphabetic codes
		bcs	LEFC6				;if carry set goto EFC6 else make changes for
		jsr	x_Modify_code_as_if_SHIFT	;SHIFT as above

LEFC1		ldb	sysvar_KEYB_STATUS		;if shift enabled bit is clear
		bpl	LEFD1				;goto EFD1
LEFC6		rol	zp_mos_OS_wksp2			;else get shift bit into 7
		bpl	LEFD1				;if not set goto EFD1
;;		ldb	zp_mos_keynumfirst		;get previous key press
;;		bne	LEFA4				;if not 0 reset repeat system etc. via EFA4
		jsr	x_Modify_code_as_if_SHIFT	;else make code changes for SHIFT
LEFD1		rts

;; Modify code as if SHIFT pressed
x_Modify_code_as_if_SHIFT			; LEA9c
		cmpa	#'0'				;if A='0' skip routine
		beq	LEABErts				;
		cmpa	#'@'				;if A='@' skip routine
		beq	LEABErts				;
		blo	LEAB8				;if A<'@' then EAB8
		cmpa	#$7F				;else is it DELETE
		beq	LEABErts			;if so skip routine
		bhi	LEABCeor10rts			;if greater than &7F then toggle bit 4
LEAACeor30	eora	#$30				;reverse bits 4 and 5
		cmpa	#$6F				;is it &6F (previously '_' (&5F))
		beq	LEAB6				;goto EAB6
		cmpa	#$50				;is it &50 (previously '`' (&60))
		bne	LEAB8				;if not EAB8
LEAB6		eora	#$1F				;else continue to convert ` _
LEAB8		cmpa	#'!'				;compare &21 '!'
		blo	LEABErts			;if less than return
LEABCeor10rts	eora	#$10				;else finish conversion by toggling bit 4
LEABErts	rts				;exit
							;
							;ASCII codes &00 &20 no change
							;21-3F have bit 4 reverses (31-3F)
							;41-5E A-Z have bit 5 reversed a-z
							;5F & 60 are reversed
							;61-7E bit 5 reversed a-z becomes A-Z
							;DELETE unchanged
							;&80+ has bit 4 changed

;; ----------------------------------------------------------------------------
;; Implement CTRL codes
x_Implement_CTRL_codes					; LEABF
		cmpa	#$7F				;is it DEL
		beq	LEAD1rts			;if so ignore routine
		bhs	LEAACeor30				;if greater than &7F go to EAAC
		cmpa	#$60				;if A<>'`'
		bne	LEACB				;goto EACB
		lda	#$5F				;if A=&60, A=&5F

LEACB		cmpa	#'@'				;if A<&40
		blo	LEAD1rts			;goto EAD1  and return unchanged
		anda	#$1F				;else zero bits 5 to 7
LEAD1rts		rts					;return

mos_OSPEEKCH						; returns NE if a new key is pressed, ignore caps/shift lock
		CLC
		pshs	B

		jsr	KEYV_test_shift_ctl
		jsr	KEYV_keyboard_scan_ge_16
		cmpb	zp_mos_keynumlast
		beq	1F
		stb	zp_mos_keynumlast
		cmpb	#$FF
		beq	1F

		cmpb	#$40
		beq	1F
		cmpb	#$50
		beq	1F

1		PULS	B,PC


mos_OSRDCH
		pshs	B,X,Y

1		jsr	KEYV_test_shift_ctl
		jsr	KEYV_keyboard_scan_ge_16
		cmpb	zp_mos_keynumlast
		beq	1B
		stb	zp_mos_keynumlast
		cmpb	#$FF
		beq	1B

		lda	sysvar_KEYB_STATUS		;get keyboard status
;;		ldb	zp_mos_keynumlast		;get last key pressed
;;		cmpb	#$D0				;if not SHIFT LOCK key (&D0) goto
		cmpb	#$50
		bne	LEF7E				;EF7E
		ora	#$90				;sets shift enabled, & no caps lock all else preserved
		eora	#$A0				;reverses shift lock disables Caps lock and Shift enab
LEF74		sta	sysvar_KEYB_STATUS		;reset keyboard status
;;		clra					;and set timer
;;		sta	zp_mos_autorep_countdown	;to 0
		bra	1B
		
LEF7E		
;;		cmpb	#$C0				;if not CAPS LOCK
		cmpb	#$40
		bne	1F
		ora	#$A0				;sets shift enabled and disables SHIFT LOCK
		tst	zp_mos_OS_wksp2			;if bit 7 not set by (EF20) shift NOT pressed
		bpl	LEF8C				;goto EF8C
		ora	#$10				;else set CAPS LOCK not enabled
		eora	#$80				;reverse SHIFT enabled

LEF8C		eora	#$90				;reverse both SHIFT enabled and CAPs Lock
		bra	LEF74				;reset keyboard status and set timer

1		jsr	x_get_ASCII_code		;goto EF91
		puls	B,X,Y,PC


; ----------------------------------------------------------------------------
 *************************************************************************
 *                                                                       *
 *        OSBYTE &76 (118) SET LEDs to Keyboard Status                   *
 *                                                                       *
 *************************************************************************
                          ;osbyte entry with carry set
                         ;called from &CB0E, &CAE3, &DB8B

mos_OSBYTE_118					; LE9D9
		pshs	CC				;PUSH P
		SEI					;DISABLE INTERUPTS
		lda	#$40				;switch on CAPS and SHIFT lock lights
		jsr	x_keyb_leds_test_esc		;via subroutine
		bmi	LE9E7				;if ESCAPE exists (M set) E9E7
		ANDCC	#~(CC_C + CC_V)			;else clear V and C
						;before calling main keyboard routine to
;;		jsr	[KEYV]				;switch on lights as required
		jsr	KEYV_test_shift_ctl

LE9E7		puls	CC				;get back flags
		rola					;and rotate carry into bit 0
		rts					;Return to calling routine
;; ----------------------------------------------------------------------------
;; Turn on keyboard lights and Test Escape flag; called from &E1FE, &E9DD  ;  
x_keyb_leds_test_esc
		bcc	LE9F5
		ldb	#$07
		stb	sheila_SYSVIA_orb
		decb
		stb	sheila_SYSVIA_orb
LE9F5		tst	zp_mos_ESC_flag
		rts
;; ----------------------------------------------------------------------------
mos_poke_SYSVIA_orb
		pshs	CC
		SEI
		sta	sheila_SYSVIA_orb
		puls	CC,PC

*************************************************************************
*                                                                       *
*        OSBYTE &9B (155) write to pallette register                    *       
*                                                                       *
*************************************************************************
                ;entry X contains value to write

mos_OSBYTE_155
		m_txa					;	EA10
write_pallette_reg
		eora	#$07				;	EA11
		pshs	CC				;	EA13
		SEI					;	EA14
		sta	sysvar_VIDPROC_PAL_COPY		;	EA15
		sta	sheila_VIDULA_pal		;	EA18
		puls	CC,PC				;	EA1B



;;FILL2
;;		FILL	$FF,REMAPPED_HW_VECTORS-FILL2
		ORG	REMAPPED_HW_VECTORS
*************************************************************
*     R E M A P P E D    H A R D W A R E    V E C T O R S   *
*************************************************************
XRESV		FDB	mos_handle_res			; $FFF0   	; Hardware vectors, paged in to $F7Fx from $FFFx
XSWI3V		FDB	mos_handle_swi3			; $FFF2		; on 6809 we use this instead of 6502 BRK
XSWI2V		FDB	mos_handle_swi2			; $FFF4
XFIRQV		FDB	mos_handle_firq			; $FFF6
XIRQV		FDB	mos_handle_irq			; $FFF8
	IF NOICE==0
XSWIV		FDB	mos_handle_swi			; $FFFA
XNMIV		FDB	mos_handle_nmi			; $FFFC
	ELSE
XSWIV		FDB	noice_handle_swi		; $FFFA
XNMIV		FDB	noice_handle_nmi		; $FFFC
	ENDIF
XRESETV		FDB	mos_handle_res			; $FFFE

		IF NOICE
noice_handle_nmi	JMP	[NOICE_CODE_BASE+0]
noice_handle_swi	JMP	[NOICE_CODE_BASE+2]
noice_handle_ch		JMP	[NOICE_CODE_BASE+4]
noice_handle_res	JMP	NOICE_CODE_BASE+6
		ENDIF

*******************************************************************************
* 6809 debug and specials
*******************************************************************************

_ytoa	pshs	Y
		leas	1,S
		puls	A,PC

_m_tax_se		; sign extend A into X
		sta	,-S
		bmi	1F
		clr	,-S
		puls	X,PC
1		clr	,-S
		dec	,S
		puls	X,PC

	IF MACH_BEEB && NOICE && !NOICE_MY
debug_init_beeb
		; force pre-init of ACIA
		jsr	ACIA_rst_ctl3		; master reset of ACIA
		lda	#$40			; 19,200/19,200/serial
		sta	sheila_SERIAL_ULA
		lda	#$56			; div 64, 8N1, RTS, TX irq disable
		sta	sheila_ACIA_CTL
		clr	sheila_ACIA_DATA	; send a zero byte to wake it up!
		rts
	ENDIF

	IF MACH_BEEB

ACIA_rst_ctl3					; LFB46
		lda	#$03				;	FB46
		bra	ACIA_set_ctl			;	FB48
ACIA_set_ctl						; LFB65
		sta	sheila_ACIA_CTL			; FB65
		rts					; FB68
	ENDIF


		; send characters after call to the UART
debug_print
		PSHS	X
		LDX	2,S
		jsr	debug_printX
		STX	2,S
		PULS	X,PC

debug_printX
		pshs	A
1		LDA	,X+	
		BEQ	2F
		ANDA	#$7F
		JSR	debug_print_ch
		BRA	1B
2		puls	A,PC

debug_print_newl
		pshs	A
;;	lda	#13
;;	jsr	debug_print_ch
		lda	#10
		jsr	debug_print_ch
		puls	A,PC

debug_print_hex
		sta	,-S
		lsra
		lsra
		lsra
		lsra
		jsr	debug_print_hex_digit
		lda	,S
		jsr	debug_print_hex_digit
		puls	A,PC
debug_print_hex_digit
		anda	#$F
		adda	#'0'
		cmpa	#'9'
		bls	1F
		adda	#'A'-'9'-1
1		jmp	debug_print_ch


	IF NOICE
debug_print_ch	equ	noice_handle_ch			; use noice's built in ch print
	ELSE
debug_print_ch	jmp	OSASCI
	ENDIF	


PRHEXA	pshs	A
	jsr	OUTHL
	lda	,S
	jsr	OUTHR
	puls	A,PC

OUTHL	LSRA 						;move left 4 places
	LSRA
	LSRA
	LSRA
OUTHR	ANDA #$0F					; mask off 4 lsb
	ADDA #$30					; add ascii bias
	CMPA #$39					; is it greater than 9?
	BLS OUTIT					; print if not
	ADDA #$07					; offset to ascii "A"
OUTIT	JMP OSWRCH					; print it


		; save DP on stack _above_ caller address
_ENTEROS	pshs	DP,CC,D				
		; stack now contains:
		;	+ 4,5	RET
		;	+ 3	DP
		;	+ 1,2	D
		;	+ 0	CC

		ldd	4,S				; get old return address
		std	3,S
		; stack now contains:
		;	+ 5	*
		;	+ 3,4	RET
		;	+ 1,2	D
		;	+ 0	CC
		tfr	DP,A
		sta	5,S
		;	+ 5	DP
		;	+ 3,4	RET
		;	+ 1,2	D
		;	+ 0	CC

		lda	#MOSROMSYS_DP / 256
		tfr	A,DP				; setup mos DP

		puls	CC,D,PC				; continue

		; pull DP from stack _above_ caller address
		; stack:
		;	+ 1,2	RET (to user)
		;	+ 0	DP
_EXITOS		puls	DP,PC

OSRDCH_bounce	M_ENTEROS
		jsr	mos_OSRDCH
		M_EXITOS

OSPEEKCH_bounce	M_ENTEROS
		jsr	mos_OSPEEKCH
		M_EXITOS


OSWRCH_bounce	M_ENTEROS
		pshs	D,X,Y,U
		jsr	mos_VDU_WRCH
		puls	D,X,Y,U
		M_EXITOS

OSBYTE_bounce	rts
OSWORD_bounce	rts

PRSTR		
1		lda	,X+
		beq	1F
		jsr	_OSASCI
		bra	1B
1		rts


;; ----------------------------------------------------------------------------
;; OSBYTE 135  Read character at text cursor position
mos_OSBYTE_135
		tst	vduvar_COL_COUNT_MINUS1			;	D7C2
		bne	LD7DC					;	D7C5
		lda	[zp_vdu_top_scanline]			;	D7C7
		jsr	x_convert_teletext_characters						; TODO - check this is right!
;;;	ldy	#$02					;	D7C9
;;;LD7CB	cmpa	mostbl_TTX_CHAR_CONV+1,y		;	D7CB
;;;	bne	LD7D4					;	D7CE
;;;	lda	mostbl_TTX_CHAR_CONV,y			;	D7D0
;;;	dey						;	D7D3
;;;LD7D4	dey						;	D7D4
;;;	bpl	LD7CB					;	D7D5
mos_OSBYTE_135_YeqMODE_XeqArts
		LDY_B	vduvar_MODE				;	D7D7
		m_tax						;	D7DA
		rts						;	D7DB
;; ----------------------------------------------------------------------------
LD7DC		jsr	x_set_up_pattern_copy		;set up copy of the pattern bytes at text cursor
		lda	#$20				;X=&20
		ldx	#vduvar_TEMP_8
		sta	zp_vdu_wksp			;store current char
		bra	1F
mos_OSBYTE_135_lp1					; LD7E1
;;;	txa						;A=&20
;;;	pha						;Save it
		lda	zp_vdu_wksp
1		jsr	x_calc_pattern_addr_for_given_char	;get pattern address for code in A
		ldy	zp_vdu_wksp + 4
;;;	pla						;get back A
;;;	tax						;and X
LD7E8		ldb	#$07				;Y=7
LD7EA		lda	B,X				;get byte in pattern copy
		cmpa	B,Y				;check against pattern source
		bne	LD7F9				;if not the same D7F9
		decb					;else Y=Y-1
		bpl	LD7EA				;and if +ve D7EA
		lda	zp_vdu_wksp
		cmpa	#$7F				;is X=&7F (delete)
		bne	mos_OSBYTE_135_YeqMODE_XeqArts	;if not D7D7
LD7F9		clra
		inc	zp_vdu_wksp			;else X=X+1
		beq	mos_OSBYTE_135_YeqMODE_XeqArts	; past 255 give up return A = 0
		leay	8,Y
		tfr	Y,D
		tstb
;	lda	zp_vdu_wksp+4				;get byte lo address
;	clc						;clear carry
;	adc	#$08					;add 8
;	sta	zp_vdu_wksp+4				;store it
		bne	LD7E8					;and go back to check next character if <>0
		bra	mos_OSBYTE_135_lp1			; recalc char pointer (may be into redeffed chars)
;; set up pattern copy
x_set_up_pattern_copy
		ldb	#$07				; Y=7
		ldx	zp_vdu_top_scanline
		ldy	#vduvar_TEMP_8
LD80A		stb	zp_vdu_wksp			; &DA=Y
		lda	#$01				; A=1 - this will rol out and signal end of loop
		sta	zp_vdu_wksp + 7			; &DB=A
LD810		lda	vduvar_LEFTMOST_PIX_MASK	; A=left colour mask
		sta	zp_vdu_wksp+2			; store an &DC
		lda	B,X				; get a byte from current text character
		eora	vduvar_TXT_BACK			; EOR with text background colour
		CLC					; clear carry
LD81B		bita	zp_vdu_wksp+2			; and check bits of colour mask
		beq	LD820				; if result =0 then D820
		SEC					; else set carry
LD820		rol	zp_vdu_wksp + 7			; &DB=&DB+Carry
		bcs	LD82E				; if carry now set (bit 7 DB originally set) D82E
		lsr	zp_vdu_wksp+2			; else  &DC=&DC/2 - roll screen bits right
		bcc	LD81B				; if carry clear D81B - keep going for this mask
;;;	tya					; A=Y
;;;	adc	#$07				; ADD ( (7+carry)
;;;	tay					; Y=A
		addb	#8
		bra	LD810				; 

LD82E		ldb	zp_vdu_wksp			; read modified values into Y and A
		lda	zp_vdu_wksp + 7			; 
		sta	B,y				; store copy
		decb					; and do it again
		bpl	LD80A				; until 8 bytes copied
		rts




		org	$FFDD
_OSPEEKCH	jmp	OSPEEKCH_bounce			;	FFDD
_OSRDCH		jmp	OSRDCH_bounce			;	FFE0
_OSASCI		cmpa	#$0D				;	FFE3
		bne	_OSWRCH				;	FFE5
_OSNEWL		lda	#$0A				;	FFE7
		jsr	OSWRCH_bounce			;	FFE9
		lda	#$0D				;	FFEC
_OSWRCH		jmp	OSWRCH_bounce			;	FFEE
_OSWORD		jmp	OSWORD_bounce			;	FFF1
_OSBYTE		jmp	OSBYTE_bounce			;	FFF4
_OSCLI		rts			;	FFF7
		FCB	"Ishbel"			; this was the original vectors