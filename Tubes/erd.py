# erd_cookie.py
"""
🍪 COOKIE CLUB - VISUALISASI ERD
Visualisasi Entity Relationship Diagram dari Database
"""

import streamlit as st
import pandas as pd
import plotly.graph_objects as go
 
from config import create_connection

# Konfigurasi halaman
st.set_page_config(
    page_title="Cookie Club ERD",
    page_icon="🍪",
    layout="wide"
)

# Header
st.markdown("""
    <div style='text-align: center; padding: 1.5rem; background: linear-gradient(90deg, #FFE4C4 0%, #DEB887 100%); border-radius: 10px; margin-bottom: 2rem;'>
        <h1 style='color: #8B4513; margin: 0;'>🍪 Cookie Club - ERD Visualization</h1>
        <p style='color: #654321; margin: 5px 0 0 0;'>Entity Relationship Diagram Database</p>
    </div>
""", unsafe_allow_html=True)


# ==================== DEFINISI STRUKTUR DATABASE ====================
TABLES = {
    "OWNER": {
        "columns": ["owner_id (PK)", "nama_owner", "no_hp", "status"],
        "color": "#FFB6C1"
    },
    "CUSTOMER": {
        "columns": ["customer_id (PK)", "nama_customer", "tipe", "no_hp", "email", "status"],
        "color": "#87CEEB"
    },
    "CUSTOMER_PROFILE": {
        "columns": ["profile_id (PK)", "customer_id (FK)", "alamat", "npwp", "pic_name", "payment_terms"],
        "color": "#B0E0E6"
    },
    "PRODUK": {
        "columns": ["produk_id (PK)", "nama_produk", "jenis_produk", "harga_satuan", "deskripsi", "status"],
        "color": "#DDA0DD"
    },
    "EVENT_KATEGORI": {
        "columns": ["kategori_id (PK)", "nama_kategori", "deskripsi"],
        "color": "#FFD700"
    },
    "EVENT": {
        "columns": ["event_id (PK)", "kategori_id (FK)", "nama_event", "tgl_mulai", "tgl_selesai", "lokasi_spesifik", "status"],
        "color": "#FFA500"
    },
    "PENJUALAN": {
        "columns": ["penjualan_id (PK)", "tgl_penjualan", "customer_id (FK)", "owner_id (FK)", "event_id (FK)", "tipe_penjualan", "total_transaksi", "keterangan"],
        "color": "#90EE90"
    },
    "PENJUALAN_DETAIL": {
        "columns": ["detail_id (PK)", "penjualan_id (FK)", "produk_id (FK)", "qty", "harga_satuan", "subtotal"],
        "color": "#98FB98"
    },
    "SUPPLIER": {
        "columns": ["supplier_id (PK)", "nama_supplier", "kontak_person", "no_telepon", "alamat", "status"],
        "color": "#F0E68C"
    },
    "PURCHASE_ORDER": {
        "columns": ["po_id (PK)", "supplier_id (FK)", "created_by (FK)", "po_no", "tgl_po", "status", "grand_total", "keterangan"],
        "color": "#FFE4B5"
    },
    "PO_ITEM": {
        "columns": ["po_item_id (PK)", "po_id (FK)", "item_category", "nama_item", "qty_ordered", "harga_satuan", "subtotal"],
        "color": "#FFDAB9"
    },
    "AKUN_KEUANGAN": {
        "columns": ["akun_id (PK)", "kode_akun", "nama_akun", "tipe_laporan", "saldo_normal"],
        "color": "#E0BBE4"
    },
    "BEBAN_OPERASIONAL": {
        "columns": ["beban_id (PK)", "tanggal", "jenis_beban", "keterangan", "nominal", "owner_id (FK)", "event_id (FK)"],
        "color": "#FFDFD3"
    },
    "JURNAL_TRANSAKSI": {
        "columns": ["jurnal_id (PK)", "tanggal", "akun_debit_id (FK)", "akun_kredit_id (FK)", "nominal", "deskripsi", "penjualan_id (FK)", "po_id (FK)", "beban_id (FK)"],
        "color": "#C7CEEA"
    }
}

# Relasi antar tabel (FROM -> TO)
RELATIONSHIPS = [
    ("CUSTOMER", "CUSTOMER_PROFILE"),
    ("EVENT_KATEGORI", "EVENT"),
    ("CUSTOMER", "PENJUALAN"),
    ("OWNER", "PENJUALAN"),
    ("EVENT", "PENJUALAN"),
    ("PENJUALAN", "PENJUALAN_DETAIL"),
    ("PRODUK", "PENJUALAN_DETAIL"),
    ("SUPPLIER", "PURCHASE_ORDER"),
    ("OWNER", "PURCHASE_ORDER"),
    ("PURCHASE_ORDER", "PO_ITEM"),
    ("OWNER", "BEBAN_OPERASIONAL"),
    ("EVENT", "BEBAN_OPERASIONAL"),
    ("AKUN_KEUANGAN", "JURNAL_TRANSAKSI"),
    ("PENJUALAN", "JURNAL_TRANSAKSI"),
    ("PURCHASE_ORDER", "JURNAL_TRANSAKSI"),
    ("BEBAN_OPERASIONAL", "JURNAL_TRANSAKSI")
]


# ==================== FUNGSI AMBIL INFO TABEL ====================
def get_table_info(table_name):
    """Ambil informasi detail tentang tabel"""
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            
            # Hitung jumlah baris
            cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
            row_count = cursor.fetchone()[0]
            
            # Ambil info kolom
            cursor.execute(f"DESCRIBE {table_name}")
            columns_info = cursor.fetchall()
            
            cursor.close()
            connection.close()
            
            return {
                'row_count': row_count,
                'columns': columns_info
            }
        except Exception as e:
            return None
    return None


