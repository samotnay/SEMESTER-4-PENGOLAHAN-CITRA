import cv2
import numpy as np
import os
import pickle

# Fungsi untuk mengekstraksi fitur bentuk dari sebuah gambar
def extract_shape_features(image_path):
    # Membaca gambar dalam format grayscale
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    
    # Melakukan thresholding pada gambar untuk menghasilkan gambar biner (hitam-putih)
    _, thresh = cv2.threshold(img, 128, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)
    
    # Mencari kontur dalam gambar
    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Jika tidak ada kontur ditemukan, kembalikan vektor fitur nol
    if not contours:
        return np.zeros(7)

    # Memilih kontur terbesar (yang paling luas)
    largest_contour = max(contours, key=cv2.contourArea)
    
    # Menghitung momen dari kontur terbesar
    moments = cv2.moments(largest_contour)
    
    # Menghitung momen Hu (invarian terhadap rotasi, skala, dan translasi)
    hu_moments = cv2.HuMoments(moments).flatten()
    
    # Melakukan normalisasi dan transformasi logaritmik pada momen Hu agar lebih stabil
    return -np.sign(hu_moments) * np.log10(np.abs(hu_moments) + 1e-10)

# Fungsi untuk membangun database fitur dari gambar yang ada di folder
def build_feature_database(image_folder, output_file="features.pkl"):
    db = {}
    # Iterasi untuk setiap file gambar dalam folder
    for file in os.listdir(image_folder):
        # Memeriksa apakah file memiliki ekstensi gambar (PNG, JPG, JPEG)
        if file.lower().endswith((".png", ".jpg", ".jpeg")):
            path = os.path.join(image_folder, file)
            
            # Mengekstraksi fitur dari gambar
            features = extract_shape_features(path)
            
            # Menyimpan nama file gambar dan fitur yang diekstraksi dalam database
            db[file] = features
    
    # Menyimpan database fitur dalam format file pickle
    with open(output_file, "wb") as f:
        pickle.dump(db, f)

# Fungsi untuk mengekstraksi fitur bentuk dari beberapa objek dalam gambar
def extract_multiple_shapes(image_path, max_objects=5):
    # Membaca gambar dalam format grayscale
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    
    # Melakukan thresholding pada gambar untuk menghasilkan gambar biner (hitam-putih)
    _, thresh = cv2.threshold(img, 128, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)
    
    # Mencari kontur dalam gambar
    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    features_list = []
    # Menyortir kontur berdasarkan luasnya dan memilih kontur terbesar sesuai jumlah maksimum
    contours = sorted(contours, key=cv2.contourArea, reverse=True)[:max_objects]

    # Menghitung momen Hu untuk setiap kontur terpilih
    for cnt in contours:
        moments = cv2.moments(cnt)
        hu = cv2.HuMoments(moments).flatten()
        
        # Melakukan normalisasi dan transformasi logaritmik pada momen Hu
        hu = -np.sign(hu) * np.log10(np.abs(hu) + 1e-10)
        
        # Menambahkan fitur Hu ke daftar fitur
        features_list.append(hu)

    return features_list

# Fungsi untuk mencocokkan gambar query dengan database fitur dan mendapatkan hasil teratas
def match_image(query_image_path, feature_db_path="features.pkl", top_k=5):
    # Memuat database fitur dari file pickle
    with open(feature_db_path, "rb") as f:
        db = pickle.load(f)

    # Mengekstraksi fitur gambar query
    query_feat = extract_shape_features(query_image_path)
    
    results = []
    # Menghitung jarak Euclidean antara fitur gambar query dan fitur setiap gambar dalam database
    for fname, feat in db.items():
        dist = np.linalg.norm(query_feat - feat)
        results.append((fname, dist))
    
    # Mengurutkan hasil berdasarkan jarak terkecil (kesamaan tertinggi)
    results.sort(key=lambda x: x[1])
    
    # Mengembalikan top-k hasil paling mirip
    return results[:top_k]
