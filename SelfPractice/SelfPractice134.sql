SELECT * FROM crime_cause2;

-- 방화사건(범죄유형)의 가장 큰 원인(term)이 무엇인가? 
SELECT term 원인 FROM crime_cause2 WHERE cnt = (SELECT MAX(cnt) FROM crime_cause2 WHERE 범죄유형 ='방화');

--방법2 
SELECT 원인 FROM (SELECT term 원인,RANK() OVER (ORDER BY cnt DESC) RANK FROM crime_cause2 WHERE 범죄유형 = '방화')
WHERE RANK =1 ;