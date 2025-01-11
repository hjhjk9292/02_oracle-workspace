/*
 H 학우들 데이터베이스 
*/
SELECT * FROM TBL_BUY; --   CUSTOMID    PCODE     QUANTITY    BUY_DATE  BUY_IDX
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID        NAME    EMAIL          REG_DATE
SELECT * FROM TBL_PRODUCT;--            PCODE   CATEGORY  PNAME   RRICE

-- (간성훈)							
-- 1. 2023년 동안 구매한 고객들 중에서, 각 고객이 구매한 상품의 평균 구매 금액이 20,000원 이상인 고객들의 고객 ID와 이름을 조회하시오.							
SELECT CUSTOM_ID, NAME, SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE TO_CHAR(BUY_DATE, 'YYYY') = '2023'
GROUP BY CUSTOM_ID, NAME
HAVING AVG(PRICE) >= 20000;


-- 2. "2023년 하반기  동안 '입'이라는 단어가 포함된 상품을 구매한 고객들의 이름, 나이, 이메일을 조회하시오.
--단, 한 고객이 구매한 여러 상품에 대해 구매 수량의 합을 구하고, 구매 수량이 많은 순으로 정렬하시오."							
SELECT NAME, EMAIL
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE TO_CHAR(BUY_DATE, 'YYYY') = '2023'
  AND TO_CHAR(BUY_DATE, 'MM') BETWEEN '07' AND '12'
  AND PNAME LIKE '%입%'
GROUP BY NAME, EMAIL
ORDER BY SUM(QUANTITY) DESC;


-- (고영훈)
-- 3. 1)DATA_TYPE이 CHAR(2)인 CATEGORY_ID와 DATA_TYPE이 VARCHAR2(20)인 CATEGORY_NAME을 갖고있는 TBL_CATEGORY라는 테이블을 만들어라
-- 이때 CATEGORY_ID를 PRIMARY KEY로 만들고 제약조건명을 CATEGORY_PK로 만들고,
-- CATEGORY_ID의 COMMENT를 CATEGORY_ID로, CATEGORY_NAME의 COMMENT를 CATRGORY_NAME로 만들고,
-- 테이블에 ('A1', '과일') 데이터와 ('B1', '기타') 데이터를 넣어라"
-- (제 문제는 맨 마지막에 푸세요!! 카테고리 데이터값 변경해서 다른 분들 문제의 답과 다르게 나올 수 있습니다,,,)

CREATE TABLE TBL_CATEGORY (
    CATEGORY_ID CHAR(2),
    CATEGORY_NAME VARCHAR2(20),
    CONSTRAINT CATEGORY_PK PRIMARY KEY (CATEGORY_ID)
);

COMMENT ON COLUMN TBL_CATEGORY.CATEGORY_ID IS 'CATEGORY_ID';
COMMENT ON COLUMN TBL_CATEGORY.CATEGORY_NAME IS 'CATEGORY_NAME';

INSERT INTO TBL_CATEGORY (CATEGORY_ID, CATEGORY_NAME) VALUES ('A1', '과일');
INSERT INTO TBL_CATEGORY (CATEGORY_ID, CATEGORY_NAME) VALUES ('B1', '기타');

-- 4.-- 2_1)과일들의 종류를 A1으로 변경하고, 그 외의 것들은 B1으로 변경하여라
-- 2_2)TBL_PRODUCT의 CATEGORY를 TBL_CATEGORY에 CATEGORY_ID를 참조하는 외래키로 만들고 
-- 데이터 삭제시 자식 데이터도 삭제되게 하여라 (이때 제약조건명은 CATEGOTY_ID_FK로 하여라)"							

UPDATE TBL_PRODUCT
SET CATEGORY = CASE 
                  WHEN CATEGORY LIKE '%과일%' THEN 'A1' 
                  ELSE 'B1' 
               END;


ALTER TABLE TBL_PRODUCT
ADD CONSTRAINT CATEGORY_ID_FK FOREIGN KEY (CATEGORY)
REFERENCES TBL_CATEGORY (CATEGORY_ID)
ON DELETE CASCADE;

SELECT * FROM TBL_PRODUCT;

ROLLBACK;

-- (김준서)
-- 5. "CATEGORY 데이터에 'B' 포함되어 있는 물품을 구매한 회원들의 이름, 구매 물품 이름과 구매물품의 총 가격 조회하시오.
--(회원이름으로 오름 차순 정렬, 총 가격은 '총 구매금액'으로 별칭 지정)"

SELECT AGE, 
    CASE 
        WHEN GROUPING(PNAME) = 1 THEN '가장 비싼 상품의 가격' 
        ELSE PNAME 
    END AS "상품이름",
    MAX(PRICE) AS "상품가격"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
GROUP BY ROLLUP(AGE, PNAME)
ORDER BY 1;

