%%
%DEMO: example of Direct Sequence Spread Spectrum (DS SS) modulation
%%

clear all; close all;
set(0,'defaultaxesfontsize',15);
set(0,'defaultlinelinewidth',2);

%generate a sequence of N random binary symbols, this is the signal to be transmitted via
%DS-SS
N=4;
bits=[1 -1 (-1).^(round(randn(1,N-2)))];
%generate now the spreading code of length SF
SF=11; %spreading factor: 11, 121, 1021
prncode=(-1).^(round(randn(1,SF)));

%Spread the bits
bits_temp=kron(bits, ones(1,SF));
spread_signal=kron(ones(1,N),prncode).*bits_temp;

%oversample the spread signal (to see better the correlation function at
%sub-chip level)
Ns=5;  %oversampling factor or number of samples per chip
x_Ns=kron(spread_signal, ones(1,Ns));
%reference frequency (in MHz)
f_ref=1.023;
%Define the length of the discrete Fourier transform (for spectrum
%computation)
fft_length=2^14;
%%
%compute the autocorrelation function over one symbol
Rcorr=xcorr(x_Ns(1:Ns*SF));
%compute the Power Spectra Density 
PSD_sim=fftshift(fft(Rcorr,fft_length));

%define the frequency axis according to sampling frequency
fs= f_ref*Ns/2; %sampling frequency
fax=[-fs+2*fs/fft_length:2*fs/fft_length:fs]+1e-6;

%%
 
%#########################NOW THE FIGURES ###############################
%% 
%%first plot is the transmitted bits
%%second plot is the spread sequence, 
figure;subplot(211); 
stairs([1:SF*N], bits_temp);   ylim([-1.1 1.1]); grid on;  title(' Initial symbols');
subplot(212); stairs([1:SF*N], spread_signal); 
grid on; hold on; title('Transmitted symbols')
xlim([1 SF*N]); ylim([-1.1 1.1]); grid on;  title(' Spread signal');
xlabel('Chips')

pause;
%%
%%

%Autocorrelation function of one symbol
Dmax_chips=2;
[garb, mid]=max(abs(Rcorr));
Rcorr_sim=Rcorr(mid-Dmax_chips*Ns:mid+Dmax_chips*Ns);
xaxchips=[-Dmax_chips*Ns:+Dmax_chips*Ns]/Ns;
figure; plot(xaxchips, abs(Rcorr_sim/max(abs(Rcorr_sim))));
xlabel('Delay error [chips]'); ylabel('abs(ACF)');
grid on; 
pause;
%%
%Third plot is the PSD
figure; plot(fax, 10*log10(abs(PSD_sim)),'k--'); hold on; 
grid on; 
ylabel('PSD [dB]'); xlabel('Frequency [MHz]');
