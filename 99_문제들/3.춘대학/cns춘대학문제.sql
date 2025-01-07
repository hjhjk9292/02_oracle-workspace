----------------------------- [Basic SELECT] 완료  ----------------------------- 

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



---------------------- [Additional SELECT - 함수] 5번, 7-9번, 12번 부터~~  ----------------------------- 

--1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른 순으로 표시하는 SQL 문장을 작성하시오.
--( 단, 헤더는 "학번", "이름", "입학년도" 가 표시되도록 한다.)
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_CLASS;

SELECT
    STUDENT_NO AS "학번",
    STUDENT_NAME AS "이름",
    TO_CHAR(ENTRANCE_DATE,'RRRR-MM-DD') AS "입학년도"
FROM TB_STUDENT
WHERE DEPARTMENT_NO = 002
ORDER BY ENTRANCE_DATE;

--2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 한 명 있다고 한다. 그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자. 
--(* 이때 올바르게 작성한 SQL 문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것) 
SELECT * FROM TB_CLASS_PROFESSOR;
SELECT * FROM TB_PROFESSOR;

SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) != 3 ;

SELECT
    PROFESSOR_NAME,
    PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';

--3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 단 이때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 만드시오. 
--(단, 교수 중 2000 년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 한다. 나이는 ‘만’으로 계산한다.)
SELECT PROFESSOR_NAME AS 교수이름, 
        (EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(PROFESSOR_SSN, 1, 2)))) AS 나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8,1)IN('1','3')
ORDER BY 나이 ASC;

SELECT 
    PROFESSOR_NAME AS "교수이름", 
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE('19'||SUBSTR(PROFESSOR_SSN,1,6))) AS "나이"
FROM TB_PROFESSOR
ORDER BY 2;


--4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 
--출력 헤더는 ?이름? 이 찍히도록 한다. (성이 2자인 경우는 교수는 없다고 가정하시오)
SELECT SUBSTR(PROFESSOR_NAME, 2,2) AS 이름
FROM TB_PROFESSOR;

SELECT 
    SUBSTR(PROFESSOR_NAME,2,LENGTH(PROFESSOR_NAME)-1) AS "이름 "
FROM TB_PROFESSOR;


---- 5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가?  
-- 이때, 19살에 입학하면 재수를 하지 않은 것으로 간주한다.

SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN,1,6))) > 19;

--SELECT STUDENT_NAME AS "학생 이름",
--       STUDENT_NO AS "학번",
--       FLOOR(MONTHS_BETWEEN(TO_DATE(SUBSTR(STUDENT_NO, 1, 4) || '-03-01', 'YYYY-MM-DD'), 
--                            TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'YYMMDD')) / 12) AS "입학 나이"
--FROM TB_STUDENT
--WHERE FLOOR(MONTHS_BETWEEN(TO_DATE(SUBSTR(STUDENT_NO, 1, 4) || '-03-01', 'YYYY-MM-DD'), 
--                            TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'YYMMDD')) / 12) > 19;  -- 오답

---6. 2020년 크리스마스는 무슨 요일인가? 
SELECT TO_CHAR(TO_DATE('2020-12-25', 'YYYY-MM--DD'), 'DAY') AS "요일"
FROM DUAL;


---- 7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD')  은 각각 몇 년 몇 월 몇 일을 의미할까? 
-- 또 TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미할까? 
SELECT TO_DATE('99/10/11','YY/MM/DD') FROM DUAL; -- 2099/10/11
SELECT TO_DATE('49/10/11','YY/MM/DD') FROM DUAL; -- 2049/10/11
SELECT TO_DATE('99/10/11','RR/MM/DD') FROM DUAL; -- 1999/10/11
SELECT TO_DATE('49/10/11','RR/MM/DD') FROM DUAL; -- 2049/10/11
-- RR : 해당 두 자리 년도 값이 50 미만일 경우, 현재 세기를 반영
--                              이상일 경우, 이전 세기를 반영
 

----8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다. 
-- 2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.
-- ENTRANCE_DATE = 입학년도 
SELECT
    STUDENT_NO,
    STUDENT_NAME
