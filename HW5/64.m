n = 10;

m = 45;

m_test = 45;

sigma= 0.250;

train=[1 2 1;
1 3 1;
1 4 1;
1 5 1;
1 6 1;
1 7 1;
1 8 1;
1 9 1;
1 10 1;
2 3 -1;
2 4 -1;
2 5 -1;
2 6 -1;
2 7 -1;
2 8 -1;
2 9 -1;
2 10 -1;
3 4 1;
3 5 -1;
3 6 -1;
3 7 1;
3 8 1;
3 9 1;
3 10 1;
4 5 -1;
4 6 -1;
4 7 1;
4 8 1;
4 9 -1;
4 10 -1;
5 6 1;
5 7 1;
5 8 1;
5 9 -1;
5 10 1;
6 7 1;
6 8 1;
6 9 -1;
6 10 -1;
7 8 1;
7 9 1;
7 10 -1;
8 9 -1;
8 10 -1;
9 10 1;
];

test=[1 2 1;
1 3 1;
1 4 1;
1 5 1;
1 6 1;
1 7 1;
1 8 1;
1 9 1;
1 10 1;
2 3 -1;
2 4 1;
2 5 -1;
2 6 -1;
2 7 -1;
2 8 1;
2 9 -1;
2 10 -1;
3 4 1;
3 5 -1;
3 6 1;
3 7 1;
3 8 1;
3 9 -1;
3 10 1;
4 5 -1;
4 6 -1;
4 7 -1;
4 8 1;
4 9 -1;
4 10 -1;
5 6 -1;
5 7 1;
5 8 1;
5 9 1;
5 10 1;
6 7 1;
6 8 1;
6 9 1;
6 10 1;
7 8 1;
7 9 -1;
7 10 1;
8 9 -1;
8 10 -1;
9 10 1;
];

A1 = sparse(1:m,train(:,1),train(:,3),m,n);
A2 = sparse(1:m,train(:,2),-train(:,3),m,n);
A = A1+A2;

cvx_begin
    variable a_hat(n)
    minimize(-sum(log_normcdf(A*a_hat/sigma)))
    subject to
    a_hat >= 0
    a_hat <= 1
cvx_end
a_hat

res = sign(a_hat(test(:,1))-a_hat(test(:,2)));
Pml = 1-length(find(res-test(:,3)))/m_test
Ply = 1-length(find(train(:,3)-test(:,3)))/m_test