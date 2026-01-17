%% 1. ADIM: Modellerin Eğitilmesi
try
    data = readtable('Train_data.xlsx');
    X_norm = [data{:,1}/100, data{:,2}/1000];
    Y_eps_norm = data{:,3}/10;
    Y_tnd_raw = data{:,4};
catch
    error('Train_data.xlsx bulunamadı!');
end

% ANFIS Ayarları
opt = genfisOptions('GridPartition','NumMembershipFunctions',[5 5],'InputMembershipFunctionType','gbellmf');
fis_eps = genfis(X_norm, Y_eps_norm, opt);
fis_tnd = genfis(X_norm, Y_tnd_raw, opt);

% Eğitim (Epoch ayarları makale ile uyumlu)
fis_eps = anfis([X_norm, Y_eps_norm], anfisOptions('InitialFIS', fis_eps, 'EpochNumber', 5000, 'DisplayANFISInformation', 0));
fis_tnd = anfis([X_norm, Y_tnd_raw], anfisOptions('InitialFIS', fis_tnd, 'EpochNumber', 500, 'DisplayANFISInformation', 0));

%% 2. ADIM: Figür 9 Çizimi (Oklar ve Üçgen MF'ler)
input_T = -30; input_F = 50; 
val_eps = evalfis(fis_eps, [input_T/100, input_F/1000]) * 10;
val_tnd = evalfis(fis_tnd, [input_T/100, input_F/1000]) * 1e-4;

figure('Color', 'w', 'Position', [100 100 1000 550], 'Name', 'Fig 9 - Simulink Style');
axis off; hold on; xlim([0 15]); ylim([0 10]);

% --- GİRİŞ BLOKLARI ---
rectangle('Position', [0.5 7 1.2 1], 'LineWidth', 1); 
text(1.1, 7.5, num2str(input_T), 'HorizontalAlignment', 'center', 'FontSize', 11);
text(1.1, 6.7, 'Temperature', 'HorizontalAlignment', 'center', 'FontSize', 10);

rectangle('Position', [0.5 2 1.2 1], 'LineWidth', 1); 
text(1.1, 2.5, num2str(input_F), 'HorizontalAlignment', 'center', 'FontSize', 11);
text(1.1, 1.6, 'Frequency', 'HorizontalAlignment', 'center', 'FontSize', 10);

% --- KAZANÇ ÜÇGENLERİ (Gain) ---
patch([2.5 2.5 3.8], [6.5 8.5 7.5], 'w', 'LineWidth', 1); text(2.6, 7.5, '1/100', 'FontSize', 9);
patch([2.5 2.5 3.8], [1.5 3.5 2.5], 'w', 'LineWidth', 1); text(2.6, 2.5, '1/1000', 'FontSize', 9);

% --- MUX (Siyah Çubuk) ---
rectangle('Position', [5 3.5 0.3 3], 'FaceColor', 'k');

% --- ANFIS BLOKLARI (ÜÇGEN ÇİZİMLERİ - TRIMF) ---
% ANFIS_tnd
rectangle('Position', [6.5 7 2.5 2], 'LineWidth', 1);
text(7.75, 6.6, 'ANFIS_tnd', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
% Üçgen Üyelik Fonksiyonu Simgeleri
plot([6.8 7.2 7.6], [7.5 8.5 7.5], 'k', 'LineWidth', 0.8); 
plot([7.3 7.7 8.1], [7.5 8.5 7.5], 'k', 'LineWidth', 0.8);
plot([7.8 8.2 8.6], [7.5 8.5 7.5], 'k', 'LineWidth', 0.8);

% ANFIS_eps
rectangle('Position', [6.5 1.2 2.5 2], 'LineWidth', 1);
text(7.75, 0.8, 'ANFIS_eps', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
plot([6.8 7.2 7.6], [1.7 2.7 1.7], 'k', 'LineWidth', 0.8); 
plot([7.3 7.7 8.1], [1.7 2.7 1.7], 'k', 'LineWidth', 0.8);
plot([7.8 8.2 8.6], [1.7 2.7 1.7], 'k', 'LineWidth', 0.8);

% --- ÇIKIŞ KAZANCI VE GÖSTERGELER ---
patch([10.5 10.5 11.8], [1.5 3.5 2.5], 'w', 'LineWidth', 1); text(10.7, 2.5, '10', 'FontSize', 10);

rectangle('Position', [11.5 7.4 2.8 1], 'LineWidth', 1); 
text(12.9, 7.9, sprintf('%.6f', val_tnd), 'HorizontalAlignment', 'center', 'FontSize', 11);
text(12.9, 7.1, 'tnd', 'HorizontalAlignment', 'center', 'FontSize', 10);

rectangle('Position', [12.5 2 2 1], 'LineWidth', 1); 
text(13.5, 2.5, sprintf('%.3f', val_eps), 'HorizontalAlignment', 'center', 'FontSize', 11);
text(13.5, 1.7, 'eps', 'HorizontalAlignment', 'center', 'FontSize', 10);

% --- SİMULİNK OKLARI (Arrowheads) ---
% Fonksiyon: Ok başı ekle
draw_arrow = @(x,y,u,v) annotation('arrow',[(x)/15 (x+u)/15],[(y)/10 (y+v)/10],'HeadStyle','vback2','HeadWidth',7,'HeadLength',7);

% Bağlantılar ve Oklar
line([1.7 2.5], [7.5 7.5], 'Color', 'k'); draw_arrow(2.3, 7.5, 0.2, 0); % Temp to Gain
line([1.7 2.5], [2.5 2.5], 'Color', 'k'); draw_arrow(2.3, 2.5, 0.2, 0); % Freq to Gain
line([3.8 4.4 4.4 5], [7.5 7.5 5.5 5.5], 'Color', 'k'); draw_arrow(4.8, 5.5, 0.2, 0); % Gain1 to Mux
line([3.8 4.4 4.4 5], [2.5 2.5 4.5 4.5], 'Color', 'k'); draw_arrow(4.8, 4.5, 0.2, 0); % Gain2 to Mux
line([5.3 6 6 6.5], [5 5 8.2 8.2], 'Color', 'k'); draw_arrow(6.3, 8.2, 0.2, 0); % Mux to ANFIS_tnd
line([6 6 6.5], [5 2.2 2.2], 'Color', 'k'); draw_arrow(6.3, 2.2, 0.2, 0); % Mux to ANFIS_eps
line([9 11.5], [8.2 8.2], 'Color', 'k'); draw_arrow(11.3, 8.2, 0.2, 0); % ANFIS_tnd to Display
line([9 10.5], [2.2 2.2], 'Color', 'k'); draw_arrow(10.3, 2.2, 0.2, 0); % ANFIS_eps to Gain
line([11.8 12.5], [2.5 2.5], 'Color', 'k'); draw_arrow(12.3, 2.5, 0.2, 0); % Gain to Display

title('Fig. 9 – A simulation user interface with ANFIS models.', 'FontSize', 13, 'FontWeight', 'bold');
hold off;