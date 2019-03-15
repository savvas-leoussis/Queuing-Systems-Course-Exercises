clc;
clear all;
close all;

#############M/M/1 QUEUE ANALYSIS WITH OCTAVE#############

# B

lambda=5;
mu=[6,7,8,9,10];
[U R Q X p0] = qsmm1( lambda,mu);

figure(1);
subplot(2,2,1);
plot(mu,U);
title("Server Utilization for each µ");
xlabel("µ");
ylabel("Server Utilization");

subplot(2,2,2);
plot(mu,R);
title("Server Response Time for each µ");
xlabel("µ");
ylabel("Server Response Time");

subplot(2,2,3);
plot(mu,Q);
title("Average Number of Requests for each µ");
xlabel("µ");
ylabel("Average Number of Requests");

subplot(2,2,4);
plot(mu,X);
title("Server Throughput for each µ");
xlabel("µ");
ylabel("Server Throughput");

###########COMPARISON OF SYSTEMS WITH 2 SERVERS###########

lambda=10;
mu=10;
[U R Q X p0 pm] = qsmmm( lambda, mu, 2 );
display("M/M/2 queue response time =");
display(R);

[U R Q X p0] = qsmm1( lambda/2, mu ); #Assuming that each of the
                                      #M/M/1 queues have the same
                                      #propability of being used by
                                      #the clients, then the lambda
                                      #parameter of each queue becomes
                                      #lambda times that propability,which
                                      #is lambda/2.
display("2 M/M/1 parallel queues response time =");
display(R);

##################BIRTH-DEATH PROCESS##################
###########IMPLEMENTATION IN A M/M/1/K SYSTEM#####################

# B lambda=5, mu=10
states = [0,1,2,3,4];
initial_state = [1,0,0,0,0];
lambda = 5;
mu = 10;
births_B = [lambda,lambda/2,lambda/3,lambda/4];
deaths_D = [mu,mu,mu,mu];
# B-i
transition_matrix = ctmcbd(births_B,deaths_D);
display(transition_matrix);
# B-ii
P = ctmc(transition_matrix);
display("Ergodic propabilities (From P0 to P4):");
display(P);
# B-v
for i=[1,2,3,4,5]
  index = 0;
  for T=0:0.01:50
    index = index + 1;
    P0 = ctmc(transition_matrix,T,initial_state);
    Prob0(index) = P0(i);
    if P0-P < 0.01
      break;
    endif
  endfor

  T = 0:0.01:T;
  figure(i+1);
  plot(T,Prob0,"r","linewidth",1.3);
  title({"lambda=10, mu=5";strcat("P",num2str(i-1));});
endfor
# B-vi-i lambda=5, mu=1
clear Prob0,T;
states = [0,1,2,3,4];
initial_state = [1,0,0,0,0];
lambda = 5;
mu = 1;
births_B = [lambda,lambda/2,lambda/3,lambda/4];
deaths_D = [mu,mu,mu,mu];
transition_matrix = ctmcbd(births_B,deaths_D);
P = ctmc(transition_matrix);
for i=[1,2,3,4,5]
  index = 0;
  for T=0:0.01:50
    index = index + 1;
    P0 = ctmc(transition_matrix,T,initial_state);
    Prob0(index) = P0(i);
    if P0-P < 0.01
      break;
    endif
  endfor
  T = 0:0.01:T;
  figure(i+6);
  plot(T,Prob0,"r","linewidth",1.3);
  title({"lambda=5, mu=1";strcat("P",num2str(i-1));});
endfor
# B-vi-ii lambda=5, mu=5
clear Prob0,T;
states = [0,1,2,3,4];
initial_state = [1,0,0,0,0];
lambda = 5;
mu = 5;
births_B = [lambda,lambda/2,lambda/3,lambda/4];
deaths_D = [mu,mu,mu,mu];
transition_matrix = ctmcbd(births_B,deaths_D);
P = ctmc(transition_matrix);
for i=[1,2,3,4,5]
  index = 0;
  for T=0:0.01:50
    index = index + 1;
    P0 = ctmc(transition_matrix,T,initial_state);
    Prob0(index) = P0(i);
    if P0-P < 0.01
      break;
    endif
  endfor
  T = 0:0.01:T;
  figure(i+11);
  plot(T,Prob0,"r","linewidth",1.3);
  title({"lambda=5, mu=5";strcat("P",num2str(i-1));});
endfor
# B-vi-iii lambda=5, mu=20
clear Prob0,T;
states = [0,1,2,3,4];
initial_state = [1,0,0,0,0];
lambda = 5;
mu = 20;
births_B = [lambda,lambda/2,lambda/3,lambda/4];
deaths_D = [mu,mu,mu,mu];
transition_matrix = ctmcbd(births_B,deaths_D);
P = ctmc(transition_matrix);
for i=[1,2,3,4,5]
  index = 0;
  for T=0:0.01:50
    index = index + 1;
    P0 = ctmc(transition_matrix,T,initial_state);
    Prob0(index) = P0(i);
    if P0-P < 0.01
      break;
    endif
  endfor
  T = 0:0.01:T;
  figure(i+16);
  plot(T,Prob0,"r","linewidth",1.3);
  title({"lambda=5, mu=20";strcat("P",num2str(i-1));});
endfor