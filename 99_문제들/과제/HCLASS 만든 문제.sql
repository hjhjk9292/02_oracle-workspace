--���� �� ���� 
--�������� 3�� �̻������ �ֱ� 1�� �� �� ���űݾ��� 5���� �̻��� ������ �̺�Ʈ�� �����Ϸ��� �Ѵ�. �ش��ϴ� ����?

����1
SELECT CUSTOM_ID, NAME, SUM(PRICE * QUANTITY) AS "�� ���űݾ�"
FROM TBL_CUSTOM
JOIN TBL_BUY ON (CUSTOM_ID = CUSTOMID)
JOIN TBL_PRODUCT USING(PCODE)
WHERE ADD_MONTHS(REG_DATE, 36) <= SYSDATE -- �������� 3�� �̻�
  AND BUY_DATE >= ADD_MONTHS(SYSDATE, -12) -- �ֱ� 1�� ��
GROUP BY CUSTOM_ID, NAME
HAVING SUM(PRICE * QUANTITY) >= 50000; -- �� ���űݾ� 5�� �̻�

SELECT C.CUSTOM_ID, C.NAME, SUM(P.PRICE * B.QUANTITY) AS "�� ���űݾ�"
FROM TBL_CUSTOM C
JOIN TBL_BUY B ON C.CUSTOM_ID = B.CUSTOMID
JOIN TBL_PRODUCT P ON B.PCODE = P.PCODE
WHERE ADD_MONTHS(C.REG_DATE, 36) <= TO_DATE('2025-01-08', 'YYYY-MM-DD') -- ���� 3�� �̻�
  AND B.BUY_DATE >= ADD_MONTHS(TO_DATE('2025-01-08', 'YYYY-MM-DD'), -12) -- �ֱ� 1�� ��
GROUP BY C.CUSTOM_ID, C.NAME
HAVING SUM(P.PRICE * B.QUANTITY) >= 50000; -- �� ���� �ݾ� 5�� �̻�

---------------------------------------------------------------------------------------
���� 2 ���� �ݾ� ���� 20%�� �ش��ϴ� �� ID�� �� ���� �ݾ��� ����Ͻÿ�.
����:
�� ���� �ݾ� �������� ���� 20%�� ���� ��ȸ�մϴ�.
�߰� ���� �����͸� INSERT�Ͽ� ���� 20%�� Ȯ���ϼ���.
INSERT INTO TBL_CUSTOM VALUES ('johnD', 'John Doe', 'john.doe@example.com', 35, TO_DATE('2019-05-10', 'YYYY-MM-DD'));
INSERT INTO TBL_PRODUCT VALUES ('FRUIT123', '����', '�ٳ���', 15000);
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

���� 3 ���ɴ뺰�� �� ���� �ݾ��� ���ϰ�, ���� ���� ���� �ݾ��� �� ���ɴ� ������ ��ȸ
����:
���ɴ뺰�� �� ���� �ݾ��� ���ϰ�, ���� ���� ���� �ݾ��� �� ���ɴ���� ��ȸ�ϼ���.

SELECT FLOOR(AGE / 10) * 10 AS AGE_RANGE, 
       SUM(PRICE * QUANTITY) AS TOTAL_AMOUNT
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
JOIN TBL_CUSTOM ON (TBL_BUY.CUSTOMID = TBL_CUSTOM.CUSTOM_ID)
GROUP BY FLOOR(AGE / 10) * 10
ORDER BY TOTAL_AMOUNT DESC;

-------------------------------------------------------------------------------

���� 4 ���� ��ǰ�� ���� �� ������ ���� ���� ������ ���� ���ڿ� �� ���� �ݾ� ��ȸ
����:
���� ��ǰ�� ���� �� ������ ���鿡 ����, �� ���� ���� ������ ���� ���ڿ� �ش� ��ǰ�� ������ �� �ݾ��� ��ȸ�ϼ���.


SELECT CUSTOMID, PCODE, MAX(BUY_DATE) AS LAST_BUY_DATE, SUM(PRICE * QUANTITY) AS TOTAL_AMOUNT
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
GROUP BY CUSTOMID, PCODE
HAVING COUNT(PCODE) > 1;

--------------------------------------------------------------------------------------
���� 5 �������� ���� ���� �ȸ� ��ǰ�� �̸��� �ش� ��ǰ�� ������ �� �� ��ȸ
����:
�������� ���� ���� �ȸ� ��ǰ�� ã��, �� ��ǰ�� ������ �� ���� ��ȸ�ϼ���. (�Ǹ� �ݾ��� ���� �������� ���� ���� �ȸ� ��ǰ�� ã�ƾ� ��)

SELECT TO_CHAR(BUY_DATE, 'YYYY') AS YEAR, 
       PNAME, 
       COUNT(DISTINCT CUSTOMID) AS CUSTOMER_COUNT
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
WHERE TO_CHAR(BUY_DATE, 'YYYY') = '2024'
GROUP BY TO_CHAR(BUY_DATE, 'YYYY'), PNAME
ORDER BY YEAR, CUSTOMER_COUNT DESC;


-----------------------------------------------------------------------------
���� 6 ���� �ֱٿ� ������ ���� ���� �ݾ� ��ȸ
����:
���� �ֱٿ� ������ ���� ���� �ݾ��� ��ȸ�ϼ���. (������ �������� ���� �ֱ� ������ ��)
SELECT CUSTOMID, SUM(PRICE * QUANTITY) AS TOTAL_AMOUNT
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
WHERE BUY_DATE = (SELECT MAX(BUY_DATE) FROM TBL_BUY)
GROUP BY CUSTOMID;

