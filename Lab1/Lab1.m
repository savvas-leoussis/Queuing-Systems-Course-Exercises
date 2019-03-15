clc;
clear all;
close all;
##################################POISSON DISTRIBUTION##################################

# A

k = 0:1:70;
lambda = [3,10,30,50];

for i=1:columns(lambda)
  poisson(i,:) = poisspdf(k,lambda(i));
endfor

colors = "rbmy";
figure(1);
hold on;
for i=1:columns(lambda)
  if(lambda(i)!=30)
    plot(k,poisson(i,:),colors(i),"linewidth",1.2);
  endif
endfor
hold off;

title("probability density function of Poisson processes");
xlabel("k values");
ylabel("probability");
legend("lambda=3","lambda=10","lambda=50");

# B

colors = "rbym";
index = find(lambda == 30);
chosen = poisson(index,:);
mean_value = 0;
for i=0:(columns(poisson(index,:))-1)
  mean_value = mean_value + i.*poisson(index,i+1);
endfor

display("mean value of Poisson with lambda 30 is");
display(mean_value);

second_moment = 0;
for i=0:(columns(poisson(index,:))-1)
  second_moment = second_moment + i.*i.*poisson(index,i+1);
endfor

variance = second_moment - mean_value.^2;
display("Variance of Poisson with lambda 30 is");
display(variance);

# C

first = find(lambda==10);
second = find(lambda==50);
poisson_first = poisson(first,:);
poisson_second = poisson(second,:);

composed = conv(poisson_first,poisson_second);
new_k = 0:1:(2*70);

figure(2);
hold on;
plot(k,poisson_first(:),colors(1),"linewidth",1.2);
plot(k,poisson_second(:),colors(2),"linewidth",1.2);
plot(new_k,composed,"mo","linewidth",2);
hold off;
title("Convolution of two Poisson processes");
xlabel("k values");
ylabel("Probability");
legend("lambda=10","lambda=50","new process");

# D

k = 0:1:200;
lambda = 30;
i = 1:1:5;
n = [300,3000,30000]; 
p = lambda./n;
figure(3);
title("Poisson process as the limit of the binomial process");
xlabel("k values");
ylabel("Probability");
hold on;
for i=1:3
  binomial = binopdf(k,n(i),p(i));
  plot(k,binomial,colors(i),'linewidth',1.2);
endfor
hold off;

########################EXPONENTIAL DISTRIBUTION################################

# A

k = 0:0.00001:8;
lambda = [1/0.5,1,1/3];
for i=1:columns(lambda)
  expon(i,:) = exppdf(k,lambda(i));
endfor

figure(4);
hold on;
for i=1:columns(lambda)
  plot(k,expon(i,:),colors(i),"linewidth",1.2);
endfor
hold off;

title("Cumulative Distribution Function of Poisson Processes");
xlabel("k values");
ylabel("Probability");
legend("1/lambda=0.5","1/lambda=1","1/lambda=3");
clear expon;

# B

k = 0:0.00001:8;
lambda = [1/0.5,1,1/3];
for i=1:columns(lambda)
  expon(i,:) = expcdf(k,lambda(i));
endfor

figure(5);
hold on;
for i=1:columns(lambda)
  plot(k,expon(i,:),colors(i),"linewidth",1.2);
endfor
hold off;

title("Cumulative Distribution Function of Poisson Processes");
xlabel("k values");
ylabel("Probability");
legend("1/lambda=0.5","1/lambda=1","1/lambda=3");

# C

display("P(X>30000) = ");
display(1-expon(30000));
display("P(X>50000|X>20000) = ");
display(1-expon(20000));

# D

number_of_samples=5000;
X1=exprnd(1/2,1,number_of_samples);
X2=exprnd(1,1,number_of_samples);
Y=min(X1,X2);
maximum_observation=max(Y);
number_of_classes=50;
width_of_class=maximum_observation/number_of_classes;
[NN,XX]=hist(Y,number_of_classes);
NN_without_free_variables=NN/width_of_class/number_of_samples;
figure(6);
hold on;
bar(XX,NN_without_free_variables);
plot(XX,NN_without_free_variables,"r","linewidth",1.3);
xlabel("classes");
ylabel("frequency");

#########################POISSON COUNTING PROCESS###############################

# A

number_of_samples=100;
X1 = exprnd(5,1,number_of_samples);
figure(7);
stairs(X1);
title("Poisson Counting Process");
xlabel("t");
ylabel("N(t)");