% For each site, make a plot
%
% Last updated by Robert Kopp, robert-dot-kopp-at-rutgers-dot-edu, Sun Dec 06 09:14:43 EST 2015

subsite=find((wdataset.siteid>10000));
maxdistfrom=0.1;
maxerror=1000;
wtestlocs=testlocs{iii};
for kkk=1:size(wtestlocs.sites,1)
    
    disp(wtestlocs.names{kkk});
    
    clf;
    subplot(2,1,1);
    
    sub=find(wtestlocs.reg==wtestlocs.sites(kkk,1));
    if wtestlocs.sites(kkk,2)<360
        distfrom=dDist(wtestlocs.sites(kkk,2:3),[wdataset.lat wdataset.long]);
        subD=find(distfrom<maxdistfrom);
    else
        subD=find((wdataset.lat==wtestlocs.sites(kkk,2)).*(wdataset.lat==wtestlocs.sites(kkk,3)));
    end
    subD=intersect(subD,find(wdataset.dY<maxerror));
    

    plotdat.x=wtestlocs.X(sub,3);
    plotdat.y=f2s{iii}(sub);
    plotdat.dy=sd2s{iii}(sub)*2;
    
    PlotWithShadedErrors(plotdat,[0 0 0]);
    for uuu=subD(:)'
        plot([wdataset.time1(uuu) wdataset.time2(uuu)],wdataset.Y0(uuu)-2*wdataset.dY(uuu)*[1 1],'r'); hold on;
        plot([wdataset.time1(uuu) wdataset.time2(uuu)],wdataset.Y0(uuu)+2*wdataset.dY(uuu)*[1 1],'r');
        plot([wdataset.time1(uuu) wdataset.time1(uuu)],wdataset.Y0(uuu)+2*wdataset.dY(uuu)*[-1 1],'r');
        plot([wdataset.time2(uuu) wdataset.time2(uuu)],wdataset.Y0(uuu)+2*wdataset.dY(uuu)*[-1 1],'r');
    end
    plot(plotdat.x,plotdat.y,'k','linew',2);
    plot(plotdat.x,plotdat.y-plotdat.dy,'k--','linew',1);
    plot(plotdat.x,plotdat.y+plotdat.dy,'k--','linew',1);
    
    title([wtestlocs.names{kkk} ' (' num2str(wtestlocs.sites(kkk,1)) ')']);
    xl=get(gca,'xlim');
    xl(2)=2010; xl(1)=max([-500 xl(1)]);
    xlim(xl);
    ylabel('Sea level (mm)');
    xlabel('Year (CE)');
    pdfwrite(['siteplot-' wtestlocs.names{kkk}]);
    
end
