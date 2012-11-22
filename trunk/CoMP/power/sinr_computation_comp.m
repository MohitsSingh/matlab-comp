%%%%% Compute SINR, throughput, and other related metrics%%%%%%%%%%%%%%%%%%
%%%%% Author: Beneyam B. Haile %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [SNR, SINR,cell_idx_order]=sinr_computation_comp(yPixels,xPixels,number_snapshots,BS_tx_power,noise_DL, h_matrix,method, w_pha)

%%%%% Pre-allocation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UE_cell_idx = zeros(UE_number,number_snapshots);
% 
% UE_SINR = zeros(UE_number,number_snapshots);
% UE_all_interference_ff = zeros(UE_number,number_snapshots);

% comp_cell_set=zeros(UE_number, number_comp_cells,number_snapshots);

%Ordering received powers
% [Rx_level_all_ff_order, cell_idx_order]=sort(Rx_level_all_ff,3, 'descend');  % association based on P_{SF}
method
if method==2

        % Computing desired and interference signal of comp users
        [m1 m2 m3 m4]=size(h_matrix);
        for xPixel=1:xPixels
            for yPixel=1:yPixels
                SINR_temp=zeros(1,number_snapshots);
                for NSS = 1:number_snapshots
                    h1=h_matrix(yPixel,xPixel,1, NSS);
                    h2_1=w_pha*h_matrix(yPixel,xPixel,2, NSS);
                    h2=[h2_1;h2_1;h2_1;h2_1];
                    if m3>2;
                        h3_1=w_pha*h_matrix(yPixel,xPixel,3, NSS);
                        h3=[h3_1;h3_1(2:4) h3_1(1);h3_1(3:4) h3_1(1:2);h3_1(4) h3_1(1:3)];
                    else
                        h3=0;
                    end
                    h=h1+h2+h3;
                    hMax=max(max(abs(h)));
     
                % computing desired signal
                    Rx_level_max=db2pow(BS_tx_power-30)*(hMax^2)/50;   %in dB
               % Computing SINR
                    SINR_temp(NSS)= pow2db(Rx_level_max) - noise_DL;
            
            % computing interference signal
%             temp=sum( 10.^(Rx_level_all_ff(yPixel,xPixel,cell_idx_order(yPixel,xPixel,1:number_comp_cells,NSS),NSS)/10) );
%             all_interference_ff(yPixel,xPixel,NSS)=10*log10( sum(10.^(Rx_level_all_ff(yPixel,xPixel,:,NSS)/10),2) -...
%                 temp + 10^(noise_DL/10)  );
            
               end
            SINR(yPixel,xPixel)=mean(SINR_temp);
            end
        
        end
            SNR=SINR;
            cell_idx_order=0;

elseif method==1             %%%%means HHO
    
       Rx_level_all_ff=db2pow(BS_tx_power-30)*(abs(h_matrix).^2)/50;   %total PRB=50
       Rx_level_all_ff_mean=mean(Rx_level_all_ff,4);                   
       [Rx_level_all_ff_order, cell_idx_order]=sort(Rx_level_all_ff_mean,3, 'descend'); %[Rx_level_all_ff_order, cell_idx_order]=sort(Rx_level_all_ff_mean,3 or 2, 'descend');
       Rx_level_max_linear=Rx_level_all_ff_order(:,:,1);
       Rx_level_max=pow2db(Rx_level_max_linear);
       Rx_level_all_ff_linear_sum=sum(Rx_level_all_ff_mean,3);
       all_interference_ff_linear=Rx_level_all_ff_linear_sum-Rx_level_max_linear;
       all_interference_ff_db=pow2db(all_interference_ff_linear);
       noise_DL_linear=db2pow(noise_DL);
       IN_db=pow2db(all_interference_ff_linear+noise_DL_linear);
   
    % Computing SINR
       SINR = Rx_level_max - IN_db;
       SNR= Rx_level_max-noise_DL;
end
       
end







