-- =====================================================
-- DATABASE COOKIE CLUB - VERSI LENGKAP (14 TABEL)
-- Database untuk UMKM Cookie Club dengan fitur lengkap
-- Mudah dipahami & siap untuk masa depan
-- =====================================================

-- Hapus database lama jika ada (HATI-HATI: Semua data akan hilang!)

-- Buat database baru
USE cookie_db;

-- =====================================================
-- BAGIAN 1: TABEL DASAR (4 Tabel)
-- =====================================================

-- 1. OWNER - Siapa yang input/kelola transaksi
CREATE TABLE OWNER (
    owner_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_owner VARCHAR(100) NOT NULL,
    no_hp VARCHAR(15),
    status VARCHAR(20) DEFAULT 'Aktif'
);

-- 2. PRODUK - Cookie yang dijual
CREATE TABLE PRODUK (
    produk_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_produk VARCHAR(100) NOT NULL,
    jenis_produk VARCHAR(50) NOT NULL, -- Regular/Premium/Bundle
    harga_satuan DECIMAL(12, 2) NOT NULL,
    deskripsi TEXT,
    status VARCHAR(20) DEFAULT 'Tersedia'
);

-- 3. PENJUALAN - Header transaksi jual
CREATE TABLE PENJUALAN (
    penjualan_id INT PRIMARY KEY AUTO_INCREMENT,
    tgl_penjualan DATE NOT NULL,
    customer_id INT NOT NULL,
    owner_id INT NOT NULL,
    event_id INT NULL, -- Kosong jika bukan di event
    tipe_penjualan VARCHAR(20) NOT NULL, -- B2C/B2B/Event
    total_transaksi DECIMAL(12, 2) NOT NULL,
    keterangan TEXT
);

-- 4. PENJUALAN_DETAIL - Detail produk yang dibeli
CREATE TABLE PENJUALAN_DETAIL (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    penjualan_id INT NOT NULL,
    produk_id INT NOT NULL,
    qty INT NOT NULL,
    harga_satuan DECIMAL(12, 2) NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL
);

-- =====================================================
-- BAGIAN 2: CUSTOMER (2 Tabel)
-- =====================================================

-- 5. CUSTOMER - Data pembeli (B2C & B2B)
CREATE TABLE CUSTOMER (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_customer VARCHAR(100) NOT NULL,
    tipe ENUM('B2C', 'B2B') NOT NULL, -- B2C=Retail, B2B=Grosir
    no_hp VARCHAR(15),
    email VARCHAR(100),
    status VARCHAR(20) DEFAULT 'Aktif'
);

-- 6. CUSTOMER_PROFILE - Detail tambahan customer
CREATE TABLE CUSTOMER_PROFILE (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    alamat VARCHAR(255),
    npwp VARCHAR(20), -- Untuk B2B
    pic_name VARCHAR(100), -- Untuk B2B
    payment_terms VARCHAR(50) -- Untuk B2B (NET 30, dll)
);

SELECT * FROM customer_profile;
-- =====================================================
-- BAGIAN 3: EVENT (2 Tabel)
-- =====================================================

-- 7. EVENT_KATEGORI - Lokasi event (Malang, Surabaya, dll)
CREATE TABLE EVENT_KATEGORI (
    kategori_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_kategori VARCHAR(100) NOT NULL, -- Malang, Surabaya, Jakarta
    deskripsi TEXT
);

-- 8. EVENT - Data bazaar/pameran
CREATE TABLE EVENT (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    kategori_id INT NOT NULL,
    nama_event VARCHAR(100) NOT NULL,
    tgl_mulai DATE NOT NULL,
    tgl_selesai DATE,
    lokasi_spesifik VARCHAR(255), -- Detail booth/tempat
    status VARCHAR(20) DEFAULT 'Planned' -- Planned/Active/Completed
);

-- =====================================================
-- BAGIAN 4: PURCHASING (3 Tabel)
-- =====================================================

