%tugas praktikum 1%

%NAMA   : RIYAN

%membaca citra%
Img = imread ('D:\DATA PRAKTIKUM CITRA\image\boneka.tif');

%menampilkan citra%

imshow(Img);

%menampilkan ukuran citra%

Ukuran = size(Img);

%mengkonversi citra warna ke grayscale%

RGB = imread ('D:\DATA PRAKTIKUM CITRA\image\dedaunan.png');
Abu = rgb2gray(RGB);
imshow(Abu);

%mengkonversi citra grayscale ke biner%

Img = imread('D:\DATA PRAKTIKUM CITRA\image\gedung.tif');
[tinggi, lebar] = size(Img);
ambang = 210; % Nilai ini bisa diubah-ubah
Biner = zeros(tinggi, lebar);
for baris=1 : tinggi
for kolom=1 : lebar
if Img(baris, kolom) >= ambang
Biner(baris, kolom) = 0;
else
Biner(baris, kolom) = 1;
end
end
end
subplot(1,3,3), imshow(Biner), title('Citra Biner');



%menyimpan citra%

RGB = imread ('D:\DATA PRAKTIKUM CITRA\image\dedaunan.png');
Abu =255 - rgb2gray(RGB);
imwrite(Abu, '"D:\DATA PRAKTIKUM CITRA\image\SIMPAN DATA\dedaunan.png');

