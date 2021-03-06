function a = BFclass(psat_obj,varargin)
% constructor of the class Busfreq
% == Busfreq ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.dat = [];
  a.x = [];
  a.w = [];
  a.u = [];
  a.ncol = 4;
  a.store = [];
  a.format = ['%4d %8.4g %8.4g %2u'];
  if psat_obj.Settings.matlab, a = class(a,'BFclass'); end
 case 2
  if isa(varargin{1},'BFclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
