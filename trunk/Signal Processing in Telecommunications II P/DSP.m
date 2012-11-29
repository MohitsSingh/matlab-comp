a=[-1i 1i -1 -1 -1i];
y=[0.0194-0.9205i -0.1107+0.8965i -1.0061-0.2676i -0.9849-0.1206i 0.3207-0.8757i];

for ii=1:5
    z(ii)=conj(a(ii))*y(ii);
end



R=zeros(1,2);
for m=2:3
    for k=m:5
        R_temp=z(k)*conj(z(k-m+1));
        R(m-1)=R(m-1)+R_temp;
    end
    R(m-1)=R(m-1)/(5-m+1);
end   
    
f=atan(imag(sum(R))/real(sum(R)))/(pi*(3)*10/2e4)

p=conj(a).*y ;
pk = fft(p,512);
f_offset=angle(max(pk))/(512*10/20000)