# ==================== SIDEBAR ====================
st.sidebar.title("🔍 Pilih Tabel")
selected_table = st.sidebar.selectbox(
    "Lihat Detail Tabel:",
    options=["-- Pilih Tabel --"] + list(TABLES.keys())
)

st.sidebar.markdown("---")
st.sidebar.markdown("### 📊 Legend")
st.sidebar.markdown("**PK** = Primary Key")
st.sidebar.markdown("**FK** = Foreign Key")


# ==================== VISUALISASI ERD DENGAN PLOTLY ====================
st.markdown("## 🗺️ Entity Relationship Diagram")

# Buat graph menggunakan NetworkX
G = nx.Graph()

# Tambahkan nodes (tabel)
for table in TABLES.keys():
    G.add_node(table)

# Tambahkan edges (relasi)
for rel in RELATIONSHIPS:
    G.add_edge(rel[0], rel[1])

# Layout menggunakan spring layout
pos = nx.spring_layout(G, k=2, iterations=50, seed=42)

# Siapkan data untuk Plotly
edge_trace = []
for edge in G.edges():
    x0, y0 = pos[edge[0]]
    x1, y1 = pos[edge[1]]
    edge_trace.append(
        go.Scatter(
            x=[x0, x1, None],
            y=[y0, y1, None],
            mode='lines',
            line=dict(width=2, color='#888'),
            hoverinfo='none',
            showlegend=False
        )
    )

# Node traces
node_x = []
node_y = []
node_text = []
node_colors = []

for node in G.nodes():
    x, y = pos[node]
    node_x.append(x)
    node_y.append(y)
    node_text.append(node)
    node_colors.append(TABLES[node]["color"])

node_trace = go.Scatter(
    x=node_x,
    y=node_y,
    mode='markers+text',
    text=node_text,
    textposition="top center",
    textfont=dict(size=10, color='#000', family='Arial Black'),
    marker=dict(
        size=50,
        color=node_colors,
        line=dict(width=2, color='#000')
    ),
    hovertemplate='<b>%{text}</b><br>Klik untuk detail<extra></extra>',
    showlegend=False
)

# Buat figure
fig = go.Figure(data=edge_trace + [node_trace])

fig.update_layout(
    title="Database Schema - Cookie Club",
    titlefont_size=20,
    showlegend=False,
    hovermode='closest',
    margin=dict(b=0, l=0, r=0, t=40),
    xaxis=dict(showgrid=False, zeroline=False, showticklabels=False),
    yaxis=dict(showgrid=False, zeroline=False, showticklabels=False),
    height=600,
    plot_bgcolor='#F5F5F5'
)

st.plotly_chart(fig, use_container_width=True)


# ==================== INFO TABEL YANG DIPILIH ====================
if selected_table != "-- Pilih Tabel --":
    st.markdown("---")
    st.markdown(f"## 📋 Detail Tabel: {selected_table}")
    
    # Ambil info dari database
    info = get_table_info(selected_table)
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.markdown("### 📊 Informasi")
        if info:
            st.metric("Jumlah Baris Data", info['row_count'])
            st.metric("Jumlah Kolom", len(TABLES[selected_table]["columns"]))
    
    with col2:
        st.markdown("### 🎨 Kolom-kolom")
        for col in TABLES[selected_table]["columns"]:
            if "(PK)" in col:
                st.markdown(f"🔑 **{col}**")
            elif "(FK)" in col:
                st.markdown(f"🔗 **{col}**")
            else:
                st.markdown(f"📌 {col}")
    
    # Tampilkan struktur detail dari database
    if info:
        st.markdown("### 🔍 Struktur Kolom Detail")
        columns_df = pd.DataFrame(info['columns'], columns=['Field', 'Type', 'Null', 'Key', 'Default', 'Extra'])
        st.dataframe(columns_df, use_container_width=True)
    
    # Relasi tabel ini
    st.markdown("### 🔗 Relasi dengan Tabel Lain")
    related_tables = []
    for rel in RELATIONSHIPS:
        if rel[0] == selected_table:
            related_tables.append(f"➡️ {selected_table} → {rel[1]}")
        elif rel[1] == selected_table:
            related_tables.append(f"⬅️ {rel[0]} → {selected_table}")
    
    if related_tables:
        for rel in related_tables:
            st.markdown(rel)
    else:
        st.info("Tidak ada relasi langsung dengan tabel lain")


# ==================== DAFTAR SEMUA TABEL ====================
st.markdown("---")
st.markdown("## 📚 Daftar Semua Tabel")

# Buat 3 kolom untuk layout
cols = st.columns(3)

for idx, (table_name, table_info) in enumerate(TABLES.items()):
    with cols[idx % 3]:
        with st.expander(f"📋 {table_name}"):
            info = get_table_info(table_name)
            if info:
                st.metric("Jumlah Data", info['row_count'])
            
            st.markdown("**Kolom:**")
            for col in table_info["columns"][:5]:  # Tampilkan 5 kolom pertama
                st.markdown(f"• {col}")
            if len(table_info["columns"]) > 5:
                st.markdown(f"_...dan {len(table_info['columns']) - 5} kolom lainnya_")


# Footer
st.markdown("---")
st.markdown("""
    <div style='text-align: center; color: #888;'>
        <p>🍪 Cookie Club ERD Visualization | KELOMPOK 8 BASDAT A</p>
    </div>
""", unsafe_allow_html=True)