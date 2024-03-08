%% khoi tao.
datasetFolder = 'C:\Users\hoain\OneDrive\Documents\New_Matlab\EEGnetDATA-main\EEGnetDATA-main';
load(fullfile(datasetFolder,"SNR-7.mat")); 
load(fullfile(datasetFolder,"EEG_all_epochs.mat"))

num_vectors = 4512;
num_linewidths = 20; % Số lượng các giá trị linewidth từ 1 đến 20
RMSE_table = zeros(num_vectors, num_linewidths);
%% setting 
time = 1:512;
width_fig                   = 480*(time(end)-time(1));
height_fig                  = 100;
MinBranchLength             = 50;
target                      = length(time);
UDR_amp_matrix = zeros(20, 512);
%%
for j = 1250:1300
    signal = SNRnegative7(j,:); % Lấy dữ liệu từ mỗi vector
    % RMSE_vector = zeros(1, num_linewidths);
    % Tính toán RMSE cho từng Linew idth và lưu vào RMSE_vector
    for i = 2:20
        linewidth = i;     
        [UDR_time, UDR_amp] = UDR(signal, time, width_fig, height_fig, linewidth, MinBranchLength, target);
        UDR_amp_matrix(i, :) = UDR_amp;
    end
    
    % Lưu RMSE_vector vào bảng kết quả
    OriginSignal = repmat(EEG_all_epochs(j,:),20,1);
    RMSE_values = rmse(OriginSignal, UDR_amp_matrix,2);
    RMSE_table(j,:) = RMSE_values';
end

