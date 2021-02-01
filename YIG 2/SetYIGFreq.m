%sets center freq for YIG2, displays new input frequency
%input freq in Hz

function SetYIGFreq(cFreq) %Hz
    if cFreq < 2000 || cFreq > 26000
        error('Centre frequency must be 2000-240000 MHz')
    else
        fprintf(yig.obj, sprintf('F%.3f', cFreq/1e6))
        centre_frequency = query(yig.obj,'R0016?')
    end
end