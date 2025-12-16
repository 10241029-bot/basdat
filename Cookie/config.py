# config.py
import mysql.connector
from mysql.connector import Error

# ==================== KONEKSI DATABASE ====================
def create_connection():
    """Membuat koneksi ke database MySQL Cookie Club"""
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='cookie_db',
            user='root',
            password=''
        )
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Error koneksi database: {e}")
        return None


# ==================== QUERY DATA ====================

def view_customers():
    """Ambil semua data customer"""
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = "SELECT * FROM CUSTOMER"
            cursor.execute(query)
            result = cursor.fetchall()
            cursor.close()
            connection.close()
            return result
        except Error as e:
            print(f"Error: {e}")
            return []
    return []


def view_products():
    """Ambil semua data produk"""
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = "SELECT * FROM PRODUK"
            cursor.execute(query)
            result = cursor.fetchall() 
            cursor.close()
            connection.close()
            return result
        except Error as e:
            print(f"Error: {e}")
            return []
    return []


def view_sales():
    """Ambil data penjualan dengan join customer"""
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = """
                SELECT 
                    p.penjualan_id,
                    p.tgl_penjualan,
                    p.total_transaksi,
                    c.nama_customer,
                    c.tipe,
                    p.tipe_penjualan
                FROM PENJUALAN p
                JOIN CUSTOMER c ON p.customer_id = c.customer_id
                ORDER BY p.tgl_penjualan DESC
            """
            cursor.execute(query)
            result = cursor.fetchall()
            cursor.close()
            connection.close()
            return result
        except Error as e:
            print(f"Error: {e}")
            return []
    return []


def view_sales_details():
    """Ambil detail penjualan lengkap"""
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = """
                SELECT 
                    pd.detail_id,
                    p.penjualan_id,
                    p.tgl_penjualan,
                    c.customer_id,
                    c.nama_customer,
                    prod.produk_id,
                    prod.nama_produk,
                    pd.harga_satuan,
                    pd.qty,
                    pd.subtotal,
                    p.total_transaksi
                FROM PENJUALAN_DETAIL pd
                JOIN PENJUALAN p ON pd.penjualan_id = p.penjualan_id
                JOIN CUSTOMER c ON p.customer_id = c.customer_id
                JOIN PRODUK prod ON pd.produk_id = prod.produk_id
                ORDER BY p.tgl_penjualan DESC
            """
            cursor.execute(query)
            result = cursor.fetchall()
            cursor.close()
            connection.close()
            return result
        except Error as e:
            print(f"Error: {e}")
            return []
    return []


def view_daily_sales():
    """Ambil penjualan harian untuk grafik"""
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = """
                SELECT 
                    DATE(tgl_penjualan) AS tanggal,
                    COUNT(*) AS jumlah_transaksi,
                    SUM(total_transaksi) AS total_penjualan
                FROM PENJUALAN
                GROUP BY DATE(tgl_penjualan)
                ORDER BY tanggal DESC
            """
            cursor.execute(query)
            result = cursor.fetchall()
            cursor.close()
            connection.close()
            return result
        except Error as e:
            print(f"Error: {e}")
            return []
    return []


def view_top_products():
    """Ambil produk terlaris"""
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = """
                SELECT 
                    prod.nama_produk,
                    prod.jenis_produk,
                    COALESCE(SUM(pd.qty), 0) AS total_terjual,
                    COALESCE(SUM(pd.subtotal), 0) AS total_pendapatan
                FROM PRODUK prod
                LEFT JOIN PENJUALAN_DETAIL pd ON prod.produk_id = pd.produk_id
                GROUP BY prod.produk_id, prod.nama_produk, prod.jenis_produk
                ORDER BY total_terjual DESC
            """
            cursor.execute(query)
            result = cursor.fetchall()
            cursor.close()
            connection.close()
            return result
        except Error as e:
            print(f"Error: {e}")
            return []
    return []


def view_customer_types():
    """Ambil komposisi B2C vs B2B"""
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = """
                SELECT 
                    tipe,
                    COUNT(*) AS jumlah,
                    COALESCE(SUM(p.total_transaksi), 0) AS total_penjualan
                FROM CUSTOMER c
                LEFT JOIN PENJUALAN p ON c.customer_id = p.customer_id
                GROUP BY tipe
            """
            cursor.execute(query)
            result = cursor.fetchall()
            cursor.close()
            connection.close()
            return result
        except Error as e:
            print(f"Error: {e}")
            return []
    return []


def view_events():
    """Ambil data event"""
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = """
                SELECT 
                    e.event_id,
                    e.nama_event,
                    ek.nama_kategori,
                    e.tgl_mulai,
                    e.tgl_selesai,
                    e.lokasi_spesifik,
                    COALESCE(SUM(p.total_transaksi), 0) AS total_penjualan
                FROM EVENT e
                JOIN EVENT_KATEGORI ek ON e.kategori_id = ek.kategori_id
                LEFT JOIN PENJUALAN p ON e.event_id = p.event_id
                GROUP BY e.event_id, e.nama_event, ek.nama_kategori, e.tgl_mulai, e.tgl_selesai, e.lokasi_spesifik
                ORDER BY e.tgl_mulai DESC
            """
            cursor.execute(query)
            result = cursor.fetchall()
            cursor.close()
            connection.close()
            return result
        except Error as e:
            print(f"Error: {e}")
            return []
    return []


def get_dashboard_summary():
    """Ambil ringkasan untuk dashboard"""
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            
            # Total penjualan
            cursor.execute("SELECT COALESCE(SUM(total_transaksi), 0) FROM PENJUALAN")
            total_penjualan = cursor.fetchone()[0] or 0
            
            # Total customer
            cursor.execute("SELECT COUNT(*) FROM CUSTOMER")
            total_customer = cursor.fetchone()[0] or 0
            
            # Total produk terjual
            cursor.execute("SELECT COALESCE(SUM(qty), 0) FROM PENJUALAN_DETAIL")
            total_produk_terjual = cursor.fetchone()[0] or 0
            
            # Rata-rata transaksi
            cursor.execute("SELECT COALESCE(AVG(total_transaksi), 0) FROM PENJUALAN")
            rata_transaksi = cursor.fetchone()[0] or 0
            
            cursor.close()
            connection.close()
            
            return {
                'total_penjualan': float(total_penjualan),
                'total_customer': int(total_customer),
                'total_produk_terjual': int(total_produk_terjual),
                'rata_transaksi': float(rata_transaksi)
            }
        except Error as e:
            print(f"Error: {e}")
            return None
    return None


def view_customer_dengan_belanja():
    """JOIN 2 TABEL : CUSTOMER DENGAN PENJUALAN"""

    connection = create_connection()
    if connection:
        try: 
            cursor = connection.cursor()

            query = """
                SELECT 
                    c.customer_id,
                    c.nama_customer,
                    c.tipe, 
                    COALESCE(SUM(p.penjualan_id),0) AS jumlah_transaksi,
                    COALESCE(SUM(p.total_transaksi),0) AS total_belanja
                    FROM CUSTOMER C
                    LEFT JOIN PENJUALAN P ON c.customer_id = p.customer_id
                    GROUP BY c.customer_id, c.nama_customer, c.tipe
                    ORDER BY total_belanja DESC 
                  """
            cursor.execute(query)
            result = cursor.fetchall()
            cursor.close()
            connection.close()
            return result
        except Error as e:
            print(f"Error: {e}")
            return []
        