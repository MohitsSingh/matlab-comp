function drawF(xPixels,yPixels,SNR_CoMP,SNR_hard,number_comp_cells,resolution)
SNR_diff=SNR_CoMP-SNR_hard;

for xPixel_number_counter=1:xPixels
    for yPixel_number_counter= 1:yPixels
        if(SNR_diff(yPixel_number_counter,xPixel_number_counter)<-1)
            c1=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'+','k');

        elseif(-1<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<0)
            c2=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'.','c');

        elseif(0<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<1)
            c3=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'s','m');

        elseif(1<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<2)
            c4=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'p','y');

        elseif(2<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<4)
            c5=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'h','b');

        elseif(4<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<6)
            c6=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'o','g');

        else
            c7=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'*','r');

        end
         hold on;
    end
end
    
xlabel('x-pixels(m)');
ylabel('x-pixels(m)');
title(['number of serving BS =',num2str(number_comp_cells)]);
legend([c1,c2,c3,c4,c5,c6,c7],'CoMP-HHO<-1dB', '[-1,0]dB', '[0,1]dB', '[1,2]dB', '[2,4]dB', '[4,6]dB', 'CoMP-HHO>7dB');
hold off;
end

