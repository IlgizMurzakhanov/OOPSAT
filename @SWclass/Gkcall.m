function Gkcall(p,psat_obj)

if ~p.n, return, end

jdx = find(p.u);
idx = p.bus(jdx);

if isempty(idx),return, end

psat_obj.DAE.Gk(idx) = psat_obj.DAE.Gk(idx) - p.con(jdx,11).*p.pg(jdx);
