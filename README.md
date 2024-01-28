# EEGnetDATA

 Mỗi file tương ứng với SNR đèu được mix theo công thức trong phần **2 data usage** tron paper : [https://arxiv.org/pdf/2009.11662.pdf](url) .
 
 Mix giữa hai tín hiệu EEG clean(4514x512) và nhiễu cơ là EMG(5598x512) - với tham số 4514 và 5598 tương ứng với 4514 segments của EEG clean và 5598 segments nhiễu EMG.
 Các file SNR(-7 đến 4) đều chứa dữ liệu được mix với SNR tương ứng từ -7 đến 4 với đoạn code để mix như sau : 

 function y = createNoisySegment(eeg,artifact,SNR)

    k = 10^(SNR/10);
    lambda = (1/k)*rms(eeg,2)/rms(artifact,2);

    y = eeg + lambda * artifact;
    save('tenfile.mat', "y");
end

Các file đều được lưu ở dạng file ".mat", với kích thước là một ma trận 4512x512 tương ứng là 4512 segments đầu tiên trong hai dữ liệu EEG clean và EMG được mix với nhau để tạo ra nhiễu.
