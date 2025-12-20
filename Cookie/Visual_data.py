# visualisasi_cookie.py
"""
COOKIE CLUB - DATA TABEL SEDERHANA
Lihat data dari database dalam format tabel
"""

import streamlit as st
import pandas as pd
from datetime import datetime
from config import *

# Konfigurasi halaman
st.set_page_config(
    page_title="Cookie Club Data",
    page_icon="🍪",
    layout="wide"
)

# Header
st.markdown("""
    <div style='text-align: center; padding: 1.5rem; background: linear-gradient(90deg, #FFE4C4 0%, #DEB887 100%); border-radius: 10px; margin-bottom: 2rem;'>
        <h1 style='color: #8B4513; margin: 0;'>Cookie Club - Data Management</h1>
        <p style='color: #654321; margin: 5px 0 0 0;'>Lihat & Kelola Data Tabel</p>
    </div>
""", unsafe_allow_html=True)    

# Sidebar
st.sidebar.title("MENU")
page = st.sidebar.radio(
    "Tabel Database:",
    ["Owner", "Produk", "Penjualan", "Detail Penjualan", 
     "Customer", "Customer Profile", "Event", "Event Kategori",
     "Supplier", "Purchase Order", "PO Item", "Akun Keuangan",
     "Beban Operasional", "Jurnal Transaksi"]
)


# ==================== FUNGSI AMBIL DATA DARI TABEL ====================
def get_table_data(table_name):
    """Ambil semua data dari tabel"""
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = f"SELECT * FROM {table_name}"
            cursor.execute(query)
            result = cursor.fetchall()
            
            # Ambil nama kolom
            column_names = [desc[0] for desc in cursor.description]
            
            cursor.close()
            connection.close()
            return result, column_names
        except Exception as e:
            st.error(f"Error: {e}")
            return [], []
    return [], []


def display_table(table_name, title):
    """Tampilkan tabel dengan pilihan kolom"""
    st.markdown(f"## {title}")
    
    # Ambil data
    result, columns = get_table_data(table_name)
    
    if not result:
        return
    
    # Buat DataFrame
    df = pd.DataFrame(result, columns=columns)
    
    # Info data
    col1, col2, col3 = st.columns(3)
    with col1:
        st.metric("Total Baris", len(df))
    with col2:
        st.metric("Total Kolom", len(df.columns))
  
       
    
    st.markdown("---")
    
    # Pilih kolom yang ditampilkan
    st.markdown("### Pilih Kolom yang Ingin Ditampilkan")
    selected_columns = st.multiselect(
        "Kolom:",
        options=df.columns.tolist(),
        default=df.columns.tolist()
    )
    
    if selected_columns:
        df_display = df[selected_columns]
        
        # Tampilkan tabel
        st.markdown("### Data Tabel")
        st.dataframe(df_display, use_container_width=True, height=400)
        
        # Download CSV
        csv = df_display.to_csv(index=False).encode('utf-8')
        st.download_button(
            label=f"Download {title} (CSV)",
            data=csv,
            file_name=f'{table_name.lower()}_data.csv',
            mime='text/csv'
        )
    else:
        st.info("Pilih minimal 1 kolom untuk ditampilkan")




# ==================== HALAMAN: TABEL OWNER ====================
if page == "Owner":
    display_table("OWNER", "Data Owner")


# ==================== HALAMAN: TABEL PRODUK ====================
elif page == "Produk":
    display_table("PRODUK", "Data Produk")


# ==================== HALAMAN: TABEL PENJUALAN ====================
elif page == "Penjualan":
    display_table("PENJUALAN", "Data Penjualan")


# ==================== HALAMAN: TABEL DETAIL PENJUALAN ====================
elif page == "Detail Penjualan":
    display_table("PENJUALAN_DETAIL", "Detail Penjualan")


# ==================== HALAMAN: TABEL CUSTOMER ====================
elif page == "Customer":
    display_table("CUSTOMER", "Data Customer")


# ==================== HALAMAN: TABEL CUSTOMER PROFILE ====================
elif page == "Customer Profile":
    display_table("CUSTOMER_PROFILE", "Profile Customer")


# ==================== HALAMAN: TABEL EVENT ====================
elif page == "Event":
    display_table("EVENT", "Data Event")


# ==================== HALAMAN: TABEL EVENT KATEGORI ====================
elif page == "Event Kategori":
    display_table("EVENT_KATEGORI", "Kategori Event")


# ==================== HALAMAN: TABEL SUPPLIER ====================
elif page == "Supplier":
    display_table("SUPPLIER", "Data Supplier")


# ==================== HALAMAN: TABEL PURCHASE ORDER ====================
elif page == "Purchase Order":
    display_table("PURCHASE_ORDER", "Purchase Order")


# ==================== HALAMAN: TABEL PO ITEM ====================
elif page == "PO Item":
    display_table("PO_ITEM", "Item Purchase Order")


# ==================== HALAMAN: TABEL AKUN KEUANGAN ====================
elif page == "Akun Keuangan":
    display_table("AKUN_KEUANGAN", "Akun Keuangan")


# ==================== HALAMAN: TABEL BEBAN OPERASIONAL ====================
elif page == "Beban Operasional":
    display_table("BEBAN_OPERASIONAL", "Beban Operasional")


# ==================== HALAMAN: TABEL JURNAL TRANSAKSI ====================
elif page == "Jurnal Transaksi":
    display_table("JURNAL_TRANSAKSI", "Jurnal Transaksi")


# Footer
st.markdown("---")
st.markdown("""
    <div style='text-align: center; color: #888;'>
        <p>KELOMPOK 8 BASDAT A</p>
    </div>
""", unsafe_allow_html=True)