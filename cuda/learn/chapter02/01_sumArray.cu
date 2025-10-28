#include<cstdio>
#include<time.h>
#include<iostream>
#include<cuda_runtime.h>
#include<chrono>
#include<cstdlib>


using namespace std;
#define CHECK(func) \
{ \
    const cudaError error = func; \
    if (error!= cudaSuccess){\
        printf("Error %s, %d\n", __FILE__, __LINE__);\
        printf("Error %d, reason %s\n", error, cudaGetErrorString(error));\
        exit(1);\
    }\
} \

template<typename T>
void sumOnHost(T *A, T *B, T* C, const int N){
    for(int i=0;i<N;i++){
        C[i] = A[i]+B[i];
    }
}

template<typename T>
__global__ void sumOnDevice(T* A, T*B, T* C, const int N){
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    if(idx<N){
        C[idx] = A[idx]+B[idx];
    }
}

template<typename T>
void funcexe_gpu(T* A, T* B, T* C, const int N, dim3 grid, dim3 block){
    cudaEvent_t start,end;
    cudaEventCreate(&start);
    cudaEventCreate(&end);
    cudaEventRecord(start);

    sumOnDevice<T><<<grid, block>>>(A,B,C,N);

    cudaDeviceSynchronize();
    cudaEventRecord(end);
    cudaEventSynchronize(end);

    float second=0;
    cudaEventElapsedTime(&second, start, end);
    cout<<"kernel exe time: "<<second*1000<<"us\n";
    cudaEventDestroy(start);
    cudaEventDestroy(end);
}

template<typename T>
void funcexe_cpu(T*A, T*B, T*C, const int N){
    auto start = chrono::high_resolution_clock::now();
    sumOnHost<T>(A,B,C,N);

    auto end = chrono::high_resolution_clock::now();
    auto during = chrono::duration_cast<chrono::microseconds>(end- start);

    cout<<"cpu exe time: "<<during.count()<<"\n";

}

template<typename T>
void init_data(T* ip , const int size){
    for(int i=0;i<size;i++){
        ip[i] = i;
    }
}

template<typename T>
void checkRes(T* A, T*B, const int N){
    double epsilon = 1.0e-8;
    for(int i=0;i<N;i++){
        if(abs(A[i]-B[i])>epsilon){
            cout<<"error gpu compute\n";
            return;
        }
    }
    cout<<"gpu perfeat\n";
    return;
}

int main(){
    const int N = 1024*1024*128;
    const int block_dim = 32;
    dim3 block(block_dim);
    dim3 grid((N+block.x-1)/block.x);
    cudaSetDevice(0);

    float *A_cpu = new float[N];
    float *B_cpu = new float[N];
    float *C_cpu = new float[N];
    float *C_gpu = new float[N];

    init_data(A_cpu, N);
    init_data(B_cpu,N);

    funcexe_cpu<float>(A_cpu,B_cpu,C_cpu,N);
    
    float *d_A, *d_B, *d_C;
    size_t nbyte = N* sizeof(float);
    CHECK(cudaMalloc((float**)&d_A, nbyte));
    CHECK(cudaMalloc((float**)&d_B, nbyte));
    CHECK(cudaMalloc((float**)&d_C, nbyte));

    CHECK(cudaMemcpy(d_A, A_cpu, nbyte, cudaMemcpyHostToDevice));
    CHECK(cudaMemcpy(d_B, B_cpu, nbyte, cudaMemcpyHostToDevice));

    funcexe_gpu(d_A,d_B,d_C,N,grid, block);
    // sumOnDevice<float><<<grid, block>>>(d_A, d_B, d_C, N);
    CHECK(cudaDeviceSynchronize());

    CHECK(cudaMemcpy(C_gpu, d_C, nbyte, cudaMemcpyDeviceToHost));
    checkRes(C_cpu,C_gpu,N);
    cudaDeviceReset();
    // for(int i=0;i<loop_1;i++){
    //     for(int j=0;j<loop_2;j++){
    //         cout<<C_cpu[i*loop_2+j]<<"  ";
    //     }
    //     cout<<"\n";
    // }
    return 0;

}