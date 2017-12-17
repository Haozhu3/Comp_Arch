.text

## unsigned int
## my_strlen(char *in) {
##     if (!in)
##         return 0;
## 
##     unsigned int count = 0;
##     while (*in) {
##         count++;
##         in++;
##     }
## 
##     return count;
## }

.globl my_strlen
my_strlen:
	# Your code goes here :)
	# $a1 = char* in
	add $v0, $0, $0   # v0 = count
	beq $a0, $0, ENDCOUNT
LP:	lb  $t2, 0($a0) 
	beq $t2, $0, ENDCOUNT
	addi $v0, $v0, 1
	addi $a0, $a0, 1
	j LP 
		
	

ENDCOUNT:
	jr	$ra
	
