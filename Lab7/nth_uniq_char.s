.data
uniq_chars: .space 256

.text

## 
## int nth_uniq_char(char *in_str, int n) {
##     if (!in_str || !n)
##         return -1;
## 
##     uniq_chars[0] = *in_str;
##     int uniq_so_far = 1;
##     int position = 0;
##     in_str++;
##     while (uniq_so_far < n && *in_str) {
##         char is_uniq = 1;
##         for (int j = 0; j < uniq_so_far; j++) {
##             if (uniq_chars[j] == *in_str) {
##                 is_uniq = 0;
##                 break;
##             }
##         }
##         if (is_uniq) {
##             uniq_chars[uniq_so_far] = *in_str;
##             uniq_so_far++;
##         }
##         position++;
##         in_str++;
##     }
## 
##     if (uniq_so_far < n) {
##         position++;
##     }
##     return position;
## }

.globl nth_uniq_char
nth_uniq_char:
	# Your code goes here :)
	beq $a1, $0, ERREND
	beq $a2, $0, ERREND
	
	la $t1, uniq_chars # t1 = uniq_chars
	lb $t2, 0($a0) # t2 = *in_str
	sb $t2, 0($t1) # uniq_chars[0] = *in_str
	move $t8, $0   # t8 is position
	addi $t9, $0, 1 # t9 is uniq_so_far, = 1 
	addi $a0, $a0, 1 # instr++
	
LPWHILE: 
	slt $t3, $t9, $a1 #t3 = uniq_so_far < n
	lb $t2, 0($a0)
	mul $t3, $t3, $t2
	beq $t3, $0, ENDWHILE #t3 reused
	addi $t7, $0, 1 # t7 = is_uniq = 1
	 	
	 # for loop
	move $t6, $t9 # t6 = uniq_so_far 
	move $t7, $t1 # t1 = uniq_chars
	LPFOR:	
		sub $t6, $t6, 1
		lb  $t3, 0($t7)
		lb 	$t4, 0($a0)
		beq $t3, $t4, AFTERIF
		
		addi $t7, $t7, 1 #ptr++ 
	 	bgt $t6, $0, LPFOR 
	 	
	 	add $t3, $t9, $t1 # uniq_chars + uniq_so_far
	 	lb  $t4, 0($a0)  # t4 = *in_str
	 	sb  $t4, 0($t3)  # *(uniq_chars + uniq_so_far) = *in_str
	 	addi $t9, $t9, 1
	 	
	AFTERIF:
		addi $t8, $t8, 1
		addi $a0, $a0, 1
		
	j LPWHILE
	
ENDWHILE: #t3, t4, reuse
	bge $t9, $a1, END
	addi $t8, $t8, 1
END:
	move $v0, $t8	
	jr	$ra
	
ERREND:
	sub $v0, $0, 1
	jr $ra	
