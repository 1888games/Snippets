// KickAssembler syntax

DrawBorders: {

	.label SCREEN_RAM = $0400
	.label COLOR_RAM = $D800
	.label ZP_SCREEN_ADDRESS = $02
	.label ZP_COLOR_ADDRESS = $04
	.label END_COLUMN_1 = 10
	.label START_COLUMN_2 = 30
	.label ROW_WIDTH = 40
	.label NUM_ROWS = 25
	.label CYAN = 3
	.label BACKGROUND_COLOR = $d021
	.label BLOCK_CHAR = 40
	.label BLACK = 0


	MakeBackgroundCyan:

		lda #CYAN
		sta BACKGROUND_COLOR


	SetupZeropageScreenRAMPointer:

		lda #<SCREEN_RAM
		sta ZP_SCREEN_ADDRESS

		lda #>SCREEN_RAM
		sta ZP_SCREEN_ADDRESS + 1

	SetupZeropageColourRAMPointer:

		lda #<COLOR_RAM
		sta ZP_COLOR_ADDRESS

		lda #>COLOR_RAM
		sta ZP_COLOR_ADDRESS + 1

	ResetIndexes:

		ldx #0
		ldy #0


	Loop:

		ScreenRam:

			lda #BLOCK_CHAR
			sta (ZP_SCREEN_ADDRESS), y

			// stores to whatever address is in $02-03, plus Y offset
			// must use Y, not X

		ColourRam:

			lda #BLACK
			sta (ZP_COLOR_ADDRESS), y

		MoveToNextChar:

			iny

		CheckIfEndOfFirstColumn:

			cpy #END_COLUMN_1
			beq JumpAcrossCol30

		CheckIfEndOfRow:

			cpy #ROW_WIDTH
			beq NewRow

		DrawNextChar:

			jmp Loop

		JumpAcrossCol30:

			ldy #START_COLUMN_2
			jmp Loop

		NewRow:

			inx

		CheckLastRow:

			cpx #NUM_ROWS
			beq AllRowsDone

		Add40ScreenRamAddress:

			lda ZP_SCREEN_ADDRESS
			clc
			adc #ROW_WIDTH
			sta ZP_SCREEN_ADDRESS

			lda ZP_SCREEN_ADDRESS + 1
			adc #0
			sta ZP_SCREEN_ADDRESS + 1

		Add40ColourRamAddress:

			lda ZP_COLOR_ADDRESS
			clc
			adc #ROW_WIDTH
			sta ZP_COLOR_ADDRESS

			lda ZP_COLOR_ADDRESS + 1
			adc #0
			sta ZP_COLOR_ADDRESS + 1

		ResetOffsetToZero:

			ldy #0

			jmp Loop

	AllRowsDone:




	rts
}
