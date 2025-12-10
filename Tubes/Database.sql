-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 10 Des 2025 pada 14.45
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cookie_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `akun_keuangan`
--

CREATE TABLE `akun_keuangan` (
  `akun_id` int(11) NOT NULL,
  `kode_akun` varchar(20) NOT NULL,
  `nama_akun` varchar(100) NOT NULL,
  `tipe_laporan` varchar(30) NOT NULL,
  `saldo_normal` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `akun_keuangan`
--

INSERT INTO `akun_keuangan` (`akun_id`, `kode_akun`, `nama_akun`, `tipe_laporan`, `saldo_normal`) VALUES
(1, '1-1000', 'Kas', 'Aset', 'Debit'),
(2, '1-1100', 'Bank', 'Aset', 'Debit'),
(3, '1-2000', 'Piutang Usaha', 'Aset', 'Debit'),
(4, '2-1000', 'Utang Usaha', 'Liabilitas', 'Kredit'),
(5, '3-1000', 'Modal Pemilik', 'Modal', 'Kredit'),
(6, '4-1000', 'Pendapatan Penjualan', 'Pendapatan', 'Kredit'),
(7, '5-1000', 'Beban Operasional', 'Beban', 'Debit'),
(8, '5-2000', 'HPP', 'Beban', 'Debit');

-- --------------------------------------------------------

--
-- Struktur dari tabel `beban_operasional`
--

CREATE TABLE `beban_operasional` (
  `beban_id` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `jenis_beban` varchar(50) NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `nominal` decimal(12,2) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `beban_operasional`
--

INSERT INTO `beban_operasional` (`beban_id`, `tanggal`, `jenis_beban`, `keterangan`, `nominal`, `owner_id`, `event_id`) VALUES
(1, '2025-03-15', 'Sewa Booth', 'Sewa booth event FIB 3 hari', 800000.00, 1, 1),
(2, '2025-03-15', 'Transport', 'Angkut barang ke event FIB', 200000.00, 1, 1),
(3, '2025-11-01', 'Bahan Baku', 'Beli tepung, telur, coklat', 2000000.00, 1, NULL),
(4, '2025-11-01', 'Kemasan', 'Beli kardus & stiker', 500000.00, 1, NULL),
(5, '2025-11-05', 'Transport', 'Ongkir kirim pesanan', 150000.00, 1, NULL),
(6, '2025-11-10', 'Sewa', 'Sewa tempat produksi', 1200000.00, 1, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `nama_customer` varchar(100) NOT NULL,
  `tipe` enum('B2C','B2B') NOT NULL,
  `no_hp` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `customer`
--

INSERT INTO `customer` (`customer_id`, `nama_customer`, `tipe`, `no_hp`, `email`, `status`) VALUES
(1, 'Budi Santoso', 'B2C', '081234567890', 'budi@email.com', 'Aktif'),
(2, 'Siti Aminah', 'B2C', '081234567891', 'siti@email.com', 'Aktif'),
(3, 'Ahmad Fauzi', 'B2C', '081234567892', 'ahmad@email.com', 'Aktif'),
(4, 'Toko Kue Manis', 'B2B', '081234567893', 'tokomanis@email.com', 'Aktif'),
(5, 'Bakery Sejahtera', 'B2B', '081234567894', 'bakery@email.com', 'Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `customer_profile`
--

CREATE TABLE `customer_profile` (
  `profile_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `npwp` varchar(20) DEFAULT NULL,
  `pic_name` varchar(100) DEFAULT NULL,
  `payment_terms` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `customer_profile`
--

INSERT INTO `customer_profile` (`profile_id`, `customer_id`, `alamat`, `npwp`, `pic_name`, `payment_terms`) VALUES
(1, 1, 'Jl. Mawar No. 10, Malang', NULL, NULL, NULL),
(2, 2, 'Jl. Melati No. 20, Malang', NULL, NULL, NULL),
(3, 3, 'Jl. Kenanga No. 15, Malang', NULL, NULL, NULL),
(4, 4, 'Jl. Raya Bisnis No. 100, Malang', '12.345.678.9-012.345', 'Ahmad Reseller', 'NET 30'),
(5, 5, 'Jl. Industri No. 50, Malang', '98.765.432.1-098.765', 'Rina Bakery', 'NET 14');

-- --------------------------------------------------------

--
-- Struktur dari tabel `event`
--

CREATE TABLE `event` (
  `event_id` int(11) NOT NULL,
  `kategori_id` int(11) NOT NULL,
  `nama_event` varchar(100) NOT NULL,
  `tgl_mulai` date NOT NULL,
  `tgl_selesai` date DEFAULT NULL,
  `lokasi_spesifik` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Planned'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `event`
--

INSERT INTO `event` (`event_id`, `kategori_id`, `nama_event`, `tgl_mulai`, `tgl_selesai`, `lokasi_spesifik`, `status`) VALUES
(1, 1, 'FIB Brawijaya 2025', '2025-03-15', '2025-03-17', 'Booth A5, Gedung FIB', 'Planned'),
(2, 1, 'Bazaar Imlek 2026', '2026-01-28', '2026-01-30', 'Malang Town Square', 'Planned'),
(3, 1, 'Car Free Day', '2025-12-15', '2025-12-15', 'Jl. Ijen Malang', 'Planned'),
(4, 1, 'Festival Kuliner', '2026-02-10', '2026-02-12', 'Alun-alun Malang', 'Planned');

-- --------------------------------------------------------

--
-- Struktur dari tabel `event_kategori`
--

CREATE TABLE `event_kategori` (
  `kategori_id` int(11) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `event_kategori`
--

INSERT INTO `event_kategori` (`kategori_id`, `nama_kategori`, `deskripsi`) VALUES
(1, 'Malang', 'Event di wilayah Malang dan sekitarnya'),
(2, 'Surabaya', 'Event di wilayah Surabaya'),
(3, 'Jakarta', 'Event di wilayah Jakarta');

-- --------------------------------------------------------

--
-- Struktur dari tabel `jurnal_transaksi`
--

CREATE TABLE `jurnal_transaksi` (
  `jurnal_id` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `akun_debit_id` int(11) NOT NULL,
  `akun_kredit_id` int(11) NOT NULL,
  `nominal` decimal(12,2) NOT NULL,
  `deskripsi` varchar(255) DEFAULT NULL,
  `penjualan_id` int(11) DEFAULT NULL,
  `po_id` int(11) DEFAULT NULL,
  `beban_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `jurnal_transaksi`
--

INSERT INTO `jurnal_transaksi` (`jurnal_id`, `tanggal`, `akun_debit_id`, `akun_kredit_id`, `nominal`, `deskripsi`, `penjualan_id`, `po_id`, `beban_id`) VALUES
(1, '2025-03-15', 1, 6, 125000.00, 'Penjualan Event FIB', 1, NULL, NULL),
(2, '2025-03-16', 1, 6, 150000.00, 'Penjualan Event FIB', 2, NULL, NULL),
(3, '2025-03-17', 1, 6, 500000.00, 'Penjualan B2B Event', 3, NULL, NULL),
(4, '2025-11-01', 1, 6, 50000.00, 'Penjualan Online', 4, NULL, NULL),
(5, '2025-11-02', 1, 6, 75000.00, 'Penjualan Toko', 5, NULL, NULL),
(6, '2025-11-05', 1, 6, 1000000.00, 'Penjualan B2B Grosir', 6, NULL, NULL),
(7, '2025-11-01', 8, 1, 5000000.00, 'Pembelian Bahan Baku', NULL, 1, NULL),
(8, '2025-11-01', 8, 1, 2000000.00, 'Pembelian Kemasan', NULL, 2, NULL),
(9, '2025-03-15', 7, 1, 800000.00, 'Biaya Sewa Booth', NULL, NULL, 1),
(10, '2025-03-15', 7, 1, 200000.00, 'Biaya Transport Event', NULL, NULL, 2),
(11, '2025-11-01', 7, 1, 2000000.00, 'Biaya Bahan Baku', NULL, NULL, 3),
(12, '2025-11-01', 7, 1, 500000.00, 'Biaya Kemasan', NULL, NULL, 4),
(13, '2025-11-05', 7, 1, 150000.00, 'Biaya Transport', NULL, NULL, 5),
(14, '2025-11-10', 7, 1, 1200000.00, 'Biaya Sewa Tempat', NULL, NULL, 6);

-- --------------------------------------------------------

--
-- Struktur dari tabel `owner`
--

CREATE TABLE `owner` (
  `owner_id` int(11) NOT NULL,
  `nama_owner` varchar(100) NOT NULL,
  `no_hp` varchar(15) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `owner`
--

INSERT INTO `owner` (`owner_id`, `nama_owner`, `no_hp`, `status`) VALUES
(1, 'Admin Utama', '081234567890', 'Aktif'),
(2, 'Kasir 1', '081234567891', 'Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `penjualan`
--

CREATE TABLE `penjualan` (
  `penjualan_id` int(11) NOT NULL,
  `tgl_penjualan` date NOT NULL,
  `customer_id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `event_id` int(11) DEFAULT NULL,
  `tipe_penjualan` varchar(20) NOT NULL,
  `total_transaksi` decimal(12,2) NOT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `penjualan`
--

INSERT INTO `penjualan` (`penjualan_id`, `tgl_penjualan`, `customer_id`, `owner_id`, `event_id`, `tipe_penjualan`, `total_transaksi`, `keterangan`) VALUES
(1, '2025-03-15', 1, 1, 1, 'B2C', 125000.00, 'Beli di event FIB'),
(2, '2025-03-16', 2, 1, 1, 'B2C', 150000.00, 'Beli di event FIB'),
(3, '2025-03-17', 4, 1, 1, 'B2B', 500000.00, 'Order grosir di event'),
(4, '2025-11-01', 1, 1, NULL, 'B2C', 50000.00, 'Beli online'),
(5, '2025-11-02', 3, 2, NULL, 'B2C', 75000.00, 'Beli langsung ke toko'),
(6, '2025-11-05', 5, 1, NULL, 'B2B', 1000000.00, 'Order grosir besar');

-- --------------------------------------------------------

--
-- Struktur dari tabel `penjualan_detail`
--

CREATE TABLE `penjualan_detail` (
  `detail_id` int(11) NOT NULL,
  `penjualan_id` int(11) NOT NULL,
  `produk_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `harga_satuan` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `penjualan_detail`
--

INSERT INTO `penjualan_detail` (`detail_id`, `penjualan_id`, `produk_id`, `qty`, `harga_satuan`, `subtotal`) VALUES
(1, 1, 1, 2, 50000.00, 100000.00),
(2, 1, 3, 1, 75000.00, 75000.00),
(3, 2, 2, 2, 75000.00, 150000.00),
(4, 3, 1, 10, 50000.00, 500000.00),
(5, 4, 1, 1, 50000.00, 50000.00),
(6, 5, 3, 1, 75000.00, 75000.00),
(7, 6, 1, 10, 50000.00, 500000.00),
(8, 6, 2, 5, 75000.00, 375000.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `po_item`
--

CREATE TABLE `po_item` (
  `po_item_id` int(11) NOT NULL,
  `po_id` int(11) NOT NULL,
  `item_category` varchar(50) NOT NULL,
  `nama_item` varchar(100) NOT NULL,
  `qty_ordered` decimal(10,2) NOT NULL,
  `harga_satuan` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `po_item`
--

INSERT INTO `po_item` (`po_item_id`, `po_id`, `item_category`, `nama_item`, `qty_ordered`, `harga_satuan`, `subtotal`) VALUES
(1, 1, 'Bahan Baku', 'Tepung Terigu 50kg', 10.00, 300000.00, 3000000.00),
(2, 1, 'Bahan Baku', 'Coklat Chip 10kg', 5.00, 400000.00, 2000000.00),
(3, 2, 'Kemasan', 'Box Cookie isi 100', 20.00, 100000.00, 2000000.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk`
--

CREATE TABLE `produk` (
  `produk_id` int(11) NOT NULL,
  `nama_produk` varchar(100) NOT NULL,
  `jenis_produk` varchar(50) NOT NULL,
  `harga_satuan` decimal(12,2) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Tersedia'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `produk`
--

INSERT INTO `produk` (`produk_id`, `nama_produk`, `jenis_produk`, `harga_satuan`, `deskripsi`, `status`) VALUES
(1, 'Chocolate Chip Cookie', 'Regular', 50000.00, 'Isi 10 pcs per box', 'Tersedia'),
(2, 'Red Velvet Cookie', 'Premium', 75000.00, 'Isi 8 pcs per box', 'Tersedia'),
(3, 'Matcha Cookie', 'Premium', 75000.00, 'Isi 8 pcs per box', 'Tersedia'),
(4, 'Peanut Butter Cookie', 'Regular', 50000.00, 'Isi 10 pcs per box', 'Tersedia'),
(5, 'Cookies & Cream', 'Premium', 75000.00, 'Isi 8 pcs per box', 'Tersedia');

-- --------------------------------------------------------

--
-- Struktur dari tabel `purchase_order`
--

CREATE TABLE `purchase_order` (
  `po_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `po_no` varchar(50) NOT NULL,
  `tgl_po` date NOT NULL,
  `status` varchar(20) DEFAULT 'Draft',
  `grand_total` decimal(15,2) NOT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `purchase_order`
--

INSERT INTO `purchase_order` (`po_id`, `supplier_id`, `created_by`, `po_no`, `tgl_po`, `status`, `grand_total`, `keterangan`) VALUES
(1, 1, 1, 'PO-2025-001', '2025-11-01', 'Received', 5000000.00, 'Beli bahan baku bulan November'),
(2, 2, 1, 'PO-2025-002', '2025-11-01', 'Received', 2000000.00, 'Beli kemasan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `supplier`
--

CREATE TABLE `supplier` (
  `supplier_id` int(11) NOT NULL,
  `nama_supplier` varchar(100) NOT NULL,
  `kontak_person` varchar(100) DEFAULT NULL,
  `no_telepon` varchar(15) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `supplier`
--

INSERT INTO `supplier` (`supplier_id`, `nama_supplier`, `kontak_person`, `no_telepon`, `alamat`, `status`) VALUES
(1, 'CV Tepung Sejahtera', 'Budi Santoso', '081234567895', 'Jl. Industri No. 123, Malang', 'Aktif'),
(2, 'Toko Kemasan Makmur', 'Siti Aminah', '081234567896', 'Jl. Pasar Besar No. 45, Malang', 'Aktif');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `akun_keuangan`
--
ALTER TABLE `akun_keuangan`
  ADD PRIMARY KEY (`akun_id`),
  ADD UNIQUE KEY `kode_akun` (`kode_akun`);

--
-- Indeks untuk tabel `beban_operasional`
--
ALTER TABLE `beban_operasional`
  ADD PRIMARY KEY (`beban_id`),
  ADD KEY `owner_id` (`owner_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indeks untuk tabel `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indeks untuk tabel `customer_profile`
--
ALTER TABLE `customer_profile`
  ADD PRIMARY KEY (`profile_id`);

--
-- Indeks untuk tabel `event`
--
ALTER TABLE `event`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `kategori_id` (`kategori_id`);

--
-- Indeks untuk tabel `event_kategori`
--
ALTER TABLE `event_kategori`
  ADD PRIMARY KEY (`kategori_id`);

--
-- Indeks untuk tabel `jurnal_transaksi`
--
ALTER TABLE `jurnal_transaksi`
  ADD PRIMARY KEY (`jurnal_id`),
  ADD KEY `akun_debit_id` (`akun_debit_id`),
  ADD KEY `akun_kredit_id` (`akun_kredit_id`),
  ADD KEY `penjualan_id` (`penjualan_id`),
  ADD KEY `po_id` (`po_id`),
  ADD KEY `beban_id` (`beban_id`);

--
-- Indeks untuk tabel `owner`
--
ALTER TABLE `owner`
  ADD PRIMARY KEY (`owner_id`);

--
-- Indeks untuk tabel `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`penjualan_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `owner_id` (`owner_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indeks untuk tabel `penjualan_detail`
--
ALTER TABLE `penjualan_detail`
  ADD PRIMARY KEY (`detail_id`),
  ADD KEY `penjualan_id` (`penjualan_id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indeks untuk tabel `po_item`
--
ALTER TABLE `po_item`
  ADD PRIMARY KEY (`po_item_id`),
  ADD KEY `po_id` (`po_id`);

--
-- Indeks untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`produk_id`);

--
-- Indeks untuk tabel `purchase_order`
--
ALTER TABLE `purchase_order`
  ADD PRIMARY KEY (`po_id`),
  ADD UNIQUE KEY `po_no` (`po_no`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indeks untuk tabel `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`supplier_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `akun_keuangan`
--
ALTER TABLE `akun_keuangan`
  MODIFY `akun_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `beban_operasional`
--
ALTER TABLE `beban_operasional`
  MODIFY `beban_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `customer_profile`
--
ALTER TABLE `customer_profile`
  MODIFY `profile_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `event`
--
ALTER TABLE `event`
  MODIFY `event_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `event_kategori`
--
ALTER TABLE `event_kategori`
  MODIFY `kategori_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `jurnal_transaksi`
--
ALTER TABLE `jurnal_transaksi`
  MODIFY `jurnal_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT untuk tabel `owner`
--
ALTER TABLE `owner`
  MODIFY `owner_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `penjualan`
--
ALTER TABLE `penjualan`
  MODIFY `penjualan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `penjualan_detail`
--
ALTER TABLE `penjualan_detail`
  MODIFY `detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `po_item`
--
ALTER TABLE `po_item`
  MODIFY `po_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `produk`
--
ALTER TABLE `produk`
  MODIFY `produk_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `purchase_order`
--
ALTER TABLE `purchase_order`
  MODIFY `po_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `supplier`
--
ALTER TABLE `supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `beban_operasional`
--
ALTER TABLE `beban_operasional`
  ADD CONSTRAINT `beban_operasional_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`owner_id`),
  ADD CONSTRAINT `beban_operasional_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `event` (`event_id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `event`
--
ALTER TABLE `event`
  ADD CONSTRAINT `event_ibfk_1` FOREIGN KEY (`kategori_id`) REFERENCES `event_kategori` (`kategori_id`);

--
-- Ketidakleluasaan untuk tabel `jurnal_transaksi`
--
ALTER TABLE `jurnal_transaksi`
  ADD CONSTRAINT `jurnal_transaksi_ibfk_1` FOREIGN KEY (`akun_debit_id`) REFERENCES `akun_keuangan` (`akun_id`),
  ADD CONSTRAINT `jurnal_transaksi_ibfk_2` FOREIGN KEY (`akun_kredit_id`) REFERENCES `akun_keuangan` (`akun_id`),
  ADD CONSTRAINT `jurnal_transaksi_ibfk_3` FOREIGN KEY (`penjualan_id`) REFERENCES `penjualan` (`penjualan_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `jurnal_transaksi_ibfk_4` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `jurnal_transaksi_ibfk_5` FOREIGN KEY (`beban_id`) REFERENCES `beban_operasional` (`beban_id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `penjualan`
--
ALTER TABLE `penjualan`
  ADD CONSTRAINT `penjualan_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  ADD CONSTRAINT `penjualan_ibfk_2` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`owner_id`),
  ADD CONSTRAINT `penjualan_ibfk_3` FOREIGN KEY (`event_id`) REFERENCES `event` (`event_id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `penjualan_detail`
--
ALTER TABLE `penjualan_detail`
  ADD CONSTRAINT `penjualan_detail_ibfk_1` FOREIGN KEY (`penjualan_id`) REFERENCES `penjualan` (`penjualan_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `penjualan_detail_ibfk_2` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`);

--
-- Ketidakleluasaan untuk tabel `po_item`
--
ALTER TABLE `po_item`
  ADD CONSTRAINT `po_item_ibfk_1` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `purchase_order`
--
ALTER TABLE `purchase_order`
  ADD CONSTRAINT `purchase_order_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`),
  ADD CONSTRAINT `purchase_order_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `owner` (`owner_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
