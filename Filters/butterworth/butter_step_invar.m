clc;clear all;close all;
fsample = 48000;                         % fa > 2*fn

fp = 2000;                               % frequência de passagem
fs = 3000;                               % frequência de corte

% Região de transição da frequência
wp = (2*pi*fp);
ws = (2*pi*fs);

T = 1/fsample


% Limites de tolerância
ap = 0.5;                               % tolerância na faixa de passagem
as = 45;                                % tolerância na faixa de rejeição

% Cálculo
[n,wn]      = buttord(wp,ws,ap,as,'s'); % recebe a ordem do filtro e a frequência de corte - 's' = filtro analógico
[zs,ps,ks]  = butter(n,wn,'s');                   % recebe zeros, polos e ganho - filtro analógico


% para analisar os pólos
% compass(ps)
z = tf('z',T);
[bs,as]     = zp2tf(zs,ps,ks);          % tf: b - numerador, a - denominador
sys         = tf(bs,as);                % função de transferência (tf)


[r_res,p_res,k_res] = residue(bs,as)    % r = resíduos, p = polos
hz_step = 0;
len_pres = length(p_res);
for c = 1:len_pres
    h0 = (r_res(c)*(exp(p_res(c)^T)-1)) / (p_res(c));
    h1 = 1/(z-exp(p_res(c)^T));
    hz_step = h0*h1 + hz_step;

end
sysz = hz_step;

figure;
bode(sysz);
hold on;
bode(sys);
title('Diagrama de Bode - Step Invariance');
disp(sysz);


figure;
step(sysz);
title('Step plot - Step Invariance');

