function fig = fm_snbfig(varargin)
% FM_SNBFIG create GUI for Saddle-Node Bifurcation Analysis
%
% HDL = FM_SNBFIG()
%
%see also FM_SNB
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Version:   1.0.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

global Settings SNB Theme Fig Path

if nargin
  switch varargin{1}

   case 'report'

    if Settings.matlab && Settings.hostver >= 7.14,
      fm_stat(cellstr(char(['lambda = ', num2str(SNB.lambda)], ...
                           char(fm_strjoin('dlambda/dP_',SNB.bus, ...
                                           ' = ', num2str(SNB.dldp))))));
    else
      fm_stat(cellstr(strvcat(['lambda = ', num2str(SNB.lambda)], ...
                              strvcat(fm_strjoin('dlambda/dP_',SNB.bus, ...
                                                 ' = ', num2str(SNB.dldp))))));
    end

   case 'slack'

    hdl = findobj(Fig.snb,'Tag','Checkbox');
    SNB.slack = ~SNB.slack;
    set(hdl,'Value',SNB.slack)
    if SNB.slack
      set(gcbo,'Checked','on')
    else
      set(gcbo,'Checked','off')
    end

   case 'check'

    SNB.slack = get(gcbo,'Value');
    hdl = findobj(Fig.snb,'Tag','MenuSlack');
    if SNB.slack
      set(hdl,'Checked','on')
    else
      set(hdl,'Checked','off')
    end

  end
  return
end

if ishandle(Fig.snb), figure(Fig.snb), return, end

if strcmp(Settings.platform,'MAC')
  dm = 0.05;
else
  dm = 0;
end

onoff = {'off','on'};

h0 = figure('Color',Theme.color01, ...
            'Units', 'normalized', ...
            'ColorMap', [], ...
            'CreateFcn','Fig.snb = gcf;', ...
            'DeleteFcn','Fig.snb = -1;', ...
            'FileName','fm_snbfig', ...
            'MenuBar','none', ...
            'Name','SNB Settings', ...
            'NumberTitle','off', ...
            'PaperPosition',[18 180 576 432], ...
            'PaperType','A4', ...
            'PaperUnits','points', ...
            'Position',sizefig(0.4,0.3), ...
            'RendererMode','manual', ...
            'Tag','Settings', ...
            'ToolBar','none');

% Menu File
h1 = uimenu('Parent',h0, ...
            'Label','File', ...
            'Tag','MenuFile');
h2 = uimenu('Parent',h1, ...
            'Callback','fm_snb', ...
            'Label','Run', ...
            'Tag','OTV', ...
            'Accelerator','z');
h2 = uimenu('Parent',h1, ...
            'Callback','close(gcf)', ...
            'Label','Exit', ...
            'Tag','NetSett', ...
            'Accelerator','x', ...
            'Separator','on');

% Menu Settings
h1 = uimenu('Parent',h0, ...
            'Label','Settings', ...
            'Tag','MenuView');
h2 = uimenu('Parent',h1, ...
            'Callback','fm_snbfig slack', ...
            'Label','Distributed Slack Bus', ...
            'Tag','MenuSlack', ...
            'Checked',onoff{SNB.slack+1}, ...
            'Accelerator','s');

% Menu View
h1 = uimenu('Parent',h0, ...
            'Label','View', ...
            'Tag','MenuView');
h2 = uimenu('Parent',h1, ...
            'Callback','fm_snbfig report', ...
            'Label','Display results', ...
            'Tag','OTV', ...
            'Accelerator','d');
h2 = uimenu('Parent',h1, ...
            'Callback','fm_tviewer', ...
            'Label','Select text viewer', ...
            'Tag','NetSett', ...
            'Accelerator','t', ...
            'Separator','on');


h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'ForegroundColor',Theme.color03, ...
               'Position',[0.05 0.05 0.9 0.9], ...
               'Style','frame', ...
               'Tag','Frame1');

h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','fm_snbfig check', ...
               'Position',[0.2 0.75 0.6 0.1], ...
               'String','Distributed Slack Bus', ...
               'Style','checkbox', ...
               'Tag','Checkbox', ...
               'Value',SNB.slack);

h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color03, ...
               'Callback','fm_snb', ...
               'FontWeight','bold', ...
               'ForegroundColor',Theme.color09, ...
               'Position',[0.2 0.5 0.6 0.125+dm], ...
               'String','Run', ...
               'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','close(gcf);', ...
               'Position',[0.2 0.1 0.6  0.125+dm], ...
               'String','Close', ...
               'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','fm_snbfig report', ...
               'Position',[0.2  0.3  0.6  0.125+dm], ...
               'String','Display Results', ...
               'Tag','Pushbutton3');

if nargout > 0, fig = h0; end
