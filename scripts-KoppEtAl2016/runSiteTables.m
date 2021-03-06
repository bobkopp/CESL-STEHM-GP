% For each site, make a plot
%
% Last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, Wed Dec 16 12:11:48 EST 2015


subsite=find((wdataset.siteid>10000));
maxdistfrom=0.1;
maxerror=1000;
wtestlocs=testlocs{iii};
%dosites=1:size(wtestlocs.sites,1);

% 120006 New Jersey-Leeds Point
% 140007 North Carolina-Sand Point
% 110004 Massachusetts-Wood Island
% 100002 Louisiana-Lydia

dosites=find(ismember(wtestlocs.sites,[120006 140007 110004 100002]));
dosites=dosites(:)';

for kkk=dosites

       
    disp(wtestlocs.names{kkk});
    
    datsub=find(wtestlocs.reg==wtestlocs.sites(kkk,1));
    
    for timesteps=[100]
        [hp,hl,hl2,dGSL,dGSLsd,dGSLV,outtable,difftimes,diffreg]=PlotPSLOverlay(wtestlocs.X(datsub,3),wtestlocs.reg(datsub),wtestlocs.sites(kkk,1),f2s{iii}(datsub),V2s{iii}(datsub,datsub),[],testt(1),testt(end),0,timesteps,wtestlocs.names(kkk));


        fid=fopen(['siteplot-' labl '-' wtestlocs.names{kkk} '-' num2str(timesteps) 'y' '.tsv'],'w');
        fprintf(fid,outtable);
        fclose(fid);
        
        
    end    
end
