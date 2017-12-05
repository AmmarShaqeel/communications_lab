global Tsampling fsampling
Tsampling = 1e-7 ; 
fsampling = 1/Tsampling;

unipolar_alphabet = [0,1];
polar_alphabet = [-1,1];
quaternary_alphabet = [-3,-1,1,3];

Tb = 1e-6; 
nbits = 1000; 
tx_bits = round(rand(1,nbits)) ;


%unipolar binary
Ts_unipolar = Tb * log2(length(unipolar_alphabet));
unipolar_nsymbols = nbits / log2(length(unipolar_alphabet));
unipolar_t = (0:Tsampling:unipolar_nsymbols*Ts_unipolar);
unipolar_tx_symbols = map(tx_bits,unipolar_alphabet);
unipolar_tx_signal = modulate(unipolar_tx_symbols,Ts_unipolar,unipolar_nsymbols) ;

%polar binary
Ts_polar = Tb * log2(length(polar_alphabet));
polar_nsymbols = nbits / log2(length(polar_alphabet));
polar_t = (0:Tsampling:polar_nsymbols*Ts_polar);
polar_tx_symbols = map(tx_bits,polar_alphabet);
polar_tx_signal = modulate((polar_tx_symbols),Ts_polar,polar_nsymbols) ;% Received signal (channel output)

%quaternary
Ts_quaternary = Tb * log2(length(quaternary_alphabet));
quaternary_nsymbols = nbits / log2(length(quaternary_alphabet));
quaternary_t = (0:Tsampling:quaternary_nsymbols*Ts_quaternary);
quaternary_tx_symbols = map(tx_bits,quaternary_alphabet);
quaternary_tx_signal = modulate((quaternary_tx_symbols),Ts_quaternary,quaternary_nsymbols) ;% Received signal (channel output)


count = 1;
N0 = 0:0.01:1;
noise = randn(1,length(unipolar_t));

%preallocating arrays to speed up code
SNR_unipolar = zeros(1,length(N0));
SNR_polar = zeros(1,length(N0));
SNR_quaternary = zeros(1,length(N0));
pe_unipolar = zeros(1,length(N0));
pe_polar = zeros(1,length(N0));
pe_quaternary = zeros(1,length(N0));

for N0 = 0:0.01:1
    unipolar_noise = sqrt(fsampling * N0 * 0.5 / 2) * noise;
    unipolar_rx_signal = unipolar_tx_signal + unipolar_noise;
    unipolar_rx_symbols = demodulate(unipolar_rx_signal,Ts_unipolar,unipolar_nsymbols);
    unipolar_rx_bits = demap(unipolar_rx_symbols,unipolar_alphabet);

    polar_noise = sqrt(fsampling * N0 * 1 / 2) * noise;
    polar_rx_signal = polar_tx_signal + polar_noise;
    polar_rx_symbols = demodulate(polar_rx_signal,Ts_polar,polar_nsymbols);
    polar_rx_bits = demap(polar_rx_symbols,polar_alphabet);

    quaternary_noise = sqrt(fsampling * N0 * 2.5 / 2) * noise;
    quaternary_rx_signal = quaternary_tx_signal + quaternary_noise;
    quaternary_rx_symbols = demodulate(quaternary_rx_signal,Ts_quaternary,quaternary_nsymbols);
    quaternary_rx_bits = demap(quaternary_rx_symbols,quaternary_alphabet);

    %compare tx_bits and rx_bits
    unipolar_error = length(tx_bits) - nnz(tx_bits == unipolar_rx_bits);
    polar_error = length(tx_bits) -  nnz(tx_bits == polar_rx_bits);
    quaternary_error = length(tx_bits) -  nnz(tx_bits == quaternary_rx_bits);
    
    SNR_unipolar(count) = 20*log(rms(unipolar_tx_signal)^2*Ts_unipolar/(N0));
    SNR_polar(count) = 20*log(rms(polar_tx_signal)^2*Ts_polar/N0);
    SNR_quaternary(count) = 20*log(rms(quaternary_tx_signal)^2*Ts_quaternary/(N0));
    
    pe_unipolar(count) = unipolar_error/nbits;
    pe_polar(count) = polar_error/nbits;
    pe_quaternary(count) = quaternary_error/nbits;
    
    count = count + 1;
end

figure(5)
semilogy(SNR_unipolar, pe_unipolar);
hold on;
grid on;
semilogy(SNR_polar, pe_polar);
semilogy(SNR_quaternary, pe_quaternary);
set(gca, 'YScale', 'log');
title('Probability of Bit error vs Eb/N0');
legend('Unipolar', 'Polar' , 'Quatenary');
xlabel('Eb/N0 (dB)');
ylabel('P(e)');
hold off;

