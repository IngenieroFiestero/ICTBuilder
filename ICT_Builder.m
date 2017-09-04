%% 
%  _____ _____ _______   ____        _ _     _           
% |_   _/ ____|__   __| |  _ \      (_) |   | |          
%   | || |       | |    | |_) |_   _ _| | __| | ___ _ __ 
%   | || |       | |    |  _ <| | | | | |/ _` |/ _ \ '__|
%  _| || |____   | |    | |_) | |_| | | | (_| |  __/ |   
% |_____\_____|  |_|    |____/ \__,_|_|_|\__,_|\___|_|   
%                                                        
%
% v1.0
% Copyright Samuel Garcés Marín
%
%
% El presente script permite calcular todos los datos de un proyecto ICT.
clear;
clc;
%% DATOS -----------------------------------------------------------------

%Numero de plantas del edificio
nFloor = 3;

% Distancia entre plantas.   (m) distancia en Metros
dFloor = 4;

% Distancia entre tomas de una vivienda.
% Cada fila de la matriz es una vivienda y las columnas las tomas de
% la principal al resto.   (m) distancia en Metros
%  _____
% |__1__|_____
% |__2__|__3__|
% |__4__|__5__|
%
housesInOneFloor = {
    [12,4,5,7,2];  % Vivienda 1
    [6,4,5,7,2];   % Vivienda 2
    [6,4,5,7,2];   % Vivienda 3
    [6,4,5,7,2];   % Vivienda 4
    [6,4,5,7,2]    % Vivienda 5
};
[nHouses,basura] = size(housesInOneFloor);
% Ubicación en metros de los amplificadores y el distribuidor con respecto
% al centro de forma radial.   (m) distancia en Metros
dAmpDistr = 0;

% Distancia entre las antenas y los ampplificadores.   (m) distancia en Metros
dUHF = 10;
dFM = 10;
dSAT = 9;

fmIntensity = [
    108, 8 * 10^-3;   % Radio FM
];

% Matriz de intensidades de Frecuencias
% |__Frecuency (Mhz)__|__Intensity (V/m)__|__Nombre Multiplex__|
% |________482________|___ 5.6 * 10^-3 ___|_________22_________|
frecIntensity = [
    482, 5.6 * 10^-3, 22; % Multiplex 22 = Gol, DisneyChannel...
    530, 6 * 10^-3, 28;   % Multiplex 28 = Atreseries HD, RealMadrid TV...
    546, 5.2 * 10^-3, 30; % Multiplex 30 = Telecinco/HD, Cuatro/HD...
    570, 7 * 10^-3, 33;   % Multiplex 33 = TDT/HD, DKiss...
    626, 7.2 * 10^-3, 40; % Multiplex 40 = Aragon TV, Aragon 2 TV...
    642, 8 * 10^-3, 42;   % Multiplex 42 = Boing, Energy, Mega, 13TV...
    674, 8.8 * 10^-3, 46; % Multiplex 46 = La 1/HD, La 2...
    738, 7.8 * 10^-3, 54; % Multiplex 54 = Antena 3/HD, LaSexta/HD...
];

% Matriz Satelites
% |__Nombre Satelite__|__PIRE (dBW)__|__BW (MHz)__|
%

satMatrix = {
    'Hispasat',54,36;
    'Astra',57,36;
};

[nFM,basura] = size(fmIntensity);
[nUHF,basura] = size(frecIntensity);
[nSAT,basura] = size(satMatrix);
nChannels = nFM+ nUHF + nSAT;

%Anchos de banda
fmBW=200000;
uhfBW = 8000000;
satBW = 36000000;
%IVA
IVA = 0.21;

%% 
% ---------------------------Datos Componentes ---------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%
%% ----------------------------CABLE COAXIAL ------------------------------
% Nombre: CCT-650
% Datasheet: http://www.ikusi.tv/sites/default/files/imported/descargables/cct-es8.pdf
% Diametro exterior 15.4mm
% Impedancia 75 Ohms
% Ref: 2507

% Metros de cable por unidad.   (m) distancia en Metros
coaxialMetersPerUnit = 1000;

% Precio del cable por unidad. (euros)
coaxialPricePerUnit = 3.8;

% Tabla de atenuaciones para cada frecuencia.
% |__Frecuency (Mhz)__|__Atenuation (dB/100m)__|
coaxialFrecuencyAtenuation = [
    100 , 2.1;
    200, 3;
    500, 4.9;
    600, 5.4;
    750, 6.1;
    862, 6.5;
    950, 7.5;
    1750, 10.2;
    2150, 11.5;
];
% ----------------------------- NO TOCAR --------------------------------
%Reajuste de atenuacion de dB/100m a db/1m
coaxialFrecuencyAtenuation(:,2) = coaxialFrecuencyAtenuation(:,2)/100;
%------------------------------------------------------------------------


%% ---------------------------- Antena UHF -------------------------------
% Nombre: HDT518V
% Datasheet: http://www.ikusi.tv/sites/default/files/imported/descargables/Ficha%20tecnica%20FLASHD.pdf
% Ref: 1795

% Precio de la antena por unidad (euros)
uhfPricePerUnit = 66.9;

% Tabla de atenuaciones para cada frecuencia.
% |__Frecuency (Mhz)__|__Atenuation (dB)__|
uhfFrecuencyAtenuation = [
    482, 12; % Multiplex 22 = Gol, DisneyChannel...
    530, 13.3;   % Multiplex 28 = Atreseries HD, RealMadrid TV...
    546, 13.6; % Multiplex 30 = Telecinco/HD, Cuatro/HD...
    570, 13.9;   % Multiplex 33 = TDT/HD, DKiss...
    626, 14.9; % Multiplex 40 = Aragon TV, Aragon 2 TV...
    642, 15.3;   % Multiplex 42 = Boing, Energy, Mega, 13TV...
    674, 15.7; % Multiplex 46 = La 1/HD, La 2...
    738, 17; % Multiplex 54 = Antena 3/HD, LaSexta/HD...
];
uhfTa = [
    482, 159; % Multiplex 22 = Gol, DisneyChannel...
    530, 104.5;   % Multiplex 28 = Atreseries HD, RealMadrid TV...
    546, 104.5; % Multiplex 30 = Telecinco/HD, Cuatro/HD...
    570, 104.5;   % Multiplex 33 = TDT/HD, DKiss...
    626, 73.5; % Multiplex 40 = Aragon TV, Aragon 2 TV...
    642, 73.5;   % Multiplex 42 = Boing, Energy, Mega, 13TV...
    674, 52.5; % Multiplex 46 = La 1/HD, La 2...
    738, 52.5; % Multiplex 54 = Antena 3/HD, LaSexta/HD...
];
uhfNoiseFigure = 0;
%% ---------------------------- Antena Radio FM -------------------------------
% Nombre: IKS1E
% Datasheet: http://www.ikusi.tv/sites/default/files/imported/descargables/Ficha%20tecnica%20FLASHD.pdf
% Ref: 1725

% Precio de la antena por unidad (euros)
fmPricePerUnit = 22.9;

% Tabla de atenuaciones para cada frecuencia.
% |__Frecuency (Mhz)__|__Atenuation (dB)__|
fmFrecuencyAtenuation = [
    100, 0
];
fmNoiseFigure = 0;
%% --------------------------- Antena Satelite ----------------------------
% Nombre: RPA-100
% Datasheet: http://www.ikusi.tv/sites/default/files/imported/descargables/Ficha%20t%C3%A9cnica%20Antenas%20parab%C3%B3licas%20RPA_es.pdf
% Ref: 3069

% Precio de la antena por unidad (euros)
satPricePerUnit = 102.5;

satDiameter = 1;

% Tabla de atenuaciones para cada frecuencia.
% |__Frecuency (Mhz)__|__Atenuation (dB)__|
satFrecuencyAtenuation = [
    12500, 40.3
];
satNoiseFigure = 0;
satTa = 155.5;
%% ------------------------------ LNB ------------------------------------
% Nombre: UEU-121K
% Datasheet: http://www.ikusi.tv/sites/default/files/imported/descargables/Ficha%20tecnica%20UEU-121K_es.pdf
% Ref: 1113
lnbG = 58;
lnbNoise = 0.2;
lnbPricePerUnit = 11.2;

%% -------------------------- Impedancias --------------------------------
% Nombre: CTF-075
% Datasheet: 
% Ref: 2221
impedancePricePerUnit = 0.65;


%% ---------------------- Distribuidor Television ------------------------
% Se encarga de dividir la señal de TV en el numero de satelites del que
% dispongamos (Hispasat y ASTRA) para tener tomas independientes.
% Nombre: SIS102
% Datasheet: http://www.ikusi.gr/prod_pdf/SIS%20EN.pdf
% Ref: 3376

%Numero de salidas del spliter
splitterNOut = 2;

%Precio
splitterPrice = 15;

% Tabla de atenuaciones por inserción para cada frecuencia.
% |__Frecuency (Mhz)__|__Atenuation (dB)__|
splitterInsertionLoss = [
    5, 4.2;
    862, 4.2;
    950, 5;
    1550,5;
    1551, 5.8;
    2300, 5.8;
];

% Tabla de atenuaciones por separación para cada frecuencia.
% |__Frecuency (Mhz)__|__Atenuation (dB)__|
splitterOutIsolation = [
    5, 12;
    47, 12;
    48, 20;
    862, 20;
    950, 15;
    2150, 15;
];


%% ----------------------- Amplificador UHF  -----------------------------
% Amplificador de señal UHF
% Nombre: SZB148
% Datasheet: http://www.ikusi.tv/sites/default/files/imported/descargables/Ficha%20t%C3%A9cnica%20cabecera%20SZB_es.pdf
% Ref: 2246

%Numero de canales
uhfAmplifierChannels = 1;

%Precio Amplificador
uhfAmplifierPrice = 84.7;

%Ganancia del amplificador  (dB)
uhfAmplifierG = [
    480, 52;
    862, 52;
];

%Figura del ruido  (dB)
uhfAmplifierNoiseFigure = 9;

%Perdidas de retorno salida (dB)
uhfAmplifierReturnLoss = 6;

%Nivel de salida (dBuV)
uhfAmplifierVRef = 121;

%% ----------------------- Amplificador FM  -----------------------------
% Amplificador de señal UHF
% Nombre: SZB129
% Datasheet:http://www.ikusi.tv/sites/default/files/imported/descargables/Ficha%20t%C3%A9cnica%20cabecera%20SZB_es.pdf
% Ref: 2294

%Precio Amplificador
fmAmplifierPrice = 63.4;

%Ganancia del amplificador  (dB)
fmAmplifierG = [
    98, 57;
    200, 57;
];

%Figura del ruido  (dB)
fmAmplifierNoiseFigure = 4;

%Perdidas de retorno salida (dB)
fmAmplifierReturnLoss = 6;

%Nivel de salida (dBuV)
fmAmplifierVRef = 113;

%% ----------------------- Amplificador SATELITE  -----------------------------
% Este amplificador satelite permite acoplar la señal de UHF
% Amplificador de señal UHF
% Nombre: SZB190
% Datasheet:http://www.ikusi.tv/sites/default/files/imported/descargables/Ficha%20t%C3%A9cnica%20cabecera%20SZB_es.pdf
% Ref: 1346

%Precio Amplificador
satAmplifierPrice = 108;

%Ganancia del amplificador  (dB)
satAmplifierG = [
    950, 33;
    2150 , 40;
];

%Figura del ruido  (dB)
satAmplifierNoiseFigure = 8;

%Perdidas de retorno salida (dB)
satAmplifierReturnLoss = 0;

%Nivel de salida (dBuV)
satAmplifierVRef = 120;

%% ------------------ Combinador Terrestre-Satelite -----------------------
% Usaremos como combinado el del amplificador de los satelites

% Entradas UHF
combUhfIn = 1;

% Entradas Satelite
combSatIn = 1;

%Salidas
combOut = 1;

%Precio (euros)
combPrice = 0;

%Atenuación por insercion (Mhz, dB)
combAtenuation = [
    5, 1;
    2300 , 1;
];
% Desacoplo entre entradas (dB)
combDesAcoplo = 0;

%% -------------------------------- Derivador -----------------------------
% Nombre: UDL-800
% Datasheet:http://www.ikusi.tv/sites/default/files/imported/descargables/udl800-es.pdf
% Ref: 3366
% Estructura de la celda(cell)
%
% |_____________|__Salidas__|__Atenuation_Derivation(dB)__|___Atenuation_Pass(dB)___|__Desacoplo_direccional_(dB)_|_Desacoplo_entre_salidas(dB)__|__Perdidas_de_retorno_(dB)__|__Price__|
% |_Derivator_1_|_____8_____|____________16_______________|__[5,4;862,4;950,4.4;]___|_____[5,30;862,30;950,30;]___|_____[5,34;862,32;950,30;]____|_____________10_____________|____15___|

derivators = {
    %'UDL-110',1, 10, [5,1.1;862,1.1;950,1.7;1550,1.7; 1551,2.3;2300,2.3;],[5,29;300,29;301,29;862,29; 950,19;2300,19;],[5,0;300,0;301,0;862,0; 950,0;2300,0;],15;
    %'UDL-115',1, 15, [5,1;  862,1;  950,1.7;1550,1.7; 1551,2.2;2300,2.2;],[5,28;300,28;301,27;862,27; 950,23;2300,23;],[5,0;300,0;301,0;862,0; 950,0;2300,0;],15;
    %'UDL-120',1, 20, [5,0.9;862,0.9;950,1.6;1550,1.6; 1551,2.1;2300,2.1;],[5,31;300,31;301,28;862,28; 950,19;2300,19;],[5,0;300,0;301,0;862,0; 950,0;2300,0;],15;
    %'UDL-125',1, 25, [5,0.5;862,0.5;950,1.3;1550,1.3; 1551,2.0;2300,2.0;],[5,38;300,38;301,35;862,35; 950,24;2300,24;],[5,0;300,0;301,0;862,0; 950,0;2300,0;],15;
    
    'UDL-825',8, 25, [5,1.8;862,1.8;950,2;1550,2; 1551,2.2;2300,2.2;],[5,33;300,33;301,36;862,36; 950,28;2300,28;],[5,30;300,30;301,28;862,28; 950,28;2300,28;],10,9.5;
    
    'UDL-820',8, 20, [5,1.8;862,1.8;950,2;1550,2; 1551,2.2;2300,2.2;],[5,30;300,30;301,30;862,30; 950,23;2300,23;],[5,30;300,30;301,28;862,28; 950,28;2300,28;],10,9.5;
    'UDL-816',8, 16, [5,4;862,4;950,4.4;1550,4.4; 1551,4.8;2300,4.8;],[5,30;300,30;301,30;862,30; 950,27;2300,27;],[5,34;300,34;301,32;862,32; 950,25;2300,25;],10,9.5;
    };
[nDerivators,basura]=size(derivators);

%% -------------------------------- PAU ------------------------------------
% Nombre: PAU-204
% Datasheet:http://www.ikusi.tv/sites/default/files/imported/descargables/pau-ficha-tecnica-es.pdf
% Ref: 3331
pauNOut = 2;
pauNIn = 2;
pauInsertionLoss = [
    5,4;
    862,4;
    950,4.5;
    2300,4.5;
];
pauPricePerUnit = 6.1;

%% -----------------------------TOMAS--------------------------------------
% Nombre: ARTU-900
% Datasheet:http://www.ikusi.tv/sites/default/files/imported/descargables/Ficha%20tecnica%20ARTU902_es.pdf
% Ref: 2479
% Estructura de la celda(cell)
%
% |_____________|__Atenuation_Conexion(dB)__|___Atenuation_Pass(dB)___|__Perdidas_de_retorno_(dB)__|__Price__|
% |____Toma_1___|___[5,4;862,4;950,4.4;]____|__[5,4;862,4;950,4.4;]___|_____________25_____________|__8.35___|

%Colocar en orden de uso
%  ______________________________________________
% | ________________IMPORTANTE___________________|
% Jugar con las tomas para obtener un valor correcto.
% Una posible mejora es que el algoritmo optimize la colocación de las
% tomas. De momento hay que hacerlo a mano.
%
tomas = {
    'ARTU-901',[5,11; 862,11; 950,11; 2300,11;], [5,2;  862,2;  950,3;  2300,3;],25,12;
    %'ARTU-902',[5,15; 862,15; 950,15; 2300,15;], [5,1.3;862,1.3;950,2.5;2300,2.5;],25,12;
    %'ARTU-903',[5,19; 862,19; 950,18; 2300,18;], [5,1.3;862,1.3;950,2.5;2300,2.5;],25,12;
    'ARTU-900',[5,4.5;862,4.5;950,5.5;2300,5.5;],[5,0;  862,0;  950,0;  2300,0;],25,12;
};
[nTomas,basura]=size(tomas);
% Hacer algoritmo de optimización en la selección de tomas para tener la 
% maxima señal en todas las tomas de la vivienda

%% Pre-checker
% Comprueba que los componentes esten bien puestos

%Cuantos satelites tenemos
[n_sat, basura] = size(satMatrix);
% Cuantos canales UHF tenemos
[n_uhf,basura] = size(frecIntensity);

%Comprueba que el splitter principal que divide la señal UHF entre el
%numero de satélites que tenemos tenga las salidas correctas.
if(splitterNOut ~= n_sat)
    error(['Numero de salidas del splitter = ' num2str(splitterNOut) ' es distinto del numero de satelites = ' num2str(n_sat)]);
end
%Combinadores terrestre-satelite necesarios
neededCombs = ceil(n_sat/combOut);
%Amplificadores necesarios
neededUHFChanelAmplifiers = ceil(n_uhf/uhfAmplifierChannels);
% Distribuidores principales necesarios
neededPrincipalSplitter = ceil(n_sat/splitterNOut);
%Por sencillez se utiliza la misma antena satelite para todos
neededSateliteAntenna = ceil(n_sat);
neededFMAntenna = 1;
neededUHFAntenna = 1;

%Calculo Metros de cable
dTotal = dUHF + dFM + dSAT*n_sat + dAmpDistr;%Hasta los amplificadores
for n_house = 1:nHouses
    %Añadimos los cables de cada vivienda
    dTotal = dTotal + sum(housesInOneFloor{n_house}(2:end))*nFloor;
    % Añadimos las canalizaciones interiores para el numero de satelites del que dispongamos
    dTotal = dTotal + (sum(housesInOneFloor{n_house}(1)) + dFloor)*nFloor*n_sat;
end

%Unidades de metros de cable
neededCoaxial = ceil(dTotal/coaxialMetersPerUnit);

%Comprobar PAU
if(pauNIn < n_sat)
    error(['Numero de entradas de PAU = ' num2str(pauNIn) ' menor que el numero de satelites = ' num2str(n_sat)]);
end

%Numero de tomas y añadir ya el precio
nTomasTotal = 0;
precioTotal = 0;% Cada toma es diferente
nViviendasTotal = 0;
for floor_n=1:nFloor
    derivator = round((nFloor-floor_n + 1)*nDerivators/nFloor);
    precioTotal = precioTotal + derivators{derivator,8}*2;
    for house_n=1:nHouses
        nViviendasTotal = nViviendasTotal + 1;
        [basura,nTomasHouse] = size(housesInOneFloor{house_n});
        nTomasTotal = nTomasTotal + nTomasHouse;
        vecTomas = toma_algoritmo( tomas,nTomasHouse );
        [basura,longTomas] = size(vecTomas);
        for i=1:longTomas
            precioTotal = precioTotal + tomas{vecTomas(i),5};%Añadir precio de cada toma
        end
    end
end

%% Calculadora ----------------------------------------------------------
% Para aclarar conceptos y no liar variables que empiezan parecido ej :
% nFloor haremos a partir de este punto que las constantes sean de
% la forma nFloor y las variables de calculo n_Floor

%Estructura del edificio con todos los datos dentro:
%
%___________________________________Edificio________________________________
%Floor|______________________________1__________________________|_2_|_3_|_.._|        
%House|_________________________1_______________________|_2_|_3_|___|___|____|
%Toma_|______________________1______________________|2|3|____________________|
%Canal|___________________1_____________________|2|3|________________________|
%Data_|_Name_|_S/N_|_signal_|_....._|___________|____________________________|
%
% En el nivel data se guarda el nombre del canal(fm,22,hispasat...) al que corresponde el canal 
% asi como tambien la señal que llega y el nivel de señal a ruido.
edificio = cell(nFloor,1);

%Maxima y minima potencia de todas las tomas para cada frecuencia
% ___________________________________________________________________________________
%|______Channel_____|____Max_Signal___|____Min_Signal____|___MAX_SNR___|___Min_SNR___|
maxMinSignal = cell(nChannels,5);
%Poner a un valor muy bajo en dBs ej: -200 dBs
for i = 1:nChannels
    maxMinSignal{i,2} = cell(2,1);
    maxMinSignal{i,2}{1} = '';
    maxMinSignal{i,2}{2} = -200;
    maxMinSignal{i,3} = cell(2,1);
    maxMinSignal{i,3}{1} = '';
    maxMinSignal{i,3}{2} = 200;
    maxMinSignal{i,4} = cell(2,1);
    maxMinSignal{i,4}{1} = '';
    maxMinSignal{i,4}{2} = -200;
    maxMinSignal{i,5} = cell(2,1);
    maxMinSignal{i,5}{1} = '';
    maxMinSignal{i,5}{2} = 200;
end

K=1.38*10^-23;
%% ---CalculoFM------------------------------------------------------------
Ta = 950;
T0 = 290;
initialNoise = K*fmBW*Ta;
noiseFigure = 9;
for n_fm = 1: nFM
    frec = fmIntensity(n_fm,1);
    intensity = fmIntensity(n_fm,2);
    longOnda = (3*10^8)/(frec*(10^6));%(m)
    %Ruido antena
    noiseFMAntena = K*fmBW*Ta + K*fmBW*(fmNoiseFigure-1)*T0;
    %Ruido salida amplificador = (K*fmBW*Ta*Gamp/AttCable + K*fmBW*(fmF-1)*T0/AttCable)*Gamp + K*fmBW*(F-1)*T0*Gamp) 
    noiseAmplifier = noiseFMAntena/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation)*dFM/10))*(10^(frecuency_interpolation(frec,fmAmplifierG)/10)) + (K*fmBW*(10^(noiseFigure/10) -1)*T0*(10^(frecuency_interpolation(frec,fmAmplifierG)/10)));
    %Ruido salida distribuidor, usamos la atenuacion por insercion como figura de ruido
    noiseDistrib = noiseAmplifier/(10^(frecuency_interpolation(frec,splitterInsertionLoss)/10)) + (K*fmBW*(10^(frecuency_interpolation(frec,splitterInsertionLoss)/10) -1)*T0/(10^(frecuency_interpolation(frec,splitterInsertionLoss)/10)));
    %Ruido Combinador
    noiseComb = noiseDistrib/(10^(frecuency_interpolation(frec,combAtenuation)/10)) + (K*fmBW*(10^(frecuency_interpolation(frec,combAtenuation)/10) -1)*T0/(10^(frecuency_interpolation(frec,combAtenuation)/10)));
    noiseFloor = noiseComb/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation*dFloor)/10));
    
    fmCampo = 10*log10(intensity);%(dBs)
    %La atenuacion a FM se obtiene interpolando las frecuencias del coaxial (W)
    signalInAmpl = ((intensity^2) * (longOnda^2) * (10^(frecuency_interpolation(frec,fmFrecuencyAtenuation)/10))) / ( 4*120*(pi^2)*(dFM*frecuency_interpolation( frec, coaxialFrecuencyAtenuation )));
    %Atenuación a la salida del amplificador (dBW)
    signalOutAmpl = 10*log10(signalInAmpl) + frecuency_interpolation(frec,fmAmplifierG);%(dBW) señal a la salida del amplificador
    signalOutDistri = signalOutAmpl - frecuency_interpolation(frec,splitterInsertionLoss);%(dBW) señal tras el distribuidor (duplica para los satelites)
    signalOutComb = signalOutDistri - frecuency_interpolation(frec,combAtenuation);%(dBW) señal tras el combinador
    signalDerivatorIn = signalOutComb - dFloor*frecuency_interpolation(frec,coaxialFrecuencyAtenuation);%(dBW) señal que llega al derivador de planta

    n_Floor= nFloor; %Empezamos calculando desde el piso más alto

    signal_derivator_floor_In = signalDerivatorIn;
    noiseDerivatorIn = noiseFloor;
    while n_Floor >=1%Planta por planta
        if iscell(edificio{n_Floor}) ~=1 %No es celda = no creado
            %Creamos las viviendas en cada planta
            edificio{n_Floor} = cell(nHouses,1);
        end
        %En funcion del numero de plantas y el numero de derivadores disponibles 
        %(para un mismo numero de salidas/viviendas) se elige el derivador mas adecuado
        derivator = round((nFloor-n_Floor + 1)*nDerivators/nFloor);
        %Salida derivador
        signal_derivator_floor_Out = signal_derivator_floor_In - derivators{derivator,3};%derivators{derivator,3}=atenuacion por derivacion
        %Salida de PAU
        signal_pau_floor_out = signal_derivator_floor_Out - frecuency_interpolation(frec,pauInsertionLoss);
        %Ruido salida derivador
        noiseDerivatorOut = noiseDerivatorIn/(10^(derivators{derivator,3}/10)) + (K*fmBW*(10^(derivators{derivator,3}/10) -1)*T0/(10^(derivators{derivator,3}/10)));
        for house_n=1:nHouses%Casa por casa
            [basura,nTomasHouse] = size(housesInOneFloor{house_n});
            %Estructura de edificio
            if iscell(edificio{n_Floor}{house_n}) ~=1 %No es celda = no creado
                %Creamos las tomas de la vivienda
                edificio{n_Floor}{house_n} = cell(nTomasHouse,1);
            end
            vecTomas = toma_algoritmo( tomas,nTomasHouse );
            signalToma = signal_pau_floor_out;%Señal antes de la primera toma de la vivienda (Hay que contar para cada vivienda la distancia)
            %Ruido en PAU y distancia
            noisePAU = noiseDerivatorOut/(10^(frecuency_interpolation(frec,pauInsertionLoss)/10)) + (K*fmBW*(10^(frecuency_interpolation(frec,pauInsertionLoss)/10) -1)*T0/(10^(frecuency_interpolation(frec,pauInsertionLoss)/10)));
            for toma_n=1:nTomasHouse%Toma por toma
                %['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)]%Debug
                %Estructura de edificio
                if iscell(edificio{n_Floor}{house_n}{toma_n}) ~=1 %No es celda = no creado
                    %Creamos los canales para cada toma de la vivienda
                    edificio{n_Floor}{house_n}{toma_n} = cell(nChannels,1);
                end
                if iscell(edificio{n_Floor}{house_n}{toma_n}{n_fm}) ~=1 %No es celda = no creado
                    edificio{n_Floor}{house_n}{toma_n}{n_fm} = cell(3,1);
                end
                dToma = housesInOneFloor{house_n}(toma_n);
                %Atenuacion la señal por distancia
                signalToma = signalToma - dToma*frecuency_interpolation(frec,coaxialFrecuencyAtenuation);
                %Elegimos un tipo de toma
                toma = vecTomas(toma_n);
                %Calculamos la señal que obtenemos en la toma-------------
                %attDerivationdEV =frecuency_interpolation(frec,tomas{toma,2})%debug
                signalTomaFinal = signalToma - frecuency_interpolation(frec,tomas{toma,2});
                edificio{n_Floor}{house_n}{toma_n}{n_fm}{1} = ['FM' num2str(n_fm)];
                edificio{n_Floor}{house_n}{toma_n}{n_fm}{2} = signalTomaFinal;
                if(signalTomaFinal > maxMinSignal{n_fm,2}{2})
                     maxMinSignal{n_fm,1} = ['FM' num2str(n_fm)];
                     maxMinSignal{n_fm,2}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm,2}{2} = signalTomaFinal;
                end
                if(signalTomaFinal < maxMinSignal{n_fm,3}{2})
                     maxMinSignal{n_fm,1} = ['FM' num2str(n_fm)];
                     maxMinSignal{n_fm,3}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm,3}{2} = signalTomaFinal;
                end
                %Calculamos el nivel de SNR en la toma--------------------
                %Primera toma del PAU, el resto de la toma de paso
                if(toma_n == 1)
                    noiseCableToma = noisePAU/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation*housesInOneFloor{house_n}(toma_n))/10));
                else
                    noiseCableToma = noiseTomaPass/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation*housesInOneFloor{house_n}(toma_n))/10));
                end
                %Ruido en la toma
                noiseToma = noiseCableToma/(10^(frecuency_interpolation(frec,tomas{toma,2})/10)) + (K*fmBW*(10^(frecuency_interpolation(frec,tomas{toma,2})/10) -1)*T0/(10^(frecuency_interpolation(frec,tomas{toma,2})/10)));
                %Ruido por paso en la toma
                noiseTomaPass = noiseCableToma/(10^(frecuency_interpolation(frec,tomas{toma,3})/10)) + (K*fmBW*(10^(frecuency_interpolation(frec,tomas{toma,3})/10) -1)*T0/(10^(frecuency_interpolation(frec,tomas{toma,3})/10)));
                snrToma = 10*log10(10^(signalTomaFinal/10)/noiseToma);
                edificio{n_Floor}{house_n}{toma_n}{n_fm}{3} = snrToma;
                
                if(snrToma > maxMinSignal{n_fm,4}{2})
                     maxMinSignal{n_fm,4}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm,4}{2} = snrToma;
                end
                if(snrToma < maxMinSignal{n_fm,5}{2})
                     maxMinSignal{n_fm,5}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm,5}{2} = snrToma;
                end
                
                %Pasamos a la siguiente toma y atenuamos por paso
                %attPasoPaso = frecuency_interpolation(frec,tomas{toma,3})%DEBUG
                signalToma = signalToma - frecuency_interpolation(frec,tomas{toma,3});
            end

        end
        n_Floor = n_Floor - 1; %Bajamos un piso
        %Calculamos la señal que tendra el siguiente derivador
        %derivators{derivator,4} atenuacion por paso para cierta frecuencia
        signal_derivator_floor_In = signal_derivator_floor_In - frecuency_interpolation(frec,derivators{derivator,4}) - dFloor*frecuency_interpolation(frec,coaxialFrecuencyAtenuation);
        noiseDerivatorIn = noiseDerivatorIn/(10^(frecuency_interpolation(frec,derivators{derivator,4})/10)) + (K*fmBW*(10^(frecuency_interpolation(frec,derivators{derivator,4})/10) -1)*T0/(10^(frecuency_interpolation(frec,derivators{derivator,4})/10)));
    end
end

%% Calculo UHF-------------------------------------------------------------
T0 = 290;
initialNoise = K*uhfBW*Ta;
noiseFigure = 9;

for channel=1:n_uhf
    
    frec = frecIntensity(channel,1);
    intensity = frecIntensity(channel,2);
    longOnda = (3*10^8)/(frec*(10^6));%(m)
    
    Ta = frecuency_interpolation(frec,uhfTa);
    %Ruido antena
    noiseUHFAntena = K*uhfBW*Ta + K*uhfBW*(0)*T0;
    %Ruido salida amplificador = (K*fmBW*Ta*Gamp/AttCable + K*fmBW*(fmF-1)*T0/AttCable)*Gamp + K*fmBW*(F-1)*T0*Gamp) 
    noiseAmplifier = noiseUHFAntena/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation)*dUHF/10))*(10^(frecuency_interpolation(frec,uhfAmplifierG)/10)) + (K*uhfBW*(10^(noiseFigure/10) -1)*T0*(10^(frecuency_interpolation(frec,uhfAmplifierG)/10)));
    %Ruido salida distribuidor, usamos la atenuacion por insercion como figura de ruido
    noiseDistrib = noiseAmplifier/(10^(frecuency_interpolation(frec,splitterInsertionLoss)/10)) + (K*uhfBW*(10^(frecuency_interpolation(frec,splitterInsertionLoss)/10) -1)*T0/(10^(frecuency_interpolation(frec,splitterInsertionLoss)/10)));
    %Ruido Combinador
    noiseComb = noiseDistrib/(10^(frecuency_interpolation(frec,combAtenuation)/10)) + (K*uhfBW*(10^(frecuency_interpolation(frec,combAtenuation)/10) -1)*T0/(10^(frecuency_interpolation(frec,combAtenuation)/10)));
    noiseFloor = noiseComb/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation*dFloor)/10));

    
    uhfCampo = 10*log10(intensity);%(dBs)
    %La atenuacion a UHF se obtiene interpolando las frecuencias del coaxial (W)
    signalInAmpl = ((intensity^2) * (longOnda^2) * (10^(frecuency_interpolation(frec,uhfFrecuencyAtenuation)/10))) / ( 4*120*(pi^2)*(dUHF*frecuency_interpolation( frec, coaxialFrecuencyAtenuation )));
    %Atenuación a la salida del amplificador (dBW)
    signalOutAmpl = 10*log10(signalInAmpl) + frecuency_interpolation(frec,uhfAmplifierG);%(dBW) señal a la salida del amplificador
    signalOutDistri = signalOutAmpl - frecuency_interpolation(frec,splitterInsertionLoss);%(dBW) señal tras el distribuidor (duplica para los satelites)
    signalOutComb = signalOutDistri - frecuency_interpolation(frec,combAtenuation);%(dBW) señal tras el combinador
    signalDerivatorIn = signalOutComb - dFloor*frecuency_interpolation(frec,coaxialFrecuencyAtenuation);%(dBW) señal que llega al derivador de planta

    n_Floor= nFloor; %Empezamos calculando desde el piso más alto
    noiseDerivatorIn = noiseFloor;
    signal_derivator_floor_In = signalDerivatorIn;
    while n_Floor >=1%Planta por planta
        if iscell(edificio{n_Floor}) ~=1 %No es celda = no creado
            %Creamos las viviendas en cada planta
            edificio{n_Floor} = cell(nHouses,1);
        end
        %En funcion del numero de plantas y el numero de derivadores disponibles 
        %(para un mismo numero de salidas/viviendas) se elige el derivador mas adecuado
        derivator = round((nFloor-n_Floor + 1)*nDerivators/nFloor);
        %Salida derivador
        signal_derivator_floor_Out = signal_derivator_floor_In - derivators{derivator,3};%derivators{derivator,3}=atenuacion por derivacion
        %Salida de PAU
        signal_pau_floor_out = signal_derivator_floor_Out - frecuency_interpolation(frec,pauInsertionLoss);
        %Ruido salida derivador
        noiseDerivatorOut = noiseDerivatorIn/(10^(derivators{derivator,3}/10)) + (K*uhfBW*(10^(derivators{derivator,3}/10) -1)*T0/(10^(derivators{derivator,3}/10)));
        for house_n=1:nHouses%Casa por casa
            [basura,nTomasHouse] = size(housesInOneFloor{house_n});
            %Estructura de edificio
            if iscell(edificio{n_Floor}{house_n}) ~=1 %No es celda = no creado
                %Creamos las tomas de la vivienda
                edificio{n_Floor}{house_n} = cell(nTomasHouse,1);
            end
            signalToma = signal_pau_floor_out;%Señal antes de la primera toma de la vivienda (Hay que contar para cada vivienda la distancia)
            vecTomas = toma_algoritmo( tomas,nTomasHouse );
            %Ruido en PAU y distancia
            noisePAU = noiseDerivatorOut/(10^(frecuency_interpolation(frec,pauInsertionLoss)/10)) + (K*uhfBW*(10^(frecuency_interpolation(frec,pauInsertionLoss)/10) -1)*T0/(10^(frecuency_interpolation(frec,pauInsertionLoss)/10)));
            for toma_n=1:nTomasHouse%Toma por toma
                %Estructura de edificio
                if iscell(edificio{n_Floor}{house_n}{toma_n}) ~=1 %No es celda = no creado
                    %Creamos los canales para cada toma de la vivienda
                    edificio{n_Floor}{house_n}{toma_n} = cell(nChannels,1);
                end
                if iscell(edificio{n_Floor}{house_n}{toma_n}{n_fm + channel}) ~=1 %No es celda = no creado
                    edificio{n_Floor}{house_n}{toma_n}{n_fm + channel} = cell(3,1);
                end
                dToma = housesInOneFloor{house_n}(toma_n);
                %Atenuacion la señal por distancia
                signalToma = signalToma - dToma*frecuency_interpolation(frec,coaxialFrecuencyAtenuation);
                %Elegimos un tipo de toma
                toma = vecTomas(toma_n);
                %Calculamos la señal que obtenemos en la toma-------------
                signalTomaFinal = signalToma - frecuency_interpolation(frec,tomas{toma,2});
                edificio{n_Floor}{house_n}{toma_n}{n_fm + channel}{1} = num2str(frecIntensity(channel,3));
                edificio{n_Floor}{house_n}{toma_n}{n_fm + channel}{2} = signalTomaFinal;
                
                if(signalTomaFinal > maxMinSignal{n_fm + channel,2}{2})
                     maxMinSignal{n_fm + channel,1} = num2str(frecIntensity(channel,3));
                     maxMinSignal{n_fm + channel,2}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm + channel,2}{2} = signalTomaFinal;
                end
                if(signalTomaFinal < maxMinSignal{n_fm + channel,3}{2})
                     maxMinSignal{n_fm + channel,1} = num2str(frecIntensity(channel,3));
                     maxMinSignal{n_fm + channel,3}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm + channel,3}{2} = signalTomaFinal;
                end
                
                %Calculamos el nivel de SNR en la toma--------------------
                %Primera toma del PAU, el resto de la toma de paso
                if(toma_n == 1)
                    noiseCableToma = noisePAU/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation*housesInOneFloor{house_n}(toma_n))/10));
                else
                    noiseCableToma = noiseTomaPass/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation*housesInOneFloor{house_n}(toma_n))/10));
                end
                %Ruido en la toma
                noiseToma = noiseCableToma/(10^(frecuency_interpolation(frec,tomas{toma,2})/10)) + (K*uhfBW*(10^(frecuency_interpolation(frec,tomas{toma,2})/10) -1)*T0/(10^(frecuency_interpolation(frec,tomas{toma,2})/10)));
                %Ruido por paso en la toma
                noiseTomaPass = noiseCableToma/(10^(frecuency_interpolation(frec,tomas{toma,3})/10)) + (K*uhfBW*(10^(frecuency_interpolation(frec,tomas{toma,3})/10) -1)*T0/(10^(frecuency_interpolation(frec,tomas{toma,3})/10)));
                snrToma = 10*log10(10^(signalTomaFinal/10)/noiseToma);
                edificio{n_Floor}{house_n}{toma_n}{n_fm + channel}{3} = snrToma;
                
                if(snrToma > maxMinSignal{n_fm + channel,4}{2})
                     maxMinSignal{n_fm + channel,4}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm + channel,4}{2} = snrToma;
                end
                if(snrToma < maxMinSignal{n_fm + channel,5}{2})
                     maxMinSignal{n_fm + channel,5}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm + channel,5}{2} = snrToma;
                end
                
                %Pasamos a la siguiente toma y atenuamos por paso
                signalToma = signalToma - frecuency_interpolation(frec,tomas{toma,3});
            end

        end
        n_Floor = n_Floor - 1; %Bajamos un piso
        %Calculamos la señal que tendra el siguiente derivador
        %derivators{derivator,4} atenuacion por paso para cierta frecuencia
        signal_derivator_floor_In = signal_derivator_floor_In - frecuency_interpolation(frec,derivators{derivator,4}) - dFloor*frecuency_interpolation(frec,coaxialFrecuencyAtenuation);
        noiseDerivatorIn = noiseDerivatorIn/(10^(frecuency_interpolation(frec,derivators{derivator,4})/10)) + (K*uhfBW*(10^(frecuency_interpolation(frec,derivators{derivator,4})/10) -1)*T0/(10^(frecuency_interpolation(frec,derivators{derivator,4})/10)));
    end
end



%% Calculo Satelite--------------------------------------------------------
%Hay que pasar de PIRE a mV/m
Ta = satTa;
for sat_n=1:nSAT
    frec = 12500;
    PIRE =satMatrix{sat_n,2};
    longOnda = (3*10^8)/(frec*(10^6));%(m)
    noiseFigure = satAmplifierNoiseFigure;
    
    Aeff = pi*((satDiameter/2)^2);
    Gant = Aeff*4*pi/(longOnda^2);
    Ts = Ta + 290*((10^(0.5/10)-1));
    intensity = (10^(PIRE/10))*Aeff*10^(lnbG/10)*10^(dSAT*frecuency_interpolation(frec,coaxialFrecuencyAtenuation)/10)/(4*pi*(36000000)^2);
    frec = 1550;%Cambio a frecuencia intermedia
    
    noiseSATAntena = K*satBW*Ta + K*satBW*(0)*T0;
    noiseAmplifier = noiseSATAntena/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation)*dSAT/10))*(10^(frecuency_interpolation(frec,satAmplifierG)/10)) + (K*satBW*(10^(noiseFigure/10) -1)*T0*(10^(frecuency_interpolation(frec,satAmplifierG)/10)));
    %Ruido salida distribuidor, usamos la atenuacion por insercion como figura de ruido
    noiseDistrib = noiseAmplifier/(10^(frecuency_interpolation(frec,splitterInsertionLoss)/10)) + (K*satBW*(10^(frecuency_interpolation(frec,splitterInsertionLoss)/10) -1)*T0/(10^(frecuency_interpolation(frec,splitterInsertionLoss)/10)));
    %Ruido Combinador
    noiseComb = noiseDistrib/(10^(frecuency_interpolation(frec,combAtenuation)/10)) + (K*satBW*(10^(frecuency_interpolation(frec,combAtenuation)/10) -1)*T0/(10^(frecuency_interpolation(frec,combAtenuation)/10)));
    noiseFloor = noiseComb/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation*dFloor)/10));

    
    satCampo = 10*log10(intensity);%(dBs)
    %La atenuacion  SAT se obtiene interpolando las frecuencias del coaxial (W)
    signalInAmpl = intensity;
    %Atenuación a la salida del amplificador (dBW)
    signalOutAmpl = 10*log10(signalInAmpl) + frecuency_interpolation(frec,satAmplifierG);%(dBW) señal a la salida del amplificador
    signalOutDistri = signalOutAmpl;%(dBW) señal tras el distribuidor (duplica para los satelites)
    signalOutComb = signalOutDistri - frecuency_interpolation(frec,combAtenuation);%(dBW) señal tras el combinador
    signalDerivatorIn = signalOutComb - dFloor*frecuency_interpolation(frec,coaxialFrecuencyAtenuation);%(dBW) señal que llega al derivador de planta
    
    n_Floor= nFloor; %Empezamos calculando desde el piso más alto
    noiseDerivatorIn = noiseFloor;
    signal_derivator_floor_In = signalDerivatorIn;
    while n_Floor >=1%Planta por planta
        if iscell(edificio{n_Floor}) ~=1 %No es celda = no creado
            %Creamos las viviendas en cada planta
            edificio{n_Floor} = cell(nHouses,1);
        end
        %En funcion del numero de plantas y el numero de derivadores disponibles 
        %(para un mismo numero de salidas/viviendas) se elige el derivador mas adecuado
        derivator = round((nFloor-n_Floor + 1)*nDerivators/nFloor);
        %Salida derivador
        signal_derivator_floor_Out = signal_derivator_floor_In - derivators{derivator,3};%derivators{derivator,3}=atenuacion por derivacion
        %Salida de PAU
        signal_pau_floor_out = signal_derivator_floor_Out - frecuency_interpolation(frec,pauInsertionLoss);
        %Ruido salida derivador
        noiseDerivatorOut = noiseDerivatorIn/(10^(derivators{derivator,3}/10)) + (K*satBW*(10^(derivators{derivator,3}/10) -1)*T0/(10^(derivators{derivator,3}/10)));
        for house_n=1:nHouses%Casa por casa
            [basura,nTomasHouse] = size(housesInOneFloor{house_n});
            %Estructura de edificio
            if iscell(edificio{n_Floor}{house_n}) ~=1 %No es celda = no creado
                %Creamos las tomas de la vivienda
                edificio{n_Floor}{house_n} = cell(nTomasHouse,1);
            end
            vecTomas = toma_algoritmo( tomas,nTomasHouse );
            signalToma = signal_pau_floor_out;%Señal antes de la primera toma de la vivienda (Hay que contar para cada vivienda la distancia)
            %Ruido en PAU y distancia
            noisePAU = noiseDerivatorOut/(10^(frecuency_interpolation(frec,pauInsertionLoss)/10)) + (K*satBW*(10^(frecuency_interpolation(frec,pauInsertionLoss)/10) -1)*T0/(10^(frecuency_interpolation(frec,pauInsertionLoss)/10)));
            for toma_n=1:nTomasHouse%Toma por toma
                %Estructura de edificio
                if iscell(edificio{n_Floor}{house_n}{toma_n}) ~=1 %No es celda = no creado
                    %Creamos los canales para cada toma de la vivienda
                    edificio{n_Floor}{house_n}{toma_n} = cell(nChannels,1);
                end
                if iscell(edificio{n_Floor}{house_n}{toma_n}{nFM + nUHF + sat_n}) ~=1 %No es celda = no creado
                    edificio{n_Floor}{house_n}{toma_n}{nFM + nUHF + sat_n} = cell(3,1);
                end
                dToma = housesInOneFloor{house_n}(toma_n);
                %Atenuacion la señal por distancia
                signalToma = signalToma - dToma*frecuency_interpolation(frec,coaxialFrecuencyAtenuation);
                %Elegimos un tipo de toma
                toma = vecTomas(toma_n);
                %Calculamos la señal que obtenemos en la toma-------------
                signalTomaFinal = signalToma - frecuency_interpolation(frec,tomas{toma,2});
                edificio{n_Floor}{house_n}{toma_n}{nFM + nUHF + sat_n}{1} = satMatrix{sat_n,1};%Nombre del satelite
                edificio{n_Floor}{house_n}{toma_n}{nFM + nUHF + sat_n}{2} = signalTomaFinal;
                
                 if(signalTomaFinal > maxMinSignal{n_fm + n_uhf + sat_n,2}{2})
                     maxMinSignal{n_fm + n_uhf + sat_n,1} = satMatrix(sat_n,1);
                     maxMinSignal{n_fm + n_uhf + sat_n,2}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm + n_uhf + sat_n,2}{2} = signalTomaFinal;
                end
                if(signalTomaFinal < maxMinSignal{n_fm + n_uhf + sat_n,3}{2})
                     maxMinSignal{n_fm + n_uhf + sat_n,1} = satMatrix(sat_n,1);
                     maxMinSignal{n_fm + n_uhf + sat_n,3}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm + n_uhf + sat_n,3}{2} = signalTomaFinal;
                end
                
                %Calculamos el nivel de SNR en la toma--------------------
                %Primera toma del PAU, el resto de la toma de paso
                if(toma_n == 1)
                    noiseCableToma = noisePAU/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation*housesInOneFloor{house_n}(toma_n))/10));
                else
                    noiseCableToma = noiseTomaPass/(10^(frecuency_interpolation(frec,coaxialFrecuencyAtenuation*housesInOneFloor{house_n}(toma_n))/10));
                end
                %Ruido en la toma
                noiseToma = noiseCableToma/(10^(frecuency_interpolation(frec,tomas{toma,2})/10)) + (K*satBW*(10^(frecuency_interpolation(frec,tomas{toma,2})/10) -1)*T0/(10^(frecuency_interpolation(frec,tomas{toma,2})/10)));
                %Ruido por paso en la toma
                noiseTomaPass = noiseCableToma/(10^(frecuency_interpolation(frec,tomas{toma,3})/10)) + (K*satBW*(10^(frecuency_interpolation(frec,tomas{toma,3})/10) -1)*T0/(10^(frecuency_interpolation(frec,tomas{toma,3})/10)));
                snrToma = 10*log10(10^(signalTomaFinal/10)/noiseToma);
                edificio{n_Floor}{house_n}{toma_n}{n_fm + n_uhf + sat_n}{3} = snrToma;
                
                if(snrToma > maxMinSignal{n_fm + n_uhf + sat_n,4}{2})
                     maxMinSignal{n_fm + n_uhf + sat_n,4}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm + n_uhf + sat_n,4}{2} = snrToma;
                end
                if(snrToma < maxMinSignal{n_fm + n_uhf + sat_n,5}{2})
                     maxMinSignal{n_fm + n_uhf + sat_n,5}{1} = ['floor=' num2str(n_Floor) ' house=' num2str(house_n) ' toma=' num2str(toma_n)];
                     maxMinSignal{n_fm + n_uhf + sat_n,5}{2} = snrToma;
                end
                
                %Pasamos a la siguiente toma y atenuamos por paso
                signalToma = signalToma - frecuency_interpolation(frec,tomas{toma,3});
            end

        end
        n_Floor = n_Floor - 1; %Bajamos un piso
        %Calculamos la señal que tendra el siguiente derivador
        %derivators{derivator,4} atenuacion por paso para cierta frecuencia
        signal_derivator_floor_In = signal_derivator_floor_In - frecuency_interpolation(frec,derivators{derivator,4}) - dFloor*frecuency_interpolation(frec,coaxialFrecuencyAtenuation);
        noiseDerivatorIn = noiseDerivatorIn/(10^(frecuency_interpolation(frec,derivators{derivator,4})/10)) + (K*satBW*(10^(frecuency_interpolation(frec,derivators{derivator,4})/10) -1)*T0/(10^(frecuency_interpolation(frec,derivators{derivator,4})/10)));
    end
end


%% Calculadora Precio
%Precio de tomas y derivadores ya añadido arriba
precioTotal = precioTotal + neededCombs*combPrice;                                                                                           %Combinadores
precioTotal = precioTotal + neededUHFChanelAmplifiers*uhfAmplifierPrice;                                                                     %Amplificadores UHF
precioTotal = precioTotal + 1*fmAmplifierPrice;                                                                                              %Amplificadores FM
precioTotal = precioTotal + n_sat*satAmplifierPrice;                                                                                         %Amplificadores SAT
precioTotal = precioTotal + neededPrincipalSplitter * splitterPrice;                                                                         %Splitter principal
precioTotal = precioTotal + neededSateliteAntenna*satPricePerUnit + neededFMAntenna*fmPricePerUnit + neededUHFAntenna*uhfPricePerUnit;       %Antenas
precioTotal = precioTotal + neededCoaxial*coaxialPricePerUnit;                                                                               %Precio de cable
precioTotal = precioTotal + n_sat*lnbPricePerUnit;                                                                                           %Precio LNBs
precioTotal = precioTotal + nTomasTotal*impedancePricePerUnit;                                                                               %Impedancias
precioTotal = precioTotal + nViviendasTotal*pauPricePerUnit;                                                                                 %PAU
precioSinIva = precioTotal
precioConIva = precioSinIva * (1 + IVA)

