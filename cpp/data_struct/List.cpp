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

