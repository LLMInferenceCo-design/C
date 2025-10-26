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