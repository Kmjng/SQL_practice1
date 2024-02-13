SELECT * FROM price;


SELECT a_name AS "상품" , a_price AS "가격", m_name AS "매장명" 
FROM price 
WHERE a_price = (SELECT MAX(a_price) FROM price);

COMMIT;