-- 시험에서는 EMPLOYEE 테이블 多
---------------------------------- QUIZ 1 --------------------------------------
--보너스를 안 받지만 부서배치는 된 사원 조회
SELECT *
FROM EMPLOYEE
WHERE BONUS = NULL AND DEPT_CODE != NULL;
-- 이게 안된다.. 왜 안되냐?
-- NULL 값에 대해 정상적으로 비교 처리 되지 않음!!

-- 문제점 : NULL 값 비교할 때는 단순한 일반 비교연산자를 통해 비교 할 수 없음!
-- 해결방법 : IS NULL / IS NOT NULL 연산자를 이용해서 비교해야됨!

-- 조치한 SQL문
SELECT *
FROM EMPLOYEE
WHERE BONUS IS NULL AND DEPT_CODE IS NOT NULL;
--------------------------------------------------------------------------------- 1월 8일에 디비 시험
---------------------------------- QUIZ 2 --------------------------------------
-- 검색하고자 하는 내용
-- JOB_CODE J7이거나 J6이면서 SALARY값이 200만원 이상이고
-- BONUS가 있고 여자이며 이메일 주소 _앞에 3글자만 있는 사원의 
-- EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS를 조회하려고 한다.
-- 정상적으로 조회가 잘 된다면 실행결과는 2행이어야 한다.

-- 위의 내용을 실행시키고자 작성한 SQL문은 아래와 같다.
SELECT EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS, EMAIL
FROM EMPLOYEE
WHERE JOB_CODE = 'J7' OR JOB_CODE = 'J6' AND SALARY > 2000000
AND EMAIL LIKE '___%' AND BONUS IS NULL;

-- 위의 SQL문 실행 시 원하는 결과가 제대로 조회가 되지 않는다.
-- 이 때 어떤 문제점(5개)들이 있는지 모두 찾아서 서술하시오.
-- 그리고 조치한 완벽한 SQL문을 작성해볼 것!

-- 문제점 :
-- 1. OR 연산자와 AND 연산자가 나열되어 있을 경우 AND 연산자 먼저 수행이 됨! 문제에서 요구한 내용으로 OR 연산이 먼저 수행이 되어야함!
-- 2. 급여값에 대한 비교가 잘못되어 있음. > 이 아닌 >= 으로 비교해야됨
-- 3. 보너스가 있는 이라는 조건에 IS NULL이 아닌 IS NOT NULL로 비교해야됨!!
-- 4. 여자에 대한 조건이 누락되어 있음.
-- 5. 이메일에 대한 비교 시 네번째 자리에 있는 _를 데이터값으로 취급하기 위해서는 새 와일드 카드를 제시해야 되고, 또한 ESCAPE OPTION으로 등록까지 해야함!

-- 조치쿼리 : 
SELECT EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS, EMAIL
FROM EMPLOYEE
WHERE (JOB_CODE = 'J7' OR JOB_CODE = 'J6') AND SALARY >= 2000000
AND EMAIL LIKE '___$_%' ESCAPE '$' AND BONUS IS NOT NULL
AND SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

---------------------------------------------------------------------------------
---------------------------------- QUIZ 3 --------------------------------------
-- [계정생성구문] CREATE USER 계정명 IDENTIFIED BY 비밀번호;

-- 계정명 : SCOTT, 비밀번호 : TIGER 계정을 생성하고 싶다!
-- 이 때, 일반 사용자 계정인 KH 계정에 접속해서 CREATE USER SCOTT; 로 실행하니 문제 발생!!

-- 문제점 1. 사용자 계정 생성은 무조건 관리자 계정에서만 가능!!
-- 문제점 2. SQL문이 잘못되어 있음! 비번까지 입력해야됨!

-- 조치내용 1. 관리자 계정에 접속해야됨!
-- 조치내용 2. CREATE USER SCOTT IDENTIFIED BY TIGER;

-- 위의 SQL(CREATE)만 실행 후 접속을 만들어서 접속을 하려고 했더니 실패!
-- 뿐만 아니라 해당 계정에 테이블 생성 같은 것도 되지 않음! 왜 그럴까?

-- 문제점 1. 사용자 계정 생성 후 최소한의 권한 부여가 안됐다.
-- 조치내용 1. GRANT CONNECT, RESOURCE TO SCOTT;








