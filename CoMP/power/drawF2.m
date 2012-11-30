function drawF2(xPixels,yPixels,SNR_CoMP,SNR_hard,BS_tx_power,resolution)
SNR_diff=SNR_CoMP-SNR_hard;

for xPixel_number_counter=1:xPixels
    for yPixel_number_counter= 1:yPixels
        if(SNR_diff(yPixel_number_counter,xPixel_number_counter)<-4)
            c1=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'+','k');

        elseif(-4<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<-2)
            c2=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'.','c');

        elseif(-2<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<0)
            c3=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'s','m');

        elseif(0<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<1)
            c4=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'p','y');

        elseif(1<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<2)
            c5=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'h','b');

        elseif(2<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<4)
            c6=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'o','g');

        else
            c7=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'*','r');

        end
         hold on;
    end
end
    
xlabel('x-pixels(m)');
ylabel('x-pixels(m)');
title(['Power =',num2str(BS_tx_power),'dbm']);
legend([c1,c2,c3,c4,c5,c6,c7],'CoMP-HHO<-4dB', '[-4,-2]dB', '[-2, 0]dB', '[0,1]dB', '[1,2]dB', '[2,4]dB', 'more than 4dB');
hold off;
end