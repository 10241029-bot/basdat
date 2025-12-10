# main_cookie.py
import streamlit as st
import pandas as pd
from datetime import datetime

# Import fungsi dari config_cookie.py
from Implementasi.config import *

# Set konfigurasi halaman dashboard
st.set_page_config("Dashboard Cookie Club", page_icon="🍪", layout="wide")

# ==================== CUSTOMERS ====================
# Ambil data pelanggan
result_customers = view_customers()

# Buat DataFrame pelanggan
df_customers = pd.DataFrame(result_customers, columns=[
    "customer_id", "nama_customer", "tipe", "alamat", "no_telp", "email", "tgl_bergabung"
])

# Hitung lama bergabung dari tgl_bergabung
df_customers['tgl_bergabung'] = pd.to_datetime(df_customers['tgl_bergabung'], errors='coerce')
df_customers['Lama_Bergabung_Hari'] = ((datetime.now() - df_customers['tgl_bergabung']).dt.days).fillna(0).astype(int)

# Fungsi tampilkan tabel Customers
def tabelCustomers_dan_export():
    total_customers = df_customers.shape[0]

    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric(label="👥 Total Pelanggan", value=total_customers, delta="Semua Data")

    st.sidebar.header("🔧 Filter Pelanggan")
    min_days = int(df_customers['Lama_Bergabung_Hari'].min())
    max_days = int(df_customers['Lama_Bergabung_Hari'].max())
    days_range = st.sidebar.slider(
        "Pilih Lama Bergabung (Hari)",
        min_value=min_days,
        max_value=max_days,
        value=(min_days, max_days)
    )

    filtered_df = df_customers[df_customers['Lama_Bergabung_Hari'].between(*days_range)]

    st.markdown("### 📋 Tabel Data Pelanggan")
    
    showdata = st.multiselect(
        "Pilih Kolom yang Ditampilkan:",
        options=filtered_df.columns.tolist(),
        default=["customer_id", "nama_customer", "tipe", "no_telp", "email", "Lama_Bergabung_Hari"]
    )
    
    st.dataframe(filtered_df[showdata], use_container_width=True)

    @st.cache_data
    def convert_df_to_csv(_df):
        return _df.to_csv(index=False).encode('utf-8')
    
    csv = convert_df_to_csv(filtered_df[showdata])
    st.download_button(
        label="📥 Download Data Pelanggan sebagai CSV",
        data=csv,
        file_name='data_pelanggan_cookie.csv',
        mime='text/csv'
    )

# ==================== PRODUCTS ====================
# Ambil data produk
result_products = view_products()

df_products = pd.DataFrame(result_products, columns=[
    "produk_id", "nama_produk", "kategori", "harga_satuan", "stok", "tgl_produksi", "tgl_kadaluarsa"
])

df_products['harga_satuan'] = df_products['harga_satuan'].astype(float)
df_products['stok'] = df_products['stok'].astype(int)

def tabelProducts_dan_export():
    total_products = len(df_products)
    total_stock = int(df_products['stok'].sum())
    avg_price = df_products['harga_satuan'].mean()

    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric(label="🍪 Total Produk", value=total_products)
    with col2:
        st.metric(label="📦 Total Stok", value=total_stock)
    with col3:
        st.metric(label="💰 Harga Rata-rata", value=f"Rp {avg_price:,.0f}")

    st.markdown("### 📋 Tabel Data Produk")
    
    st.dataframe(df_products, use_container_width=True)

    @st.cache_data
    def convert_df_to_csv(_df):
        return _df.to_csv(index=False).encode('utf-8')
    
    csv = convert_df_to_csv(df_products)
    st.download_button(
        label="📥 Download Data Produk sebagai CSV",
        data=csv,
        file_name='data_produk_cookie.csv',
        mime='text/csv'
    )

# ==================== SALES ====================
# Ambil data penjualan
result_sales = view_sales()

df_sales = pd.DataFrame(result_sales, columns=[
    "penjualan_id", "tgl_penjualan", "total_transaksi", "nama_customer", "tipe"
])

