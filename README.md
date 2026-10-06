# PAM-transceiver-simulation
  A MATLAB Simulation of Pulse Amplitude Modulation (PAM) complete digital communication system. Includes simulated transmission and reception chain. The project demonstrates the entire PAM system with pulse shaping, simulated additive white Gaussian noise (AWGN) and is recovered using a matched filter and decision block.

## Features
  - **Configurable Modulation Order** — Supports any power-of-two PAM order (2-PAM, 4-PAM, 8-PAM, 16-PAM, 32-PAM, ...),  with no technical fixed modulation-order limit in the simulation.
  - **Configurable SNR** — Simulated Channel features configurable E<sub>b</sub>/N<sub>0</sub> (dB) to change SNR where 

$$
\mathrm{SNR}_{\mathrm{dB}} =
(E_b/N_0)_{\mathrm{dB}}
+
10\log_{10}
\left(
\frac{\log_2(M)}{\mathrm{sps}}
\right)
$$

  - **Generates Figures and BER data** — Generates Constellation of Received Signals and Eye Diagrams for Transmitted Signal, Noisy Signal, and Received Signal.

## Figures
  **Variables used for example figures:**
  - Modulation Order = 8
  - 3e4 bits
  - E<sub>b</sub>/N<sub>0</sub> (dB) = 12

<img src="figures/Constellation.png" alt="8-PAM Received Constellation" width="400">

<img src="figures/TxSig.png" alt="Transmitted Signal Eye Diagram (No AWGN)" width="400">

<img src="figures/NoisySig.png" alt="Noisy Signal Eye Diagram (Simulated Channel)" width="400">

<img src="figures/RxSig.png" alt="Received Signal Eye Diagram" width="400">

