# 📊 Dokumentasi Visualisasi Data dengan Streamlit

**Project:** Cookie Club Database Visualization  
**File:** `visualisasi_cookie.py`  
**Framework:** Streamlit  
**Kelompok:** 8 BASDAT A  
**Tanggal:** 11 Desember 2025

---

## 🎯 Tujuan Visualisasi

Membuat **web dashboard sederhana** yang memungkinkan owner/user untuk:
- ✅ Melihat data dari 14 tabel database dalam format tabel
- ✅ **Memilih kolom** mana saja yang ingin ditampilkan (interaktif)
- ✅ Download data ke CSV
- ✅ Interface simpel seperti phpMyAdmin tapi lebih user-friendly

---

## 🔧 Teknologi yang Digunakan

```python
import streamlit as st      # Framework web dashboard
import pandas as pd         # Manipulasi data tabel
from datetime import datetime
from config import *        # Fungsi koneksi database
```

**Library yang diperlukan:**
```bash
pip install streamlit pandas mysql-connector-python
```

---

## 📁 Code Lengkap: `visualisasi_cookie.py`

```python
# visualisasi_cookie.py
"""
🍪 COOKIE CLUB - DATA TABEL SEDERHANA
Lihat data dari database dalam format tabel
"""

import streamlit as st
import pandas as pd
from datetime import datetime
from config import *

# ==================== KONFIGURASI HALAMAN ====================
st.set_page_config(
    page_title="Cookie Club Data",
    page_icon="🍪",
    layout="wide"  # Layout lebar penuh
)

# ==================== HEADER ====================
st.markdown("""
    <div style='text-align: center; padding: 1.5rem; 
                background: linear-gradient(90deg, #FFE4C4 0%, #DEB887 100%); 
                border-radius: 10px; margin-bottom: 2rem;'>
        <h1 style='color: #8B4513; margin: 0;'>🍪 Cookie Club - Data Management</h1>
        <p style='color: #654321; margin: 5px 0 0 0;'>Lihat & Kelola Data Tabel</p>
    </div>
""", unsafe_allow_html=True)    

# ==================== SIDEBAR NAVIGASI ====================
st.sidebar.title("📊 Pilih Tabel")
page = st.sidebar.radio(
    "Tabel Database:",
    ["👤 Owner", "🍪 Produk", "🛒 Penjualan", "📦 Detail Penjualan", 
     "👥 Customer", "📝 Customer Profile", "🎉 Event", "📍 Event Kategori",
     "🏪 Supplier", "📋 Purchase Order", "📦 PO Item", "💰 Akun Keuangan",
     "💸 Beban Operasional", "📊 Jurnal Transaksi"]
)

st.sidebar.markdown("---")
st.sidebar.info("💡 Pilih kolom yang ingin ditampilkan pada setiap tabel")


# ==================== FUNGSI AMBIL DATA DARI TABEL ====================
def get_table_data(table_name):
    """
    Fungsi untuk mengambil semua data dari tabel database
    
    Parameter:
        table_name (str): Nama tabel yang akan diambil datanya
        
    Return:
        result (list): Data dalam bentuk list of tuples
        column_names (list): Nama-nama kolom
    """
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            
            # Query SELECT * untuk ambil semua data
            query = f"SELECT * FROM {table_name}"
            cursor.execute(query)
            result = cursor.fetchall()
            
            # Ambil nama kolom dari cursor.description
            column_names = [desc[0] for desc in cursor.description]
            
            cursor.close()
            connection.close()
            return result, column_names
        except Exception as e:
            st.error(f"Error: {e}")
            return [], []
    return [], []


# ==================== FUNGSI TAMPILKAN TABEL ====================
def display_table(table_name, title, emoji):
    """
    Fungsi untuk menampilkan tabel dengan fitur pilih kolom
    
    Parameter:
        table_name (str): Nama tabel di database
        title (str): Judul tabel untuk ditampilkan
        emoji (str): Emoji untuk dekorasi
    """
    st.markdown(f"## {emoji} {title}")
    
    # Ambil data dari database
    result, columns = get_table_data(table_name)
    
    # Jika tidak ada data, keluar dari fungsi
    if not result:
        return
    
    # Konversi data ke DataFrame pandas
    df = pd.DataFrame(result, columns=columns)
    
    # Tampilkan info data (metrics)
    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric("📊 Total Baris", len(df))
    with col2:
        st.metric("📋 Total Kolom", len(df.columns))
    
    st.markdown("---")
    
    # ==================== FITUR PILIH KOLOM (INI YANG BIKIN INTERAKTIF!) ====================
    st.markdown("### 🔍 Pilih Kolom yang Ingin Ditampilkan")
    selected_columns = st.multiselect(
        "Kolom:",
        options=df.columns.tolist(),        # Semua kolom jadi pilihan
        default=df.columns.tolist()         # Default: semua kolom dipilih
    )
    
    # Jika ada kolom yang dipilih, tampilkan
    if selected_columns:
        df_display = df[selected_columns]   # Filter DataFrame berdasarkan kolom yang dipilih
        
        # Tampilkan tabel
        st.markdown("### 📋 Data Tabel")
        st.dataframe(df_display, use_container_width=True, height=400)
        
        # Download CSV
        csv = df_display.to_csv(index=False).encode('utf-8')
        st.download_button(
            label=f"📥 Download {title} (CSV)",
            data=csv,
            file_name=f'{table_name.lower()}_data.csv',
            mime='text/csv'
        )
    else:
        st.info("ℹ️ Pilih minimal 1 kolom untuk ditampilkan")


# ==================== ROUTING HALAMAN ====================
# Tampilkan halaman sesuai pilihan di sidebar

if page == "👤 Owner":
    display_table("OWNER", "Data Owner", "👤")

elif page == "🍪 Produk":
    display_table("PRODUK", "Data Produk", "🍪")

elif page == "🛒 Penjualan":
    display_table("PENJUALAN", "Data Penjualan", "🛒")

elif page == "📦 Detail Penjualan":
    display_table("PENJUALAN_DETAIL", "Detail Penjualan", "📦")

elif page == "👥 Customer":
    display_table("CUSTOMER", "Data Customer", "👥")

elif page == "📝 Customer Profile":
    display_table("CUSTOMER_PROFILE", "Profile Customer", "📝")

elif page == "🎉 Event":
    display_table("EVENT", "Data Event", "🎉")

elif page == "📍 Event Kategori":
    display_table("EVENT_KATEGORI", "Kategori Event", "📍")

elif page == "🏪 Supplier":
    display_table("SUPPLIER", "Data Supplier", "🏪")

elif page == "📋 Purchase Order":
    display_table("PURCHASE_ORDER", "Purchase Order", "📋")

elif page == "📦 PO Item":
    display_table("PO_ITEM", "Item Purchase Order", "📦")

elif page == "💰 Akun Keuangan":
    display_table("AKUN_KEUANGAN", "Akun Keuangan", "💰")

elif page == "💸 Beban Operasional":
    display_table("BEBAN_OPERASIONAL", "Beban Operasional", "💸")

elif page == "📊 Jurnal Transaksi":
    display_table("JURNAL_TRANSAKSI", "Jurnal Transaksi", "📊")


# ==================== FOOTER ====================
st.markdown("---")
st.markdown("""
    <div style='text-align: center; color: #888;'>
        <p>KELOMPOK 8 BASDAT A</p>
    </div>
""", unsafe_allow_html=True)
```

