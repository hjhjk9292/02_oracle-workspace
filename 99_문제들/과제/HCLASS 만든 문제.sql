--내가 낼 문제 
--가입일이 3년 이상됐으며 최근 1년 내 총 구매금액이 5만원 이상인 고객에게 이벤트를 진행하려고 한다. 해당하는 고객은?

문제1
SELECT CUSTOM_ID, NAME, SUM(PRICE * QUANTITY) AS "총 구매금액"
FROM TBL_CUSTOM
JOIN TBL_BUY ON (CUSTOM_ID = CUSTOMID)
JOIN TBL_PRODUCT USING(PCODE)
WHERE ADD_MONTHS(REG_DATE, 36) <= SYSDATE -- 가입일이 3년 이상
  AND BUY_DATE >= ADD_MONTHS(SYSDATE, -12) -- 최근 1년 내
GROUP BY CUSTOM_ID, NAME
HAVING SUM(PRICE * QUANTITY) >= 50000; -- 총 구매금액 5만 이상

SELECT C.CUSTOM_ID, C.NAME, SUM(P.PRICE * B.QUANTITY) AS "총 구매금액"
FROM TBL_CUSTOM C
JOIN TBL_BUY B ON C.CUSTOM_ID = B.CUSTOMID
JOIN TBL_PRODUCT P ON B.PCODE = P.PCODE
WHERE ADD_MONTHS(C.REG_DATE, 36) <= TO_DATE('2025-01-08', 'YYYY-MM-DD') -- 가입 3년 이상
  AND B.BUY_DATE >= ADD_MONTHS(TO_DATE('2025-01-08', 'YYYY-MM-DD'), -12) -- 최근 1년 내
GROUP BY C.CUSTOM_ID, C.NAME
HAVING SUM(P.PRICE * B.QUANTITY) >= 50000; -- 총 구매 금액 5만 이상

---------------------------------------------------------------------------------------
문제 2 구매 금액 상위 20%에 해당하는 고객 ID와 총 구매 금액을 출력하시오.
설명:
총 구매 금액 기준으로 상위 20%의 고객만 조회합니다.
추가 구매 데이터를 INSERT하여 상위 20%를 확인하세요.
INSERT INTO TBL_CUSTOM VALUES ('johnD', 'John Doe', 'john.doe@example.com', 35, TO_DATE('2019-05-10', 'YYYY-MM-DD'));
INSERT INTO TBL_PRODUCT VALUES ('FRUIT123', '과일', '바나나', 15000);
INSERT INTO TBL_BUY VALUES (1010, 'johnD', 'FRUIT123', 5, TO_DATE('2024-09-01', 'YYYY-MM-DD'));


SELECT CUSTOMID, TOTAL_AMOUNT
FROM (
    SELECT CUSTOMID, 
           SUM(PRICE * QUANTITY) AS TOTAL_AMOUNT,
           RANK() OVER (ORDER BY SUM(PRICE * QUANTITY) DESC) AS RANKING
    FROM TBL_BUY
    JOIN TBL_PRODUCT USING (PCODE)
    GROUP BY CUSTOMID
) 
WHERE RANKING <= 
    CEIL(0.2 * (SELECT COUNT(DISTINCT CUSTOMID) 
                FROM TBL_BUY));
                
---------------------------------------------------------------------------------------

문제 3 연령대별로 총 구매 금액을 구하고, 가장 많은 구매 금액을 쓴 연령대 순으로 조회
설명:
연령대별로 총 구매 금액을 구하고, 가장 많은 구매 금액을 쓴 연령대부터 조회하세요.

SELECT FLOOR(AGE / 10) * 10 AS AGE_RANGE, 
       SUM(PRICE * QUANTITY) AS TOTAL_AMOUNT
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
JOIN TBL_CUSTOM ON (TBL_BUY.CUSTOMID = TBL_CUSTOM.CUSTOM_ID)
GROUP BY FLOOR(AGE / 10) * 10
ORDER BY TOTAL_AMOUNT DESC;

-------------------------------------------------------------------------------

