# 📋 Dokumentasi DDL dan DML - Cookie Club Database

**Tugas Besar Basis Data**  
**Kelompok:** 8 BASDAT A  
**Database:** `cookie_db`  
**Tanggal:** 10 Desember 2025

---

## 📖 Pengertian DDL dan DML

### 🏗️ DDL (Data Definition Language)

**DDL** adalah sub-bahasa SQL yang digunakan untuk **mendefinisikan dan memodifikasi struktur database**. DDL berfokus pada pembuatan, perubahan, dan penghapusan objek database seperti tabel, index, dan constraint.

**Fungsi DDL:**
- Membuat struktur tabel dan database
- Menentukan tipe data kolom
- Mendefinisikan constraint (PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL)
- Mengatur relasi antar tabel
- Memodifikasi atau menghapus struktur database

**Perintah DDL yang umum digunakan:**
- `CREATE` - Membuat database, tabel, index, atau objek lainnya
- `ALTER` - Mengubah struktur tabel yang sudah ada
- `DROP` - Menghapus database, tabel, atau objek lainnya
- `TRUNCATE` - Menghapus semua data dalam tabel tanpa menghapus strukturnya
- `RENAME` - Mengubah nama tabel atau kolom

**Karakteristik DDL:**
- ✅ Auto-commit (perubahan langsung tersimpan)
- ✅ Mengubah metadata database
- ✅ Tidak dapat di-rollback
- ✅ Mempengaruhi struktur, bukan data

---

### 📝 DML (Data Manipulation Language)

**DML** adalah sub-bahasa SQL yang digunakan untuk **memanipulasi data** di dalam tabel yang sudah dibuat. DML berfokus pada operasi CRUD (Create, Read, Update, Delete) terhadap data.

**Fungsi DML:**
- Memasukkan data baru ke dalam tabel
- Membaca/mengambil data dari tabel
- Mengubah data yang sudah ada
- Menghapus data dari tabel
- Melakukan query dan filter data

**Perintah DML yang umum digunakan:**
- `INSERT` - Menambahkan record/baris baru ke dalam tabel
- `SELECT` - Mengambil/membaca data dari tabel
- `UPDATE` - Mengubah data yang sudah ada
- `DELETE` - Menghapus record/baris dari tabel

**Karakteristik DML:**
- ✅ Memerlukan COMMIT untuk menyimpan perubahan (dalam transaction mode)
- ✅ Dapat di-rollback sebelum di-commit
- ✅ Mengubah data, bukan struktur
- ✅ Mempengaruhi isi tabel

---

### 🔄 Perbedaan DDL dan DML

| Aspek | DDL | DML |
|-------|-----|-----|
| **Tujuan** | Mendefinisikan struktur database | Memanipulasi data dalam database |
| **Operasi** | CREATE, ALTER, DROP, TRUNCATE | INSERT, SELECT, UPDATE, DELETE |
| **Target** | Struktur tabel (schema) | Isi tabel (data/record) |
| **Commit** | Auto-commit | Manual commit (dalam transaction) |
| **Rollback** | Tidak bisa di-rollback | Bisa di-rollback sebelum commit |
| **Contoh** | Membuat tabel CUSTOMER | Menambah data customer baru |

---

## 🏗️ Implementasi DDL (Data Definition Language)

DDL adalah perintah SQL untuk **mendefinisikan struktur database**, termasuk membuat, mengubah, dan menghapus tabel.

### 1. CREATE DATABASE

```sql
CREATE DATABASE cookie_db;
USE cookie_db;
```

### 2. CREATE TABLE (14 Tabel)

#### 2.1 Tabel OWNER
```sql
CREATE TABLE OWNER (
    owner_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_owner VARCHAR(100) NOT NULL,
    no_hp VARCHAR(15),
    email VARCHAR(100)
);
```
**Fungsi:** Menyimpan data pemilik usaha Cookie Club.

---

#### 2.2 Tabel PRODUK
```sql
CREATE TABLE PRODUK (
    produk_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_produk VARCHAR(100) NOT NULL,
    jenis_produk VARCHAR(50),
    harga_satuan DECIMAL(10,2) NOT NULL,
    deskripsi TEXT,
    status VARCHAR(20) DEFAULT 'Tersedia'
);
```
**Fungsi:** Menyimpan katalog produk cookie (Regular/Premium).