---

## 🎨 Cara Kerja Visualisasi

### 1️⃣ **Konfigurasi Halaman**
```python
st.set_page_config(
    page_title="Cookie Club Data",
    page_icon="🍪",
    layout="wide"
)
```
**Fungsi:** Set judul browser, icon, dan layout lebar penuh.

---

### 2️⃣ **Sidebar Navigation**
```python
page = st.sidebar.radio(
    "Tabel Database:",
    ["👤 Owner", "🍪 Produk", "🛒 Penjualan", ...]
)
```
**Fungsi:** User pilih tabel mana yang mau dilihat (radio button di sidebar).  
**Variabel `page`** menyimpan pilihan user (contoh: "👤 Owner").

---

### 3️⃣ **Fungsi `get_table_data()` - Ambil Data dari Database**
```python
def get_table_data(table_name):
    connection = create_connection()
    cursor = connection.cursor()
    
    # SELECT * FROM tabel_name
    query = f"SELECT * FROM {table_name}"
    cursor.execute(query)
    result = cursor.fetchall()  # Ambil semua baris
    
    # Ambil nama kolom
    column_names = [desc[0] for desc in cursor.description]
    
    return result, column_names
```

**Cara Kerja:**
1. Koneksi ke database MySQL
2. Query `SELECT * FROM PRODUK` (contoh)
3. `fetchall()` → ambil semua baris data (list of tuples)
4. `cursor.description` → ambil metadata nama kolom
5. Return: `[(data baris 1), (data baris 2), ...]` dan `['produk_id', 'nama_produk', ...]`