--- 6. "회원들의 각 나이 별로 구매한 상품들과 그 상품들 중 가장 가격이 높은 상품을 조회할려고 한다. 
-- 나이, 상품이름, 나이 별 가장 비싼 상품 가격을 조회하시오.
--(중간 집계와 총 집계에서 상품 이름에 '가장 비싼 상품의 가격' 문구가 출력되도록 작성, 나이 기준으로 오름차순 정렬)"							

SELECT AGE, PNAME AS "상품이름" , MAX(PRICE) AS "상품가격" 
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
GROUP BY AGE, PNAME, ROLLUP(PRICE)
ORDER BY 1;


-- (김현지)
--문제7. 오늘 날짜 기준으로 가입일이 2년 이상됐으며 최근 1년 내 총 구매금액이 5만원 이상인 고객에게 이벤트를 진행하려고 한다. 
--해당하는 고객의 아이디, 이름, 총 구매금액을 조회하시오.

SELECT CUSTOM_ID, NAME, SUM(PRICE * QUANTITY) AS "총 구매금액"
FROM TBL_CUSTOM
JOIN TBL_BUY ON (CUSTOM_ID = CUSTOMID)
JOIN TBL_PRODUCT USING(PCODE)
WHERE ADD_MONTHS(REG_DATE, 24) <= SYSDATE -- 가입일이 2년 이상
  AND BUY_DATE >= ADD_MONTHS(SYSDATE, -12) -- 최근 1년 내
GROUP BY CUSTOM_ID, NAME
HAVING SUM(PRICE * QUANTITY) >= 50000; -- 총 구매금액 5만 이상


SELECT C.CUSTOM_ID, C.NAME, SUM(P.PRICE * B.QUANTITY) AS "총 구매금액"
FROM TBL_CUSTOM C
JOIN TBL_BUY B ON C.CUSTOM_ID = B.CUSTOMID
JOIN TBL_PRODUCT P ON B.PCODE = P.PCODE
WHERE ADD_MONTHS(C.REG_DATE, 24) <= TO_DATE('2025-01-08', 'YYYY-MM-DD') -- 가입일이 2년 이상
  AND B.BUY_DATE >= ADD_MONTHS(TO_DATE('2025-01-08', 'YYYY-MM-DD'), -12) -- 최근 1년 내
GROUP BY C.CUSTOM_ID, C.NAME
HAVING SUM(P.PRICE * B.QUANTITY) >= 50000; -- 총 구매 금액 5만 이상


-- 8. 2023년과 2024년도별로 판매된 상품의 이름과 상품구매수량과 해당 상품을 구매한 고객 수를 조회하시오. 
-- 출력 결과는 년도는 오름차순으로 정렬하고, 상품구매수량과 구매한 고객 수는 내림차순으로 정렬한다.

SELECT TO_CHAR(BUY_DATE, 'YYYY') AS YEAR, 
       PNAME, 
       COUNT(QUANTITY) AS "상품구매수량", 
       COUNT(CUSTOMID) AS "구매한 고객 수"
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
WHERE TO_CHAR(BUY_DATE, 'YYYY') IN ('2023', '2024')
GROUP BY TO_CHAR(BUY_DATE, 'YYYY'), PNAME
ORDER BY YEAR ASC, "상품구매수량" DESC, "구매한 고객 수" DESC;


-- (서동진)				
--- 9. 이름이 김미나인 사람이 구매한 물품중에 두번째로 많은 것의 상품코드, 상품명, 가격, 수량
-- 만약 동순위 존재 시 둘다 출력 RANK()OVER를 쓰세여"

SELECT PCODE, PNAME, PRICE, QUANTITY
FROM (
    SELECT PCODE, PNAME, PRICE, QUANTITY,
           RANK() OVER (PARTITION BY NAME ORDER BY QUANTITY DESC) AS RANKING
    FROM TBL_BUY
    JOIN TBL_PRODUCT USING(PCODE)
    JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
    WHERE NAME = '김미나'
)
WHERE RANKING = 2;

                        	
--- 10. 상품 코드 별 연도별 매출액(BUY_DATE)의 합계를 구하시오
--ROLL UP 사용 / UNION ALL 사용 
--UNION ALL귀찮으면 그냥 ROLLUP만 쓰세요"	

SELECT PCODE, BUY_DATE, SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
GROUP BY ROLLUP(PCODE, BUY_DATE);


