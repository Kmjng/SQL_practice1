-- 5. ANSI JOIN : 국제 표준 JOIN문 

-- 1) CROSS JOIN : 조인조건 없음 
/*
  SELECT *
  FROM table1 CROSS JOIN table2;
*/

DESC student ; 
DESC professor ; 
SELECT * FROM student ; -- 20r x 12c
SELECT * FROM professor ; -- 16r x 10c

SELECT * 
FROM STUDENT CROSS JOIN PROFESSOR; -- (320rx22c) ★★행곱열덧


-- 2) Inner Join : ON절 이용 조인 조건 
/*
  SELECT * 
  FROM table1 Inner Join table2
  ON 조인조건 | USING(공통칼럼);
*/

-- ON 조인조건 
SELECT S.name, S.deptno1, P.profno, P.name, P.position, P.deptno
FROM STUDENT S Inner Join PROFESSOR P
ON S.profno = P.profno; -- 조인 조건 : (15r x 6c) 
-- 학생 : 지도교수 있음, 교수 : 지도학생 있음 


-- 3) Outer Join : 왼쪽,오른쪽,양쪽 테이블 기준  
/*
  SELECT * 
  SELECT * FROM table1 [LEFT | RIGHT] Outer Join table2
  ON 조인조건  | USING(공통칼럼);
*/

-- [1) LEFT Outer Join : ON절 
SELECT S.name, S.profno, P.name, P.profno
FROM student S LEFT Outer Join professor P
ON S.profno = P.profno; -- 20명 학생 출력

-- [2] RIGHT Outer Join
SELECT S.name, S.profno, P.name, P.profno
FROM student S RIGHT Outer Join professor P
ON S.profno = P.profno; -- 22명 교수 (겹침) 출력
-- 담당한 학생없는 경우 포함  


-- USING 사용 
SELECT s.name, s.deptno1, p.profno, p.name, p.position, p.deptno
FROM student s INNER JOIN professor p 
USING (profno) ; 

COMMIT;
