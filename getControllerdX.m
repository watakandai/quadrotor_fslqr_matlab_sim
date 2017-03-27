function dX=getControllerdX(X, U, Actr,Bctr)
dX = Actr*X+Bctr*U;