#include<bits/stdc++.h>
using namespace std;
#define N 14


int n,m,l;
char a[N][N];

struct node{
    int x,y,val;
    node(int x,int y,int val):x(x),y(y),val(val){};

    bool operator==(const node& other){
        return val == other.val;
    }
};
void init_X(int x,int y){
    a[x-1][y]='X';
    a[x][y-1]='X';
    a[x+1][y]='X';
    a[x][y+1]='X';

}
void de(stack<node>&s,int x,int y, int val){
    int res=0;
    if(x>1 && a[x-1][y]!='X'){
        res++;
    }
    if(x<n && a[x+1][y]!='X'){
        res++;
    }
    if(y>1 && a[x][y-1]!='X'){
        res++;
    }
    if(y<m && a[x][y+1]!='X'){
        res++;
    }
    int tmp = (res>1)?val+1:val;
    if(x>1 && a[x-1][y]!='X'){
        s.push(*(new node(x-1,y,tmp)));
        a[x-1][y]=(a[x-1][y]=='*')?'*':'X';
    }
    if(x<n && a[x+1][y]!='X'){
        s.push(*(new node(x+1,y,tmp)));
        a[x+1][y]=(a[x+1][y]=='*')?'*':'X';
    }
    if(y>1 && a[x][y-1]!='X'){
        s.push(*(new node(x,y-1,tmp)));
        a[x][y-1]=(a[x][y-1]=='*')?'*':'X';
    }
    if(y<m && a[x][y+1]!='X'){
        s.push(*(new node(x,y+1,tmp)));
        a[x][y+1]=(a[x][y+1]=='*')?'*':'X';
    }
}
int depth(int s_x, int s_y){
    if(a[s_x][s_y]=='*')return 0;
    stack<node>s;
    node sta(s_x,s_y,0);
    s.push(sta);
    a[s_x][s_y] = 'X';
    while(!s.empty()){
        node cur = s.top();
        s.pop();
        int t_x,t_y,t_val;
        t_x = cur.x;
        t_y = cur.y;
        t_val = cur.val;
        if(a[t_x][t_y]=='*'){
            return t_val;
        }
        else{
            de(s, t_x,t_y,t_val);
        }
    }
    return -1;
}

int main(){
    int T;
    cin>>T;
    while(T--){
        cin>>n>>m;
        getchar();
        int s_x,s_y;
        for(int i=1;i<=n; i++){
            for(int j=1;j<=m;j++){
                cin>>a[i][j];
                
                if(a[i][j]=='M')
                    s_x= i,s_y=j;
            }
            getchar();
        }
        cin>>l;
        int res = depth(s_x,s_y);
        if(res==l){
            cout<<"Yes\n";
        }
        else{
            cout<<"No\n";
        }
    }

}