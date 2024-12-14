-- 1. create database
CREATE DATABASE mobile_banking_db;
USE mobile_banking_db;
-- 2. create table users
CREATE TABLE users (
    id BIGINT PRIMARY KEY,
    nama_lengkap VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    nomor_telepon VARCHAR(15) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    alamat TEXT,
    tanggal_lahir DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- 3. create table akun
CREATE TABLE accounts (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    nomor_rekening VARCHAR(20) NOT NULL UNIQUE,
    saldo DECIMAL(15,2) DEFAULT 0.00,
    jenis_akun ENUM('tabungan', 'giro') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- 4. create table transaksi
CREATE TABLE transactions (
    id BIGINT PRIMARY KEY,
    account_id BIGINT NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    jenis_transaksi ENUM('debit', 'kredit', 'transfer') NOT NULL,
    nominal DECIMAL(15,2) NOT NULL,
    tujuan_transaksi VARCHAR(20),
    keterangan TEXT,
    status ENUM('pending', 'berhasil', 'gagal') NOT NULL DEFAULT 'pending',
    tanggal_transaksi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 5. create table kartu
CREATE TABLE cards (
    id BIGINT PRIMARY KEY,
    account_id BIGINT NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    nomor_kartu VARCHAR(16) NOT NULL UNIQUE,
    jenis_kartu ENUM('debit', 'kredit') NOT NULL,
    tanggal_kadaluarsa DATE NOT NULL,
    cvv_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- 6. create table notifikasi
CREATE TABLE notifications (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    judul VARCHAR(100) NOT NULL,
    isi_pesan TEXT NOT NULL,
    status ENUM('belum_dibaca', 'dibaca') NOT NULL DEFAULT 'belum_dibaca',
    tanggal_dikirim TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 7. create table audit logs
CREATE TABLE audit_logs (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action VARCHAR(100) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    device_info VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 7. create table sessions
CREATE TABLE sessions (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) NOT NULL UNIQUE,
    device_info VARCHAR(255),
    ip_address VARCHAR(45),
    expired_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 8. insert data users
INSERT INTO users 
    (id, nama_lengkap, email, nomor_telepon, password_hash, alamat, tanggal_lahir, created_at, updated_at)
    VALUES
    (1, 'Andi Wijaya', 'andi.wijaya@gmail.com', '081234567890', '$2a$12$V4fGmAeK1h14P4uJWt.t7./HiAnvmbu6b6LVO2.IahzWli.JSYK3a', 'Jl. Merdeka No. 10, Jakarta', '1990-05-10', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 'Siti Rahmawati', 'siti.rahmawati@yahoo.com', '082123456789', '$2a$12$gepUFY8TyoYmg5POTEIwHOtZTyhIvA/q6GG5raTNVp9O6EJUI3.jy', 'Jl. Diponegoro No. 25, Bandung', '1995-08-15', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
-- 9. insert data akun
INSERT INTO accounts 
    (id, user_id, nomor_rekening, saldo, jenis_akun, created_at, updated_at) 
    VALUES
    (1, 1, '1234567890', 15000000.00, 'tabungan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 2, '0987654321', 25000000.00, 'giro', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
-- 10. insert data transactions
INSERT INTO transactions 
    (id, account_id, jenis_transaksi, nominal, tujuan_transaksi, keterangan, status, tanggal_transaksi) 
    VALUES
    (1, 1, 'debit', 500000.00, NULL, 'Pembelian pulsa', 'berhasil', CURRENT_TIMESTAMP),
    (2, 2, 'transfer', 1000000.00, '1234567890', 'Transfer ke Andi Wijaya', 'berhasil', CURRENT_TIMESTAMP);
-- 11. insert data cards
INSERT INTO cards 
    (id, account_id, nomor_kartu, jenis_kartu, tanggal_kadaluarsa, cvv_hash, created_at, updated_at) 
    VALUES
    (1, 1, '4111111111111111', 'debit', '2026-12-31', '$2a$12$OIYGKqSIjUJUlN6r.NkTweibK3FQlbWdpZ4AozcxDTJDgahIoKcH2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 2, '4222222222222222', 'kredit', '2027-11-30', '$2a$12$s9Ik3vtjRwniWCTHbme5vOnGTVdjQp/lk3OAeMOVPEILWinl9z69i', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
-- 12. insert data notifications
INSERT INTO notifications 
    (id, user_id, judul, isi_pesan, status, tanggal_dikirim) 
    VALUES
    (1, 1, 'Transaksi Berhasil', 'Transaksi sebesar Rp500.000 berhasil dilakukan.', 'belum_dibaca', CURRENT_TIMESTAMP),
    (2, 2, 'Saldo Bertambah', 'Saldo Anda bertambah sebesar Rp1.000.000.', 'dibaca', CURRENT_TIMESTAMP);
-- 13. insert data audit_logs
INSERT INTO audit_logs 
    (id, user_id, action, ip_address, device_info, created_at) 
    VALUES
    (1, 1, 'Login', '192.168.1.1', 'Android 12 - Chrome Browser', CURRENT_TIMESTAMP),
    (2, 2, 'Transfer', '192.168.1.2', 'iOS 15 - Safari Browser', CURRENT_TIMESTAMP);
-- 14. insert data sessions
INSERT INTO sessions 
    (id, user_id, token, device_info, ip_address, expired_at, created_at) 
    VALUES
    (1, 2, 'token12345abcdef', 'Android 12 - Chrome Browser', '192.168.1.1', '2024-12-31 23:59:59', CURRENT_TIMESTAMP),
    (2, 2, 'token67890ghijk', 'iOS 15 - Safari Browser', '192.168.1.2', '2024-12-31 23:59:59', CURRENT_TIMESTAMP);
-- 15. get data users
SELECT * FROM users;
-- 16. get data accounts
SELECT * FROM accounts;
-- 17. get data transactions
SELECT * FROM transactions;
-- 18. get data accounts
SELECT * FROM cards;
-- 19. get data users
SELECT * FROM notifications;
-- 20. get data accounts
SELECT * FROM audit_logs;
-- 21. get users data join dengan akun
SELECT 
    users.id AS user_id,
    users.nama_lengkap,
    users.email,
    users.nomor_telepon,
    accounts.nomor_rekening,
    accounts.saldo,
    accounts.jenis_akun
FROM 
    users
INNER JOIN 
    accounts ON users.id = accounts.user_id;
-- 22. get audit log dengan dengan user
SELECT 
    audit_logs.id AS log_id,
    audit_logs.action,
    audit_logs.ip_address,
    audit_logs.device_info,
    audit_logs.created_at,
    users.nama_lengkap
FROM 
    audit_logs
INNER JOIN 
    users ON audit_logs.user_id = users.id;
-- 22.  get data dsesi login aktif dengan user dan perangkat
SELECT 
    sessions.id AS session_id,
    sessions.token,
    sessions.device_info,
    sessions.ip_address,
    sessions.expired_at,
    users.nama_lengkap
FROM 
    sessions
INNER JOIN 
    users ON sessions.user_id = users.id
WHERE 
    sessions.expired_at > CURRENT_TIMESTAMP;
--  23. get data notifikasi berdasarkan status dan 
SELECT 
    notifications.id AS notification_id,
    notifications.judul,
    notifications.isi_pesan,
    notifications.status,
    notifications.tanggal_dikirim,
    users.nama_lengkap
FROM 
    notifications
INNER JOIN 
    users ON notifications.user_id = users.id
WHERE 
    notifications.status = 'belum_dibaca';
-- 24. get semua sesi login dengan detail pengguna dan IP
SELECT 
    sessions.id AS session_id,
    sessions.token,
    sessions.device_info,
    sessions.ip_address,
    sessions.created_at,
    users.nama_lengkap
FROM 
    sessions
INNER JOIN 
    users ON sessions.user_id = users.id;
-- 25. mengambil transaksi berdasarkan tanggal dan status
SELECT 
    transactions.id AS transaction_id,
    transactions.jenis_transaksi,
    transactions.nominal,
    transactions.tanggal_transaksi,
    transactions.keterangan,
    accounts.nomor_rekening,
    users.nama_lengkap
FROM 
    transactions
INNER JOIN 
    accounts ON transactions.account_id = accounts.id
INNER JOIN 
    users ON accounts.user_id = users.id
WHERE 
    transactions.tanggal_transaksi BETWEEN '2024-01-01' AND '2024-12-31'
    AND transactions.status = 'berhasil';
-- 26. mengambil data audit log berdasarkan periode dan perangkat 
SELECT 
    audit_Logs.id AS log_id,
    audit_Logs.action,
    audit_Logs.device_info,
    audit_Logs.created_at,
    users.nama_lengkap
FROM 
    audit_Logs
INNER JOIN 
    users ON audit_Logs.user_id = users.id
WHERE 
    audit_Logs.created_at BETWEEN '2024-06-01' AND '2024-12-31';
-- 27. Mengambil Informasi Kartu dan Riwayat Transaksi Terkait
SELECT 
    cards.nomor_kartu,
    cards.jenis_kartu,
    cards.tanggal_kadaluarsa,
    transactions.id AS transaction_id,
    transactions.jenis_transaksi,
    transactions.nominal,
    transactions.tanggal_transaksi
FROM 
    cards
INNER JOIN 
    accounts ON cards.account_id = accounts.id
INNER JOIN 
    transactions ON accounts.id = transactions.account_id
WHERE 
    cards.jenis_kartu = 'debit';















