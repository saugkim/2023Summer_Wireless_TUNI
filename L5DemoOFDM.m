clear all; 
close all
set(0,'defaultaxesfontsize',15);
set(0,'defaultlinelinewidth',2);


%bandwidth
BW=3000*1e3;  %in Hz
%BW=300*1e3;  %in Hz

fs=15*1e3;  % frequency spacing

%number of carriers
N_FFT = round(BW/fs); % no of sub band       
T=0.001; %subframe interval
Ts=1/fs; % time interval of a ofdm symbol  %OFDM symbol time, because each sub-carrier has a 15 kHZ BW
Ns=12;%number of samples per ofdm symbol 
Tsa=Ts/Ns;%sampling interval
Fs=1/Tsa; %sampling frquency
N=round(T/Ts);  % no of ofdm symbols per subframe
%%%%%%%%%%%%%%%%%%

%%%%%%%%
M=2^4;                                             % M qam modulation
nbit=N_FFT*log2(M);                                %number of information bits
msg=round(rand(nbit,1));                           % information generation as binary form

% binary information convert into symbolic form for M-array QAM modulation
%M=order of QAM modulation
msg_reshape=reshape(msg,log2(M),nbit/log2(M))';

size(msg_reshape);
for(j=1:1:nbit/log2(M))
   for(i=1:1:log2(M))
       a(j,i)=num2str(msg_reshape(j,i));
   end
end


as=bin2dec(a);
ass=as';
figure
stem(ass,'Linewidth',2.0);
title('serial symbol for M-array QAM modulation at transmitter');
xlabel('n(discrete time)');
ylabel(' magnitude');
pause 

%%%%%%%%%%%%%%%%% qam mod %%%%%%%%%%%%%%%5
p=qammod(ass,M);

%%%%%%%%%%%%%%%%%%%%%%%%
y=[];
for i=1:round(N_FFT*Ns)
y(i)=sum(exp(1j*2*pi*i*[0:N_FFT-1]/Ns/N_FFT).*p);
end
y=y/(N_FFT*Ns);

faxnoGI=[-BW/2: BW/(N_FFT)/Ns: BW/2-BW/(N_FFT)/Ns]*1e-7; 
figure
plot(faxnoGI,fftshift(10*log10(abs((ifft(y))))))
title('spectrum of ofdm signal without cyclic prefix');

pause
%%%%%%%%%%%%%%% cyclic prefix %%%%%%%%%%%
N_GI = round((0.1)*N_FFT);
y1=[y(round(N_FFT*Ns-N_GI*Ns+1):round(N_FFT*Ns)) y];

fc=[-BW/2: BW/(N_FFT+N_GI)/Ns: BW/2-BW/(N_FFT+N_GI)/Ns]*1e-7;
figure
plot(fc,fftshift(10*log10(abs((ifft(y1))))))
title('spectrum of ofdm signal with cyclic prefix');

pause
figure
plot(abs(xcorr((y1))));
title('correlation of OFDM signal');
