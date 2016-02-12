.data

	str: .space 80
	temp: .space 80
	arr: .word 1:20
	fill1: .ascii "\nArray is : "
	space: .asciiz " "
	fin: .asciiz "inp.txt"
	fout: .asciiz "out.txt"
	new: .asciiz "\n"
	inpa: .asciiz "\nOriginal array is  :  "
	outa: .asciiz "\nReverse Sorted array is  :  "
	load: .asciiz "\nLoaded : "

.text

	# Open (for reading) a file that does not exist
	li   $v0, 13       # system call for open file
	la   $a0, fin    # inp file name
	li   $a1, 0        # Open for reading (flags are 0: read, 1: write)
	li   $a2, 0         # mode is ignored
	syscall            # open a file (file descriptor returned in $v0)
	move $s5, $v0      # save the file descriptor 

	# Open (for writing) a file that does not exist
	li   $v0, 13       # system call for open file
	la   $a0, fout     # output file name
 	li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
 	li   $a2, 0        # mode is ignored
  	syscall            # open a file (file descriptor returned in $v0)
	move $v1, $v0      # save the file descriptor 
	
	li $v0, 14
	move $a0, $s5
	la $a1, str
	li $a2, 80
	syscall
	

	li $v0, 4
	la $a0, inpa
	syscall
	
	la $a0, str
	syscall
  
	la $t0, str 
	li $t1, 0

	strlen:
		lb $t2, 0($t0)
		beqz $t2, ex
		addi $t1, $t1, 1
		addi $t0, $t0, 1	
		j strlen

	
	ex:

		move $s6, $t1

		la $t1, str
		la $t2, str
 
		move $t0, $s6
		addi $t0, $t0, -1
		add $t2, $t2, $t0
		addi $t0, $t0, 1
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
	  
		li $s7, 1
	 
		li $t1, 1 # powers of 10
		li $t2, 0 # loop variable
		move $t0, $s6 
		li $t4, 0 # sum
	
		la $s0, str
		la $s1, arr
	 
		loop:
			beq $t2, $t0, exit
			addi $t2, $t2, 1
		
			lb $t3, 1($s0)
			addi $s0, $s0, 1

			beq $t3, 32, sp
			bne $t3, 32, cont
		
			sp:
				addi $s7, $s7, 1
				sw $t4, 0($s1)
				addi $s1, $s1, 4				
				li $t1, 1
		
				li $t4, 0
			 
				j loop
		
			cont:
				andi $t3, $t3, 0x0F
							
				mul $t3, $t3, $t1
				add $t4, $t4, $t3
				mul $t1, $t1, 10
			
				j loop
			
		exit:

		sw $t4, 0($s1)
	
		li $t0, 0 # i
	
		for1:
			beq $t0, $s7, doneh
			addi $t0, $t0, 1
	
			li $t1, 1 # j
			la $s1, arr
		
			for2:
				beq $t1, $s7, for1
				addi $t1, $t1, 1
					
				lw $t5, 0($s1)
				lw $t6, 4($s1)
			
				bgt $t5, $t6, con
			
				sw $t6, 0($s1)
				sw $t5, 4($s1)
			
				con:
					addi $s1, $s1, 4
					j for2
			j for1	

		doneh:
	
			pr: 
				beq $t0, $t1, eexx
				addi $t1, $t1, 1
		
				lw $a0, 0($s0)
				li $v0, 1
				syscall
		
				li $v0, 4
				la $a0, space
				syscall
		
				addi $s0, $s0, 4
				j pr
	eexx:
			
		li $v0, 4
		la $a0, new
		syscall
		
		###################################  Converting int array into buffer  #########################
		
		la $t0, arr
		la $t1, str
		li $s0, 0
		 
		move $t2, $s7
		li $t3, 0 # loop variable
		
		convert:
			beq $t2, $t3, strev2
			addi $t3, $t3, 1
			lw $t4, 0($t0)
			lw $t8, 0($t0)
			 
			bnez $t8, divide
			 
			storezero:
			
				li $t5, 0 
				addi $t5, $t5, 0x30
				sb $t5, 0($t1)
				addi $s0, $s0, 1
				 
				addi $t1, $t1, 1
				
				j moov
				
				
			divide:
				beqz $t4, moov
				div $t5, $t4, 10
				mul $t6, $t5, 10
				sub $t7, $t4, $t6
				
				addi $s0, $s0, 1
				addi $t7, $t7, 0x30
			
			#	 addi $sp, $sp, -1
			#	 sb $t7, 0($sp)	 
			 	sb $t7, 0($t1)
			 	
				addi $t1, $t1, 1
				 
				div $t4, $t4, 10
				j divide
				
		 	moov:
				
				la $t7, space
				
				lb $t6, 0($t7)
				
				sb $t6, 0($t1)
				addi $t1, $t1, 1
				addi $s0, $s0, 1
				
				addi $t0, $t0, 4
				j convert
		
		strev2:
		
		li $v0, 4
		la $a0, new
		syscall
		
		li $t3, 0
		move $t0, $s0
		div $t0, $t0, 2 
		la $t1, str
		la $t2, str
		add $t2, $t2, $s0
		addi $t2, $t2, -1
		 
		strev:
			beq $t3, $t0, fwrite
			addi $t3, $t3, 1
	
			lb $t4, 0($t1)
			lb $t5, 0($t2)
	
			sb $t5, 0($t1)
			sb $t4, 0($t2)
  	
 			addi $t1, $t1, 1
			addi $t2, $t2, -1
	
			j strev


		fwrite:	
		
		li $v0, 4
		la $a0, str
		syscall
		
		
		#####################################  Writing into file  ########################################
		
		li   $v0, 15       # system call for write to file
		move $a0, $v1      # file descriptor 
		la   $a1, str      # address of buffer from which to write
		move $a2, $s0    # hardcoded buffer length
		syscall
		
		#####################################   Closing files ############################################
		
		li $v0, 16
		move $a0, $s5
		syscall
	
		li $v0, 16
		move $a0, $s6
		syscall
		
		li $v0, 10
		syscall
