function [ atenuation ] = frecuency_interpolation( frec, frecAtenuation )
    %FRECUENCY_INTERPOLATION
    % Interpola la frecuencia para obtener una atenuacion entre dos valores.
    %
    % |__Frecuency (Mhz)__|__Atenuation (dB)__|
    % |________482________|_________12________|
    %
    %Example of frecuency atenuation table:
    %
    %uhfFrecuencyAtenuation = [
    %    482, 12; % Multiplex 22 = Gol, DisneyChannel...
    %    530, 13.3;   % Multiplex 28 = Atreseries HD, RealMadrid TV...
    %    546, 13.6; % Multiplex 30 = Telecinco/HD, Cuatro/HD...
    %    570, 13.9;   % Multiplex 33 = TDT/HD, DKiss...
    %    626, 14.9; % Multiplex 40 = Aragon TV, Aragon 2 TV...
    %    642, 15.3;   % Multiplex 42 = Boing, Energy, Mega, 13TV...
    %    674, 15.7; % Multiplex 46 = La 1/HD, La 2...
    %    738, 17; % Multiplex 54 = Antena 3/HD, LaSexta/HD...
    %];
    % For frec=560 the atenuation value will be 13.775
    [y,x]=size(frecAtenuation);
    atenuation = frecAtenuation(1,2);
    for i=1:y
        if(frec < frecAtenuation(i,1))
            atenuation = frecAtenuation(i,2);
            if(i-1 >= 1)
                atenuation = interp1([frecAtenuation(i-1,1),frecAtenuation(i,1)],[frecAtenuation(i-1,2),frecAtenuation(i,2)],frec);
            end
            break;
        end
    end
end

