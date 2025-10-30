#include<bits/stdc++.h>
using namespace std;

#define N (int)(1e9+ 5)

#define ll long long

ll a[N];
ll n,m;
bool cmp(ll a,ll b){
    return a>b;
}
int main(){
    cin>>n>>m;
    map<ll,ll>mp;
    for(int i=0;i<n;i++){
        int tmp;
        cin>>tmp;
        if(mp.count(tmp)!=0){
            mp[tmp]++;
        }
        else{
            mp[tmp]=1;
        }
    }
    int loc=0;
    for(auto& [k,v]:mp){
        a[loc++] = v;
    }
    sort(a,a+loc,cmp);
    ll res = 0;
    
}