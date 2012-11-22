%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Main function of the LTE Simulator%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Author: Beneyam B. Haile%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Date: October, 2012%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%Suite matlab environment and file path for simulation
clc                                  % Clear command window
clear all;                           % Clear work space
close all;                           % Close opened figures
% set_path;                            % Add workign directory path for simulation




% xInput=input('please input the ISD: \n0: ISD=500\n1: ISD=1732\n');
% while(1)
% if xInput==0
%     ISD =  500;                                % Inter-Site Distance: 500 m for 3GPP Case 1 (Macro 1), 1732 m for 3GPP Case 3 (Macro 3), 3000 m for Noise-Limited Case 
%     break;
% elseif xInput==1
%     ISD =1732;
%     break;
% else
%     fprintf('error input!\n');
%     xInput=input('enther again:\n');
% end
% end
% 
% 
% 
% 
% %%%%%Configure cells/basestations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fprintf('Enter the number of cells(2 or 3)\n');
% xInput=input('0: 2 base stations(Scenario 1)\n1: 3 base stations(Scenario 2)\n');
% while(1)
% if xInput==0
%     number_cells = 2;               % Number of cells  
%     fprintf('Call the Scenario 1.\n');
%     scenario=1;
%     break;
% elseif xInput==1
%     number_cells = 3;
%     fprintf('Call the Scenario 2.\n');
%     scenario=2;
%     break;
% else
%     fprintf('error input!\n');
%     xInput=input('enther again:\n');
% end
% end
%%%%%%Define simulation area and general parameters%%%%%%%%%%%%%%%%%%%%%%%
number_snapshots = 10;                     %here to modify the samples

for ii=1:2
    if ii==1
        ISD=500;
        resolution = 5; 
    else
        ISD=1732;
        resolution = 10; 
    end
    
    number_cells=3;
monitored_cells = 1:number_cells;

antenna_tower_height = 20;                   % Antenna tower height in meters based on simulation environment
BS_ground_height(1:number_cells) = 0;                         % Base station (eNB) ground height based on simulation environment
                                                    % Ground height has not been modeled but it is included in m-files
                                                    % BS_antenna_gain is
                                                    % automatically calculated!
UE_height= 1.5;
scenario=2;
if scenario==2
                              % in meters 
    xmin = 0;
    xmax = ISD;                                  
    ymin = 0;
    ymax =ISD*sqrt(3)/2;                                  %compute

    xPixels = fix((xmax-xmin)/resolution) + 1;
    yPixels = fix((ymax-ymin)/resolution) + 1;
    [xx yy] = meshgrid( 1:xPixels, 1:yPixels );
    xx = (xx - 1) * resolution + xmin;
    yy = (yy - 1) * resolution + ymin;
    coverage_location = complex(xx,yy);
    coverage_location=flipud(coverage_location);
    cell_location = [1i*ymax xmax/2 xmax+1i*ymax];
    
else
    resolution = 1;                           % in meters  0.5
    xmin = 0;
    xmax = ISD;                                  
    ymin = 0;
    ymax =0; 
    xPixels = fix((xmax-xmin)/resolution) + 1;
    yPixels = fix((ymax-ymin)/resolution) + 1;
    [xx yy] = meshgrid( 1:xPixels, 1:yPixels );
    xx = (xx - 1) * resolution + xmin;
    yy = (yy - 1) * resolution + ymin;
    coverage_location = complex(xx,yy);
    coverage_location=flipud(coverage_location);
    cell_location = [1i*ymax  xmax+1i*ymax];
%     distance(1,:)= sqrt(coverage_location.^2+(antenna_tower_height-UE_height)^2)/1000;        %distance to base station 1
%     distance(2,:)= sqrt((ISD-coverage_location).^2+(antenna_tower_height-UE_height)^2)/1000;  %distance to base station 2
end




