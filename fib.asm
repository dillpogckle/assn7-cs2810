.data
prompt: .asciiz "Please enter how many fibonacci numbers you would like: "
.align 2
array:  .space 128 
space: .asciiz " "
nl: .asciiz "\n"

.text
.globl main

main:
	la $a0, prompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	
	la $t3, array
	li $t4, 0
	
main_loop:
	move $a0, $t4
	jal fib
	sw $v0, 0($t3)
	
	la $a0, array
	addi $a1, $t4, 1
	jal print_array
	
	addi $t4, $t4, 1
	addi $t3, $t3, 4
	blt $t4, $s0, main_loop

main_done:
	li $v0, 10
	syscall

### PRINT LOGIC ###
print_array:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	move $t0, $a0
	move $t1, $a1
	li $t2, 0

print_loop:
	bge $t2, $t1, print_done
	
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	 la $a0, space
	 li $v0, 4
	 syscall
	
	 addi $t0, $t0, 4
	 addi $t2, $t2, 1
	 j print_loop

 print_done:
 	la $a0, nl
 	li $v0, 4
 	syscall
 	
 	lw $ra, 0($sp)
 	addi $sp, $sp, 4
 	jr $ra
 	
### FIB FUNCTION ###
fib:
	beqz $a0, fib_zero
	li $t5, 1
	beq $a0, $t5, fib_one
	
	subi $sp, $sp, 12
	sw $ra, 8($sp)
	sw $a0, 4($sp)
	
	subi $a0, $a0, 1
	jal fib
	sw $v0, 0($sp)
	
	lw $a0, 4($sp)
	subi $a0, $a0, 2
	jal fib
	
	lw $t6, 0($sp)
	add $v0, $v0, $t6
	
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	 
fib_zero:
	move $v0, $zero
	jr $ra
	
fib_one:
	li $v0, 1
	jr $ra	
