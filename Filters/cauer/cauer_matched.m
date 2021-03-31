clc; close all; clear all;
%% O projeto de filtros envolve os seguintes estágios:
% - Especificação das propriedades desejadas do sistema;
% - Aproximaçãoo das especificações usando um sistema de tempo discreto causal;
% - Realização do sistema

%% 1. Especificação das propriedades desejadas do sistema
% Filtro passa-baixas com frequência de amostragem  fsample = 48kHz.

% Teorema de Nyquist:  A frequência de amostragem (fa) deve ser pelo menos
% o dobro da frequência máxima do sinal. Se o teorema não for respeitado,
% poderemos ter perdas no espectro.

% Parâmetros iniciais
fsample = 48000;                         

fp = 2000;                               % frequência de passagem
fs = 3000;                               % frequência de corte

% Região de transição da frequência
wp = (2*pi*fp);                  % warping
ws = (2*pi*fs);                  % warping

T = 1/fsample

pre_wp = (2/T)*tan(wp/2)
pre_ws = (2/T)*tan(ws/2)

% Limites de tolerância
ap = 0.5;                               % tolerância na faixa de passagem
as = 45;                                % tolerância na faixa de rejeição

% Cálculo
[n, wn]    = ellipord(wp,ws,ap,as,'s')
[bs,as]    = ellip(n,ap,as,wn,'s');     % recebe zeros, polos e ganho - filtro analógico

%[bs,as]     = zp2tf(zs,ps,ks);          % tf: b - numerador, a - denominador
sys         = tf(bs,as);                % função de transferência (tf)

%[bs,as]     = butter(n,wn,'s');        % butterworth analógico
[hs,wout]   = freqs(bs,as,fsample);     % H(s) e frequência angular
magnitude   = mag2db(abs(hs));          % magnitude
fase        = unwrap(angle(hs));        % fase
%% Plot
sysz = c2d(sys,T,'matched')

figure;
bode(sysz);
hold on;
bode(sys);
title('Diagrama de Bode - Matched Z x Filtro Analógico')
disp(sysz);

figure;
step(sysz);
hold on;
step(sys);
title('Step - Matched Z x Filtro Analógico')
disp(sysz);