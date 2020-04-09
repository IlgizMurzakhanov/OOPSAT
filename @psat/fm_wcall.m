function fm_wcall(obj)
%FM_WCALL writes the function FM_CALL for the component calls.
%         and uses the information in Comp.prop for setting
%         the right calls. Comp.prop is organized as follows:
%         comp(i,:) = [x1 x2 x3 x4 x5 xi x0 xt]
%
%         if x1 -> call for algebraic equations
%         if x2 -> call for algebraic Jacobians
%         if x3 -> call for state equations
%         if x4 -> call for state Jacobians
%         if x5 -> call for non-windup limits
%         if xi -> component used in power flow computations
%         if x0 -> call for initializations
%         if xt -> call for current simulation time
%                  (-1 is used for static analysis)
%
%         Comp.prop is stored in the "comp.ini" file.
%
%FM_WCALL
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    22-Aug-2003
%Update:    03-Nov-2005
%Version:   1.2.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

% -------------------------------------------------------------------------
%  Opening file "fm_call.m" for writing
% -------------------------------------------------------------------------
tmp_fName = mfilename;
tmp_path = mfilename('fullpath');

fm_call_path = tmp_path(1:end-length(tmp_fName));

if obj.Settings.local
  fid = fopen([fm_call_path,'fm_call.m'], 'wt');
else
  [fid,msg] = fopen([fm_call_path,'fm_call.m'], 'wt');
  if fid == -1
    fm_disp(msg)
    fid = fopen([fm_call_path,'fm_call.m'], 'wt');
  end
end
count = fprintf(fid,'function fm_call(obj,flag)\n\n');

count = fprintf(fid,'\n%%FM_CALL calls component equations');
count = fprintf(fid,'\n%%');
count = fprintf(fid,'\n%%FM_CALL(CASE)');
count = fprintf(fid,'\n%%  CASE ''1''  algebraic equations');
count = fprintf(fid,'\n%%  CASE ''pq'' load algebraic equations');
count = fprintf(fid,'\n%%  CASE ''3''  differential equations');
count = fprintf(fid,'\n%%  CASE ''1r'' algebraic equations for Rosenbrock method');
count = fprintf(fid,'\n%%  CASE ''4''  state Jacobians');
count = fprintf(fid,'\n%%  CASE ''0''  initialization');
count = fprintf(fid,'\n%%  CASE ''l''  full set of equations and Jacobians');
count = fprintf(fid,'\n%%  CASE ''kg'' as "L" option but for distributed slack bus');
count = fprintf(fid,'\n%%  CASE ''n''  algebraic equations and Jacobians');
count = fprintf(fid,'\n%%  CASE ''i''  set initial point');
count = fprintf(fid,'\n%%  CASE ''5''  non-windup limits');
count = fprintf(fid,'\n%%');
count = fprintf(fid,'\n%%see also FM_WCALL\n\n');
% count = fprintf(fid,'fm_var\n\n');
count = fprintf(fid,'switch flag\n');

% -------------------------------------------------------------------------
% look for loaded components
% -------------------------------------------------------------------------
obj.Comp.prop(:,10) = 0;
for i = 1:obj.Comp.n
  ncompi = eval(['obj.', obj.Comp.names{i},'.n']);    % please kill me
  if ncompi, obj.Comp.prop(i,10) = 1; end
end

cidx1 = find(obj.Comp.prop(:,10));
prop1 = obj.Comp.prop(cidx1,1:9);
s11 = buildcell(cidx1,prop1(:,1),'gcall',obj);
s12 = buildcell(cidx1,prop1(:,2),'Gycall',obj);
s13 = buildcell(cidx1,prop1(:,3),'fcall',obj);
s14 = buildcell(cidx1,prop1(:,4),'Fxcall',obj);
s15 = buildcell(cidx1,prop1(:,5),'windup',obj);

cidx2 = find(obj.Comp.prop(1:end-2,10));
prop2 = obj.Comp.prop(cidx2,1:9);
s20 = buildcell(cidx2,prop2(:,7),'setx0',obj);
s21 = buildcell(cidx2,prop2(:,1),'gcall',obj);
s22 = buildcell(cidx2,prop2(:,2),'Gycall',obj);
s23 = buildcell(cidx2,prop2(:,3),'fcall',obj);
s24 = buildcell(cidx2,prop2(:,4),'Fxcall',obj);

