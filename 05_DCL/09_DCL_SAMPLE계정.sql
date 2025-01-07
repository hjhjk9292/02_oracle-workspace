CREATE TABLE TEST(
    TEST_ID NUMBER,
    TEST_NAME VARCHAR2(10)
);

-- CREATE TABLE 할 수 있는 권한이 없어서 문제 발생!
-- 3_1. CREATE TABLE 권한 받기
-- 3_2. TABLESPACE 할당 받기

SELECT * FROM TEST;
INSERT INTO TEST VALUES(10, '안녕');
-- CREATE TABLE 권한 받으면 테이블들 바로 조작 가능

----------------------------------------------------------------------------------
-- KH계정에 있는 EMPLOYEE 테이블에 접근
-- 근데 조회 권한이 없음
-- 4. SELECT ON KH.EMPLOYEE 권한 부여받기
SELECT * FROM KH.EMPLOYEE;
SELECT * FROM KH.DEPARTMENT;

-- 5. INSERT ON KH.DEPARTMENT 권한 부여받기
INSERT INTO KH.DEPARTMENT
VALUES('D0', '회계부', 'L1');

ROLLBACK;


















