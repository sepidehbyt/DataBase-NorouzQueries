1. select c_name from customer
2. select customer.c_name from customer LEFT JOIN borrow ON customer.c_id = borrow.c_id where borrow.c_id is NULL;
3. select customer.c_name from customer natural JOIN deposit NATURAL JOIN branch WHERE deposit.balance > 1000 and branch.b_name = 'valiasr';
4. select customer.c_name from customer natural JOIN deposit NATURAL JOIN branch WHERE branch.b_name = 'valiasr' and customer.c_id not in (select borrow.c_id from borrow)
5. select customer.c_street from customer natural JOIN deposit NATURAL JOIN branch WHERE deposit.balance < 10 and customer.c_id in (select borrow.c_id from borrow)
6. select customer.c_name from customer WHERE customer.c_city = (select customer.c_city from customer WHERE customer.c_id = 1002) and customer.c_street = (select customer.c_street from customer WHERE customer.c_id = 1002) and customer.c_name <> (select customer.c_name from customer WHERE customer.c_id = 1002);
7. select borrow.L_id FROM borrow NATURAL JOIN customer WHERE customer.c_city = 'tehran';
8. select count(branch.b_city) from borrow NATURAL JOIN branch where branch.b_city = 'shiraz'
9. select DISTINCT customer.c_city from customer where customer.c_id IN (select deposit.c_id from branch NATURAL JOIN deposit where branch.b_name = 'valiasr') and customer.c_id IN (select borrow.c_id FROM branch NATURAL JOIN borrow where branch.b_name = 'hafez') ;
10. select SUM(deposit.balance) FROM branch NATURAL JOIN deposit where branch.b_name = 'valiasr';
11. select customer.c_id, customer.c_name FROM customer where customer.c_id IN (select borrow.c_id from borrow NATURAL JOIN branch where branch.b_name='amirkabir' GROUP BY borrow.c_id having COUNT(borrow.c_id) > 2) and customer.c_id IN (select deposit.c_id from branch NATURAL JOIN deposit WHERE deposit.balance >999 and deposit.balance <20001 and branch.b_name = 'amirkabir' );
12. select borrow.c_id, borrow.amount FROM borrow WHERE borrow.c_id IN (select T.c_id from (select deposit.c_id, deposit.b_id FROM deposit NATURAL JOIN branch WHERE branch.b_name= 'valiasr' OR branch.b_name = 'amirkabir' ORDER BY deposit.c_id) as T GROUP BY T.c_id  HAVING COUNT(T.c_id) > 1 );
13. select customer.c_name , T.tsum from (select SUM(amount) as tsum, a2_id FROM transfer where a1_id = '3003' GROUP BY a2_id HAVING tsum > 1000 ) as T JOIN deposit as D on D.a_id=T.a2_id LEFT JOIN customer ON customer.c_id = D.c_id;
14. select customer.c_name FROM customer WHERE customer.c_id IN (select T.c_id from (select DISTINCT deposit.c_id, branch.b_name FROM deposit JOIN branch on deposit.b_id = branch.b_id WHERE branch.b_name= 'valiasr' OR branch.b_name = 'amirkabir' OR branch.b_name = 'hafez') as T GROUP BY T.c_id having COUNT(T.c_id) > 2) 
and 
(select AVG(deposit.balance) FROM deposit JOIN customer on customer.c_id = '1002') > (select AVG(deposit.balance) from deposit where deposit.c_id IN (select T.c_id from (select DISTINCT deposit.c_id, branch.b_name FROM deposit JOIN branch on deposit.b_id = branch.b_id WHERE branch.b_name= 'valiasr' OR branch.b_name = 'amirkabir' OR branch.b_name = 'hafez') as T GROUP BY T.c_id having COUNT(T.c_id) > 2) and deposit.b_id IN (select branch.b_id FROM branch WHERE branch.b_name = 'valiasr' or branch.b_name = 'hafez' or branch.b_name = 'amirkabir'))
and
(select SUM(borrow.amount) FROM borrow NATURAL JOIN branch WHERE branch.b_name = 'valiasr' and borrow.c_id IN (select T.c_id from (select DISTINCT deposit.c_id, branch.b_name FROM deposit JOIN branch on deposit.b_id = branch.b_id WHERE branch.b_name= 'valiasr' OR branch.b_name = 'amirkabir' OR branch.b_name = 'hafez') as T GROUP BY T.c_id having COUNT(T.c_id) > 2) ) < (select SUM(borrow.amount) FROM borrow NATURAL JOIN branch WHERE borrow.c_id = '1001' and branch.b_name = 'jordan')
15. select branch.b_name, branch.b_id, COUNT(deposit.c_id), customer.c_name, customer.c_id from customer NATURAL JOIN branch NATURAL JOIN deposit GROUP BY branch.b_name, deposit.c_id HAVING COUNT(customer.c_id) > 2
16. SELECT customer.c_id, customer.c_name, customer.c_city, customer.c_street , branch.b_id, branch.b_name, branch.b_city , deposit.a_id 
from customer NATURAL JOIN deposit NATURAL JOIN branch 
WHERE deposit.a_id IN (SELECT transactions.a_id FROM transactions WHERE transactions.type ='0' and MONTH(transactions.ts) = MONTH(CURRENT_DATE()) AND transactions.a_id IN 
(select distinct r.a_id from 
(SELECT T.c_id, Substring_index(Substring_index(gdate, ',', 2), ',', -1) AS sec_date from (SELECT deposit.c_id, GROUP_CONCAT(transactions.amount order by transactions.amount desc) AS gdate
FROM  deposit JOIN transactions on transactions.a_id = deposit.a_id
GROUP  BY deposit.c_id) as T) as q 
JOIN transactions as r On q.sec_date = r.amount JOIN deposit as d ON d.c_id = q.c_id))
17. SELECT DISTINCT customer.c_name, T.c_id, Substring_index(Substring_index(gdate, ',', 3), ',', -1) AS third_date, deposit.a_id, deposit.balance, deposit.b_id
from 
(SELECT deposit.c_id, GROUP_CONCAT(r.amount order by r.amount desc) AS gdate
FROM (select * from transfer union all select * from transactions) as r JOIN deposit on r.a1_id = deposit.a_id
Where deposit.c_id IN(select deposit.c_id
from (select * from transfer union all select * from transactions) as q JOIN deposit On q.a1_id = deposit.a_id
GROUP BY deposit.c_id HAVING COUNT(deposit.c_id) > 2)
GROUP BY deposit.c_id) as T LEFT JOIN deposit ON deposit.c_id = T.c_id JOIN (select * from transfer union all select * from transactions) as q on q.amount = Substring_index(Substring_index(gdate, ',', 3), ',', -1) and deposit.a_id = q.a1_id LEFT JOIN customer on customer.c_id = T.c_id
WHERE deposit.b_id IN ( SELECT branch.b_id FROM branch WHERE branch.b_name='valiasr' and branch.b_city='tehran');
18. select transfer.a1_id, transfer.amount FROM transfer WHERE transfer.a2_id IN
(SELECT transfer.a2_id FROM transfer WHERE 
transfer.a1_id In ( select deposit.a_id FROM deposit WHERE deposit.c_id in ( SELECT customer.c_id FROM customer WHERE customer.c_name = 'sina' ) ) )
19. SELECT customer.c_name, customer.c_id, deposit.c_id, SUM(deposit.balance) as sum_deposits from deposit NATURAL JOIN customer GROUP BY deposit.c_id ORDER by sum_deposits ASC LIMIT 10
20. select SUM(transfer.amount) from transfer where MONTH(transfer.ts) = '3'
21. select MAX(transactions.amount) from transactions where DATE(transactions.ts) = '1376:05:05' and transactions.a_id IN(SELECT a_id FROM deposit WHERE deposit.b_id IN ( SELECT b_id FROM branch WHERE branch.b_city= 'karaj') )
22. SELECT customer.c_name FROM customer NATURAL JOIN deposit where deposit.a_id IN
(select transfer.a2_id FROM transfer WHERE transfer.a1_id IN (SELECT deposit.a_id FROM deposit NATURAL JOIN customer WHERE customer.c_name = 'Karim Benzema') GROUP BY transfer.a2_id ORDER BY sum(transfer.amount) DESC) limit 1
23. select customer.c_name, deposit.a_id , MAX(deposit.balance) as mmax FROM deposit NATURAL JOIN customer WHERE DATE(deposit.ts) = '2018:04:05'
24. select customer.c_name,customer.c_id, DATEDIFF(Substring_index(gdate, ',', 1), Substring_index(gdate, ',', -1)) as dif 
FROM (
    SELECT deposit.c_id, GROUP_CONCAT(transactions.ts order by transactions.ts desc) AS gdate 
    FROM transactions JOIN deposit on transactions.a_id = deposit.a_id
GROUP BY deposit.c_id
    ) as T JOIN customer on T.c_id = customer.c_id ORDER BY dif DESC LIMIT 1
