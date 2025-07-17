%Tugas Praktikum 2%

%NAMA   : RIYAN

%Memuat package yang dibutuhkan histogram
pkg load image;

% 1. Menampilkan Histogram
img = imread('D:\DATA PRAKTIKUM CITRA\zakia.png');
img = im2uint8(img); %gambar dalam format uint8
figure;
imhist(img);
title('Histogram Normal');

figure;
R =img(:, :, 1); %Pisahkan Channel RGB
G =img(:, :, 2);
B =img(:, :, 3);

subplot(3,1,1);
imhist(R);
title('Histogram Merah');
xlim([0 255]);

subplot(3,1,2);
imhist(G);
title('Histogram Hijau');
xlim([0 255]);

subplot(3,1,3);
imhist(B);
title('Histogram Biru');
xlim([0 255]);

pkg load image;

% 2. Meningkatkan Kecerahan
%kecerahan hitam putih
img = imread('D:\DATA PRAKTIKUM CITRA\image\ikan-1.png');
imgGray = rgb2gray(img);
imgCerah = imgGray + 80;

figure;
subplot(2,2,1);
imshow (imgGray);
title('Hasil Gambar Normal');

subplot(2,2,3);
imhist (imgCerah);
title('Hasil Histogram');

subplot(2,2,2);
imshow(imgCerah);
title('Hasil Meningkatkan Kecerahan Gray');
pkg load image;

%kecerahan berwarna
RGB = imread('D:\DATA PRAKTIKUM CITRA\zakia.png');
RGB2 = RGB + 80;

figure;
subplot(2,2,1);
imshow (img);
title('Hasil Gambar Normal');

subplot(2,2,3);
imhist (RGB2);
title('Hasil Histogram');

subplot(2,2,2);
imshow(RGB2);
title('Hasil Meningkatkan Kecerahan RGB');
pkg load image;

% 3. Merenggangkan Kontras
img = imread('D:\DATA PRAKTIKUM CITRA\image\gedung.png');
MK = 2.5 * img;

KM = MK;

figure;
subplot(2,2,1);
imshow (img);
title('Hasil Gambar Normal');

subplot(2,2,3);
imhist(MK);
title('Hasil Histogram');

subplot(2,2,2);
imshow (KM);
title('Hasil Merenggangkan Kontras');
pkg load image;

% 4. Kombinasi Kecerahan & Kontras
img = imread('D:\DATA PRAKTIKUM CITRA\image\lapangan.tif');
KC = img - 12;
TK = KC * 2;

KT = TK;

figure;
subplot(2,2,1);
imshow (img);
title('Hasil Gambar Normal');

subplot(2,2,3);
imhist(KT);
title('Hasil Histogram');

subplot(2,2,2);
imshow (TK);
title('Hasil Kombinasi Kecerahan & Kontras');
pkg load image;

% 5. Membalik Citra
P = 255 - imgGray;

HP = P;

figure;
subplot(2,2,1);
imshow (imgGray);
title('Hasil Gambar Normal');

subplot(2,2,3);
imhist(HP);
title('Hasil Histogram');

subplot(2,2,2);
imshow (P);
title('Hasil Membalik Citra');
pkg load image;

% 6. Pemetaan Nonlinear
C1 = log (1+double(imgGray));
C2 = im2uint8(mat2gray(C1));

C3 = C2;

figure;
subplot(2,2,1);
imshow (imgGray);
title('Hasil Gambar Normal');

subplot(2,2,2);
imshow (C2);
title('Hasil Pemetaan Nonlinear');

subplot(2,2,3);
imhist(C3);
title('Hasil Histogram');
pkg load image;

% 7. Pemotongan Aras Keabuan (Menghilangkan Backgroud)
img = imread('D:\DATA PRAKTIKUM CITRA\image\ipomoea.tif');
imgGray = rgb2gray(img); % Konversi ke grayscale

threshold = 150; % Nilai threshold
imgThreshold = imgGray; % Buat salinan terlebih dahulu
imgThreshold(imgGray <= threshold) = 0; % Piksel di bawah threshold dibuat hitam
imgThreshold(imgGray > threshold) = 255; % Piksel di atas threshold dibuat putih

figure;
subplot(2,2,1);
imshow(imgGray);
title('Hasil Gambar Normal');

subplot(2,2,2);
imhist(imgGray);
title('Hasil Histogram Normal');

subplot(2,2,3);
imshow(imgThreshold);
title('Hasil Pemotongan Aras Keabuan (Menghilangkan Background)');

subplot(2,2,4);
imhist(imgThreshold);
title('Hasil Histogram');
pkg load image;

#8.Ekualisasi Histogram
img = imread('D:\DATA PRAKTIKUM CITRA\image\sungai.png');
imgGray = rgb2gray(img);
imgCerah = imgGray + 80;

imgEqual = histeq(imgGray);

figure;
subplot(2,2,2);
imhist (imgCerah);
title('Hasil Histogram');

subplot(2,2,1);
imshow(imgCerah);
title('Hasil Normal');

subplot(2,2,3);
imshow(imgEqual);
title('Hasil Gambar Ekualisasi Histogram');

subplot(2,2,4);
imhist(imgEqual);
title('Hasil Ekualisasi Histogram ');
pkg load image;

