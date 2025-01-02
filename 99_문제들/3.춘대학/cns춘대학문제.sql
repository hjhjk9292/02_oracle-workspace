----- [Basic SELECT] 완료

--1. 춘 기술대학교의 학과 이름과 계열을 표시하시오.
-- 단, 출력 헤더는 "학과 명", "계열" 으로 표시하도록 한다.
SELECT * FROM TB_CLASS;
SELECT * FROM TB_DEPARTMENT;

SELECT DEPARTMENT_NAME AS "학과 명", CATEGORY AS "계열"
FROM TB_DEPARTMENT;


---2.  학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
-- 힌트 : 연결 연산자 이용해서 || 는 2개 이상 가능
--CONCAT(STRING, STRING) : 2개만 받을 수 있음

SELECT DEPARTMENT_NAME || '의 정원은' AS "학과별", CAPACITY || '명 입니다.' AS "정원"
FROM TB_DEPARTMENT;
--WHERE DEPARTMENT_NAME ||'의 정원은' CAPACITY '명 입니다.' ;

--SELECT DEPARTMENT_NAME AS "학과별", CAPACITY AS "정원"
--FROM TB_DEPARTMENT;
--WHERE CONCAT(DEPARTMENT_NAME '의 정원은', CAPACITY '명 입니다.') ;



--3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어왔다. 
-- 누구인가? (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자)
SELECT * FROM TB_STUDENT;      -- DEPARTMENT_NO
SELECT * FROM TB_DEPARTMENT;   -- DEPARTMENT_NO 001

SELECT STUDENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NO = '001' AND SUBSTR(STUDENT_SSN, 8 ,1) IN ('2', '4') AND ABSENCE_YN = 'Y';


--4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다. 
--그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오. 
--  A513079, A513090, A513091, A513110, A513119
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
ORDER BY STUDENT_NAME DESC;


-- 5. 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열을 출력하시오.
SELECT * FROM TB_DEPARTMENT;

SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY >= 20 AND CAPACITY <= 30;


-- 6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다.
--그럼 춘 기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.
SELECT * FROM TB_PROFESSOR;

SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;


--7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다. 
--어떠한 SQL 문장을 사용하면 될 것인지 작성하시오. 

SELECT *
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;


-- 8. 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는 
--과목들은 어떤 과목인지 과목번호를 조회해보시오.
SELECT * FROM TB_CLASS; -- 선수과목 = PREATTENDING_CLASS_NO

SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;


--9. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오.
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT;


--10. 02 학번 전주 거주자들의 모임을 만들려고 한다.
-- 휴학한 사람들은 제외한 재학중인 학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오.  
-- ㄴ 휴학 안 한 사람 ABSENCE_YN 'N' / 02학번 = 'A21%'
SELECT * FROM TB_STUDENT;

SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'N'
    AND STUDENT_NO LIKE 'A21%'
    AND STUDENT_ADDRESS LIKE '%전주%';



-----[Additional SELECT - 함수] 

--1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른 순으로 표시하는 SQL 문장을 작성하시오.
--( 단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 한다.)
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_CLASS;

SELECT STUDENT_NO AS "학번", STUDENT_NAME AS "이름", ENTRANCE_DATE AS "입학년도"
FROM TB_STUDENT
JOIN TB_CLASS USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NO = '002' AND CLASS_NAME = '영어교육연구'
ORDER BY ENTRANCE_DATE ASC;

--2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다. 그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자. 
--(* 이때 올바르게 작성한 SQL 문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것) 
SELECT * FROM TB_CLASS_PROFESSOR;
SELECT * FROM TB_PROFESSOR;

SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) != 3 ;

--3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 단 이때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 만드시오. 
--(단, 교수 중 2000 년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 한다. 나이는 ‘만’으로 계산한다.)
SELECT PROFESSOR_NAME AS 교수이름, 
        (EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(PROFESSOR_SSN, 1, 2)))) AS 나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8,1)IN('1','3')
ORDER BY 나이 ASC;


--4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 
--출력 헤더는 ?이름? 이 찍히도록 한다. (성이 2자인 경우는 교수는 없다고 가정하시오)
SELECT SUBSTR(PROFESSOR_NAME, 2) AS 이름
FROM TB_PROFESSOR;


---- 5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가?  
-- 이때, 19살에 입학하면 재수를 하지 않은 것으로 간주한다.
--SELECT STUDENT_NAME AS "학생 이름",
--       STUDENT_NO AS "학번",
--       FLOOR(MONTHS_BETWEEN(TO_DATE(SUBSTR(STUDENT_NO, 1, 4) || '-03-01', 'YYYY-MM-DD'), 
--                            TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'YYMMDD')) / 12) AS "입학 나이"
--FROM TB_STUDENT
--WHERE FLOOR(MONTHS_BETWEEN(TO_DATE(SUBSTR(STUDENT_NO, 1, 4) || '-03-01', 'YYYY-MM-DD'), 
--                            TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'YYMMDD')) / 12) > 19;


