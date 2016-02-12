.data
 str: .asciiz "Enter a string: "
 new: .asciiz "\n"
 ans: .asciiz"\nString after Capitalisation  -  "
 buffer: .space 30
 
main:
.text
	
	li $t9, 5
	li $t8, 0
	
	la $a0, str
	li $v0, 4
	syscall
	
	li $a1, 30
	la $a0, buffer
	li $v0, 8
	syscall
	
	la $t0, buffer
	
	loop1: 
		lb $t1, 0($t0)
		beqz $t1, done ## if $t1=0, exit
		blt $t1, 'a', no_change ## $t1 < a,next
		bgt $t1, 'z', no_change ## $t1 > z,next
		addiu $t1, $t1, -32 ## convert to uppercase: 'A'-'a'=-32
		sb $t1, 0($t0)	
	no_change:
		addiu $t0,$t0,1 ## increment pointer, i++
		j loop1

	
	done:
		li $v0, 4
	
		la $a0, ans
		syscall
			
		la $a0, buffer
		syscall
		
		la $a0, new
		syscall
		
		li $v0, 10
		syscall
