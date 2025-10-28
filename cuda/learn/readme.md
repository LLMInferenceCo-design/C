# cuda c学习记录

## 函数api
### chapter1
**显式释放当前进程的所有资源**
```cpp
cudaDeviceReset();
```

### chapter2
**cudaError_t数据类型**
> cudaSuccess  
> cudaErrorMemoryAllocation


**检查error api**
```cpp
char* cudaGetErrorString(cudaError_t error);
```

**申请显存**
```cpp
cudaError_t cudaMalloc(void** devptr, size_t size)
```

**host与GPU通信**
```cpp
cudaError_t cudaMemcpy(void* dst, void*src, size_t count, cudaMemcpyKind kind)
```
> 这里面kind一共有4种类型
>> cudaMemcpyHostToDevice #cpu to GPU  
>> cudaMemcpyDeviceToHost  
>> cudaMemcpyDeviceToDevice  
>> cudaMemcpyHostToHost  

**Host和Device同步**
```cpp
cudaError_t cudaDevicesynchronize();
```

**设置在那一块GPU上运行**
```cpp
cudaError cudaSetDevice(int dev)
```

**查看timeline**
```cpp
nvprof ./exe
```


## chapter1 熟悉cuda


## chapter2 