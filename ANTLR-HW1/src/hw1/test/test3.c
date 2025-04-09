#include <stdio.h>

/*
    this is a recursive function to calculate the fibonacci of a number
    the fibonacci of a number is the sum of the two numbers before it
*/
int fib(int n) {
    if (n <= 1) {
        return n;
    }
    return fib(n - 1) + fib(n - 2);
}

int main() {
    int num1;
    printf("Enter number of fib: ");
    scanf("%d", num1);
    printf("Fibonacci of %d is %d\n", num1, fib(num1));
    return 0;
}