FROM TB_STUDENT
WHERE SUBSTR(ENTRANCE_DATE,1,2) >= 49;

SELECT
    STUDENT_NO,
    STUDENT_NAME
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_NO,1,1) <> 'A';


---- 9. 학번이 A517178 인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 
--단, 이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시힌다.

--SELECT ROUND(POINT, 1)  AS "평점"
--FROM TB_GRADE
--JOIN TB_STUDENT USING (STUDENT_NO)
--WHERE STUDENT_NO = 'A517178';  -- 오답

SELECT
    ROUND(AVG(POINT),1) AS "평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';


---- 10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 만들어 결과값이 출력되도록 하시오.
-- ㄴ 학과별이니까 GROUP BY 사용
-- DEPARTMENT_NO = 학과번호, STUDENT_NO = 학번 OR STUDENT_NAME 으로 해당 학과 소속된 학생 추출
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;

SELECT DEPARTMENT_NO "학과번호", COUNT(STUDENT_NO) "학생수(명)"
FROM TB_STUDENT
--JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO ASC;


-- 11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는 알아내는 SQL 문을 작성하시오.
-- 지도 교수 배정 COACH_PROFESSOR_NO
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;


----12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 
--단, 이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시한다.
SELECT
    DISTINCT TO_CHAR(SUBSTR(TERM_NO,1,4)) AS "년도",
    ROUND(AVG(POINT),1) AS "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY TO_CHAR(SUBSTR(TERM_NO,1,4))
ORDER BY 1;

---- 13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오. 
--          ㄴ 학과별이니까 GROUP BY 사용, 
-- DEPARTMENT_NO = 학과번호, 휴학한 사람 ABSENCE_YN 'Y' // 서브쿼리 써야하나??? ㅡx , decode  사용

SELECT
    DEPARTMENT_NO AS "학과코드명",
    COUNT(DECODE(ABSENCE_YN,'Y',1)) AS "휴학생 수"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 1;

--SELECT DEPARTMENT_NO "학과코드명", COUNT(ABSENCE_YN) "휴학생 수"
--FROM TB_DEPARTMENT
--JOIN TB_STUDENT USING (DEPARTMENT_NO)
--GROUP BY DEPARTMENT_NO
--HAVING ABSENCE_YN = 'Y'
--ORDER BY DEPARTMENT_NO ASC;  -- 오답

---- 14.  춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 한다. 
--어떤 SQL 문장을 사용하면 가능하겠는가?
SELECT
    STUDENT_NAME AS "동일이름",
    COUNT(*) AS "동명인 수"
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(*) > 1
ORDER BY 1;

---- 15. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총 평점을 구하는 SQL 문을 작성하시오. 
--(단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)
SELECT
    NVL(SUBSTR(TERM_NO,1,4),' ') AS "년도",
    NVL(SUBSTR(TERM_NO,5,2),' ') AS "학기",
    ROUND(AVG(POINT),1) AS "평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO,1,4), SUBSTR(TERM_NO,5,2));


----------------------------- [Additional SELECT - Option] page 13 ~ 21 / 9번, 10번 ~~ (12번은 더 쉽게 푸는 법 없을까)

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
--ORDER BY POINT DESC, STUDENT_NO ASC;  -- 오답


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
SELECT
    CLASS_NAME,
    PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO);

--SELECT CLASS_NAME, PROFESSOR_NAME
--FROM TB_CLASS
--JOIN TB_PROFESSOR USING (DEPARTMENT_NO); -- 오답


--SELECT CLASS_NAME, PROFESSOR_NAME
--FROM (
--    SELECT CLASS_NAME, PROFESSOR_NAME,
--           ROW_NUMBER() OVER (PARTITION BY CLASS_NAME ORDER BY PROFESSOR_NAME) AS rn
--    FROM TB_CLASS C
--    JOIN TB_PROFESSOR P ON C.DEPARTMENT_NO = P.DEPARTMENT_NO)
--WHERE rn = 1
--ORDER BY CLASS_NAME;  -- 오답