---6. 2020년 크리스마스는 무슨 요일인가? 
SELECT TO_CHAR(TO_DATE('2020-12-25', 'YYYY-MM--DD'), 'DAY') AS "요일"
FROM DUAL;


---- 7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD')  은 각각 몇 년 몇 월 몇 일을 의미할까? 
-- 또 TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미할까? 
SELECT TO_DATE('99/10/11','YY/MM/DD') AS "년/월/일", 
       TO_DATE('49/10/11','YY/MM/DD') AS "년/월/일",
       TO_DATE('99/10/11','RR/MM/DD') AS "년/월/일",
       TO_DATE('49/10/11','RR/MM/DD') AS "년/월/일"
FROM DUAL;

-- SELECT TO_DATE('99/10/11', 'YY/MM/DD') AS "YY/MM/DD 형식(99)",
--       TO_DATE('49/10/11', 'YY/MM/DD') AS "YY/MM/DD 형식(49)",
--       TO_DATE('99/10/11', 'RR/MM/DD') AS "RR/MM/DD 형식(99)",
--       TO_DATE('49/10/11', 'RR/MM/DD') AS "RR/MM/DD 형식(49)"
--FROM DUAL;
 

----8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다. 
-- 2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.
-- ENTRANCE_DATE = 입학년도 
SELECT * FROM TB_STUDENT;
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO != 'A%';

--SELECT * FROM TB_STUDENT;
--SELECT STUDENT_NO, STUDENT_NAME
--FROM TB_STUDENT
--WHERE ENTRANCE_DATE >;


---- 9. 학번이 A517178 인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 
--단, 이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시힌다.
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_GRADE;

SELECT ROUND(POINT, 1)  AS "평점"
FROM TB_GRADE
JOIN TB_STUDENT USING (STUDENT_NO)
WHERE STUDENT_NO = 'A517178';

-- 행이 1개만 나와야 하는데...
--SELECT TB_GRADE, AVG(POINT) AS "평점"
--FROM TB_GRADE
--JOIN TB_STUDENT USING (STUDENT_NO)
--WHERE STUDENT_NO = 'A517178';


-- 10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 만들어 결과값이 출력되도록 하시오.
-- ㄴ 학과별이니까 GROUP BY 사용
-- DEPARTMENT_NO = 학과번호, STUDENT_NO = 학번 OR STUDENT_NAME 으로 해당 학과 소속된 학생 추출
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;

SELECT DEPARTMENT_NO "학과번호", COUNT(STUDENT_NO) "학생수(명)"
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING (DEPARTMENT_NO)
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO ASC;


-- 11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는 알아내는 SQL 문을 작성하시오.
-- 지도 교수 배정 COACH_PROFESSOR_NO
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;


--12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 
--단, 이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시한다.
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_GRADE; -- TERM_NO 학기 번호

--SELECT
--FROM
--WHERE STUDENT_NO = 'A112113'

----13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오. 
--          ㄴ 학과별이니까 GROUP BY 사용, 
-- DEPARTMENT_NO = 학과번호, 휴학한 사람 ABSENCE_YN 'Y' // 서브쿼리 써야하나???

SELECT DEPARTMENT_NO "학과코드명", COUNT(ABSENCE_YN) "휴학생 수"
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING (DEPARTMENT_NO)
GROUP BY DEPARTMENT_NO
HAVING ABSENCE_YN = 'Y'
ORDER BY DEPARTMENT_NO ASC;


--SELECT DEPARTMENT_NO "학과코드명", COUNT(ABSENCE_YN) "휴학생 수"
--FROM TB_DEPARTMENT
--JOIN TB_STUDENT USING (DEPARTMENT_NO)
--GROUP BY DEPARTMENT_NO
--HAVING ABSENCE_YN = 'Y'
--ORDER BY DEPARTMENT_NO ASC;


--14.  춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 한다. 
--어떤 SQL 문장을 사용하면 가능하겠는가?

--SELECT STUDENT_NAME AS "동일이름" COUNT(STUDENT_NAME) AS "동명인 수"
--FROM TB_STUDENT
--WHERE STUDENT_NAME = STUDENT_NAME;



--15. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총 평점을 구하는 SQL 문을 작성하시오. 
--(단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)




-----[Additional SELECT - Option] page 13 ~ 21

--1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 이름으로 오름차순 표시하도록 한다. 
SELECT * FROM TB_STUDENT;

SELECT STUDENT_NAME AS "학생이름", STUDENT_ADDRESS AS "주소지"
FROM TB_STUDENT
ORDER BY STUDENT_NAME ASC;

--2.  휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY STUDENT_SSN DESC;

--3. 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번, 주소를
--이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 "학생이름","학번","거주지 주소" 가 출력되도록 한다. 
SELECT STUDENT_NAME "학생이름", STUDENT_NO "학번", STUDENT_ADDRESS "거주지 주소"
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '%강원도%' OR STUDENT_ADDRESS LIKE '%경기도%' AND STUDENT_NO LIKE '9%' 
ORDER BY STUDENT_NAME ASC;

