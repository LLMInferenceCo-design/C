#include<bits/stdc++.h>
using namespace std;

#define N 1000
#define M 100

// 生成next数组（动态分配内存）
int *getNext(char* s1, int len) { //模式串
    int *next = new int[len];  // 动态分配，避免局部变量问题
    next[0] = -1;
    int j = 0, k = -1;
    while (j < len - 1) {
        if (k == -1 || s1[j] == s1[k]) {
            j++;
            k++;
            next[j] = k;
        } 
        else {
            k = next[k];
        }
    }
    return next;
}

// KMP匹配算法
int KMP(char* s1, char* s2) {
    int len1 = strlen(s1);
    int len2 = strlen(s2);
    if (len2 == 0) return 0;  // 处理空串情况
    int *next = getNext(s2, len2);  // 注意：next数组应基于模式串s2生成（原代码此处有误）
    
    int i = 0, j = 0;
    while (i < len1 && j < len2) {
        if (j == -1 || s1[i] == s2[j]) {
            i++;
            j++;
        } else {
            j = next[j];
        }
    }
    delete[] next;  // 释放动态分配的内存，避免泄漏
    if (j == len2) {
        return i - j;  // 匹配成功，返回起始位置
    }
    return -1;  // 匹配失败
}

int main() {
    char s1[N], s2[M];
    cin >> s1;  // 主串，如"helloworld"
    cin >> s2;  // 模式串，如"wo"
    
    cout << KMP(s1, s2) << endl;  // 输出匹配位置，示例中应为5
    
    return 0;
}