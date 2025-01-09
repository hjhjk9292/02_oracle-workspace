-- 처음에 쿼리돌렸을 때 해당 테이블들이 없어서 오류가 생기는 것, 다음에 돌리면 오류 없음!

--테이블을 보며, 어떤 데이터인지 추측해보고, 각 테이블에 커맨트를 단다. (그리고, 캡쳐해둔다)
SELECT * FROM TBL_BUY; -- 구매정보(구매번호, 고객아이디, 상품코드, 상품 구매수량, 구매 일자)
SELECT * FROM TBL_CUSTOM; -- 고객(고객 아이디, 고객 이름, 이메일, 나이, 가입 일자)
SELECT * FROM TBL_PRODUCT; -- 상품(상품코드, 상품카테고리, 상품명, 가격)

--COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
COMMENT ON COLUMN TBL_BUY.BUY_IDX IS '구매번호';
COMMENT ON COLUMN TBL_BUY.CUSTOMID IS '고객 아이디';
COMMENT ON COLUMN TBL_BUY.PCODE IS '상품코드';
COMMENT ON COLUMN TBL_BUY.QUANTITY IS '상품 구매수량';
COMMENT ON COLUMN TBL_BUY.BUY_DATE IS '구매 일자';

COMMENT ON COLUMN TBL_CUSTOM.CUSTOM_ID IS '고객 아이디';
COMMENT ON COLUMN TBL_CUSTOM.NAME IS '고객 이름';
COMMENT ON COLUMN TBL_CUSTOM.EMAIL IS '이메일';
COMMENT ON COLUMN TBL_CUSTOM.AGE IS '나이';
COMMENT ON COLUMN TBL_CUSTOM.REG_DATE IS '가입 일자';

COMMENT ON COLUMN TBL_PRODUCT.PCODE IS '상품코드';
COMMENT ON COLUMN TBL_PRODUCT.CATEGORY IS '상품카테고리';
COMMENT ON COLUMN TBL_PRODUCT.PNAME IS '상품명';
COMMENT ON COLUMN TBL_PRODUCT.PRICE IS '가격';

/* A조  */
SELECT * FROM TBL_BUY; --   CUSTOMID    PCODE     QUANTITY    BUY_DATE
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID
SELECT * FROM TBL_PRODUCT;--            PCODE   PNAME   RRICE

--A-1. 'mina012' 가 구매한 상품 금액 합계(이광원)
SELECT CUSTOMID, SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
GROUP BY CUSTOMID
HAVING CUSTOMID = 'mina012';

--A-2. 이름에 '길동'이 들어가는 회원 구매한 상품 구매현황 (권태윤)
-- 데이터 추가 후 실행하세요.
INSERT INTO TBL_CUSTOM 
			VALUES ('dongL','이길동','lee@daum.net',25,sysdate);
INSERT INTO TBL_BUY 
			VALUES (1008,'dongL','DOWON123A',2,sysdate);
COMMIT;

SELECT * FROM TBL_CUSTOM;
SELECT * FROM TBL_BUY;
			            
--A-3. `25살`이상 고객님들의 `구매`한 `상품명` 조회하기 (강주찬) => 테이블 3개
SELECT PNAME
FROM TBL_BUY
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
JOIN TBL_PRODUCT USING(PCODE)
WHERE AGE >= 25;
	
--A-4. 상품명에 '사과' 단어가 포함된 상품을 구매한 고객에 대해 상품별 구매금액의 합을 구하기.(고길현)
-- 데이터 추가 후 실행하세요.
INSERT INTO TBL_PRODUCT
			VALUES ('BUSA211','B2','부사 사과 3kg 박스',25000);
INSERT INTO TBL_BUY  
			VALUES (1009,'hongGD','BUSA211',2,TO_date('2024-01-03','yyyy-mm-dd'));
COMMIT;

SELECT * FROM TBL_BUY; -- CUSTOMID      PCODE
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID
SELECT * FROM TBL_PRODUCT;--            PCODE   PNAME   RRICE

SELECT SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE PNAME LIKE '%사과%';

--A-5. 총 구매합산 금액이 100000~200000 값인 고객 ID를 조회하시오.(김태완)
SELECT CUSTOMID, PRICE * QUANTITY AS "총 구매합산 금액"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE PRICE * QUANTITY >= 10000 AND PRICE * QUANTITY <= 20000;


/*  B조 */
--B-1. 20대 나이 고객의 구매 상품 코드와 나이를 나이순으로 정렬 조회 (이대환)
SELECT PCODE, AGE
FROM TBL_BUY
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE AGE >= 20 AND AGE < 30
ORDER BY AGE DESC;

----B-2. 나이가 가장 많은 고객이 상품을 구매한 횟수를 조회하세요.-서브쿼리 사용하기 (김승한)
SELECT MAX(AGE), COUNT(QUANTITY) AS "상품구매횟수"
FROM TBL_BUY
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID);