**Contoh Output:**
```python
result = [
    (1, 'Chocolate Chip Cookie', 'Regular', 50000, 'Isi 10 pcs', 'Tersedia'),
    (2, 'Red Velvet Cookie', 'Premium', 75000, 'Isi 8 pcs', 'Tersedia')
]
column_names = ['produk_id', 'nama_produk', 'jenis_produk', 'harga_satuan', 'deskripsi', 'status']
```

---

### 4️⃣ **Fungsi `display_table()` - Tampilkan Tabel Interaktif**

#### 📊 **Konversi ke DataFrame Pandas**
```python
df = pd.DataFrame(result, columns=columns)
```
**Fungsi:** Konversi data mentah jadi tabel pandas (mudah dimanipulasi).

**Contoh:**
```
| produk_id | nama_produk              | jenis_produk | harga_satuan | deskripsi     | status    |
|-----------|--------------------------|--------------|--------------|---------------|-----------|
| 1         | Chocolate Chip Cookie    | Regular      | 50000        | Isi 10 pcs    | Tersedia  |
| 2         | Red Velvet Cookie        | Premium      | 75000        | Isi 8 pcs     | Tersedia  |
```

---

### 5️⃣ **🔥 FITUR INTERAKTIF - Pilih Kolom (INI YANG BIKIN BISA KLIK KOLOM!)**

```python
selected_columns = st.multiselect(
    "Kolom:",
    options=df.columns.tolist(),        # ['produk_id', 'nama_produk', ...]
    default=df.columns.tolist()         # Semua kolom dipilih default
)
```

**Cara Kerja:**
1. `st.multiselect()` → widget Streamlit untuk pilih multiple items
2. `options=df.columns.tolist()` → semua nama kolom jadi pilihan
3. User **klik/centang** kolom yang mau ditampilkan
4. `selected_columns` → list kolom yang dipilih user

**Contoh Interaksi User:**
```
☑ produk_id
☑ nama_produk
☐ jenis_produk
☑ harga_satuan
☐ deskripsi
☐ status
```

Hasilnya: `selected_columns = ['produk_id', 'nama_produk', 'harga_satuan']`

---

### 6️⃣ **Filter DataFrame Berdasarkan Kolom Pilihan**
```python
df_display = df[selected_columns]
```

**Cara Kerja:**
- Pandas **slicing** → ambil hanya kolom yang dipilih user
- DataFrame original tidak berubah, cuma tampilan yang di-filter

**Contoh:**
```python
# DataFrame asli (semua kolom)
df = 
| produk_id | nama_produk              | jenis_produk | harga_satuan | deskripsi     | status    |
| 1         | Chocolate Chip Cookie    | Regular      | 50000        | Isi 10 pcs    | Tersedia  |

# Setelah user pilih ['nama_produk', 'harga_satuan']
df_display = 
| nama_produk              | harga_satuan |
| Chocolate Chip Cookie    | 50000        |
```

---

### 7️⃣ **Tampilkan Tabel di Web**
```python
st.dataframe(df_display, use_container_width=True, height=400)
```

**Fungsi:**
- `st.dataframe()` → widget Streamlit untuk tampilkan tabel
- `use_container_width=True` → tabel lebar penuh
- `height=400` → tinggi tabel 400px (bisa scroll kalau data banyak)

