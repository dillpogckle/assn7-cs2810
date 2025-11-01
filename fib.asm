.data
prompt: .asciiz "Please enter how many fibonacci numbers you would like: "
.align 2
array:  .space 128 
space: .asciiz " "
nl: .asciiz "\n"

.text
.globl main

main:
	# prompt
	la $a0, prompt
	li $v0, 4
	syscall
	
	# get nth fib
	li $v0, 5
	syscall
	move $s0, $v0
	
	# load array and start index
	la $t3, array
	li $t4, 0
	
main_loop:
	# run fib
	move $a0, $t4
	jal fib
	sw $v0, 0($t3)
	
	# print iteration of array
	la $a0, array
	addi $a1, $t4, 1
	jal print_array
	
	# increment and if loop hasn't been completed n fib times repeat
	addi $t4, $t4, 1
	addi $t3, $t3, 4
	blt $t4, $s0, main_loop

main_done:
	# close program
	li $v0, 10
	syscall

### PRINT LOGIC ###
print_array:
	# made space on stack for ra because I thought I might call print array recursively
	# didn't end up doing so but will leave as is for future recursive printing use on other assignments
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	# move array and array length into temp vars
	move $t0, $a0
	move $t1, $a1
	li $t2, 0

print_loop:
	# check if every item has been printed
	bge $t2, $t1, print_done
	
	# print current item 
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	# print space
	la $a0, space
	li $v0, 4
	syscall
	
	# increment
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	j print_loop

 print_done:
 	# print new line and return
 	la $a0, nl
 	li $v0, 4
 	syscall
 	
 	lw $ra, 0($sp)
 	addi $sp, $sp, 4
 	jr $ra
 	
### FIB FUNCTION ###
fib:
	# base cases
	beqz $a0, fib_zero
	li $t5, 1
	beq $a0, $t5, fib_one
	
	# make room on the stack for return address, nth fib num, and fib(n-1)
	subi $sp, $sp, 12
	# store return and nth fib
	sw $ra, 8($sp)
	sw $a0, 4($sp)
	
	# fib(n-1)
	subi $a0, $a0, 1
	jal fib
	sw $v0, 0($sp)
	
	# fib(n-2)
	lw $a0, 4($sp)
	subi $a0, $a0, 2
	jal fib
	
	# fib(n-1) + fib(n-2)
	lw $t6, 0($sp)
	add $v0, $v0, $t6
	
	# return
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	 
fib_zero:
	# zero base case
	move $v0, $zero
	jr $ra
	
fib_one:
	# one base case
	li $v0, 1
	jr $ra	
