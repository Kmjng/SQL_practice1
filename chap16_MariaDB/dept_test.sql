CREATE OR REPLACE TABLE dept_test(
dno INT AUTO_INCREMENT PRIMARY KEY, 
dname VARCHAR(50) NOT NULL, 
loc VARCHAR(100) 
);
-- 자동번호생성: 1부터 1씩 증가 
-- null값이어도 자동번호생성기가 숫자 부여하는듯 

INSERT INTO dept_test VALUES(NULL, '영업부','뉴욕시');
INSERT INTO dept_test VALUES(NULL, '기획실','서울시');
INSERT INTO dept_test VALUES(NULL, '연구실','대전시');

SELECT * FROM dept_test;

COMMIT ; 

