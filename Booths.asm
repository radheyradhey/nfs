#########################################    MIPS program to multiply two binary numbers... ######################################

.data
	msg1: .asciiz "Enter number of bits of input : "
	msg2: .asciiz "\nEnter first number : "
	msg3: .asciiz "\nEnter second number : "
	buffer1: .space 20
	buffer2: .space 20
	buffer3: .space 20
	buffer4: .space 20
	zer: .asciiz "0"
	new: .asciiz "\n"
	ans: .asciiz "\nProduct of two numbers  -  "
	
	
.text

li $v0, 4
la $a0, msg1
syscall

li $v0, 5
syscall

move $s0, $v0 # s0 -> number of bits of bits ################

#################### Printing n
li $v0, 4
la $a0, msg2
syscall
  
li $v0, 8
la $a0, buffer1
li $a1, 10
syscall

li $v0, 4
la $a0, msg3
syscall
   
li $v0, 8
la $a0, buffer2
li $a1, 10
syscall


move $t0, $s0
mul $t0, $t0, 2
li $t1, 0
la $t2, buffer3

la $t4, zer
lb $t5, 0($t4)

li $s1, 0 # number of times shifted right

init: 
	beq $t0, $t1, doneinit
	addi $t1, $t1, 1
	
	sb $t5, 0($t2)
	lb $a0, 0($t2)
	
	addi $t2, $t2, 1
		
	j init

sr:  

	la $s5, buffer3
	add $s5, $s5, $s0
	add $s5, $s5, $s0
	addi $s5, $s5, -1
	
	lb $s6, ($s5)
	
	addi $s5, $s5, -1
	
	add $a2, $s0, $s0
	addi $a2, $a2, -1
	li $a3, 0
	
	shiftr: 
		beq $a2, $a3, return
		addi $a3, $a3, 1
		
 		lb $t9, ($s5)
 		sb $t9, 1($s5)
 		
		addi $s5, $s5, -1		
 		j shiftr		
			
	return: 
		la $s5, buffer3
		sb $s6, 0($s5)
					
		j shifted


doneinit:	
	
	la $t0, buffer2
	add $t0, $t0, $s0
	addi $t0, $t0, -1
	li $s2, 0 # sum
	li $s3, 0 # carry
	li $t7, 0
		
	multnum:
	
		beq $t7, 0, proceed		 	
				
		move $t9, $s7			
		li $s6, 1
		addi $s6, $s6, 0x30

		
		carry:
		 	
			beqz $s3, proceed
			lb $t8, ($t9)
							
			andi $t8, $t8, 0x0F
			
			beqz $t8, sz
			addi $t9, $t9, 1
						
			j carry
						
			sz:
				li $s3, 0
				sb $s6, ($t9) 
				addi $t9, $t9, 1
							
				j proceed
						
 		proceed:
 		
		beq $t7, $s0, done
		addi $t7, $t7, 1
		  
		la $t1, buffer1 
		add $t1, $t1, $s0
		addi $t1, $t1, -1
	
		la $s7, buffer3 # out buff
		add $s7, $s7, $s0
		add $s7, $s7, $s0
		addi $s7, $s7, -1
		 			 
		lb $t2, 0($t0)
		
		addi $t0, $t0, -1

		j sr
		
		shifted:	
			addi $s1, $s1, 1
			andi $t2, $t2, 0x0F
				 
			beqz $t2, multnum 
			
			li $t3, 0
		  
			addnum:
				beq $t3, $s0, multnum
				addi $t3, $t3, 1
			
				lb $t4, ($t1)
				lb $t5, ($s7)
				
				andi $t4, $t4, 0x0F
				andi $t5, $t5, 0x0F
			
				add $t6, $t4, $t5
				add $t6, $t6, $s3
			
				beq $t6, 0, setzero
				beq $t6, 1, setone
				beq $t6, 2, setsum
				beq $t6, 3, setboth
					 
				setzero:
					li $s2, 0
					li $s3, 0
					j doneset
				setone:
					li $s2, 1
					li $s3, 0
					j doneset
				setsum:
					li $s2, 0
					li $s3, 1
					j doneset
				setboth:
					li $s2, 1
					li $s3, 1
					j doneset
				
				doneset:
			 			
					addi $s2, $s2, 0x30
					sb $s2, 0($s7)
			 
					addi $t1, $t1, -1
					addi $s7, $s7, -1
				
				j addnum
		
	done:
	
	
		li $t3, 0
		    
		move $t0, $s0
		addi $t0, $t0, -1
	 
		la $s7, buffer3
		la $s6, buffer4
		la $s5, buffer3
		
		add $s7, $s7, $t0
		
		li $t1, 0
		
		shift:
					
			lb $t2, ($s7)
			
			beqz $t2, remaining
			
			sb $t2, ($s6)	
			
			addi $s6, $s6, 1
			addi $s7, $s7, 1		
			
			j shift
		
		remaining:
			
			beq $t0, $t1, exit
			addi $t1, $t1, 1
			
			lb $t2, ($s5)
			sb $t2, ($s6)
					
			addi $s5, $s5, 1
			addi $s6, $s6, 1
			
			j remaining
			
		exit:			
			li $v0, 4
			la $a0, ans
			syscall
			
			li $v0, 4
			la $a0, buffer4
			syscall
			
			li $v0, 4
			la $a0, new
			syscall
			
			li $v0, 10
			syscall
