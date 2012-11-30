function drawF(xPixels,yPixels,SNR_CoMP,SNR_hard,ISD,resolution)
SNR_diff=SNR_CoMP-SNR_hard;

for xPixel_number_counter=1:xPixels
    for yPixel_number_counter= 1:yPixels
        if(SNR_diff(yPixel_number_counter,xPixel_number_counter)<1)
            c1=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'+','k');

        elseif(1<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<2)
            c2=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'.','c');

        elseif(2<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<3)
            c3=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'s','m');

        elseif(3<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<4)
            c4=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'p','y');

        elseif(4<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<6)
            c5=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'h','b');

        elseif(6<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<8)
            c6=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'o','g');

        else
            c7=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'*','r');

        end
         hold on;
    end
end
    
xlabel('x-pixels(m)');
ylabel('x-pixels(m)');
title(['ISD=',num2str(ISD)]);
legend([c1,c2,c3,c4,c5,c6,c7],'CoMP-HHO 0.5dB larger ', '1.5dB larger', '2.5dB larger', '3.5dB larger', '5dB larger', '7dB larger', 'more than 8dB');
hold off;
end

