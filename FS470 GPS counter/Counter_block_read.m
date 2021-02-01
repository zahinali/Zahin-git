function dataBlock = Counter_block_read(tGpsC,blockSize)
dataBlock = str2num(query(tGpsC.obj, sprintf('DATA:REMove? %u', blockSize)));
end
