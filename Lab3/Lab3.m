clc;
clear all;
close all;
fig_num = 1;
############# M/M/1 AND M/D/1 SYSTEMS COMPARISON #############

# 3

lambda=0.1:0.1:2.9;
mu=[3];
[UD RD QD XD] = qsmd1(lambda,mu);
[UM RM QM XM p0] = qsmm1(lambda,mu);
figure(fig_num++);
subplot(2,1,1);
hold on;
plot(lambda./mu,QD,"r");
plot(lambda./mu,QM,"b");
hold off;
title("Average number of clients for each rho");
xlabel("rho");
ylabel("Average number of clients");
legend("M/D/1","M/M/1");

subplot(2,1,2);
hold on;
plot(lambda./mu,RD,"r");
plot(lambda./mu,RM,"b");
hold off;
title("Server response time for each rho");
xlabel("rho");
ylabel("Server response time");
legend("M/D/1","M/M/1");

############# M/M/1/10 SYSTEM SIMULATION #############

lambda = [1,5,10]; 
mu = 5;

for lambda = [1,5,10]
  total_arrivals = 0; % to measure the total number of arrivals
  current_state = 0;  % holds the current state of the system
  previous_mean_clients = 0; % will help in the convergence test
  index = 0;
  clear arrivals;
  clear P;
  display(lambda);
  threshold = lambda/(lambda + mu); % the threshold used to calculate probabilities
  rand("seed",1);
  transitions = 0; % holds the transitions of the simulation in transitions steps

  while transitions >= 0
    transitions = transitions + 1; % one more transitions step
    
    if mod(transitions,1000) == 0 % check for convergence every 1000 transitions steps
      index = index + 1;
      for i=1:1:length(arrivals)
          P(i) = arrivals(i)/total_arrivals; % calculate the probability of every state in the system
      endfor
      P_blocking = P(length(arrivals));
      mean_clients = 0; % calculate the mean number of clients in the system
      for i=1:1:length(arrivals)
         mean_clients = mean_clients + (i-1).*P(i);
      endfor
      
      to_plot(index) = mean_clients;
          
      if abs(mean_clients - previous_mean_clients) < 0.00001 || transitions > 1000000 % convergence test
        break;
      endif
      
      previous_mean_clients = mean_clients;
      
    endif
    
    random_number = rand(1); % generate a random number (Uniform distribution)
#    if (transitions<=30) % debugging
#      display("##### NEW TRANSITION #####");
#      display(transitions);
#      display(current_state);
#      if current_state == 0 || random_number < threshold
#        display("Next transition is an arrival.");
#      else
#        display("Next transition is a departure.");
#      endif
#      display(total_arrivals);
#    endif
    if current_state == 0 || random_number < threshold % arrival
      total_arrivals = total_arrivals + 1;
      try % to catch the exception if variable arrivals(i) is undefined. Required only for systems with finite capacity.
        arrivals(current_state + 1) = arrivals(current_state + 1) + 1; % increase the number of arrivals in the current state
      catch
        arrivals(current_state + 1) = 1;
      end
      if current_state == 10
        continue;  
      else
        current_state = current_state + 1;
      endif
    else % departure
      if current_state != 0 % no departure from an empty system
        current_state = current_state - 1;  
      endif
    endif
  endwhile

  for i=1:1:length(arrivals)
    display(P(i));
  endfor
  display(P_blocking);
  figure(fig_num++);
  plot(to_plot,"r","linewidth",1.3);
  title("Average number of clients in the M/M/1/10 queue: Convergence");
  xlabel("transitions in thousands");
  ylabel("Average number of clients");

  figure(fig_num++);
  bar(P,'r',0.4);
  title("Probabilities");
endfor

############# M/M/1/5 SYSTEM SIMULATION WITH VARIABLE MU #############

# 1 

states = [0,1,2,3,4,5];
initial_state = [1,0,0,0,0,0];
lambda = 3;
mu = 1;
births_B = [lambda,lambda,lambda,lambda,lambda];
deaths_D = [mu*2,mu*3,mu*4,mu*5,mu*6];
transition_matrix = ctmcbd(births_B,deaths_D);
P = ctmc(transition_matrix);
for i=[1,2,3,4,5,6]
  index = 0;
  for T=0:0.01:50
    index = index + 1;
    P0 = ctmc(transition_matrix,T,initial_state);
    Prob0(index) = P0(i);
    if P0-P < 0.01
      break;
    endif
  endfor
endfor
display(P0);

# 2

lambda = 3; 
mu = [1,2,3,4,5,6];

for criterion = [1,0.1,0.01,0.001,0.0001,0.00001,0.000001,0.0000001]
  total_arrivals = 0; % to measure the total number of arrivals
  current_state = 0;  % holds the current state of the system
  previous_mean_clients = 0; % will help in the convergence test
  index = 0;
  clear arrivals;
  clear P;
  rand("seed",1);
  transitions = 0; % holds the transitions of the simulation in transitions steps

  while transitions >= 0
    threshold = lambda/(lambda + current_state + 1);
    transitions = transitions + 1; % one more transitions step
    if mod(transitions,1000) == 0 % check for convergence every 1000 transitions steps
      index = index + 1;
      for i=1:1:length(arrivals)
          P(i) = arrivals(i)/total_arrivals; % calculate the probability of every state in the system
      endfor
      P_blocking = P(length(arrivals));
      mean_clients = 0; % calculate the mean number of clients in the system
      for i=1:1:length(arrivals)
         mean_clients = mean_clients + (i-1).*P(i);
      endfor
      
      to_plot(index) = mean_clients;    
      if abs(mean_clients - previous_mean_clients) < 1/criterion || transitions > 1000000 % convergence test
        display(criterion);
        display(transitions);
        break;
      endif
      previous_mean_clients = mean_clients;
    endif
    random_number = rand(1); % generate a random number (Uniform distribution)
    if current_state == 0 || random_number < threshold % arrival
      total_arrivals = total_arrivals + 1;
      try % to catch the exception if variable arrivals(i) is undefined. Required only for systems with finite capacity.
        arrivals(current_state + 1) = arrivals(current_state + 1) + 1; % increase the number of arrivals in the current state
      catch
        arrivals(current_state + 1) = 1;
      end
      if current_state == 5
        continue;  
      else
        current_state = current_state + 1;
      endif
    else % departure
      if current_state != 0 % no departure from an empty system
        current_state = current_state - 1;  
      endif
    endif
  endwhile
  display(P);
  display(P_blocking);
  display(mean_clients);
endfor