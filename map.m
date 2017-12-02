function tx_symbols = map(tx_bits,alphabet)
tx_symbols = zeros(1,length(tx_bits)/log2(length(alphabet))) ;
aux = reshape(tx_bits,log2(length(alphabet)),length(tx_bits)/log2(length(alphabet)))' ;
for k = 1:length(tx_symbols)
tx_symbols(k) = alphabet(bi2de(aux(k,:),'left-msb') +1) ;
end
end