# cpp 模板

## Stl 模版

### vector

```cpp
#include <vector>
vector<int> v(n); // 定义一个长度为n的数组，初始值默认为0，下标范围[0, n - 1]
vector<int> v(n, 1); // v[0] 到 v[n - 1]所有的元素初始值均为1
vector<int> a{1, 2, 3, 4, 5};//数组a中有五个元素，数组长度就为5

```

### queue stack

```cpp
#include <queue>
#include <stack>

// 队列
queue<int> q;
q.push(num);
q.pop();
int n=q.size();
bool isEmpty=q.empty();
int first=q.front(); // 队头
int last=q.back();   // 队尾：最后一个push进去的元素是队尾！

// 栈
stack<int>st;
st.push(num);
st.pop();
int top=q.top(); //栈顶元素
int n=st.size();
bool isEmpty=st.empty();
```

### Set,Map

```cpp
// 集合
set<int> s;

// 常用函数
int n=s.size();
s.insert(num);
s.erase(num);
s.count(num); // 常用来判断有无这一元素

// 遍历元素
set<int>::iterator it;
for(it = s1.begin(); it!=s1.end(); it++){ //自动排序元素
    cout<<*it<<endl;  // 这里的it是个指向数据的指针
}
//c++ 11
for(auto it : s){
    cout<<it<<endl;   // 这里的it就是数据本身
}
 
// map
map<string, int> m;

// 常用函数
int n=m.size();
m[key]=value; // 最简单的插入方法（个人认为）
m.erase(key);
s.count(key); // 常用来判断有无这一元素

// 遍历元素
map<string, int>::iterator it;
for (it = m.begin(); it != m.end(); it++) {
    cout<<it->first<<" "<<it->second<<endl;
}
// c++ 11
for(auto it : m){
    cout<<it.first<<" "<<it.second<<endl;
}
```

### priority_queue

```cpp
#include <queue>

priority_queue<int> q; //等同于 priority_queue<int, vector<int>, less<int>> a;


priority_queue<int, vector<int>, greater<int>> q;\\小根堆, 吐小的
priority_queue<int, vector<int>, less<int>>q;// 大根堆

struct cmp{\\小根堆升序，吐小的
    bool operator()(int a,int b){
        return a>b;
    }
};


// 常用函数
q.push(num);
int top=q.top();
q.pop();
```


### sort

```cpp
sort(a, a+5,greater<int>()); \\降序
sort(a, a+5,less<int>());
```





## data_struct

### 链表

```cpp
#include<bits/stdc++.h>
using namespace std;

template<typename T>
struct List{
    T val;
    List *next;
    List(T val) : val(val), next(nullptr) {}
    void insert(T v){
        List* tmp = next; 
        next = new List(v);
        next->next = tmp;
    }

    // 反转链表（不包括当前节点，只反转 next 之后的部分）
    void reverse() {
        List* prev = nullptr;
        List* curr = next;
        while (curr) {
            List* nxt = curr->next;
            curr->next = prev;
            prev = curr;
            curr = nxt;
        }
        next = prev;
    }

    bool dele(){
        if(next==nullptr){
            return false;
        }
        List* tmp = next;
        next = next->next;
        delete tmp;
    }
    void init(T* l, int len){
        List * head=this;
        for(int i=0;i<len;i++){
            head->next = new List(l[i]);
            head=head->next;
        }
    }
    List find(int v){
        List *tmp = this;
        while(tmp->next){
            if(tmp->next->val == v)break;
        }
        return tmp->next;
    }
    void print(){
        List* tmp = next;
        while(tmp){
            cout<<tmp->val<<" ";
            tmp = tmp->next;
        }
        cout<<"\n";
    }
};

int main(){
    map<int, List<int>*>mp;
    int a[5] = {1,2,3,4,5};
    List<int>* head = new List<int>(-1);
    head->init(a,5);
    head->print();
    head->dele();
    head->print();
    head->insert(6);
    head->print();
    head->reverse();
    head->print();
    mp[5] = head->next;
    cout<<mp[5]->val;
}
```

### queue

```cpp
#include<bits/stdc++.h>
using namespace std;

template<typename T>
struct Queue_list{
    T *val;
    int len;
    int start;
    int end;
    Queue_list(int len):len(len){
        val = new T[len];
        start = 0;
        end = 0;
    }
    ~Queue_list(){
        delete[] val;
    }
    int loc(int lo){
        return (lo)%this->len;
    }
    void distroy(){
        delete[] val;
    }
    bool push(T v){
        int tmp_loc = loc(end+1);
        if(tmp_loc == start){
            return false;
        }
        val[end] = v;
        end = tmp_loc;
        return true;
    }
    bool pop(T &v){
        if(end == start)return false;
        v = val[start];
        start = loc(start+1);
        return true;    
    }
    int length(){
        return len;
    }
    bool isEmpty(){
        return start == end;
    }
};

int main(){
    int len = 5;
    Queue_list<int> q(len+1);
    cout<<q.isEmpty();
    q.push(5);
    q.push(4);
    int res1,res2;
    q.pop(res1);
    q.pop(res2);
    cout<<res1<<" "<<res2<<"\n";
    q.push(5);
    q.push(5);
    q.push(4);
    q.push(5);
    q.push(4);
    q.pop(res1);
    cout<<res1<<" "<<res2;
}
```


### union
```cpp
//并查集 路径压缩+按秩合并
#include<bits/stdc++.h>
using namespace std;
#define N 200005
int n,m,x,y,z;

int fa[N];
int siz[N]; //子树大小

int find(int x){
  return fa[x]==x?x:fa[x]=find(fa[x]);
}
void unset(int x,int y){
  x=find(x),y=find(y);
  if(x==y)return;
  if(siz[x]<siz[y]) swap(x,y);
  fa[y]=x; siz[x]+=siz[y];
}
int main(){
  cin>>n>>m;
  for(int i=1;i<=n;i++) fa[i]=i,siz[i]=1;
  while(m --){
    cin>>z>>x>>y;
    if(z==1) unset(x,y);
    else{
      if(find(x)==find(y))puts("Y");
      else puts("N");
    }
  }
}
```
end



## string
### KMP
```cpp
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
```
