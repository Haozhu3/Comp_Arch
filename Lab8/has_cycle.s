.data

.text
## struct Node {
##     int node_id;            // Unique node ID
##     struct Node **children; // pointer to null terminated array of children node pointers
## };
##
## int
## has_cycle(Node *root, int num_nodes) {
##     if (!root)
##         return 0;
## 
##     Node *stack[num_nodes];
##     stack[0] = root;
##     int stack_size = 1;
## 
##     int discovered[num_nodes];
##     for (int i = 0; i < num_nodes; i++) {
##         discovered[i] = 0;
##     }
## 
##     while (stack_size > 0) {
##         Node *node_ptr = stack[--stack_size];
## 
##         if (discovered[node_ptr->node_id]) {
##             return 1;
##         }
##         discovered[node_ptr->node_id] = 1;
## 
##         for (Node **edge_ptr = node_ptr->children; *edge_ptr; edge_ptr++) {
##             stack[stack_size++] = *edge_ptr;
##         }
##     }
## 
##     return 0;
## }

.globl has_cycle
has_cycle:
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
BEGIN:
	move $s0, $a0
	move $s1, $a1
	beq $a0, $0, ZEROEND
	
	mul $s2, $a1, 4 # s2 = 4 * num_nodes == bytes of stack
	sub $sp, $sp, $s2
	move $s3, $sp   # s3 = stack
	sw  $a0, 0($s3) #stack[0] = root 
	
	add $s4, $0, 1  # s4 = stack_size = 1
	sub $sp, $sp, $s2
	move $s5, $sp   # s5 = discovered array
	
	move $t0, $0  # t0 = i = 0
LOOPCLEAR:
	bge $t0, $a1, ENDCLEAR
		mul $t1, $t0, 4
		add $t1, $t1, $s5
		sw  $0, 0($t1)
		add $t0, $t0, 1
		j LOOPCLEAR
ENDCLEAR:	 
	ble $s4, $0, ZEROEND
		sub $s4, $s4, 1 # --stack_size
		mul $t0, $s4, 4
		add $t0, $t0, $s3 # t0 = stack_size * 4 + stack 		
		lw  $t0, 0($t0)   # t0 = *(stack + stack_size * 4)  == node_ptr
		
		# t1 = node_ptr->node_id
		lw  $t1, 0($t0) 
		mul $t2, $t1, 4 
		add $t2, $t2, $s5 # t2 = discovered + (node_ptr->node_id)*4
		lw  $t3, 0($t2)  # t3 = discovered[node_ptr->node_id];
		bne $t3, $0, ONEEND
		add $t4, $0, 1
		sw  $t4, 0($t2)
		
		lw  $t4, 4($t0)  #t4 = edge_ptr = node_ptr->children
LOOPFOR:			
		lw $t5, 0($t4)   # t5 = *edge_ptr
		beq $t5, $0, ENDFOR
		mul $t6, $s4, 4
		add $t6, $t6, $s3 
		sw  $t5, 0($t6)
		
		add $s4, $s4, 1
		add $t4, $t4, 4
		j LOOPFOR
ENDFOR:			
		j ENDCLEAR	
ZEROEND:
	move $v0, $0
	j END
ONEEND:
	addi $v0, $0, 1
	j END		
		
END:
	add $sp, $sp, $s2   #pop discovered
	add $sp, $sp, $s2	#pop stack
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
