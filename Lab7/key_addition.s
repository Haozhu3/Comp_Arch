.text

## void
## key_addition(unsigned char *in_one, unsigned char *in_two, unsigned char *out) {
##     for (unsigned int i = 0; i < 16; i++) {
##         out[i] = in_one[i] ^ in_two[i];
##     }
## }

.globl key_addition
key_addition:
	# Your code goes here :)
	addi $t9, $0, 16
	
LP:		
	sub $t9, $t9, 1
	lb  $t2, 0($a0)	#t2 = *arr1
	lb  $t3, 0($a1) #t3 = *arr2
	xor $t2, $t2, $t3 #t2 = in_one[0] ^ in_two[0]
	sb  $t2, 0($a2)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	addi $a2, $a2, 1
	bgt $t9, $0, LP
	
	
END:	
	jr	$ra