----9. 8번의 결과 중 ‘인문사회’ 계열에 속한 과목의 교수 이름을 찾으려고 한다. 
--이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오. 
SELECT
    CLASS_NAME,
    PROFESSOR_NAME
FROM TB_CLASS C
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON(C.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE CATEGORY = '인문사회';


----10. ‘음악학과’ 학생들의 평점을 구하려고 한다. 
--음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 SQL 문장을 작성하시오.
--(단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;
SELECT * FROM TB_GRADE;

SELECT
    STUDENT_NO AS "학번",
    STUDENT_NAME AS "학생 이름",
    ROUND(AVG(POINT),1) AS "전체 평점"
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '음악학과'
GROUP BY (STUDENT_NO, STUDENT_NAME)
ORDER BY 1;

--SELECT STUDENT_NO, STUDENT_NAME, ROUND(AVG(POINT),1)
--FROM TB_STUDENT
--JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
--JOIN TB_GRADE USING(STUDENT_NO)
--WHERE DEPARTMENT_NAME = '음악학과'; --오답


----11. 학번이 A313047인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 
--이때 사용할 SQL 문을 작성하시오.  단, 출력헤더는 ?학과이름?, ?학생이름?, ?지도교수이름?으로 출력되도록 한다. 
--SELECT DEPARTMENT_NAME AS "학과이름", STUDENT_NAME AS "학생이름", PROFESSOR_NAME "지도교수이름";
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;
SELECT * FROM TB_PROFESSOR;

SELECT
    DEPARTMENT_NAME AS "학과이름",
    STUDENT_NAME AS "학생이름",
    PROFESSOR_NAME AS "지도교수이름"
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_PROFESSOR ON(COACH_PROFESSOR_NO=PROFESSOR_NO)
WHERE STUDENT_NO = 'A313047';


----12. 2007 년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기를 표시하는 SQL 문장을 작성하시오. 
SELECT * FROM TB_CLASS
WHERE CLASS_NAME = '인간관계론';

SELECT * FROM TB_GRADE
WHERE TERM_NO LIKE '2007%' AND CLASS_NO = 'C2604100';

SELECT STUDENT_NAME, TERM_NO
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
WHERE TERM_NO LIKE '2007%' AND CLASS_NO = 'C2604100'; --답은 같게 나온다..

SELECT
    STUDENT_NAME,
    TERM_NO AS "TERM_NAME"
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_CLASS USING(CLASS_NO)
WHERE SUBSTR(TERM_NO,1,4) = 2007 AND CLASS_NAME = '인간관계론'; --정답


----13. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 그 과목 이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.
SELECT * FROM TB_DEPARTMENT
WHERE CATEGORY = '예체능'; -- DEPARMENT_NO = 056 ~063
SELECT * FROM TB_CLASS; -- DEPARTMENT_NO
SELECT * FROM TB_CLASS_PROFESSOR; -- PROFESSOR_NO

SELECT
    CLASS_NAME,
    DEPARTMENT_NAME
FROM TB_CLASS C, TB_CLASS_PROFESSOR CP,TB_DEPARTMENT D
WHERE 
    C.CLASS_NO = CP.CLASS_NO
    AND C.DEPARTMENT_NO = D.DEPARTMENT_NO
    AND PROFESSOR_NO IS NULL
    AND CATEGORY = '예체능';


----14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 
--학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 "지도교수 미지정?으로 표시하도록 하는 SQL 문을 작성하시오. 
--단,  출력헤더는 ?학생이름?, ?지도교수?로 표시하며 고학번 학생이 먼저 표시되도록 한다. 
SELECT
    STUDENT_NAME AS "학생이름",
    NVL(PROFESSOR_NAME,'지도교수 미지정') AS "지도교수"
FROM TB_STUDENT S, TB_DEPARTMENT D, TB_PROFESSOR P
WHERE
    S.DEPARTMENT_NO = D.DEPARTMENT_NO
    AND S.COACH_PROFESSOR_NO = P.PROFESSOR_NO(+)
    AND DEPARTMENT_NAME = '서반아어학과';

----15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과 이름, 평점을 출력하는 SQL 문을 작성하시오.  
SELECT
    S.STUDENT_NO AS "학번",
    STUDENT_NAME AS "이름",
    DEPARTMENT_NAME AS "학과 이름",
    ROUND(AVG(POINT),5) AS "평점"
FROM TB_STUDENT S, TB_DEPARTMENT D, TB_GRADE G
WHERE 
    ABSENCE_YN = 'N'
    AND S.DEPARTMENT_NO = D.DEPARTMENT_NO
    AND S.STUDENT_NO = G.STUDENT_NO
GROUP BY (S.STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME)
HAVING AVG(POINT) >= 4.0;

----16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.
SELECT
    C.CLASS_NO,
    CLASS_NAME,
    ROUND(AVG(POINT),8) AS "AVG(POINT)"
FROM TB_CLASS C, TB_GRADE G, TB_DEPARTMENT D
WHERE 
    D.DEPARTMENT_NO = C.DEPARTMENT_NO
    AND G.CLASS_NO = C.CLASS_NO
    AND D.DEPARTMENT_NAME = '환경조경학과'
    AND CLASS_TYPE LIKE '전공%'
GROUP BY (C.CLASS_NO, CLASS_NAME)
ORDER BY 1;

----17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL 문을 작성하시오. --서브쿼리
SELECT
    STUDENT_NAME,
    STUDENT_ADDRESS
FROM TB_STUDENT
WHERE 
    DEPARTMENT_NO = (SELECT DEPARTMENT_NO 
                       FROM TB_STUDENT 
                      WHERE STUDENT_NAME = '최경희');

----18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL문을 작성하시오. --서브쿼리
SELECT STUDENT_NO, STUDENT_NAME
FROM (
    SELECT
        S.STUDENT_NO,
        STUDENT_NAME
    FROM TB_STUDENT S, TB_DEPARTMENT D, TB_GRADE G
    WHERE 
        S.DEPARTMENT_NO = D.DEPARTMENT_NO
        AND D.DEPARTMENT_NAME = '국어국문학과'
        AND S.STUDENT_NO = G.STUDENT_NO
    GROUP BY S.STUDENT_NO, STUDENT_NAME
    ORDER BY AVG(POINT) DESC
    )
WHERE ROWNUM = 1;

----19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 파악하기 위한 적절한 SQL 문을 찾아내시오.
--단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록 한다.
SELECT * FROM TB_DEPARTMENT;
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_GRADE;

SELECT DEPARTMENT_NAME AS "계열 학과명", ROUND(AVG(POINT),1) AS "전공평점"
FROM TB_DEPARTMENT D, TB_GRADE G, TB_STUDENT S
WHERE CATEGORY = 
        (
        SELECT CATEGORY
        FROM TB_DEPARTMENT
        WHERE DEPARTMENT_NAME = '환경조경학과'
        ) 
    AND D.DEPARTMENT_NO = S.DEPARTMENT_NO
    AND S.STUDENT_NO = G.STUDENT_NO
GROUP BY DEPARTMENT_NAME
ORDER BY 1;


---------------------------------- [DDL] ------------------------------------ 10~14. view문제
--1. 계열 정보를 저장할 카테고리 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
-- 테이블 이름 
-- TB_CATEGORY 
--컬럼 
--NAME, VARCHAR2(10)  
--USE_YN, CHAR(1), 기본값은 Y 가 들어가도록

CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);

SELECT * FROM TB_CATEGORY;

--2. 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
--테이블이름 
--TB_CLASS_TYPE 
--컬럼 
--NO, VARCHAR2(5), PRIMARY KEY 
--NAME , VARCHAR2(10)  

DROP TABLE TB_CLASS_TYPE;
SELECT * FROM TB_CLASS_TYPE;

CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10)
);

CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5),
    NAME VARCHAR2(10),
    PRIMARY KEY(NO)
);

--3. TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY를 생성하시오. 
--(KEY 이름을 생성하지 않아도 무방함. 만일 KEY 이를 지정하고자 한다면 이름은 본인이 알아서 적당한 이름을 사용한다.)
DROP TABLE TB_CATEGORY;
SELECT * FROM TB_CATEGORY;

ALTER TABLE TB_CATEGORY ADD CONSTRAINT NAME_PK PRIMARY KEY(NAME);

--4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.
ALTER TABLE TB_CLASS_TYPE MODIFY NAME NOT NULL;

-- 5. 두 테이블에서 컬럼 명이 NO인 것은 기존 타입을 유지하면서 크기는 10 으로, 
--컬럼명이 NAME 인 것은 마찬가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오.
ALTER TABLE TB_CATEGORY 
    MODIFY NAME VARCHAR2(20);
    
ALTER TABLE TB_CLASS_TYPE
    MODIFY NO VARCHAR2(10)
    MODIFY NAME VARCHAR2(20);

--6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_ 를 제외한 테이블 이름이 앞에 
--붙은 형태로 변경한다. (ex. CATEGORY_NAME) 

ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;

ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;

--7. TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경하시오. 
--Primary Key 의 이름은 "PK_ + 컬럼이름"으로 지정하시오. (ex. PK_CATEGORY_NAME ) 
ALTER TABLE TB_CATEGORY RENAME CONSTRAINT NAME_PK TO PK_CATEGORY_NAME;
--ALTER TABLE TB_CLASS_TYPE RENAME CONSTRAINT SYS_C007215 TO PK_CLASS_TYPE_NO;

