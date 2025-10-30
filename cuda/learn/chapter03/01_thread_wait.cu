#include<cuda_runtime.h>
#include<cstdio>
#include<cstdlib>
#include<cmath>
#include<iostream>

using namespace std;

#define CHECK(func)\
{\
    cudaError_t error = func;\
    if(error!=cudaSuccess){\
        cout<<"file: "<<__FILE__<<"  line: "<<__LINE__<<" error\n";\
        cout<<"error id: "<<error<<"  reason: "<<cudaGetErrorString(error);\
        exit(0);\
    }\
}
template<typename T>
__global__ void thread_run(T* A, const int N,int num){
    int idx = blockIdx.x*blockDim.x + threadIdx.x;
    idx*=num;
    A+=idx; 
    // printf("thread idx: %d\n",idx/num);
    for(int i=0;i<num && idx+i<N;i++){
        if((idx/num)%2){
            A[i]*=2;

        }
        else{
            A[i]*=4;
        }
    }
}

template<typename T>
__global__ void wrap_run(T*A, const int N, int num){
    int idx = blockIdx.x*blockDim.x + threadIdx.x;
    idx*=num;
    A+=idx; 
    for(int i=0;i<num&&i+idx<N;i++){
        if(((idx/num)/ warpSize)%2==0){//常量
            A[i]*=2;
        }
        else{
            A[i]*=4;
        }
    }
}

template<typename T>
void run_time(void (*func)(T*, int, int), T*A, int N, int num, dim3 grid, dim3 block){
    cudaEvent_t start,end;
    cudaEventCreate(&start);
    cudaEventCreate(&end);

    cudaEventRecord(start);
    (*func)<<<grid, block>>>(A,N,num);
    CHECK(cudaGetLastError());  // 检查核函数启动错误
    cudaDeviceSynchronize();
    cudaEventRecord(end);
    cudaEventSynchronize(end);

    float second =0.0;
    cudaEventElapsedTime(&second, start, end);
    cout<<"func run time: "<<second<<" ms\n";
    CHECK(cudaEventDestroy(start));
    CHECK(cudaEventDestroy(end)); //释放时间
}

template<typename T>
void data_init(T*A, int N){
    for(int i=0;i<N;i++){
        A[i] = 1;
    }
}

template<typename T>
void print_A(T*A, int N, int num){
    for(int i=0;i<N/num;i++){
        cout<<"idx: "<<i<<"--->";
        for(int j=0;j<num;j++){
            cout<<A[i*num+j]<<" ";
        }
        cout<<"\n";
    }
}
int main(){
    int N = 64*32;
    int num = 32;
    dim3 block(32);
    dim3 grid(ceil(ceil(1.0*N/num)/block.x));

    cout<<"run start\n";

    int *A =new int [N];
    int *A_gpu = new int [N];

    data_init(A, N);

    data_init(A_gpu,N);

    int *d_A;
    int nbyte=N*sizeof(int);
    cudaMalloc((void**)&d_A, nbyte);


    cudaMemcpy(d_A, A, nbyte, cudaMemcpyHostToDevice);
    run_time<int>(wrap_run, d_A,N,num, grid, block);
    cudaMemcpy(A, d_A, nbyte, cudaMemcpyDeviceToHost);

    cudaMemcpy(d_A, A_gpu, nbyte, cudaMemcpyHostToDevice);
    run_time<int>(thread_run, d_A, N, num, grid, block); 
    cudaMemcpy(A_gpu, d_A, nbyte, cudaMemcpyDeviceToHost);

    cout<<"----------------------------------------------------\n";
    print_A<int>(A, N, num);
    cout<<"----------------------------------------------------\n";
    print_A<int>(A_gpu, N,num);


    delete[] A;
    delete[] A_gpu;
    cudaFree(d_A);
    return 0;
}