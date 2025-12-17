# ERD COOKIE CLUB (REVISI MASA DEPAN v2.0)
## Visualisasi & Dokumentasi Teknis Lengkap

---

### 📋 CATATAN PENTING (REVISI BERDASARKAN FEEDBACK DOSEN)

1.  **CUSTOMER & PROFILE**:
    *   Tabel `CUSTOMER_B2C_PROFILE` dan `CUSTOMER_B2B_PROFILE` **DIHAPUS**.
    *   Digantikan oleh **SATU** tabel `CUSTOMER_PROFILE` yang berisi gabungan atribut 
    *   Tabel `CUSTOMER` menggunakan `ENUM('B2C', 'B2B')` untuk tipe customer.

2.  **EVENT MANAGEMENT**:
    *   Tabel `CUSTOMER_EVENT_PROFILE` **DIHAPUS** (karena event bukan "customer" tapi "aktivitas").
    *   Dibuat tabel **`EVENT`** sebagai master data untuk event-event konsisten/besar.
    *   Dibuat tabel **`EVENT_KATEGORI`** untuk hierarki lokasi (Malang, Balikpapan, dll) sesuai visi masa depan.
    *   Penjualan di event dicatat di tabel `PENJUALAN` dengan FK optional ke tabel `EVENT`.

3.  **PURCHASING**:
    *   Tetap menggunakan struktur unified (`SUPPLIER` + `PURCHASE_ORDER` + `PO_ITEM`) karena ini best practice untuk masa depan.

---

### 📊 VISUALISASI ERD (MERMAID DIAGRAM)

