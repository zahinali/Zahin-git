clear
format long

%open connections
yig = open_instrument_connection_generic('YIG 2')
obj_vna = OpenVNAconnection;
obj_vna.Timeout = 1000;

%set constants
n_avg = 4;
n_f_pts = 400; % number of frequency points in each measurement
vna_BW = 10000;
p_fixed = -10; % fixed power in case of no sweep. dbm
f_span = 1e9;

n_val = 23; % n measurements across YIG frequency span
centre_freq = linspace(2e9,24e9,n_val);
insertion_loss = NaN(1,n_val); % initialise array of size [1 x n_val]

for k = 1:n_val
    SetYIGFreq(centre_freq(k));
    status = ConfigureVNAS21(obj_vna,centre_freq(k)-f_span/2,centre_freq(k)+f_span/2,p_fixed,...
    n_f_pts, vna_BW, n_avg);
    fprintf(obj_vna, 'INITIATE:IMMEDIATE; *WAI');
    amp = (str2num(VNAReadTrace(obj_vna,'mlog')));
    f_span=str2num(query(obj_vna,':SENS:FREQ:SPAN?'));
    freq = linspace(centre_freq(k)-f_span/2,centre_freq(k)+f_span/2,n_f_pts);
    insertion_loss(k) = max(amp);
    freq_shifted = freq - centre_freq(k); %so if YIG is working as expected the peak will be centred at zero
    amp_shifted = amp + 30 * k; %stack each measurement on top of each other
    
    figure(1);
    details = strcat('Start frequency = ', num2str(centre_freq(1)/1e9), ' GHz. End frequency = ', num2str(centre_freq(n_val)/1e9),...
        ' GHz. Frequency increment = ',num2str((centre_freq(2)-centre_freq(1))/1e9), ' GHz. Number of measurements = ', num2str(n_val));
    plot(freq_shifted/1e9,amp_shifted)
    xlabel('Relative frequency')
    ylabel('Amplitude (dB)')
    title(details)
    hold on
end

figure(2);
clf
bar(centre_freq/1e3, insertion_loss)
xlabel('Set centre frequency (GHz)')
ylabel('Insertion loss (dB)')

%save data
fpath = strcat('P:\Solid State QT\equipment&electronics\YIG filters\VNA response data\');
fname1 = strcat('vna response ', date);
fname2 = strcat('insertion loss ', date);
saveas(figure(1),strcat(fpath, fname1), 'png')
saveas(figure(1),strcat(fpath, fname1), 'fig')
saveas(figure(2),strcat(fpath, fname2), 'png')
saveas(figure(2),strcat(fpath, fname2), 'fig')

%close connections
if strcmp(obj_vna.status,'open')
    fclose(obj_vna);
end

if strcmp(yig.obj.status,'open')
    fclose(obj_vna);
end