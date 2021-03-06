function [q,idx] = qmin(a,psat_obj)

if a.n
  q = a.u.*a.con(:,7);
  idx = a.bus;
elseif ~isempty(a.store)
  q = a.store(:,a.ncol).*a.store(:,7).*a.store(:,2)/psat_obj.Settings.mva;
  idx = getint(psat_obj.Bus,a.store(:,1));
else
  q = [];
  idx = [];
end
