# main_cookie.py - VERSI YANG SUDAH DIPERBAIKI
import streamlit as st
import pandas as pd
from datetime import datetime
from Implementasi.config import *

# Set konfigurasi halaman dashboard
st.set_page_config("Dashboard Cookie Club", page_icon="🍪", layout="wide")

# ==================== CUSTOMERS ====================
# Ambil data pelanggan
result_customers = view_customers()

# Buat DataFrame pelanggan - SESUAI STRUKTUR DATABASE
df_customers = pd.DataFrame(result_customers, columns=[
    "customer_id", "nama_customer", "tipe", "no_hp", "email", "status"
])

# Fungsi tampilkan tabel Customers
def tabelCustomers_dan_export():
    total_customers = df_customers.shape[0]
    total_b2c = len(df_customers[df_customers['tipe'] == 'B2C'])
    total_b2b = len(df_customers[df_customers['tipe'] == 'B2B'])

    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric(label="👥 Total Pelanggan", value=total_customers)
    with col2:
        st.metric(label="🛍️ B2C", value=total_b2c)
    with col3:
        st.metric(label="🏢 B2B", value=total_b2b)

    st.sidebar.header("🔧 Filter Pelanggan")
    
    # Filter berdasarkan tipe
    tipe_filter = st.sidebar.multiselect(
        "Pilih Tipe Customer:",
        options=df_customers['tipe'].unique(),
        default=df_customers['tipe'].unique()
    )
    
    # Filter berdasarkan status
    status_filter = st.sidebar.multiselect(
        "Pilih Status:",
        options=df_customers['status'].unique(),
        default=df_customers['status'].unique()
    )

    filtered_df = df_customers[
        (df_customers['tipe'].isin(tipe_filter)) & 
        (df_customers['status'].isin(status_filter))
    ]

    st.markdown("### 📋 Tabel Data Pelanggan")
    
    showdata = st.multiselect(
        "Pilih Kolom yang Ditampilkan:",
        options=filtered_df.columns.tolist(),
        default=["customer_id", "nama_customer", "tipe", "no_hp", "email", "status"]
    )
    
    if showdata:
        st.dataframe(filtered_df[showdata], use_container_width=True)
        
        # Download CSV
        csv = filtered_df[showdata].to_csv(index=False).encode('utf-8')
        st.download_button(
            label="📥 Download Data Pelanggan sebagai CSV",
            data=csv,
            file_name='data_pelanggan_cookie.csv',
            mime='text/csv'
        )

# ==================== PRODUCTS ====================
# Ambil data produk
result_products = view_products()

# Buat DataFrame produk - SESUAI STRUKTUR DATABASE
df_products = pd.DataFrame(result_products, columns=[
    "produk_id", "nama_produk", "jenis_produk", "harga_satuan", "deskripsi", "status"
])

df_products['harga_satuan'] = df_products['harga_satuan'].astype(float)

def tabelProducts_dan_export():
    total_products = len(df_products)
    total_regular = len(df_products[df_products['jenis_produk'] == 'Regular'])
    total_premium = len(df_products[df_products['jenis_produk'] == 'Premium'])
    avg_price = df_products['harga_satuan'].mean()

    col1, col2, col3, col4 = st.columns(4)
    with col1:
        st.metric(label="🍪 Total Produk", value=total_products)
    with col2:
        st.metric(label="⭐ Regular", value=total_regular)
    with col3:
        st.metric(label="💎 Premium", value=total_premium)
    with col4:
        st.metric(label="💰 Harga Rata-rata", value=f"Rp {avg_price:,.0f}")

    st.sidebar.header("🔧 Filter Produk")
    
    # Filter jenis produk
    jenis_filter = st.sidebar.multiselect(
        "Pilih Jenis Produk:",
        options=df_products['jenis_produk'].unique(),
        default=df_products['jenis_produk'].unique()
    )
    
    filtered_df = df_products[df_products['jenis_produk'].isin(jenis_filter)]

    st.markdown("### 📋 Tabel Data Produk")
    
    showdata = st.multiselect(
        "Pilih Kolom yang Ditampilkan:",
        options=filtered_df.columns.tolist(),
        default=["produk_id", "nama_produk", "jenis_produk", "harga_satuan", "status"]
    )
    
    if showdata:
        st.dataframe(filtered_df[showdata], use_container_width=True)
        
        # Download CSV
        csv = filtered_df[showdata].to_csv(index=False).encode('utf-8')
        st.download_button(
            label="📥 Download Data Produk sebagai CSV",
            data=csv,
            file_name='data_produk_cookie.csv',
            mime='text/csv'
        )

# ==================== SALES ====================
# Ambil data penjualan
result_sales = view_sales()

# Buat DataFrame penjualan - SESUAI STRUKTUR DATABASE
df_sales = pd.DataFrame(result_sales, columns=[
    "penjualan_id", "tgl_penjualan", "total_transaksi", 
    "nama_customer", "tipe", "tipe_penjualan"
])

df_sales['tgl_penjualan'] = pd.to_datetime(df_sales['tgl_penjualan'])
df_sales['total_transaksi'] = df_sales['total_transaksi'].astype(float)

