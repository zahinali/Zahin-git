function Counter_block_ready(tGpsC, blockSize, gateTime)

nr_measurements = 0;
while nr_measurements < blockSize
    nr_measurements = str2num(query(tGpsC.obj, 'DATA:POINts?'));
    pause(gateTime)
end

