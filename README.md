# 📘 InvenBill – Smart Inventory & Billing System

InvenBill is a **smart, mobile-first Inventory and Billing System** built for small businesses, retail shops, and wholesalers. It enables staff to easily **scan barcodes**, **manage stock**, and **generate PDF invoices**, all from a clean and offline-friendly mobile interface.

Developed using **Flutter (Dart)** for the frontend and **Laravel (PHP)** for the backend, InvenBill is a full-stack, real-time inventory system with role-based admin features and beautiful PDF generation.

---

## 🚀 Features at a Glance

✅ Email & Password Login with Secure Token Auth  
✅ Real-Time Stock Tracking  
✅ Barcode Scanning for Products  
✅ Product Add/Edit/Delete  
✅ Stock In / Stock Out Logging  
✅ PDF Invoice Generation & Sharing  
✅ Invoice History & Filtering  
✅ Role-based Admin Dashboard  
✅ Offline-friendly UI  

---

## 🧭 App Flow – How it Works

### 1️⃣ Login/Signup Screen
- Secure login with email & password
- Auth token stored via `SharedPreferences`
- On success → user is redirected to **Dashboard**

### 2️⃣ Home / Dashboard Screen
Shows real-time overview:
- 📦 Total Products
- 📉 Low Stock Items
- 💰 Sales Today / Month

🔘 Actions:
- ➕ Add Product
- 🧾 Create Invoice
- 🔍 Scan Product
- 📋 View Products

### 3️⃣ Add Product Screen
- Input: Name, Barcode (scan/manual), Price, Quantity, Image (optional)
- Save button → sends data to Laravel API (MySQL)

### 4️⃣ Scan Product Screen
- Uses camera to scan barcode
- If found → auto-fill product details  
- If not → prompt to add as new product

### 5️⃣ Stock Management
- Choose product → Stock In or Stock Out
- Each update logged in `stock_logs` table

### 6️⃣ Product List
- View all products with:
  - Thumbnail, Name, Barcode, Price, Quantity
- Search + Filters (category, low stock)

### 7️⃣ Create Invoice
- Input customer name (optional)
- Add items (via scan or manual)
- Quantity + Auto-calculated totals
- "Generate Invoice" → saves in backend, reduces stock, creates PDF

### 8️⃣ Invoice PDF Preview
- Beautiful invoice with:
  - Logo, Invoice No., Date, Customer Name
  - Itemized products, totals, tax
- Options:
  - 📄 Save
  - 📤 Share (Email, WhatsApp)
  - 🖨️ Print

### 9️⃣ Invoice History
- List of all invoices
- Tap to view, download, re-print
- Optional filter: Date, Customer, Amount

---

## 🔐 Admin-Only Features

- View all users (admin/staff)
- Manage roles & permissions
- Export data (CSV)
- Sales Analytics Chart (daily/monthly)

---

## 🛠️ Tech Stack

| Component         | Technology                     |
|------------------|--------------------------------|
| Frontend         | Flutter (Dart)                 |
| Backend          | Laravel (PHP) + REST API       |
| Database         | MySQL (via XAMPP / Hosted)     |
| Barcode Scanning | `mobile_scanner`               |
| PDF Generation   | `pdf` + `printing` packages    |
| Auth             | Laravel Sanctum                |
| State Mgmt       | Provider                       |
| Charts (Optional)| `fl_chart`                     |

---

## 🧾 Laravel Backend Functionality

- Auth via Sanctum with Role-based Middleware
- REST APIs:
  - `/api/products` – CRUD for products
  - `/api/stock` – Manage stock in/out
  - `/api/invoices` – Create, list, and download invoices
  - `/api/dashboard/stats` – Dashboard metrics
- PDF Templates (if needed)
- Admin middleware for permission control
- JSON responses optimized for mobile

> 📂 Want the backend layout? Ping in Issues or check `backend/` folder if available.

---

## 🔄 Folder Structure (Frontend)

