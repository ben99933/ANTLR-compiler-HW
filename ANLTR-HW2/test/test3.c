#include<stdio.h>

int main() {
    int i = 1;
    // count from 1 to 10
    while (i <= 10) {
        printf("%d 's square is %d\n", i, i * i);
        i = i+1;
    }
    return 0;
}