-- (손희찬)
-- 11. 각 카테고리별로 가장 가격이 저렴한 제품들의 제품 코드와 해당 카테고리 이름을 구하는 SQL 쿼리
SELECT CATEGORY, PCODE, MIN(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
GROUP BY CATEGORY, PCODE;


/* 문제 12. "총 구매 금액에 따라 회원 등급은 다음과 같이 분류됩니다:

5만 원 미만: 일반 회원
5만 원 이상 10만원 미만: 우수 회원
10만 원 이상: 최우수 회원
또한, 구매 연도에 따른 할인율은 다음과 같이 적용됩니다:

2022년 구매: 10% 할인
2023년 구매: 20% 할인
2024년 구매: 30% 할인
그 외 년도 구매: 정가
위 기준을 기반으로 회원아이디 총 구매 금액(할인 적용 후)과 회원 등급 SQL 로 작성 부탁드립니다."							
*/
SELECT CUSTOMID,
       SUM(CASE
               WHEN TO_CHAR(TO_DATE(BUY_DATE, 'YYYY-MM-DD'), 'YYYY') = '2022' THEN PRICE * 0.9
               WHEN TO_CHAR(TO_DATE(BUY_DATE, 'YYYY-MM-DD'), 'YYYY') = '2023' THEN PRICE * 0.8
               WHEN TO_CHAR(TO_DATE(BUY_DATE, 'YYYY-MM-DD'), 'YYYY') = '2024' THEN PRICE * 0.7
               ELSE PRICE
           END) AS "총 구매 금액",
       CASE
           WHEN SUM(PRICE) < 50000 THEN '일반 회원'
           WHEN SUM(PRICE) < 100000 THEN '우수 회원'
           ELSE '최우수 회원'
       END AS "회원 등급"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
GROUP BY CUSTOMID;


-- (신현정) 
--- 문제 13. 2025년 기준, 가입한지 3년 이상 된 구매자들의 아이디, 이름, 이메일을 조회하라
-- (이때 이메일 '@' 뒷문자들은 *로 표시되게 조회해라) 	

SELECT CUSTOM_ID, NAME, 
       SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1) || '@************' AS EMAIL
FROM TBL_CUSTOM
WHERE ADD_MONTHS(REG_DATE, 36) <= SYSDATE;



----문제 14. 카테고리별 가격합이 제일 적은 카테고리와 --HAVING
--그 카테고리 상품을 제일 처음 구매한 구매자아이디와 구매날짜를 구하시오		--WHERE					
SELECT CATEGORY, "구매자 ID", "구매 날짜"
FROM (SELECT CATEGORY, CUSTOMID AS "구매자 ID", BUY_DATE AS "구매 날짜"
        FROM TBL_BUY
        JOIN TBL_PRODUCT USING(PCODE)
        GROUP BY CATEGORY, CUSTOMID, BUY_DATE
        ORDER BY BUY_DATE, SUM(PRICE))
WHERE ROWNUM = 1;


-- (이용훈)
-- 문제 15. 연휴 선물로 구입한 선물을 조회하고자 한다. 제품 1개당 가격이 20000원 이상이고,
-- 회원 1명 당 구입한 제품의 총 금액이 100000원 이상인 것을 조회하시오.
-- 이때 회원코드, 제품코드, 제품 이름, 제품 가격, 구입한 제품 개수, 구입한 제품의 총 금액을 조회하시오."							
SELECT CUSTOM_ID, PCODE, PNAME, PRICE, QUANTITY , QUANTITY * PRICE AS "구입한제품의총금액"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE QUANTITY * PRICE >= 100000
ORDER BY QUANTITY * PRICE ;


-- 문제 16. 각 년도별 판매 장부를 정리하고 있다.
-- 23년도, 24년도를 기준으로 구입 일자, 제품 이름, 제품 가격, 구입 개수, 제품별 총 금액을 조회하시오.
-- 판매 장부는 23년도부터 정렬한다."							
SELECT BUY_DATE, PNAME, PRICE, QUANTITY, (PRICE * QUANTITY) AS 총_금액
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE SUBSTR(BUY_DATE, 1, 2) IN ('23', '24')
ORDER BY BUY_DATE;

-- (이지은)
-- 문제 17. 나이가 20대인 회원이 구매한 상품 중 금액이 20000원 이상인 상품들만 뽑아 상품별 구매금액의 합을 구하시오.							
SELECT SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE (AGE >=20 AND AGE < 30) AND PRICE >= 20000;

/*
문제 18. 포인트제도를 도입하고자 한다. 포인트는 이용 금액에 따라(0.1%) 적립되며, 
적립된 포인트는 10점 이상부터 10점 단위로 매장에서 사용이 가능하다. 
(단, 사용은 적립된 포인트가 5000점이 넘어가야 사용이 가능함)
이때, 포인트 사용이 가능한 회원의 이름과 적립된 포인트를 조회하시오.
- TBL_POINT 테이블을 생성한 뒤 진행한다. 데이터는 TBL_CUSTOM의 모든 컬럼을 복사한 뒤, 
POINT 컬럼을 추가한다. (자료형은 NUMBER, 기본값은 0으로 준다.)
- POINT는 고객 별 누적 구매 금액 * 0.1 으로 계산한다.
*/

