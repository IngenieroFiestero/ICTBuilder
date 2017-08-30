function [ vecTomas ] = toma_algoritmo( tomas,nTomasHouse )
%TOMA_ALGORITMO
% Permite seleccionar la mejor combinación de las tomas para evitar que
% haya mucha diferencia de potencia entre varias.
% Estructura de la celda(cell)
%
% |_____________|__Atenuation_Conexion(dB)__|___Atenuation_Pass(dB)___|__Perdidas_de_retorno_(dB)__|
% |____Toma_1___|___[5,4;862,4;950,4.4;]____|__[5,4;862,4;950,4.4;]___|_____________25_____________|
    [nTomas,basura]=size(tomas);
    vecTomas = zeros(1,nTomasHouse);
    for toma_n=1:nTomasHouse
        if(toma_n == nTomasHouse)%Si es la ultima toma ponemos la final
            vecTomas(toma_n) = nTomas;%La toma es la ultima
        else%Si no es la ultima toma
            vecTomas(toma_n) = round(toma_n*(nTomas-1)/(nTomasHouse-1));%La toma elegida no puede ser la ultima
            if(vecTomas(toma_n) <= 0)
                vecTomas(toma_n) = 1;
            end
        end
    end
end

