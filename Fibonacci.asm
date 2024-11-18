# TITLE fibonacci	(fibonacci.s)
# This program handles the I/O for a fibonacci function.

	.data
# variables
IntPrompt:      .asciiz	"Enter a integer between 0 and 25: "
OutStr:         .asciiz	"\nThe Fibonacci value is "
LowError:	.asciiz	"\nYour input was too small.  Try again: "
HighError:      .asciiz	"\nYour input was too large.  Try again: "
AgainStr:	.asciiz	"\nWould you like to try again? (y/n): "
NewLine:        .asciiz	"\n"
YesNoBuf:	.space	5	# Plenty of room for 'yes' or 'no'
IntIn:          .word	0
IntMin:		.word	0
IntMax:		.word	25

	.text
	.globl main

again:  # print a newline on subsequent returns to main
la	$a0, NewLine		# point to NewLine
li	$v0, 4			# print_string
syscall

main:	# start of the main procedure
	
	# Get an integer
la	$a0, IntPrompt		# point to IntPrompt
li	$v0, 4			# print_string
syscall
	

GetInt:	
li	$v0, 5			# read_integer
syscall
move	$t1, $v0 		# move input before it gets changed
	
	# check if below min
lw	$a1, IntMin		# load our lower bound
bge	$v0, $a1, BigEnough	# if good, try next check
la	$a0, LowError		# point to Error string
li	$v0, 4			# print_string
syscall
j	GetInt	

	# check if above max
BigEnough:
lw	$a1, IntMax		# load our upper bound
ble	$v0, $a1, SmallEnough	# if good, try next check
la	$a0, HighError		# point to Error string
li	$v0, 4			# print_string
syscall
j	GetInt	
	
SmallEnough:
	# save the input, just in case
sw	$v0, IntIn
	
	# Print the text to go with the output
la	$a0, OutStr		# point to OutStr
li	$v0, 4			# print_string
syscall
sw 	$ra, -4($sp)


addiu 	$sp, $sp, -4 
lw 	$t1, IntIn
sw 	$t1, -8($sp)

addiu 	$sp, $sp, -8
jal 	fib

lw 	$t0, 4($sp)
lw 	$t1, 0($sp)

addiu	$sp, $sp, 8
lw 	$ra, 0($sp)

addiu 	$sp, $sp, 4


move 	$a0, $t0
li 	$v0, 1

syscall

	# Print a newline before continuing
la	$a0, NewLine		# point to NewLine
li	$v0, 4			# print_string
syscall
	
	# Prompt to see if the user wants to do it again
la	$a0, AgainStr		# point to AgainStr
li	$v0, 4			# print_string
syscall

	# Get the input
la	$a0, YesNoBuf		# point to YesNoBuf
li	$a1, 5			# length of buffer
li	$v0, 8			# read_string
syscall
lb	$t1, YesNoBuf		# load the first character into $t1

	# Test if first character is 'Y'
li	$t0, 89			# ASCII for 'Y'
beq	$t1, $t0, again	# equal, so run program again
	
	# Test if first character is 'y'
li	$t0, 121		# ASCII for 'y'
beq	$t1, $t0, again	# equal, so run program again
	
	# Not 'yes', so assume 'no' and end program
jr	$ra

Fibonacci: 
sw	$fp, -4($sp)


move	$fp, $sp 
addiu	$sp, $sp, -4 
sw	$ra, -4($sp) 


addiu	$sp, $sp, -4 
addiu	$sp, $sp, -4 
sw	$t1, -4($sp)

 
addiu	$sp, $sp, -4 
sw	$t0, -4($sp)


addiu	$sp, $sp, -4
lw	$t1, 0($fp)
li	$t0, 2
bge	$t1, $t0, Recursion 
sw	$t1, 4($fp) 


cleanup:
lw	$t0, 0($sp)
addiu	$sp, $sp, 4


lw	$t1, 0($sp)
addiu	$sp, $sp, 4


addiu	$sp, $sp, 4 
lw	$ra, 0($sp)


addiu	$sp, $sp, 4 
lw	$fp, 0($sp)


addiu	$sp, $sp, 4 
jr	$ra 
    
Recursion:
addiu	$t1, $t1, -1
sw	$t1, -8($sp)


addiu	$sp, $sp, -8
jal	fib


lw	$t0, 4($sp)
lw	$t1, 0($sp)
addiu	$sp, $sp, 8
sw	$t0, -12($fp)


addiu	$t1, $t1, -1 
sw	$t1, -8($sp)


addiu	$sp, $sp, -8
jal	Fibonacci 
lw	$t0, 4($sp) 
lw	$t1, 0($sp)
 
addiu	$sp, $sp, 8 
lw	$t1, -12($fp)

addu	$t1, $t1, $t0
sw	$t1, 4($fp)


j	cleanup 
