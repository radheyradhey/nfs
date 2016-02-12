.data
	str1: .asciiz "Enter n : "
	str2: .asciiz "\nFibonaccii number is : "
	
.text
	li $v0, 4
	la $a0, str1 
	syscall
	
	li $v0, 5
	syscall
	
	move $s0, $v0
	move $s7, $s0
	
	li $t0, 3
	
	li $s1, 1
	li $s2, 1
	
	li $v0, 4
	la $a0, str2
	syscall
	
	loop:
		blt $s0, $t0, exit
		beq $s0, $t0, print
		addi $s0, $s0, -1
		
		add $s3, $s1, $s2
		
		move $s1, $s2
		move $s2, $s3
		
		j loop	
		
	exit:
		bne $s7, 0, done
		
		li $v0, 1
		li $a0, 0
		syscall
		
		done:
			li $v0, 1
			move $a0, $s1
			syscall
			j finish
	
	print: 
		add $s2, $s1, $s2
		
		li $v0, 1
		move $a0, $s2
		syscall
	
	finish:
	
		li $v0, 10
		syscall	