---

#### 2.3 Tabel CUSTOMER
```sql
CREATE TABLE CUSTOMER (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_customer VARCHAR(100) NOT NULL,
    tipe ENUM('B2C', 'B2B') NOT NULL,
    no_hp VARCHAR(15),
    email VARCHAR(100),
    status VARCHAR(20) DEFAULT 'Aktif'
);
```
**Fungsi:** Menyimpan data pelanggan (B2C = Retail, B2B = Wholesaler).

---

#### 2.4 Tabel CUSTOMER_PROFILE
```sql
CREATE TABLE CUSTOMER_PROFILE (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    alamat TEXT,
    npwp VARCHAR(20),
    pic_name VARCHAR(100),
    payment_terms VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```
**Fungsi:** Menyimpan profil lengkap pelanggan (khususnya B2B dengan payment terms).

---

#### 2.5 Tabel PENJUALAN
```sql
CREATE TABLE PENJUALAN (
    penjualan_id INT PRIMARY KEY AUTO_INCREMENT,
    tgl_penjualan DATE NOT NULL,
    customer_id INT NOT NULL,
    total_transaksi DECIMAL(12,2) NOT NULL,
    tipe_penjualan ENUM('B2C', 'B2B') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```
**Fungsi:** Menyimpan header transaksi penjualan.

---

#### 2.6 Tabel PENJUALAN_DETAIL
```sql
CREATE TABLE PENJUALAN_DETAIL (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    penjualan_id INT NOT NULL,
    produk_id INT NOT NULL,
    qty INT NOT NULL,
    harga_satuan DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (penjualan_id) REFERENCES PENJUALAN(penjualan_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (produk_id) REFERENCES PRODUK(produk_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```
**Fungsi:** Menyimpan detail item per transaksi penjualan.

---

#### 2.7 Tabel EVENT_KATEGORI
```sql
CREATE TABLE EVENT_KATEGORI (
    kategori_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_kategori VARCHAR(50) NOT NULL,
    deskripsi TEXT
);
```
**Fungsi:** Menyimpan kategori event (Bazar, Workshop, Festival).

---

#### 2.8 Tabel EVENT
```sql
CREATE TABLE EVENT (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_event VARCHAR(100) NOT NULL,
    kategori_id INT NOT NULL,
    lokasi VARCHAR(200),
    tgl_mulai DATE NOT NULL,
    tgl_selesai DATE NOT NULL,
    biaya_sewa DECIMAL(10,2),
    FOREIGN KEY (kategori_id) REFERENCES EVENT_KATEGORI(kategori_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```
**Fungsi:** Menyimpan data event tempat Cookie Club berjualan.

---

#### 2.9 Tabel SUPPLIER
```sql
CREATE TABLE SUPPLIER (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_supplier VARCHAR(100) NOT NULL,
    jenis_bahan VARCHAR(100),
    no_hp VARCHAR(15),
    email VARCHAR(100),
    alamat TEXT
);
```
**Fungsi:** Menyimpan data supplier bahan baku.

---

#### 2.10 Tabel PURCHASE_ORDER
```sql
CREATE TABLE PURCHASE_ORDER (
    po_id INT PRIMARY KEY AUTO_INCREMENT,
    tgl_order DATE NOT NULL,
    supplier_id INT NOT NULL,
    total_po DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```
**Fungsi:** Menyimpan header Purchase Order pembelian bahan baku.

---

#### 2.11 Tabel PO_ITEM
```sql
CREATE TABLE PO_ITEM (
    po_item_id INT PRIMARY KEY AUTO_INCREMENT,
    po_id INT NOT NULL,
    nama_bahan VARCHAR(100) NOT NULL,
    qty INT NOT NULL,
    harga_satuan DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (po_id) REFERENCES PURCHASE_ORDER(po_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```
**Fungsi:** Menyimpan detail item per Purchase Order.

---

#### 2.12 Tabel AKUN_KEUANGAN
```sql
CREATE TABLE AKUN_KEUANGAN (
    akun_id INT PRIMARY KEY AUTO_INCREMENT,
    kode_akun VARCHAR(20) NOT NULL UNIQUE,
    nama_akun VARCHAR(100) NOT NULL,
    tipe_laporan VARCHAR(30) NOT NULL,
    saldo_normal VARCHAR(10) NOT NULL
);
```
**Fungsi:** Menyimpan Chart of Accounts (COA) untuk sistem akuntansi.