**Fitur Bawaan `st.dataframe()`:**
- ✅ **Sortir** kolom (klik header kolom)
- ✅ **Search** data (kotak pencarian otomatis)
- ✅ **Scroll** horizontal & vertikal
- ✅ **Highlight** cell saat hover

---

### 8️⃣ **Download CSV**
```python
csv = df_display.to_csv(index=False).encode('utf-8')
st.download_button(
    label=f"📥 Download {title} (CSV)",
    data=csv,
    file_name=f'{table_name.lower()}_data.csv',
    mime='text/csv'
)
```

**Cara Kerja:**
1. `df_display.to_csv()` → konversi DataFrame ke format CSV
2. `index=False` → tidak export index pandas
3. `encode('utf-8')` → encode ke bytes
4. `st.download_button()` → tombol download, klik langsung download file

---

## 🎬 Alur Kerja Lengkap (Step by Step)

### **Saat User Buka Dashboard:**

```
1. User buka browser → http://localhost:8501
2. Streamlit load file visualisasi_cookie.py
3. Tampilkan header "Cookie Club - Data Management"
4. Sidebar muncul dengan 14 pilihan tabel
```

### **Saat User Pilih Tabel (Contoh: "🍪 Produk"):**

```
5. User klik "🍪 Produk" di sidebar
6. Variabel `page = "🍪 Produk"`
7. Routing: if page == "🍪 Produk" → call display_table("PRODUK", ...)
8. Fungsi display_table() jalan:
   
   a. Call get_table_data("PRODUK")
      - Koneksi ke MySQL
      - Query: SELECT * FROM PRODUK
      - Result: [(1, 'Choco...', 'Regular', 50000, ...), (2, 'Red...', ...)]
      - Column names: ['produk_id', 'nama_produk', ...]
   
   b. Konversi ke DataFrame:
      df = pd.DataFrame(result, columns=columns)
   
   c. Tampilkan metrics:
      - Total Baris: 5
      - Total Kolom: 6
   
   d. Tampilkan multiselect widget:
      - Options: ['produk_id', 'nama_produk', 'jenis_produk', ...]
      - Default: semua tercentang
   
   e. User BISA KLIK/UNCHECK kolom yang tidak mau ditampilkan
   
   f. Filter DataFrame: df_display = df[selected_columns]
   
   g. Tampilkan tabel: st.dataframe(df_display)
   
   h. Tampilkan tombol download CSV
```

### **Saat User Uncheck Kolom:**

```
9. User uncheck kolom 'deskripsi' dan 'status'
10. Streamlit OTOMATIS re-run code
11. selected_columns sekarang = ['produk_id', 'nama_produk', 'jenis_produk', 'harga_satuan']
12. df_display = df[selected_columns]  → hanya 4 kolom
13. Tabel langsung UPDATE tanpa refresh manual!
```

---

## 🔥 Kenapa Bisa Langsung Muncul Saat Klik Kolom?

### **🎯 Konsep: Streamlit Reactive Programming**

Streamlit pakai konsep **reactive programming** atau **state management**:

1. **Setiap interaksi user = re-run script**
   - Klik checkbox → script di-run ulang dari atas
   - Tapi Streamlit **caching** koneksi database (cepat)

2. **Widget punya state**
   - `st.multiselect()` ingat pilihan user
   - Saat re-run, widget load state terakhir

3. **Flow:**
   ```
   User klik checkbox → Streamlit detect change → Re-run script
   → selected_columns berubah → df_display di-filter ulang
   → st.dataframe() tampilkan data baru → UI update!
   ```

4. **Semua terjadi di SISI SERVER**
   - Bukan JavaScript di browser
   - Streamlit pakai WebSocket untuk komunikasi real-time
   - User rasa kayak web biasa, padahal Python di-run ulang tiap klik

---

## 📊 Perbandingan: Streamlit vs phpMyAdmin

| Fitur | phpMyAdmin | Streamlit (visualisasi_cookie.py) |
|-------|------------|-------------------------------------|
| **Tampilan** | Kompleks, banyak menu | Simpel, fokus data |
| **Pilih Kolom** | Edit query manual | Klik checkbox (user-friendly) |
| **Filter** | WHERE clause manual | Multiselect otomatis |
| **Export** | Banyak langkah | 1 tombol download |
| **Customisasi** | Terbatas | Bisa tambah metrics, charts |
| **Akses** | Butuh install XAMPP | Web app bisa deploy |

