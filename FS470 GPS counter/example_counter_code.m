%Example script for using the FS740 GPS rubidium counter to take gapless
%measurements
%Configured for front input use
%User should set parameters below: gateTime, sampleCount and blockSize
%before running. Data transfer_timeout and bufferSize are additional
%input arguments for opening the connection with the counter
%% 

%set parameters
gateTime = 0.01; %time interval in s of measurements
sampleCount = 1e6; %total number of measurements
blockSize = 1000; %after this many measurements, data will be transferred to data set
transfer_timeout = 10; %timeout in s for data transfer of block
bufferSize = 250000;

disp('Parameters set')
%% 

total_time = gateTime * sampleCount;
if total_time > 3600
    total_time = total_time/3600
    disp(sprintf('Total measurement time = %.3f hrs',total_time/3600))
else
    disp(sprintf('Total measurement time = %.3f s', total_time))
end

    
time_axis = linspace(0, total_time, sampleCount);
no_iterations = sampleCount / blockSize;
data = [];

%% 
%open connection with counter, configure and start measurement
tGpsC = open_instrument_connection_generic('RUBIDIUM', 0, bufferSize, transfer_timeout)

Configure_counter_fs740(tGpsC,gateTime,sampleCount)
disp('Counter configured')

Start_counter_fs740(tGpsC)
disp('Measurement in progress')
%% 

%waits for n=blockSize measurements to be ready, 
%once ready reads and appends data to data set and repeats until 
%n=sampleCount measurements are complete

for k=1:no_iterations
    
   Counter_block_ready(tGpsC, blockSize, gateTime);
   
   dataBlock = Counter_block_read(tGpsC,blockSize);
   data = [data, dataBlock];
end

%% 

disp('Measurement complete!')

%plot frequency over time
plot(time_axis/3600,data/1e6)
xlabel('Time / hours')
ylabel('Frequency / MHz')
title(sprintf('Frequency stability of %d measurements with gate time %f s', sampleCount, gateTime))

fclose(tGpsC.obj)
