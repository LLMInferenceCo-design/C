#include<bits/stdc++.h>
using namespace std;
struct List{
    int val;
    // List(int v):val(v){};
};
struct cmp{
    bool operator()(int a,int b){
        return a>b;
    }
};

int main(){
    int  a[5] = {2,1,4,3,5};
    List l[5];
    for(int i=0;i<5;i++){
        l[i].val = a[i];
    }
    priority_queue<int, vector<int>, cmp>q;
    q.push(4);
    q.push(5);
    q.push(3);
    while(!q.empty()){
        cout<< q.top()<<" ";
        q.pop();
    }
    cout<<"\n";
    sort(a, a+5,cmp());
    for(int i=0;i<5;i++){
        cout<<a[i]<<" ";
    }
    cout<<"\n";
}