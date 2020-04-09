function output = fm_disp(obj,varargin)
% FM_DISP display messages
%
% OUTPUT = FM_DISP(VARARGIN)
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    02-Feb-2003
%Update:    09-Jul-2003
%Version:   1.0.3
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano
if obj.clpsat.init && ~obj.clpsat.mesg
  return
end

% check inputs
% ----------------------------------------------------------
switch nargin-1
 case 0
  testo = {'   '};
  colore = 1;
 case 1
  testo = varargin{1};
  colore = 1;
 case 2
  testo = varargin{1};
  colore = varargin{2};
 otherwise
  testo = 'Improper call to function "fm_disp"';
  colore = 2;
end

% size of input text/data
% ----------------------------------------------------------
[a,b] = size(testo);

% format text if input is a cell array
% ----------------------------------------------------------
if iscell(testo) && b > 1
  d = testo;
  testo = cell(a,1);
  testo{1,1} = '';
  for i = 1:a,
    for j = 1:b,
      testo{i,1} = [testo{i,1},fvar([' ',d{i,j}],14)];
    end
  end
end

% actions for string/numeric input
% ----------------------------------------------------------
if ischar(testo),
  testo = cellstr(testo);
end
if isnumeric(testo)
  d = testo;
  string = '';
  testo = cell(a,1);
  for i = 1:b  % liulin122
    temp1 = num2str(d(:,i)');
    temp2 = findstr(temp1, '.');
    if ~isempty(temp2)
      string = [string, ' %-13.4f'];
    else
      string = [string, ' %-13.0f'];
    end
  end
  for i = 1:a,
    testo{i,1} = sprintf(string,d(i,:));
  end
end
%if isnumeric(testo)
%  d = testo;
%  string = '';
%  testo = cell(a,1);
%  for i = 1:b,
%    string = [string, ' %-13.4f'];
%  end
%  for i = 1:a,
%    testo{i,1} = sprintf(string,d(i,:));
%  end
%end

% display last text row on the main window bar
% ----------------------------------------------------------

if ishandle(obj.Fig.main)
  switch colore
   case 1,
    set(obj.Hdl.text, ...
        'String', testo{end,1}, ...
        'ForegroundColor', obj.Theme.color05);
   case 2,
    set(obj.Hdl.text, ...
        'String', testo{end,1}, ...
        'ForegroundColor', obj.Theme.color07);
    if obj.Settings.beep, beep, end
   case 3,
    set(obj.Hdl.text, ...
        'String', testo{end,1}, ...
        'ForegroundColor', obj.Theme.color05);
  end
  drawnow;
end

% resize obj.History.text cell array and display on workspace
% ----------------------------------------------------------
if colore < 3
  obj.History.text = [obj.History.text; testo];
  len = length(obj.History.text);
  if len > obj.History.Max,
    obj.History.text = obj.History.text(len-obj.History.Max+1:end);
  end
  if ishandle(obj.Fig.hist),
    set(obj.Hdl.hist, 'String', obj.History.text);
  end
  if obj.History.workspace || obj.clpsat.init,
    if obj.Settings.matlab && obj.Settings.hostver >= 7.14,
      disp(char(testo))
    else
      disp(strvcat(testo))
    end
  end
end

% output formatted text
% ----------------------------------------------------------
if nargout > 0, output = testo; end