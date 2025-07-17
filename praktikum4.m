%Tugas operasi geometrik%

%NAMA   : RIYAN

pkg load image;  % Pastikan paket image sudah terinstal

%% 1. Memuat Citra
try
    % Ganti path berikut sesuai dengan lokasi citra yang Anda miliki
    img = imread('D:\tugas kuliah\pemrograman\pengolahan citra\operasi geometrik\senku.jpg');
catch
    disp('Citra tidak ditemukan. Menggunakan fallback "peppers.png".');
    img = imread('peppers.png');
end

img_double = im2double(img);
[rows, cols, channels] = size(img_double);
[X, Y] = meshgrid(1:cols, 1:rows);

%% 2. Definisi Parameter Transformasi
% Translation (pergeseran)
tx = 20;              % Geser ke kanan 20 piksel
ty = 30;              % Geser ke bawah 30 piksel

% Scaling (penskalaan)
scaleX = 1.1;         % Perbesar secara horizontal 10%
scaleY = 0.9;         % Perkecil secara vertikal 10%

% Rotation (rotasi)
theta = pi/18;        % Rotasi sekitar 10° (pi/18 radian)

% Flip horizontal (pembalikan secara horizontal)
flip_flag = true;     % Jika true, lakukan flip horizontal

% Ripple effect (efek gelombang)
ripple_amp = 10;      % Amplitudo ripple (piksel)
ripple_freq = 3;      % Frekuensi ripple

% Tentukan pusat citra untuk operasi penskalaan dan rotasi
cx = cols / 2;
cy = rows / 2;

%% 3. Gabungkan Semua Efek Operasi Geometrik Secara Runtut
% a. Translation: Menggeser koordinat
X_t = X + tx;
Y_t = Y + ty;

% b. Scaling: Melakukan penskalaan relatif terhadap pusat
X_s = scaleX * (X_t - cx) + cx;
Y_s = scaleY * (Y_t - cy) + cy;

% c. Rotation: Memutar citra sekitar pusat
X_r = cos(theta) * (X_s - cx) - sin(theta) * (Y_s - cy) + cx;
Y_r = sin(theta) * (X_s - cx) + cos(theta) * (Y_s - cy) + cy;

% d. Flip Horizontal: Membalik citra secara horizontal
if flip_flag
    X_f = cols - X_r + 1;
else
    X_f = X_r;
end
Y_f = Y_r;  % Tidak ada flip vertikal

% e. Ripple Effect: Menerapkan efek gelombang pada kedua sumbu
X_final = X_f + ripple_amp * sin(2 * pi * ripple_freq * Y_f / rows);
Y_final = Y_f + ripple_amp * sin(2 * pi * ripple_freq * X_f / cols);

%% 4. Interpolasi dan Pemetaan Citra ke Efek Gabungan
img_transformed = zeros(size(img_double));
for ch = 1:channels
    img_transformed(:,:,ch) = interp2(X, Y, img_double(:,:,ch), X_final, Y_final, 'linear', 0);
end
img_out = im2uint8(img_transformed);

%% 5. Tampilkan Hasil pada Figure
figure;
set(gcf, 'Name', 'Operasi Geometrik', 'NumberTitle', 'off');
subplot(1,2,1);
imshow(img);
title('Citra Asli');

subplot(1,2,2);
imshow(img_out);
title('Gabungan Operasi Geometrik');

% Simpan hasil ke file jika diinginkan
% imwrite(img_out, 'gabungan_operasi_geometrik.png');
% disp('Gambar hasil gabungan efek telah disimpan sebagai "gabungan_operasi_geometrik.png".');

