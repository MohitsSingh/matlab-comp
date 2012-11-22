%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Main function of the LTE Simulator%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Author: Beneyam B. Haile%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Date: October, 2012%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%Compute link loss, received power per PRB, and receiver noise per PRB from each cell to all pixels%%%%%
% linkloss= calculate_linkloss(number_cells, cell_location, antenna_tower_height, BS_ground_height,cable_loss, rfhead_gain, ...
%                 UE_height, UE_ground_height, UE_bodyloss, UE_antenna_gain,coverage_location, xPixels, yPixels,xmin, ymin,xmax,ymax, ...
%                 pathloss_model, area_correction, frequency, resolution, ISD, monitored_cells);
% save('./Input_data/linkloss.mat','linkloss');

noise_DL = thermal_noise_density + 10 * log10( bandwidth_PRB ) + noise_figure_UE; 

% if method==1
%     rm1_bar=k*(d1.^(-aexp));           
%     rm2_bar=k*(d2.^(-aexp));  
%     h_matrix=zeros(length(rm1_bar),2,number_snapshots);
%     Rx_level_all = zeros(length(d0),2, number_snapshots);
%     for ii=1:length(d0)
%         for div_num=1:div
%                   h_temp1(div_num,:)=sqrt(rm1_bar(ii)/2)*randn(1,number_snapshots)+1i*sqrt(rm1_bar(ii)/2)*randn(1,number_snapshots);
%                   h_temp2(div_num,:)=sqrt(rm2_bar(ii)/2)*randn(1,number_snapshots)+1i*sqrt(rm2_bar(ii)/2)*randn(1,number_snapshots);
%         end
%         h_matrix(ii,1,:)=max(h_temp1,[],1);
%         h_matrix(ii,2,:)=max(h_temp2,[],1);
% %         Rx_level_all_linear(ii,1,:)=db2pow(BS_tx_power)*(abs(h(ii,1,:)).^2)/total_PRB;
% %         Rx_level_all_linear(ii,2,:)=db2pow(BS_tx_power)*(abs(h(ii,2,:)).^2)/total_PRB;
% %         Rx_level_all=pow2db(Rx_level_all_linear);
%     end
% 
% else

%%%%%Fast fading generation for all UEs from each cell for all snapshots%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    for Cell_number_counter=1:number_cells
        distance = sqrt((abs(coverage_location - cell_location(Cell_number_counter))).^2 + (antenna_tower_height-UE_height).^2)/1000;
        rm_bar=k*(distance.^(-aexp));
        for xPixel_number_counter=1:xPixels
            for yPixel_number_counter= 1:yPixels
                    for div_num=1:div
                      h(div_num,:)=sqrt(rm_bar(yPixel_number_counter,xPixel_number_counter)/2)*(randn(1, number_snapshots)+ 1i*randn(1, number_snapshots));
                    end
                    h_max=max(h,[],1);
                    h_matrix(yPixel_number_counter,xPixel_number_counter,Cell_number_counter, :)=h_max; 
            end
        end
    end

% h_mean=mean(h_max);
%           fast_fading_mean=10*log10(abs(h_mean)^2);
%           Rx_level_all_ff(yPixel_number_counter,xPixel_number_counter,Cell_number_counter)=...
%              Rx_level_all(yPixel_number_counter,xPixel_number_counter,Cell_number_counter)+fast_fading_mean;
% fast_fading_matrix=10*log10(abs(h_matrix).^2);
% save('./Input_data/fast_fading_matrix.mat','fast_fading_matrix');
% save('./Input_data/h_matrix.mat','h_matrix');


%%%%% Received signal level including fast fading %%%%%%%%%%%%%%%%%%%%%%%%%
% Rx_level_all_ff =Rx_level_all+fast_fading_matrix;


%%%%% SINR computation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
for mm=1:2
    method=mm;
    if mm==1
        [SNR_hard, SINR_hard,index_hard]=sinr_computation_comp(yPixels,xPixels,number_snapshots,BS_tx_power,noise_DL, h_matrix,method, w_pha);
    else
        [SNR_CoMP, SINR_hard,no_index]=sinr_computation_comp(yPixels,xPixels,number_snapshots,BS_tx_power,noise_DL, h_matrix,method, w_pha);
    end
