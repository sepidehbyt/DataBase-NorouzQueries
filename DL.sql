DELIMITER $$
CREATE TRIGGER ins_trans AFTER INSERT ON transactions
    
    FOR EACH ROW
    BEGIN	
    
    UPDATE deposit
    SET deposit.balance = deposit.balance - new.amount
    WHERE deposit.a_id = new.a_id and new.type = '1';
    
    UPDATE deposit
    SET deposit.balance = deposit.balance + new.amount
    WHERE deposit.a_id = new.a_id and new.type = '0';
    

END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER ins_tran AFTER INSERT ON transfer
    
    FOR EACH ROW
    BEGIN   
    
    UPDATE deposit
    SET deposit.balance = deposit.balance + new.amount
    WHERE deposit.a_id = new.a1_id;
    
    UPDATE deposit
    SET deposit.balance = deposit.balance - new.amount
    WHERE deposit.a_id = new.a2_id;

    insert into transactions(a_id, type, amount, ts) VALUES (new.a1_id, '0', new.amount DIV 2, NOW());
    insert into transactions(a_id, type, amount, ts) VALUES (new.a2_id, '1', new.amount DIV 2, NOW());

END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER ins_borr AFTER INSERT ON borrow
    
    FOR EACH ROW
    BEGIN   
    
    IF (new.c_id NOT IN (select deposit.c_id FROM deposit WHERE deposit.b_id = new.b_id  ))
    THEN
        CALL raise_application_error(3001, 'No customer Found in this branch');
    ELSE
        UPDATE deposit
        SET deposit.balance = deposit.balance + new.amount
        WHERE new.c_id = deposit.c_id and new.b_id = deposit.b_id;
    END IF;

END$$
DELIMITER ;



insert into customer(c_id, c_name, c_city, c_street) VALUES ('1000', 'Sepideh', 'tehran', 'Valiasr');
insert into customer(c_id, c_name, c_city, c_street) VALUES ('1001', 'sina', 'tehran', 'Jordan');
insert into customer(c_id, c_name, c_city, c_street) VALUES ('1002', 'Khosro Heydari', 'shiraz', 'Amirkabir');
insert into customer(c_id, c_name, c_city, c_street) VALUES ('1003', 'Karim Benzema', 'karaj', 'Hafez');

insert into branch(b_id, b_name, b_city) VALUES ('2000', 'Hafez', 'shiraz');
insert into branch(b_id, b_name, b_city) VALUES ('2001', 'Valiasr', 'tehran');
insert into branch(b_id, b_name, b_city) VALUES ('2002', 'Amirkabir', 'tehran');
insert into branch(b_id, b_name, b_city) VALUES ('2003', 'Jordan', 'tehran');

insert into deposit(c_id, b_id, a_id, balance, ts) VALUES ('1003', '2001', '3000', '75195', NOW());
insert into deposit(c_id, b_id, a_id, balance, ts) VALUES ('1000', '2000', '3001', '4683', NOW());
insert into deposit(c_id, b_id, a_id, balance, ts) VALUES ('1002', '2000', '3002', '92706', NOW());
insert into deposit(c_id, b_id, a_id, balance, ts) VALUES ('1003', '2002', '3003', '59999', NOW());
insert into deposit(c_id, b_id, a_id, balance, ts) VALUES ('1003', '2003', '3004', '57772', NOW());
insert into deposit(c_id, b_id, a_id, balance, ts) VALUES ('1001', '2001', '3005', '53578', NOW());
insert into deposit(c_id, b_id, a_id, balance, ts) VALUES ('1003', '2003', '3006', '43318', NOW());
insert into deposit(c_id, b_id, a_id, balance, ts) VALUES ('1001', '2002', '3007', '37382', NOW());
insert into deposit(c_id, b_id, a_id, balance, ts) VALUES ('1002', '2003', '3008', '9633', NOW());
insert into deposit(c_id, b_id, a_id, balance, ts) VALUES ('1000', '2003', '3009', '64184', NOW());

insert into borrow(c_id, b_id, L_id, amount) VALUES ('1002', '2000', '4000', '91217');
insert into borrow(c_id, b_id, L_id, amount) VALUES ('1000', '2003', '4001', '81332');
insert into borrow(c_id, b_id, L_id, amount) VALUES ('1002', '2000', '4002', '67590');
insert into borrow(c_id, b_id, L_id, amount) VALUES ('1000', '2000', '4003', '86375');
insert into borrow(c_id, b_id, L_id, amount) VALUES ('1000', '2003', '4004', '8566');
insert into borrow(c_id, b_id, L_id, amount) VALUES ('1001', '2002', '4005', '40195');
insert into borrow(c_id, b_id, L_id, amount) VALUES ('1003', '2003', '4006', '38700');
insert into borrow(c_id, b_id, L_id, amount) VALUES ('1003', '2002', '4007', '21959');
insert into borrow(c_id, b_id, L_id, amount) VALUES ('1003', '2001', '4008', '41183');
insert into borrow(c_id, b_id, L_id, amount) VALUES ('1003', '2003', '4009', '21317');

insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3001', '3008', '41671',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3009', '3004', '23094',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3002', '3000', '466', NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3002', '3006', '82579',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3007', '3003', '50742',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3008', '3002', '67335',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3008', '3008', '27622',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3009', '3009', '93935',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3008', '3008', '14732',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3001', '3002', '97505',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3007', '3003', '74184',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3000', '3002', '70415',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3009', '3003', '65952',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3002', '3006', '12454',NOW());
insert into transfer(a1_id, a2_id, amount, ts) VALUES ('3009', '3003', '57056',NOW());

insert into transactions(a_id, type, amount, ts) VALUES ('3001', '0', '5372', NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3003', '0', '45945',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3000', '0', '49687',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3007', '0', '52449',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3005', '1', '26643',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3003', '0', '48709',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3003', '1', '73209',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3007', '1', '31480',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3007', '0', '83021',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3007', '1', '61170',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3007', '1', '71133',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3001', '0', '18041',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3004', '1', '65500',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3001', '1', '50934',NOW());
insert into transactions(a_id, type, amount, ts) VALUES ('3000', '0', '13056',NOW());