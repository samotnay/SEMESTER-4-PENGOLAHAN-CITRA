%Tugas Praktikum 3%

%NAMA   : RIYAN

%Memuat package yang dibutuhkan histogram
pkg load image;

% 1. Filter batas

% Daftar file gambar
file_gambar = {'original_grayscale_image.png',
'poison_noise_image.png',
'alt_and_pepper_noise_image.png',
'speckle_noise_image.png',
'gaussian_noise_image.png',};

% Path folder gambar
path_folder = 'D:\DATA PRAKTIKUM CITRA\FILE_FOTO';

% Jumlah gambar
num_images = numel(file_gambar);

%% Menampilkan gambar asli
figure;
set(gcf, 'Name', 'Gambar Sebelum Filter Batas', 'NumberTitle', 'off');

for i = 1:num_images

    F = imread([path_folder, file_gambar{i}]);


    subplot(2, 3, i);
    imshow(F);
    title(file_gambar{i}, 'Interpreter', 'none');
end

%% Menampilkan gambar hasil filter batas
figure;
set(gcf, 'Name', 'Hasil Filter Batas', 'NumberTitle', 'off');
for i = 1:num_images

    F = imread([path_folder, file_gambar{i}]);


    [tinggi, lebar, ~] = size(F);

    H = F;


    for baris = 2 : tinggi - 1
        for kolom = 2 : lebar - 1

            minPiksel = min([F(baris-1, kolom-1), F(baris-1, kolom), F(baris-1, kolom+1), ...
                             F(baris, kolom-1),               F(baris, kolom+1), ...
                             F(baris+1, kolom-1), F(baris+1, kolom), F(baris+1, kolom+1)]);

            maksPiksel = max([F(baris-1, kolom-1), F(baris-1, kolom), F(baris-1, kolom+1), ...
                              F(baris, kolom-1),               F(baris, kolom+1), ...
                              F(baris+1, kolom-1), F(baris+1, kolom), F(baris+1, kolom+1)]);


            if F(baris, kolom) < minPiksel
                H(baris, kolom) = minPiksel;
            elseif F(baris, kolom) > maksPiksel
                H(baris, kolom) = maksPiksel;
            else
                H(baris, kolom) = F(baris, kolom);
            end
        end
    end


    subplot(2, 3, i);
    imshow(H);
    title(file_gambar{i}, 'Interpreter', 'none');
end

% Figure untuk histogram sebelum filter batas
figure;
set(gcf, 'Name', 'Histogram Sebelum Filter batas', 'NumberTitle', 'off');

for i = 1:num_images
    F = imread([path_folder, file_gambar{i}]);

    subplot(2, 3, i);
    imhist(F);
    title(file_gambar{i}, 'Interpreter', 'none');
    xlabel('Nilai Intensitas');
    ylabel('Frekuensi');
end

% Figure untuk histogram setelah filter batas
figure;
set(gcf, 'Name', 'Histogram Setelah Filter batas', 'NumberTitle', 'off');

for i = 1:num_images
    F = imread([path_folder, file_gambar{i}]);

    [tinggi, lebar, ~] = size(F);
    H = F;


    for baris = 2 : tinggi - 1
        for kolom = 2 : lebar - 1
            minPiksel = min([F(baris-1, kolom-1), F(baris-1, kolom), F(baris-1, kolom+1), ...
                             F(baris, kolom-1),               F(baris, kolom+1), ...
                             F(baris+1, kolom-1), F(baris+1, kolom), F(baris+1, kolom+1)]);

            maksPiksel = max([F(baris-1, kolom-1), F(baris-1, kolom), F(baris-1, kolom+1), ...
                              F(baris, kolom-1),               F(baris, kolom+1), ...
                              F(baris+1, kolom-1), F(baris+1, kolom), F(baris+1, kolom+1)]);


            if F(baris, kolom) < minPiksel
                H(baris, kolom) = minPiksel;
            elseif F(baris, kolom) > maksPiksel
                H(baris, kolom) = maksPiksel;
            else
                H(baris, kolom) = F(baris, kolom);
            end
        end
    end

    subplot(2, 3, i);
    imhist(H);
    title(file_gambar{i}, 'Interpreter', 'none');
    xlabel('Nilai Intensitas');
    ylabel('Frekuensi');
end

% 2. Filter pererataan

file_gambar = {'original_grayscale_image.png','poison_noise_image.png','alt_and_pepper_noise_image.png','speckle_noise_image.png','gaussian_noise_image.png',};

path_folder = 'D:\DATA PRAKTIKUM CITRA\FILE_FOTO';

num_images = numel(file_gambar);

figure;
set(gcf, 'Name', 'Gambar Sebelum Filter Pererataan', 'NumberTitle', 'off');