--------------------------------------------------------------------------------------
���� 7 2024�⿡ �� ���̶� ������ �� �� 2023�⿡ ������ ���� ���� ��
����:
2024�⿡ �� ���̶� ������ �� ��, 2023�⿡ ������ ���� ���� ���� ��ȸ�ϼ���.

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
       
       
���� 8 ��� ���� �ݾ� �̻��� ������ ���� ID�� �ش� ���� �� ���� �ݾ��� ����Ͻÿ�.
����:
���������� �̿��Ͽ� ��ü ���� ��� ���� �ݾ��� ����ϰ�, �� ���� �ʰ��ϴ� ���� ��ȸ�մϴ�.       
SELECT CUSTOMID, SUM(PRICE * QUANTITY) AS ��ձ��űݾ�
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
�ٸ� ��� ����
------------------------------------------------------------------------------------						
							
����9
-- 1)DATA_TYPE�� CHAR(2)�� CATEGORY_ID�� DATA_TYPE�� VARCHAR2(20)�� CATEGORY_NAME�� �����ִ� TBL_CATEGORY��� ���̺��� ������
--   �̶� CATEGORY_ID�� PRIMARY KEY�� ����� �������Ǹ��� CATEGORY_PK�� �����,
--   CATEGORY_ID�� COMMENT�� CATEGORY_ID��, CATEGORY_NAME�� COMMENT�� CATRGORY_NAME�� �����,
--   ���̺� ('A1', '����') �����Ϳ� ('B1', '��Ÿ') �����͸� �־��"		


����10
-- 2_1)���ϵ��� ������ A1���� �����ϰ�, �� ���� �͵��� B1���� �����Ͽ���
-- 2_2)TBL_PRODUCT�� CATEGORY�� TBL_CATEGORY�� CATEGORY_ID�� �����ϴ� �ܷ�Ű�� ����� ������ ������ �ڽ� �����͵� �����ǰ� �Ͽ���
-- (�̶� �������Ǹ��� CATEGOTY_ID_FK�� �Ͽ���)"							


����11	
"CATEGORY �����Ϳ� 'B' ���ԵǾ� �ִ� ��ǰ�� ������ ȸ������ �̸�, ���� ��ǰ �̸��� ���Ź�ǰ�� �� ���� ��ȸ�Ͻÿ�.
(ȸ���̸����� ���� ���� ����, �� ������ '�� ���űݾ�'���� ��Ī ����)"							
����12	
"ȸ������ �� ���� ���� ������ ��ǰ��� �� ��ǰ�� �� ���� ������ ���� ��ǰ�� ��ȸ�ҷ��� �Ѵ�. ����, ��ǰ�̸�, ���� �� ���� ��� ��ǰ ������ ��ȸ�Ͻÿ�.
(�߰� ����� �� ���迡�� ��ǰ �̸��� '���� ��� ��ǰ�� ����' ������ ��µǵ��� �ۼ�, ���� �������� �������� ����)"							
								
                                
����13
: �̸��� ��̳��� ����� 
--������ ��ǰ�߿� �ι�°�� ���� ���� ��ǰ�ڵ�,��ǰ��,����,����
-- ���� ������ ���� �� �Ѵ� ��� RANK()OVER�� ������"		

����14	"--���� 2 : ��ǰ �ڵ� �� ������ �����(BUY_DATE)�� �հ踦 ���Ͻÿ�
--ROLL UP ��� / UNION ALL ��� 
--UNION ALL�������� �׳� ROLLUP�� ������"		

����15	�� ī�װ����� ���� ������ ������ ��ǰ���� ��ǰ �ڵ�� �ش� ī�װ� �̸��� ���ϴ� SQL ����							
����16	"�� ���� �ݾ׿� ���� ȸ�� ����� ������ ���� �з��˴ϴ�:

5�� �� �̸�: �Ϲ� ȸ��
5�� �� �̻� 10���� �̸�: ��� ȸ��
10�� �� �̻�: �ֿ�� ȸ��
����, ���� ������ ���� �������� ������ ���� ����˴ϴ�:

2022�� ����: 10% ����
2023�� ����: 20% ����
2024�� ����: 30% ����
�� �� �⵵ ����: ����
�� ������ ������� ȸ�����̵� �� ���� �ݾ�(���� ���� ��)�� ȸ�� ��� SQL �� �ۼ� ��Ź�帳�ϴ�."							
							
����17
----1. ���� ������ ������ ������ ��ȸ�ϰ��� �Ѵ�. ��ǰ 1���� ������ 20000�� �̻��̰�,
-- ȸ�� 1�� �� ������ ��ǰ�� �� �ݾ��� 100000�� �̻��� ���� ��ȸ�Ͻÿ�.
-- �̶� ȸ���ڵ�, ��ǰ�ڵ�, ��ǰ �̸�, ��ǰ ����, ������ ��ǰ ����, ������ ��ǰ�� �� �ݾ��� ��ȸ�Ͻÿ�.	


����18	
"-- 2. �� �⵵�� �Ǹ� ��θ� �����ϰ� �ִ�.
-- 23�⵵, 24�⵵�� �������� ���� ����, ��ǰ �̸�, ��ǰ ����, ���� ����, ��ǰ�� �� �ݾ��� ��ȸ�Ͻÿ�.
-- �Ǹ� ��δ� 23�⵵���� �����Ѵ�."							
							
����19	--�޹� 12���Կ� ���� ī�װ��� �����ִ� ��ǰ�� ������ ���� �̸�, ���̸� ����Ͻÿ�.							
����20	--�̳����� ���� ��¥�� ������ ȸ���� �̸��� EMAIL�� ��ȸ�϶�. '�̳���'��� �̸��� ����ؼ� ��ȸ�ϵ��� �϶�. (��ȸ��� : �̳���, �̱浿)



					