df_sales['tgl_penjualan'] = pd.to_datetime(df_sales['tgl_penjualan'])
df_sales['total_transaksi'] = df_sales['total_transaksi'].astype(float)

def tabelSales_dan_export():
    total_sales = len(df_sales)
    total_revenue = df_sales['total_transaksi'].sum()
    avg_sale = df_sales['total_transaksi'].mean()

    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric(label="🛍️ Total Transaksi", value=total_sales)
    with col2:
        st.metric(label="💵 Total Pendapatan", value=f"Rp {total_revenue:,.0f}")
    with col3:
        st.metric(label="📊 Rata-rata Transaksi", value=f"Rp {avg_sale:,.0f}")

    st.markdown("### 📋 Tabel Data Penjualan")
    
    df_display = df_sales.copy()
    df_display['tgl_penjualan'] = df_display['tgl_penjualan'].dt.strftime('%Y-%m-%d %H:%M:%S')
    
    st.dataframe(df_display, use_container_width=True)

    @st.cache_data
    def convert_df_to_csv(_df):
        return _df.to_csv(index=False).encode('utf-8')
    
    csv = convert_df_to_csv(df_display)
    st.download_button(
        label="📥 Download Data Penjualan sebagai CSV",
        data=csv,
        file_name='data_penjualan_cookie.csv',
        mime='text/csv'
    )

# ==================== SALES DETAILS ====================
# Ambil data detail penjualan
result_sales_details = view_sales_details()

df_sales_details = pd.DataFrame(result_sales_details, columns=[
    "detail_id", "penjualan_id", "tgl_penjualan", "customer_id", "nama_customer",
    "produk_id", "nama_produk", "harga_satuan", "qty", "subtotal", "total_transaksi", "no_telp"
])

df_sales_details['tgl_penjualan'] = pd.to_datetime(df_sales_details['tgl_penjualan'])
df_sales_details['harga_satuan'] = df_sales_details['harga_satuan'].astype(float)
df_sales_details['qty'] = df_sales_details['qty'].astype(int)
df_sales_details['subtotal'] = df_sales_details['subtotal'].astype(float)
df_sales_details['total_transaksi'] = df_sales_details['total_transaksi'].astype(float)

def tabelSalesDetails_dan_export():
    total_items = len(df_sales_details)
    total_quantity = int(df_sales_details['qty'].sum())
    total_revenue = df_sales_details['subtotal'].sum()

    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric(label="📝 Total Item", value=total_items)
    with col2:
        st.metric(label="📦 Total Kuantitas", value=total_quantity)
    with col3:
        st.metric(label="💰 Total Revenue", value=f"Rp {total_revenue:,.0f}")

    st.markdown("### 📋 Tabel Detail Penjualan")
    
    df_display = df_sales_details.copy()
    df_display['tgl_penjualan'] = df_display['tgl_penjualan'].dt.strftime('%Y-%m-%d %H:%M:%S')
    
    st.dataframe(df_display, use_container_width=True)

    @st.cache_data
    def convert_df_to_csv(_df):
        return _df.to_csv(index=False).encode('utf-8')
    
    csv = convert_df_to_csv(df_display)
    st.download_button(
        label="📥 Download Detail Penjualan sebagai CSV",
        data=csv,
        file_name='data_detail_penjualan_cookie.csv',
        mime='text/csv'
    )

# ==================== SIDEBAR NAVIGATION ====================
st.sidebar.title("🍪 Navigasi Data Cookie Club")

# Pilihan tabel dengan radio button
page = st.sidebar.radio(
    "Pilih Tabel:",
    ["👥 Pelanggan", "🍪 Produk", "🛍️ Penjualan", "📋 Detail Penjualan"],
    index=0
)


# ==================== MAIN CONTENT ====================
st.title("🍪 Cookie Club Dashboard")

# Tampilkan halaman berdasarkan pilihan
if page == "👥 Pelanggan":
    tabelCustomers_dan_export()

elif page == "🍪 Produk":
    tabelProducts_dan_export()

elif page == "🛍️ Penjualan":
    tabelSales_dan_export()

elif page == "📋 Detail Penjualan":
    tabelSalesDetails_dan_export()
