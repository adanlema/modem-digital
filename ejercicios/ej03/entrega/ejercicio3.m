close all;
clear all;
clc

n = 25;
M = 10;			# Cantidad de ceros agregados.
Ts = M;

#############################################################
# PULSOS
#p = ones(1,10);
#p = sin(pi*(0:M-1)/M);

beta = 0.8;
t = -3*M:3*M;
p = raised_cosine(t, Ts, beta);

p = p./max(p);
#############################################################
# CANAL
#h = [1 zeros(1,10)];	# ideal
h = [1];

#############################################################
# SECUENCIA ALEATORIA
b = round(rand(1,n))*2 - 1;
aux = [1 zeros(1,M-1)];
d = kron(b,aux);

x = conv(d,p,'same');
c = conv(x,h,'same');

#############################################################
# AGREGADO DEL RUIDO
sigma = 0.1;
n = sigma * randn(1,length(c));

c = c + n;

#############################################################
# PLOTS
figure(1);
title("Filtro Coseno Elevado");
xlabel("Valor normalizado");
xlabel("Muestras");
stem(p,'x-');

figure(2);
title("Modulacion en banda base y canal");
xlabel("Valor normalizado");
xlabel("Muestras");
hold on;
stem(d,'s-');
stem(x,'o-');
stem(c,'x-');