SELECT * FROM TB_CLASS_TYPE;
SELECT * FROM TB_CATEGORY;

--8. 다음과 같은INSERT 문을 수행한다. 
--INSERT INTO TB_CATEGORY VALUES ('공학','Y'); 
--INSERT INTO TB_CATEGORY VALUES ('자연과학','Y'); 
--INSERT INTO TB_CATEGORY VALUES ('의학','Y'); 
--INSERT INTO TB_CATEGORY VALUES ('예체능','Y'); 
--INSERT INTO TB_CATEGORY VALUES ('인문사회','Y'); 
--COMMIT;  

INSERT INTO TB_CATEGORY VALUES ('공학','Y'); 
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y'); 
INSERT INTO TB_CATEGORY VALUES ('의학','Y'); 
INSERT INTO TB_CATEGORY VALUES ('예체능','Y'); 
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y'); 
COMMIT;

SELECT * FROM TB_CATEGORY;

----9.TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모값으로 참조하도록 FOREIGN KEY를 지정하시오. 
-- 이 때 KEY 이름은 FK_테이블이름_컬럼이름으로 지정한다. (ex. FK_DEPARTMENT_CATEGORY ) 
SELECT * FROM TB_DEPARTMENT;

ALTER TABLE TB_DEPARTMENT ADD CONSTRAINT FK_DEPARTMENT_CATEGORY 
FOREIGN KEY(CATEGORY) REFERENCES TB_CATEGORY(CATEGORY_NAME);

SELECT * FROM TB_CATEGORY;
SELECT * FROM TB_CLASS_TYPE;
SELECT * FROM TB_DEPARTMENT;


--10. 춘 기술대학교 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW를 만들고자 한다. 
--아래 내용을 참고하여 적절한 SQL 문을 작성하시오.
SELECT * FROM TB_STUDENT;

--뷰 이름 : VW_학생일반정보 
--컬럼 : 학번 학생이름 주소  

CREATE OR REPLACE VIEW VW_학생일반정보
AS SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT;

GRANT CREATE VIEW TO CNS;

SELECT * FROM VW_학생일반정보;

ROLLBACK;

--11. 춘 기술대학교는 1년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행한다. 
--이를 위해 사용할 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 VIEW 를 만드시오. 
--이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오 
--(단, 이 VIEW 는 단순 SELECT 만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.) 
SELECT * FROM TB_STUDENT;       -- DEPARTMENT_NO       학생이름 (STUDENT_NAME)
SELECT * FROM TB_DEPARTMENT;    -- DEPARTMENT_NO       학과이름 (DEPARTMENT_NAME)
SELECT * FROM TB_PROFESSOR;     -- DEPARTMENT_NO       담당교수이름(PROFESSOR_NAME)

--뷰 이름 VW_지도면담 
--컬럼 --학생이름 --학과이름 --지도교수이름