-- 9. SUPPLIER - Data vendor/pemasok
CREATE TABLE SUPPLIER (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    nama_supplier VARCHAR(100) NOT NULL,
    kontak_person VARCHAR(100),
    no_telepon VARCHAR(15),
    alamat VARCHAR(255),
    status VARCHAR(20) DEFAULT 'Aktif'
);

-- 10. PURCHASE_ORDER - Header pembelian bahan
CREATE TABLE PURCHASE_ORDER (
    po_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT NOT NULL,
    created_by INT NOT NULL, -- FK ke OWNER
    po_no VARCHAR(50) NOT NULL UNIQUE,
    tgl_po DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Draft', -- Draft/Approved/Received
    grand_total DECIMAL(15, 2) NOT NULL,
    keterangan TEXT
);

-- 11. PO_ITEM - Detail pembelian bahan
CREATE TABLE PO_ITEM (
    po_item_id INT PRIMARY KEY AUTO_INCREMENT,
    po_id INT NOT NULL,
    item_category VARCHAR(50) NOT NULL, -- Bahan Baku/Kemasan/Alat
    nama_item VARCHAR(100) NOT NULL,
    qty_ordered DECIMAL(10, 2) NOT NULL,
    harga_satuan DECIMAL(12, 2) NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL
);

-- =====================================================
-- BAGIAN 5: ACCOUNTING (3 Tabel)
-- =====================================================

-- 12. AKUN_KEUANGAN - Daftar akun keuangan (Chart of Accounts)
CREATE TABLE AKUN_KEUANGAN (
    akun_id INT PRIMARY KEY AUTO_INCREMENT,
    kode_akun VARCHAR(20) NOT NULL UNIQUE,
    nama_akun VARCHAR(100) NOT NULL,
    tipe_laporan VARCHAR(30) NOT NULL, -- Aset/Liabilitas/Modal/Pendapatan/Beban
    saldo_normal VARCHAR(10) NOT NULL -- Debit/Kredit
);

-- 13. BEBAN_OPERASIONAL - Biaya-biaya operasional
CREATE TABLE BEBAN_OPERASIONAL (
    beban_id INT PRIMARY KEY AUTO_INCREMENT,
    tanggal DATE NOT NULL,
    jenis_beban VARCHAR(50) NOT NULL,
    keterangan VARCHAR(255),
    nominal DECIMAL(12, 2) NOT NULL,
    owner_id INT NOT NULL,
    event_id INT NULL -- Kosong jika bukan biaya event
);

-- 14. JURNAL_TRANSAKSI - Jurnal pembukuan (Double Entry)
CREATE TABLE JURNAL_TRANSAKSI (
    jurnal_id INT PRIMARY KEY AUTO_INCREMENT,
    tanggal DATE NOT NULL,
    akun_debit_id INT NOT NULL,
    akun_kredit_id INT NOT NULL,
    nominal DECIMAL(12, 2) NOT NULL,
    deskripsi VARCHAR(255),
    penjualan_id INT NULL,
    po_id INT NULL,
    beban_id INT NULL
);

-- =====================================================
-- TAMBAH FOREIGN KEY (Relasi Antar Tabel)
-- =====================================================

-- Relasi PENJUALAN
ALTER TABLE PENJUALAN
ADD FOREIGN KEY (customer_id) REFERENCES CUSTOMER (customer_id),
ADD FOREIGN KEY (owner_id) REFERENCES OWNER (owner_id),
ADD FOREIGN KEY (event_id) REFERENCES EVENT (event_id) ON DELETE SET NULL;

-- Relasi PENJUALAN_DETAIL
ALTER TABLE PENJUALAN_DETAIL
ADD FOREIGN KEY (penjualan_id) REFERENCES PENJUALAN (penjualan_id) ON DELETE CASCADE,
ADD FOREIGN KEY (produk_id) REFERENCES PRODUK (produk_id);

-- Relasi CUSTOMER_PROFILE
ALTER TABLE CUSTOMER_PROFILE
ADD FOREIGN KEY (customer_id) REFERENCES CUSTOMER (customer_id) ON DELETE CASCADE;

