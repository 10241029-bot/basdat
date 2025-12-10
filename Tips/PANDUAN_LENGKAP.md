# 🚀 PANDUAN LENGKAP - Cookie Club Analytics Dashboard

## 📋 Daftar Isi
1. [Persiapan](#persiapan)
2. [Cara Menjalankan](#cara-menjalankan)
3. [Fitur Dashboard](#fitur-dashboard)
4. [Troubleshooting](#troubleshooting)

---

## 🔧 Persiapan

### 1. Pastikan Sudah Terinstall:
- ✅ Python 3.8+ (`python --version`)
- ✅ XAMPP (untuk MySQL)
- ✅ pip (`pip --version`)

### 2. File yang Diperlukan:
```
Implementasi/
├── config.py                  # ✅ Sudah dibuat
├── visualisasi_cookie.py      # ✅ Sudah dibuat (FILE UTAMA)
├── Database.sql               # ✅ Sudah ada
├── requirements.txt           # ✅ Sudah dibuat
└── README.md                  # Dokumentasi
```

---

## 🚀 Cara Menjalankan

### LANGKAH 1: Install Dependencies
Buka PowerShell di folder `Implementasi`:
```powershell
cd c:\xampp\htdocs\BASDAT\TUBES\Implementasi
pip install -r requirements.txt
```

### LANGKAH 2: Start MySQL (XAMPP)
1. Buka **XAMPP Control Panel**
2. Klik **Start** pada MySQL
3. Pastikan status jadi **hijau/running**

### LANGKAH 3: Import Database
**Cara 1: Via phpMyAdmin**
1. Buka browser → `http://localhost/phpmyadmin`
2. Klik tab **"SQL"**
3. Copy-paste isi file `Database.sql`
4. Klik **"Go"**

**Cara 2: Via MySQL Command**
```powershell
cd c:\xampp\htdocs\BASDAT\TUBES\Implementasi
mysql -u root -p < Database.sql
```
(Tekan Enter jika diminta password - default kosong)

### LANGKAH 4: Jalankan Dashboard
```powershell
streamlit run visualisasi_cookie.py
```

✨ **Dashboard otomatis terbuka di browser: `http://localhost:8501`**

---

## 📊 Fitur Dashboard

### 🏠 HALAMAN 1: Dashboard Ringkasan
**Fitur:**
- 4 Metric Cards (Total Penjualan, Customer, Produk Terjual, Rata-rata Transaksi)
- 📈 Grafik Line Chart: Trend Penjualan Harian
- 🥧 Pie Chart: Komposisi B2C vs B2B
- 📊 Bar Chart: Top 10 Produk Terlaris

**Gunakan Untuk:**
- Overview bisnis sekilas
- Monitoring KPI utama
- Identifikasi produk favorit

---

### 📈 HALAMAN 2: Analisis Penjualan
**Fitur:**
- Penjualan per bulan (Bar Chart)
- Jumlah transaksi per bulan (Line Chart)
- Penjualan berdasarkan tipe (B2C/B2B/Event)

**Gunakan Untuk:**
- Analisis trend bulanan
- Perbandingan performa B2C vs B2B
- Identifikasi bulan peak season

---

### 🍪 HALAMAN 3: Analisis Produk
**Fitur:**
- Top 15 Produk Terlaris (Horizontal Bar)
- Top 15 Pendapatan Per Produk
- Distribusi per Jenis Produk (Pie Chart)

**Gunakan Untuk:**
- Identifikasi best seller
- Analisis pendapatan per produk
- Strategi stocking & produksi

---

### 👥 HALAMAN 4: Analisis Customer
**Fitur:**
- Komposisi B2C vs B2B (Pie Chart)
- Total penjualan per tipe customer
- Jumlah customer aktif

**Gunakan Untuk:**
- Segmentasi customer
- Strategi marketing
- Customer retention

---

### 🎉 HALAMAN 5: Analisis Event
**Fitur:**
- Top 10 Event berdasarkan penjualan
- Distribusi penjualan per lokasi event
- ROI per event

**Gunakan Untuk:**
- Evaluasi performa event
- Pemilihan lokasi strategis
- Budget planning event

---

### 📋 HALAMAN 6: Data Tabel
**Fitur:**
- 4 Tab: Customer, Produk, Penjualan, Detail Penjualan
- View data lengkap dalam tabel
- Download CSV untuk setiap tabel

**Gunakan Untuk:**
- Export data ke Excel
- Analisis detail manual
- Report ke stakeholder

---

## 🎨 Interaksi dengan Grafik

### Fitur Plotly Interactive:
1. **Hover** - Lihat detail data point
2. **Zoom** - Scroll mouse / drag area
3. **Pan** - Klik & drag grafik
4. **Download** - Klik icon camera (save as PNG)
5. **Reset** - Double click grafik

---

## 🐛 Troubleshooting

### ❌ Error: "Can't connect to MySQL server"
**Solusi:**
```powershell
# 1. Cek MySQL running di XAMPP
# 2. Test koneksi:
mysql -u root -p
USE cookie_db;
SHOW TABLES;
```

### ❌ Error: "No module named 'streamlit'"
**Solusi:**
```powershell
pip install --upgrade streamlit pandas plotly mysql-connector-python
```

### ❌ Error: "Database 'cookie_db' doesn't exist"
**Solusi:**
```powershell
# Import ulang database
mysql -u root -p < Database.sql
```

### ❌ Port 8501 sudah dipakai
**Solusi:**
```powershell
streamlit run visualisasi_cookie.py --server.port 8502
# Buka: http://localhost:8502
```

### ❌ Data tidak muncul di grafik
**Cek:**
1. Database sudah ter-import?
2. Ada data di tabel? (`SELECT * FROM PENJUALAN;`)
3. Koneksi database di `config.py` sudah benar?

---

## 📱 Tips Penggunaan

### Untuk Presentasi:
1. Pilih halaman "Dashboard Ringkasan" untuk overview
2. Gunakan halaman "Analisis Penjualan" untuk trend
3. Download tabel di halaman "Data Tabel" untuk backup

### Untuk Analisis Bisnis:
1. Cek "Top Produk" → fokus produksi best seller
2. Cek "Customer B2C vs B2B" → strategi marketing
3. Cek "Event Performance" → lokasi strategis

### Untuk Export Data:
1. Buka halaman "Data Tabel"
2. Pilih tab yang diinginkan
3. Klik tombol "📥 Download CSV"
4. Buka di Excel/Google Sheets

---

## 🔄 Update Data

Dashboard akan **otomatis refresh** jika:
- Data baru ditambahkan ke database
- Data diupdate via phpMyAdmin
- Anda refresh halaman browser (F5)

---

## 🎯 Quick Commands

### Run Dashboard:
```powershell
cd c:\xampp\htdocs\BASDAT\TUBES\Implementasi
streamlit run visualisasi_cookie.py
```

### Stop Dashboard:
- Tekan `Ctrl + C` di terminal
- Atau tutup browser & terminal

### Re-import Database:
```powershell
mysql -u root -p cookie_db < Database.sql
```

---

## 📞 Bantuan

### Cek Status:
```powershell
# Python version
python --version

# Streamlit version
streamlit --version

# MySQL connection test
python -c "import mysql.connector; print('MySQL OK')"

# Plotly test
python -c "import plotly; print('Plotly OK')"
```

### Log Error:
Jika ada error, cek terminal untuk detail message. Copy error message untuk debugging.

---

## ✨ Fitur Tambahan

### Filter Data (Coming Soon):
- Filter by date range
- Filter by customer type
- Filter by product category

### Export Options (Coming Soon):
- Export to PDF
- Export grafik as image
- Scheduled reports

---

🍪 **Selamat Menggunakan Cookie Club Analytics Dashboard!** 📊

Jika ada pertanyaan atau error, cek error message di terminal atau browser console.