gisland = '  gisland(obj.Bus,obj)\n';
gyisland = '  Gyisland(obj.Bus,obj)\n';

% -------------------------------------------------------------------------
% call algebraic equations
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''gen''\n\n');
idx = find(sum(prop2(:,[8 9]),2));
count = fprintf(fid,'  %s\n',s21{idx});

% -------------------------------------------------------------------------
% call algebraic equations of shunt components
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''load''\n\n');
idx = find(prod(prop2(:,[1 8]),2));
count = fprintf(fid,'  %s\n',s21{idx});
count = fprintf(fid,gisland);

% -------------------------------------------------------------------------
% call algebraic equations
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''gen0''\n\n');
idx = find(sum(prop2(:,[8 9]),2) & prop2(:,6));
count = fprintf(fid,'  %s\n',s21{idx});

% -------------------------------------------------------------------------
% call algebraic equations of shunt components
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''load0''\n\n');
idx = find(prod(prop2(:,[1 6 8]),2));
count = fprintf(fid,'  %s\n',s21{idx});
count = fprintf(fid,gisland);

% -------------------------------------------------------------------------
% call differential equations
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''3''\n\n');
idx = find(prop2(:,3));
count = fprintf(fid,'  %s\n',s23{idx});

% -------------------------------------------------------------------------
% call algebraic equations for Rosenbrock method
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''1r''\n\n');
idx = find(prop1(:,1));
count = fprintf(fid,'  %s\n',s11{idx});
count = fprintf(fid,gisland);

% -------------------------------------------------------------------------
% call algebraic equations of series component
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''series''\n\n');
idx = find(prop1(:,9));
count = fprintf(fid,'  %s\n',s11{idx});
count = fprintf(fid,gisland);

% -------------------------------------------------------------------------
% call DAE Jacobians
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''4''\n');
writejacs(fid)
idx = find(prop2(:,4));
count = fprintf(fid,'  %s\n',s24{idx});

% -------------------------------------------------------------------------
% call initialization functions
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''0''\n\n');
idx = find(prop2(:,7));
count = fprintf(fid,'  %s\n',s20{idx});

% -------------------------------------------------------------------------
% call the complete set of algebraic equations
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''fdpf''\n\n');
idx = find(prod(prop1(:,[1 6]),2));
count = fprintf(fid,'  %s\n',s11{idx});
count = fprintf(fid,gisland);

% -------------------------------------------------------------------------
% call the complete set of equations and Jacobians
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''l''\n\n');
idx = find(prod(prop1(:,[1 6]),2));
count = fprintf(fid,'  %s\n',s11{idx});
count = fprintf(fid,gisland);
idx = find(prod(prop1(:,[2 6]),2));
count = fprintf(fid,'  %s\n',s12{idx});
count = fprintf(fid,gyisland);
count = fprintf(fid,'\n\n');
idx = find(prod(prop1(:,[3 6]),2));
count = fprintf(fid,'  %s\n',s13{idx});
writejacs(fid)
idx = find(prod(prop1(:,[4 6]),2));
count = fprintf(fid,'  %s\n',s14{idx});

% -------------------------------------------------------------------------
% call the complete set of eqns and Jacs for distributed slack bus
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''kg''\n\n');
idx = find(prop2(:,1));
count = fprintf(fid,'  %s\n',s21{idx});
count = fprintf(fid,gisland);
idx = find(prop2(:,2));
count = fprintf(fid,'  %s\n',s22{idx});
count = fprintf(fid,gyisland);
count = fprintf(fid,'\n\n');
idx = find(prop2(:,3));
count = fprintf(fid,'  %s\n',s23{idx});
writejacs(fid)
idx = find(prop2(:,4));
count = fprintf(fid,'  %s\n',s24{idx});