def tabelSales_dan_export():
    total_sales = len(df_sales)
    total_revenue = df_sales['total_transaksi'].sum()
    avg_sale = df_sales['total_transaksi'].mean()
    total_b2c_sales = df_sales[df_sales['tipe_penjualan'] == 'B2C']['total_transaksi'].sum()
    total_b2b_sales = df_sales[df_sales['tipe_penjualan'] == 'B2B']['total_transaksi'].sum()

    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric(label="🛍️ Total Transaksi", value=total_sales)
    with col2:
        st.metric(label="💵 Total Pendapatan", value=f"Rp {total_revenue:,.0f}")
    with col3:
        st.metric(label="📊 Rata-rata Transaksi", value=f"Rp {avg_sale:,.0f}")

    col4, col5 = st.columns(2)
    with col4:
        st.metric(label="🛒 Penjualan B2C", value=f"Rp {total_b2c_sales:,.0f}")
    with col5:
        st.metric(label="🏢 Penjualan B2B", value=f"Rp {total_b2b_sales:,.0f}")

    st.sidebar.header("🔧 Filter Penjualan")
    
    # Filter tipe penjualan
    tipe_filter = st.sidebar.multiselect(
        "Pilih Tipe Penjualan:",
        options=df_sales['tipe_penjualan'].unique(),
        default=df_sales['tipe_penjualan'].unique()
    )
    
    # Filter tanggal
    min_date = df_sales['tgl_penjualan'].min().date()
    max_date = df_sales['tgl_penjualan'].max().date()
    
    date_range = st.sidebar.date_input(
        "Pilih Range Tanggal:",
        value=(min_date, max_date),
        min_value=min_date,
        max_value=max_date
    )
    
    if len(date_range) == 2:
        filtered_df = df_sales[
            (df_sales['tipe_penjualan'].isin(tipe_filter)) &
            (df_sales['tgl_penjualan'].dt.date >= date_range[0]) &
            (df_sales['tgl_penjualan'].dt.date <= date_range[1])
        ]
    else:
        filtered_df = df_sales[df_sales['tipe_penjualan'].isin(tipe_filter)]

    st.markdown("### 📋 Tabel Data Penjualan")
    
    df_display = filtered_df.copy()
    df_display['tgl_penjualan'] = df_display['tgl_penjualan'].dt.strftime('%Y-%m-%d')
    
    showdata = st.multiselect(
        "Pilih Kolom yang Ditampilkan:",
        options=df_display.columns.tolist(),
        default=["penjualan_id", "tgl_penjualan", "nama_customer", "tipe_penjualan", "total_transaksi"]
    )
    
    if showdata:
        st.dataframe(df_display[showdata], use_container_width=True)
        
        # Download CSV
        csv = df_display[showdata].to_csv(index=False).encode('utf-8')
        st.download_button(
            label="📥 Download Data Penjualan sebagai CSV",
            data=csv,
            file_name='data_penjualan_cookie.csv',
            mime='text/csv'
        )

# ==================== SALES DETAILS ====================
# Ambil data detail penjualan
result_sales_details = view_sales_details()

# Buat DataFrame detail penjualan - SESUAI STRUKTUR DATABASE
df_sales_details = pd.DataFrame(result_sales_details, columns=[
    "detail_id", "penjualan_id", "tgl_penjualan", "customer_id", "nama_customer",
    "produk_id", "nama_produk", "harga_satuan", "qty", "subtotal", "total_transaksi"
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
    
    # Produk terlaris
    top_products = df_sales_details.groupby('nama_produk')['qty'].sum().sort_values(ascending=False).head(3)

    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric(label="📝 Total Item", value=total_items)
    with col2:
        st.metric(label="📦 Total Kuantitas", value=total_quantity)
    with col3:
        st.metric(label="💰 Total Revenue", value=f"Rp {total_revenue:,.0f}")

    # Tampilkan produk terlaris
    st.markdown("### 🏆 Top 3 Produk Terlaris")
    col1, col2, col3 = st.columns(3)
    for idx, (produk, qty) in enumerate(top_products.items()):
        if idx == 0:
            with col1:
                st.info(f"🥇 {produk}: {qty} terjual")
        elif idx == 1:
            with col2:
                st.info(f"🥈 {produk}: {qty} terjual")
        elif idx == 2:
            with col3:
                st.info(f"🥉 {produk}: {qty} terjual")

    st.markdown("### 📋 Tabel Detail Penjualan")
    
    df_display = df_sales_details.copy()
    df_display['tgl_penjualan'] = df_display['tgl_penjualan'].dt.strftime('%Y-%m-%d')
    
    showdata = st.multiselect(
        "Pilih Kolom yang Ditampilkan:",
        options=df_display.columns.tolist(),
        default=["detail_id", "penjualan_id", "nama_customer", "nama_produk", "qty", "harga_satuan", "subtotal"]
    )
    
    if showdata:
        st.dataframe(df_display[showdata], use_container_width=True)
        
        # Download CSV
        csv = df_display[showdata].to_csv(index=False).encode('utf-8')
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
st.markdown("---")

# Tampilkan halaman berdasarkan pilihan
if page == "👥 Pelanggan":
    tabelCustomers_dan_export()

elif page == "🍪 Produk":
    tabelProducts_dan_export()

elif page == "🛍️ Penjualan":
    tabelSales_dan_export()

elif page == "📋 Detail Penjualan":
    tabelSalesDetails_dan_export()

# Footer
st.markdown("---")
st.markdown("""
    <div style='text-align: center; color: #888;'>
        <p>🍪 Cookie Club Dashboard | KELOMPOK 8 BASDAT A</p>
    </div>
""", unsafe_allow_html=True)