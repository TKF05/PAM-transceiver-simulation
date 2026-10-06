% bits -> |s/p| -> LUT -> Pulse Shaping Filter -> S(t) -> AWGN -> r(t)
% r(t) -> MF (PSF(-t)) -> Sampling -> Coefficients -> Decision Block -> log2(M) bits

M = 8;         % Modulation order
bps = log2(M);  % Bits per symbol
n = 3e4;      % Transmitted bits
sps = 2;        % Samples per symbol (This is the upsampling rate)
EbNo = 12;      % Eb/N0 (dB) (Energy of bit)/(energy of noise) OR SNRlinear(samples/bit / bits/symbol)
span = 10;      % Filter span in symbols
rolloff = 0.25; % Filter rolloff factor

txfilter = comm.RaisedCosineTransmitFilter( ...
    RolloffFactor=rolloff, ...
    FilterSpanInSymbols=span, ...
    OutputSamplesPerSymbol=sps);

% Matched filter so rxfilter is just tx(-t)

rxfilter = comm.RaisedCosineReceiveFilter( ...
    RolloffFactor=rolloff, ...
    FilterSpanInSymbols=span, ...
    InputSamplesPerSymbol=sps, ...
    DecimationFactor=sps);

%impz(txfilter.coeffs.Numerator) % plot impulse response baseband Pulse Shaping filter

filtDelay = bps*span;

errorRate = comm.ErrorRate(ReceiveDelay=filtDelay);

%% Bits

x = randi([0 1],n,1); %randomly generate the bits

%% S/P Block

% Convert bits into 2-bit symbols
xSym = bi2de(reshape(x, bps, []).', 'left-msb'); % binary to decimal conversion (Think of like an S/P block)

%% LUT

% 4-PAM modulation
modSig = pammod(xSym, M); %param xSym: the bits to be modulated. param M: modulation order ie number of keys

%% Pulse Shaping

txSig = txfilter(modSig); % look above for txfilter def txSig is S(t)
eyediagram(txSig(1:1000),sps) % show the eye diagram for transmitted unnoisy signal
set(gcf, 'Name', 'Transmitted Signal Eye Diagram (NO AWGN)', 'NumberTitle', 'off');

%% AWGN

SNR = convertSNR(EbNo,"ebno","snr", ...
    SamplesPerSymbol=sps, ...
    BitsPerSymbol=bps);
noisySig = awgn(txSig,SNR,"measured");
eyediagram(noisySig(1:1000), sps)
set(gcf, 'Name', 'Noisy Signal Eye Diagram', 'NumberTitle', 'off');
% noisySig is r(t)

%% MF (time reversed PSF function) + Sampling
rxSig = rxfilter(noisySig);
eyediagram(rxSig(1:1000),sps)
set(gcf, 'Name', 'Received Signal Eye Diagram', 'NumberTitle', 'off');
scatterplot(rxSig)

%% Decision Block
% 4-PAM demodulation
zSym = pamdemod(rxSig, M);
% Convert PAM symbols back to bits
z = de2bi(zSym, bps, 'left-msb');
z = z.';
z = z(:);


%% STATS 

errStat = errorRate(x,z); % errorrate gives ber, bit errors, and total bits
fprintf('\nFull System Stats: \n')
fprintf('\nBER = %5.2e\nBit Errors = %d\nBits Transmitted = %d\n',...
    errStat)

%x_aligned = x(1:end-filtDelay);
%z_aligned = z(filtDelay+1:end);
%errors = (x_aligned ~= z_aligned);
%total_errors = sum(errors);
%BER = total_errors / length(x_aligned);
%fprintf('\nTOTAL ERRORS: %d\nBER: %d\n', total_errors, BER);

%% no pulse shaping, just AWGN
nzmod = awgn(modSig,SNR,"measured");
demodSym = pamdemod(nzmod, M);
demodsig = de2bi(demodSym, bps, 'left-msb');
demodsig = demodsig.';
demodsig = demodsig(:);
errorRate2 = comm.ErrorRate;
errStat2 = errorRate2(x,demodsig);
fprintf('\nNo Pulse Shaping: \n')
fprintf('\nBER = %5.2e\nBit Errors = %d\nBits Transmitted = %d\n',...
    errStat2)
