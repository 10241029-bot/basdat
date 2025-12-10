# 🍪 Cookie Club Analytics Dashboard

Dashboard visualisasi data interaktif untuk UMKM Cookie Club menggunakan Python & Streamlit.

## ✨ Fitur

### 📊 6 Halaman Analisis:
1. **Dashboard Ringkasan** - KPI utama, grafik trend, top produk
2. **Analisis Penjualan** - Trend bulanan, penjualan per tipe (B2C/B2B/Event)
3. **Analisis Produk** - Produk terlaris, pendapatan per produk, jenis produk
4. **Analisis Customer** - Komposisi B2C vs B2B, penjualan per customer
5. **Analisis Event** - Performa event, penjualan per lokasi
6. **Data Tabel** - View & download data dalam format tabel

### 🎨 Visualisasi:
- Line Chart (Trend penjualan)
- Bar Chart (Top produk, penjualan)
- Pie Chart (Komposisi customer, distribusi)
- Interactive Plotly Charts (hover untuk detail)

## 🚀 Cara Install & Jalankan

### 1. Install Dependencies
```powershell
pip install -r requirements.txt
```

### 2. Setup Database
Pastikan XAMPP MySQL sudah running, lalu:
```sql
-- Import file Database.sql ke phpMyAdmin atau MySQL
-- Database: cookie_db
```

### 3. Konfigurasi Database
Edit `config.py` jika perlu mengubah koneksi:
```python
host='localhost',
database='cookie_db',
user='root',
password=''
```

### 4. Jalankan Dashboard
```powershell
streamlit run visualisasi_cookie.py
```

Dashboard akan terbuka di browser: `http://localhost:8501`

## 📁 Struktur File

```
Implementasi/
├── config.py                  # Koneksi database & query functions
├── visualisasi_cookie.py      # Dashboard utama (jalankan ini)
├── main_cookie.py             # Alternatif: tabel sederhana
├── Database.sql               # Database schema + sample data
├── requirements.txt           # Python dependencies
└── README.md                  # Dokumentasi ini
```

## 🎯 Cara Pakai

1. **Pilih Menu** di sidebar kiri
2. **Hover pada grafik** untuk melihat detail data
3. **Download data** dengan klik tombol "Download CSV" di tab Data Tabel
4. **Filter interaktif** pada setiap grafik Plotly

## 📊 Teknologi

- **Python 3.12+**
- **Streamlit** - Framework dashboard
- **Plotly** - Interactive charts
- **Pandas** - Data manipulation
- **MySQL** - Database

## 💡 Tips

- Grafik interaktif: klik, zoom, pan
- Semua data real-time dari database
- Otomatis refresh saat data berubah

## 🐛 Troubleshooting

**Error koneksi database:**
- Pastikan XAMPP MySQL running
- Cek nama database: `cookie_db`
- Cek username/password di `config.py`

**Error import module:**
```powershell
pip install --upgrade -r requirements.txt
```

**Port 8501 sudah dipakai:**
```powershell
streamlit run visualisasi_cookie.py --server.port 8502
```

## 📞 Support

Jika ada error atau pertanyaan, cek:
1. Database sudah ter-import
2. XAMPP MySQL running
3. Dependencies sudah ter-install
4. Python versi 3.8+

---

🍪 **Happy Analyzing!** 📊
