.data

.text

## void
## decrypt(unsigned char *ciphertext, unsigned char *plaintext, unsigned char *key,
##         unsigned char rounds) {
##     unsigned char A[16], B[16], C[16], D[16];
##     key_addition(ciphertext, &key[16 * rounds], C);
##     inv_shift_rows(C, (unsigned int *) B);
##     inv_byte_substitution(B, A);
##     for (unsigned int k = rounds - 1; k > 0; k--) {
##         key_addition(A, &key[16 * k], D);
##         inv_mix_column(D, C);
##         inv_shift_rows(C, (unsigned int *) B);
##         inv_byte_substitution(B, A);
##     }
##     key_addition(A, key, plaintext);
##     return;
## }

.globl decrypt
decrypt:
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
	move $s2, $a2
	move $s3, $a3
# store args finish	
	sub	$sp, $sp, 16
	move $s4, $sp # S4 = A
	sub	$sp, $sp, 16	
	move $s5, $sp # S5 = B
	sub	$sp, $sp, 16	
	move $s6, $sp # S6 = C	 	
	sub	$sp, $sp, 16	
	move $s7, $sp # S7 = D
#   unsigned char A[16], B[16], C[16], D[16] finish

#   key_addition(ciphertext, &key[16 * rounds], C);
	
	mul $t0, $s3, 16 # 16 * rounds
	add $t0, $t0, $s2 # key + 16 * rounds
	# a0 not change
	move $a1, $t0
	move $a2, $s6
	jal key_addition
	
#   inv_shift_rows(C, (unsigned int *) B);	
	
	move $a0, $s6
	move $a1, $s5
	jal inv_shift_rows
	
#   inv_byte_substitution(B, A);	

	move $a0, $s5
	move $a1, $s4	
	jal inv_byte_substitution
	
	sub $s8, $s3, 1 # s8 = k = rounds - 1
LP:	ble $s8, $0, ENDLOOP
	
#   key_addition(A, &key[16 * k], D);
	
	move $a0, $s4
	mul $t0, $s8, 16
	add $t0, $t0, $s2
	move $a1, $t0
	move $a2, $s7
	jal key_addition

#   inv_mix_column(D, C);	
	
	move $a0, $s7
	move $a1, $s6
	jal inv_mix_column
	
#   inv_shift_rows(C, (unsigned int *) B);	
	
	move $a0, $s6
	move $a1, $s5
	jal inv_shift_rows

#   inv_byte_substitution(B, A);
	move $a0, $s5
	move $a1, $s4	
	jal inv_byte_substitution
	
	sub $s8, $s8, 1  # k--  
	j LP

ENDLOOP:	

#   key_addition(A, key, plaintext);

	move $a0, $s4
	move $a1, $s2
	move $a2, $s1
	jal key_addition
	

	
END:	
	add	$sp, $sp, 16
	add	$sp, $sp, 16
	add	$sp, $sp, 16
	add	$sp, $sp, 16
	
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
