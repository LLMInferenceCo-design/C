#include<cuda_runtime.h>
#include<cstdio>
#include<cstdlib>
#include<iostream>
#include<chrono>
#include<cmath>

using namespace std;

#define CHECK(func)\
{\
    cudaError_t error = func;\
    if(error!=cudaSuccess){\
        printf("file: %s, line %d error", __FILE__, __LINE__);\
        printf("error: %d, reason: %s", error, cudaGetErrorString(error));\
        exit(0);\
    }\
}

template<typename T>
void check_res(T *res1, T *res2, const int N){
    float eplos = 1.0e-8;
    for(int i=0;i<N;i++){
        if(abs(res1[i]-res2[i])>eplos){
            cout<<"gpu exe fail\n";
            exit(0);
        }
    }
    cout<<"gpu exe success\n";
}

template<typename T>
void sumOnHost(T* A, T*B, T*C, const int row, const int col){
    for(int i=0;i<row;i++){
        for(int j=0;j<col;j++){
            C[i*col+j] = A[i*col+j]+B[i*col+j];
        }
    }
}

template<typename T>
__global__ void sumOnDevice(T*A, T*B, T*C,const int nx, const int ny,const int num){
    int idx = blockIdx.y * gridDim.x * blockDim.x * blockDim.y + blockIdx.x * blockDim.x * blockDim.y + threadIdx.y * blockDim.x + threadIdx.x;
    idx *= num;

    if (idx < nx * ny) {
        C=C+idx;
        A=A+idx;
        B=B+idx;
        for (int i = 0; i < num && idx + i < nx * ny; i++) {
            C[i] = A[i] + B[i];
        }
    }
}

template<typename T>
void timeOnHost(T *A, T*B, T*C, const int nx, const int ny, const int num){
    auto start = chrono::high_resolution_clock::now();
    sumOnHost(A, B, C, nx, ny);
    auto end = chrono::high_resolution_clock::now();
    auto during = chrono::duration_cast<chrono::microseconds>(end-start);
    cout<<"cpu exe time: "<<during.count()/1000<<"ms\n";
}

template<typename T>
void timeOnDevice(T*A, T*B, T*C, const int nx, const int ny, const int num){
    dim3 block(32,32);
    dim3 grid(32);
    int thread_num = (nx*ny+num-1)/num;

    grid.y = ceil((thread_num*1.0)/(block.x*block.y+grid.x));

    cudaEvent_t start;
    cudaEvent_t end;
    cudaEventCreate(&start);
    cudaEventCreate(&end);
    cudaEventRecord(start);
    sumOnDevice<T><<<grid, block>>>(A,B,C,nx,ny,num);
    cudaDeviceSynchronize();
    cudaEventRecord(end);
    cudaEventSynchronize(end);

    float second = 0;
    cudaEventElapsedTime(&second, start, end);
    cout<<"GPU exe time :"<<second<<"ms\n";
}

template<typename T>
void init_data(T*A, const int N){
    for(int i=0;i<N;i++){
        A[i]=i;
    }
}

int main(){
    int nx=1024;
    int ny =1024;
    int num=32;
    int device = 0;
    CHECK(cudaSetDevice(device));

    float *A = new float[nx*ny];
    float *B = new float[nx*ny];
    float *C = new float[nx*ny];
    float *C_gpu = new float[nx*ny];

    init_data(A, nx*ny);
    init_data(B,nx*ny);

    int nbyte = nx*ny*sizeof(float);
    float *d_A,*d_B,*d_C;

    CHECK(cudaMalloc((float**)&d_A, nbyte));
    CHECK(cudaMalloc((float**)&d_B, nbyte));
    CHECK(cudaMalloc((void**)&d_C, nbyte));

    CHECK(cudaMemcpy(d_A, A, nbyte, cudaMemcpyHostToDevice));
    CHECK(cudaMemcpy(d_B,B,nbyte,cudaMemcpyHostToDevice));

    timeOnHost<float>(A,B,C,nx,ny,num);
    timeOnDevice<float>(d_A, d_B, d_C, nx, ny, num);
    CHECK(cudaMemcpy(C_gpu, d_C, nbyte, cudaMemcpyDeviceToHost));
    check_res(C_gpu, C, nx*ny);

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    cudaDeviceReset();

    delete[] A;
    delete[] B;
    delete[] C;
    delete[] C_gpu;
    return 0;

}