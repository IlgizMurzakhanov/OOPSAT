function a = add(a,data,psat_obj)


a.n = a.n + length(data(1,:));
a.con = [a.con; data];
[a.bus,a.vbus] = getbus(psat_obj.Bus,a.con(:,1));
if length(data(:,1)) < a.ncol
  a.u = [a.u; ones(length(data(1,:)),1)];
else
  a.u = [a.u; data(:,12)];
end
a.init = [a.init; data(:,11)];
