function  [cont, obser] = checkContObser(A, B, C)
%% Checking for Controllability & Observability
co=ctrb(A,B);
if rank(co)==size(A)
   cont = 'This system is controllable.';
else
   if rank(co)==0
      cont = 'This system is uncontrollable.';
   else
      cont = 'This system is stabilizable.';
   end
end
cont = cont + string(sprintf('Rank = %f/%f', rank(co),size(A)));

obs=obsv(A,C);
if rank(obs)==size(A)
   obser = 'This system is observable.';
else
   if rank(obs)==0
      obser = 'This system is unobservable.';
   else
      obser = 'This system is detectable.';
   end
end
obser = obser + string(sprintf('Rank = %f/%f', rank(obs),size(C)));