% -------------------------------------------------------------------------
% call the complete set of eqns and Jacs for distributed slack bus
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''kgpf''\n\n');
%count = fprintf(fid,'  global PV SW\n');
idx = find(prod(prop2(:,[1 6]),2));
count = fprintf(fid,'  %s\n',s21{idx});
count = fprintf(fid,'  obj.PV = gcall(obj.PV,obj);\n');
count = fprintf(fid,'  greactive(obj.SW,obj)\n');
count = fprintf(fid,'  glambda(obj.SW,1,obj.DAE.kg,obj)\n');
count = fprintf(fid,gisland);
idx = find(prod(prop2(:,[2 6]),2));
count = fprintf(fid,'  %s\n',s22{idx});
count = fprintf(fid,'  Gycall(obj.PV,obj)\n');
count = fprintf(fid,'  Gyreactive(obj.SW,obj)\n');
count = fprintf(fid,gyisland);
count = fprintf(fid,'\n\n');
idx = find(prod(prop2(:,[3 6]),2));
count = fprintf(fid,'  %s\n',s23{idx});
writejacs(fid)
idx = find(prod(prop2(:,[4 6]),2));
count = fprintf(fid,'  %s\n',s24{idx});

% -------------------------------------------------------------------------
% calling algebraic equations and Jacobians
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''n''\n\n');
idx = find(prop1(:,1));
count = fprintf(fid,'  %s\n',s11{idx});
count = fprintf(fid,gisland);
idx = find(prop1(:,2));
count = fprintf(fid,'  %s\n',s12{idx});
count = fprintf(fid,gyisland);
count = fprintf(fid,'\n');

% -------------------------------------------------------------------------
% call all the functions for setting initial point
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''i''\n\n');
idx = find(prop1(:,1));
count = fprintf(fid,'  %s\n',s11{idx});
count = fprintf(fid,gisland);
idx = find(prop1(:,2));
count = fprintf(fid,'  %s\n',s12{idx});
count = fprintf(fid,gyisland);
count = fprintf(fid,'\n\n');
idx = find(prop1(:,3));
count = fprintf(fid,'  %s\n',s13{idx});
count = fprintf(fid,'\n  if obj.DAE.n > 0');
writejacs(fid)
count = fprintf(fid,'  end \n\n');
idx = find(prop1(:,4));
count = fprintf(fid,'  %s\n',s14{idx});

% -------------------------------------------------------------------------
% call saturation functions
% -------------------------------------------------------------------------
count = fprintf(fid,'\n case ''5''\n\n');
idx = find(prop1(:,5));
count = fprintf(fid,'  %s\n',s15{idx});

% -------------------------------------------------------------------------
%  close "fm_call.m"
% -------------------------------------------------------------------------
count = fprintf(fid,'\nend\n');
count = fclose(fid);
cd(obj.Path.local);


% -------------------------------------------------------------------------
% function for writing Jacobian initialization
% -------------------------------------------------------------------------
function writejacs(fid)

count = fprintf(fid,'\n  obj.DAE.Fx = sparse(obj.DAE.n,obj.DAE.n);');
count = fprintf(fid,'\n  obj.DAE.Fy = sparse(obj.DAE.n,obj.DAE.m);');
count = fprintf(fid,'\n  obj.DAE.Gx = sparse(obj.DAE.m,obj.DAE.n);\n');


% -------------------------------------------------------------------------
% function for building component call function cells
% -------------------------------------------------------------------------
function out = buildcell(j,idx,type,obj)
out = cell(length(idx),1);

h = find(idx <= 1);
k = j(h);
if obj.Settings.octave
  c = obj.Comp.names(k);
  out(h) = fm_strjoin(type,'_',lower(c),'(obj.',c,',obj)');
else
  out(h) = fm_strjoin(type,'(obj.',{obj.Comp.names{k}}',',obj)');
end

h = find(idx == 2);
k = j(h);
if obj.Settings.octave
  c = obj.Comp.names(k);
  out(h) = fm_strjoin('obj.', c,' = ',type,'_',lower(c),'(',c,');');
else
  str = [' = ',type,'(obj.'];
  out(h) = fm_strjoin('obj.',{obj.Comp.names{k}}',str,{obj.Comp.names{k}}',',obj);');
end