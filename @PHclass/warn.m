function warn(a,idx,msg,psat_obj)

psat_obj.fm_disp(fm_strjoin('Warning: PHS #',int2str(idx),' between buses <', ...
    psat_obj.Bus.names{a.bus1(idx)},'> and <', ...
    psat_obj.Bus.names{a.bus2(idx)},'> ',msg))