/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // length must be a multiple of 8
	assert((length % 8) == 0);
	
	
   // allocate an array for the output
	char *message_out = new char[length];
	unsigned char mask = 0x01;
	
	for (int i = 0; i < length; i++) {
		if (i % 8 == 0) mask = 0x01;
		unsigned char now = 0x00;
		for (int j = 0; j < 8; j++) {
			now = now + (((mask & message_in[(i/8)*8 + j]) >> (i % 8)) << j);
		}
		
		mask = mask << 1;
		//cout << "now char is " << (int)now << endl;
		message_out[i] = now;
		now = 0x00;
		
	}
	// TODO: write your code here
	
	return message_out;
}
