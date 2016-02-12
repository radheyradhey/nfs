.data
	str1: .asciiz "Enter string 1 : "
	buffer1: .space 40
	
.text
	li $v0, 4
	la $a0, str1
	syscall
	
	li $v0, 8
	la $a0, buffer1
	li $a1, 30
	syscall
	 
	la $t0, buffer1
	li $s1, 0
	 
	loop:
	
		bne $s1, 1, gotit
		
		li $v0, 11
		move $a0, $t2
		syscall
		
		j exit
		
		gotit:
		
		lb $t2, 0($t0)
		la $t1, buffer1
		
		addi $t0, $t0, 1
		
		beqz $t2, exit
		beq $t2, 10, exit
		li $s1, 0
		
		loop2:
			
			lb $t3, 0($t1)
			beqz $t3, loop
			beq $t3, 10, loop
			
			bne $t3, $t2, cont
			
			addi $s1, $s1, 1
			
			cont:
				addi $t1, $t1, 1
				j loop2
				
		j loop
		
		 
	exit:
		
		li $v0, 10
		syscall
