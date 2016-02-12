.data
	ans: .asciiz "\nSecond max is : "
	str1: .asciiz "Enter number of elements : "
	str2: .asciiz "\nEnter a number : "
	str3: .asciiz "\nExtracted : "
	arr: .word 1:20
	str4: .asciiz "\nmax is : "
	
.text

	li $v0, 4
	la $a0, str1
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	
	li $t0, 0
	la $t1, arr
	
	li $t2, 0 # max
	li $t3, 0 # maxind
  
	
	inp:
		beq $t0, $s0, next
		addi $t0, $t0, 1
		
		li $v0, 4
		la $a0, str2
		syscall
		
		li $v0, 5
		syscall
		
		sw $v0, 0($t1)
		move $v1, $v0
		
		ble $v1, $t2, cont
		
		move $t2, $v1
		move $t3, $t0
		#addi $t3, $t3, -1
			
		cont:
			addi $t1, $t1, 4
				
			j inp
		
	next:
		
		move $s1, $t2
					
		li $t0, 0
		la $t1, arr
		li $t4, 0 # smax
		li $t5, 0 # maxind	 
		
	smax:
	
		beq $t0, $s0, print
		addi $t0, $t0, 1
		
		lw $s3, 0($t1)
		
		ble $s3, $t4, scont
		beq $t0, $t3, scont
		
		move $t4, $s3
		move $t5, $t0
		
		scont:
			addi $t1, $t1, 4
				
			j smax
			
	print:
	
		li $v0, 4
		la $a0, ans
		syscall
		
		li $v0, 1
		move $a0, $t4
		syscall
		
		