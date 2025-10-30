#include<cuda_runtime.h>
#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<cmath>

using namespace std;

#define CHECK(func)\
{\
    cudaError_t error = func;\
    if(error!=cudaSuccess){\
        printf("file: %s, line: %d\n",__FILE__, __LINE__);\
        printf("id: %d, reason: %s\n",error, cudaGetErrorString(error));\
        exit(0);\
    }\
}\

int main(){
    int devicecount = 0;
    CHECK(cudaGetDeviceCount(&devicecount)); //获得有几块GPU
    if(devicecount==0){
        cout<<"This device is pure cpu\n";
    }
    else{
        printf("There are %d GPUs\n", devicecount);
    }
    for(int dev =0;dev<devicecount;dev++){
        int driverVersion, runtimeVersion;
        cudaSetDevice(dev);
        cudaDeviceProp prop;
        cudaGetDeviceProperties(&prop,dev);//获取GPU
        printf("-----------device %d is %s----------\n", dev,prop.name);
        cudaDriverGetVersion(&driverVersion);
        cudaRuntimeGetVersion(&runtimeVersion);

        printf("cuda driver version: %d.%d, runtime Version: %d.%d\n", \
            driverVersion/1000, (driverVersion%100)/10, runtimeVersion/1000, (runtimeVersion%100)/10);

        printf("Total amount of global memory: %.2f GBytes, (%llu bytes)\n",\
            (float)prop.totalGlobalMem/(pow(1024.0, 3)), (unsigned long long)prop.totalGlobalMem);
        
        printf("GPU Clock rate: %.0f MHZ (%0.2f GHZ)\n", prop.clockRate*1e-3f, prop.clockRate*1e-6f);

        printf("Memory Clock rate: %.0f Mhz\n", prop.memoryClockRate*1e-3f);

        printf("Memory Bus Width: %d-bit\n", prop.memoryBusWidth);

        if(prop.l2CacheSize){
            printf("L2 Cache Size: %d Kbytes (%d bytes)\n", prop.l2CacheSize/1024, prop.l2CacheSize);
        }

        printf("Max Texture Dimension Size (x, y, z): 1D = (%d) x %d, 2D = (%d, %d) x %d\n",\
        prop.maxTexture1DLayered[0], prop.maxTexture1DLayered[1],\
        prop.maxTexture2DLayered[0], prop.maxTexture2DLayered[1], prop.maxTexture2DLayered[2]);

        printf("Total amount of constant memory: %lu bytes\n", prop.totalConstMem);//只读，所有SM共享

        printf("Total amount of shared memory per block: %lu Kbytes\n", prop.sharedMemPerBlock/1024);

        printf("Wrap size: %d\n", prop.warpSize);//一个wrap同时最多启动多少个thread

        printf("Maximum number of threads per multiprocessor: %d\n", prop.maxThreadsPerMultiProcessor); //一个SM最多多少个thread

        printf("Maximum number of threads per block: %d\n", prop.maxThreadsPerBlock);//一个block最多多少个thread

        printf("Maximum sizes of each dimension of a block: %d x %d x %d\n", prop.maxThreadsDim[0], prop.maxThreadsDim[1], prop.maxThreadsDim[2]);

        printf("Maximum sizes of each dimension of a grid: %d x %d x %d\n",prop.maxGridSize[0],prop.maxGridSize[1], prop.maxGridSize[2]);
        
        printf("Maximum memory pitch: %lu bytes\n", prop.memPitch);//分配二位数组时，行宽度最大值

        printf("------------------end--------------------\n");
        // cout<<warpSize<<"\n";

        cudaDeviceReset();
    }
}