BS_tx_power = 46;         % in dBm - Some evaluations to exploit carrier aggregation techniques may use wider bandwidths e.g. 60 or 80 MHz (FDD). For these evaluations [49 dBm] Total BS Tx power should be used.
cable_loss = 3; %2;                        % in dB
rfhead_gain = 0;                           % RF Head Gain in dB (DL)

%%%%%Configure user equipments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UE_antenna_gain = 0;                             % UE antenna gain
UE_bodyloss = 0;                                 % Body loss in UEs
UE_ground_height=0;
div=2;                                           % receiver diversity degree e.g. 1x2 -> 2; 2x2 -> 2
thermal_noise_density=-174;                      % in dBm/Hz
noise_figure_UE = 9;                             % in dB for UE in DL



% pathloss_model = 4;
%                                % 1. COST 231
%                                % 2. UMTS 30.03 models: pedestrian  (micro cell)
%                                % 3. UMTS 30.03 models: vehicular_a (macro cell)
%                                % 4. 3GPP LTE Pathloss law is 128.1 + 37.6*log10(d/km) 
%                                % 5. 3GPP TR 36.814 V9.0.0 Rural Macro for all carrier frequencies (0.45 GHz - 6 GHz)
%                                % 6. 3GPP TR 36.814 V9.0.0 Suburban Macro for the carrier frequencies between 2 - 6 GHz
%                                % 7. 3GPP TR 36.814 V9.0.0 Urban Macro for the carrier frequencies between 2 - 6 GHz



 
                               
area_correction = 0;          % e.g. indoor loss or penetration loss in dB 

%%%%%Define resource parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frequency = 2000;                             % system frequency in MHz
bandwidth_PRB = 180000; %180000               % bandwidth per PRB in Hz
bandwidth_resource_element = 15000; %15000    % bandwidth per subcarrier in Hz
total_PRB = 50; %50          % Physical resource blocks
control_PRB(monitored_cells) = 0;             % Number of PRBs for control transmission or signalling

%%%channel model%%%
Ch=3.2*((log10(11.75*UE_height))^2)-4.97; %Okumura value in this case(2000MHZ)
%Ch=0.8+(1.1*log10(fc)-0.7)*UE_height-1.56*log10(fc);     %Small/Medium size of city
k=db2pow(-(69.55+26.16*log10(frequency)-13.82*log10(antenna_tower_height)-Ch));
aexp=3;      %path loss exponent: assume outdoor in urban area; 

%%%%%CoMP parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
comp_flag=1;                                  % 0-> comp off/HH 1-> comp on
number_comp_cells=3;                          % the number of members of cooperating set
comp_mode= 1;                                 % 1->Co-phasing,
%comp_threshold=10;                            % when to perform CoMP is known from this threshold in dB
nf=2;                                         % Number of required feedback bits

%%%%%Generate codebook for CoMP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w_pha=phase_codebook_generate(nf);


fprintf('\n You successfully accomplished setting simulation parameters and configuring the network!\n')

SimulatorMain;  

fprintf('\n Finished calculating, plotting.......!\n')
 if ii==1
        subplot(2,1,ii),drawF(xPixels,yPixels,SNR_CoMP_ISD1,SNR_hard_ISD1,ISD,resolution);
 else
        subplot(2,1,ii),drawF(xPixels,yPixels,SNR_CoMP_ISD2,SNR_hard_ISD2,ISD,resolution);
 end

end


% for ii=1:2
%     if ii==1
%         ISD=500;
%         resolution = 5;                           % in meters 
%     else
%         ISD=1732;
%         resolution = 10;                           % in meters 
%     end
%   
%   
%     xmin = 0;
%     xmax = ISD;                                  
%     ymin = 0;
%     ymax =ISD*sqrt(3)/2;                                  %compute
% 
%     xPixels = fix((xmax-xmin)/resolution) + 1;
%     yPixels = fix((ymax-ymin)/resolution) + 1;
%     [xx yy] = meshgrid( 1:xPixels, 1:yPixels );
%     xx = (xx - 1) * resolution + xmin;
%     yy = (yy - 1) * resolution + ymin;
%     figure(2)
%    
%     
% end