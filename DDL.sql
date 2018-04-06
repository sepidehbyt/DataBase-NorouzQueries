CREATE TABLE customer (
    c_id int not null UNIQUE,
    c_name varchar(100) not null,
    c_city varchar(100),
    c_street varchar(100),
    primary key (c_id)
);

CREATE TABLE branch (
    b_id int not null UNIQUE,
    b_name varchar(100) not null UNIQUE,
    b_city varchar(100) not null,
    primary key (b_id, b_name)
);

CREATE TABLE deposit (
    c_id int not null,
    b_id int not null,
    a_id int not null UNIQUE,
    balance int not null,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (c_id) REFERENCES customer(c_id),
    FOREIGN KEY (b_id) REFERENCES branch(b_id),
    primary key (a_id)
);

CREATE TABLE transfer (
    a1_id int not null,
    a2_id int not null,
    amount int not null,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (a1_id) REFERENCES deposit(a_id),   
    FOREIGN KEY (a2_id) REFERENCES deposit(a_id)
);

CREATE TABLE transactions (
    a_id int not null,
    type varchar(20) not null,
    amount int not null,
    ts TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (a_id) REFERENCES deposit(a_id)  
);

CREATE TABLE borrow (
	c_id int not null,
    b_id int not null,
    L_id int not null UNIQUE,
    amount int not null,
    FOREIGN KEY (c_id) REFERENCES customer(c_id),
    FOREIGN KEY (b_id) REFERENCES branch(b_id),
    primary key (L_id) 
);