CREATE TABLE TBL_POINT
AS SELECT *
FROM TBL_CUSTOM;

SELECT * FROM TBL_POINT;

ALTER TABLE TBL_POINT ADD POINT NUMBER DEFAULT '0';

UPDATE TBL_POINT
SET POINT = (
    SELECT NVL(SUM(PRICE * QUANTITY) * 0.1, 0)  -- 구매 금액 * 0.1, 없으면 0
    FROM TBL_BUY
    JOIN TBL_PRODUCT USING(PCODE)
    WHERE CUSTOMID = CUSTOM_ID
);


-- 포인트가 5000점 이상인 회원의 이름과 적립된 포인트 조회
SELECT NAME, POINT
FROM TBL_POINT
WHERE POINT >= 5000;


-- (이호석)
--- 문제 19. 햇반 12개입와 같은 카테고리로 묶여있는 제품을 구매한 고객의 이름, 나이를 출력하시오.
SELECT DISTINCT NAME, AGE
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOMID)
WHERE CATEGORY = (SELECT CATEGORY
                     FROM TBL_PRODUCT
                     WHERE PNAME = '햇반 12개입');


--- 문제 20. 이나나와 같은 날짜에 가입한 회원의 이름과 EMAIL을 조회하라. '이나나'라는 이름을 사용해서 조회하도록 하라. (조회결과 : 이나나, 이길동)
SELECT NAME, EMAIL
FROM TBL_CUSTOM
WHERE REG_DATE = (SELECT REG_DATE
                  FROM TBL_CUSTOM
                  WHERE NAME = '이나나');

-- (전창용)
--문제 21. 이메일이 'korea'인 사람과, 'daum'인 사람의 이름, 구매 품목, 구매일, 구매 수량, 구매 물품 당 가격의 총합 조회
-- 서브쿼리 사용, 조회 컬럼마다 별칭 지정, 이름 순으로 정렬"		
SELECT * FROM TBL_CUSTOM;

SELECT NAME AS "이름", PNAME AS "구매 품목", BUY_DATE AS "구매일", QUANTITY AS "구매 수량", PRICE * QUANTITY AS "구매물품당가격의총합"
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE (EMAIL LIKE '%korea%') OR EMAIL LIKE '%daum%';


--문제 22. 위 문제에서 10만원 이상 구매한 구매자를 조회	
SELECT NAME AS "이름", PNAME AS "구매 품목", BUY_DATE AS "구매일", QUANTITY AS "구매 수량", PRICE * QUANTITY AS "구매물품당가격의총합"
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE (EMAIL LIKE '%korea%' OR EMAIL LIKE '%daum%') AND PRICE * QUANTITY >= 100000;

-- (주현수)
-- 문제 23. 모든 고객의 이름, 구매한 제품 이름, 총 가격(구매 수량 * 제품 가격)을 출력한다. 
--이때 각 고객들마다 마지막 행에는 구매한 모든 상품에 대한 총 합산 금액 정보가 있어야 하며(이때의 PNAME은 null),
--맨 마지막 행에는 모든 고객의 총 구매 금액을 합산한 정보가 있어야 한다.(이때의 NAME, PNAME은 null)
--(ROLLUP 함수 사용)
SELECT NAME, PNAME, SUM(PRICE * QUANTITY)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
GROUP BY ROLLUP(NAME, PNAME);

-- 문제 24. "2. 2023년 동안 총 10만원 이상 구매한 고객에 대한 정보를 조회하고자 한다.
--고객 이름, 아이디, 2023년 총 구매 금액을 조회하시오."							
SELECT NAME, CUSTOM_ID, SUM(PRICE * QUANTITY) AS "2023년 총 구매 금액"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE TO_CHAR(BUY_DATE, 'YY') = '23'
GROUP BY NAME, CUSTOM_ID
HAVING SUM(PRICE * QUANTITY) >= 100000;

-- (한재희)
--문제 25. 모든 고객의 구매한 상품, 구매한 갯수, 상품 별 가격, 상품 별 판매금액합계를 구하시오. 
--출력 시 표기되는 것은 상품이름, 상품별 판매개수, 해당 상품의 개당 가격, 판매금액합계 '만' 표기되어야한다. 	-- 6행까지 있음						

SELECT PCODE, SUM(QUANTITY), PRICE
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
GROUP BY PCODE, PRICE;


--문제 26. 판매된 상품을 표기되게 하며, 추가로 각 상품들을 구매한 고객과 구매수량을 구하시오. (내림차순 정렬) -- 9행까지 있음
SELECT PCODE, CUSTOM_ID, QUANTITY
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
ORDER BY QUANTITY DESC;


