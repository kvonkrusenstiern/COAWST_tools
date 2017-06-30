%% csv2ts.m
% author : kvonkrusenstiern
% date   : 30 june 2017
% update : 30 june 2017
% to do  : make so ramp can handle greater than 1 day
%
% This code takes a timeseries in the a file (time, value), and creates a
% .mat file. Purpose of this code is to generate data to force
% boundary condtions in ROMS/COAWST as a time-series. It was made
% specifically for sea surface elevations taken from NOAA buoys. With
% create_roms_bdy.m and pop_roms_bdy.m, a time-series forcing netcdf file
% is created.
%
%
%% user inputs
% (1) SET FILE INFORMATION
% csv info
ds          = 'C:\Users\kvonkrusenstiern\field_work\hampton2016\forcing\fort_point\aug2011_july2012.csv';   %name of csv dataset
delimiter   = ',';
formatSpec  = '%s%s%s%[^\n\r]';
% path where .mat file will be placed
outpath  = 'C:\Users\kvonkrusenstiern\field_work\hampton2016\forcing\fort_point\';
outname  = ['fortpoint_aug2011july2012.mat'];

% (3) SET LENGTH OF TIME-SERIES
sdate    = datenum(2011,09,19,0,0,0);
edate    = datenum(2011,10,19,0,0,0);
dt       = 360; %in seconds

%% upload csv data
disp('------ csv2ts started ------');
disp(['## uploading user input for ', num2str(edate-sdate) ' days'])

fid = fopen(ds,'r');
dataArray = textscan(fid,formatSpec,'Delimiter',',','ReturnOnError',false);
fclose(fid);

%set variables
datetime = dataArray{1}; %timing
WL = dataArray{2};       %waterlevel

%get rid of header
datetime = datetime(2:end);
datenumber = datenum(datetime);
WL = WL(2:end);
WL = cellfun(@str2num,WL);

%set time-series 
istart = find(datenumber == sdate);
iend   = find(datenumber == edate);
WLdata = WL(istart:iend);
Tdata  = ((0:1:(iend-istart))*dt)';
%% plot time-series

image = input('Plot time-series for set dates? 0-->no, 1-->yes ');
if image == 1
    fig1 = figure;
    plot(Tdata./86400,WLdata,'k');
    title(['Time-Series ' num2str(edate-sdate) 'days']);
    xlabel('time [days]');
    ylabel('SSH [meters]');
end

ramp = input('Do you want to add ramp to time series? 0--> no, 1--> yes ');
if ramp == 1
    r_length = input('Enter # of days of ramp; ie--> 4 ');
    disp(['## adding ramp to time series for ', num2str(r_length), ' days']);
    ramp_time = r_length*60*60*24;
    ii = find(Tdata(:,1) == ramp_time);
    
    %set hyperbolic Tangent for user specified days
    ltan = length(Tdata);
    tang = ones(ltan,1);
    tang(1:ii) = tanh(0:1/80:3);
    WLramp = WLdata.* tang;
    
    image = input('Plot time-series w/ ramp? 0 --> now; 1 --> yes ');
    if image == 1;
        fig2 = figure;
        plot(Tdata/(86400), WLramp , 'r');
        hold on
        plot(Tdata/86400,WLdata,'k');
        title(['Time-Series w/ ramp' num2str(edate-sdate) 'days']);
        xlabel('time [days]');
        ylabel('SSH [meters]');
    end 
end

%%
%save data
WLdata = WLramp;
o_name = [outpath outname];
disp(['## saving data to: ' outname]);
save(o_name,'Tdata','WLdata');
disp('------ csv2ts finished ------');

    
   
    