25. select branch.b_city, transactions.type, sum(transactions.amount) 
FROM transactions JOIN deposit on transactions.a_id = deposit.a_id JOIN branch on branch.b_id = deposit.b_id
GROUP BY transactions.type, branch.b_city
26. SELECT T.c_id, T.c_name, T.maxx
from(SELECT customer.c_name, deposit.c_id, MAX(deposit.balance) as maxx
      FROM  deposit NATURAL JOIN customer
      GROUP BY deposit.c_id
      HAVING maxx < (select MAX(deposit.balance) FROM deposit)
      ORDER BY maxx DESC
      ) as T
WHERE T.maxx = (SELECT MAX(T.maxx) FROM (SELECT customer.c_name, deposit.c_id, MAX(deposit.balance) as maxx
      FROM  deposit NATURAL JOIN customer
      GROUP BY deposit.c_id
      HAVING maxx < (select MAX(deposit.balance) FROM deposit)
      ORDER BY maxx DESC) as T)
27. select FF.c_id, MIN(FF.ans)
FROM
(SELECT T.c_id, ABS(T.avg0 - Q.avg1) as ans
from 
(SELECT deposit.c_id, AVG(transactions.amount) as avg0 FROM transactions JOIN deposit on deposit.a_id = transactions.a_id JOIN customer on customer.c_id = deposit.c_id
WHERE customer.c_name <> 'sepideh'
GROUP BY deposit.c_id) as T ,
(SELECT AVG(transactions.amount) as avg1 FROM transactions JOIN deposit on deposit.a_id = transactions.a_id JOIN customer on customer.c_id = deposit.c_id WHERE customer.c_name='sepideh') as Q) as FF
28. SELECT branch.b_id, branch.b_name, AVG(deposit.balance) as avvg
FROM branch NATURAL JOIN deposit
GROUP BY branch.b_id
HAVING avvg > (SELECT AVG(deposit.balance) FROM deposit)