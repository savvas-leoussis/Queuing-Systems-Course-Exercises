clc;
clear all;
close all;

##### NETWORK WITH ALTERNATIVE ROUTING #####

#2#
lambda = 10*10^3;
b_1= 1875000;
b_2= 1500000;
mu_1=b_1/128;
mu_2=b_2/128;
i=1;
best_a=0;
lowest_E=9999999;
for a=0.001:0.001:0.999;
  E(i)=(1/(mu_1-a*lambda))*a + (1/(mu_2-(1-a)*lambda))*(1-a);
  if E(i)<lowest_E;
    lowest_E = E(i);
    best_a=a;
   endif
  i++;
endfor
#figure(1);
#plot(0.001:0.001:0.999,E);
#xlabel("Probability a");
#ylabel("Average Waiting Time");
#title("Average Waiting Time");
#display(lowest_E);
#display(best_a);

##### OPEN QUEUING SYSTEM NETWORK #####

#2#

function [rho ergodicity] = intensities(lambda, mu)
  rho(1)=lambda(1)/mu(1);
  rho(2)=(lambda(2)+(2/7)*lambda(1))/mu(2);
  rho(3)=((4/7)*lambda(1))/mu(3);
  rho(4)=((3/7)*lambda(1))/mu(4);
  rho(5)=(lambda(2)+(4/7)*lambda(1))/mu(5);
  ergodicity=1;
  for i=1:5
    if rho(i)>1
      ergodicity=0;
    endif
  endfor
  display(rho);
endfunction

#3#

function clients = mean_clients(lambda, mu)
  [rho erg] = intensities(lambda,mu);
  if erg == 1
    for i=1:5
      clients(i)=rho(i)/(1-rho(i));
    endfor
  else
    for i=1:5
      clients(i)=0;
    endfor  
  endif
endfunction

#4#

lambda = [4 1];
mu = [6 5 8 7 6];

[rho erg] = intensities(lambda,mu);
mean_clients_ = mean_clients(lambda,mu);
Average_Time = (mean_clients_(1)+mean_clients_(2)+mean_clients_(3)+mean_clients_(4)+mean_clients_(5))/(lambda(1)+lambda(2));
display(Average_Time);

#5#

mu = [6 5 8 7 6];
best_lambda=99;
lambda_1 = 4;
while 1
  lambda=[lambda_1 1];
  [rho erg]=intensities(lambda,mu);
  if erg == 0
     best_lambda = lambda_1;
     break;
  endif
  lambda_1 = lambda_1 + 0.01;
endwhile
display(best_lambda);
  
#6#
mu = [6 5 8 7 6];
a = 1;
mean_clients_ = zeros(1, 5); 
for i = 0.1:0.01:0.99
  list=[best_lambda*i 1];
  mean_clients_ = mean_clients(list,mu);
  Average_Time_(a) = (mean_clients_(1)+mean_clients_(2)+mean_clients_(3)+mean_clients_(4)+mean_clients_(5))/(lambda(1)+lambda(2));
  a++;
endfor
figure(2)
plot(0.1:0.01:0.99,Average_Time_);
title("Average Waiting Time");
xlabel("Percentage of lambda 1");
ylabel("Average Waiting Time");
