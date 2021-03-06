
M = [1 -1/2; -1/2 2];
m = [-1 0]';
A = [1 2; 1 -4; 5 76];
b = [-2 -3 1]';

cvx_begin
    variable x(2)
    dual variable y
    minimize(quad_form(x, M)+m'*x)
    subject to
        y: A*x <= b;
cvx_end
p_star = cvx_optval
y
x


i = 0
j = 0

p_pred = p_star - [y(1) y(2)]*[i; j]*delta;
cvx_begin
    variable x(2)
    minimize(quad_form(x,Q)+f'*x)
    subject to
        A*x <= b+[i;j;0]*delta
cvx_end
p_exact = cvx_optval;
i*delta 
j*delta 
p_pred 
p_exact