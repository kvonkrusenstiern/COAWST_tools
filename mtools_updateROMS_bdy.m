%% mtools_updateROMSbdy.m
% author : kvonkrusenstiern
% date   : 5 July 2017
% update : 5 July 2017
% to do  : 
%
%
% This routine populates an empty ocean_bdy.nc file with desired
% time-series. Due to the nature of individual runs, script will likely
% need to be adapted to user needs. This script is more of a framework to
% work with. Script is compatible with mtools_createROMSbdy.m
%
%

%%
%netcdf files
fname    = 'hampton_bdy_TEST.nc';
grdname  = 'C:\Users\kvonkrusenstiern\field_work\hampton2016\gridding\run05\run05G_grd.nc';

%vert. layers
N        = 8;

%zeta in ocean.in
zeta     = 24;

%input boundary data
load('C:\Users\kvonkrusenstiern\field_work\hampton2016\forcing\fort_point\run07_zeta.mat');
%% get grid info
lon_rho = ncread(grdname,'lon_rho');
[LP,MP] = size(lon_rho);
L       = LP-1;
Lm      = L-1;
M       = MP-1;
Mm      = M-1;
L       = Lm+1;
M       = Mm+1;
xpsi    = L;
xrho    = LP;
xu      = L;
xv      = LP;
epsi    = M;
erho    = MP;
eu      = MP;
ev      = M;
s       = N;
%% set matrices for ncwrite

time = run30days_sept192011(:,1)';

%check to make sure that length of time-series matches length of ocean_time
%variable

bdy_time = ncread(fname,'ocean_time');
assert(numel(time) == bdy_time,'ocean_time and length of time-series not equal');

zeta_east = zeros(MP,numel(time));
ubar_east = zeros(MP,numel(time));
vbar_east = zeros(M,numel(time));
u_east    = zeros(MP,N,numel(time));
v_east    = zeros(M,N,numel(time));
temp_east = zeros(MP,N,numel(time));
salt_east = zeros(MP,N,numel(time));

for ii = 1:MP
    zeta_east(ii,:) = WLramp-24;
    ubar_east(ii,:) = zeros(1,numel(time));
end

for  ii = 1:M
    vbar_east(ii,:) = zeros(1,numel(time));
end

for ii = 1: MP
    for jj = 1:N;
        u_east(ii,jj,:)    = zeros(1,numel(time));
        temp_east(ii,jj,:) = ones(1,numel(time))*17;
        salt_east(ii,jj,:) = ones(1,numel(time))*32;
    end
end

for ii = 1: M
    for jj = 1:N;
        v_east(ii,jj,:) = zeros(1,numel(time));
    end
end

%% write to matrix

ncwrite(fname,'zeta_time',time);
ncwrite(fname,'v2d_time',time);
ncwrite(fname,'v3d_time',time);
ncwrite(fname,'salt_time',time);
ncwrite(fname,'temp_time',time);

ncwrite(fname,'zeta_east',zeta_east);
ncwrite(fname,'ubar_east',ubar_east);
ncwrite(fname,'vbar_east',vbar_east);
ncwrite(fname,'u_east',u_east);
ncwrite(fname,'v_east',v_east);
ncwrite(fname,'temp_east',temp_east);
ncwrite(fname,'salt_east',salt_east);
%%
netcdf.close(fname)
disp(['## wrote variables to: ' fname]);
