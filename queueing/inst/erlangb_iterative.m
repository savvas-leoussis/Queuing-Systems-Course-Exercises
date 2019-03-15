function B = erlangb_iterative(rho, c)
  if c == 0
    B = 1;
    return;
  else
    B = (rho*erlangb_iterative(rho,c-1))/(rho*erlangb_iterative(rho,c-1)+c);
  endif
endfunction
