-- 전국에서 교통사고가 제일 많이 발생하는 지역은?

SELECT * FROM acc_loc_data;

-- 사고장소, 사고건수, 순위 
SELECT * FROM (SELECT acc_loc_name AS 사고장소, acc_cnt AS 사고건수, 
RANK() OVER (ORDER BY acc_cnt DESC) AS 순위  
FROM acc_loc_data WHERE acc_year = 2017 ) WHERE 순위 <=5 ; 
