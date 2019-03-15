function B = erlangb_factorial(rho, c)
  sum = 0;
  for i = 0:c
    sum = sum + (rho^i)/factorial(i);
  endfor
  B=((rho^c)/factorial(c))/sum;
endfunction
