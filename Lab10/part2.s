SCAN_FLAG: .space 4


.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 8	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"
.ktext 0x80000180
interrupt_handler:
.set noat
	move	$k1, $at		# Save $at                               
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)		# Get some free registers                  
	sw	$a1, 4($k0)		# by storing them to a global variable  

	mfc0 $k0, $13		# Get Cause register                       
	srl	$a0, $k0, 2                
	and	$a0, $a0, 0xf		# ExcCode field                            
	bne	$a0, 0, non_intrpt     

interrupt_dispatch:
	mfc0	$k0, $13		# Get Cause register, again                 
	beq	$k0, 0, done		# handled all outstanding interrupts  
	and	$a0, $k0, 0x4000 #is there a starcoin interrupt?
	bne	$a0, 0, star_interrupt 

	# li	$v0, PRINT_STRING	# Unhandled interrupt types
	# la	$a0, unhandled_str
	# syscall 
	j	done

star_interrupt:
      sw $a1, 0xffff00e4($0)   # acknowledge interrupt

      li $a1, 233
      sw $a1, SCAN_FLAG
      #sw $0, 0xffff0010($0)

#       li      $a1, 10                  #  ??
#       lw      $a0, 0xffff001c($zero)   # what
#       and     $a0, $a0, 1              # does
#       bne     $a0, $zero, bonk_skip    # this 
#       li      $a1, -10                 # code
# bonk_skip:                             #  do 
#       sw      $a1, 0xffff0010($zero)   #  ??  


      j       interrupt_dispatch       # see if other interrupts are waiting

non_intrpt:				# was some non-interrupt
	# li	$v0, PRINT_STRING
	# la	$a0, non_intrpt_str
	# syscall				# print out an error message
	# fall through to done
done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)		# Restore saved registers
	lw	$a1, 4($k0)
.set noat
	move	$at, $k1		# Restore $at
.set at 
	eret



# syscall constants
PRINT_STRING	= 4
PRINT_CHAR	= 11
PRINT_INT	= 1

# memory-mapped I/O
VELOCITY	= 0xffff0010
ANGLE		= 0xffff0014
ANGLE_CONTROL	= 0xffff0018

BOT_X		= 0xffff0020
BOT_Y		= 0xffff0024

TIMER		= 0xffff001c

REQUEST_JETSTREAM	= 0xffff00dc
REQUEST_STARCOIN	= 0xffff00e0

PRINT_INT_ADDR		= 0xffff0080
PRINT_FLOAT_ADDR	= 0xffff0084
PRINT_HEX_ADDR		= 0xffff0088

# interrupt constants
BONK_MASK	= 0x1000
BONK_ACK	= 0xffff0060

TIMER_MASK	= 0x8000
TIMER_ACK	= 0xffff006c

REQUEST_STARCOIN_INT_MASK	= 0x4000
REQUEST_STARCOIN_ACK		= 0xffff00e4

.data
# put your data things here
three:	.float	3.0
five:	.float	5.0
PI:	.float	3.141592
F180:	.float  180.0

.align 2
event_horizon_data: .space 90000
star_data: .space 200
num_star: .space 4


.text
main:
	sub $sp, $sp, 24
	sw  $ra, 0($sp)
	sw  $s0, 4($sp)
	sw  $s1, 8($sp)
	sw  $s2, 12($sp)
	sw  $s3, 16($sp)
	sw  $s4, 20($sp)
	la  $t0, event_horizon_data
	sw  $t0, REQUEST_JETSTREAM
	# enable interrupts
	li	$t4, REQUEST_STARCOIN_INT_MASK		#  interrupt enable bit
	or	$t4, $t4, 1		# global interrupt enable
	mtc0	$t4, $12		# set interrupt mask (Status register)
	# request timer interrupt
#	lw	$t0, TIMER		# read current time
#	add	$t0, $t0, 50		# add 50 to current time
#	sw	$t0, TIMER		# request timer interrupt in 50 cycles
	
	
	
	
	
	li $t0, 150 
	lw $s1, BOT_X
	lw $s2, BOT_Y
	sub $s1, $t0, $s1
	sub $s2, $t0, $s2
	move $a0, $s1
	move $a1, $s2
	jal euclidean_dist
	move $s0, $v0    # v0 is RADIUS
	la  $t0, star_data
	sw  $t0, REQUEST_STARCOIN

	#jal move_to
	#j main

	# la  $t0, star_data
	# sw  $t0, REQUEST_STARCOIN
	lw $s5, BOT_X
	lw $s6, BOT_Y
	lw $s7, ANGLE
	and $s3, $s3, 0 #s3 = num stars
DOIT:


SCAN:
	la $t9, SCAN_FLAG
	lw $t9, 0($t9)
	bne $t9, 233, SCAN
		la $t0, star_data
		lw $t1, 0($t0)
		bge $s3, 24, NORMAL
		bne $t1, -1, EXIST

		lw $s5, BOT_X
		lw $s6, BOT_Y
		lw $s7, ANGLE

		la  $t0, star_data
		sw  $t0, REQUEST_STARCOIN

		la  $t0, star_data
		sw  $0, 0($t0)
		la $t0, SCAN_FLAG
		sw $0, 0($t0)
		j NORMAL
EXIST:  
		add $s3, $s3, 1
		srl $a0, $t1, 16
		and $a1, $t1, 0xffff

		jal move_to
		la  $t0, star_data
		sw  $t0, REQUEST_STARCOIN
		la  $t0, star_data
		sw  $0, 0($t0)
		la $t0, SCAN_FLAG
		sw $0, 0($t0)
		move $a0, $s5
		move $a1, $s6
		jal move_to
		sw $s7, ANGLE
	#	li $t0, 1
 	#	sw $t0, ANGLE_CONTROL
