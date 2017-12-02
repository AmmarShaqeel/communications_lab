function rx_symbols = demodulate(rx_signal,Ts,nsymbols) ;
global Tsampling
t = (0:Tsampling:nsymbols*Ts) ; rx_symbols = zeros(1,nsymbols) ;
for k = 1:nsymbols
rx_symbols(k) = Tsampling * sum(rx_signal .* (1/sqrt(Ts) * rectpuls(t-Ts/2-(k-1)*Ts,Ts))) ;	
end
end