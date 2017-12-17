// a code generator for the ALU chain in the 32-bit ALU
// see example_generator.cpp for inspiration

// make generator
// ./generator

#include <cstdio>
using std::printf;

int main() {
	for (int i = 1; i <= 31; i++) {
		printf("alu1 a%d(out[%d],c[%d],A[%d],B[%d],c[%d],control);\n",i,i,i+1,i,i,i);
	}

	
	return 0;
	 
}
