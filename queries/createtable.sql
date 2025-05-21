CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    hashed_password TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE assets (
    symbol TEXT PRIMARY KEY, -- Ej: BTC, ETH, USDT
    name TEXT NOT NULL
);

CREATE TABLE wallets (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    asset_symbol TEXT REFERENCES assets(symbol),
    balance NUMERIC(30,10) DEFAULT 0 NOT NULL,
    UNIQUE(user_id, asset_symbol)
);

CREATE TABLE kyc (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) UNIQUE,
    full_name TEXT NOT NULL,
    date_of_birth DATE NOT NULL,
    document_type TEXT CHECK (document_type IN ('passport', 'id_card', 'driver_license')) NOT NULL,
    document_number TEXT NOT NULL,
    country TEXT NOT NULL,
    status TEXT CHECK (status IN ('pending', 'approved', 'rejected')) DEFAULT 'pending',
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP
);

CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action TEXT NOT NULL,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE limits (
    id SERIAL PRIMARY KEY,
    name TEXT,
    tx_type TEXT, -- e.g., 'withdrawal'
    asset_symbol TEXT,
    max_amount NUMERIC(30,10),
    period TEXT CHECK (period IN ('daily', 'monthly'))
);

CREATE TABLE user_limits (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    limit_id INTEGER REFERENCES limits(id),
    used_amount NUMERIC(30,10) DEFAULT 0,
    period_start TIMESTAMP
);

CREATE TABLE fees (
    id SERIAL PRIMARY KEY,
    tx_type TEXT, -- e.g., 'withdrawal'
    asset_symbol TEXT,
    fixed_fee NUMERIC(30,10),
    percentage_fee NUMERIC(5,2)
);