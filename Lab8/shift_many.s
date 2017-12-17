## struct Shifter {
##     unsigned int value;
##     unsigned int *to_rotate[4];
## };
## 
## 
## void
## shift_many(Shifter *s, int offset) {
##     for (int i = 0; i < 4; i++) {
##         unsigned int *ptr = s->to_rotate[i];
## 
##         if (ptr == NULL) {
##             continue;
##         }
## 
##         unsigned char x = (i + offset) & 3;
##         *ptr = circular_shift(s->value, x);
##     }
## }

shift_many:
	sub	$sp, $sp, 40
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw  $s3, 12($sp)
	sw  $s4, 16($sp)
	sw  $s6, 20($sp)
	sw  $s6, 24($sp)
	sw  $s7, 28($sp)
	sw  $s8, 32($sp)
	sw	$ra, 36($sp)
	move $s0, $a0
	move $s1, $a1
BEGIN:
	move $s2, $0   # s2 = int i
	add  $s3, $0, 4  # s3 = const int 4
LOOPFOR:
	bge  $s2, $s3, END
		mul $t0, $s2, 4 # 4 * i
		add $t0, $t0, 4 # 4 + 4 * i
		add $t0, $t0, $s0  # s0 + 4 + 4 * i
		lw  $s6, 0($t0)
		
		beq $s6, $0, CONT  # s6 is ptr
		
		add $t0, $s2, $s1
		andi $t0, $t0, 3
		lw $a0, 0($s0)   # arg0 = s->value = *s
		move $a1, $t0    # arg1 = x
		jal circular_shift
		sw $v0, 0($s6)	
		
CONT:	add $s2, $s2, 1
	j LOOPFOR
END:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw  $s3, 12($sp)
	lw  $s4, 16($sp)
	lw  $s6, 20($sp)
	lw  $s6, 24($sp)
	lw	$s7, 28($sp)
	lw  $s8, 32($sp)
	lw	$ra, 36($sp)
	add	$sp, $sp, 40
	jr	$ra	
