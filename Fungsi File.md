# 📚 Dokumentasi File Project Cookie Club

Ini fungsi setiap file di folder **basdat/Tubes**:

---

## 📁 **config.py**
### Database Connection & Query Functions

**Fungsi:**
- Koneksi ke MySQL database `cookie_db`
- Fungsi-fungsi query seperti:
  - `view_customers()` - Ambil data pelanggan
  - `view_products()` - Ambil data produk
  - `view_sales()` - Ambil data penjualan (JOIN dengan CUSTOMER)
  - `view_sales_details()` - Ambil detail penjualan lengkap
  - `view_daily_sales()` - Penjualan per hari untuk grafik
- Ini **backend** yang dipakai kedua dashboard

---

## 📁 **main_cookie.py**
### Dashboard Bisnis dengan Analitik

**Fitur:**
- **4 halaman** dengan metrics & filter canggih:
  - 👥 Pelanggan (filter tipe B2C/B2B, status)
  - 🍪 Produk (filter jenis Regular/Premium, harga rata-rata)
  - 🛍️ Penjualan (filter tanggal, tipe, total pendapatan)
  - 📋 Detail Penjualan (top 3 produk terlaris)
- Tampilkan **KPI cards** (Total Pelanggan, Revenue, dll)
- Export CSV per tabel
- Footer: "KELOMPOK 8 BASDAT A"

---

## 📁 **visualisasi_cookie.py**
### Dashboard Owner - Lihat Semua Data Mentah

**Fitur:**
- **14 tabel** lengkap database (seperti phpMyAdmin):
  - OWNER, PRODUK, CUSTOMER, CUSTOMER_PROFILE
  - PENJUALAN, PENJUALAN_DETAIL
  - EVENT, EVENT_KATEGORI
  - SUPPLIER, PURCHASE_ORDER, PO_ITEM
  - AKUN_KEUANGAN, BEBAN_OPERASIONAL, JURNAL_TRANSAKSI
- Pilih kolom yang mau ditampilkan (multiselect)
- Export CSV per tabel
- Tidak ada metrics/grafik, **fokus data mentah**

---

## 📁 **Database.sql**
### Schema + Sample Data

**Isi:**
- CREATE TABLE untuk 14 tabel
- INSERT data untuk setiap tabel (format single-line)
- Dijalankan di phpMyAdmin untuk buat database `cookie_db`
- Total ~400-500 baris SQL (sudah disederhanakan)

---

## 📁 **__pycache__/**
### Python Cache (Auto-generated)

**Keterangan:**
- File `.pyc` hasil compile Python
- Bisa diabaikan, auto-generate setiap run

---

## 📌 Kesimpulan

| File | Fungsi |
|------|--------|
| **Database.sql** | Bikin database |
| **config.py** | Koneksi & query database |
| **main_cookie.py** | Dashboard bisnis (4 tabel + analitik) |
| **visualisasi_cookie.py** | Dashboard owner (14 tabel mentah) |

---

**Dibuat oleh:** KELOMPOK 8 BASDAT A  
**Tanggal:** 10 Desember 2025