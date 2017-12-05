snr_db = 0:1:24; 
snr = 10.^(snr_db/10); 

polar = 1/2 * erfc (sqrt(snr));
unipolar = 1/2 * erfc(sqrt(1/2*snr));
quaternary = 3/4 * erfc(sqrt(2/5*snr));

figure(6)
semilogy(snr_db,polar);
hold on;
grid on;
semilogy(snr_db,unipolar);
semilogy(snr_db,quaternary);
xlim([0 18]);
ylim([10^(-6) 1]);
title('Binary vs Quaternary Transmission');
xlabel('E_b/N_0 (dB)');
ylabel('P(e)');
legend('Binary: Unipolar','Binary: Polar','Quaternary');