/*
    < PL / SQL >
    PROCEDURE LANGUAGE EXTENSION TO SQL
    
    오라클 자체에 내장되어 있는 절차적 언어
    SQL 문장내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE) 등을 지원하여 SQL 단점을 보완
    다수의 SQL문을 한번에 실행 가능 (BLOCK 구조) + 예외처리도 가능
    
    * PL / SQL 구조
    - [선언부] : DECLARE로 시작, 변수나 상수를 선언 및 초기화 하는 부분
    - 실행부 : BEGIN 으로 시작, 무조건 있어야함!!, SQL문 또는 제어문(조건문, 반복문) 등의 로직을 기술하는 부분
    - [예외처리부] : EXCEPTION 으로 시작, 예외 발생 시 해결하기 위한 구문을 미리 기술해둘 수 있는 구문

BEGIN
END;
/       -- 구분하기 위해 / 작성해주며 이게 한 블럭이라고 표현

*/

SET SERVEROUTPUT ON; -- 콘솔창 키는 거★ 학원 오면 켜놓기

-- 간단하게 화면에 HELLO ORACLE 출력! HELLO WORLD 출력했던 것처럼..
BEGIN
    -- Sytem.out.println("HELLO ORACLE");
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/          

 -- 하나의 PROCEDURE를 만든 것, / 뒤에 주석 달면 오류남
 
----------------------------------------------------------------------------------
/*
    1. DECLARE 선언부
    변수 및 상수 선언하는 공간 (선언과 동시에 초기화도 가능)
    일반타입변수, 레퍼런스타입변수, ROW타입 변수
    
    1_1) 일반타입 변수 선언 및 초기화 (변수 선언 = 변수 만든다)
        [표현식] 변수명 [CONSTANT -> 상수가 됨] 자료형 [:= 값]; -- 변수 선언과 동시에 초기화 -> [표현식] 변수명 자료형 := 값; [] 들 생략가능    
*/

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    --EID := 800;
    --ENAME := '배장남';
    
    EID := &번호;
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/
-- 문자는 홑따옴표 ' 붙이기 // &번호 , '&이름' 사용해서 입력 받을 수 있음

---------------------------------------------------------------------------------
-- 1_2) 레퍼런스 타입 변수 선언 및 초기화(어떤 테이블의 어떤 컬럼의 데이터 타입을 참조해서 그 타입으로 지정)
--      [표현식] 변수명 테이블명.컬럼명%TYPE;   --자료형을 내가 정하는 것이 아니라 레퍼런스 테이블의 그 컬럼이 갖고 있는 타입으로 만들래~

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
--    EID := '300';
--    ENAME := '김시연';
--    SAL := 3000000;
-- 위처럼 내가 원하는 값을 정해줘도 되지만 밑처럼
    -- 사원이 200번인 사원의 사번, 사원명, 급여 조회해서 각 변수에 대입
    
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
END;
/

