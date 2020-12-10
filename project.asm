/*
	Author: Jeremy Kimotho
	Date: 06/12/2020
*/

	.text
	prnfmt1: .string "\n*****Program Starts*****\n\n"
	prnfmt2: .string "Please enter input in the form <filename> <player_name> M N\n"
	prnfmt3: .string "Please enter values of M and N between 10 and 75 inclusive\n"
	prnfmt4: .string "\n*****Program Ends*****\n\n"
	prnfmt5: .string "%0.02f"
    	prnfmt6: .string " "
	prnfmt7: .string "\n"
    	prnfmt8: .string "Enter bomb position (x,y): "
	prnfmt9: .string "Please enter integer values of x and y smaller than the your row and column values, but larger than -1\n"
    	prnfmt10: .string "Your input was %d,%d\n"
    	prnfmt11: .string "Total negative numbers is %d/%d = %0.2f percent\n"
    	prnfmt12: .string "Your username is %s. The row size is %d and column size %d\n"
    	prnfmt13: .string "Would you like to view the top scores? (y/n) "
    	prnfmt14: .string "How many top scores would you like to view? "
    	prnfmt15: .string "%c"
    	prnfmt16: .string "%-3d"
        prnfmt17: .string "Negative numbers %d/%d = %d percent\n"
        prnfmt18: .string "Positive numbers %d/%d = %d percent\n"
        prnfmt19: .string "Special tiles %d/%d = %d percent\n"
	prnfmt20: .string "%d,%d"
	prnfmt21: .string "Lives: %d\n"
	prnfmt22: .string "Score: %0.02f\n"
	prnfmt23: .string "Bombs: %d\n"
	prnfmt24: .string "You have found the exit tile and won the game!\n"
	prnfmt25: .string "You've ran out of bombs or lives. Game Over!\n"
	prnfmt26: .string "Your score has dipped below zero, you have lost a life :( \n"
	prnfmt27: .string "You have found the extra lives bonus special tile! You will be rewarded with three extra lives immediately!\n"
	prnfmt28: .string "You have found the score double bonus tile! Your score was negative so it has been made positive and doubled!\n"
	prnfmt29: .string "You have found the score double bonus tile! Your score for this roll has been doubled! If it was negative it has been made positive and doubled!\n"
	prnfmt30: .string "Bang!! Your bomb range is doubled\n"
	prnfmt31: .string "Total uncovered score of %0.02f points\n"
	prnfmt32: .string "Currently assesing cell %d %d\n"
	scnfmt:	.string	"%d,%d"
	// Constants
	float_space = 2
	char_space = 4500000
	cover = 'X'
	positive = '+'
	negative = '-'
	special_C = '$'
	bonusA = '#'
	bonusB = '@'
	exit_C = '*'
	alloc = -50640
	// Register equates
	alloc_r	.req	x23
	fp	.req	x29	
	lr	.req	x30

    	// Defined Macros
	define(argv, x21)
	define(row, x19)
    	define(row_w, w19)
	define(column, x20)
    	define(column_w, w20)
	define(argc, w22)

    	define(offset, x18)
	define(i_r, x21)
	define(j_r, x22)
	define(random, x25)
	define(base,x28)	
	define(min, x21)
	define(max, x22)
	define(base_2, x24)
	define(temp, x26)
	define(count, x24)
	define(temp_w, w26)
	define(random_w, w25)	
	define(sums_w, w17)
    	define(random_f, d25)
        define(exit, d19)
        define(negative_count, x26)
        define(negative_max, x17)
        define(special_count, x27)
        define(special_max, x14)
        define(total, w15)

	define(layers, w16)
	define(running_score, d25)
	define(value, d15)
	define(row_start, x21)
	define(row_end, x22)
	define(row_start_w, w21)
	define(row_end_w, w22) 
	define(column_start, x26)
	define(column_end, x27)
	define(column_start_w,w26)
	define(column_end_w,w27)
	define(score, d12)
	define(bombs, w13)
	define(lives, w14)
	define(double_range, w15)
	define(other_specials, w17)
	define(exit_tile, w16)
	define(bomb_1, w17)
	define(bomb_2, w18)
	define(s_bombs, x1)

    	// Open Subroutines
	define(`sum',
	`add $1, $1, $2')

   	define(`printThis',
    	`ldr x0, =$1'
    	`bl printf')

	define(`storeThese',
	`stp $1, $2, [fp,$3]')
    	
	define(`restoreThese',
	`ldp $1, $2, [fp,$3]')

    	.balign 4
	.global main
main:
	stp	fp,	lr,	[sp,-32]!				// save fp register and link register current values
	mov	fp,	sp						// update fp register

	mov	argv,	x1						// saving the arguments from the command line to argv 
	mov	argc,	w0						// saving the number of arguments from the command line to argc

	cmp	argc,	4						// comparing the number of arguments passed to 4
	b.lt	wrongArguments						// if the number if arguments is not equal to 3 we branch to wrongArguments

    	cmp 	argc,   4      					        // comparing the number of arguments passed to 4
    	b.gt    wrongArguments                 				// if the number if arguments is not equal to 4 we branch to wrongArguments

	ldr	row,	[argv,16]					// loading from memory the second argument that was passed in cmd line
	ldr	column,	[argv,24]					// loading from memory the third argument that was passed in cmd line

	mov	x0,	row						// copying the row value to x0
	bl	atoi							// converting to int the row value that was copied to x0
	mov	row,	x0						// copying the row value that is now an int back to row

	mov	x0,	column						// copying the column value to x0
	bl	atoi							// converting to int the column value that was copied to x0
	mov	column,	x0						// copying the coilumn value that is now an int back to column

	cmp	row,	10						// comparing the row value to integer 10
	b.lt	wrongInput						// if the row is less than 10 we branch to wrongInput
	cmp	column,	10						// comparing the column value to integer 10
	b.lt	wrongInput						// if the column is less than 10 we branch to wrongInput
	cmp	column,	75						// comparing the column value to integer 75
	b.gt	wrongInput						// if the column value is larger than 75 we branch to wrongInput
	cmp	row,	75						// comparing the row value to integer 75
	b.gt	wrongInput						// if the row value is larger than 75 we branch to wronInput

	str	row,	[argv,8]					// storing the row value to memory location argv+8 to be loaded into w register
	str	column,	[argv, 16]					// storing the column value to memory location argv+16 to be loaded into w register
	
	ldr	row_w,	[argv,8]					// loading row value into w register
	ldr	column_w,[argv,16]					// loading column value into w register

    	mov	alloc_r,	alloc					// allocating enough memory for a 2 2d arrays 	
	add	sp,	sp,	alloc_r					// allocate the number of bytes we need on top of the stack	
	mov	fp,	sp

    	printThis(prnfmt1)						// print the string prnfmt1
	
	mov	x0,	fp						// setting first argument of initialise to base address of 2d array
	bl	initialise						// initialise the table 
	
	printThis(prnfmt7)						// print nextline character

	mov	x0,	column						// setting first argument of display to column size
	mov	x1,	row						// setting second argument of display to row size
	mov	x2,	fp						// setting third argument of display to base address of 2d array
	bl	displayUncovered					// display initialised table 	

	printThis(prnfmt7)						// print nextline character

    	mov	x0,	column						// setting first argument of display to column size
	mov	x1,	row						// setting second argument of display to row size
	mov	x2,	fp						// setting third argument of display to base address of 2d array
	bl	display							// display initialised table 	

	mov	x0,	column						// set first argument to column
	mov	x1,	row						// set second argument to row
	mov	x2,	fp						// set third argument to base
	bl	gameLoop						// run the game
	
	b 	end							// branch to the function that restores registers for main and deallocates space

gameLoop:
	stp     fp,     lr,     [sp,-144]!                              // save fp register and link register current values
        mov     fp,     sp                                              // update fp register

        storeThese(x19, x20, 16)                                        // storing in memory location fp+16 and fp+24 the registers x19 and x20 respectively
        storeThese(x21, x22, 32)                                        // storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively
        storeThese(x23, x24, 48)                                        // storing in memory location fp+16 and fp+24 the registers x23 and x24 respectively
        storeThese(x25, x26, 64)                                        // storing in memory location fp+16 and fp+24 the registers x25 and x26 respectively
        storeThese(x27, x28, 80)                                        // storing in memory location fp+16 and fp+24 the registers x27 and x28 respectively

	mov	column,	x0						// setting fourth argument of gameLoop to column
	mov	row,	x1						// setting second argument of gameLoop to row
        mov     base,   x2                                              // setting third argument of gameLoop to base

        mov     base_2, base                                            // setting base_2 to be same as base
        mov     x0,     row                                             // copying row to x0
        mul     x0,     x0,     column                                  // multiply the row value in x0 by column
        lsl     x0,     x0,     3                                       // multiply row*column by 8 because float array contains cells of 8
        add     base_2, base_2, x0                                      // moving base_2 down past the float array in stack

	mov	w0,	0						// move 0 to w0 to be converted to float
	scvtf	d0,	w0						// convert to float
	fmov	score,	d0						// set score to 0.00
	mov	bombs,	3						// set bombs to 3
	mov	lives,	3						// set lives to 3

	mov	double_range,	0					// set double_range to 0
	mov	other_specials,	0					// set other_specials to 0
	mov	exit_tile,	0					// set exit_tile to 0

	str	score,	[fp,96]						// store in memory score
	str	bombs,	[fp,104]					// store in memory bombs
	str	lives,	[fp,108]					// store in memory lives
	
	str	double_range,	[fp,112]				// store in memory double_range
	str	other_specials,	[fp,116]				// store in memory other_specials
	str	exit_tile,	[fp,120]				// store in memory exit_tile

	ldr     x0,     =prnfmt21					// print to the user the lives count
        ldr     w1,     [fp,108]					// print to the user the lives count
        bl      printf							// print to the user the lives count

        ldr     x0,     =prnfmt22					// print to the user the starting score
        ldr     d0,     [fp,96]						// print to the user the starting score
        bl      printf							// print to the user the starting score

        ldr     x0,     =prnfmt23					// print to  the user the bomb count
        ldr     w1,     [fp,104]					// print to  the user the bomb count
        bl      printf							// print to  the user the bomb count

topGame_loop:								// label is used to return here by some functions
	printThis(prnfmt7)						// print the nextline character
	printThis(prnfmt8)						// prompt the user for input
	ldr	x0,	=scnfmt						// use scnfmt to collect user input
	ldr	x1,	=entered_x					// store first int in entered_x
	ldr	x2,	=entered_y					// store secodn int in entered_y
	bl	scanf							// collect user input

	mov     w0,     0						// move 0 to w0 to be converted to float
        scvtf   d0,     w0						// convert to float
	fmov	running_score, d0					// set running_score to 0.00
	
	ldr	double_range, [fp,112]					// load the double range variable
	cmp	double_range,	0					// compare it to 0
	b.ne	doubleRangeNotice					// if double range is not equal to zero, they found specials on previous roll so inform them they're double ranged 
	
continue_game_run_A:							// label is used to return here by some functions
	ldr     double_range,   [fp,112]				// load the double range variable

	mov	w0,	1						// move 1 to w0 to be used in calculations
	lsl	layers,	w0,	double_range				// calculate the numebr of layers = 2^double_range
			
	mov	double_range,	0					// reset double range to 0 after it has been used on calculations
	str	double_range,	[fp,112]				// store new value of double_range

	ldr     x0,     =entered_x					// load into x0 address of entered_x
        ldr     bomb_1, [x0]						// store in bomb_1 value of entered_x
        ldr     x0,     =entered_y					// load into x0 address of entered_y
        ldr     bomb_2, [x0]						// store in bomb_2 value of entered_y

	mov	row_start_w,	bomb_1					// copy to row_start_w the value of bomb_1
	sub	row_start_w,	row_start_w,	layers			// subtract the number of layers we'll be assessing

	mov	row_end_w,	bomb_1					// copy to row_end_w the value of bomb_1
	add	row_end_w,	row_end_w,	layers			// add the number of layers we'll be assessing

	mov	column_start_w,	bomb_2					// copy to column_start_w the value of bomb_2
	sub	column_start_w,	column_start_w,	layers			// subtract the number of layers we'll be assessing

	mov	column_end_w,	bomb_2					// copy to column_end_w the value of bomb_2
	add	column_end_w,	column_end_w,	layers			// add the number of layers we'll be assessing

	printThis(prnfmt7)						// print the nextline character

	str	column_start_w,	[fp,124]				// store in memory the original value of column_start_w

game_running:
	cmp	row_start_w,	0					// checking the row_starting position is within range
	b.lt	continue_game_run					// if not we increment column index and loop back to here

	cmp	row_start_w,row_w					// checking the row_starting position is within range
	b.ge	continue_game_run					// if not we increment column index and loop back to here

	cmp	column_start_w,	0					// checking the column_starting position is within range
	b.lt	continue_game_run					// if not we increment column index and loop back to here

	cmp	column_start_w,column_w					// checking the column_starting position is within range
	b.ge	continue_game_run					// if not we increment column index and loop back to here

	mul	offset,	column,	row_start				// calculating the offset in row i_r, j_r
	add	offset,	offset,	column_start				// calculating the offset in row i_r, j_r

	ldrb	w0,	[base_2,offset]					// loading the character in i,j
	cmp	w0,	cover						// comparing the character to how it should be in covered state
	b.ne	alreadyUncovered					// if the character has already been uncovered we branch to a function that moves us to the next cell

	mul     offset, column, row_start                               // calculating the offset in row i_r, j_r
        add     offset, offset, column_start                            // calculating the offset in row i_r, j_r
        lsl     offset, offset, 3                                       // calculating the offset in row i_r, j_r
        
        ldr     value,  [base,offset]					// loading the value in row_start, column_start
	
	fmov	d0,	15.00						// comparing it to 15 because our specials are all larger than 15
	fcmp	value,	d0						// comparison
	b.gt	specialToDealWith					// if it is larger than 15 we branch to function that deals with specials

	fadd	running_score,	running_score,	value			// if it is normal value we then add it to score for this roll
	
	mov     w0,     0						// move 0 to w0 to be converted to float
        scvtf   d0,     w0						// convert to float
	fcmp	value,	d0						// compare value with 0, if it is lower than 0 we branch to negative func
	b.lt	negative_uncovered					// branch to here

	b	positive_uncovered					// otherwise it must be positive and we branch here

continue_game_run:							// label is used to return here from certain functions
	add	column_start_w,	column_start_w,	1			// incremement column_start_w which is our index
	cmp	column_start_w,	column_end_w				// check if it is larger than limit
	b.le	game_running						// if not we continue the loop

	ldr	column_start_w,	[fp,124]				// reset the value in column_start

	add	row_start_w,	row_start_w,	1			// increment our row index
	cmp	row_start_w,	row_end_w				// check if it is larger than limit
	b.le	game_running						// if not we continue the loop

	ldr	other_specials,	[fp,116]				// load the value in other specials to see if it has been activated
	cmp	other_specials, 27					// compare it to 27
	b.eq	other_specials_27					// we branch to the a function that carries out bonus rewards

	cmp	other_specials, 28					// compare it to 27
	b.eq	other_specials_28					// we branch to the a function that carries out bonus rewards

printing_game_state:							// label is used to return here from certain functions
	ldr	x0,	=prnfmt31					// load the running score message
	fmov	d0,	running_score					// print to the user what their score for this certain roll was
	bl	printf							// branch to C function printf

	ldr	score,	[fp,96]						// load the total score
	fadd	score,	score,	running_score				// add to the total score the score for this particular roll
	str	score,	[fp,96]						// store new value back
	
	ldr     bombs,  [fp,104]					// load bombs
        sub     bombs,  bombs,  1					// decrement bombs as user used one of them 
        str     bombs,  [fp,104]					// store new value back
	
	mov	w0,	0						// move 0 to w0 to be converted to float
	scvtf	d0,	w0						// convert to float
	fcmp	running_score, d0					// if running score is less than 0 thereby negative we decrement a life and zero the score
	b.lt	lives_decrement						// function that decrements lives and zeroes the score

printing_game_state_B:							// label is used to return here from certain functions
	mov	x0,	column						// set column as first arg
	mov	x1,	row						// set row as first arg
	mov	x2,	base						// set base as third arg
	bl	display							// display character table

	ldr     x0,     =prnfmt21					// load print lives message
        ldr     w1,     [fp,108]					// printing the number of lives remaining
        bl      printf							// printing

        ldr     x0,     =prnfmt22					// load score message
        ldr     d0,     [fp,96]						// printing total score
        bl      printf							// printing

        ldr     x0,     =prnfmt23					// load bombs message
        ldr     w1,     [fp,104]					// printing the bombs remaining
        bl      printf							// printing

	ldr	lives,	[fp,108]					// load lives
	cmp	lives,	0						// check if we still have lives left
	b.le	game_over						// end game if no lives left

	ldr	bombs,	[fp,104]					// load bombs
	cmp	bombs,	0						// check if still bombs left
	b.le	game_over						// end game if no bombs

	ldr	exit_tile,	[fp,120]				// load exit tile
	cmp	exit_tile,	1					// check if exit tile was found
	b.eq	game_end_exit_tile					// end game if it was

	b	topGame_loop						// branch back to the top of subroutine

game_end_exit_tile:							// label is used to return here from certain functions
	printThis(prnfmt24)						// print to the user they found exit tile and won game

game_end:								// label is used to return here from certain functions
	restoreThese(x19, x20, 16)                                      // loading from memory location fp+16 and fp+24 the registers x19 and x20 respectively
        restoreThese(x21, x22, 32)                                      // loading from memory location fp+16 and fp+24 the registers x21 and x22 respectively
        restoreThese(x23, x24, 48)                                      // loading from memory location fp+16 and fp+24 the registers x23 and x24 respectively
        restoreThese(x25, x26, 64)                                      // loading from memory location fp+16 and fp+24 the registers x25 and x26 respectively
        restoreThese(x27, x28, 80)                                      // loading from memory location fp+16 and fp+24 the registers x27 and x28 respectively

        ldp     fp,     lr,     [sp],  144                              // restore fp and link registers
        ret


insertExit:
    	stp     fp,     lr,     [sp,-32]!                               // save fp register and link register current values
        mov     fp,     sp                                              // update fp register

    	storeThese(x21, x22, 16)					// storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively

    	bl  	rand							// branch to C function rand
	udiv	x2,	x0,	row					// do modulus of random and row value= rand() % row
	msub	x3,	x2,	row,	x0				// do modulus of random and row value= rand() % row
	mov     i_r,    x3						// copy result of modulus to i_r
	
    	bl  	rand							// branch to C function rand
	udiv    x2,     x0,     column					// do modulus of random and row value= rand() % row
        msub    x3,     x2,     column,    x0				// do modulus of random and row value= rand() % row
        mov     j_r,    x3						// copy result of modulus to j_r
	
    	mul	offset,	column,	i_r					// calculating the offset in row i_r, j_r
	add	offset,	offset,	j_r					// calculating the offset in row i_r, j_r
	lsl	offset,	offset,	3					// calculating the offset in row i_r, j_r

	mov	w0,	25						// copy to register w0 25 to be converted to float
	scvtf	exit,	w0						// convert 25 to float

    	str 	exit,   [base, offset]					// store float representation of exit (25.00) somewhere on the board

    	restoreThese(x21, x22, 16)					// storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively

    	ldp     fp,     lr,     [sp],  32                              	// restore fp and link registers
    	ret	

insertBonusSpecials:
    	stp     fp,     lr,     [sp,-32]!                               // save fp register and link register current values
        mov     fp,     sp                                              // update fp register

    	storeThese(x21, x22, 16)					// storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively

	bl      rand							// branch to C function rand
        udiv    x2,     x0,     row					// do modulus of random and row value= rand() % row
        msub    x3,     x2,     row,    x0				// do modulus of random and row value= rand() % row
        mov     i_r,    x3						// copy result of modulus to i_r

        bl      rand							// branch to C function rand
        udiv    x2,     x0,     column					// do modulus of random and row value= rand() % row
        msub    x3,     x2,     column,    x0				// do modulus of random and row value= rand() % row
        mov     j_r,    x3						// copy result of modulus to j_r

        mul     offset, column, i_r                                     // calculating the offset in row i_r, j_r
        add     offset, offset, j_r                                     // calculating the offset in row i_r, j_r
        lsl     offset, offset, 3                                       // calculating the offset in row i_r, j_r

        mov     w0,     27						// copy to register w0 27 to be converted to float
        scvtf   exit,   w0						// convert 27 to float

        str     exit,   [base, offset]					// store float representation of bonusA (27.00) somewhere on the board
	
	bl      rand							// branch to C function rand
        udiv    x2,     x0,     row					// do modulus of random and row value= rand() % row
        msub    x3,     x2,     row,    x0				// do modulus of random and row value= rand() % row
        mov     i_r,    x3						// copy result of modulus to i_r

        bl      rand							// branch to C function rand
        udiv    x2,     x0,     column					// do modulus of random and row value= rand() % row
        msub    x3,     x2,     column,    x0				// do modulus of random and row value= rand() % row
        mov     j_r,    x3						// copy result of modulus to j_r

        mul     offset, column, i_r                                     // calculating the offset in row i_r, j_r
        add     offset, offset, j_r                                     // calculating the offset in row i_r, j_r
        lsl     offset, offset, 3                                       // calculating the offset in row i_r, j_r

        mov     w0,     28						// copy to register w0 28 to be converted to float
        scvtf   exit,   w0						// convert 28 to float

        str     exit,   [base, offset]					// store float representation of bonusB (28.00) somewhere on the board

    	restoreThese(x21, x22, 16)					// storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively

    	ldp     fp,     lr,     [sp],  32                              	// restore fp and link registers
    	ret	

toSpecial:
	stp     fp,     lr,     [sp,-32]!                               // save fp register and link register current values
        mov     fp,     sp                                              // update fp register

        storeThese(x21, x22, 16)                                        // storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively
	
	mov     x21,    x0                                              // copy to x21 our special_max arg
        cmp     x21,    special_count                                	// check if we've maxed out our special quota
        b.eq    endSpecMaker                                            // branch to end of tospecial func

        bl      rand                                                    // branch to C function rand
        mov     x1,     12                                              // copy into x1 12 to be modulo with rand
        udiv    x2,     x0,     x1                                      // do modulus of random and 12 = rand() % 12
        msub    x3,     x2,     x1,     x0                              // do modulus of random and 12 = rand() % 12

        mov     x1,    	3                                               // copy into x1 12 to be modulo with rand
        udiv    x0,     x3,     x1                                      // do modulus of x3 and 2 = x3 % 2
        msub    x4,     x0,     x1,     x3                              // do modulus of x3 and 2 = x3 % 2

        cmp     x4,     1                                               // if result of modulo random number (between 0 and 12) and 2 is 1 we branch to end other wise we make spec
        b.eq    endNegMaker                                             // branch to end spec function

	fcmp	random_f,0						// to ensure we're not making negatives special
	b.lt	endSpecMaker						// branch to end spec function

	mov	w1,	26						// copy 26 to w1 to be converted to a float value
	scvtf	random_f,w1						// copy 26.00 in to random_f which is float representation of special tile
        add 	special_count, special_count, 1                        	// increment the special counter

endSpecMaker:
        restoreThese(x21, x22, 16)                                      // storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively

        ldp     fp,     lr,     [sp],  32                               // restore fp and link registers
        ret


toNegative:
    	stp     fp,     lr,     [sp,-32]!                               // save fp register and link register current values
        mov     fp,     sp                                              // update fp register

    	storeThese(x21, x22, 16)					// storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively
        
    	mov 	x21,    x0  						// copy to x21 our negative_max arg
	cmp	x21,	negative_count					// check if we've maxed out our negative quota
	b.eq	endNegMaker						// branch to end of tonegative func

    	bl	rand							// branch to C function rand
	mov	x1,	12						// copy into x1 12 to be modulo with rand
	udiv	x2,	x0,	x1					// do modulus of random and 12 = rand() % 12
	msub	x3,	x2,	x1,	x0				// do modulus of random and 12 = rand() % 12

	mov	x1,	2						// copy into x1 12 to be modulo with rand
	udiv	x0,	x3,	x1					// do modulus of x3 and 2 = x3 % 2
	msub	x4,	x0,	x1,	x3				// do modulus of x3 and 2 = x3 % 2

	cmp	x4,	1						// if result of modulo random number (between 0 and 12) and 2 is 1 we branch to end other wise we make neg
	b.eq	endNegMaker						// branch to end neg function
	
	fmov	d0,	25.00
	fcmp	random_f,d0						// ensuring we don't make any special characters negative
	b.eq	endNegMaker						// ensuring we don't make any special characters negative

	fmov	d0,	26.00
	fcmp    random_f,d0						// ensuring we don't make any special characters negative
        b.eq    endNegMaker						// ensuring we don't make any special characters negative
			
	fmov	d0,	27.00
	fcmp    random_f,d0						// ensuring we don't make any special characters negative
        b.eq    endNegMaker						// ensuring we don't make any special characters negative

	fmov	d0,	28.00
	fcmp    random_f,d0						// ensuring we don't make any special characters negative
        b.eq    endNegMaker						// ensuring we don't make any special characters negative
	
    	mov     w1,     -1                                              // copy -1 to w1
        scvtf   d1,     w1                                              // convert -1 to float
        fmul    random_f,random_f,d1                                    // multiply the float by -1 and make negative

    	add negative_count, negative_count, 1				// increment the negative counter
	
endNegMaker:
        restoreThese(x21, x22, 16)					// storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively
        
	ldp     fp,     lr,     [sp],  32                              	// restore fp and link registers
   	ret	

randomNumber:
	stp     fp,     lr,     [sp,-32]!                               // save fp register and link register current values
        mov     fp,     sp                                              // update fp register

	storeThese(x21, x22, 16)					// storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively
        
	mov	max,	x0						// setting the value of our max to first argument
	mov	min,	x1						// setting the value of our min to second argument
rand_loop:	
	bl	rand							// branching to C fu ction rand which generates random integer
	mov	random_w,w0						// moving the random number we generated into more stable register
	mov 	random, x0              			        // moving the random number we generated into more stable register
    	and	random,	random,	0xF					// bitwise anding with 16
	cmp	random,	min						// ensuring the random integer is greater than our min
	b.lt	rand_loop						// if not we generate another integer
	cmp	random,	max						// ensuring the random integer is less than our max
	b.gt	rand_loop						// if not we generate another integer

    	scvtf 	random_f,   random_w					// converting number we generated to a float

    	bl  	rand							// branch to C function rand
	and	w0,	w0,	0x7C0					// bitwise and random number generated with 1984 
    	mov	w1,	2000						// copying 2000 into w1 
	scvtf	d1,	w1						// convert 2000 into float value
    	scvtf   d0, 	w0						// convert random number we generated to float
    	fdiv    d0, 	d0, 	d1					// divide random number generated that is between 0 and 1984 with 2000 to produce decimal between 0 and 0.99

    	mov	w1,	-1						// copy -1 to w1
	scvtf	d1,	w1						// convert -1 to float
    	fmul    d0, 	d0, 	d1					// make the decimal we generated earlier a negative value of itself
    	fadd    random_f, random_f, d0					// subtract a decimal between 0 and 0.99 to produce floating point random

	restoreThese(x21, x22, 16)					// loading from memory location fp+16 and fp+24 the registers x21 and x22 respectively
        
        ldp     fp,     lr,     [sp],  32                              	// restore fp and link registers
        ret	

initialise:
	stp     fp,     lr,     [sp,-96]!                               // save fp register and link register current values
        mov     fp,     sp                                              // update fp register
	
	storeThese(x19, x20, 16)                                        // storing in memory location fp+16 and fp+24 the registers x19 and x20 respectively
        storeThese(x21, x22, 32)                                        // storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively
        storeThese(x23, x24, 48)                                        // storing in memory location fp+16 and fp+24 the registers x23 and x24 respectively
        storeThese(x25, x26, 64)                                        // storing in memory location fp+16 and fp+24 the registers x25 and x26 respectively
        storeThese(x27, x28, 80)                                        // storing in memory location fp+16 and fp+24 the registers x27 and x28 respectively

	mov	base,	x0						// setting first argument of initialise to x0

   	mov 	base_2, base                				// setting base_2 to be same as base
    	mov 	x0, 	row						// copying row to x0
    	mul 	x0, 	x0, 	column					// multiply the row value in x0 by column
    	lsl 	x0, 	x0, 	3					// multiply row*column by 8 because float array contains cells of 8
	add 	base_2, base_2, x0          				// moving base_2 down past the float array in stack
	
	restoreThese(row, column, 16)					// load from memory the values of row and column the user entered

    	mov	i_r,	0						// set i for my loop to 0
	mov	j_r,	0						// set j for my loop to 0
	mov	offset,	0						// set offset for my loop to 0
	
	mov	x0,	xzr						// copy 0 into x0 for seeding of rand
	bl	time							// seeding of rand
	bl	srand							// seeding of rand
init1_loop:
	mov	x0,	15						// pass 15 as first arg os randomNumber
	mov	x1,	1						// pass 1 as second arg of randomNumber
	bl	randomNumber						// branching to function which generates a random floating point number between 0 and 15.00

	mul	offset,	column,	i_r					// multiply column by i which is row index. this is first part of offset
	add	offset,	offset,	j_r					// adding to offset j which is column index
	lsl	offset,	offset,	3					// multiplying offset by 4 because cell size is 4
	
	str	random_f,[base, offset]					// store in memory address base+offset the random value
	add	j_r,	j_r,	1					// incrementing the column index by 1
	cmp	j_r,	column						// comparing our count for how many columns with required size we want in column
	b.lt	init1_loop						// if we don't have enough columns we branch back to the start of the loop
	
	mov	j_r,	0						// copy 0 back into column index as we prepare to store new row
	mov	offset,	0
	add	i_r,	i_r,	1					// increment the row index by 1
	cmp	i_r,	row						// compare how many rows we already have with how many we need
	b.lt	init1_loop						// if we don't have enough rows we branch back to start of loop
	
    	mov 	negative_count, 0					// setting the counter for the number of negatives we have to 0
    	mov 	special_count, 0					// setting the counter for the number of specials we have to 0

    	mov 	count,  0						// set count for init3_loop to 0
insertions:
    	mov	i_r,	0						// set i for my loop to 0
	mov	j_r,	0						// set j for my loop to 0
	mov	offset,	0						// set offset for my loop to 0
	
init3_loop:
    	mul	offset,	column,	i_r					// multiply column by i which is row index. this is first part of offset
	add	offset,	offset,	j_r					// adding to offset j which is column index
	lsl	offset,	offset,	3					// multiplying offset by 4 because cell size is 4
	
    	ldr	random_f,[base, offset]					// store in memory address base+offset the random value

	mov     w0,     row_w						// copying into w0 the value of rpw
        mul     w0,     w0,     column_w				// multiplying row and column
        scvtf   d0,     w0						// converting row*column to float
        adrp    x0,     negative_percent                                // Load address of global var
        add     x0,     x0,     :lo12: negative_percent			// passing into x0 the address of value in negative_percent at data section
        ldr     d1,     [x0]						// loading into d1 the value in negative_percent
        fmul    d0,     d0,     d1					// multiplying cell number with negative_percent
        fcvtns  negative_max, d0					// converting to int the maximum negs allowed
	
	mov	x0,	negative_max					// passing negative_max as first argument of toNegative
	bl  	toNegative						// branching to toNegative which may make random_f negative

	mul     offset, column, i_r                                     // multiply column by i which is row index. this is first part of offset
        add     offset, offset, j_r                                     // adding to offset j which is column index
        lsl     offset, offset, 3                                       // multiplying offset by 8 because cell size is 8

	str	random_f,[base, offset]					/// storing possible altered random_f back to where it was loaded from
	
	mov     w0,     row_w						// copying into w0 the value of rpw
        mul     w0,     w0,     column_w				// multiplying row and column
        scvtf   d0,     w0						// converting row*column to float
        adrp    x0,     spec_percent                                    // Load address of global var
        add     x0,     x0,     :lo12: spec_percent			// passing into x0 the address of value in spec_percent at data section
        ldr     d1,     [x0]						// loading into d1 the value in spec_percent
        fmul    d0,     d0,     d1					// multiplying cell number with spec_percent
        fcvtns  special_max, d0						// converting to int the maximum specials allowed

	mov	x0,	special_max					// passing special_max as first argument of toSpecial
	bl	toSpecial						// branching to toSpecial which may make random_f special
    	
	mul     offset, column, i_r                                     // multiply column by i which is row index. this is first part of offset
        add     offset, offset, j_r                                     // adding to offset j which is column index
        lsl     offset, offset, 3                                       // multiplying offset by 8 because cell size is 8

	str	random_f,[base, offset]					/// storing possible altered random_f back to where it was loaded from

	add	j_r,	j_r,	1					// incrementing the column index by 1
	cmp	j_r,	column						// comparing our count for how many columns with required size we want in column
	b.lt	init3_loop						// if we don't have enough columns we branch back to the start of the loop
    
    	mov	j_r,	0						// copy 0 back into column index as we prepare to store new row
	mov	offset,	0
	add	i_r,	i_r,	1					// increment the row index by 1
	cmp	i_r,	row						// compare how many rows we already have with how many we need
	b.lt	init3_loop						// if we don't have enough rows we branch back to start of loop
	add	count,	count,	1 					// incrementing count by 1
   	cmp 	count,  7						// if we haven't executed the loop at least 7 times we branch back to top
    	b.lt    insertions						// branch back to top of loop

    	mov 	w2,  row_w						// copying into w2 the value in row
    	mul 	w2,	w2,  column_w					// multiplying row and column result is in w2

	mov	x0,	-16						// copying 16 to x0 to add 16 bytes on top of stack
	add	fp,	fp,	x0					// add 16 bytes on top of fp

	str	negative_count,[fp,0]					// store in memory the number of negatives on the board
	str	special_count, [fp,8]					// store in memory the number of specials on the board

    	ldr 	x0, 	=prnfmt17					// load prnfmt17 to x0
	ldr	w1,	[fp,0]						// load neg_count into w1
    	scvtf  	d1,  	w1						// converting neg_count to float
    	scvtf   d2, 	w2						// convertign number of cells to float
	fdiv    d0,     d1,     d2					// dividing number of neg by total cells
    	mov     w3,     100						// copying to w3 100
        scvtf   d1,     w3						// converting 100 to float
        fmul    d0,     d0,     d1					// coverting to percventage number of negs
	fcvtns	x3,	d0						// converting to int number if negs
        bl      printf							// print the number of negs

	mov     w2,  	row_w						// copying into w2 the value in row
        mul     w2,     w2,  column_w					// multiplying row and column result is in w2

	str     negative_count,[fp,0]					// store in memory the number of negatives on the board
        str     special_count, [fp,8]					// store in memory the number of specials on the board

	ldr	x0,	=prnfmt18					// load prnfmt18 to x0
	ldr	w1,	[fp,0]						// load neg_count into w1
	ldr	w3,	[fp,8]						// load spec_count into w3
	add	w5,	w1,	w3					// adding negs and specs putting result in w5
	sub	w1,	w2,	w5					// subtracting total from negs and specs to produce positives
	scvtf   d1,  	w1						// converting to float positives
        scvtf   d2, 	w2						// converting to float total
        fdiv    d0, 	d1, 	d2					// dividing number of positives by total cells
        mov     w3,     100						// copying to w3 100
        scvtf   d1,     w3						// converting 100 to float
        fmul    d0,     d0,     d1					// coverting to percventage number of positiives
        fcvtns  x3,     d0						// converting to int number if positiives
	bl      printf  						// print the number of positivies

	mov     w2,  row_w						// copying into w2 the value in row
        mul     w2,  w2,  column_w					// multiplying row and column result is in w2

	str     negative_count,[fp,0]					// store in memory the number of negatives on the board
        str     special_count, [fp,8]					// store in memory the number of specials on the board

	ldr	x0,	=prnfmt19					// load prnfmt19 to x0
	ldr	w1,	[fp,8]						// load spec_count into w1
        scvtf   d1,     w1						// converting spec_count to float
        scvtf   d2,     w2						// convertign number of cells to float
        fdiv    d0,     d1,     d2					// dividing number of specs by total cells
	mov     w3,     100						// copying to w3 100
        scvtf   d1,     w3						// converting 100 to float
        fmul    d0,     d0,     d1					// coverting to percventage number of specs
        fcvtns  x3,     d0						// converting to int number if specs	
        bl      printf							// print the number of specs

	mov	x0,	16						// copy 16 to x0 to deallocate bytes
	add	fp,	fp,	x0					// deallocate 16 bytes from top of stack

	bl  insertBonusSpecials						// insert to a random position on the board the bonus tiles
    	bl  insertExit							// inert to a random position on the board the exit tile

	mov     base_2, base                                            // setting base_2 to be same as base
        mov     x0,     row                                             // copying row to x0
        mul     x0,     x0,     column                                  // multiply the row value in x0 by column
        lsl     x0,     x0,     3                                       // multiply row*column by 8 because float array contains cells of 8
        add     base_2, base_2, x0                                      // moving base_2 down past the float array in stack

    	mov	i_r,	0						// set i for my loop to 0
	mov	j_r,	0						// set j for my loop to 0
	mov	offset,	0						// set offset for my loop to 0
	mov	random_w,cover						// set random for my loop to X

init2_loop:
	mul	offset,	column,	i_r					// multiply column by i which is row index. this is first part of offset
	add	offset,	offset,	j_r					// adding to offset j which is column index
	
	strb	random_w,[base_2, offset]				// store in memory address base+offset the random value
	add	j_r,	j_r,	1					// incrementing the column index by 1
	cmp	j_r,	column						// comparing our count for how many columns with required size we want in column
	b.lt	init2_loop						// if we don't have enough columns we branch back to the start of the loop
	
	mov	j_r,	0						// copy 0 back into column index as we prepare to store new row
	mov	offset,	0						// reset offset to 0
	add	i_r,	i_r,	1					// increment the row index by 1
	cmp	i_r,	row						// compare how many rows we already have with how many we need
	b.lt	init2_loop						// if we don't have enough rows we branch back to start of loop

	restoreThese(x19, x20, 16)                                      // loading from memory location fp+16 and fp+24 the registers x19 and x20 respectively
        restoreThese(x21, x22, 32)                                      // loading from memory location fp+16 and fp+24 the registers x21 and x22 respectively
        restoreThese(x23, x24, 48)                                      // loading from memory location fp+16 and fp+24 the registers x23 and x24 respectively
        restoreThese(x25, x26, 64)                                      // loading from memory location fp+16 and fp+24 the registers x25 and x26 respectively
        restoreThese(x27, x28, 80)                                      // loading from memory location fp+16 and fp+24 the registers x27 and x28 respectively
	
	ldp     fp,     lr,     [sp],  96                              	// restore fp and link registers
        ret

display:
	stp     fp,     lr,     [sp,-96]!                               // save fp register and link register current values
        mov     fp,     sp                                              // update fp register
	
	storeThese(x19, x20, 16)                                        // storing in memory location fp+16 and fp+24 the registers x19 and x20 respectively
        storeThese(x21, x22, 32)                                        // storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively
        storeThese(x23, x24, 48)                                        // storing in memory location fp+16 and fp+24 the registers x23 and x24 respectively
        storeThese(x25, x26, 64)                                        // storing in memory location fp+16 and fp+24 the registers x25 and x26 respectively
        storeThese(x27, x28, 80)                                        // storing in memory location fp+16 and fp+24 the registers x27 and x28 respectively
	
	mov	column,	x0						// setting first argument of display to column
	mov	row,	x1						// setting second argument of display to row
	mov	base,	x2						// setting third argument of display to base

    	mov 	x0,	row						// copy row to x0
    	mul 	x0, 	x0, 	column					// multiply row and column
    	lsl 	x0, 	x0, 	3					// multiply row*column by 8 because cells are of size 8 bytes

    	add base,   base,   x0						// move base down the stack by x0 bytes

	mov	i_r,	0						// set i for my loop to 0
	mov	j_r,	0						// set j for my loop to 0
	mov	offset,	0						// set offset for my loop to 0    	

d_loop:									// loop where we load from memory and print the data
	mul     offset, column, i_r					// multiply column by i which is row index. this is first part of offset
    	add     offset, offset, j_r					// adding to offset j which is column index
    
	ldrb	random_w,[base, offset]					// load from memory base+offset the random value we had stored earlier

	ldr	x0,	=prnfmt15					// load the string prnfmt15 into x0 to be printed
	mov	w1,	random_w					// copying into x1 the value of the random value to be printed
	bl	printf							// print the random value using C function printf
	
    	printThis(prnfmt6)						// print the space character

	add	j_r,	j_r,	1					// increment the column index by 1
	cmp	j_r,	column						// comparing the number of column we already printed and how many we need to print
	b.lt	d_loop							// if we haven't printed all the columns yet we branch back to loop
	
	printThis(prnfmt7)						// print the nextline character
	mov	j_r,	0						// copy 0 back into column index as we prepare to store new row
	add	i_r,	i_r,	1					// increment the row index by 1
	cmp	i_r,	row						// compare how many rows we already printed with how many we need to print
	b.lt	d_loop							// if we haven't printed enough rows we branch back to start of loop
	 	
	restoreThese(x19, x20, 16)                                      // loading from memory location fp+16 and fp+24 the registers x19 and x20 respectively
        restoreThese(x21, x22, 32)                                      // loading from memory location fp+16 and fp+24 the registers x21 and x22 respectively
        restoreThese(x23, x24, 48)                                      // loading from memory location fp+16 and fp+24 the registers x23 and x24 respectively
        restoreThese(x25, x26, 64)                                      // loading from memory location fp+16 and fp+24 the registers x25 and x26 respectively
        restoreThese(x27, x28, 80)                                      // loading from memory location fp+16 and fp+24 the registers x27 and x28 respectively

	ldp     fp,     lr,     [sp],   96                              // restore fp and link registers
        ret

displayUncovered:
	stp     fp,     lr,     [sp,-96]!                               // save fp register and link register current values
        mov     fp,     sp                                              // update fp register
	
	storeThese(x19, x20, 16)                                        // storing in memory location fp+16 and fp+24 the registers x19 and x20 respectively
        storeThese(x21, x22, 32)                                        // storing in memory location fp+16 and fp+24 the registers x21 and x22 respectively
        storeThese(x23, x24, 48)                                        // storing in memory location fp+16 and fp+24 the registers x23 and x24 respectively
        storeThese(x25, x26, 64)                                        // storing in memory location fp+16 and fp+24 the registers x25 and x26 respectively
        storeThese(x27, x28, 80)                                        // storing in memory location fp+16 and fp+24 the registers x27 and x28 respectively
	
	mov	column,	x0						// setting first argument of display to column
	mov	row,	x1						// setting second argument of display to row
	mov	base,	x2						// setting third argument of display to base

	mov	i_r,	0						// set i for my loop to 0
	mov	j_r,	0						// set j for my loop to 0
	mov	offset,	0						// set offset for my loop to 0    	

du_loop:								// loop where we load from memory and print the data uncovered
	mul     offset, column, i_r					// multiply column by i which is row index. this is first part of offset
        add     offset, offset, j_r					// adding to offset j which is column index
        lsl     offset, offset, 3					// multiplying offset by 8 because cell size is 8

	ldr	random_f, [base, offset]				// load from memory base+offset the random value we had stored earlier

	fmov	d0,	25.00						// move to d0 the value we want to compare
	fcmp	random_f,d0						// compare d0 with value in random_f
	b.eq	five_twenty						// if random_f is equal to special value we branch to print the special character

	fmov	d0,	26.00						// move to d0 the value we want to compare
	fcmp	random_f,d0						// compare d0 with value in random_f
	b.eq	six_twenty						// if random_f is equal to special value we branch to print the special character

	fmov	d0,	27.00						// move to d0 the value we want to compare
	fcmp    random_f,d0						// compare d0 with value in random_f
        b.eq    seven_twenty						// if random_f is equal to special value we branch to print the special character

	fmov	d0,	28.00						// move to d0 the value we want to compare
	fcmp    random_f,d0						// compare d0 with value in random_f
        b.eq    eight_twenty						// if random_f is equal to special value we branch to print the special character

	ldr	x0,	=prnfmt5					// load the string prnfmt6 into x0 to be printed
	fmov	d0,	random_f					// copying into d0 the value of the random value to be printed
	bl	printf							// print the random value using C function printf
	
    	printThis(prnfmt6)						// print two spaces

	add     j_r,    j_r,    1                                       // increment the column index by 1
        cmp     j_r,    column                                          // comparing the number of column we already printed and how many we need to print
        b.lt    du_loop                                                 // if we haven't printed all the columns yet we branch back to loop
	b       next_i_r						// branch to where we move to the next row
	
five_twenty:								// where we print the exit character
	ldr     x0,     =prnfmt15                                       // load the string prnfmt15 into x0 to be printed
        mov    	x1,     exit_C                                          // copying into x1 the value of the character to be printed
        bl      printf                                                  // print the random value using C function printf
	printThis(prnfmt6)						// print two spaces

	add     j_r,    j_r,    1                                       // increment the column index by 1
        cmp     j_r,    column                                          // comparing the number of column we already printed and how many we need to print
        b.lt    du_loop                                                 // if we haven't printed all the columns yet we branch back to loop
	b	next_i_r						// branch to where we move to the next row

six_twenty:								// where we print the $ character
	ldr     x0,     =prnfmt15                                       // load the string prnfmt15 into x0 to be printed
        mov  	x1,     special_C                                       // copying into x1 the value of character to be printed
        bl      printf                                                  // print the random value using C function printf
	printThis(prnfmt6)						// print two spaces

	add     j_r,    j_r,    1                                       // increment the column index by 1
        cmp     j_r,    column                                          // comparing the number of column we already printed and how many we need to print
        b.lt    du_loop                                                 // if we haven't printed all the columns yet we branch back to loop
	b       next_i_r						// branch to where we move to the next row

seven_twenty:								// where we print bonusA character 
	ldr     x0,     =prnfmt15                                       // load the string prnfmt15 into x0 to be printed
        mov    	x1,     bonusA                                          // copying into x1 the value of the character to be printed
        bl      printf                                                  // print the random value using C function printf
	printThis(prnfmt6)						// print two spaces

	add     j_r,    j_r,    1                                       // increment the column index by 1
        cmp     j_r,    column                                          // comparing the number of column we already printed and how many we need to print
        b.lt    du_loop                                                 // if we haven't printed all the columns yet we branch back to loop
	b       next_i_r						// branch to where we move to the next row

eight_twenty:								// where we print the character for bonusB
	ldr     x0,     =prnfmt15                                       // load the string prnfmt15 into x0 to be printed
        mov    	x1,     bonusB                                          // copying into x1 the value of the character to be printed
        bl      printf                                                  // print the random value using C function printf
	printThis(prnfmt6)						// print two spaces

	add	j_r,	j_r,	1					// increment the column index by 1
	cmp	j_r,	column						// comparing the number of column we already printed and how many we need to print
	b.lt	du_loop							// if we haven't printed all the columns yet we branch back to loop
next_i_r:	
	printThis(prnfmt7)						// print the nextline character
	mov	j_r,	0						// copy 0 back into column index as we prepare to store new row
	add	i_r,	i_r,	1					// increment the row index by 1
	cmp	i_r,	row						// compare how many rows we already printed with how many we need to print
	b.lt	du_loop							// if we haven't printed enough rows we branch back to start of loop
	 	
	restoreThese(x19, x20, 16)                                      // loading from memory location fp+16 and fp+24 the registers x19 and x20 respectively
        restoreThese(x21, x22, 32)                                      // loading from memory location fp+16 and fp+24 the registers x21 and x22 respectively
        restoreThese(x23, x24, 48)                                      // loading from memory location fp+16 and fp+24 the registers x23 and x24 respectively
        restoreThese(x25, x26, 64)                                      // loading from memory location fp+16 and fp+24 the registers x25 and x26 respectively
        restoreThese(x27, x28, 80)                                      // loading from memory location fp+16 and fp+24 the registers x27 and x28 respectively

	ldp     fp,     lr,     [sp],   96                              // restore fp and link registers
        ret

specialToDealWith:							// label name is used to come here by some functions
	mul     offset, column, row_start                               // calculating the offset in row i_r, j_r
        add     offset, offset, column_start                            // calculating the offset in row i_r, j_r
        lsl     offset, offset, 3                                       // calculating the offset in row i_r, j_r

        ldr     value,  [base,offset]					// load the value in row_start,column_start
	fmov	d0,	25.00						// move into d0 25 for comparison
	fcmp	value,	d0						// if value is equal to 25.00 we branch to function that deals with it
	b.eq	spec_25							// function that stores correct character and updates correct variables

	fmov	d0,	26.00						// move into d0 26 for comparison
	fcmp	value,	d0						// if value is equal to 26.00 we branch to function that deals with it
	b.eq	spec_26							// function that stores correct character and updates correct variables

	fmov	d0,	27.00						// move into d0 27 for comparison
	fcmp	value,	d0						// if value is equal to 27.00 we branch to function that deals with it
	b.eq	spec_27							// function that stores correct character and updates correct variables

	fmov	d0,	28.00						// move into d0 28 for comparison
	fcmp	value,	d0						// if value is equal to 28.00 we branch to function that deals with it
	b.eq	spec_28							// function that stores correct character and updates correct variables

spec_25:								// label name is used to come here by some functions
	mul     offset, column, row_start                               // calculating the offset in row i_r, j_r
        add     offset, offset, column_start                            // calculating the offset in row i_r, j_r

	mov	w0,	exit_C						// move to w0 the exit character
	strb	w0,	[base_2,offset]					// store the character in correct location

	mov	exit_tile,	1					// update the exit tile value
	str	exit_tile,	[fp,120]				// store new value in memory

	b	continue_game_run					// go back to where we resume game loop
	
spec_26:								// label name is used to come here by some functions
	mul     offset, column, row_start                               // calculating the offset in row i_r, j_r
        add     offset, offset, column_start                            // calculating the offset in row i_r, j_r

        mov     w0,     special_C					// move to w0 the special character
        strb    w0,     [base_2,offset]					// store the character in correct location

	ldr	double_range,	[fp,112]				// load double range from memory
	add	double_range,	double_range,	1			// increment the double range counter
	str	double_range,	[fp,112]				// store new value in memory

	b	continue_game_run					// go back to where we resume game loop

spec_27:								// label name is used to come here by some functions
	mul     offset, column, row_start                               // calculating the offset in row i_r, j_r
        add     offset, offset, column_start                            // calculating the offset in row i_r, j_r

        mov     w0,     bonusA						// move to w0 the bonusA character
        strb    w0,     [base_2,offset]					// store the character in correct location

	ldr	other_specials,	[fp,116]				// load other specials from memory
	add	other_specials,	other_specials,	27			// update the value
	str	other_specials,	[fp,116]				// store new value in memory

	b	continue_game_run					// go back to where we resume game loop

spec_28:								// label name is used to come here by some functions
	mul     offset, column, row_start                               // calculating the offset in row i_r, j_r
        add     offset, offset, column_start                            // calculating the offset in row i_r, j_r

        mov     w0,     bonusB						// move to w0 the bonusB character
        strb    w0,     [base_2,offset]					// store the character in correct location

	ldr     other_specials, [fp,116]				// load other specials from memory
        add     other_specials, other_specials, 28			// update the value
        str     other_specials, [fp,116]				// store new value in memory

        b       continue_game_run					// go back to where we resume game loop
	
negative_uncovered:							// label name is used to come here by some functions
	mul     offset, column, row_start                               // calculating the offset in row i_r, j_r
        add     offset, offset, column_start                            // calculating the offset in row i_r, j_r

        mov     w0,     negative					// move to w0 the negative character
        strb    w0,     [base_2,offset]					// store the character in correct location

	b	continue_game_run					// go back to where we resume game loop

positive_uncovered:							// label name is used to come here by some functions
	mul     offset, column, row_start                               // calculating the offset in row i_r, j_r
        add     offset, offset, column_start                            // calculating the offset in row i_r, j_r

        mov     w0,     positive					// move to w0 the positive character
        strb    w0,     [base_2,offset]					// store the character in correct location

        b       continue_game_run					// go back to where we resume game loop

other_specials_27:							// label name is used to come here by some functions
	ldr	lives,	[fp,108]					// load lives from memory
	add	lives,	lives,	3					// increment lives by 3
	str	lives,	[fp,108]					// store new lives value back in memory

	mov	other_specials,	0					// reset other specials to 0
	str	other_specials,	[fp,116]				// store new value in memory
	printThis(prnfmt27)						// inform the user they found the bonusA
	
	b       printing_game_state					// go back to where we resume game loop

other_specials_28:							// label name is used to come here by some functions
	mov     w0,     0						// move to w0 0 to be converted to float
        scvtf   d0,     w0						// convert to float
	fcmp	running_score,	d0					// compare 0 to running_score to see if it is negative
	b.ge	other_specials_28_continued				// if it is not negative we branch here
	
	mov	w0,	-1						// move to w0 -1 to be converted to float
	scvtf	d0,	w0						// convert to float
	fmul	running_score,	running_score,	d0			// make negative running_score positive
other_specials_28_continued:						// label name is used to come here by some functions
	fmov	d0,	2.00						// move to d0 the float 2.00
	fmul	running_score,	running_score,	d0			// double the running_score

	mov     other_specials, 0					// reset other specials to 0
        str     other_specials, [fp,116]				// store new value in memory
	printThis(prnfmt29)						// inform the user they found the bonusB

	b       printing_game_state					// go back to where we resume game loop

lives_decrement:							// label name is used to come here by some functions
	ldr	lives,	[fp,108]					// load value of lives
	sub	lives,	lives,	1					// decrement the lives
	str	lives,	[fp,108]					// store the new lives value in memory

	mov	w0,	0						// move to w0 0 to be converted to float
	scvtf	d0,	w0						// convert to float
	fmov	score,	d0						// move to score the value in d0
	str	score,	[fp,96]						// reset score value to 0 and store in memory
	printThis(prnfmt26)						// inform the user they lost a life

	b	printing_game_state_B					// go back to where we resume game loop

game_over:								// label name is used to come here by some functions
	printThis(prnfmt25)						// inform the user the game has ended and they lost
	b	game_end						// go back to where we resume game loop
	
alreadyUncovered:							// label name is used to come here by some functions
	add	column_start,	column_start,	1			// increment column_start to skip past already uncovered cell
	b	game_running						// branch back to the loop that goes through blast radius

doubleRangeNotice:							// label name is used to come here by some functions
	printThis(prnfmt30)						// inform the user they'll get an enhanced blast
	b	continue_game_run_A					// go back to where we resume game loop

wrongBombInput:								// label name is used to come here by some functions
	printThis(prnfmt9)						// print error message about wrong coordinate input
	b	topGame_loop						// branch back to the top of the game loop

wrongArguments:								// label name for where we return error message of wrong argument number
	printThis(prnfmt2)
	b	endEarly						// branch to the end function that restores registers

wrongInput:								// label name for where we return error message for wrong values for row and column
	printThis(prnfmt3)
	b	endEarly						// branch to the end function that restores registers

end:									// label name for where we deallocate the memory for the 2d array and restore registers if the program ran
	printThis(prnfmt4)					
	sub	alloc_r,	xzr,	alloc_r				// make the allocated memory a minus of itself (alloc*-1)
	add	sp,		sp,	alloc_r				// remove the allocated memory from the stack frame
endEarly:								// label name for where we end if user entered incorrect M and/or N values before we allocate memory
	ldp	fp,	lr,	[sp],	32				// restore fp and link registers
	ret

	.data								// where entered variables are stored
	entered_x:		.int	0				// we will store the requested coordinates here
	entered_y:              .int    0                               // we will store the requested coordinates here
	spec_percent:		.double	0.2				// the percentage of specials we want	
	negative_percent:	.double	0.4				// the percentage of negatives we want	