문제 4 같은 상품을 여러 번 구매한 고객의 가장 마지막 구매 일자와 총 구매 금액 조회
설명:
같은 상품을 여러 번 구매한 고객들에 대해, 그 고객의 가장 마지막 구매 일자와 해당 상품을 구매한 총 금액을 조회하세요.


SELECT CUSTOMID, PCODE, MAX(BUY_DATE) AS LAST_BUY_DATE, SUM(PRICE * QUANTITY) AS TOTAL_AMOUNT
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
GROUP BY CUSTOMID, PCODE
HAVING COUNT(PCODE) > 1;

--------------------------------------------------------------------------------------
문제 5 연도별로 가장 많이 팔린 상품의 이름과 해당 상품을 구매한 고객 수 조회
설명:
연도별로 가장 많이 팔린 상품을 찾고, 그 상품을 구매한 고객 수를 조회하세요. (판매 금액의 합을 기준으로 가장 많이 팔린 상품을 찾아야 함)

SELECT TO_CHAR(BUY_DATE, 'YYYY') AS YEAR, 
       PNAME, 
       COUNT(DISTINCT CUSTOMID) AS CUSTOMER_COUNT
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
WHERE TO_CHAR(BUY_DATE, 'YYYY') = '2024'
GROUP BY TO_CHAR(BUY_DATE, 'YYYY'), PNAME
ORDER BY YEAR, CUSTOMER_COUNT DESC;


-----------------------------------------------------------------------------
문제 6 가장 최근에 구매한 고객의 구매 금액 조회
설명:
가장 최근에 구매한 고객의 구매 금액을 조회하세요. (구매일 기준으로 가장 최근 구매한 고객)
SELECT CUSTOMID, SUM(PRICE * QUANTITY) AS TOTAL_AMOUNT
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
WHERE BUY_DATE = (SELECT MAX(BUY_DATE) FROM TBL_BUY)
GROUP BY CUSTOMID;

--------------------------------------------------------------------------------------
문제 7 2024년에 한 번이라도 구매한 고객 중 2023년에 구매한 적이 없는 고객
설명:
2024년에 한 번이라도 구매한 고객 중, 2023년에 구매한 적이 없는 고객을 조회하세요.

SELECT CUSTOMID
FROM TBL_BUY
WHERE BUY_DATE BETWEEN TO_DATE('2024-01-01', 'yyyy-mm-dd') AND TO_DATE('2024-12-31', 'yyyy-mm-dd')
AND CUSTOMID NOT IN (
    SELECT DISTINCT CUSTOMID
    FROM TBL_BUY
    WHERE BUY_DATE BETWEEN TO_DATE('2023-01-01', 'yyyy-mm-dd') AND TO_DATE('2023-12-31', 'yyyy-mm-dd')
)
GROUP BY CUSTOMID;



---------------------------------------------------------------------------------------
       
       
문제 8 평균 구매 금액 이상을 지출한 고객의 ID와 해당 고객의 총 구매 금액을 출력하시오.
설명:
서브쿼리를 이용하여 전체 고객의 평균 구매 금액을 계산하고, 이 값을 초과하는 고객을 조회합니다.       
SELECT CUSTOMID, SUM(PRICE * QUANTITY) AS 평균구매금액
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
GROUP BY CUSTOMID
HAVING SUM(PRICE * QUANTITY) >= (
    SELECT AVG(SUM(PRICE * QUANTITY))
    FROM TBL_BUY
    JOIN TBL_PRODUCT USING (PCODE)
    GROUP BY CUSTOMID
);



SELECT CUSTOMID, PNAME, PRICE
FROM (
    SELECT CUSTOMID, PNAME, PRICE, 
           RANK() OVER (PARTITION BY CUSTOMID ORDER BY PRICE DESC) AS RANKING
    FROM TBL_BUY
    JOIN TBL_PRODUCT USING (PCODE)
    WHERE BUY_DATE >= ADD_MONTHS(SYSDATE, -12)
)
WHERE RANKING = 1;




-------------------------------------------------------------------------------------
다른 사람 문제
------------------------------------------------------------------------------------						
							