CREATE OR REPLACE VIEW VW_지도면담
AS SELECT STUDENT_NAME, DEPARTMENT_NAME, PROFESSOR_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_PROFESSOR USING(DEPARTMENT_NO);

SELECT * FROM VW_지도면담;

ROLLBACK;

--SELECT DEPARTMENT_NO "학과번호", COUNT(STUDENT_NO) "학생수(명)"
--FROM TB_STUDENT
----JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
--GROUP BY DEPARTMENT_NO
--ORDER BY DEPARTMENT_NO ASC;

----12. 모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 VIEW 를 작성해 보자. 
--뷰 이름 --VW_학과별학생수 
--컬럼 --DEPARTMENT_NAME --STUDENT_COUNT 
SELECT * FROM TB_STUDENT;       -- DEPARTMENT_NO       학생이름 (STUDENT_NAME)
SELECT * FROM TB_DEPARTMENT;


CREATE OR REPLACE VIEW VW_학과별학생수
AS SELECT DEPARTMENT_NO "학과번호", COUNT(STUDENT_NO) "학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO ASC;

SELECT * FROM VW_학과별학생수;

----13. 위에서 생성한 학생일반정보 View를 통해서 학번이 A213046인 학생의 이름을 
--본인 이름으로 변경하는 SQL 문을 작성하시오. 

UPDATE VW_학생일반정보
SET STUENT_NAME = '김현지'
WHERE STUDENT_NO = 'A213046';

SELECT * FROM VW_학생일반정보
WHERE STUDENT_NO = 'A213046'; -- 서가람

----14. 13 번에서와 같이 VIEW를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW를 
--어떻게 생성해야 하는지 작성하시오. 
CREATE OR REPLACE VIEW VW_학과별학생수
AS SELECT DEPARTMENT_NO "학과번호", COUNT(STUDENT_NO) "학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO ASC
WITH READ ONLY;

-----15. 춘 기술대학교는 매년 수강신청 기간만 되면 특정 인기 과목들에 수강 신청이 몰려 
--문제가 되고 있다. 최근 3년을 기준으로 수강인원이 가장 많았던 3 과목을 찾는 구문을 작성해보시오.
SELECT *
FROM
    (SELECT
        G.CLASS_NO AS "과목번호",
        CLASS_NAME AS "과목이름",
        COUNT(*) AS "누적수강생수(명)"
     FROM TB_GRADE G, TB_CLASS C
     WHERE C.CLASS_NO = G.CLASS_NO
           AND TERM_NO >= (SELECT MAX(TERM_NO) FROM TB_GRADE) - 402
     GROUP BY G.CLASS_NO, CLASS_NAME
     ORDER BY 3 DESC)
WHERE ROWNUM <= 3;


--------------------------------------[DML]-----------------------------------------
-- 1. 과목유형 테이블(TB_CLASS_TYPE)에 아래와 같은 데이터를 입력하시오.
--번호, 유형이름 ------------ 
--01, 전공필수 
--02, 전공선택 
--03, 교양필수 
--04, 교양선택 
--05. 논문지도  
SELECT * FROM TB_CLASS_TYPE;

INSERT INTO TB_CLASS_TYPE
VALUES(01,'전공필수');

INSERT INTO TB_CLASS_TYPE VALUES(02,'전공선택');
INSERT INTO TB_CLASS_TYPE VALUES(03,'교양필수');
INSERT INTO TB_CLASS_TYPE VALUES(04,'교양선택');
INSERT INTO TB_CLASS_TYPE VALUES(05,'논문지도');

-- 2. 춘 기술대학교 학생들의 정보가 포함되어 있는 학생일반정보 테이블을 만들고자 한다. 
-- 아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (서브쿼리를 이용하시오) 
-- 테이블이름 
--  TB_학생일반정보 
--  컬럼 
--  학번 
--  학생이름 
--  주소
CREATE TABLE TB_학생일반정보
AS SELECT STUDENT_NO AS "학번", STUDENT_NAME AS "학생이름", STUDENT_ADDRESS AS "주소"
FROM TB_STUDENT;

