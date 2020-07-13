% StiPstnNo=14
% VesselNo=1
% Rec=1:7;
% FlowMax=max(mean((cat(2,MdlPrp.FlwVelDia{StiPstnNo,VesselNo,Rec,1})),2));
% DiaMax=max(mean((cat(2,MdlPrp.FlwVelDia{StiPstnNo,VesselNo,Rec,3})),2));
% Maxes=max(cat(2,MdlPrp.FlwVelDia{StiPstnNo,VesselNo,Rec,1:3}),1);
%
% figure
% plot(mean((cat(2,MdlPrp.FlwVelDia{StiPstnNo,VesselNo,Rec,1})),2)/FlowMax);
% hold on ;plot(mean((cat(2,MdlPrp.FlwVelDia{StiPstnNo,VesselNo,Rec,3})),2)/DiaMax,'r');
% legend('flow','diameter')
% title (['S' num2str(StiPstnNo) 'V' num2str(VesselNo)])

%% plot ensemble average curve for Rows
close all
SavePath='./figures';
FlwVelDiaNo=3
FVD={'Flow','Vel','Dia'}
for  FlwVelDiaNo=1:3
    
    for VesselNo=1
        for i=1:5
            StiPstnNoArray=i:5:25
            figure
            for StiPstnNo=StiPstnNoArray
                hold on;
                plot(MdlPrp.mnt,MdlPrp.mnFlwVelDia{StiPstnNo,VesselNo,FlwVelDiaNo},'LineWidth',2)
            end
            LegendMatrix=NumMat2LegendMatrix(StiPstnNoArray,'StiPstnNo','');
            legend (LegendMatrix)
            title(['V' num2str(VesselNo)])
            ttl_fig=[[ FVD{FlwVelDiaNo} '_Compare_The_Row_of_S'] num2str(i) ['_V_'] num2str(VesselNo) ];
            
%             saveas(gcf,[SavePath '\' ttl_fig '.png'])
        end
    end
end
%%  For Column
close all
SavePath='./figures';

FVD={'Flow','Vel','Dia'}
for  FlwVelDiaNo=1:3
    for VesselNo=1:4
        for i=1:5
            StiPstnNoArray=(i-1)*5+1:(i)*5
            figure
            for StiPstnNo=StiPstnNoArray
                hold on;
                plot(MdlPrp.mnt,MdlPrp.mnFlwVelDia{StiPstnNo,VesselNo,FlwVelDiaNo},'LineWidth',2)
            end
            LegendMatrix=NumMat2LegendMatrix(StiPstnNoArray,'StiPstnNo','');
            legend (LegendMatrix)
            title(['V' num2str(VesselNo)])
            ttl_fig=[[FVD{FlwVelDiaNo} '_Compare_No_'] num2str(i) ['_Column_V_'] num2str(VesselNo) ];
            
            saveas(gcf,[SavePath '\' ttl_fig '.png'])
        end
    end
end
%%
%
% for StiLcCntr=1:size(MdlPrp.FlwVelDia,1)
%     for VsslCntr=1:size(MdlPrp.FlwVelDia,2)
%         for FlwVelDiaCntr=1:size(MdlPrp.FlwVelDia,4)
%             MdlPrp.mnFlwVelDia{StiLcCntr,VsslCntr,FlwVelDiaCntr}=mean((cat(2,MdlPrp.FlwVelDia{StiPstnNo,VesselNo,:,FlwVelDiaCntr})),2);
%         end
%     end
% end
%%
close all
SavePath='./figures';

FVD={'Flow','Vel','Dia'}
for  FlwVelDiaNo=1:3
    for VesselNo=1:4
        for i=1:5
            StiPstnNoArray=(i-1)*5+1:(i)*5
            figure
            for StiPstnNo=StiPstnNoArray
                hold on;
                plot(MdlPrp.mnt,MdlPrp.mnFlwVelDia{StiPstnNo,VesselNo,FlwVelDiaNo},'LineWidth',2)
            end
            LegendMatrix=NumMat2LegendMatrix(StiPstnNoArray,'StiPstnNo','');
            legend (LegendMatrix)
            title(['V' num2str(VesselNo)])
            ttl_fig=[[FVD{FlwVelDiaNo} '_Compare_No_'] num2str(i) ['_Column_V_'] num2str(VesselNo) ];
            
            saveas(gcf,[SavePath '\' ttl_fig '.png'])
        end
    end
end