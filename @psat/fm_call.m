function fm_call(obj,flag)


%FM_CALL calls component equations
%
%FM_CALL(CASE)
%  CASE '1'  algebraic equations
%  CASE 'pq' load algebraic equations
%  CASE '3'  differential equations
%  CASE '1r' algebraic equations for Rosenbrock method
%  CASE '4'  state Jacobians
%  CASE '0'  initialization
%  CASE 'l'  full set of equations and Jacobians
%  CASE 'kg' as "L" option but for distributed slack bus
%  CASE 'n'  algebraic equations and Jacobians
%  CASE 'i'  set initial point
%  CASE '5'  non-windup limits
%
%see also FM_WCALL

switch flag

 case 'gen'

  obj.Line = gcall(obj.Line,obj);
  gcall(obj.PQ,obj)

 case 'load'

  gcall(obj.PQ,obj)
  gisland(obj.Bus,obj)

 case 'gen0'

  obj.Line = gcall(obj.Line,obj);
  gcall(obj.PQ,obj)

 case 'load0'

  gcall(obj.PQ,obj)
  gisland(obj.Bus,obj)

 case '3'

  fcall(obj.Syn,obj)
  obj.Exc = fcall(obj.Exc,obj);

 case '1r'

  obj.Line = gcall(obj.Line,obj);
  gcall(obj.PQ,obj)
  obj.Syn = gcall(obj.Syn,obj);
  gcall(obj.Exc,obj)
  obj.PV = gcall(obj.PV,obj);
  obj.SW = gcall(obj.SW,obj);
  gisland(obj.Bus,obj)

 case 'series'

  obj.Line = gcall(obj.Line,obj);
  gisland(obj.Bus,obj)

 case '4'

  obj.DAE.Fx = sparse(obj.DAE.n,obj.DAE.n);
  obj.DAE.Fy = sparse(obj.DAE.n,obj.DAE.m);
  obj.DAE.Gx = sparse(obj.DAE.m,obj.DAE.n);
  Fxcall(obj.Syn,obj)
  Fxcall(obj.Exc,obj)

 case '0'

  obj.Syn = setx0(obj.Syn,obj);
  obj.Exc = setx0(obj.Exc,obj);

 case 'fdpf'

  obj.Line = gcall(obj.Line,obj);
  gcall(obj.PQ,obj)
  obj.PV = gcall(obj.PV,obj);
  obj.SW = gcall(obj.SW,obj);
  gisland(obj.Bus,obj)

 case 'l'

  obj.Line = gcall(obj.Line,obj);
  gcall(obj.PQ,obj)
  obj.PV = gcall(obj.PV,obj);
  obj.SW = gcall(obj.SW,obj);
  gisland(obj.Bus,obj)
  Gycall(obj.Line,obj)
  Gycall(obj.PQ,obj)
  Gycall(obj.PV,obj)
  Gycall(obj.SW,obj)
  Gyisland(obj.Bus,obj)


  
  obj.DAE.Fx = sparse(obj.DAE.n,obj.DAE.n);
  obj.DAE.Fy = sparse(obj.DAE.n,obj.DAE.m);
  obj.DAE.Gx = sparse(obj.DAE.m,obj.DAE.n);
  Fxcall(obj.PV,obj)
  Fxcall(obj.SW,obj)

 case 'kg'

  obj.Line = gcall(obj.Line,obj);
  gcall(obj.PQ,obj)
  obj.Syn = gcall(obj.Syn,obj);
  gcall(obj.Exc,obj)
  gisland(obj.Bus,obj)
  Gycall(obj.Line,obj)
  Gycall(obj.PQ,obj)
  obj.Syn = Gycall(obj.Syn,obj);
  Gycall(obj.Exc,obj)
  Gyisland(obj.Bus,obj)


  fcall(obj.Syn,obj)
  obj.Exc = fcall(obj.Exc,obj);

  obj.DAE.Fx = sparse(obj.DAE.n,obj.DAE.n);
  obj.DAE.Fy = sparse(obj.DAE.n,obj.DAE.m);
  obj.DAE.Gx = sparse(obj.DAE.m,obj.DAE.n);
  Fxcall(obj.Syn,obj)
  Fxcall(obj.Exc,obj)

 case 'kgpf'

  obj.Line = gcall(obj.Line,obj);
  gcall(obj.PQ,obj)
  obj.PV = gcall(obj.PV,obj);
  greactive(obj.SW,obj)
  glambda(obj.SW,1,obj.DAE.kg,obj)
  gisland(obj.Bus,obj)
  Gycall(obj.Line,obj)
  Gycall(obj.PQ,obj)
  Gycall(obj.PV,obj)
  Gyreactive(obj.SW,obj)
  Gyisland(obj.Bus,obj)


  
  obj.DAE.Fx = sparse(obj.DAE.n,obj.DAE.n);
  obj.DAE.Fy = sparse(obj.DAE.n,obj.DAE.m);
  obj.DAE.Gx = sparse(obj.DAE.m,obj.DAE.n);
  
 case 'n'

  obj.Line = gcall(obj.Line,obj);
  gcall(obj.PQ,obj)
  obj.Syn = gcall(obj.Syn,obj);
  gcall(obj.Exc,obj)
  obj.PV = gcall(obj.PV,obj);
  obj.SW = gcall(obj.SW,obj);
  gisland(obj.Bus,obj)
  Gycall(obj.Line,obj)
  Gycall(obj.PQ,obj)
  obj.Syn = Gycall(obj.Syn,obj);
  Gycall(obj.Exc,obj)
  Gycall(obj.PV,obj)
  Gycall(obj.SW,obj)
  Gyisland(obj.Bus,obj)


 case 'i'

  obj.Line = gcall(obj.Line,obj);
  gcall(obj.PQ,obj)
  obj.Syn = gcall(obj.Syn,obj);
  gcall(obj.Exc,obj)
  obj.PV = gcall(obj.PV,obj);
  obj.SW = gcall(obj.SW,obj);
  gisland(obj.Bus,obj)
  Gycall(obj.Line,obj)
  Gycall(obj.PQ,obj)
  obj.Syn = Gycall(obj.Syn,obj);
  Gycall(obj.Exc,obj)
  Gycall(obj.PV,obj)
  Gycall(obj.SW,obj)
  Gyisland(obj.Bus,obj)


  fcall(obj.Syn,obj)
  obj.Exc = fcall(obj.Exc,obj);

  if obj.DAE.n > 0
  obj.DAE.Fx = sparse(obj.DAE.n,obj.DAE.n);
  obj.DAE.Fy = sparse(obj.DAE.n,obj.DAE.m);
  obj.DAE.Gx = sparse(obj.DAE.m,obj.DAE.n);
  end 

  Fxcall(obj.Syn,obj)
  Fxcall(obj.Exc,obj)
  Fxcall(obj.PV,obj)
  Fxcall(obj.SW,obj)

 case '5'

  windup(obj.Exc,obj)

end
