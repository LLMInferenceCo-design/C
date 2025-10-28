#include<stdio.h>

__global__ void print(){
    printf("hello cuda\n");
}

int main(){
    printf("----------start------------\n");
    print<<<2,10>>>();
    printf("-----------end--------------\n");
    cudaDeviceReset();
    return 0;
}