---

## 🚀 Cara Menjalankan

```bash
# 1. Pastikan database sudah dibuat
# Jalankan Database.sql di phpMyAdmin

# 2. Install dependencies
pip install streamlit pandas mysql-connector-python

# 3. Jalankan dashboard
cd c:\xampp\htdocs\BASDAT\TUBES\basdat\Tubes
streamlit run visualisasi_cookie.py

# 4. Buka browser
# http://localhost:8501
```

---

## 🎨 Fitur Utama Dashboard

### ✅ **1. Multi-Table Support**
- 14 tabel database dalam 1 dashboard
- Navigasi sidebar dengan radio button

### ✅ **2. Interaktif Column Selection**
- **Multiselect widget** untuk pilih kolom
- Update real-time saat checkbox dicentang/uncheck

### ✅ **3. Metrics Dashboard**
- Total baris, total kolom
- Info cepat tentang data

### ✅ **4. Export to CSV**
- Download data sesuai kolom yang dipilih
- Format CSV siap untuk Excel/Google Sheets

### ✅ **5. Responsive Design**
- Layout wide (lebar penuh)
- Tabel auto-scroll untuk data banyak

### ✅ **6. User-Friendly**
- Tidak perlu SQL query manual
- Cocok untuk non-technical users

---

## 💡 Kelebihan Streamlit untuk Visualisasi Data

1. **✅ Cepat Dibuat**
   - 200 baris code → full dashboard
   - Tidak perlu HTML/CSS/JavaScript

2. **✅ Pure Python**
   - Tidak perlu belajar web development
   - Fokus ke logika data

3. **✅ Reactive by Default**
   - Widget otomatis interaktif
   - State management built-in

4. **✅ Easy Deployment**
   - Bisa deploy ke Streamlit Cloud (gratis)
   - Akses dari mana aja

5. **✅ Rich Components**
   - Charts (Plotly, Altair, Matplotlib)
   - Maps, forms, file uploader
   - Extensible dengan custom components

---

## 🔮 Pengembangan Lanjutan (Optional)

### **Tambahan Fitur yang Bisa Diimplementasikan:**

1. **Filter Data**
   ```python
   filter_jenis = st.selectbox("Filter Jenis Produk", ['Semua', 'Regular', 'Premium'])
   if filter_jenis != 'Semua':
       df = df[df['jenis_produk'] == filter_jenis]
   ```

2. **Search Box**
   ```python
   search = st.text_input("🔍 Cari Produk")
   if search:
       df = df[df['nama_produk'].str.contains(search, case=False)]
   ```

3. **Charts**
   ```python
   st.bar_chart(df['harga_satuan'])
   ```

4. **Edit Data**
   ```python
   with st.form("edit_form"):
       new_price = st.number_input("Harga Baru")
       if st.form_submit_button("Update"):
           # UPDATE query ke database
   ```

---

## 📌 Kesimpulan

**`visualisasi_cookie.py`** adalah dashboard Streamlit sederhana yang:

✅ Menampilkan **14 tabel** database Cookie Club  
✅ Fitur **pilih kolom interaktif** dengan `st.multiselect()`  
✅ Update **real-time** saat user klik checkbox (reactive programming)  
✅ Export CSV dengan 1 klik  
✅ User-friendly, tidak perlu SQL query manual  

**Cara Kerja Interaktif:**
- Streamlit **re-run script** tiap ada interaksi
- Widget `st.multiselect()` simpan **state** pilihan user
- DataFrame di-filter sesuai `selected_columns`
- `st.dataframe()` tampilkan tabel yang sudah di-filter
- Semua terjadi **instant** karena WebSocket real-time

---

**Dibuat oleh:** KELOMPOK 8 BASDAT A  
**File:** `visualisasi_cookie.py`  
**Framework:** Streamlit 1.31.0  
**Tanggal:** 11 Desember 2025
