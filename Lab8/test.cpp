#include <iostream>
#include <cstdio>
using namespace std;



typedef struct _shifter {
	unsigned long value;
	unsigned int* arr[4];
} shifter;


int main() {
	unsigned int a[4] = {1 ,2 ,3, 4};
	shifter ss;
	ss.arr[0] = a;
	ss.arr[1] = a+1;
	ss.arr[2] = a+2;
	ss.arr[3] = a+3;

	shifter* addr = &ss;
	cout <<"shifter* = " <<addr << endl;
	cout << sizeof(shifter) << endl;
	printf("%p\n",(char*)addr + sizeof(unsigned long));
	cout << &(addr->arr) << endl;
	printf("%p\n",addr->arr[0]);
	printf("%p\n",&(addr->arr[0]));
}
