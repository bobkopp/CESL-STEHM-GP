% Last updated by  Bob Kopp, robert-dot-kopp-at-rutgers-dot-edu, Tue Feb 18 00:03:43 EST 2014

thinyrs=10;
minlen=50;

%%%%%%%%%%%

latNC1 =34.97; longNC1=-76.38; %Tump Point, NC
latNC2 = 35.89; longNC2=-75.64; %Sand Point, NC
latNJ1 = 39.085; longNJ1 = -74.811; % Cape May Courthouse, NJ
latNJ2 = 39.50; longNJ2 = -74.415; % Leeds Point, NJ

latNJ = mean([latNJ1 latNJ2]); longNJ = mean([longNJ1 longNJ2]);
latNC = mean([latNC1 latNC2]); longNC = mean([longNC1 longNC2]);
latFL = 30.6; longFL = -81.7;
latNS = 44.72; longNS = -63.23; % Chezzetcook, Nova Scotia


idNJ = 1e4;
idNC= 2e4;
idFL = 3e4;
idNS = 4e4;
idHolo = 2e5;

%%%%%%%%%%%%%%%

% First load tide gauge data

[TG,cvfuncTG,notbedrock]=ImportSmoothedTideGaugeDataSet(1,thinyrs,minlen); 
[TGNOCW]=ImportSmoothedTideGaugeDataSet(0,thinyrs,minlen);

TG.limiting=zeros(size(TG.Y));
TG.compactcorr=zeros(size(TG.Y));
TG.istg=ones(size(TG.Y));
TG.time1=TG.years; TG.time2=TG.years;

TGNOCW.limiting=zeros(size(TGNOCW.Y));
TGNOCW.compactcorr=zeros(size(TGNOCW.Y));
TGNOCW.istg=ones(size(TGNOCW.Y));
TGNOCW.time1=TGNOCW.years; TGNOCW.time2=TGNOCW.years;

% set up bedrockMask

notbedrock = union(notbedrock,[idNJ idNJ+1 idNJ+2 idNC idNC+1 idNC+2 (idHolo+(7:16)*1e3) idFL ]);
bedrocksiteids=setdiff(TG.siteid,notbedrock);

