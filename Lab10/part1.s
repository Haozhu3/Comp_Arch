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

.text
main:
	sub $sp, $sp, 24
	sw  $ra, 0($sp)
	sw  $s0, 4($sp)
	sw  $s1, 8($sp)
	sw  $s2, 12($sp)
	sw  $s3, 16($sp)
	sw  $s3, 20($sp)
	la  $t0, event_horizon_data
	sw  $t0, REQUEST_JETSTREAM
	
	li $t0, 150 
	lw $s1, BOT_X
	lw $s2, BOT_Y
	sub $s1, $t0, $s1
	sub $s2, $t0, $s2
	move $a0, $s1
	move $a1, $s2
	jal euclidean_dist
	move $s0, $v0    # v0 is RADIUS
	


DOIT:
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
	# s3 shi yao yun dong de jiao du
	sub $s3, $v0, $t0  # s3 is now 90 - arctan(y/x) 
 	# xian zai suan ban jing r
 	move $a0, $s1
 	move $a1, $s2
 	jal euclidean_dist
 	move $s4, $v0 # s4 is radius now 
 	# if radius now > R, jiang di jiao du
 	bgt $s4, $s0, JIANDIAODU
 		add $s3, $s3, -1
 		j ENDIF
JIANDIAODU:	
 		add $s3, $s3, 1
ENDIF:	
 	sw $s3, ANGLE
 	li $t0, 1
 	sw $t0, ANGLE_CONTROL
 	j DOIT
 	
 	
 		
	# enable interrupts
#	li	$t4, TIMER_MASK		# timer interrupt enable bit
#	or	$t4, $t4, BONK_MASK	# bonk interrupt bit
#	or	$t4, $t4, 1		# global interrupt enable
#	mtc0	$t4, $12		# set interrupt mask (Status register)

	# request timer interrupt
#	lw	$t0, TIMER		# read current time
#	add	$t0, $t0, 50		# add 50 to current time
#	sw	$t0, TIMER		# request timer interrupt in 50 cycles





	
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
