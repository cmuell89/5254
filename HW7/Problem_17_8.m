% opt_pol_pos_data.m
% optimal political positioning.
% Set random seeds
randn('state',0);
rand('state',0);
% Set parameters
K = 12; % demographic groups (constituencies)
P = 20000 + ceil(50000*rand(K,1)); % group populations
n = 5; % political issues
W = randn(K,n); % W(k,:) = (w_k)^T political views of each constituency
v = rand(K,1); % v(k) = v_k preference of constituency for prior position
l= -ones(n,1); % lower limit on position change
u= ones(n,1); % upper limit on position change
g = @(z) 1./(1+exp(-z)); % logistic function
gp = @(z) exp(-z)./(1+exp(-z)).^2; % derivative of logistic function
gapxi = @(z,i) g(i)+gp(i)*(z-i);
% concave approximation to logistic function (upper bound when z >= 0) at point i
gapx = @(z) min(min(min(min(min(1,gapxi(z,0)),gapxi(z,1)),gapxi(z,2)),gapxi(z,3)),gapxi(z,4));
% concave approximation to logistic function (upper bound when z >= 0)

cvx_begin
variable x(n)
maximize(P'*gapx(W*x+v))
subject to
    W*x+v >= 0
    l <= x <= u
    l < 0
    u > 0
cvx_end

x