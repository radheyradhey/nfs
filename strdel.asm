.data
	str1: .asciiz "Enter string 1 : "
	str2: .asciiz "Enter string 2 : "
	buffer1: .space 40
	buffer2: .space 40
	buffer3: .space 40
	
.text
	li $v0, 4
	la $a0, str1
	syscall
	
	li $v0, 8
	la $a0, buffer1
	li $a1, 30
	syscall
	
	li $v0, 4
	la $a0, str2
	syscall
	
	li $v0, 8
	la $a0, buffer2
	li $a1, 30
	syscall
	
	la $t0, buffer1
	la $s0, buffer3
	
	loop:
		lb $t2, 0($t0)
		la $t1, buffer2
		
		addi $t0, $t0, 1
		
		beqz $t2, exit
		beq $t2, 10, exit
		li $s1, 0
		
		loop2:
			
			lb $t3, 0($t1)
			beqz $t3, check
			beq $t3, 10, check
			
			bne $t3, $t2, cont
			
			li $s1, 1
			
			cont:
				addi $t1, $t1, 1
				j loop2
				
		j loop
		
	check:
		beq $s1, 1, loop
		sb $t2, 0($s0)
		addi $s0, $s0, 1
		j loop
		
	exit:
		li $v0, 4
		la $a0, buffer3
		syscall