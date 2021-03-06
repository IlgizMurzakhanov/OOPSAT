function a = IMclass(psat_obj,varargin)
% constructor of the Induction Machine
% == Induction Machine ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.dat = [];
  a.slip = [];
  a.e1r = [];
  a.e1m = [];
  a.e2r = [];
  a.e2m = [];
  a.z = []; % startup
  a.u = []; % status
  a.ncol = 20;
  a.format = ['%4d %8.4g %8.4g %8.4g %4d %4d ',repmat('%8.4g ',1,12),'%2d %2d'];
  a.store = [];
  if psat_obj.Settings.matlab, a = class(a,'IMclass'); end
 case 2
  if isa(varargin{1},'IMclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
