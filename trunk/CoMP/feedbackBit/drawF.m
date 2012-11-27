function drawF(xPixels,yPixels,SNR_CoMP,SNR_hard,nf,resolution)
SNR_diff=SNR_CoMP-SNR_hard;

for xPixel_number_counter=1:xPixels
    for yPixel_number_counter= 1:yPixels
        if(SNR_diff(yPixel_number_counter,xPixel_number_counter)<0)
            c1=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'+','k');

        elseif(0<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<0.1)
            c2=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'.','c');

        elseif(0.1<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<0.2)
            c3=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'s','m');

        elseif(0.2<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<0.3)
            c4=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'p','y');

        elseif(0.3<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<0.4)
            c5=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'h','b');

        elseif(0.4<=SNR_diff(yPixel_number_counter,xPixel_number_counter) && SNR_diff(yPixel_number_counter,xPixel_number_counter)<0.5)
            c6=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'o','g');

        else
            c7=scatter(xPixel_number_counter*resolution,yPixel_number_counter*resolution,'*','r');

        end
         hold on;
    end
end
    
xlabel('x-pixels(m)');
ylabel('x-pixels(m)');
title(['different number of feedback bits between ',num2str(nf),' to 2']);
legend([c1,c2,c3,c4,c5,c6,c7],'5 feedback bits has less SNR', '0.1 dB larger', '0.2 dB larger', '0.3 dB larger', '0.4 dB larger', '0.5 dB larger', 'more than 0.5dB');
hold off;
end

