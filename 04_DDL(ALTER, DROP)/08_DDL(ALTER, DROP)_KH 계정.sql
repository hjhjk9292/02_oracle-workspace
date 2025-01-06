-- 먼저 저장

/*
    DDL (DATA DEFINITION LANGUAGE) : 데이터 정의 언어
    
    객체들을 생성(CREATE), 변경(ALTER), 삭제(DROP) 하는 구문
    
    < ALTER >
    객체를 변경하는 구문
    
    [표현식]
    ALTER TABLE 테이블명 변경할내용;
    
    * 변경할 내용
    1) 컬럼 추가 / 수정 / 삭제
    2) 제약조건 추가 / 삭제 --> 수정은 불가 (수정하고자 한다면 삭제한 후 새로이 추가)
    3) 컬럼명 / 제약조건명 / 테이블명 변경
*/

-- 1) 컬럼 추가 / 수정 / 삭제
-- 1_1) 컬럼 추가(ADD) : ADD 컬럼명 자료형 [DEFAULT 기본값 제약조건]
-- DEPT_COPY에 CNAME 컬럼 추가
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);
-- > 새로운 컬럼이 만들어지고 기본적으로는 NULL로 태워짐

-- LNAME 컬럼 추가 (기본값을 지정한채로)
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국'; -- DEFAULT에 NULL이 아닌 값

-- 1_2) 컬럼 수정(MODIFY)
--> 자료형 수정      : MODIFY 컬럼명 바꾸고자하는 자료형
--> DEFAULT값 수정  : MODIFY 컬럼명 DEFAULT 바꾸고자하는 기본값

ALTER TABLE DEPT_COPY 변경할내용;
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;
-- 이건 오류남!! 이미 데이터가 숫자 아닌것도 들어있음
-- 존재하는 데이터가 없어야만 이렇게 바꿀 수 있음!! 

ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10);
-- 이것도 오류 발생! (some value is too big)
-- 이미 담겨있는 데이터가 10바이트보다 큼!

-- DEPT_TITLE 컬럼을 VARCHAR2(50) => DEPT_COPY 테이블 바꾸는거!!
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(50);
-- LOCATION_ID 컬럼을 VARCHAR(4)로 = > 
ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHAR(4);
-- LNAME 컬럼의 기본값을 '영국'으로 변경
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '영국';
SELECT * FROM DEPT_COPY; -- 조회하면 '한국'으로 나온다 ㄴ 앞으로의 데이터가 '영국'으로 될 것

-- 다중 변경 가능
ALTER TABLE DEPT_COPY
    MODIFY DEPT_TITLE VARCHAR2(50)
    MODIFY LOCATION_ID VARCHAR(4)
    MODIFY LNAME DEFAULT '영국';

-- 1_3) 컬럼 삭제 (DROP COLUMN) : DROP COLUMN 삭제하고자 하는 컬럼명
-- 삭제를 위한 복사본 테이블 생성
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY; -- DEPT_COPY 복제

SELECT * FROM DEPT_COPY2;

-- DEPT_COPY2로 부터 DEPT_ID컬럼 지우기
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;

-- DROP COLUMN은 다중 ALTER 안됨! 하나하나 해주기!

ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
-- ORA-12983: cannot drop all columns in a table
-- 최소 한 개의 컬럼은 존재해야됨!!

--------------------------------------------------------------------------------
-- 2) 제약조건 추가 / 삭제
/*
    2_1)제약조건 추가
    PRIMARY KEY : ADD PRIMARY KEY(컬럼명)
    FOREIGN KEY : ADD FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명 [(컬럼명)]
    UNIQUE : ADD UNIQUE(컬럼명)
    CHECK : ADD CHECK(컬럼에 대한 조건)
    NOT NULL : MODIFY 컬럼명 NOT NULL | NULL
    
    제약조건명을 지정하고자 한다면 [CONSTAINT 제약조건명] 제약조건
*/
-- DEPT_ID에 PRIMARY KEY 제약조건 추가 (ADD 사용)
-- DEPT_TITLE에 UNIQUE 제약조건 추가 ADD
-- LNAME에 NOT NULL 제약조건 추가 MODIFY

ALTER TABLE DEPT_COPY
    ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
    ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
    MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;

-- 2_2) 제약조건 삭제 : DROP CONSTRAINT 제약조건명
-- NOT NULL은 삭제가 안되고 MODIFY NULL 이걸로 수정해줘야한다.
ALTER TABLE DEPT_COPY 변경할내용;
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;

ALTER TABLE DEPT_COPY 
    DROP CONSTRAINT DCOPY_UQ
    MODIFY LNAME NULL;

-----------------------------------------------------------------------------
-- 3) 컬럼명 / 제약조건명 / 테이블명 변경 (RENAME)
-- 3_1) 컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명

--DEPT_TITLE ==> DEPT_NAME
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 3_2) 제약조건명 변경 : RENAME CONTRINT 기존제약조건명 TO 바꿀제약조건명;
-- DEPT_COPY 테이블에서 SYS_C007228를 DCOPY_DID_NN로 바꾸기
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007228 TO DCOPY_DID_NN;

-- 3_3) 테이블명 변경 : RENAME [기존테이블명] TO 바꿀테이블명
-- DEPT_COPY 테이블 이름을 DEPT_TES로 변경
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;

SELECT * FROM DEPT_TEST;

--------------------------------------------------------------------------------
/*
    2. DROP
    객체를 삭제하는 구문
    
    [표현법]
    DROP TABLE 삭제하고자하는 테이블명;
*/

-- EMP_NEW 삭제
DROP TABLE EMP_NEW;

-- 부모테이블을 삭제할 경우, 테스트 할 환경 만들기
-- 1) DEPT_TEST 테이블에 DEPT_ID 컬럼을 먼저 PRIMARY KEY 제약조건 추가 시키기
ALTER TABLE DEPT_TEST
ADD CONSTRAINT DTEST_PK PRIMARY KEY(DEPT_ID);

-- 2) EMPLOYEE_COPY3에 컬럼 추가 => 외래키 제약조건
ALTER TABLE EMPLOYEE_COPY3
ADD DEPT_CODE CHAR(3);

SELECT * FROM EMPLOYEE_COPY3;

UPDATE EMPLOYEE_COPY3
SET DEPT_CODE = 'D1';

ALTER TABLE EMPLOYEE_COPY3
ADD CONSTRAINT ECOPY_FK FOREIGN KEY(DEPT_CODE) REFERENCES DEPT_TEST; -- 부모 : DEPT_ TEST / 자식 : EMPLOYEE_COPY3

DROP TABLE DEPT_TEST;
-- ORA-02449: unique/primary keys in table referenced by foreign keys

-- 단, 참조되고 있는 부모테이블은 삭제되지 않음
-- 만약에 부모테이블을 삭제하고자 한다면

-- 방법1) 자식테이블을 먼저 삭제 후 부모테이블 삭제
DROP TABLE 자식테이블;
DROP TABLE 부모테이블;

-- 방법2) 자식테이블에서 외래키 제약조건 삭제 후, 부모테이블 지우기











