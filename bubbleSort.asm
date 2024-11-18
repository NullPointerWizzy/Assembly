	.data
array:		.space 40
prompt:		.asciiz "Enter a value between 1 and 10: "
numToSort:	.asciiz "Enter a number to be sorted: "
error:		.asciiz "Invalid input. "
comma:		.asciiz ","

	.text
	.globl main

main:
	j ReadNums
	move $t9, $s0
	j Loop
	j PrintNums
	jr $ra
	

BSort:
	move $t0, $s0
	addiu $t0, $t0, -1
	la $t1, 0($s1)
	la $t2, 4($s1)

SortingLoop:
	addiu $t0, $t0, -1
	bgt $t1, $t2, Swap
	addiu $s0, $s0, 4
	bgtz $t0, SortingLoop

Check:
	li $v0, 4
	la $a0, error
	syscall
	j NumsInput


Swap:
	la $t2, 0($s1)
	la $t1, 4($s1)
Loop:
	j BSort
	addiu $t9, $t9, -1
	bgtz $t9, Loop	

	
PrintNums:
	move $t1, $s0
	li $t2, ','
PrintingLoop:
	la $v0,4
	la $a0, 0($s1)
	syscall
	la $v0, 4
	la $a0, ($t2)
	syscall
	addiu $v0, $v0, 4
	addiu $t1, $t1, -1
	bgtz $t1, PrintingLoop


ReadNums:
NumsInput:
	li $v0, 4
	la $a0, prompt
	syscall
	li $v0, 5
	syscall
	move $s0, $v0
	blt $s0, 1, Check
	bgt $s0, 10, Check
	move $t0, $s0
	li $t1, 0
Filling:
	addiu $t0, $t0, -1
	li $v0, 4
	la $a0, array
	syscall
	li $v0, 5
	syscall
	sw $s0, ($v0)
	addiu $s0, $s0, 4
	bgtz $t0, Filling

