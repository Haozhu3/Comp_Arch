# before running your code for the first time, run:
#     module load QtSpim
# run with:
#     QtSpim -file main.s question_4.s

# int replace_matches_int(int *array, int length, int from, int to) {
#     int matches = 0;
#     for (int i = 0; i < length; i++) {
#         if (array[i] == from) {
#             array[i] = to;
#             matches++;
#         }
#     }
#     return matches;
# }
.globl replace_matches_int
replace_matches_int:
	add $t0, $0, 0 # t0 = 0 = matches
	add $t1, $0, 0 # t1 = 0 = i
LOOP:
	bge $t1, $a1, ENDLOOP		
		mul $t2, $t1, 4
		add $t2, $t2, $a0 # t2 = arr + 4i
		lw  $t3, 0($t2)
		bne $t3, $a2, NEE
			sw $a3, 0($t2)
			add $t0, $t0, 1 	
	NEE:
	add $t1, $t1, 1
	j LOOP
ENDLOOP:
	move $v0, $t0
	jr $ra
