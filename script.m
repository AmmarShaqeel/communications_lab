global Tsampling fsampling
Tsampling = 1e-7 ; 
fsampling = 1/Tsampling;

unipolar_alphabet = [0,1];
polar_alphabet = [-1,1];
quaternary_alphabet = [-3,-1,1,3];

Tb = 1e-6; 
nbits = 1000; 
N0 = 0.5;
%tx_bits = [1,1,1,1,1,0,0,1,0,1];
tx_bits = round(rand(1,nbits)) ;

%load('tx_bits.mat');

 
%unipolar binary
Ts_unipolar = Tb * log2(length(unipolar_alphabet));
unipolar_nsymbols = nbits / log2(length(unipolar_alphabet));
unipolar_t = (0:Tsampling:unipolar_nsymbols*Ts_unipolar);
unipolar_noise = sqrt(fsampling * N0 * 0.5 / 2) * randn(1,length(unipolar_t));

unipolar_tx_symbols = map(tx_bits,unipolar_alphabet);
unipolar_tx_signal = modulate(unipolar_tx_symbols,Ts_unipolar,unipolar_nsymbols) ;
unipolar_rx_signal = unipolar_tx_signal + unipolar_noise;
unipolar_rx_symbols = demodulate(unipolar_rx_signal,Ts_unipolar,unipolar_nsymbols);
unipolar_rx_bits = demap(unipolar_rx_symbols,unipolar_alphabet);

%polar binary
Ts_polar = Tb * log2(length(polar_alphabet));
polar_nsymbols = nbits / log2(length(polar_alphabet));
polar_t = (0:Tsampling:polar_nsymbols*Ts_polar);
polar_noise = sqrt(fsampling * N0 / 2) * randn(1,length(polar_t));

polar_tx_symbols = map(tx_bits,polar_alphabet);
polar_tx_signal = modulate((polar_tx_symbols),Ts_polar,polar_nsymbols) ;% Received signal (channel output)
polar_rx_signal = polar_tx_signal + polar_noise;
polar_rx_symbols = demodulate(polar_rx_signal,Ts_polar,polar_nsymbols);
polar_rx_bits = demap(polar_rx_symbols,polar_alphabet);

%quaternary
Ts_quaternary = Tb * log2(length(quaternary_alphabet));
quaternary_nsymbols = nbits / log2(length(quaternary_alphabet));
quaternary_t = (0:Tsampling:quaternary_nsymbols*Ts_quaternary);
quaternary_noise = sqrt(fsampling * N0 * 2.5 / 2) * randn(1,length(quaternary_t));

quaternary_tx_symbols = map(tx_bits,quaternary_alphabet);
quaternary_tx_signal = modulate((quaternary_tx_symbols),Ts_quaternary,quaternary_nsymbols) ;% Received signal (channel output)
quaternary_rx_signal = quaternary_tx_signal + quaternary_noise;
quaternary_rx_symbols = demodulate(quaternary_rx_signal,Ts_quaternary,quaternary_nsymbols);
quaternary_rx_bits = demap(quaternary_rx_symbols,quaternary_alphabet);


%compare tx_bits and rx_bits
unipolar_error = length(tx_bits) - nnz(tx_bits == unipolar_rx_bits)
polar_error = length(tx_bits) -  nnz(tx_bits == polar_rx_bits)
quaternary_error = length(tx_bits) -  nnz(tx_bits == quaternary_rx_bits)

%plotting constellation diagrams
figure(1);
subplot(2,3,1);
scatter (real(unipolar_tx_symbols),imag(unipolar_tx_symbols));
grid on;
title('Tx symbols - Unipolar');
xlabel('Real Axis');
ylabel('Imaginary Axis');
subplot(2,3,4);
scatter (real(unipolar_rx_symbols),imag(unipolar_rx_symbols));
grid on;
title('Rx symbols - Unipolar')
xlabel('Real Axis');
ylabel('Imaginary Axis');


subplot(2,3,2);
scatter (real(polar_tx_symbols),imag(polar_tx_symbols));
grid on;
title('Tx symbols - polar')
xlabel('Real Axis');
ylabel('Imaginary Axis');
subplot(2,3,5);
scatter (real(polar_rx_symbols),imag(polar_rx_symbols));
grid on;
title('Rx symbols - polar')
xlabel('Real Axis');
ylabel('Imaginary Axis');


subplot(2,3,3);
scatter (real(quaternary_tx_symbols),imag(quaternary_tx_symbols));
grid on;
title('Tx symbols - quaternary')
xlabel('Real Axis');
ylabel('Imaginary Axis');
subplot(2,3,6);
scatter (real(quaternary_rx_symbols),imag(quaternary_rx_symbols));
grid on;
title('Rx symbols - quaternary')
xlabel('Real Axis');
ylabel('Imaginary Axis');

%plotting signal diagrams
figure(2);
subplot(1,3,1);
plot(unipolar_tx_signal);
title('Tx signal - Unipolar');


subplot(1,3,2);
plot(polar_tx_signal);
title('Tx signal - polar');

subplot(1,3,3);
plot(quaternary_tx_signal);
title('Tx signal - quaternary');