---

#### 2.13 Tabel BEBAN_OPERASIONAL
```sql
CREATE TABLE BEBAN_OPERASIONAL (
    beban_id INT PRIMARY KEY AUTO_INCREMENT,
    tanggal DATE NOT NULL,
    jenis_beban VARCHAR(50) NOT NULL,
    keterangan VARCHAR(255),
    nominal DECIMAL(12,2) NOT NULL,
    owner_id INT NOT NULL,
    event_id INT,
    FOREIGN KEY (owner_id) REFERENCES OWNER(owner_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (event_id) REFERENCES EVENT(event_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
```
**Fungsi:** Menyimpan beban operasional usaha (sewa, transport, bahan baku).

---

#### 2.14 Tabel JURNAL_TRANSAKSI
```sql
CREATE TABLE JURNAL_TRANSAKSI (
    jurnal_id INT PRIMARY KEY AUTO_INCREMENT,
    tanggal DATE NOT NULL,
    nomor_jurnal VARCHAR(20) NOT NULL UNIQUE,
    deskripsi VARCHAR(255),
    akun_id INT NOT NULL,
    debit DECIMAL(12,2) DEFAULT 0,
    kredit DECIMAL(12,2) DEFAULT 0,
    ref_type VARCHAR(20),
    ref_id INT,
    FOREIGN KEY (akun_id) REFERENCES AKUN_KEUANGAN(akun_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```
**Fungsi:** Menyimpan jurnal double-entry bookkeeping untuk setiap transaksi.

---

## 📝 Implementasi DML (Data Manipulation Language)

### 1. INSERT - Memasukkan Data

#### 1.1 INSERT Data OWNER
```sql
INSERT INTO OWNER (nama_owner, no_hp, email) VALUES 
('Sarah Wijaya', '081234567890', 'sarah@cookieclub.com'),
('Lisa Anggraini', '082345678901', 'lisa@cookieclub.com');
```
**Hasil:** 2 pemilik usaha ditambahkan.

---

#### 1.2 INSERT Data PRODUK
```sql
INSERT INTO PRODUK (nama_produk, jenis_produk, harga_satuan, deskripsi, status) VALUES 
('Chocolate Chip Cookie', 'Regular', 50000, 'Isi 10 pcs per box', 'Tersedia'),
('Red Velvet Cookie', 'Premium', 75000, 'Isi 8 pcs per box', 'Tersedia'),
('Matcha Cookie', 'Premium', 70000, 'Isi 8 pcs per box', 'Tersedia'),
('Peanut Butter Cookie', 'Regular', 45000, 'Isi 10 pcs per box', 'Tersedia'),
('Double Chocolate', 'Premium', 80000, 'Isi 8 pcs per box', 'Tersedia');
```
**Hasil:** 5 produk cookie ditambahkan (2 Regular, 3 Premium).

---

#### 1.3 INSERT Data CUSTOMER
```sql
INSERT INTO CUSTOMER (nama_customer, tipe, no_hp, email, status) VALUES 
('Budi Santoso', 'B2C', '081234567890', 'budi@email.com', 'Aktif'),
('Cafe Kopi Nusantara', 'B2B', '081987654321', 'cafe.kopi@email.com', 'Aktif'),
('Toko Roti Bahagia', 'B2B', '082112233445', 'roti.bahagia@email.com', 'Aktif'),
('Dewi Lestari', 'B2C', '085566778899', 'dewi@email.com', 'Aktif'),
('Ahmad Fauzi', 'B2C', '089988776655', 'ahmad@email.com', 'Aktif');
```
**Hasil:** 5 pelanggan ditambahkan (3 B2C Retail, 2 B2B Wholesaler).

---

