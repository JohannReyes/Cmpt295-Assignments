/*
 * Filename: main.c
 * Purpose: Assignment 6 Question 1
 * Name: Johann Reyes
 * Date: March 11, 2022
 * Student #: 301443359
*/

#include <stdlib.h>  // atoi()
#include <stdio.h>   // printf()

int isLessThan(int x, int y);  // changing name to: isLessThan
int plus(int x, int y);
int minus(int x, int y);
int mul(int x, int y);


int main(int argc, char *argv[]) {
	int x = 0;
  	int y = 0;
  	int result = 0;

	if (argc == 3) {
		x = atoi(argv[1]);
		y = atoi(argv[2]);

		result = isLessThan(x, y); // changing name to: isLessThan
  		printf("%d < %d -> %d\n", x, y, result); // using symbol: <

		result = plus(x, y);
  		printf("%d + %d = %d\n", x, y, result);

		result = minus(x, y);
  		printf("%d - %d = %d\n", x, y, result);

  		result = mul(x, y);
  		printf("%d * %d = %d\n", x, y, result);


	} else {
	  	printf("Must supply 2 integers arguments.\n");
	  	return 1;
	}

  return 0;
}
