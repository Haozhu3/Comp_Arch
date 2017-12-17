.data

.text

.globl max_depth
max_depth:
	sub	$sp, $sp, 40
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw  $s3, 12($sp)
	sw  $s4, 16($sp)
	sw  $s5, 20($sp)
	sw  $s6, 24($sp)
	sw  $s7, 28($sp)
	sw  $s8, 32($sp)
	sw	$ra, 36($sp)
	move $s0, $a0
BEGIN:
	beq $s0, $0, RET0
	
	move $s1, $0 # s1 = int cur_child = 0
	
	lw  $s2, 4($s0)  # s2 = current->children
	mul $t0, $s1, 4  # t0 = 4 * cur_child
	add $t0, $t0, $s2  # t0 =  current->children + 4 * cur_child
	lw  $s3, 0($t0)    # s3 = node* child =  *(current->children + 4 * cur_child)
	move $s4, $0       # s4 = int max = 0
	
LOOP:	beq $s3, $0, RETMAXP1
			move $s0, $s3
			jal max_depth
			ble $v0, $s4, ENDIF
				move $s4, $v0

ENDIF:		add $s1, $s1, 1
			mul $t0, $s1, 4  # t0 = 4 * cur_child		
			add $t0, $t0, $s2  # t0 =  current->children + 4 * cur_child
			lw  $s3, 0($t0)    # s3 = node* child =  *(current->children + 4 * cur_child)
		j LOOP
RETMAXP1:
	add $v0, $s4, 1
	j END
RET0:
	move $v0, $0
	j END
END:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw  $s3, 12($sp)
	lw  $s4, 16($sp)
	lw  $s5, 20($sp)
	lw  $s6, 24($sp)
	lw	$s7, 28($sp)
	lw  $s8, 32($sp)
	lw	$ra, 36($sp)
	add	$sp, $sp, 40
	jr	$ra	
