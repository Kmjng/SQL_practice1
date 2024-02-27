-- 문제해결 개별과제 (기한: 2024-02-29) 

-- 참고 테이블 자료:  hospital_table.sql 

-- 테이블 조회 
SELECT * FROM doctors;
SELECT * FROM nurses;
SELECT * FROM patients;
SELECT * FROM treatments;

DESC doctors;
DESC nurses;
DESC patients;
DESC treatments;


-- 테이블 제약조건 확인 
 -- SELECT * FROM USER_

-- 테이블 1. 최근 병원방문 환자들의 정보 및 진료내역 확인하기 
SELECT treat_date 진료일자 , treat_id 진료번호, t.pat_id 환자번호, p.pat_name 환자이름, t.treat_contents 진료내역, d.doc_name 담당의
FROM treatments t INNER JOIN patients p 
ON t.pat_id = p.pat_id INNER JOIN doctors d ON p.doc_id = d.doc_id
ORDER BY treat_date DESC ; 

-- 테이블 2. 환자 진료내역과 담당의의 전공과 직위 출력하기 
SELECT p.pat_id 환자번호, pat_name 환자이름, t.treat_contents 진료내역,d.major_treat 전공,  d.doc_name "담당의 이름",  d.doc_position 직위
FROM treatments t INNER JOIN patients p 
ON t.pat_id = p.pat_id INNER JOIN doctors d ON d.doc_id = t.doc_id 
ORDER BY 환자번호; 

-- 테이블 3. 진료 내역에 따른 담당의와 간호사 배치 확인하기 
SELECT t.treat_contents 진료내역, doc_name 의사이름, nur_name 간호사이름
FROM patients p INNER JOIN nurses n 
ON p.nur_id = n.nur_id INNER JOIN patients p INNER JOIN treatments t --  환자와 간호사 연결, 환자와 진료내역 연결
ON p.pat_id = t.pat_id INNER JOIN  doctors d      -- 환자와 의사 연결
ON d.doc_id = p.doc_id 
; 