---------------------------- 실습문제 -----------------------------------------
/*
    레퍼런스타입 변수로 EID, JCODE, SAL, DTITLE을 선언하고
    각 자료형이 EMPLOYEE, DEPARTMENT 테이블들을 참조하도록
    
    사용자가 입력한 사번의 사원의 사번, 사원명, 직급코드, 급여, 부서명 조회 한 후 
    각 변수에 담아 총 5개의 값 모두 출력
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL ,DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    WHERE EMP_ID = '&사번';
    
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE : ' || DTITLE);

END;
/

---------------------------------------------------------------------------------
-- 1_3) ROW 타입 변수
--      테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
--      [표현식] 변수명 테이블명%ROWTYPE;

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * 
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    -- DBMS_OUTPUT.PUT_LINE(E);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS, 0)); -- NVL 가능!
END;
/

---------------------------------------------------------------------------------
-- 2. BEGIN 실행부

-- < 조건문 >

-- 1) IF 조건식 THEN 실행내용 END IF; (단독 if문)

-- 사번 입력받은 후 해당 사원의 사번, 이름, 급여, 보너스율(%) 출력
-- 단, 보너스를 받지 않는 사원은 보너스율 출력 전 '보너스를 지급받지 않는 사원입니다' 출력

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)  -- BONUS가 NULL이면 0으로
    INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
END;
/

-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF; (IF-ELSE 문)

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)  -- BONUS가 NULL이면 0으로
    INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
    END IF;
    
END;
/

------------------------------- 실습문제 ---------------------------------------
-- 프로시져 만들기
-- 변수
-- 레퍼런스타입변수 (EID, ENAME, DTITLE, NCODE)
-- 참조할테이블 : EMPLOYEE, DEPARTMENT, LOCATION

-- 일반타입변수 (TEAM 문자열) => 이따가 '국내팀', '해외팀' 담을 예정

-- 사용자가 입력한 사원의 사번, 이름, 부서명, 근무국가코드 조회 후 변수에 대입
-- NCODE의 값이 KO일 경우에는 => TEAM에 '국내팀'
--             그게아닐경우 => TEAM에 '해외팀'
-- 사번, 이름, 부서, 소속(국내팀 해외팀)에 대해 출력

DECLARE
    -- 레퍼런스타입변수 (EID, ENAME, DTITLE, NCODE)
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    -- 일반타입변수 (TEAM 문자열) => 이따가 '국내팀', '해외팀' 담을 예정
    TEAM VARCHAR2(10);
    
BEGIN
    -- 사용자가 입력한 사원의 사번, 이름, 부서명, 근무국가코드 조회 후 변수에 대입
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE) --LOCATION에 KO 정보가 써있음
    JOIN NATIONAL N USING (NATIONAL_CODE)
    WHERE EMP_ID = '&사번';
    
    -- NCODE의 값이 KO일 경우에는 => TEAM에 '국내팀'
    --             그게아닐경우 => TEAM에 '해외팀'
    IF NCODE = 'KO'
        THEN TEAM := '국내팀';
    ELSE
        TEAM := '해외팀';
    END IF;
    
-- 사번, 이름, 부서, 소속(국내팀 해외팀)에 대해 출력    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('부서 : ' || DTITLE);
    DBMS_OUTPUT.PUT_LINE('소속 : ' || TEAM);

END;
/

--------------------------------------------------------------------------------
-- 3) IF 조건식1 THEN 실행내용1, ELSIF 조건식2 THEN 실행내용2 .... END IF; (IF - ELSEIF - ELSE 문)

-- 점수를 입력받아 SCORE 변수에 저장한 후 
-- 90점 이상은 'A', 80점 이상은 'B', 70점 이상은 'C', 60점 이상은 'D', 60점 미만은 'F'로 처리한 후 
-- GRADE 변수에 저장
-- 당신의 점수는 XX점이고, 학점은 X학점입니다.

DECLARE
    SCORE NUMBER;
    GRADE VARCHAR2(1);
BEGIN
    SCORE := &점수;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';    
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는' || SCORE || '점이고, 학점은 ' || GRADE || '학점입니다.');
        
END;
/

-------------------------------- 실습문제 -----------------------------------------
-- 프로시저 만들기
-- 변수 2개 (레퍼런스타입변수 : SAL, 일반타입변수 : GRADE => 초급, 중급, 고급)

-- 입력한 사번의 사원의 급여가 500만원 이상이면 GRADE => 고급
--                          300만원 이상이면 GRADE => 중급
--                          300만원 미만이면 GRADE => 초급
-- 해당 사원의 급여 등급은 XX 입니다.

DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY
    INTO SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    IF SAL >= 5000000 THEN GRADE := '고급';
    ELSIF SAL >= 3000000 THEN GRADE := '중급';
    ELSE GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다.');

END;
/

----------------------------------------------------------------------------------
-- 4) CASE 비교대상자 WHEN 동등비교할값1 THEN 결과값1 WHEN 동등비교할값2 THEN 결과값2 .... END; (SWICH CASE)
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(30); -- 부서명 보관 변수
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN '인사팀'
                WHEN 'D2' THEN '회계팀'
                WHEN 'D3' THEN '마케팅팀'
                WHEN 'D4' THEN '국내영업팀'
                WHEN 'D9' THEN '총무팀'
                ELSE '해외영업팀'
             END;
    
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '은(는) ' || DNAME || '입니다.');
END;
/

--------------------------------- 실습문제 --------------------------------------
-- 1. 사원의 연봉을 구하는 PL/SQL 블럭 작성
-- 보너스가 있는 사원은 보너스도 포함하여 계산
-- 보너스가 없으면 보너스미포함 연봉
-- 보너스가 있으면 보너스포함 연봉
-- 출력에서
-- 급여 이름 ￦999,999,999(8000000 선동일 ￦124,800,000)

DECLARE
    EMP EMPLOYEE%ROWTYPE;
    SALARY NUMBER;
BEGIN
    SELECT * --ROWTYPE 쓰기로 했으면 전체 조회하기
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
        IF(EMP.BONUS IS NULL)
            THEN SALARY := EMP.SALARY * 12 ;
        ELSE SALARY := (EMP.SALARY + (EMP.SALARY * EMP.BONUS)) * 12;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE(EMP.SALARY || ' ' || EMP.EMP_NAME || TO_CHAR(SALARY,'L999,999,999'));
        
END;
/
