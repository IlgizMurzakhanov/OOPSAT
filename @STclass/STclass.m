function a = STclass(psat_obj,varargin)
% constructor of the class Statcom
% == Statcom ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.ist = [];
  a.store = [];
  a.vref = [];
  a.Vref = [];
  a.u = [];
  a.ncol = 9;
  a.format = ['%4d ', repmat('%8.4g ',1,7),'%2u'];
  if psat_obj.Settings.matlab, a = class(a,'STclass'); end
 case 2
  if isa(varargin{1},'STclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
