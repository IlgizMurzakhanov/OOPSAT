function p = base(p,psat_obj)
if ~p.n, return, end

fm_errv(p.con(:,4),'Dfig',p.bus)
Vb2old = p.con(:,4).*p.con(:,4);
Vb2new = getkv(psat_obj.Bus,p.bus,2);

k = psat_obj.Settings.mva*Vb2old./p.con(:,3)./Vb2new;

p.con(:,6) = k.*p.con(:,6);
p.con(:,7) = k.*p.con(:,7);
p.con(:,8) = k.*p.con(:,8);
p.con(:,9) = p.con(:,4).*p.con(:,9)./getkv(psat_obj.Bus,p.bus,1);

k = p.con(:,3)/psat_obj.Settings.mva;

p.con(:,10) = p.con(:,10).*k;
p.con(:,21) = p.con(:,21).*k;
p.con(:,22) = p.con(:,22).*k;
p.con(:,23) = p.con(:,23).*k;
p.con(:,24) = p.con(:,24).*k;