-- Relasi EVENT
ALTER TABLE EVENT
ADD FOREIGN KEY (kategori_id) REFERENCES EVENT_KATEGORI (kategori_id);

-- Relasi PURCHASE_ORDER
ALTER TABLE PURCHASE_ORDER
ADD FOREIGN KEY (supplier_id) REFERENCES SUPPLIER (supplier_id),
ADD FOREIGN KEY (created_by) REFERENCES OWNER (owner_id);

-- Relasi PO_ITEM
ALTER TABLE PO_ITEM
ADD FOREIGN KEY (po_id) REFERENCES PURCHASE_ORDER (po_id) ON DELETE CASCADE;

-- Relasi BEBAN_OPERASIONAL
ALTER TABLE BEBAN_OPERASIONAL
ADD FOREIGN KEY (owner_id) REFERENCES OWNER (owner_id),
ADD FOREIGN KEY (event_id) REFERENCES EVENT (event_id) ON DELETE SET NULL;

-- Relasi JURNAL_TRANSAKSI
ALTER TABLE JURNAL_TRANSAKSI
ADD FOREIGN KEY (akun_debit_id) REFERENCES AKUN_KEUANGAN (akun_id),
ADD FOREIGN KEY (akun_kredit_id) REFERENCES AKUN_KEUANGAN (akun_id),
ADD FOREIGN KEY (penjualan_id) REFERENCES PENJUALAN (penjualan_id) ON DELETE SET NULL,
ADD FOREIGN KEY (po_id) REFERENCES PURCHASE_ORDER (po_id) ON DELETE SET NULL,
ADD FOREIGN KEY (beban_id) REFERENCES BEBAN_OPERASIONAL (beban_id) ON DELETE SET NULL;

-- =====================================================
-- DATA CONTOH (Sample Data)
-- =====================================================

-- 1. Insert OWNER
INSERT INTO
    OWNER (nama_owner, no_hp)
VALUES ('Admin Utama', '081234567890'),
    ('Kasir 1', '081234567891');

-- 2. Insert PRODUK
INSERT INTO PRODUK (nama_produk, jenis_produk, harga_satuan, deskripsi) VALUES 
('Chocolate Chip Cookie', 'Regular', 50000, 'Isi 10 pcs per box'),
('Red Velvet Cookie', 'Premium', 75000, 'Isi 8 pcs per box'),
('Matcha Cookie', 'Premium', 75000, 'Isi 8 pcs per box'),
('Peanut Butter Cookie', 'Regular', 50000, 'Isi 10 pcs per box'),
('Cookies & Cream', 'Premium', 75000, 'Isi 8 pcs per box');

-- 3. Insert CUSTOMER
INSERT INTO CUSTOMER (nama_customer, tipe, no_hp, email) VALUES 
('Budi Santoso', 'B2C', '081234567890', 'budi@email.com'),
('Siti Aminah', 'B2C', '081234567891', 'siti@email.com'),
('Ahmad Fauzi', 'B2C', '081234567892', 'ahmad@email.com'),
('Toko Kue Manis', 'B2B', '081234567893', 'tokomanis@email.com'),
('Bakery Sejahtera', 'B2B', '081234567894', 'bakery@email.com');

-- 4. Insert CUSTOMER_PROFILE
INSERT INTO CUSTOMER_PROFILE (customer_id, alamat, npwp, pic_name, payment_terms) VALUES 
(1, 'Jl. Mawar No. 10, Malang', NULL, NULL, NULL),
(2, 'Jl. Melati No. 20, Malang', NULL, NULL, NULL),
(3, 'Jl. Kenanga No. 15, Malang', NULL, NULL, NULL),
(4, 'Jl. Raya Bisnis No. 100, Malang', '12.345.678.9-012.345', 'Ahmad Reseller', 'NET 30'),
(5, 'Jl. Industri No. 50, Malang', '98.765.432.1-098.765', 'Rina Bakery', 'NET 14');

