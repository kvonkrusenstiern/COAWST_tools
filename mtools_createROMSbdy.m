%% create_APP_bdy.m
% author  : kvonkrusenstiern
% date    : 5 July 2017
% update  : 5 July 2017
% to-do   : 
%
% this routine creates a shell for boundary file for a ROMS model based on a
% user-defined grid, user defined open boundaries and user-defined length of time.
%
% code is written by Kate von Krusenstiern, June 2017, and is based off of
% coawst boundary, initial, and climatology scripts provided by COAWST.
%
% NEEDS NCTOOLBOX TO RUN!!!
%
% Authors of COAWST scripts includes:
% Mingkui Li, May 2008
% Brandy Armstrong, March 2009
% jcwarner, April 20, 2009
% Ilgar Safak, June 2012 

%% ------- START OF USER INPUT --------
disp(' ## Grabbing User Input...')

% (1) enter name of output boundary files
fn         = 'hampton_bdy_run07e_v3.nc';

% (2) enter path and name of the ROMS grid (grdname)
grdname    = 'C:\Users\kvonkrusenstiern\field_work\hampton2016\gridding\run05\run05G_grd.nc';
%eval(['gridname=''',grdname,''';']);

% (3) enter length of boundary forcing time-series
ocean_time = 7201;

% (4) enter number of vertical layers
N          = 8;

% (5) decide open boundaries. 0 = close, 1 = open
north      = 0;
east       = 1;
south      = 0;
west       = 0;

%(5) Enter in information forcing boundaries. length must match ocean_time
% leave arrays empty if not used.

% if north == 1;
%     zeta_north = [];
%     ubar_north = [];
%     vbar_north = [];
%     u_north    = [];
%     v_north    = [];
%     temp_north = [];
%     salt_north = [];
% end
% 
% if east == 1;
%     zeta_east = ones(1,ocean_time)';
%     ubar_east = ones(1,ocean_time)';
%     vbar_east = ones(1,ocean_time)';
%     u_east    = ones(1,ocean_time)';
%     v_east    = ones(1,ocean_time)';
%     temp_east = ones(1,ocean_time)';
%     salt_east = ones(1,ocean_time)';
% end
% 
% if south == 1;
%     zeta_south = [];
%     ubar_south = [];
%     vbar_south = [];
%     u_south    = [];
%     v_south    = [];
%     temp_south = [];
%     salt_south = [];
% end
% 
% if west == 1;
%     zeta_west = [];
%     ubar_west = [];
%     vbar_west = [];
%     u_west    = [];
%     v_west    = [];
%     temp_west = [];
%     salt_west = [];
% end

%% GET GRID INFO

disp(' ## Reading Grid Info...')

lon_rho = ncread(grdname,'lon_rho');
[LP,MP]=size(lon_rho);
L=LP-1;
Lm=L-1;
M=MP-1;
Mm=M-1;
L  = Lm+1;
M  = Mm+1;
xpsi  = L;
xrho  = LP;
xu    = L;
xv    = LP;
epsi = M;
erho = MP;
eu   = MP;
ev   = M;
s    = N;

  %% create boundary file
 disp(['------------ writing ',fn,' ------------']);
  
nc_bndry=netcdf.create(fn,'clobber');
if isempty(nc_bndry), return, end

disp(' ## Defining Global Attributes...')
netcdf.putAtt(nc_bndry,netcdf.getConstant('NC_GLOBAL'),'history', ['Created by updatclim on ' datestr(now)]);
netcdf.putAtt(nc_bndry,netcdf.getConstant('NC_GLOBAL'),'type', 'BOUNDARY FORCING FILE - includes ramp');
netcdf.putAtt(nc_bndry,netcdf.getConstant('NC_GLOBAL'),'source', 'created with create_app_bdy.m');


%% Dimensions:

disp(' ## Defining Dimensions From Given Grid File...')
 
psidimID = netcdf.defDim(nc_bndry,'xpsi',L);
xrhodimID = netcdf.defDim(nc_bndry,'xrho',LP);
xudimID = netcdf.defDim(nc_bndry,'xu',L);
xvdimID = netcdf.defDim(nc_bndry,'xv',LP);

epsidimID = netcdf.defDim(nc_bndry,'epsi',M);
erhodimID = netcdf.defDim(nc_bndry,'erho',MP);
eudimID = netcdf.defDim(nc_bndry,'eu',MP);
evdimID = netcdf.defDim(nc_bndry,'ev',M);
s_rhodimID = netcdf.defDim(nc_bndry,'s_rho',s);

zttdimID = netcdf.defDim(nc_bndry,'zeta_time',ocean_time);
v2tdimID = netcdf.defDim(nc_bndry,'v2d_time',ocean_time);
v3tdimID = netcdf.defDim(nc_bndry,'v3d_time',ocean_time);
sltdimID = netcdf.defDim(nc_bndry,'salt_time',ocean_time);
tptdimID = netcdf.defDim(nc_bndry,'temp_time',ocean_time);

%% Variables and attributes:
disp(' ## Defining Dimensions, Variables, and Attributes...')
 
ztID = netcdf.defVar(nc_bndry,'zeta_time','double',zttdimID);
netcdf.putAtt(nc_bndry,ztID,'long_name','zeta_time');
netcdf.putAtt(nc_bndry,ztID,'units','second');
netcdf.putAtt(nc_bndry,ztID,'field','zeta_time, scalar, series');

v2ID = netcdf.defVar(nc_bndry,'v2d_time','double',v2tdimID);
netcdf.putAtt(nc_bndry,v2ID,'long_name','v2d_time');
netcdf.putAtt(nc_bndry,v2ID,'units','days');
netcdf.putAtt(nc_bndry,v2ID,'field','v2d_time, scalar, series');

v3ID = netcdf.defVar(nc_bndry,'v3d_time','double',v3tdimID);
netcdf.putAtt(nc_bndry,v3ID,'long_name','v3d_time');
netcdf.putAtt(nc_bndry,v3ID,'units','days');
netcdf.putAtt(nc_bndry,v3ID,'field','v3d_time, scalar, series');

slID = netcdf.defVar(nc_bndry,'salt_time','double',sltdimID);
netcdf.putAtt(nc_bndry,slID,'long_name','salt_time');
netcdf.putAtt(nc_bndry,slID,'units','days');
netcdf.putAtt(nc_bndry,slID,'field','salt_time, scalar, series');

tpID = netcdf.defVar(nc_bndry,'temp_time','double',tptdimID);
netcdf.putAtt(nc_bndry,tpID,'long_name','temp_time');
netcdf.putAtt(nc_bndry,tpID,'units','days');
netcdf.putAtt(nc_bndry,tpID,'field','temp_time, scalar, series');

%% creating fields for indicated boundaries
disp(' ## Set Boundary Variables...')
if north == 1
    zetnID = netcdf.defVar(nc_bndry,'zeta_north','double',[xudimID zttdimID]);
    netcdf.putAtt(nc_bndry,zetnID,'long_name','free-surface northern boundary condition');
    netcdf.putAtt(nc_bndry,zetnID,'units','meter');
    netcdf.putAtt(nc_bndry,zetnID,'field','zeta_north, scalar, series');
    
    ubnID = netcdf.defVar(nc_bndry,'ubar_north','float',[xudimID v2tdimID]);
    netcdf.putAtt(nc_bndry,ubnID,'long_name','2D u-momentum nothern boundary condition');
    netcdf.putAtt(nc_bndry,ubnID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,ubnID,'field','ubar_north, scalar, series');

    vbnID = netcdf.defVar(nc_bndry,'vbar_north','float',[xvdimID v2tdimID]);
    netcdf.putAtt(nc_bndry,vbnID,'long_name','2D v-momentum nothern boundary condition');
    netcdf.putAtt(nc_bndry,vbnID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,vbnID,'field','vbar_north, scalar, series');

    unID = netcdf.defVar(nc_bndry,'u_north','float',[xudimID s_rhodimID v3tdimID]);
    netcdf.putAtt(nc_bndry,unID,'long_name','3D u-momentum nothern boundary condition');
    netcdf.putAtt(nc_bndry,unID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,unID,'field','u_north, scalar, series');

    vnID = netcdf.defVar(nc_bndry,'v_north','float',[xvdimID s_rhodimID v3tdimID]);
    netcdf.putAtt(nc_bndry,vnID,'long_name','3D v-momentum nothern boundary condition');
    netcdf.putAtt(nc_bndry,vnID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,vnID,'field','v_north, scalar, series');

    tmpnID = netcdf.defVar(nc_bndry,'temp_north','float',[xrhodimID s_rhodimID tptdimID]);
    netcdf.putAtt(nc_bndry,tmpnID,'long_name','3D temperature nothern boundary condition');
    netcdf.putAtt(nc_bndry,tmpnID,'units','C');
    netcdf.putAtt(nc_bndry,tmpnID,'field','temp_north, scalar, series');

    salnID = netcdf.defVar(nc_bndry,'salt_north','float',[xrhodimID s_rhodimID sltdimID]);
    netcdf.putAtt(nc_bndry,salnID,'long_name','3D salinity nothern boundary condition');
    netcdf.putAtt(nc_bndry,salnID,'units','psu');
    netcdf.putAtt(nc_bndry,salnID,'field','salt_north, scalar, series');
end

if east == 1
    zeteID = netcdf.defVar(nc_bndry,'zeta_east','double',[erhodimID zttdimID]);
    netcdf.putAtt(nc_bndry,zeteID,'long_name','free-surface eastern boundary condition');
    netcdf.putAtt(nc_bndry,zeteID,'units','meter');
    netcdf.putAtt(nc_bndry,zeteID,'field','zeta_east, scalar, series');
    
    ubeID = netcdf.defVar(nc_bndry,'ubar_east','float',[eudimID v2tdimID]);
    netcdf.putAtt(nc_bndry,ubeID,'long_name','2D u-momentum eastern boundary condition');
    netcdf.putAtt(nc_bndry,ubeID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,ubeID,'field','ubar_east, scalar, series');

    vbeID = netcdf.defVar(nc_bndry,'vbar_east','float',[evdimID v2tdimID]);
    netcdf.putAtt(nc_bndry,vbeID,'long_name','2D v-momentum eastern boundary condition');
    netcdf.putAtt(nc_bndry,vbeID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,vbeID,'field','vbar_east, scalar, series');

    ueID = netcdf.defVar(nc_bndry,'u_east','float',[eudimID s_rhodimID v3tdimID]);
    netcdf.putAtt(nc_bndry,ueID,'long_name','3D u-momentum eastern boundary condition');
    netcdf.putAtt(nc_bndry,ueID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,ueID,'field','u_east, scalar, series');

    veID = netcdf.defVar(nc_bndry,'v_east','float',[evdimID s_rhodimID v3tdimID]);
    netcdf.putAtt(nc_bndry,veID,'long_name','3D v-momentum eastern boundary condition');
    netcdf.putAtt(nc_bndry,veID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,veID,'field','v_east, scalar, series');

    tmpeID = netcdf.defVar(nc_bndry,'temp_east','float',[erhodimID s_rhodimID tptdimID]);
    netcdf.putAtt(nc_bndry,tmpeID,'long_name','3D temperature eastern boundary condition');
    netcdf.putAtt(nc_bndry,tmpeID,'units','C');
    netcdf.putAtt(nc_bndry,tmpeID,'field','temp_east, scalar, series');

    saleID = netcdf.defVar(nc_bndry,'salt_east','float',[erhodimID s_rhodimID sltdimID]);
    netcdf.putAtt(nc_bndry,saleID,'long_name','3D salinity eastern boundary condition');
    netcdf.putAtt(nc_bndry,saleID,'units','psu');
    netcdf.putAtt(nc_bndry,saleID,'field','salt_east, scalar, series');
end

if south == 1
    zetsID = netcdf.defVar(nc_bndry,'zeta_south','double',[xudimID zttdimID]);
    netcdf.putAtt(nc_bndry,zetsID,'long_name','free-surface southern boundary condition');
    netcdf.putAtt(nc_bndry,zetsID,'units','meter');
    netcdf.putAtt(nc_bndry,zetsID,'field','zeta_south, scalar, series');
    
    ubsID = netcdf.defVar(nc_bndry,'ubar_south','float',[xudimID v2tdimID]);
    netcdf.putAtt(nc_bndry,ubsID,'long_name','2D u-momentum southern boundary condition');
    netcdf.putAtt(nc_bndry,ubsID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,ubsID,'field','ubar_south, scalar, series');

    vbsID = netcdf.defVar(nc_bndry,'vbar_south','float',[xvdimID v2tdimID]);
    netcdf.putAtt(nc_bndry,vbsID,'long_name','2D v-momentum southern boundary condition');
    netcdf.putAtt(nc_bndry,vbsID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,vbsID,'field','vbar_south, scalar, series');

    usID = netcdf.defVar(nc_bndry,'u_south','float',[xudimID s_rhodimID v3tdimID]);
    netcdf.putAtt(nc_bndry,usID,'long_name','3D u-momentum southern boundary condition');
    netcdf.putAtt(nc_bndry,usID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,usID,'field','u_south, scalar, series');

    vsID = netcdf.defVar(nc_bndry,'v_south','float',[xvdimID s_rhodimID v3tdimID]);
    netcdf.putAtt(nc_bndry,vsID,'long_name','3D v-momentum southern boundary condition');
    netcdf.putAtt(nc_bndry,vsID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,vsID,'field','v_south, scalar, series');

    tmpsID = netcdf.defVar(nc_bndry,'temp_south','float',[xrhodimID s_rhodimID tptdimID]);
    netcdf.putAtt(nc_bndry,tmpsID,'long_name','3D temperature southern boundary condition');
    netcdf.putAtt(nc_bndry,tmpsID,'units','C');
    netcdf.putAtt(nc_bndry,tmpsID,'field','temp_south, scalar, series');

    salsID = netcdf.defVar(nc_bndry,'salt_south','float',[xrhodimID s_rhodimID sltdimID]);
    netcdf.putAtt(nc_bndry,salsID,'long_name','3D salinity southern boundary condition');
    netcdf.putAtt(nc_bndry,salsID,'units','psu');
    netcdf.putAtt(nc_bndry,salsID,'field','salt_south, scalar, series');
end

if west == 1
    zetwID = netcdf.defVar(nc_bndry,'zeta_west','double',[erhodimID zttdimID]);
    netcdf.putAtt(nc_bndry,zetwID,'long_name','free-surface western boundary condition');
    netcdf.putAtt(nc_bndry,zetwID,'units','meter');
    netcdf.putAtt(nc_bndry,zetwID,'field','zeta_west, scalar, series');
    
    ubeID = netcdf.defVar(nc_bndry,'ubar_west','float',[eudimID v2tdimID]);
    netcdf.putAtt(nc_bndry,ubeID,'long_name','2D u-momentum western boundary condition');
    netcdf.putAtt(nc_bndry,ubeID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,ubeID,'field','ubar_west, scalar, series');

    vbeID = netcdf.defVar(nc_bndry,'vbar_west','float',[evdimID v2tdimID]);
    netcdf.putAtt(nc_bndry,vbeID,'long_name','2D v-momentum western boundary condition');
    netcdf.putAtt(nc_bndry,vbeID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,vbeID,'field','vbar_west, scalar, series');

    ueID = netcdf.defVar(nc_bndry,'u_west','float',[eudimID s_rhodimID v3tdimID]);
    netcdf.putAtt(nc_bndry,ueID,'long_name','3D u-momentum western boundary condition');
    netcdf.putAtt(nc_bndry,ueID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,ueID,'field','u_west, scalar, series');

    veID = netcdf.defVar(nc_bndry,'v_west','float',[evdimID s_rhodimID v3tdimID]);
    netcdf.putAtt(nc_bndry,veID,'long_name','3D v-momentum western boundary condition');
    netcdf.putAtt(nc_bndry,veID,'units','meter second-1');
    netcdf.putAtt(nc_bndry,veID,'field','v_west, scalar, series');

    tmpeID = netcdf.defVar(nc_bndry,'temp_west','float',[erhodimID s_rhodimID tptdimID]);
    netcdf.putAtt(nc_bndry,tmpeID,'long_name','3D temperature western boundary condition');
    netcdf.putAtt(nc_bndry,tmpeID,'units','C');
    netcdf.putAtt(nc_bndry,tmpeID,'field','temp_west, scalar, series');

    saleID = netcdf.defVar(nc_bndry,'salt_west','float',[erhodimID s_rhodimID sltdimID]);
    netcdf.putAtt(nc_bndry,saleID,'long_name','3D salinity western boundary condition');
    netcdf.putAtt(nc_bndry,saleID,'units','psu');
    netcdf.putAtt(nc_bndry,saleID,'field','salt_west, scalar, series');
end
%% close file
netcdf.close(nc_bndry)
 disp(['------------ wrote ',fn,' ------------']);
%%


