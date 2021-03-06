function Fxcall(a,psat_obj)

if ~a.n, return, end

V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);
t1 = psat_obj.DAE.y(a.bus1);
t2 = psat_obj.DAE.y(a.bus2);
ss = sin(t1-t2);
cc = cos(t1-t2);
Tr = a.con(:,9);

x1 = psat_obj.DAE.x(a.x1);
x1_max = a.con(:,10);
x1_min = a.con(:,11);

DB = dbtcsc(a,psat_obj);

u = x1 < x1_max & x1 > x1_min & a.u;
tx = a.con(:,3) == 1;
t2 = a.con(:,3) == 2 & a.u;
ta = a.con(:,4) == 1;   

Kp = t2.*a.con(:,12);
Ki = t2.*a.con(:,13);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.x1,a.x1,1./Tr,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.x1,a.x0,a.u./Tr,psat_obj.DAE.n,psat_obj.DAE.m);

P1vs = DB.*V1.*V2.*ss;  
Q1vs = DB.*V1.*(V1-V2.*cc);
Q2vs = DB.*V2.*(V2-V1.*cc);

psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.bus1,a.x1,u.*P1vs,psat_obj.DAE.m,psat_obj.DAE.n);  
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.bus2,a.x1,u.*P1vs,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.v1,a.x1,u.*Q1vs,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.v2,a.x1,u.*Q2vs,psat_obj.DAE.m,psat_obj.DAE.n);    
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.x0,a.x1,u.*ta.*Kp.*P1vs,psat_obj.DAE.m,psat_obj.DAE.n);

a1 = ta.*ss.*(a.B+a.y);
a3 = V1.*V2;
a5 = ta.*a3.*cc.*(a.B+a.y);
i2 = find(t2);
x2 = a.x2(i2);

ty2 = find(a.con(:,3) == 2);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.x2(ty2),a.x2(ty2),~a.u(ty2),psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(x2,a.pref(i2),Ki(i2),psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(x2,a.v1(i2),Ki(i2).*V2(i2).*a1(i2),psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(x2,a.v2(i2),Ki(i2).*V1(i2).*a1(i2),psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(x2,a.bus1(i2),Ki(i2).*a5(i2),psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(x2,a.bus2(i2),Ki(i2).*a5(i2),psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(x2,a.x1(i2),u(i2).*ta(i2).*Ki(i2).*P1vs(i2),psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.x0(i2),x2,t2(i2),psat_obj.DAE.m,psat_obj.DAE.n);
