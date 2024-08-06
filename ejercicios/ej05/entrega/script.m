close all;
clear all;
clc

n = 10000;
M = 16;			# Cantidad de ceros agregados.
Ts = 1e-6/16;

#############################################################
# SECUENCIA ALEATORIA
bi = round(rand(1,n))*2 - 1;
bq  = round(rand(1,n))*2 - 1;

b = bi + j * bq;
aux = [1 zeros(1,M-1)];
d = kron(b,aux);		# Señal Compleja

#############################################################
# PULSOS
#p = ones(1,10);
#p = sin(pi*(0:M-1)/M);

beta = 0.8;
Tsymb = 16 * Ts;
t = -7*Tsymb:Ts:7*Tsymb;
p = root_raised_cosine(t,Tsymb,beta);

p = p./max(p);
#############################################################
# CANAL
#h = [1 zeros(1,10)];	# ideal
h = [1];

#############################################################

x = conv(d,p,'same');
c = conv(x,h,'same');

#############################################################
# AGREGADO DEL RUIDO
sigma = 1.0;
ni = sigma * randn(1,length(c));
nq = sigma * randn(1,length(c));
noise = ni + j*nq;
c = c + noise;

#############################################################
# POST CANAL
y = conv(c,p,'same');
att = max(conv(p,p));
y = y ./ att;

# Submuestreo
b_s = y(1:M:end);
bi_s = (real(b_s)>0)*2-1;
bq_s = (imag(b_s)>0)*2-1;

e_i = sum(abs(bi-bi_s));
e_q = sum(abs(bq-bq_s));
er = e_i + e_q

############################################
# Calculo de los errores
BER = er / n
MSE = mean(abs(b-b_s).^2)

Es = sum(abs(b_s.^2)) * Ts
Ps = Es / Tsymb
Pn = sigma.^2
SNR = Ps / Pn
SNR_dB = 10.*log(SNR)

# Es = sum (p**2) dt
# Ps = Es / Tsymb
# Pn = sigma**2
# SNR = Ps / Pn

#############################################################
if false

# PLOTS
figure(1);
title("Filtro Raiz de Coseno Elevado");
ylabel("Valor normalizado");
xlabel("Muestras");
hold on;
stem(p,'x-');
hold off;

figure(2);
title("Modulacion en banda base y canal");
ylabel("Valor normalizado");
xlabel("Muestras");
hold on;
stem(d,'s-');
stem(x,'o-');
stem(c,'x-');
hold off;

figure(3);
title("Señal pre-post filtro adaptativo");
ylabel("Valor normalizado");
xlabel("Muestras");
hold on;
stem(y,'s-');
stem(d,'o-');
hold off;

figure(4);
title("Señal banda base");
ylabel("Valor normalizado");
xlabel("Muestras");
hold on;
stem(b_s,'x-');
stem(b,'o-');
hold off;
end

figure(5);
title("Grafico de Constelacion");
ylabel("Real");
xlabel("Img");
hold on;
plot(b_s, ".");
hold off;