-- 5. Insert EVENT_KATEGORI
INSERT INTO EVENT_KATEGORI (nama_kategori, deskripsi) VALUES 
('Malang', 'Event di wilayah Malang dan sekitarnya'),
('Surabaya', 'Event di wilayah Surabaya'),
('Jakarta', 'Event di wilayah Jakarta');

-- 6. Insert EVENT
INSERT INTO
    EVENT (
        kategori_id,
        nama_event,
        tgl_mulai,
        tgl_selesai,
        lokasi_spesifik,
        status
    )
VALUES (
        1,
        'FIB Brawijaya 2025',
        '2025-03-15',
        '2025-03-17',
        'Booth A5, Gedung FIB',
        'Planned'
    ),
    (
        1,
        'Bazaar Imlek 2026',
        '2026-01-28',
        '2026-01-30',
        'Malang Town Square',
        'Planned'
    ),
    (
        1,
        'Car Free Day',
        '2025-12-15',
        '2025-12-15',
        'Jl. Ijen Malang',
        'Planned'
    ),
    (
        1,
        'Festival Kuliner',
        '2026-02-10',
        '2026-02-12',
        'Alun-alun Malang',
        'Planned'
    );

-- 7. Insert PENJUALAN
INSERT INTO
    PENJUALAN (
        tgl_penjualan,
        customer_id,
        owner_id,
        event_id,
        tipe_penjualan,
        total_transaksi,
        keterangan
    )
VALUES (
        '2025-03-15',
        1,
        1,
        1,
        'B2C',
        125000,
        'Beli di event FIB'
    ),
    (
        '2025-03-16',
        2,
        1,
        1,
        'B2C',
        150000,
        'Beli di event FIB'
    ),
    (
        '2025-03-17',
        4,
        1,
        1,
        'B2B',
        500000,
        'Order grosir di event'
    ),
    (
        '2025-11-01',
        1,
        1,
        NULL,
        'B2C',
        50000,
        'Beli online'
    ),
    (
        '2025-11-02',
        3,
        2,
        NULL,
        'B2C',
        75000,
        'Beli langsung ke toko'
    ),
    (
        '2025-11-05',
        5,
        1,
        NULL,
        'B2B',
        1000000,
        'Order grosir besar'
    );

-- 8. Insert PENJUALAN_DETAIL
INSERT INTO
    PENJUALAN_DETAIL (
        penjualan_id,
        produk_id,
        qty,
        harga_satuan,
        subtotal
    )
VALUES (1, 1, 2, 50000, 100000),
    (1, 3, 1, 75000, 75000),
    (2, 2, 2, 75000, 150000),
    (3, 1, 10, 50000, 500000),
    (4, 1, 1, 50000, 50000),
    (5, 3, 1, 75000, 75000),
    (6, 1, 10, 50000, 500000),
    (6, 2, 5, 75000, 375000);

-- 9. Insert SUPPLIER
INSERT INTO
    SUPPLIER (
        nama_supplier,
        kontak_person,
        no_telepon,
        alamat
    )
VALUES (
        'CV Tepung Sejahtera',
        'Budi Santoso',
        '081234567895',
        'Jl. Industri No. 123, Malang'
    ),
    (
        'Toko Kemasan Makmur',
        'Siti Aminah',
        '081234567896',
        'Jl. Pasar Besar No. 45, Malang'
    );

-- 10. Insert PURCHASE_ORDER
INSERT INTO
    PURCHASE_ORDER (
        supplier_id,
        created_by,
        po_no,
        tgl_po,
        status,
        grand_total,
        keterangan
    )
VALUES (
        1,
        1,
        'PO-2025-001',
        '2025-11-01',
        'Received',
        5000000,
        'Beli bahan baku bulan November'
    ),
    (
        2,
        1,
        'PO-2025-002',
        '2025-11-01',
        'Received',
        2000000,
        'Beli kemasan'
    );

