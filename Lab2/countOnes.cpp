/**
 * @file
 * Contains the implementation of the countOnes function.
 */
unsigned countOnes(unsigned input) {
	// TODO: write your code here
	unsigned lm = 0xAAAAAAAA;
	unsigned rm = 0x55555555;
	unsigned a = input & lm;
	unsigned b = input & rm;
	input = (a >> 1) + b;
	
	lm = 0xCCCCCCCC;
	rm = 0x33333333;
	a = input & lm;
	b = input & rm;
	input = (a >> 2) + b;
	
	lm = 0xF0F0F0F0;
	rm = 0x0F0F0F0F;
	a = input & lm;
	b = input & rm;
	input = (a >> 4) + b;
	
	lm = 0xFF00FF00;
	rm = 0x00FF00FF;
	a = input & lm;
	b = input & rm;
	input = (a >> 8) + b;
	
	lm = 0xFFFF0000;
	rm = 0x0000FFFF;
	a = input & lm;
	b = input & rm;
	return 	input = (a >> 16) + b;
}




