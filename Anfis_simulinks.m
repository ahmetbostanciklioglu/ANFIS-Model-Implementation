%% Step 1: Veri Yükleme
try
    train_tbl = readtable('Train_data.xlsx');
    training_data = train_tbl{:,:}; 
catch
    error('Train_data.xlsx bulunamadı.');
end

train_inputs = training_data(:, 1:2);
train_eps = training_data(:, 3);
train_tnd = training_data(:, 4);

%% Step 2: Normalizasyon (Simulink Fig 9 ile Birebir)
train_inputs_norm = [train_inputs(:,1)/100, train_inputs(:,2)/1000];
train_eps_norm = train_eps / 10;
train_tnd_raw = train_tnd; 

anfis_data_eps = [train_inputs_norm, train_eps_norm];
anfis_data_tnd = [train_inputs_norm, train_tnd_raw];

%% Step 3: ANFIS Eğitimi (Makale Metodolojisi: Grid Partitioning + GbellMF)
disp('ANFIS Eğitiliyor (Makale Ayarları Uygulanıyor)...');

% Girişler için 5'er adet 'gbellmf' tanımla
opt_eps = genfisOptions('GridPartition');
opt_eps.NumMembershipFunctions = [5 5]; % Her giriş için 5 MF 
opt_eps.InputMembershipFunctionType = 'gbellmf'; 

opt_tnd = genfisOptions('GridPartition');
opt_tnd.NumMembershipFunctions = [5 5];
opt_tnd.InputMembershipFunctionType = 'gbellmf';

% FIS Yapılarını Oluştur (25 Kural Oluşturulur) 
fis_eps = genfis(train_inputs_norm, train_eps_norm, opt_eps);
fis_tnd = genfis(train_inputs_norm, train_tnd_raw, opt_tnd);

% Model eps için 5000 Epoch eğitim 
trainOpt_eps = anfisOptions('InitialFIS', fis_eps, 'EpochNumber', 5000, 'DisplayANFISInformation', 0);
fis_eps = anfis(anfis_data_eps, trainOpt_eps);

% Model tnd için 500 Epoch eğitim 
trainOpt_tnd = anfisOptions('InitialFIS', fis_tnd, 'EpochNumber', 500, 'DisplayANFISInformation', 0);
fis_tnd = anfis(anfis_data_tnd, trainOpt_tnd);

disp('Eğitim Makale Standartlarında Tamamlandı.');

%% Step 4: Figür 10 Oluşturma
% Uyarı almamak için 50 Hz'den başlatıyoruz (Veri setinin başlangıcı)
freq_range = linspace(50, 10000, 100); 
temps_to_plot = [20, 50, 80];
styles = {'-', '--', ':'}; 

figure('Name', 'Fig-10–Frequency-Tloss-graph', 'Color', 'w'); hold on;

for i = 1:length(temps_to_plot)
    T_val = temps_to_plot(i);
    
    % Input Hazırlama
    input_T_norm = (T_val / 100) * ones(size(freq_range));
    input_F_norm = freq_range / 1000;
    eval_inputs = [input_T_norm', input_F_norm'];
    
    % Tahmin
    pred_eps_norm = evalfis(fis_eps, eval_inputs);
    pred_tnd = evalfis(fis_tnd, eval_inputs);
    
    % Birimleri geri çevir ve T_loss hesapla
    % T_loss = Eps * F * TanDelta
    eps_val = pred_eps_norm * 10;
    tan_delta_real = pred_tnd * 1e-4; 
    
    t_loss = eps_val .* freq_range' .* tan_delta_real;
    
    % Çizim
    plot(freq_range, t_loss, 'k', 'LineStyle', styles{i}, 'LineWidth', 2);
end

xlabel('Frequency (Hz)');
ylabel('T_{loss}');
legend('20 ^\circC', '50 ^\circC', '80 ^\circC', 'Location', 'NorthWest');
title('Fig. 10 – Frequency vs. Tloss graph for each temperature value.');
grid on;
hold off;