#### 1.4 INSERT Data CUSTOMER_PROFILE
```sql
INSERT INTO CUSTOMER_PROFILE (customer_id, alamat, npwp, pic_name, payment_terms) VALUES 
(1, 'Jl. Merdeka No. 10, Jakarta', NULL, NULL, NULL),
(2, 'Jl. Sudirman No. 45, Jakarta', '01.234.567.8-901.000', 'Pak Joko', 'NET 30'),
(3, 'Jl. Gatot Subroto No. 88, Jakarta', '01.987.654.3-210.000', 'Ibu Siti', 'NET 14'),
(4, 'Jl. Thamrin No. 25, Jakarta', NULL, NULL, NULL),
(5, 'Jl. Asia Afrika No. 15, Bandung', NULL, NULL, NULL);
```
**Hasil:** Profil lengkap untuk semua customer (B2B punya NPWP & payment terms).

---

#### 1.5 INSERT Data PENJUALAN
```sql
INSERT INTO PENJUALAN (tgl_penjualan, customer_id, total_transaksi, tipe_penjualan) VALUES 
('2025-11-05', 1, 150000, 'B2C'),
('2025-11-06', 2, 1500000, 'B2B'),
('2025-11-07', 4, 70000, 'B2C'),
('2025-11-08', 3, 2000000, 'B2B'),
('2025-11-09', 5, 50000, 'B2C'),
('2025-11-10', 1, 225000, 'B2C');
```
**Hasil:** 6 transaksi penjualan (4 B2C, 2 B2B).

---

#### 1.6 INSERT Data PENJUALAN_DETAIL
```sql
INSERT INTO PENJUALAN_DETAIL (penjualan_id, produk_id, qty, harga_satuan, subtotal) VALUES 
(1, 1, 2, 50000, 100000),
(1, 2, 1, 75000, 75000),
(2, 1, 20, 50000, 1000000),
(2, 4, 10, 45000, 450000),
(3, 3, 1, 70000, 70000),
(4, 5, 25, 80000, 2000000),
(5, 1, 1, 50000, 50000),
(6, 2, 3, 75000, 225000);
```
**Hasil:** 8 detail item transaksi.

---

#### 1.7 INSERT Data AKUN_KEUANGAN (Chart of Accounts)
```sql
INSERT INTO AKUN_KEUANGAN (kode_akun, nama_akun, tipe_laporan, saldo_normal) VALUES 
('1-1000', 'Kas', 'Aset', 'Debit'),
('1-1100', 'Bank', 'Aset', 'Debit'),
('1-2000', 'Piutang Usaha', 'Aset', 'Debit'),
('2-1000', 'Utang Usaha', 'Liabilitas', 'Kredit'),
('3-1000', 'Modal Pemilik', 'Modal', 'Kredit'),
('4-1000', 'Pendapatan Penjualan', 'Pendapatan', 'Kredit'),
('5-1000', 'Beban Operasional', 'Beban', 'Debit'),
('5-2000', 'HPP', 'Beban', 'Debit');
```
**Hasil:** 8 akun keuangan untuk sistem akuntansi double-entry.

---

#### 1.8 INSERT Data JURNAL_TRANSAKSI
```sql
-- Contoh: Jurnal untuk Penjualan #1 (B2C Cash)
INSERT INTO JURNAL_TRANSAKSI (tanggal, nomor_jurnal, deskripsi, akun_id, debit, kredit, ref_type, ref_id) VALUES 
('2025-11-05', 'JU-2025-001', 'Penjualan B2C #1 - Cash', 1, 150000, 0, 'PENJUALAN', 1),
('2025-11-05', 'JU-2025-001', 'Penjualan B2C #1 - Revenue', 6, 0, 150000, 'PENJUALAN', 1);

-- Contoh: Jurnal untuk Penjualan #2 (B2B Credit)
INSERT INTO JURNAL_TRANSAKSI (tanggal, nomor_jurnal, deskripsi, akun_id, debit, kredit, ref_type, ref_id) VALUES 
('2025-11-06', 'JU-2025-002', 'Penjualan B2B #2 - Piutang', 3, 1500000, 0, 'PENJUALAN', 2),
('2025-11-06', 'JU-2025-002', 'Penjualan B2B #2 - Revenue', 6, 0, 1500000, 'PENJUALAN', 2);
```
**Hasil:** Jurnal double-entry untuk setiap transaksi (Debit = Kredit).

---

### 2. SELECT - Membaca Data

#### 2.1 SELECT Semua Customer
```sql
SELECT * FROM CUSTOMER;
```

#### 2.2 SELECT Produk Premium
```sql
SELECT nama_produk, harga_satuan 
FROM PRODUK 
WHERE jenis_produk = 'Premium';
```

