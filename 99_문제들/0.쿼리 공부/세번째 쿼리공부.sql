-- QUIZ1 (DCL 복습)
-- CREATE USER TEST IDENTIFIED BY 1234; 실행
-- User TEST이(가) 생성되었습니다.
-- 계정 생성만 하고 접속 시 에러

-- 왜 오류가 났는지? 해결 방안
-- 문제점 : 계정 생성만 했고 접속 권한을 부여하지 않았기 때문에
-- GRANT CONNECT, RESOURCE TO TEST; -- CONNECT : 역할(ROLE) // 문제에서 딱히 언급이 없으면
-- GRANT CREATE SESSTION TO TEST; -- CREATE SESSION : 접속할 수 있는 권한 // 문제에서 롤을 쓰지 말고 권한 이름으로 작성하시오. 라고 했을 때

-- QUIZ(JOIN 복습)
CREATE TABLE TB_JOB(
    JOBCODE NUMBER PRIMARY KEY,
    JOBNAME VARCHAR2(10) NOT NULL
);

CREATE TABLE TB_EMP(
    EMPNO NUMBER PRIMARY KEY,
    EMPNAME VARCHAR2(10) NOT NULL,
    JOBNO NUMBER REFERENCES TB_JOB(JOBCODE)    
);

-- 위의 두 테이블이 있다는 가정하에
-- 두 테이블 조인해서 EMPNO, EMPNAME, JOBNO, JOBNAME 컬럼을 조회할거임
-- 이 때 실행한 SQL문

SELECT EMPNO, EMPNAME, JOBNO, JOBNAME
FROM TB_EMP
JOIN TB_JOB USING(JOBNO);
-- 에러
-- ORA-00904: "TB_JOB"."JOBNO": invalid identifier

-- 문제점 : JOBNO 컬럼이 TB_EMP에는 존재하지만, TB_JOB에는 존재하지 않기 때문에 USING 구문에 문제 있음
-- 해결내용 : USING(JOBNO)이 아니라 ON절 (JOBNO = JOBCODE)을 사용한다

SELECT EMPNO, EMPNAME, JOBNO, JOBNAME
FROM TB_EMP
JOIN TB_JOB ON (JOBNO = JOBCODE);

---------------------------------------------------------------------------------
-- 테이블 생성 관련 해서 데이터 타입 (CHAR, VARCHAR2 차이점) ㅡ 고정길이 2000BYTE, 가변길이 4000BYTE
-- 오라클 객체 (SEQUENCE, TABLE, VIEW) 각각 뭔지..
-- 제약조건 => 뒤늦게 제약조건을 추가할 수 있는 ALTER 문
-- DCL은 뭘까?
-- 커밋 롤백 뭘까?(TCL)

-- QUIZ3(JOIN 복습)
-- 아래의 SQL 구문은 부서별 월급 합계가 15,000,000을 초과하는 부서를 조회한 것이다.
-- 결과가 올바르지 않다고 할 때, 그 원인과 조치사항

SELECT DEPT_CODE, SUM(SALARY) --4
FROM EMPLOYEE --1
WHERE SALARY >= 15000000 --2
GROUP BY DEPT_CODE; --3

-- GROUP BY를 할 때는 WHERE절이 안된다. (X)
-- GROUP에 대한 조건을 제시할 때는 WHERE절로 쓰는게 아니다. => HAVING

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 15000000;

-- QUIZ4 (제약조건 복습)
CREATE TABLE QUIZ4(
    QNO NUMBER PRIMARY KEY,
    QNAME VARCHAR2(10),
    SCORE NUMBER
);

SELECT * FROM QUIZ4;

INSERT INTO QUIZ4 VALUES(1, '퀴즈1번', 30);
INSERT INTO QUIZ4 VALUES(1, '퀴즈2번', 50); -- PRIMARY 제약조건은 중복도, NULL도 안 됨

-- 에러남 왜나냐~~~
-- 조치해봐~~


-- CASE WHEN
-- SALARY가 500 이상이면 고급개발자
--          300 이상이면 중급개발자
--                      초급개발자 (DECODE가 아니라 CASE WHEN으로 푸시오.)

SELECT EMP_NAME, SALARY,
        CASE WHEN SALARY >= 5000000 THEN '고급 개발자'
             WHEN SALARY >= 3000000 THEN '중급 개발자'
             ELSE '초급 개발자'
        END AS "레벨" -- END 꼭 해주기
FROM EMPLOYEE;