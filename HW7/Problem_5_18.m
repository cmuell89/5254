% data file for multi-label SVM problem
clear all;
randn('state', 0);
mTrain = 1000; % size of training data
mTest = 100; % size of test data
K = 10; % number of categories
n = 20; % number of features
A_true = randn(K, n);
b_true = randn(K, 1);
v = 0.2*randn(K, mTrain + mTest); % noise
data = randn(n, mTrain + mTest);
[~, label] = max(A_true * data + b_true * ones(1, mTrain + mTest) + v, [], 1);
% training data
x = data(:, 1:mTrain);
y = label(1:mTrain);
% test data
xtest = data(:, (mTrain+1):end);
ytest = label((mTrain+1):end);

up = 10^2
lo = 10^(-2)

U = [];
E = [];

U = [0.01 0.05 0.1 0.2 0.5 1 2 5 10 20 50 75 100]
% This loop generates a new u value. 
for u = 1:size(U,2)
    cvx_begin
        variable z(mTrain, 1)
        variable A(K, n)
        variable b(K, 1)
        minimize(sum(z) + U(u)*square_pos(norm(A,'fro')))
        subject to
        for i=1:mTrain
            for k=[1:y(i)-1 y(i)+1:K]
                1+(A(k,:)*x(:,i)+b(k))-(A(y(i),:)*x(:,i)+b(y(i))) <= z(i);
            end
            z(i) >= 0;
        end
        sum(b) == 0;
%         ones(K,mTrain)+A*x+b*ones(1, mTrain)-ones(K,1)*y <= ones(K,1)*z
%         1'*b == 0
%         z >= 0
    cvx_end
    % Compute the predict predicted labels by computing the affine function
    % on xtest using the estimated optial A and b. Find the max in each
    % column (i.e. argmax for label) and round to get whole number value.

    correct = 0
    y_pred = zeros(1,mTest);

    for i=1:mTest
        [~, y_pred(i)] = max(A*xtest(:,i) + b);
        if (y_pred(i) == ytest(i))
            correct = correct + 1;
        end
    end
    percent_correct = correct/mTest
    E = [E ; percent_correct]    
end
plot(U,E)