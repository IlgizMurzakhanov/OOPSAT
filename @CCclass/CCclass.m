function a = CCclass(psat_obj,varargin)
% constructor of the class Central Area Controller
% == Cac ==
switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.q1 = [];
  a.q = [];
  a.u = [];
  a.store = [];
  a.ncol = 10;
  a.format = ['%4d %8.4g %8.4g %4d ',repmat('%8.4g ',1,5),'%2u'];
  if psat_obj.Settings.matlab, a = class(a,'CCclass'); end
 case 2
  if isa(varargin{1},'CCclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