문제9
-- 1)DATA_TYPE이 CHAR(2)인 CATEGORY_ID와 DATA_TYPE이 VARCHAR2(20)인 CATEGORY_NAME을 갖고있는 TBL_CATEGORY라는 테이블을 만들어라
--   이때 CATEGORY_ID를 PRIMARY KEY로 만들고 제약조건명을 CATEGORY_PK로 만들고,
--   CATEGORY_ID의 COMMENT를 CATEGORY_ID로, CATEGORY_NAME의 COMMENT를 CATRGORY_NAME로 만들고,
--   테이블에 ('A1', '과일') 데이터와 ('B1', '기타') 데이터를 넣어라"		


문제10
-- 2_1)과일들의 종류를 A1으로 변경하고, 그 외의 것들은 B1으로 변경하여라
-- 2_2)TBL_PRODUCT의 CATEGORY를 TBL_CATEGORY에 CATEGORY_ID를 참조하는 외래키로 만들고 데이터 삭제시 자식 데이터도 삭제되게 하여라
-- (이때 제약조건명은 CATEGOTY_ID_FK로 하여라)"							


문제11	
"CATEGORY 데이터에 'B' 포함되어 있는 물품을 구매한 회원들의 이름, 구매 물품 이름과 구매물품의 총 가격 조회하시오.
(회원이름으로 오름 차순 정렬, 총 가격은 '총 구매금액'으로 별칭 지정)"							
문제12	
"회원들의 각 나이 별로 구매한 상품들과 그 상품들 중 가장 가격이 높은 상품을 조회할려고 한다. 나이, 상품이름, 나이 별 가장 비싼 상품 가격을 조회하시오.
(중간 집계와 총 집계에서 상품 이름에 '가장 비싼 상품의 가격' 문구가 출력되도록 작성, 나이 기준으로 오름차순 정렬)"							
								
                                
문제13
: 이름이 김미나인 사람이 
--구매한 물품중에 두번째로 많은 것의 상품코드,상품명,가격,수량
-- 만약 동순위 존재 시 둘다 출력 RANK()OVER를 쓰세여"		

문제14	"--문제 2 : 상품 코드 별 연도별 매출액(BUY_DATE)의 합계를 구하시오
--ROLL UP 사용 / UNION ALL 사용 
--UNION ALL귀찮으면 그냥 ROLLUP만 쓰세요"		

문제15	각 카테고리별로 가장 가격이 저렴한 제품들의 제품 코드와 해당 카테고리 이름을 구하는 SQL 쿼리							
문제16	"총 구매 금액에 따라 회원 등급은 다음과 같이 분류됩니다:

5만 원 미만: 일반 회원
5만 원 이상 10만원 미만: 우수 회원
10만 원 이상: 최우수 회원
또한, 구매 연도에 따른 할인율은 다음과 같이 적용됩니다:

2022년 구매: 10% 할인
2023년 구매: 20% 할인
2024년 구매: 30% 할인
그 외 년도 구매: 정가
위 기준을 기반으로 회원아이디 총 구매 금액(할인 적용 후)과 회원 등급 SQL 로 작성 부탁드립니다."							
							
문제17
----1. 연휴 선물로 구입한 선물을 조회하고자 한다. 제품 1개당 가격이 20000원 이상이고,
-- 회원 1명 당 구입한 제품의 총 금액이 100000원 이상인 것을 조회하시오.
-- 이때 회원코드, 제품코드, 제품 이름, 제품 가격, 구입한 제품 개수, 구입한 제품의 총 금액을 조회하시오.	


문제18	
"-- 2. 각 년도별 판매 장부를 정리하고 있다.
-- 23년도, 24년도를 기준으로 구입 일자, 제품 이름, 제품 가격, 구입 개수, 제품별 총 금액을 조회하시오.
-- 판매 장부는 23년도부터 정렬한다."							
							
문제19	--햇반 12개입와 같은 카테고리로 묶여있는 제품을 구매한 고객의 이름, 나이를 출력하시오.							
문제20	--이나나와 같은 날짜에 가입한 회원의 이름과 EMAIL을 조회하라. '이나나'라는 이름을 사용해서 조회하도록 하라. (조회결과 : 이나나, 이길동)



					