end

for xPixel_number_counter=1:xPixels
    for yPixel_number_counter= 1:yPixels
        if(index_hard(yPixel_number_counter,xPixel_number_counter)==1)
            scatter(xPixel_number_counter,yPixel_number_counter,'o','k');

        elseif(index_hard(yPixel_number_counter,xPixel_number_counter)==2)
            scatter(xPixel_number_counter,yPixel_number_counter,'*','c');

        elseif(index_hard(yPixel_number_counter,xPixel_number_counter)==3)
            scatter(xPixel_number_counter,yPixel_number_counter,'+','m');

        end
         hold on;
    end
end




plot3(xx,yy,SNR_hard);

return;
SNR_diff=SNR_CoMP-SNR_hard;
color=zeros(1,7);
for xPixel_number_counter=1:xPixels
    for yPixel_number_counter= 1:yPixels
        if(SNR_diff(yPixel_number_counter,xPixel_number_counter)<0)
            scatter(xPixel_number_counter,yPixel_number_counter,'+','k');

        elseif(0<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<1)
            scatter(xPixel_number_counter,yPixel_number_counter,'.','c');

        elseif(1<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<2)
            scatter(xPixel_number_counter,yPixel_number_counter,'s','m');

        elseif(2<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<3)
            scatter(xPixel_number_counter,yPixel_number_counter,'p','y');

        elseif(3<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<4)
            scatter(xPixel_number_counter,yPixel_number_counter,'h','b');

        elseif(4<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<5)
            scatter(xPixel_number_counter,yPixel_number_counter,'o','g');

        else
            scatter(xPixel_number_counter,yPixel_number_counter,'*','r');
%             if(color(7)~=0)
%                 legend('more than 5dB');
%                 color(7)=color(7)+1;
%             end
        end
         hold on;
    end
end
legend('CoMP SNR less than HHO', '1 dB larger', '2 dB larger', '3 dB larger', '4 dB larger', '5 dB larger', 'more than 5dB');

            
            
            
           return; 
%%%%%% Statistics calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

statistics_SINR=[];
UE_SINR_all = [];
for counter = monitored_cells
    UE_SINR_all = [UE_SINR_all; UE_SINR(UE_cell_idx==counter)];
end

af = cdf_percentile(UE_SINR_all,10);
am = cdf_percentile(UE_SINR_all,50);
anf = cdf_percentile(UE_SINR_all,90);
stats_min = af;
stats_med = am;
stats_max = anf;
statistics_SINR = [ statistics_SINR [stats_min; stats_med; stats_max] ] 
           
       
%%%%%%%%%%% Saving Simulation Results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output_file_name = ['./Output_data/output_comp_flag_' num2str(comp_flag) num2str(comp_threshold) '.mat']; 

if comp_flag==0
    save(output_file_name,'UE_Rx_level_ff', 'UE_all_interference_ff', 'UE_Rx_level_all','UE_SINR','statistics_SINR');
else
    save(output_file_name,'UE_Rx_level_ff', 'UE_all_interference_ff', 'UE_Rx_level_all','UE_SINR', 'statistics_SINR', 'comp_UE_flag','comp_cell_set');
end
        
               
%%%%% plotting figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%comp_plot;
        for xPixel=1:xPixels
            for yPixel=1:yPixels
                plot3(yPixel,xPixel,SINR(yPixel,xPixel));
                hold on;
            end
        end
        SINR=peaks(20);
        mesh(SINR);
        surf(SINR);

                  
%%%%% Notifications for users on GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n Relax, simulation is done! Feel free to use me again :-)\n')                            
           
t=0:pi/10:2*pi; y=sin(t);
scatter(t,y,[-2:0.1:2],'+','r');
subplot(3,2,1); scatter(t,y)
subplot(3,2,2); scatter(t,y,'v')
subplot(3,2,3); scatter(t,y,(abs(y)+2).^4,'filled')
subplot(3,2,4); scatter(t,y,30,[0:2: 40],'v','filled')
subplot(3,2,5); scatter(t,y,(t+1).^3,y,'filled')