----B-3. 2023년 하반기 구매금액을 고객ID별로 조회하시오. 금액이 높은 순서부터 조회하세요. (노희영) -- 하반기 조건
SELECT CUSTOMID, PRICE
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE SUBSTR(BUY_DATE, 1,2) = '23'
ORDER BY PRICE DESC;


--B-4. 2024년에 구매횟수가 1회 이상인 고객id, 고객이름, 나이,이메일을 조회하세요.(이재훈)
SELECT CUSTOM_ID, NAME, EMAIL, BUY_DATE
FROM TBL_CUSTOM
JOIN TBL_BUY ON (CUSTOM_ID = CUSTOMID)
WHERE SUBSTR(BUY_DATE, 1,2) = '24';


---B-5. 고객별-상품별 구매금액을 조회하세요. 정렬도 고객ID,상품코드 오름차순으로 정렬하세요.(이예진)
SELECT CUSTOMID, PCODE, SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
GROUP BY CUSTOMID, PCODE
ORDER BY 1, 2 ;


/* C조 */
---C-1. 가격 1만원 이상의 상품에 대해 각각 고객들이 구매한 평균 개수를 출력하시오.상품코드 순서로 정렬 (임현범)
SELECT * FROM TBL_BUY; -- CUSTOMID      PCODE                   QUANTITY
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID
SELECT * FROM TBL_PRODUCT;--            PCODE   PNAME   RRICE

SELECT PCODE, AVG(QUANTITY) AS "평균 개수"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE PRICE >= 10000
GROUP BY PCODE
ORDER BY PCODE;
	 
	 
--C-2. 진라면을 구매한 고객의 이름, 구매수량, 구매날짜를 조회하자. (출제자 : 전예진)
SELECT NAME AS 이름, QUANTITY AS 구매수량, BUY_DATE AS 구매날짜
FROM TBL_BUY
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
JOIN TBL_PRODUCT USING (PCODE)
WHERE PNAME LIKE '진라면%';


--C-4. 2023년에 팔린 상품의 이름과 코드, 총 판매액 그리고 총 판매개수를 상품코드 순서로 정렬하여 조회하시오. (정제원)
SELECT PNAME, PCODE, SUM(PRICE * QUANTITY) AS "총 판매액", COUNT(QUANTITY) AS "총 판매개수" 
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE SUBSTR(BUY_DATE, 1,2) = '23'
GROUP BY PNAME, PCODE
ORDER BY PCODE;


--C-5. 'twice'와 'hongGD'는 한집에 살고 있습니다. 이들이 구매한 상품,수량,가격을 조회하세요.-가격이 높은순서부터 정렬 (장성우)
SELECT PNAME, QUANTITY, PRICE
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE CUSTOMID in('twice','hongGD')
ORDER BY PRICE DESC;


/* D조 */
--D-1. 진라면을 가장 많이 구매한 회원을 구매금액이 높은 순으로 회원아이디와 총 진라면 구매금액을 보여주세요.(조하연)
-- 							ㄴ 서브쿼리 없이 조인만 사용

SELECT CUSTOMID AS "회원 아이디", PRICE * QUANTITY AS "총 구매금액"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE PCODE = 'JINRMN5'
ORDER BY PRICE DESC;


----D-2. 판매 갯수가 가장 많은 순서로 상품 을 정렬하고 총 팔린 금액을 출력하시오.(한진만)
-- 	   판매 개수가 같으면 상품 코드 순서로 정렬합니다.			ㄴ 동등 조인으로 조회

SELECT PCODE, QUANTITY, PRICE * QUANTITY AS "총 팔린금액"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
ORDER BY QUANTITY DESC, PCODE;


---D-3. 진라면을 구매한 고객들의 평균 나이를 제품코드(PCODE)와 함께 출력해 주세요.(황병훈)
SELECT * FROM TBL_BUY; -- CUSTOMID      PCODE
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID
SELECT * FROM TBL_PRODUCT;--            PCODE   PNAME   RRICE

SELECT PCODE "제품코드", AVG(AGE) "평균 나이"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOMID)
WHERE PNAME LIKE '%진라면%'
GROUP BY PCODE;

---D-4. 30세 미만 회원별 구매금액을 구하고 회원으로 그룹바이해서 구매금액 합계가 큰 순으로 정렬(조지수)
-- 						ㄴ 3개의 테이블 조인
SELECT CUSTOMID , SUM(PRICE * QUANTITY) "구매금액 합계"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOMID)
WHERE AGE < 30
GROUP BY CUSTOMID
ORDER BY 2 DESC;


SELECT * FROM TBL_BUY; --   CUSTOMID    PCODE     QUANTITY    BUY_DATE
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID
SELECT * FROM TBL_PRODUCT;--            PCODE   PNAME   RRICE

-- 가입일이 3년 이상됐으며 최근 1년 내 총 구매금액이 10만원 이상인 고객에게 이벤트를 진행하려고 한다. 해당하는 고객은?


-- 
