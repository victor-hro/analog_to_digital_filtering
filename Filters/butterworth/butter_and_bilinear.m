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
fsample = 48000;                         % fa > 2*fn

fp = 2000;                               % frequência de passagem
fs = 3000;                               % frequência de corte

% Região de transição da frequência
wp = (2*pi*fp)/fsample;
ws = (2*pi*fs)/fsample;

T = 1/fsample
%pre warping
%wp/fs
pre_wp = %% Filtro Digital - Cauer
(2/T)*tan(wp/2)
pre_ws = (2/T)*tan(ws/2)



% Limites de tolerância
ap = 0.5;                               % tolerância na faixa de passagem
as = 45;                                % tolerância na faixa de rejeição

% Cálculo
[n,wn]      = buttord(pre_wp,pre_ws,ap,as,'s'); % recebe a ordem do filtro e a frequência de corte - 's' = filtro analógico
[zs,ps,ks]  = butter(n,wn,'s');         % recebe zeros, polos e ganho - filtro analógico

% para analisar os pólos
% compass(ps)

[bs,as]     = zp2tf(zs,ps,ks);          % tf: b - numerador, a - denominador
sys         = tf(bs,as);                % função de transferência (tf)
disp(sys)

[hs,wout]   = freqs(bs,as,fsample);     % H(s) e frequência angular
magnitude   = mag2db(abs(hs));          % magnitude
fase        = unwrap(angle(hs));        % fase
%% Plot
figure;
bode(sys);
title('Diagrama de Bode - Filtro Analógico');
grid;

figure;
subplot(2,1,1);
plot((wout/(2*pi*1000)),magnitude); 
grid;
title('Filtro Analógico - Resposta em Magnitude')
xlabel('Frequência (kHz)');
ylabel('Magnitude(dB)');

subplot(2,1,2);
plot((wout/(2*pi*1000)),fase);
grid;
title('Filtro Analógico - Resposta em Fase');
xlabel('Frequência (kHz)');
ylabel('Fase');


%% Filtro Digital - Transformada Bilinear
fs = fsample;

% Bilinear
sysz = c2d(sys,T,'tustin')
figure;
step(sys);
hold on;
step(sysz);
title('Resposta ao degrau');

figure;
bode(sysz);
hold on;
bode(sys);
title('Bode - Bilinear');