#### 2.3 SELECT Penjualan dengan JOIN
```sql
SELECT 
    p.penjualan_id,
    p.tgl_penjualan,
    c.nama_customer,
    p.total_transaksi,
    p.tipe_penjualan
FROM PENJUALAN p
JOIN CUSTOMER c ON p.customer_id = c.customer_id
ORDER BY p.tgl_penjualan DESC;
```

#### 2.4 SELECT Total Revenue per Customer
```sql
SELECT 
    c.nama_customer,
    SUM(p.total_transaksi) AS total_revenue
FROM PENJUALAN p
JOIN CUSTOMER c ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_revenue DESC;
```

---

### 3. UPDATE - Mengubah Data

#### 3.1 UPDATE Harga Produk
```sql
UPDATE PRODUK 
SET harga_satuan = 55000 
WHERE produk_id = 1;
```

#### 3.2 UPDATE Status Customer
```sql
UPDATE CUSTOMER 
SET status = 'Tidak Aktif' 
WHERE customer_id = 5;
```

#### 3.3 UPDATE Status Purchase Order
```sql
UPDATE PURCHASE_ORDER 
SET status = 'Completed' 
WHERE po_id = 1;
```

---

### 4. DELETE - Menghapus Data

#### 4.1 DELETE Produk (dengan CASCADE)
```sql
DELETE FROM PRODUK 
WHERE produk_id = 5;
-- Otomatis hapus PENJUALAN_DETAIL terkait karena ON DELETE RESTRICT
```

#### 4.2 DELETE Customer B2C
```sql
DELETE FROM CUSTOMER 
WHERE customer_id = 5;
-- Otomatis hapus CUSTOMER_PROFILE karena ON DELETE CASCADE
```

---

## 🔗 Relationship & Constraints

### Foreign Key Constraints:
1. **CUSTOMER_PROFILE** → **CUSTOMER** (ON DELETE CASCADE)
2. **PENJUALAN** → **CUSTOMER** (ON DELETE RESTRICT)
3. **PENJUALAN_DETAIL** → **PENJUALAN** (ON DELETE CASCADE)
4. **PENJUALAN_DETAIL** → **PRODUK** (ON DELETE RESTRICT)
5. **EVENT** → **EVENT_KATEGORI** (ON DELETE RESTRICT)
6. **PURCHASE_ORDER** → **SUPPLIER** (ON DELETE RESTRICT)
7. **PO_ITEM** → **PURCHASE_ORDER** (ON DELETE CASCADE)
8. **BEBAN_OPERASIONAL** → **OWNER** (ON DELETE RESTRICT)
9. **BEBAN_OPERASIONAL** → **EVENT** (ON DELETE SET NULL)
10. **JURNAL_TRANSAKSI** → **AKUN_KEUANGAN** (ON DELETE RESTRICT)

### Constraint Explanation:
- **CASCADE**: Hapus data parent = hapus data child otomatis
- **RESTRICT**: Tidak bisa hapus parent kalau masih ada child
- **SET NULL**: Hapus parent = child jadi NULL

---

## 📊 Statistik Database

| Item | Jumlah |
|------|--------|
| **Total Tabel** | 14 |
| **Total Foreign Keys** | 10 |
| **Total Records** | ~100+ |
| **Owner** | 2 orang |
| **Produk** | 5 item |
| **Customer** | 5 (3 B2C, 2 B2B) |
| **Transaksi Penjualan** | 6 (4 B2C, 2 B2B) |
| **Akun Keuangan** | 8 COA |
| **Jurnal Entry** | 14 (double-entry) |

---

## 🎯 Kesimpulan

Database `cookie_db` mengimplementasikan:
- ✅ **DDL**: 14 tabel dengan relasi Foreign Key yang kompleks
- ✅ **DML**: INSERT, SELECT, UPDATE, DELETE lengkap
- ✅ **Normalisasi**: Database sudah dalam bentuk 3NF
- ✅ **Integritas**: Constraint CASCADE/RESTRICT terjaga
- ✅ **Akuntansi**: Sistem double-entry bookkeeping

---

**Dibuat oleh:** KELOMPOK 8 BASDAT A  
**File SQL:** `Database.sql`  
**Tanggal:** 10 Desember 2025
