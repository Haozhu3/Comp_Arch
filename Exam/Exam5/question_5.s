# before running your code for the first time, run:
#     module load QtSpim
# run with:
#     QtSpim -file main.s question_5.s

# struct node_t {
#     node_t *children[4];
#     int data;
# };
# 
# int quad_leaf_average(node_t *root) {
#     if (root == NULL) {
#         return 0;
#     }
# 
#     if (root->children[0] != NULL) {
#         int total = 0;
#         for (int i = 0; i < 4; i++) {
#             total += quad_leaf_average(root->children[i]);
#         }
#         return total >> 2;
#     } else {
# 
#     	return root->data;
# 		}
#}
.globl quad_leaf_average
quad_leaf_average:
sub $sp, $sp, 32
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $ra, 28($sp)
move $s0, $a0
BEGIN:
	beq $s0, 0, RET0
	
	lw $t0, 0($s0) #t0 = child[0]
	beq $t0, 0, RET
		move $s1, $0 #s1 = 0 = int total
		move $s2, $0 #s2 = i = 0
LP:		bge $s2, 4, ENDFOR
			mul $t0, $s2, 4 # t0 = 4 * i
			add $t1, $t0, $s0	# t1 = 4 * i + root
			lw $t2, 0($t1) # t2 = root[4 * i]		
			move $a0, $t2
			jal quad_leaf_average
			add $s1, $s1, $v0
	
		add $s2, $s2, 1
		j LP
ENDFOR:		
		srl $v0, $s1, 2
		j END
RET:
	lw $t0, 16($s0)
	move $v0, $t0	
	j END
RET0:
	move $v0, $0 
	j END

END:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $ra, 28($sp)
add $sp, $sp, 32
jr $ra