```mermaid
erDiagram
    %% CORE BUSINESS %%
    OWNER {
        int owner_id PK
        varchar nama_owner
        varchar no_hp
        varchar status
    }

    PRODUK {
        int produk_id PK
        varchar nama_produk
        varchar jenis_produk
        decimal harga_satuan
        text deskripsi
        varchar status
    }

    PENJUALAN {
        int penjualan_id PK
        date tgl_penjualan
        int customer_id FK
        int owner_id FK
        int event_id FK "Optional (Nullable)"
        varchar tipe_penjualan
        decimal total_transaksi
        text keterangan
    }

    PENJUALAN_DETAIL {
        int detail_id PK
        int penjualan_id FK
        int produk_id FK
        int qty
        decimal harga_satuan
        decimal subtotal
    }

    %% CUSTOMER MANAGEMENT (REVISED) %%
    CUSTOMER {
        int customer_id PK
        varchar nama_customer
        enum tipe "ENUM('B2C', 'B2B')"
        varchar no_hp
        varchar email
        varchar status
    }

    CUSTOMER_PROFILE {
        int profile_id PK
        int customer_id FK
        varchar alamat "B2B/Delivery"
        varchar npwp "B2B Only"
        varchar pic_name "B2B Only"
        varchar payment_terms "B2B Only"
    }

    %% EVENT MANAGEMENT (REVISED - HIERARCHICAL) %%
    EVENT_KATEGORI {
        int kategori_id PK
        varchar nama_kategori "Lokasi: Malang, dll"
        text deskripsi
    }

    EVENT {
        int event_id PK
        int kategori_id FK
        varchar nama_event
        date tgl_mulai
        date tgl_selesai
        varchar lokasi_spesifik
        varchar status
    }

    %% PURCHASING SYSTEM %%
    SUPPLIER {
        int supplier_id PK
        varchar nama_supplier
        varchar kontak_person
        varchar no_telepon
        varchar alamat
        varchar status 
    }

    PURCHASE_ORDER {
        int po_id PK
        int supplier_id FK
        int created_by FK "Ref Owner"
        varchar po_no
        date tgl_po
        varchar status
        decimal grand_total
        text keterangan 
    }

    PO_ITEM {
        int po_item_id PK
        int po_id FK
        varchar item_category
        varchar nama_item
        decimal qty_ordered
        decimal harga_satuan
        decimal subtotal
    }

    %% ACCOUNTING %%
    AKUN_KEUANGAN {
        int akun_id PK
        varchar kode_akun
        varchar nama_akun
        varchar tipe_laporan
        varchar saldo_normal
    }

    BEBAN_OPERASIONAL {
        int beban_id PK
        int owner_id FK
        int event_id FK "Optional (Nullable)"
        date tgl_beban
        varchar jenis_beban
        decimal nominal
        text keterangan 
    }

    JURNAL_TRANSAKSI {
        int jurnal_id PK
        date tanggal
        int akun_debit_id FK
        int akun_kredit_id FK
        decimal nominal
        varchar deskripsi
        int penjualan_id FK "Optional"
        int po_id FK "Optional"
        int beban_id FK "Optional"
    }

    %% RELASI ANTAR ENTITAS %%
    OWNER ||--o{ PENJUALAN : "mencatat"
    OWNER ||--o{ PURCHASE_ORDER : "membuat"
    OWNER ||--o{ BEBAN_OPERASIONAL : "mencatat"
    
    CUSTOMER ||--o{ PENJUALAN : "melakukan"
    CUSTOMER ||--|{ CUSTOMER_PROFILE : "memiliki detail (1:1)"
    
    PRODUK ||--o{ PENJUALAN_DETAIL : "terjual"
    PENJUALAN ||--|{ PENJUALAN_DETAIL : "memiliki"
    
    EVENT_KATEGORI ||--o{ EVENT : "mengelompokkan"
    EVENT ||--o{ PENJUALAN : "tempat transaksi (optional)"
    EVENT ||--o{ BEBAN_OPERASIONAL : "sumber biaya (optional)"
    
    SUPPLIER ||--o{ PURCHASE_ORDER : "menerima"
    PURCHASE_ORDER ||--|{ PO_ITEM : "memiliki"
    
    AKUN_KEUANGAN ||--o{ JURNAL_TRANSAKSI : "dicatat di"
    PENJUALAN ||--o| JURNAL_TRANSAKSI : "tercatat (optional)"
    PURCHASE_ORDER ||--o| JURNAL_TRANSAKSI : "tercatat (optional)"
    BEBAN_OPERASIONAL ||--o| JURNAL_TRANSAKSI : "tercatat (optional)"
```

---

### 🏗️ STRUKTUR SQL LENGKAP (SCHEMA)

#### 1. CUSTOMER MANAGEMENT (REVISI)

