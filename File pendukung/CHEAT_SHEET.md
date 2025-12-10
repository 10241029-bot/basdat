# ⚡ CHEAT SHEET - Cookie Club Dashboard

## 🚀 Quick Start (3 Langkah)

```powershell
# 1. Install dependencies
pip install -r requirements.txt

# 2. Start XAMPP MySQL (manual)

# 3. Jalankan dashboard
streamlit run visualisasi_cookie.py
```

---

## 📝 Command Reference

### Database
```powershell
# Import database
mysql -u root -p < Database.sql

# Check database
mysql -u root -p
> USE cookie_db;
> SHOW TABLES;
> SELECT COUNT(*) FROM PENJUALAN;
> EXIT;
```

### Python/Streamlit
```powershell
# Run dashboard
streamlit run visualisasi_cookie.py

# Run on different port
streamlit run visualisasi_cookie.py --server.port 8502

# Check versions
python --version
streamlit --version

# Install/Update packages
pip install -r requirements.txt
pip install --upgrade streamlit
```

### File Management
```powershell
# Navigate to project
cd c:\xampp\htdocs\BASDAT\TUBES\Implementasi

# List files
dir

# Open in VS Code
code .
```

---

## 🔍 Troubleshooting Cepat

| Error | Solusi |
|-------|--------|
| MySQL connection failed | Start XAMPP MySQL |
| Port 8501 busy | Gunakan `--server.port 8502` |
| Module not found | `pip install -r requirements.txt` |
| Database not found | `mysql -u root -p < Database.sql` |
| Grafik kosong | Cek data di database |

---

## 📊 Fitur Dashboard

| Halaman | Fitur Utama |
|---------|-------------|
| 🏠 Dashboard | KPI, Trend, Top Produk |
| 📈 Penjualan | Trend bulanan, B2C/B2B |
| 🍪 Produk | Best seller, Pendapatan |
| 👥 Customer | Segmentasi, Komposisi |
| 🎉 Event | Performa, ROI, Lokasi |
| 📋 Data | Tabel lengkap, Export CSV |

---

## 💡 Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Stop Streamlit | `Ctrl + C` |
| Refresh dashboard | `F5` atau `R` |
| Clear cache | `C` |
| Open settings | Click ⋮ (top right) |

---

## 🎯 URLs

| Service | URL |
|---------|-----|
| Dashboard | http://localhost:8501 |
| phpMyAdmin | http://localhost/phpmyadmin |
| XAMPP Control | C:\xampp\xampp-control.exe |

---

## 📁 File Structure

```
Implementasi/
├── config.py              # Database config
├── visualisasi_cookie.py  # Main dashboard ⭐
├── Database.sql           # Database schema
├── requirements.txt       # Dependencies
└── *.md                   # Documentation
```

---

## ✅ Pre-Flight Checklist

Sebelum run dashboard:
- [ ] MySQL XAMPP running (hijau)
- [ ] Database cookie_db sudah import
- [ ] Python packages installed
- [ ] Terminal di folder Implementasi

---

## 🔄 Workflow Standar

```
1. Start XAMPP → MySQL
2. cd c:\xampp\htdocs\BASDAT\TUBES\Implementasi
3. streamlit run visualisasi_cookie.py
4. Browser auto-open http://localhost:8501
5. Pilih menu di sidebar
6. Analisis data!
```

---

## 🎨 Grafik Interaktif

**Aksi pada grafik Plotly:**
- **Hover**: Detail data
- **Click & Drag**: Zoom
- **Double Click**: Reset
- **Camera Icon**: Download PNG
- **Pan**: Geser grafik

---

## 🚨 Emergency Commands

```powershell
# Force kill Streamlit
taskkill /F /IM streamlit.exe

# Clear pip cache
pip cache purge

# Reinstall all
pip uninstall -r requirements.txt -y
pip install -r requirements.txt

# Check MySQL running
netstat -ano | findstr :3306
```

---

🍪 **Pro Tip:** Bookmark `http://localhost:8501` untuk akses cepat!
