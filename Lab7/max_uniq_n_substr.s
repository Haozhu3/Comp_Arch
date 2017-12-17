.text

## void
## max_unique_n_substr(char *in_str, char *out_str, int n) {
##     if (!in_str || !out_str || !n)
##         return;
## 
##     char *max_marker = in_str;
##     unsigned int len_max = 0;
##     unsigned int len_in_str = my_strlen(in_str);
##     for (unsigned int cur_pos = 0; cur_pos < len_in_str; cur_pos++) {
##         char *i = in_str + cur_pos;
##         int len_cur = n_uniq_char(i, n + 1);
##         if (len_cur > len_max) {
##             len_max = len_cur;
##             max_marker = i;
##         }
##     }
## 
##     my_strncpy(out_str, max_marker, len_max);
## }

.globl max_unique_n_substr
max_unique_n_substr:
	sub	$sp, $sp, 32
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw  $s3, 12($sp)
	sw  $s4, 16($sp)
	sw  $s5, 20($sp)
	sw  $s6, 24($sp)
	sw	$ra, 28($sp)
	move	$s0, $a0 	# s0 is in_str
	move	$s1, $a1	# s1 is out_str
	move	$s2, $a2	# s2 is int n
	
	beq $a0, $0, END
	beq $a1, $0, END
	beq $a2, $0, END
	
	move $s3, $s0 # s3 = max_marker = in_str = s0
	move $s4, $0  # s4 = len_max = 0
	jal my_strlen
	move $s5, $v0 # s5 = len_in_str = strlen(in_str)
	move $a0, $s3
	
	move $s6, $0 # s6 is cur_pos

FORLP:	
	bge $s6, $s5, ENDFOR
	add $t4, $a0, $s6  # char* i = in_str + cur_pos
		
	move $t5, $a0  #store in_str
	move $t6, $a1  #store out_str
	
	move $a0, $t4  #make args
	addi $a1, $s2, 1
	sub	$sp, $sp, 4
	sw  $t4, 0($sp)
	jal nth_uniq_char
	lw  $t4, 0($sp)
	add $sp, $sp, 4
	move $t7, $v0  # t7 = len_cur = nth_uniq_char(i, n + 1); 
	move $a0, $t5
	move $a1, $t6
	ble $t7, $s4, AFTERIF 	  
		move $s4, $t7
		move $s3, $t4 	
AFTERIF:
	addi $s6, $s6, 1
	j FORLP

ENDFOR:
	
	move $a0, $s1
	move $a1, $s3
	move $a2, $s4
	jal my_strncpy
	
END:	
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw  $s3, 12($sp)
	lw  $s4, 16($sp)
	lw  $s5, 20($sp)
	lw  $s6, 24($sp)
	lw	$ra, 28($sp)
	add	$sp, $sp, 32
	jr	$ra	