--4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을 작성하시오. --
--(법학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아내도록 하자) 
SELECT * FROM TB_PROFESSOR;
SELECT * FROM TB_DEPARTMENT;

SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '법학과'
ORDER BY PROFESSOR_SSN ASC;


----5. 2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 
--학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오. 
SELECT * FROM TB_GRADE;
SELECT * FROM TB_CLASS;
SELECT * FROM TB_STUDENT;

SELECT STUDENT_NO,POINT
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_CLASS USING(DEPARTMENT_NO)
WHERE CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO ASC;

--SELECT STUDENT_NO, POINT
--FROM TB_GRADE
--WHERE CLASS_NO = 'C3118100' AND SEMESTER = '2학기' AND YEAR = 2004
--ORDER BY POINT DESC, STUDENT_NO ASC;


--6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL 문을 작성하시오. 
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;

SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME ASC;

--7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
SELECT * FROM TB_CLASS;
SELECT * FROM TB_DEPARTMENT;

SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);

----8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오. 
SELECT * FROM TB_CLASS;
SELECT * FROM TB_PROFESSOR;

--SELECT CLASS_NAME, PROFESSOR_NAME
--FROM TB_CLASS
--JOIN TB_PROFESSOR USING(DEPARTMENT_NO)
--GROUP BY CLASS_NAME;

SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_PROFESSOR USING (DEPARTMENT_NO);


SELECT CLASS_NAME, PROFESSOR_NAME
FROM (
    SELECT CLASS_NAME, PROFESSOR_NAME,
           ROW_NUMBER() OVER (PARTITION BY CLASS_NAME ORDER BY PROFESSOR_NAME) AS rn
    FROM TB_CLASS C
    JOIN TB_PROFESSOR P ON C.DEPARTMENT_NO = P.DEPARTMENT_NO)
WHERE rn = 1
ORDER BY CLASS_NAME;


--9. 8번의 결과 중 ‘인문사회’ 계열에 속한 과목의 교수 이름을 찾으려고 한다. 
--이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오. 



--10. ‘음악학과’ 학생들의 평점을 구하려고 한다. 
--음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 SQL 문장을 작성하시오.
--(단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;
SELECT * FROM TB_GRADE;

SELECT STUDENT_NO, STUDENT_NAME, POINT --ROUND(AVG(POINT),1)
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_GRADE USING(STUDENT_NO)
WHERE DEPARTMENT_NAME = '음악학과';


--11. 학번이 A313047인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 
--이때 사용할 SQL 문을 작성하시오.  단, 출력헤더는 ?학과이름?, ?학생이름?, ?지도교수이름?으로 출력되도록 한다. 
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;
SELECT * FROM TB_PROFESSOR;

SELECT DEPARTMENT_NAME AS "학과이름", STUDENT_NAME AS "학생이름", PROFESSOR_NAME "지도교수이름";


--12. 2007 년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기를 표시하는 SQL 문장을 작성하시오. 


--13. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 그 과목 이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.


--14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 
--학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 "지도교수 미지정?으로 표시하도록 하는 SQL 문을 작성하시오. 
--단,  출력헤더는 ?학생이름?, ?지도교수?로 표시하며 고학번 학생이 먼저 표시되도록 한다. 


--15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과 이름, 평점을 출력하는 SQL 문을 작성하시오.  


--16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.


--17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL 문을 작성하시오. 


--18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL문을 작성하시오. 


--19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 파악하기 위한 적절한 SQL 문을 찾아내시오.
--단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록 한다.



--[DDL] 
--1. 계열 정보를 저장할 카테고리 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
-- 테이블 이름 
-- TB_CATEGORY 
--컬럼 
--NAME, VARCHAR2(10)  
--USE_YN, CHAR(1), 기본값은 Y 가 들어가도록

CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y' CHECK(USE_YN IN ('N', 'Y'))
);

SELECT * FROM TB_CATEGORY;

--2. 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
--테이블이름 
--TB_CLASS_TYPE 
--컬럼 
--NO, VARCHAR2(5), PRIMARY KEY 
--NAME , VARCHAR2(10)  

CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10)
);

SELECT * FROM TB_CLASS_TYPE;

--3. TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY를 생성하시오. 
--(KEY 이름을 생성하지 않아도 무방함. 만일 KEY 이를 지정하고자 한다면 이름은 본인이 알아서 적당한 이름을 사용한다.)

DROP TABLE TB_CATEGORY;

CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10) CONSTRAINT CATEGORY_PK PRIMARY KEY,
    USE_YN CHAR(1) DEFAULT 'Y' CHECK(USE_YN IN ('N', 'Y'))
);

SELECT * FROM TB_CATEGORY;

--4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.

DROP TABLE TB_CLASS_TYPE;

CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10) CONSTRAINT CLASSTYPE_NN_NAME NOT NULL 
);

SELECT * FROM TB_CLASS_TYPE;

-- 5. 두 테이블에서 컬럼 명이 NO인 것은 기존 타입을 유지하면서 크기는 10 으로, 
--컬럼명이 NAME 인 것은 마찬가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오.
