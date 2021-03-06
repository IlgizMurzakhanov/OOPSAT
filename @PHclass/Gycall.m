function Gycall(a,psat_obj)

if ~a.n, return, end

V1 = a.u.*psat_obj.DAE.y(a.v1);
V2 = a.u.*psat_obj.DAE.y(a.v2);  
V12 = V1.*V2;
y = admittance(a);
g = real(y);
b = imag(y);
m = a.con(:,15);
m2 = m.*m;

[s12,c12] = angles(a);

k1 = (c12.*g+s12.*b)./m;
k2 = (c12.*g-s12.*b)./m;
k3 = (s12.*g-c12.*b)./m;
k4 = (s12.*g+c12.*b)./m;

psat_obj.DAE.Gy = psat_obj.DAE.Gy + ...
          sparse(a.bus1, a.v1, 2.*V1.*g./m2-V2.*k1, psat_obj.DAE.m, psat_obj.DAE.m) + ...
          sparse(a.bus1, a.v2, -V1.*k1, psat_obj.DAE.m, psat_obj.DAE.m) + ...
          sparse(a.bus2, a.v1, -V2.*k2, psat_obj.DAE.m, psat_obj.DAE.m) + ...
          sparse(a.bus2, a.v2, 2*V2.*g-V1.*k2, psat_obj.DAE.m, psat_obj.DAE.m);

psat_obj.DAE.Gy = psat_obj.DAE.Gy + ...
          sparse(a.bus1, a.bus1, V12.*k3, psat_obj.DAE.m, psat_obj.DAE.m) - ...
          sparse(a.bus1, a.bus2, V12.*k3, psat_obj.DAE.m, psat_obj.DAE.m) + ...
          sparse(a.bus2, a.bus1, V12.*k4, psat_obj.DAE.m, psat_obj.DAE.m) - ...
          sparse(a.bus2, a.bus2, V12.*k4, psat_obj.DAE.m, psat_obj.DAE.m);

psat_obj.DAE.Gy = psat_obj.DAE.Gy + ...
          sparse(a.v1, a.v1, -2.*V1.*b./m2-V2.*k3, psat_obj.DAE.m, psat_obj.DAE.m) + ...
          sparse(a.v1, a.v2, -V1.*k3, psat_obj.DAE.m, psat_obj.DAE.m) + ...
          sparse(a.v2, a.v1,  V2.*k4, psat_obj.DAE.m, psat_obj.DAE.m) + ...
          sparse(a.v2, a.v2, -2*V2.*b+V1.*k4, psat_obj.DAE.m, psat_obj.DAE.m);

psat_obj.DAE.Gy = psat_obj.DAE.Gy - ...
          sparse(a.v1, a.bus1, V12.*k1, psat_obj.DAE.m, psat_obj.DAE.m) + ...
          sparse(a.v1, a.bus2, V12.*k1, psat_obj.DAE.m, psat_obj.DAE.m) + ...
          sparse(a.v2, a.bus1, V12.*k2, psat_obj.DAE.m, psat_obj.DAE.m) - ...
          sparse(a.v2, a.bus2, V12.*k2, psat_obj.DAE.m, psat_obj.DAE.m);