-- 11. Insert PO_ITEM
INSERT INTO
    PO_ITEM (
        po_id,
        item_category,
        nama_item,
        qty_ordered,
        harga_satuan,
        subtotal
    )
VALUES (
        1,
        'Bahan Baku',
        'Tepung Terigu 50kg',
        10,
        300000,
        3000000
    ),
    (
        1,
        'Bahan Baku',
        'Coklat Chip 10kg',
        5,
        400000,
        2000000
    ),
    (
        2,
        'Kemasan',
        'Box Cookie isi 100',
        20,
        100000,
        2000000
    );

-- 12. Insert AKUN_KEUANGAN
INSERT INTO
    AKUN_KEUANGAN (
        kode_akun,
        nama_akun,
        tipe_laporan,
        saldo_normal
    )
VALUES (
        '1-1000',
        'Kas',
        'Aset',
        'Debit'
    ),
    (
        '1-1100',
        'Bank',
        'Aset',
        'Debit'
    ),
    (
        '1-2000',
        'Piutang Usaha',
        'Aset',
        'Debit'
    ),
    (
        '2-1000',
        'Utang Usaha',
        'Liabilitas',
        'Kredit'
    ),
    (
        '3-1000',
        'Modal Pemilik',
        'Modal',
        'Kredit'
    ),
    (
        '4-1000',
        'Pendapatan Penjualan',
        'Pendapatan',
        'Kredit'
    ),
    (
        '5-1000',
        'Beban Operasional',
        'Beban',
        'Debit'
    ),
    (
        '5-2000',
        'HPP',
        'Beban',
        'Debit'
    );

-- 13. Insert BEBAN_OPERASIONAL
INSERT INTO
    BEBAN_OPERASIONAL (
        tanggal,
        jenis_beban,
        keterangan,
        nominal,
        owner_id,
        event_id
    )
