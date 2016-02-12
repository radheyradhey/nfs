.data

str1: .asciiz "Enter any fraction in binary ( -x.y if negative, x.y if positive ) - "
buffer1: .space 40
sign: .space 1
exp: .space 40
frac: .space 40
strsign: .asciiz "\nSign bit is - "
strexp: .asciiz "\nExponent bits are - "
strfrac: .asciiz "\nFraction bits are - " 
space: .asciiz " "
new: .asciiz "\n"


.text

main:
	li $t9, 0 # Stores index of .
	li $t8, 0 # Stores index of first 1
	
	li $v0, 4
	la $a0, str1
	syscall
	 
	li $v0, 8
	la $a0, buffer1
	li $a1, 10
	syscall 
	 
	la $t0, buffer1
	la $s1, sign
	lb $t1, 0($t0)
	
	beq $t1, 45, setminus
	li $t7, 0
	addi $t7, $t7, 0x30
	sb $t7, 0($s1)
	j FindDot
	
	setminus:
		li $t7, 1
		addi $t7, $t7, 0x30
		sb $t7, 0($s1)
 
	
	FindDot:
	
		lb $t2, 0($t0)
		beq $t2, 46, back
		
		addi $t0, $t0, 1
		addi $t9, $t9, 1
		j FindDot
			
	back:
		la $t0, buffer1
		
		find: 
			lb $t2, 0($t0)
			beq $t2, 49, next
			
			addi $t0, $t0, 1
			addi $t8, $t8, 1
			
			j find
	next:
	
 		sub $t7, $t9, $t8   ### $t7 has exponent
 		bgt $t9, $t8, yupp1
		addi $t7, $t7, 127
		j yupp
		
		yupp1:
			addi $t7, $t7, 126		
		j yupp
		
		yupp:
		
		la $t0, buffer1
		add $t0, $t0, $t8
		addi $t0, $t0, 1
		li $t5, 0
		la $t1, frac
		 
		loop:
			lb $t4, 0($t0)
			 
			beqz $t4, exit
			beq $t4, 10, exit
			
			beq $t4, 46, continue  
			bne $t4, 46, skip
			
			continue:
			
				addi $t0, $t0, 1
			
				j loop				
		
			skip:
				sb $t4, 0($t1)
				 
				addi $t5, $t5, 1
				addi $t0, $t0, 1
				addi $t1, $t1, 1
			
				j loop				
			
		exit:
			setzerofrac:
				
				bge $t5, 23, pr
				addi $t5, $t5, 1
				
				li $t6, 0
				addi $t6, $t6, 0x30
				
				sb $t6, 0($t1)
				addi $t1, $t1, 1
				
				j setzerofrac
				
	pr:	
		li $v0, 4
		la $a0, strsign
		syscall
		
		la $a0, sign
		syscall
		
		la $a0, new
		syscall
		
		la $a0, strfrac
		syscall
		
		la $a0, frac
		syscall
		
		la $a0, new
		syscall
		
		la $t0, exp
		li $a1, 0
	 
		binary:
			beqz $t7, setzero
			
			addi $a1, $a1, 1		
			
			div $t6, $t7, 2
			mul $t6, $t6, 2
		 	sub $t5, $t7, $t6
		 		
			addi $sp, $sp, -4
			
			sw $t5, 0($sp) 
			div $t7, $t7, 2
			
			j binary
				 

		setzero:
			
			move $t5, $a1
			
			for: 
				bge $t5, 8, rev
				addi $t5, $t5, 1
				
				li $t6, 0
				addi $t6, $t6, 0x30
				sb $t6, 0($t0)
				
				addi $t0, $t0, 1
				
				j for
		 
		
		rev:			
		
			beqz $a1, print
			addi $a1, $a1, -1
			
			lw $t5, 0($sp)
			 
			addi $t5, $t5, 0x30
			sb $t5, 0($t0)
			
			addi $t0, $t0, 1
			addi $sp, $sp, 4
			
			j rev
				
		print:		
			li $v0, 4		
			la $a0, strexp
			syscall
		
			la $a0, exp
			syscall
			
			la $a0, new
			syscall
		
			li $v0, 10
			syscall