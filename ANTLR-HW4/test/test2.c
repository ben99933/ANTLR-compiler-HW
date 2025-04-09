#include<stdio.h>

int main() {
    int a = 10;
    int b = 12;

    if(a!=b){
        printf("a!=b\n");
        if(a<b){
            printf("a=%d < b=%d\n", a, b);
        }else{
            printf("a=%d > b=%d\n", a, b);
        }
    }

    return 0;
}