VALUES (
        '2025-03-15',
        'Sewa Booth',
        'Sewa booth event FIB 3 hari',
        800000,
        1,
        1
    ),
    (
        '2025-03-15',
        'Transport',
        'Angkut barang ke event FIB',
        200000,
        1,
        1
    ),
    (
        '2025-11-01',
        'Bahan Baku',
        'Beli tepung, telur, coklat',
        2000000,
        1,
        NULL
    ),
    (
        '2025-11-01',
        'Kemasan',
('2025-11-01', 'Kemasan', 'Beli kardus & stiker', 500000, 1, NULL),
('2025-11-05', 'Transport', 'Ongkir kirim pesanan', 150000, 1, NULL),
    (
        '2025-11-10',
        'Sewa',
        'Sewa tempat produksi',
        1200000,
        1,
        NULL
    );

-- 14. Insert JURNAL_TRANSAKSI
INSERT INTO
    JURNAL_TRANSAKSI (
        tanggal,
        akun_debit_id,
        akun_kredit_id,
        nominal,
        deskripsi,
        penjualan_id,
        po_id,
        beban_id
    )
VALUES (
        '2025-03-15',
        1,
        6,
        125000,
        'Penjualan Event FIB',
        1,
        NULL,
        NULL
    ),
    (
        '2025-03-16',
        1,
        6,
        150000,
        'Penjualan Event FIB',
        2,
        NULL,
        NULL
    ),
    (
        '2025-03-17',
        1,
        6,
        500000,
        'Penjualan B2B Event',
        3,
        NULL,
        NULL
    ),
    (
        '2025-11-01',
        1,
        6,
        50000,
        'Penjualan Online',
        4,
        NULL,
        NULL
    ),
    (
        '2025-11-02',
        1,
        6,
        75000,
        'Penjualan Toko',
        5,
        NULL,
        NULL
    ),
    (
        '2025-11-05',
        1,
        6,
        1000000,
        'Penjualan B2B Grosir',
        6,
        NULL,
        NULL
    ),
    (
        '2025-11-01',
        8,
        1,
        5000000,
        'Pembelian Bahan Baku',
        NULL,
        1,
        NULL
    ),
    (
        '2025-11-01',
        8,
        1,
        2000000,
        'Pembelian Kemasan',
        NULL,
        2,
        NULL
    ),
    (
        '2025-03-15',
        7,
        1,
        800000,
        'Biaya Sewa Booth',
        NULL,
        NULL,
        1
    ),
    (
        '2025-03-15',
        7,
        1,
        200000,
        'Biaya Transport Event',
        NULL,
        NULL,
        2
    ),
    (
        '2025-11-01',
        7,
        1,
        2000000,
        'Biaya Bahan Baku',
        NULL,
        NULL,
        3
    ),
    (
        '2025-11-01',
        7,
        1,
        500000,
        'Biaya Kemasan',
        NULL,
        NULL,
        4
    ),
    (
        '2025-11-05',
        7,
        1,
        150000,
        'Biaya Transport',
        NULL,
        NULL,
        5
    ),
    (
        '2025-11-10',
        7,
        1,
        1200000,
        'Biaya Sewa Tempat',
        NULL,
        NULL,
        6
    );

-- =====================================================
-- QUERY ANALISIS (Cara Pakai Database)
-- =====================================================

-- 1. Lihat semua penjualan dengan detail customer
SELECT p.penjualan_id, p.tgl_penjualan, c.nama_customer, c.tipe, e.nama_event, p.total_transaksi
FROM
    PENJUALAN p
    JOIN CUSTOMER c ON p.customer_id = c.customer_id
    LEFT JOIN EVENT e ON p.event_id = e.event_id
ORDER BY p.tgl_penjualan DESC;

-- 2. Produk terlaris
SELECT
    pr.nama_produk,
    SUM(pd.qty) AS jumlah_terjual,
    SUM(pd.subtotal) AS total_pendapatan
FROM
    PRODUK pr
    LEFT JOIN PENJUALAN_DETAIL pd ON pr.produk_id = pd.produk_id
GROUP BY
    pr.produk_id,
    pr.nama_produk
ORDER BY jumlah_terjual DESC;

-- 3. Customer B2C vs B2B
SELECT tipe, COUNT(*) AS jumlah FROM CUSTOMER GROUP BY tipe;

-- 4. Analisis ROI per Event
SELECT
    e.nama_event,
    e.lokasi_spesifik,
    COALESCE(SUM(p.total_transaksi), 0) AS total_penjualan,
    COALESCE(SUM(b.nominal), 0) AS total_beban,
    COALESCE(SUM(p.total_transaksi), 0) - COALESCE(SUM(b.nominal), 0) AS laba
FROM
    EVENT e
    LEFT JOIN PENJUALAN p ON e.event_id = p.event_id
    LEFT JOIN BEBAN_OPERASIONAL b ON e.event_id = b.event_id
GROUP BY
    e.event_id,
    e.nama_event,
    e.lokasi_spesifik
ORDER BY laba DESC;

-- 5. Total beban per kategori
SELECT jenis_beban, SUM(nominal) AS total
FROM BEBAN_OPERASIONAL
GROUP BY
    jenis_beban
ORDER BY total DESC;

-- 6. Ringkasan Dashboard
SELECT (
        SELECT SUM(total_transaksi)
        FROM PENJUALAN
    ) AS total_penjualan,
    (
        SELECT COUNT(*)
        FROM CUSTOMER
    ) AS total_customer,
    (
        SELECT SUM(qty)
        FROM PENJUALAN_DETAIL
    ) AS total_produk_terjual,
    (
        SELECT SUM(nominal)
        FROM BEBAN_OPERASIONAL
    ) AS total_beban,
    (
        SELECT SUM(total_transaksi)
        FROM PENJUALAN
    ) - (
        SELECT SUM(nominal)
        FROM BEBAN_OPERASIONAL
    ) AS laba_bersih;

-- =====================================================
-- SELESAI! Database lengkap 14 tabel siap digunakan
-- =====================================================