.data
s1: .asciiz "Enter any number : "
s5: .asciiz "\nFactorial of your number  is : "

main:
.text

la $a0, s1
li $v0, 4
syscall

li $v0, 5
syscall
move $t0, $v0

move $t1, $t0
move $t2, $t0
addi $t2, $t2, -1

move $s0, $t0   # ans
  
fact: 
	beqz $t2, exit
	move $t3, $t2
	move $t4, $t2
	li $t5, 0
	
	fn:
		beqz $t3, AddStack
		addi $t3, $t3, -1
		
		addi $sp, $sp, -4
		sw $s0, 0($sp)
		
		j fn
	
	AddStack:
	
		beqz $t4, done
		addi $t4, $t4, -1
				
		lw $t0, 0($sp)
		addi $sp, $sp, 4
		
		add $t5, $t5, $t0
		
		j AddStack 
		
	done:
		addi $t2, $t2, -1
		move $s0, $t5
		j fact
 

exit:	
	la $a0, s5
	li $v0, 4
	syscall
	 
	move $a0, $s0
	li $v0, 1
	syscall

li $v0, 10
syscall