-- 3. 국어국문학과 학생들의 정보만이 포함되어 있는 학과정보 테이블을 만들고자 핚다. 
--아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (힌트 : 방법은 다양함, 소신껏 작성하시오) 
--테이블이름 
--  TB_국어국문학과 
--컬럼 
--   학번 
--   학생이름 
--   출생년도 <= 네자리 년도로 표기 
--   교수이름 
SELECT * FROM TB_STUDENT;

CREATE TABLE TB_국어국문학과
AS SELECT 
    STUDENT_NO AS "학번", 
    STUDENT_NAME AS "학생이름", 
    EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN,1,6),'RR/MM/DD')) AS "출생년도", 
    PROFESSOR_NAME AS "교수이름"
   FROM TB_STUDENT, TB_PROFESSOR
   WHERE COACH_PROFESSOR_NO = PROFESSOR_NO;

--4. 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용할 SQL 문을 작성하시오. 
--(단, 반올림을 사용하여 소수점 자릿수는 생기지 않도록 한다) 
SELECT * FROM TB_DEPARTMENT;

UPDATE TB_DEPARTMENT
SET CAPACITY = ROUND(CAPACITY * 1.1); -- 국어국문학과 20, 영어영문학과 36, 28, 28

ROLLBACK;

--5. 학번 A413042 인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21 "로 변경되었다고 한다.
-- 주소지를 정정하기 위해 사용할 SQL 문을 작성하시오. 
SELECT * FROM TB_STUDENT;

SELECT STUDENT_ADDRESS
FROM TB_STUDENT
WHERE STUDENT_NO = 'A413042' AND STUDENT_NAME = '박건우';

UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '서울시 종로구 숭인동 182-21'; -- 경기도 파주시 적성면 장현2리 산65번지

ROLLBACK;

--6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로 결정하였다. 
--이 내용을 반영한 적절한 SQL 문장을 작성하시오. (예. 830530-2124663 ==> 830530 )  
SELECT * FROM TB_STUDENT;

SELECT SUBSTR(STUDENT_SSN,1,6)
FROM TB_STUDENT;

UPDATE TB_STUDENT
SET STUDENT_SSN = SUBSTR(STUDENT_SSN,1,6); -- 830530-2124663

ROLLBACK;

--7. 의학과 김명훈 학생은 2005년 1학기에 자신이 수강한 '피부생리학' 점수가 잘못되었다는 것을 발견하고는 정정을 요청하였다. 
--담당 교수의 확인 받은 결과 해당 과목의 학점을 3.5로 변경키로 결정되었다. 적절한 SQL 문을 작성하시오. 

SELECT *
FROM TB_STUDENT
WHERE STUDENT_NAME = '김명훈'; -- 동명이인 DEPARTMENT_NO = 024, 053 / STUDENT_NO = A331092, A331101

SELECT * 
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME = '의학과'; -- DEPARTMENT_NO 053

SELECT *
FROM TB_GRADE -- TERM_NO = 200501
WHERE STUDENT_NO = 'A331101' AND TERM_NO = '200501' AND CLASS_NO = 'C3843900';

--SELECT * FROM TB_CLASS
--WHERE CLASS_NAME = '피부생리학'; -- DEPARTMENT_NO = 053 / CALSS_NO = C3843900

UPDATE TB_GRADE
SET POINT = 3.5
WHERE STUDENT_NO = 'A331101' AND TERM_NO = '200501'; -- 1.5

ROLLBACK; -- ㄴ 큰 일날뻔... WHERE 꼭 써주기..!! 더 쉽게 작성하는 코드 있을 거 같은데..


--8. 성적 테이블(TB_GRADE) 에서 휴학생들의 성적항목을 제거하시오.
SELECT * FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y';

SELECT *
FROM TB_GRADE
JOIN TB_STUDENT USING(STUDENT_NO)
WHERE ABSENCE_YN = 'Y';

UPDATE TB_GRADE
SET POINT = NULL
WHERE TB_GRADE.STUDENT_NO IN (SELECT STUDENT_NO 
                                FROM TB_STUDENT 
                               WHERE ABSENCE_YN = 'Y');

