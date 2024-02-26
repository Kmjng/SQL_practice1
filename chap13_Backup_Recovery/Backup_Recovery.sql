/*
    1. 테이블 삭제 
    2. 임시파일 & 테이블 이름 확인
    3. 임시파일 이용 테이블 복원 

*/

-- 1) 테이블 확인
SELECT * FROM USER_TABLES;
-- 2) table 삭제
DROP TABLE dept01; 


-- 3) 임시파일 조회 데이터 사전 뷰에서 dept01에 대한 임시파일을 확인한다.
SELECT * FROM USER_RECYCLEBIN; 
-- 4) 테이블 찾기 - 삭제된 것 확인
SELECT * FROM USER_TABLES 
WHERE TABLE_NAME = 'DEPT01'; -- 대문자 주의
-- 5) 테이블 복원 : 복사 & 붙여넣기 - 오브젝트 이름 
FLASHBACK TABLE "BIN$FlJHLWdvRVuKoHsbWY+rVA==$0" TO BEFORE DROP; 
