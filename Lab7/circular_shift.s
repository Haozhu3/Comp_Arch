.text

## unsigned int
## circular_shift(unsigned int in, unsigned char s) {
##     return (in >> 8 * s) | (in << (32 - 8 * s));
## }

.globl circular_shift
circular_shift:
	addi $t1, $0, 8 # t1 = 8 
	mul $t1, $t1, $a1  # t1 = 8 * s
	
	addi $t2, $0, 32
	sub $t2, $t2, $t1  # t2 = 32 - 8 * s
	
	move $t3, $a0
	move $t4, $a0
	
#LPLEFT: 
#	srl $t3, $t3, 8 
#	sub $t1, $t1, 8
#	bgt $t1, $0, LPLEFT
	srl $t3, $t3, $t1

#LPRIGNT:
#	sll $t4, $t4, 1
#	sub $t2, $t2, 1
#	bgt $t2, $0, LPRIGNT 

	sll $t4, $t4, $t2
END:
	or  $v0, $t3, $t4	
	jr	$ra