for i = 1:num_images

    img_path = fullfile(path_folder, file_gambar{i});
    F = imread(img_path);

    subplot(2, 3, i);
    imshow(F);
    title(file_gambar{i}, 'Interpreter', 'none');
end

figure;
set(gcf, 'Name', 'Hasil Filter Pererataan', 'NumberTitle', 'off');

for i = 1:num_images

    img_path = fullfile(path_folder, file_gambar{i});
    F = imread(img_path);

    [tinggi, lebar] = size(F);

    F2 = double(F);

    G = F;


    for baris = 2 : tinggi - 1
        for kolom = 2 : lebar - 1
            jum = sum(sum(F2(baris-1:baris+1, kolom-1:kolom+1))); % Hitung rata-rata
            G(baris, kolom) = uint8(jum / 9);
        end
    end

    subplot(2, 3, i);
    imshow(G);
    title(file_gambar{i}, 'Interpreter', 'none');
end

% Figure untuk histogram sebelum filter pererataan
figure;
set(gcf, 'Name', 'Histogram Sebelum Filter pererataan', 'NumberTitle', 'off');

for i = 1:num_images
    F = imread([path_folder, file_gambar{i}]);

    subplot(2, 3, i);
    imhist(F);
    title(file_gambar{i}, 'Interpreter', 'none');
    xlabel('Nilai Intensitas');
    ylabel('Frekuensi');
end

% Figure untuk histogram setelah filter pererataan
figure;
set(gcf, 'Name', 'Histogram Setelah Filter pererataan', 'NumberTitle', 'off');

for i = 1:num_images

    img_path = fullfile(path_folder, file_gambar{i});
    F = imread(img_path);

    [tinggi, lebar] = size(F);

    F2 = double(F);

    G = F;


    for baris = 2 : tinggi - 1
        for kolom = 2 : lebar - 1
            jum = sum(sum(F2(baris-1:baris+1, kolom-1:kolom+1))); % Hitung rata-rata
            G(baris, kolom) = uint8(jum / 9);
        end
    end


    subplot(2, 3, i);
    imhist(G);
    title(file_gambar{i}, 'Interpreter', 'none');
    xlabel('Nilai Intensitas');
    ylabel('Frekuensi');
end

% 3. Filter median

file_gambar = {'original_grayscale_image.png','poison_noise_image.png','alt_and_pepper_noise_image.png','speckle_noise_image.png','gaussian_noise_image.png',};

path_folder = 'D:\DATA PRAKTIKUM CITRA\FILE_FOTO';
num_images = numel(file_gambar);

%% Menampilkan gambar asli sebelum filter median
figure;
set(gcf, 'Name', 'Gambar Sebelum Filter Median', 'NumberTitle', 'off');

for i = 1:num_images
    img_path = fullfile(path_folder, file_gambar{i});
    origImage = imread(img_path);

    % Memastikan gambar grayscale
    if size(origImage,3) == 3
        origImage = rgb2gray(origImage);
    end

    subplot(2, 3, i);
    imshow(origImage);
    title(file_gambar{i}, 'Interpreter', 'none');
end

%% Filter median
figure;
set(gcf, 'Name', 'Hasil Filter Median', 'NumberTitle', 'off');

for i = 1:num_images
    img_path = fullfile(path_folder, file_gambar{i});
    F = imread(img_path);


    if size(F,3) == 3
        F = rgb2gray(F);
    end

    % Gunakan filter median
    H = medfilt2(F, [3 3]);

    subplot(2, 3, i);
    imshow(H);
    title(['', file_gambar{i}], 'Interpreter', 'none');
end

% Figure untuk histogram sebelum filter median
figure;
set(gcf, 'Name', 'Histogram Sebelum Filter median', 'NumberTitle', 'off');

for i = 1:num_images
    F = imread([path_folder, file_gambar{i}]);

    subplot(2, 3, i);
    imhist(F);
    title(file_gambar{i}, 'Interpreter', 'none');
    xlabel('Nilai Intensitas');
    ylabel('Frekuensi');
end

% Figure untuk histogram setelah filter median
figure;
set(gcf, 'Name', 'Histogram Setelah Filter median', 'NumberTitle', 'off');

for i = 1:num_images
    img_path = fullfile(path_folder, file_gambar{i});
    F = imread(img_path);


    if size(F,3) == 3
        F = rgb2gray(F);
    end

    % Gunakan filter median
    H = medfilt2(F, [3 3]);

    subplot(2, 3, i);
    imhist(H);
    title(file_gambar{i}, 'Interpreter', 'none');
    xlabel('Nilai Intensitas');
    ylabel('Frekuensi');
end

