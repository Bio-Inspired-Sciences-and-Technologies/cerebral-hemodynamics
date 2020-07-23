Data_Path = './experiment-output/';
MirrorPath = './mirror_SD_40K_0.50SA_200A_0x';
List = dir([Data_Path]);
Process2DAngio = 0;
for FileCounter = size(List,1):-1:1
    close all
    if List(FileCounter).isdir == 0
        if List(FileCounter).bytes>5e6
            if strcmpi(List(FileCounter).name(1:6),'OCT_2D')
                SavePath = [Data_Path,'Results\2Dimages\',List(FileCounter).name];
                Bi = [strfind(List(FileCounter).name,'Bi') strfind(List(FileCounter).name,'BD')];
                if isempty(Bi)
                    Bi = 0;
                else
                    Bi = 1;
                end
                Processed = 1;
                if ~exist(SavePath)
                    Processed = 0;
                elseif exist(SavePath) & Process2DAngio
                    if isempty(dir([SavePath,'\*Ang*.bin']))
                        Processed = 0;
                    end
                end
                if ~Processed
                    List(FileCounter).name
                    Data_Name = List(FileCounter).name;
                    
                    LS_Stim = dir([Data_Path,'/*Dpp_Dt_*']);
                    OCTTime = str2num(List(FileCounter).name(8:9))*3600+str2num(List(FileCounter).name(11:12))*60+str2num(List(FileCounter).name(14:15));
                    timeGap = inf;
                    for StimFileCtr = 1:size(LS_Stim,1)
                        Indx = strfind(LS_Stim(StimFileCtr).name,'Dpp_Dt');
                        Dpp_DtTime = str2num(LS_Stim(StimFileCtr).name(Indx+7:Indx+8))*3600+str2num(LS_Stim(StimFileCtr).name(Indx+10:Indx+11))*60+str2num(LS_Stim(StimFileCtr).name(Indx+13:Indx+14));
                        if Dpp_DtTime<OCTTime+1
                            if (OCTTime-Dpp_DtTime)<timeGap
                                timeGap = OCTTime-Dpp_DtTime;
                                StimFileNum = StimFileCtr;
                            end
                        end
                    end
                    timeGap
                    LS2 = LS_Stim(StimFileNum);
                    StimFileName = LS2(1).name;
                    [~,~,VarName,VarValue] = ReadImpulse_ForGCaMP([Data_Path,'\',StimFileName]);
                    StimParams.BasePeriod  = 0;
                    StimParams.Freq = 0;
                    StimParams.StimPeriod = 0;
                    StimParams.DC = 0;
                    StimParams.xArray = [];
                    StimParams.yArray = [];
                    for i = 1:size(VarName,2)
                        if strcmpi(VarName{i},'Imp Base Line Period (sec)')
                            StimParams.BasePeriod = VarValue{i};
                        end
                        if strcmpi(VarName{i},'Pulse Freq')
                            StimParams.Freq = VarValue{i};
                        end
                        if strcmpi(VarName{i},'Imp Stimulation Period (sec)')
                            StimParams.StimPeriod = VarValue{i};
                        end
                        if strcmpi(VarName{i},'DutyCycle')
                            StimParams.DC = VarValue{i};
                        end
                        if strcmpi(VarName{i},'xArray')
                            StimParams.xArray = VarValue{i};
                        end
                        if strcmpi(VarName{i},'yArray')
                            StimParams.yArray = VarValue{i};
                        end
                    end
                    
                    
                    Main2D_Imp_Doppler_Angio_MultiVesselOneFrame(Data_Path,Data_Name,SavePath,MirrorPath,StimParams,1,inf,Bi,Process2DAngio);
                    save([SavePath,'\StimParam.mat'],'StimParams')
                    
                    LSDpp = dir([SavePath,'\MyDoppler*.bin']);
                    for FileCtr = 1:size(LSDpp,1)
                        Dpp_Path = [SavePath,'\',LSDpp(FileCtr).name];
                        Ang_Path = [SavePath,'\Angio2D',LSDpp(FileCtr).name(10:end)];
                        [Dpp, LnPerCross, FrmNum, T MaxFrmNo Last_FrmNum] = ReadOMAG(Dpp_Path,1);
                        if size(Dpp,1)>500
                            if exist(Ang_Path)
                                RemoveOutOfFOV(Dpp_Path,Ang_Path);
                            else
                                RemoveOutOfFOV(Dpp_Path,[]);
                            end
                        end
                    end

                    if Process2DAngio==0
                        LSDpp = dir([SavePath,'\*Doppler*.bin']);
                        for DppCtr = 1:size(LSDpp,1)
                            Flow_Velocity_Diam_Measurement([SavePath,'\',LSDpp(DppCtr).name],[],StimParams);
                        end
                    else
                        LSDpp = dir([SavePath,'\*Doppler*.bin']);
                        for DppCtr = 1:size(LSDpp,1)
                            LSAng = ['Angio2D',LSDpp(DppCtr).name(10:end)];
                            Flow_Velocity_Diam_Measurement([SavePath,'\',LSDpp(DppCtr).name],[SavePath,'\',LSAng],StimParams);
                        end
                    end
                end
                
            elseif strcmpi(List(FileCounter).name(1:6),'OCT_3D') || strcmpi(List(FileCounter).name(1:2),'3D')
                
                SavePath = [Data_Path,'Results\3Dimages\',List(FileCounter).name];
                if ~exist(SavePath)
                    List(FileCounter).name
                    
                    Indx = strfind(List(FileCounter).name,'K');
                    Indx = Indx(end);
                    Indx2 = strfind(List(FileCounter).name(1:Indx),'_');
                    Indx2 = Indx2(end);
                    
                    BD = strfind(List(FileCounter).name,'_BD_');
                    Repeat = strfind(List(FileCounter).name,'1x');
                    
                    Indx = strfind(List(FileCounter).name,'A');
                    Indx = Indx(end);
                    Indx2 = strfind(List(FileCounter).name(1:Indx),'_');
                    Indx2 = Indx2(end);
                    A = str2num(List(FileCounter).name(Indx2+1:Indx-1));
                     if isempty(BD)
                        Bi = 0;
                    else
                        Bi = 1;
                    end
                    if isempty(Repeat)
                        SrcPath = [];
                        Main_Angio_Multiple_3D(Data_Path,List(FileCounter).name,[SavePath],MirrorPath,Bi,1);
                    else
                        Main_Doppler_Multiple_3D(Data_Path,List(FileCounter).name,SavePath,MirrorPath,Bi,1);
                    end
                end
            end
        end
    end
end