bedrockMask = @(r1,r2) [repmat(sparse(~ismember(r1,bedrocksiteids)),1,length(r2)).*(repmat(sparse(~ismember(r2,bedrocksiteids))',length(r1),1))]';

%%%%%%%%%%%%%%%%

% import proxy data

datid=[]; time1=[]; time2=[]; limiting=[]; Y=[]; dY = []; compactcorr = [];
istg = []; lat=[]; long=[];
siteid=[]; sitenames={};

% process geological data

% NJ


datNJ=importdata(fullfile(IFILES,'Horton2013NJ.csv'));
dat2 = datNJ;

sub = find(dat2.data(:,2) ~= 40); % exclude Little Egg
wdatid = ones(length(sub),1)*idNJ;
count=[1:length(wdatid)]';
wtime1 = 1950-dat2.data(sub,8) + count/1e5;
wtime2 = 1950-dat2.data(sub,9) + count/1e5;
wlimiting = dat2.data(sub,3);
wY = dat2.data(sub,12)*1000;
wdY = dat2.data(sub,13)/2*1000;
wcompactcorr = dat2.data(sub,11)*1000;
wlat = dat2.data(sub,5);
wlong = dat2.data(sub,4);

datid = [datid ; wdatid];
time1 = [time1 ; wtime1];
time2 = [time2 ; wtime2];
limiting = [limiting ; wlimiting];
Y = [Y ; wY];
dY = [dY ; wdY];
compactcorr = [compactcorr ; wcompactcorr];
istg = [istg ; 0 * wY];
lat = [lat ; wlat];
long = [long ; wlong];

siteid=[siteid ; idNJ];
sitenames={sitenames{:}, 'New Jersey (H13)'};

% NJ hi-res

datNJ2=importdata(fullfile(IFILES,'NJ_July2013.csv'));
dat2 = datNJ2;

wdatid=idNJ*ones(size(dat2.data(:,1)))+dat2.data(:,5);
count=[1:length(wdatid)]';
wtime1 = dat2.data(:,1) + dat2.data(:,2) + count/1e5;
wtime2 = dat2.data(:,1) - dat2.data(:,2) + count/1e5;
wY = dat2.data(:,3)*1000;
wdY = dat2.data(:,4)*1000;
wlimiting = 0*wY;
wcompactcorr = 0*wY*1000;
wlat = ones(size(wY)) * latNJ;
wlong = ones(size(wY)) * longNJ;

%  split out LP and CMCt

sub=find(wdatid == (idNJ+1));
wlat(sub) = latNJ1; wlong(sub)=longNJ1;
sub=find(wdatid == (idNJ+2));
wlat(sub) = latNJ2; wlong(sub)=longNJ2;

datid = [datid ; wdatid];
time1 = [time1 ; wtime1];
time2 = [time2 ; wtime2];
limiting = [limiting ; wlimiting];
Y = [Y ; wY];
dY = [dY ; wdY];
compactcorr = [compactcorr ; wcompactcorr];
istg = [istg ; 0 * wY];
lat = [lat ; wlat];
long = [long ; wlong];

siteid=[siteid ; idNJ+1 ; idNJ+2];
sitenames={sitenames{:}, 'Cape May', 'Leeds Point'};


% NC

datNC=importdata(fullfile(IFILES,'Kemp2011NCb.csv'));
dat2 = datNC;

wdatid=idNC*ones(size(dat2.data(:,1)))+dat2.data(:,1);
count=[1:length(wdatid)]';
wtime1 = dat2.data(:,2) + dat2.data(:,4) + count/1e5;
wtime2 = dat2.data(:,2) - dat2.data(:,4) + count/1e5;
wY = dat2.data(:,3)*1000;
wdY = dat2.data(:,5)*1000;
wlimiting = 0*wY;
wcompactcorr = 0*wY*1000;
wlat = ones(size(wY)) * latNC;
wlong = ones(size(wY)) * longNC;

%  split out Tump Point and Sand Point

sub=find(wdatid == idNC+1);
wlat(sub) = latNC1; wlong(sub)=longNC1;
sub=find(wdatid == idNC+2);
wlat(sub) = latNC2; wlong(sub)=longNC2;

datid = [datid ; wdatid];
time1 = [time1 ; wtime1];
time2 = [time2 ; wtime2];
limiting = [limiting ; wlimiting];
Y = [Y ; wY];
dY = [dY ; wdY];
compactcorr = [compactcorr ; wcompactcorr];
istg = [istg ; 0 * wY];
lat = [lat ; wlat];
long = [long ; wlong];

siteid=[siteid ; idNC+1 ; idNC+2];
sitenames={sitenames{:}, 'Tump Point', 'Sand Point'};


% FL

datFL=importdata(fullfile(IFILES,'NassauFL_July2013.csv'));
dat2 = datFL;

wdatid=idFL*ones(size(dat2.data(:,1)));
count=[1:length(wdatid)]';
wtime1 = dat2.data(:,1) + dat2.data(:,2) + count/1e5;
wtime2 = dat2.data(:,1) - dat2.data(:,2) + count/1e5;
wY = dat2.data(:,3)*1000;
wdY = dat2.data(:,4)*1000;
wlimiting = 0*wY;
wcompactcorr = 0*wY*1000;
wlat = ones(size(wY)) * latFL;
wlong = ones(size(wY)) * longFL;

datid = [datid ; wdatid];
time1 = [time1 ; wtime1];
time2 = [time2 ; wtime2];
limiting = [limiting ; wlimiting];
Y = [Y ; wY];
dY = [dY ; wdY];
compactcorr = [compactcorr ; wcompactcorr];
istg = [istg ; 0 * wY];
lat = [lat ; wlat];
long = [long ; wlong];

siteid=[siteid ; idFL];
sitenames={sitenames{:}, 'Nassau'};


% NS Gehrels et al. 2005

datNS=importdata(fullfile(IFILES,'Gehrels2005_NS.csv'));
dat2 = datNS;

wdatid=idNS*ones(size(dat2.data(:,1)));
count=[1:length(wdatid)]';
wtime1 = dat2.data(:,1) + dat2.data(:,2) + count/1e5;
wtime2 = dat2.data(:,1) - dat2.data(:,3) + count/1e5;
wY = dat2.data(:,4)*1000;
wdY = dat2.data(:,5)*1000;
wlimiting = 0*wY;
wcompactcorr = 0*wY*1000;
wlat = ones(size(wY)) * latNS;
wlong = ones(size(wY)) * longNS;

datid = [datid ; wdatid];
time1 = [time1 ; wtime1];
time2 = [time2 ; wtime2];
limiting = [limiting ; wlimiting];
Y = [Y ; wY];
dY = [dY ; wdY];
compactcorr = [compactcorr ; wcompactcorr];
istg = [istg ; 0 * wY];
lat = [lat ; wlat];
long = [long ; wlong];

siteid=[siteid ; idNS];
sitenames={sitenames{:}, 'Chezzetcook'};


% Engelhart & Horton database

datHolo=importdata(fullfile(IFILES,'Engelhart_Horton_2012.csv'));
HoloRegions=[1:7 9:16];
for curreg=1:length(HoloRegions)
	sub=find((datHolo.data(:,1)==HoloRegions(curreg)).*(datHolo.data(:,2)==0));

	count=[1:length(sub)]';
	wdatid = ones(length(sub),1)*(idHolo+HoloRegions(curreg)*1e3);
	wtime1=1950-datHolo.data(sub,8) + count/1e5;
	wtime2=1950-datHolo.data(sub,9) + count/1e5;
	wlimiting=datHolo.data(sub,2);
	wY=datHolo.data(sub,10)*1000;
	wdY=datHolo.data(sub,11)*1000;
	wlat=datHolo.data(sub,3);
	wlong=-datHolo.data(sub,4);
	wcompactcorr = wY*.1;
	
	datid = [datid ; wdatid];
	time1 = [time1 ; wtime1];
	time2 = [time2 ; wtime2];
	limiting = [limiting ; wlimiting];
	Y = [Y ; wY];
	dY = [dY ; wdY];
	compactcorr = [compactcorr ; wcompactcorr];
	istg = [istg ; 0 * wY];
	lat = [lat ; wlat];
	long = [long ; wlong];
end
siteid=[siteid ; [idHolo+HoloRegions*1e3]'];
for i=1:length(HoloRegions)
    sitenames={sitenames{:}, ['EH12_' num2str(HoloRegions(i))]};
end

PX.datid=datid;
PX.time1=time1;
PX.time2=time2;
PX.limiting=limiting;
PX.Y=Y;
PX.dY = dY;
PX.compactcorr=compactcorr;
PX.istg = istg;
PX.lat=lat;
PX.long=long;
PX.Ycv=sparse(diag(dY.^2));
PX.siteid=siteid;
PX.sitenames=sitenames;

%%%%%% load GIA model

giamodel.gia=ncread(fullfile(IFILES,'dsea250.1grid.ICE5Gv1.3_VM2_L90_2012.nc'),'Dsea_250');
giamodel.lat=ncread(fullfile(IFILES,'dsea250.1grid.ICE5Gv1.3_VM2_L90_2012.nc'),'Lat');
giamodel.long=ncread(fullfile(IFILES,'dsea250.1grid.ICE5Gv1.3_VM2_L90_2012.nc'),'Lon');

ICE5Ggia=giamodel.gia;
ICE5Glat=giamodel.lat;
ICE5Glon=giamodel.long;
sub=find(ICE5Glon>180); ICE5Glon(sub)=ICE5Glon(sub)-360;
[ICE5Glon,si]=sort(ICE5Glon); ICE5Ggia=ICE5Ggia(si,:);

% fingerprint

[GISfp,GISfplong,GISfplat]=readFingerprintInd('gis',IFILES);
sub=find(GISfplong>180); GISfplong(sub)=GISfplong(sub)-360;
[GISfplong,si]=sort(GISfplong); GISfp=GISfp(:,si);
GISfp=GISfp*1000;

%%%%%%

clear datasets;
datasets{1}=MergeDataStructures(TG,PX);
datasets{2}=MergeDataStructures(TGNOCW,PX);
datasets{3}=PX;
datasets{4}=TG;
datasets{5}=TGNOCW;

datasets{1}.label='TG+GSL+PX';
datasets{2}.label='TG+PX';
datasets{3}.label='PX';
datasets{4}.label='TG+GSL';
datasets{5}.label='TG';


for ii=1:length(datasets)
    t1=datasets{ii}.time1; t2=datasets{ii}.time2;
    datasets{ii}.meantime=mean([t1 t2],2);
    datasets{ii}.dt = abs(t1-t2)/4;
    datasets{ii}.dY0=datasets{ii}.dY;
    datasets{ii}.Ycv0 = datasets{ii}.Ycv;
    datasets{ii}.compactcorr=sparse(datasets{ii}.compactcorr);
    datasets{ii}.bedrockMask=bedrockMask;
    datasets{ii}.bedmsk=bedrockMask(datasets{ii}.datid,datasets{ii}.datid);


    datasets{ii}.obsGISfp = interp2(GISfplong,GISfplat,GISfp,datasets{ii}.long,datasets{ii}.lat,'linear');
    datasets{ii}.obsGISfp(find(datasets{ii}.lat>100))=1;
    
    % subtract GIA model
    
    ider = datasets{ii}.lat*1e5+datasets{ii}.long;
    [ideru,iderui]=unique(ider);
    
%    [regionsu,regionsusi]=unique(datasets{ii}.datid);
%    sitecoords=[datasets{ii}.lat(regionsusi) datasets{ii}.long(regionsusi)];
%    GIAproju=zeros(size(regionsu));
%    GIAproj=zeros(size(datasets{ii}.Y));
    GIAproju=zeros(size(ideru));
    GIAproj=zeros(size(datasets{ii}.Y));

    for jj=1:length(ideru)
        if datasets{ii}.datid(iderui(jj))>0
            GIAproju(jj)=interp2(ICE5Glat,ICE5Glon,ICE5Ggia,datasets{ii}.lat(iderui(jj)),datasets{ii}.long(iderui(jj)));
            sub=find(ider==ideru(jj));
            GIAproj(sub)=GIAproju(jj).*(datasets{ii}.meantime(sub)-refyear);
        end
    end
    for jj=1:length(datasets{ii}.siteid)
        datasets{ii}.siteGIA(jj)=0;
        sub=find(datasets{ii}.datid == datasets{ii}.siteid(jj));
        if length(sub)>0
            datasets{ii}.siteGIA(jj) = GIAproj(sub(1));
        end
    end
    datasets{ii}.GIAproj=GIAproj;
    datasets{ii}.Y0=datasets{ii}.Y;
    %datasets{ii}.Y=datasets{ii}.Y0-GIAproj;
end



% indices

datNAO = importdata(fullfile(IFILES,'nao-trouet2009.txt'));
	
	%% comparison to temperature records
	impt=importdata(fullfile(IFILES,'Marcott2013_global.txt'));
	Marcottgl_yr = 1950-impt.data(:,1);
	Marcottgl_T = impt.data(:,2);
	Marcottgl_dT = impt.data(:,3);

		impt=importdata(fullfile(IFILES,'Marcott2013_regional.txt'));
	Marcottr_yr=1950-impt.data(:,1);
	Marcott_Next_T=impt.data(:,2);
	Marcott_Next_dT=impt.data(:,3);
	Marcott_eq_T=impt.data(:,4);
	Marcott_eq_dT=impt.data(:,5);
	Marcott_Sext_T=impt.data(:,6);
	Marcott_Sext_dT=impt.data(:,7);

	impt=importdata(fullfile(IFILES,'HadCRUT4-gl.dat'));
	HadCRUT_yr=impt(1:2:end,1);
	HadCRUT_T=impt(1:2:end,end);

	Mann_T=importdata(fullfile(IFILES,'glglfulihad_smxx.txt'));
	Mann_yr = [[1:length(Mann_T)]-1]';