**Tabel: CUSTOMER**
*Penyederhanaan tipe customer menggunakan ENUM sesuai saran dosen.*
```sql
CREATE TABLE CUSTOMER (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_customer VARCHAR(100) NOT NULL,
    tipe ENUM('B2C', 'B2B') NOT NULL,  -- REVISI: Pakai ENUM
    no_hp VARCHAR(15),
    email VARCHAR(100),
    status VARCHAR(20) DEFAULT 'Aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Tabel: CUSTOMER_PROFILE**
*Satu tabel gabungan untuk detail B2B dan B2C. Kolom bersifat NULLABLE.*
```sql
CREATE TABLE CUSTOMER_PROFILE (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL UNIQUE,
    
    -- Atribut B2B (Nullable)
    alamat_bisnis VARCHAR(255) NULL,
    npwp VARCHAR(20) NULL,
    pic_name VARCHAR(100) NULL,
    payment_terms VARCHAR(50) NULL,    
    
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE
);
```

#### 2. EVENT MANAGEMENT (REVISI HIERARKI)

**Tabel: EVENT_KATEGORI**
*Master data lokasi/wilayah untuk masa depan (Multi-kota).*
```sql
CREATE TABLE EVENT_KATEGORI (
    kategori_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_kategori VARCHAR(100) NOT NULL,  -- Contoh: "Malang", "Surabaya"
    deskripsi TEXT
);
```

**Tabel: EVENT**
*Master data event yang konsisten/besar.*
```sql
CREATE TABLE EVENT (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    kategori_id INT NOT NULL,             -- FK ke Lokasi
    nama_event VARCHAR(100) NOT NULL,     -- Contoh: "FIB 2025"
    tgl_mulai DATE NOT NULL,
    tgl_selesai DATE,
    lokasi_spesifik VARCHAR(255),         -- Contoh: "Booth A5, Universitas Brawijaya"
    status VARCHAR(20) DEFAULT 'Aktif',   -- Planned/Active/Completed
    
    FOREIGN KEY (kategori_id) REFERENCES EVENT_KATEGORI(kategori_id)
);
```

#### 3. TRANSAKSI & OPERASIONAL (UPDATE)

**Tabel: PENJUALAN (Update)**
*Menambahkan kolom `event_id` (nullable) untuk relasi ke event tertentu.*
```sql
CREATE TABLE PENJUALAN (
    penjualan_id INT PRIMARY KEY AUTO_INCREMENT,
    tgl_penjualan DATE NOT NULL,
    customer_id INT NOT NULL,
    owner_id INT NOT NULL,
    event_id INT NULL,                    -- REVISI: FK ke tabel EVENT (Optional)
    tipe_penjualan VARCHAR(20) NOT NULL,  -- 'B2C', 'B2B', 'Event'
    total_transaksi DECIMAL(12,2) NOT NULL,
    keterangan TEXT,
    
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (owner_id) REFERENCES OWNER(owner_id),
    FOREIGN KEY (event_id) REFERENCES EVENT(event_id)
);
```

**Tabel: BEBAN_OPERASIONAL (Update)**
*Menambahkan kolom `event_id` untuk tracking biaya spesifik event (sewa booth, dll).*
```sql
CREATE TABLE BEBAN_OPERASIONAL (
    beban_id INT PRIMARY KEY AUTO_INCREMENT,
    tgl_beban DATE NOT NULL,
    jenis_beban VARCHAR(50) NOT NULL,
    deskripsi VARCHAR(255) NOT NULL,
    nominal DECIMAL(12,2) NOT NULL,
    owner_id INT NOT NULL,
    event_id INT NULL,                    -- REVISI: FK ke tabel EVENT (Optional)
    
    FOREIGN KEY (owner_id) REFERENCES OWNER(owner_id),
    FOREIGN KEY (event_id) REFERENCES EVENT(event_id)
);
```

*(Tabel lainnya seperti OWNER, PRODUK, SUPPLIER, PURCHASE_ORDER, PO_ITEM, AKUN_KEUANGAN, JURNAL_TRANSAKSI tetap menggunakan struktur standar masa depan yang sudah disepakati sebelumnya)*.

---

### 🎯 ANALISIS KECOCOKAN DENGAN MASA DEPAN

1.  **Fleksibilitas Customer**: Struktur `CUSTOMER` + `CUSTOMER_PROFILE` sangat efisien. Jika ada customer B2B, kita isi field B2B. Jika B2C. Tidak perlu banyak join tabel, tapi data tetap terpisah rapi.
2.  **Skalabilitas Event**: Dengan memisahkan `EVENT` dan `EVENT_KATEGORI`, sistem siap jika Cookie Club buka cabang di kota lain. Kita bisa filter laporan: "Berapa total penjualan event di Malang vs Surabaya?".
3.  **ROI Tracking**: Karena `PENJUALAN` dan `BEBAN_OPERASIONAL` sama-sama punya FK ke `EVENT`, kita bisa hitung ROI per event dengan mudah: `(SUM(Penjualan) - SUM(Beban)) WHERE event_id = X`.
4.  **Purchasing Power**: Struktur purchasing unified siap menangani supplier bahan baku, kemasan, bahkan alat berat sekalipun tanpa perlu mengubah struktur database.
