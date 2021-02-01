%Configures the FS740 counter in gapless mode with gateTime, sampleCount
%to prepare for initiation of measurement 

function Configure_counter_fs740(tGpsC,gateTime,sampleCount)


%clear all present data, reset
fprintf(tGpsC.obj, '*RST')
fprintf(tGpsC.obj, '*CLS')
flushinput(tGpsC.obj)
flushoutput(tGpsC.obj)

timeout = 1; %s, default
fprintf(tGpsC.obj,sprintf('SENSe:FREQuency:TIMeout %.3f', timeout))

fprintf(tGpsC.obj, sprintf('SAMPle:COUNt %f', sampleCount))

if gateTime < 10e-6 || gateTime > 1000
    error('Gate time must be 10 ms - 1000 s')
    return
end

fprintf(tGpsC.obj, sprintf('SENSe:FREQuency:GATE %.3f', gateTime))

fprintf(tGpsC.obj, 'INPut:LEVel DEFault')
fprintf(tGpsC.obj, 'INPut:SLOPe DEFault')
end

