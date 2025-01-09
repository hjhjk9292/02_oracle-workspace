--본인이 출제한 2문제 
/*
문제1. 오늘 날짜 기준으로 가입일이 2년 이상됐으며 최근 1년 내 총 구매금액이 5만원 이상인 고객에게 이벤트를 진행하려고 한다. 
해당하는 고객의 아이디, 이름, 총 구매금액을 조회하시오.
*/
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

/*
문제2. 2023년과 2024년도별로 판매된 상품의 이름과 상품구매수량과 해당 상품을 구매한 고객 수를 조회하시오. 
출력 결과는 년도는 오름차순으로 정렬하고, 상품구매수량과 구매한 고객 수는 내림차순으로 정렬한다.
*/
SELECT TO_CHAR(BUY_DATE, 'YYYY') AS YEAR, 
       PNAME, 
       COUNT(QUANTITY) AS "상품구매수량", 
       COUNT(CUSTOMID) AS "구매한 고객 수"
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
WHERE TO_CHAR(BUY_DATE, 'YYYY') IN ('2023', '2024')
GROUP BY TO_CHAR(BUY_DATE, 'YYYY'), PNAME
ORDER BY YEAR ASC, "상품구매수량" DESC, "구매한 고객 수" DESC;