# BB:		j AA
# AA:
# 		j BB		
NORMAL:
	li $t0, 10
	sw $t0, VELOCITY # v = 10
	#get curr loc
	lw $s1, BOT_X
	lw $s2, BOT_Y
	#calc 
	li $t0, 150 
	sub $s1, $t0, $s1
	sub $s2, $t0, $s2
	move $a0, $s1
	move $a1, $s2
	jal sb_arctan
	li $t0, 90
	# t3 shi yao yun dong de jiao du
	sub $t3, $v0, $t0  # t3 is now arctan(y/x)-90 
 	# xian zai suan ban jing r
 	move $a0, $s1
 	move $a1, $s2
 	jal euclidean_dist
 	move $t4, $v0 # t4 is radius now 
 	# if radius now > R, JIA JIAO DU 
 	# [now - R] in [-10,10] 
 	sub $a0, $t4, $s0
 	bgt $a0, 5, JIAJIAODU
 	#bgt $t4, $s0, JIAJIAODU
 	bgt $a0, -5, ENDIF  	
 		add $t3, $t3, -5
 		j ENDIF
JIAJIAODU:	
 		add $t3, $t3, 13
ENDIF:	
 	sw $t3, ANGLE
 	li $t0, 1
 	sw $t0, ANGLE_CONTROL
 	j DOIT
 	
	
END:
	lw  $ra, 0($sp)
	lw  $s0, 4($sp)
	lw  $s1, 8($sp)
	lw  $s2, 12($sp)
	lw  $s3, 16($sp)
	lw  $s4, 20($sp)
	add $sp, $sp, 24
	jr  $ra	



# -----------------------------------------------------------------------
# sb_arctan - computes the arctangent of y / x
# $a0 - x
# $a1 - y
# returns the arctangent
# -----------------------------------------------------------------------

sb_arctan:
	li	$v0, 0		# angle = 0;

	abs	$t0, $a0	# get absolute values
	abs	$t1, $a1
	ble	$t1, $t0, no_TURN_90	  

	## if (abs(y) > abs(x)) { rotate 90 degrees }
	move	$t0, $a1	# int temp = y;
	neg	$a1, $a0	# y = -x;      
	move	$a0, $t0	# x = temp;    
	li	$v0, 90		# angle = 90;  

no_TURN_90:
	bgez	$a0, pos_x 	# skip if (x >= 0)

	## if (x < 0) 
	add	$v0, $v0, 180	# angle += 180;

pos_x:
	mtc1	$a0, $f0
	mtc1	$a1, $f1
	cvt.s.w $f0, $f0	# convert from ints to floats
	cvt.s.w $f1, $f1
	
	div.s	$f0, $f1, $f0	# float v = (float) y / (float) x;

	mul.s	$f1, $f0, $f0	# v^^2
	mul.s	$f2, $f1, $f0	# v^^3
	l.s	$f3, three	# load 3.0
	div.s 	$f3, $f2, $f3	# v^^3/3
	sub.s	$f6, $f0, $f3	# v - v^^3/3

	mul.s	$f4, $f1, $f2	# v^^5
	l.s	$f5, five	# load 5.0
	div.s 	$f5, $f4, $f5	# v^^5/5
	add.s	$f6, $f6, $f5	# value = v - v^^3/3 + v^^5/5

	l.s	$f8, PI		# load PI
	div.s	$f6, $f6, $f8	# value / PI
	l.s	$f7, F180	# load 180.0
	mul.s	$f6, $f6, $f7	# 180.0 * value / PI

	cvt.w.s $f6, $f6	# convert "delta" back to integer
	mfc1	$t0, $f6
	add	$v0, $v0, $t0	# angle += delta

	jr 	$ra
		
# -----------------------------------------------------------------------
# euclidean_dist - computes sqrt(x^2 + y^2)
# $a0 - x
# $a1 - y
# returns the distance
# -----------------------------------------------------------------------

euclidean_dist:
	mul	$a0, $a0, $a0	# x^2
	mul	$a1, $a1, $a1	# y^2
	add	$v0, $a0, $a1	# x^2 + y^2
	mtc1	$v0, $f0
	cvt.s.w	$f0, $f0	# float(x^2 + y^2)
	sqrt.s	$f0, $f0	# sqrt(x^2 + y^2)
	cvt.w.s	$f0, $f0	# int(sqrt(...))
	mfc1	$v0, $f0
	jr	$ra	

# a0 is x, a1 is y, s1 is botx, s2 is boty
move_to:	
	# li $a0, 150
	# li $a1, 70
	move $s1, $a0
	move $s2, $a1
	lw $t1, BOT_X
	lw $t2, BOT_Y
	#calc 
	#(t1, t2) -> (a0, a1)
	sub $a0, $s1, $t1 #dx
	sub $a1, $s2, $t2 #dy
	move $s4, $ra
	jal sb_arctan
	#add $v0, $v0, -90 #now absolute degree.
	#mul $v0, $v0, -1
	sw $v0, ANGLE
 	li $t0, 1
 	sw $t0, ANGLE_CONTROL 
	li $t0, 10
	sw $t0, VELOCITY 
	move $ra, $s4
STILL_MOVE:	
	lw $t1, BOT_X
	lw $t2, BOT_Y
	sub $t3, $s1, $t1
	sub $t4, $s2, $t2
	#t3 = dx
	#t4 = dy
	blt $t3, -2, STILL_MOVE
	bgt $t3, 2, STILL_MOVE
	blt $t4, -2, STILL_MOVE
	bgt $t4, 2, STILL_MOVE
	sw $0, VELOCITY
	jr  $ra
	
	
