.data
str: .asciiz "1 5 67 2 6 45"
f1: .asciiz "\nFirst: "
s1: .asciiz "\nSecond: "
f2: .asciiz "\nNew First: "
s2: .asciiz "\nNew Second: "
arr: .word 1:10
fill1: .ascii "\nArray is : "
fill2: .asciiz " "


.text

li $t0, 12 # strlen

la $t1, str
la $t2, str

add $t2, $t2, $t0
div $t0, $t0, 2

li $t3, 0

rev:
	beq $t3, $t0, main
	addi $t3, $t3, 1
	
	lb $t4, 0($t1)
	lb $t5, 0($t2)
	
	sb $t5, 0($t1)
	sb $t4, 0($t2)
  	
 	addi $t1, $t1, 1
	addi $t2, $t2, -1
	
	j rev

main:
	
	li $t1, 1 # powers of 10
	li $t2, 0 # loop variable
	li $t0, 12
	li $t4, 0 # sum
	la $s0, str
	la $s1, arr
	
	li $v0, 4
	la $a0, str
	syscall	
	 
	loop:
		beq $t2, $t0, exit
		addi $t2, $t2, 1
		
		lb $t3, 0($s0)
		addi $s0, $s0, 1

		beq $t3, 32, sp
		bne $t3, 32, cont
		
		sp:
			sw $t4, 0($s1)
			addi $s1, $s1, 4			
			li $t4, 0	
			li $t1, 1
			 
			j loop
		
		cont:
			andi $t3, $t3, 0x0F
			mul $t3, $t3, $t1
			add $t4, $t4, $t3
			mul $t1, $t1, 10
			
			j loop
			
exit:

	li $v0, 4
	la $a0, fill1
	syscall
	 
	li $t0, 6
	li $t1, 0
	la $s0, arr
	
	loop2: 
		beq $t0, $t1, ekhey
		addi $t1, $t1, 1
		
		lw $a0, 0($s0)
		li $v0, 1
		syscall
		
		li $v0, 4
		la $a0, fill2
		syscall
		
		addi $s0, $s0, 4
		j loop2
		
ekhey:
