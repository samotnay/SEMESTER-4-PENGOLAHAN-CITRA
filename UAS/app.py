import tkinter as tk
from tkinter import filedialog, ttk
from PIL import Image, ImageTk
import os
import cv2
import numpy as np
import ttkbootstrap as tb
from datetime import datetime
from cbir_engine import match_image
from cbir_engine import build_feature_database
build_feature_database("D:\CITRA\UAS\dataset")

IMAGE_DB_PATH = "D:\CITRA\UAS\dataset"
CAPTURED_IMAGES_FOLDER = "captured_images"

# Membuat folder 'captured_images' jika belum ada
if not os.path.exists(CAPTURED_IMAGES_FOLDER):
    os.makedirs(CAPTURED_IMAGES_FOLDER)

class CBIRApp:
    def __init__(self, root):
        self.root = root
        self.root.title("🔍 CBIR MADAKNE RAI")
        self.root.geometry("1200x700")
        self.style = tb.Style("superhero")

        self.history = []  # Simpan riwayat pencarian

        self.frame = ttk.Frame(self.root, padding=10)
        self.frame.pack(fill="both", expand=True)

        # Panel kiri untuk gambar query
        self.query_img_panel = ttk.Label(self.frame, text="Query Image", anchor="center")
        self.query_img_panel.grid(row=0, column=0, rowspan=2, padx=10, pady=10)

        ttk.Button(self.frame, text="📁 Pilih Gambar", command=self.load_query_image).grid(row=2, column=0, pady=10)
        ttk.Button(self.frame, text="📸 Capture Image", command=self.capture_image).grid(row=3, column=0, pady=10)  # Tombol untuk capture gambar

        # Panel kanan untuk hasil pencarian
        self.results_frame = ttk.Frame(self.frame)
        self.results_frame.grid(row=0, column=1, rowspan=3, sticky="nsew")

        # Panel bawah untuk riwayat
        self.history_frame = ttk.Frame(self.frame)
        self.history_frame.grid(row=0, column=2, rowspan=3, sticky="ns", padx=10)
        self.history_label = ttk.Label(self.history_frame, text="🕒 Riwayat", font=("Arial", 12, "bold"))
        self.history_label.pack(pady=(0, 5))

        self.history_listbox = tk.Listbox(self.history_frame, height=30, width=30)
        self.history_listbox.pack(fill="y", expand=True)
        self.history_listbox.bind("<<ListboxSelect>>", self.on_history_select)

        # === Tombol Hapus Riwayat ===
        self.delete_button = ttk.Button(self.history_frame, text="🗑 Hapus Riwayat", command=self.delete_selected_history)
        self.delete_button.pack(pady=10)

    def delete_selected_history(self):
        selection = self.history_listbox.curselection()
        if not selection:
            return

        index = selection[0]
        del self.history[index]  # Hapus dari memori
        self.update_history_display()

    def load_query_image(self):
        file_path = filedialog.askopenfilename(filetypes=[("Image files", "*.jpg *.png *.jpeg")])
        if not file_path:
            return
        self.display_query_image(file_path)

        # Panggil CBIR dan tampilkan hasil
        results = match_image(file_path)
        self.show_results(results)

        # Tambahkan ke riwayat
        self.history.append((file_path, results))
        self.update_history_display()

    def display_query_image(self, file_path):
        img = Image.open(file_path).resize((200, 200))
        self.query_image_tk = ImageTk.PhotoImage(img)
        self.query_img_panel.config(image=self.query_image_tk)
        self.query_img_panel.image_path = file_path

    def show_results(self, results):
        for widget in self.results_frame.winfo_children():
            widget.destroy()

        ttk.Label(self.results_frame, text="🔝 Hasil Pencocokan:", font=("Arial", 14, "bold")).pack(pady=5)

        for fname, dist in results:
            img_path = os.path.join(IMAGE_DB_PATH, fname)
            img = Image.open(img_path).resize((100, 100))
            img_tk = ImageTk.PhotoImage(img)

            frame = ttk.Frame(self.results_frame, padding=5)
            frame.pack(side="top", fill="x", pady=5)

            img_label = ttk.Label(frame, image=img_tk)
            img_label.image = img_tk
            img_label.pack(side="left")
            #OUTPUT GAMBAR HASIL
            text = f"{fname}\nKecocokane ikilo: {dist:.2f}"
            ttk.Label(frame, text=text).pack(side="left", padx=10)

    def update_history_display(self):
        self.history_listbox.delete(0, tk.END)
        for i, (path, _) in enumerate(self.history):
            filename = os.path.basename(path)
            self.history_listbox.insert(tk.END, f"{i+1}. {filename}")

    def on_history_select(self, event):
        selection = event.widget.curselection()
        if not selection:
            return
        index = selection[0]
        file_path, results = self.history[index]

        self.display_query_image(file_path)
        self.show_results(results)

    def capture_image(self):
        # Buka kamera untuk mengambil gambar
        cap = cv2.VideoCapture(0)

        while True:
            ret, frame = cap.read()
            if not ret:
                break

            # Menampilkan video dari kamera
            cv2.imshow('Capture Image', frame)

            # Tunggu sampai tombol 'q' ditekan untuk menangkap gambar
            if cv2.waitKey(1) & 0xFF == ord('q'):
                # Membuat nama file gambar berdasarkan timestamp untuk memastikan nama file unik
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                img_filename = f"captured_{timestamp}.jpg"
                img_path = os.path.join(CAPTURED_IMAGES_FOLDER, img_filename)
                
                # Simpan gambar yang diambil
                cv2.imwrite(img_path, frame)
                cap.release()
                cv2.destroyAllWindows()

                # Tampilkan gambar yang diambil di GUI
                self.display_query_image(img_path)

                # Panggil CBIR dan tampilkan hasil
                results = match_image(img_path)
                self.show_results(results)

                # Tambahkan ke riwayat
                self.history.append((img_path, results))
                self.update_history_display()
                break

if __name__ == "__main__":
    root = tb.Window(themename="superhero")
    app = CBIRApp(root)
    root.mainloop()
