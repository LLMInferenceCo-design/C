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