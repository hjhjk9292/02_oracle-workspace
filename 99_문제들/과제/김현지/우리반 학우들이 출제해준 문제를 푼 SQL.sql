/*
 H �п�� �����ͺ��̽� 
*/
SELECT * FROM TBL_BUY; --   CUSTOMID    PCODE     QUANTITY    BUY_DATE  BUY_IDX
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID        NAME    EMAIL          REG_DATE
SELECT * FROM TBL_PRODUCT;--            PCODE   CATEGORY  PNAME   RRICE

-- (������)							
-- 1. 2023�� ���� ������ ���� �߿���, �� ���� ������ ��ǰ�� ��� ���� �ݾ��� 20,000�� �̻��� ������ �� ID�� �̸��� ��ȸ�Ͻÿ�.							
SELECT CUSTOM_ID, NAME, SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE TO_CHAR(BUY_DATE, 'YYYY') = '2023'
GROUP BY CUSTOM_ID, NAME
HAVING AVG(PRICE) >= 20000;


-- 2. "2023�� �Ϲݱ�  ���� '��'�̶�� �ܾ ���Ե� ��ǰ�� ������ ������ �̸�, ����, �̸����� ��ȸ�Ͻÿ�.
--��, �� ���� ������ ���� ��ǰ�� ���� ���� ������ ���� ���ϰ�, ���� ������ ���� ������ �����Ͻÿ�."							
SELECT NAME, EMAIL
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE TO_CHAR(BUY_DATE, 'YYYY') = '2023'
  AND TO_CHAR(BUY_DATE, 'MM') BETWEEN '07' AND '12'
  AND PNAME LIKE '%��%'
GROUP BY NAME, EMAIL
ORDER BY SUM(QUANTITY) DESC;


-- (����)
-- 3. 1)DATA_TYPE�� CHAR(2)�� CATEGORY_ID�� DATA_TYPE�� VARCHAR2(20)�� CATEGORY_NAME�� �����ִ� TBL_CATEGORY��� ���̺��� ������
-- �̶� CATEGORY_ID�� PRIMARY KEY�� ����� �������Ǹ��� CATEGORY_PK�� �����,
-- CATEGORY_ID�� COMMENT�� CATEGORY_ID��, CATEGORY_NAME�� COMMENT�� CATRGORY_NAME�� �����,
-- ���̺� ('A1', '����') �����Ϳ� ('B1', '��Ÿ') �����͸� �־��"
-- (�� ������ �� �������� Ǫ����!! ī�װ� �����Ͱ� �����ؼ� �ٸ� �е� ������ ��� �ٸ��� ���� �� �ֽ��ϴ�,,,)

CREATE TABLE TBL_CATEGORY (
    CATEGORY_ID CHAR(2),
    CATEGORY_NAME VARCHAR2(20),
    CONSTRAINT CATEGORY_PK PRIMARY KEY (CATEGORY_ID)
);

COMMENT ON COLUMN TBL_CATEGORY.CATEGORY_ID IS 'CATEGORY_ID';
COMMENT ON COLUMN TBL_CATEGORY.CATEGORY_NAME IS 'CATEGORY_NAME';

INSERT INTO TBL_CATEGORY (CATEGORY_ID, CATEGORY_NAME) VALUES ('A1', '����');
INSERT INTO TBL_CATEGORY (CATEGORY_ID, CATEGORY_NAME) VALUES ('B1', '��Ÿ');

-- 4.-- 2_1)���ϵ��� ������ A1���� �����ϰ�, �� ���� �͵��� B1���� �����Ͽ���
-- 2_2)TBL_PRODUCT�� CATEGORY�� TBL_CATEGORY�� CATEGORY_ID�� �����ϴ� �ܷ�Ű�� ����� 
-- ������ ������ �ڽ� �����͵� �����ǰ� �Ͽ��� (�̶� �������Ǹ��� CATEGOTY_ID_FK�� �Ͽ���)"							

UPDATE TBL_PRODUCT
SET CATEGORY = CASE 
                  WHEN CATEGORY LIKE '%����%' THEN 'A1' 
                  ELSE 'B1' 
               END;


ALTER TABLE TBL_PRODUCT
ADD CONSTRAINT CATEGORY_ID_FK FOREIGN KEY (CATEGORY)
REFERENCES TBL_CATEGORY (CATEGORY_ID)
ON DELETE CASCADE;

SELECT * FROM TBL_PRODUCT;

ROLLBACK;

-- (���ؼ�)
-- 5. "CATEGORY �����Ϳ� 'B' ���ԵǾ� �ִ� ��ǰ�� ������ ȸ������ �̸�, ���� ��ǰ �̸��� ���Ź�ǰ�� �� ���� ��ȸ�Ͻÿ�.
--(ȸ���̸����� ���� ���� ����, �� ������ '�� ���űݾ�'���� ��Ī ����)"

SELECT AGE, 
    CASE 
        WHEN GROUPING(PNAME) = 1 THEN '���� ��� ��ǰ�� ����' 
        ELSE PNAME 
    END AS "��ǰ�̸�",
    MAX(PRICE) AS "��ǰ����"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
GROUP BY ROLLUP(AGE, PNAME)
ORDER BY 1;

--- 6. "ȸ������ �� ���� ���� ������ ��ǰ��� �� ��ǰ�� �� ���� ������ ���� ��ǰ�� ��ȸ�ҷ��� �Ѵ�. 
-- ����, ��ǰ�̸�, ���� �� ���� ��� ��ǰ ������ ��ȸ�Ͻÿ�.
--(�߰� ����� �� ���迡�� ��ǰ �̸��� '���� ��� ��ǰ�� ����' ������ ��µǵ��� �ۼ�, ���� �������� �������� ����)"							

SELECT AGE, PNAME AS "��ǰ�̸�" , MAX(PRICE) AS "��ǰ����" 
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
GROUP BY AGE, PNAME, ROLLUP(PRICE)
ORDER BY 1;


-- (������)
--����7. ���� ��¥ �������� �������� 2�� �̻������ �ֱ� 1�� �� �� ���űݾ��� 5���� �̻��� ������ �̺�Ʈ�� �����Ϸ��� �Ѵ�. 
--�ش��ϴ� ���� ���̵�, �̸�, �� ���űݾ��� ��ȸ�Ͻÿ�.

SELECT CUSTOM_ID, NAME, SUM(PRICE * QUANTITY) AS "�� ���űݾ�"
FROM TBL_CUSTOM
JOIN TBL_BUY ON (CUSTOM_ID = CUSTOMID)
JOIN TBL_PRODUCT USING(PCODE)
WHERE ADD_MONTHS(REG_DATE, 24) <= SYSDATE -- �������� 2�� �̻�
  AND BUY_DATE >= ADD_MONTHS(SYSDATE, -12) -- �ֱ� 1�� ��
GROUP BY CUSTOM_ID, NAME
HAVING SUM(PRICE * QUANTITY) >= 50000; -- �� ���űݾ� 5�� �̻�


SELECT C.CUSTOM_ID, C.NAME, SUM(P.PRICE * B.QUANTITY) AS "�� ���űݾ�"
FROM TBL_CUSTOM C
JOIN TBL_BUY B ON C.CUSTOM_ID = B.CUSTOMID
JOIN TBL_PRODUCT P ON B.PCODE = P.PCODE
WHERE ADD_MONTHS(C.REG_DATE, 24) <= TO_DATE('2025-01-08', 'YYYY-MM-DD') -- �������� 2�� �̻�
  AND B.BUY_DATE >= ADD_MONTHS(TO_DATE('2025-01-08', 'YYYY-MM-DD'), -12) -- �ֱ� 1�� ��
GROUP BY C.CUSTOM_ID, C.NAME
HAVING SUM(P.PRICE * B.QUANTITY) >= 50000; -- �� ���� �ݾ� 5�� �̻�


-- 8. 2023��� 2024�⵵���� �Ǹŵ� ��ǰ�� �̸��� ��ǰ���ż����� �ش� ��ǰ�� ������ �� ���� ��ȸ�Ͻÿ�. 
-- ��� ����� �⵵�� ������������ �����ϰ�, ��ǰ���ż����� ������ �� ���� ������������ �����Ѵ�.

SELECT TO_CHAR(BUY_DATE, 'YYYY') AS YEAR, 
       PNAME, 
       COUNT(QUANTITY) AS "��ǰ���ż���", 
       COUNT(CUSTOMID) AS "������ �� ��"
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
WHERE TO_CHAR(BUY_DATE, 'YYYY') IN ('2023', '2024')
GROUP BY TO_CHAR(BUY_DATE, 'YYYY'), PNAME
ORDER BY YEAR ASC, "��ǰ���ż���" DESC, "������ �� ��" DESC;


-- (������)				
--- 9. �̸��� ��̳��� ����� ������ ��ǰ�߿� �ι�°�� ���� ���� ��ǰ�ڵ�, ��ǰ��, ����, ����
-- ���� ������ ���� �� �Ѵ� ��� RANK()OVER�� ������"

SELECT PCODE, PNAME, PRICE, QUANTITY
FROM (
    SELECT PCODE, PNAME, PRICE, QUANTITY,
           RANK() OVER (PARTITION BY NAME ORDER BY QUANTITY DESC) AS RANKING
    FROM TBL_BUY
    JOIN TBL_PRODUCT USING(PCODE)
    JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
    WHERE NAME = '��̳�'
)
WHERE RANKING = 2;

                        	
--- 10. ��ǰ �ڵ� �� ������ �����(BUY_DATE)�� �հ踦 ���Ͻÿ�
--ROLL UP ��� / UNION ALL ��� 
--UNION ALL�������� �׳� ROLLUP�� ������"	

SELECT PCODE, BUY_DATE, SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
GROUP BY ROLLUP(PCODE, BUY_DATE);


-- (������)
-- 11. �� ī�װ����� ���� ������ ������ ��ǰ���� ��ǰ �ڵ�� �ش� ī�װ� �̸��� ���ϴ� SQL ����
SELECT CATEGORY, PCODE, MIN(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
GROUP BY CATEGORY, PCODE;


/* ���� 12. "�� ���� �ݾ׿� ���� ȸ�� ����� ������ ���� �з��˴ϴ�:

5�� �� �̸�: �Ϲ� ȸ��
5�� �� �̻� 10���� �̸�: ��� ȸ��
10�� �� �̻�: �ֿ�� ȸ��
����, ���� ������ ���� �������� ������ ���� ����˴ϴ�:

2022�� ����: 10% ����
2023�� ����: 20% ����
2024�� ����: 30% ����
�� �� �⵵ ����: ����
�� ������ ������� ȸ�����̵� �� ���� �ݾ�(���� ���� ��)�� ȸ�� ��� SQL �� �ۼ� ��Ź�帳�ϴ�."							
*/
SELECT CUSTOMID,
       SUM(CASE
               WHEN TO_CHAR(TO_DATE(BUY_DATE, 'YYYY-MM-DD'), 'YYYY') = '2022' THEN PRICE * 0.9
               WHEN TO_CHAR(TO_DATE(BUY_DATE, 'YYYY-MM-DD'), 'YYYY') = '2023' THEN PRICE * 0.8
               WHEN TO_CHAR(TO_DATE(BUY_DATE, 'YYYY-MM-DD'), 'YYYY') = '2024' THEN PRICE * 0.7
               ELSE PRICE
           END) AS "�� ���� �ݾ�",
       CASE
           WHEN SUM(PRICE) < 50000 THEN '�Ϲ� ȸ��'
           WHEN SUM(PRICE) < 100000 THEN '��� ȸ��'
           ELSE '�ֿ�� ȸ��'
       END AS "ȸ�� ���"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
GROUP BY CUSTOMID;


-- (������) 
--- ���� 13. 2025�� ����, �������� 3�� �̻� �� �����ڵ��� ���̵�, �̸�, �̸����� ��ȸ�϶�
-- (�̶� �̸��� '@' �޹��ڵ��� *�� ǥ�õǰ� ��ȸ�ض�) 	

SELECT CUSTOM_ID, NAME, 
       SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1) || '@************' AS EMAIL
FROM TBL_CUSTOM
WHERE ADD_MONTHS(REG_DATE, 36) <= SYSDATE;



----���� 14. ī�װ��� �������� ���� ���� ī�װ��� --HAVING
--�� ī�װ� ��ǰ�� ���� ó�� ������ �����ھ��̵�� ���ų�¥�� ���Ͻÿ�		--WHERE					
SELECT CATEGORY, "������ ID", "���� ��¥"
FROM (SELECT CATEGORY, CUSTOMID AS "������ ID", BUY_DATE AS "���� ��¥"
        FROM TBL_BUY
        JOIN TBL_PRODUCT USING(PCODE)
        GROUP BY CATEGORY, CUSTOMID, BUY_DATE
        ORDER BY BUY_DATE, SUM(PRICE))
WHERE ROWNUM = 1;


-- (�̿���)
-- ���� 15. ���� ������ ������ ������ ��ȸ�ϰ��� �Ѵ�. ��ǰ 1���� ������ 20000�� �̻��̰�,
-- ȸ�� 1�� �� ������ ��ǰ�� �� �ݾ��� 100000�� �̻��� ���� ��ȸ�Ͻÿ�.
-- �̶� ȸ���ڵ�, ��ǰ�ڵ�, ��ǰ �̸�, ��ǰ ����, ������ ��ǰ ����, ������ ��ǰ�� �� �ݾ��� ��ȸ�Ͻÿ�."							
SELECT CUSTOM_ID, PCODE, PNAME, PRICE, QUANTITY , QUANTITY * PRICE AS "��������ǰ���ѱݾ�"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE QUANTITY * PRICE >= 100000
ORDER BY QUANTITY * PRICE ;


-- ���� 16. �� �⵵�� �Ǹ� ��θ� �����ϰ� �ִ�.
-- 23�⵵, 24�⵵�� �������� ���� ����, ��ǰ �̸�, ��ǰ ����, ���� ����, ��ǰ�� �� �ݾ��� ��ȸ�Ͻÿ�.
-- �Ǹ� ��δ� 23�⵵���� �����Ѵ�."							
SELECT BUY_DATE, PNAME, PRICE, QUANTITY, (PRICE * QUANTITY) AS ��_�ݾ�
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE SUBSTR(BUY_DATE, 1, 2) IN ('23', '24')
ORDER BY BUY_DATE;

-- (������)
-- ���� 17. ���̰� 20���� ȸ���� ������ ��ǰ �� �ݾ��� 20000�� �̻��� ��ǰ�鸸 �̾� ��ǰ�� ���űݾ��� ���� ���Ͻÿ�.							
SELECT SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE (AGE >=20 AND AGE < 30) AND PRICE >= 20000;

/*
���� 18. ����Ʈ������ �����ϰ��� �Ѵ�. ����Ʈ�� �̿� �ݾ׿� ����(0.1%) �����Ǹ�, 
������ ����Ʈ�� 10�� �̻���� 10�� ������ ���忡�� ����� �����ϴ�. 
(��, ����� ������ ����Ʈ�� 5000���� �Ѿ�� ����� ������)
�̶�, ����Ʈ ����� ������ ȸ���� �̸��� ������ ����Ʈ�� ��ȸ�Ͻÿ�.
- TBL_POINT ���̺��� ������ �� �����Ѵ�. �����ʹ� TBL_CUSTOM�� ��� �÷��� ������ ��, 
POINT �÷��� �߰��Ѵ�. (�ڷ����� NUMBER, �⺻���� 0���� �ش�.)
- POINT�� �� �� ���� ���� �ݾ� * 0.1 ���� ����Ѵ�.
*/

CREATE TABLE TBL_POINT
AS SELECT *
FROM TBL_CUSTOM;

SELECT * FROM TBL_POINT;

ALTER TABLE TBL_POINT ADD POINT NUMBER DEFAULT '0';

UPDATE TBL_POINT
SET POINT = (
    SELECT NVL(SUM(PRICE * QUANTITY) * 0.1, 0)  -- ���� �ݾ� * 0.1, ������ 0
    FROM TBL_BUY
    JOIN TBL_PRODUCT USING(PCODE)
    WHERE CUSTOMID = CUSTOM_ID
);


-- ����Ʈ�� 5000�� �̻��� ȸ���� �̸��� ������ ����Ʈ ��ȸ
SELECT NAME, POINT
FROM TBL_POINT
WHERE POINT >= 5000;


-- (��ȣ��)
--- ���� 19. �޹� 12���Կ� ���� ī�װ��� �����ִ� ��ǰ�� ������ ���� �̸�, ���̸� ����Ͻÿ�.
SELECT DISTINCT NAME, AGE
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOMID)
WHERE CATEGORY = (SELECT CATEGORY
                     FROM TBL_PRODUCT
                     WHERE PNAME = '�޹� 12����');


--- ���� 20. �̳����� ���� ��¥�� ������ ȸ���� �̸��� EMAIL�� ��ȸ�϶�. '�̳���'��� �̸��� ����ؼ� ��ȸ�ϵ��� �϶�. (��ȸ��� : �̳���, �̱浿)
SELECT NAME, EMAIL
FROM TBL_CUSTOM
WHERE REG_DATE = (SELECT REG_DATE
                  FROM TBL_CUSTOM
                  WHERE NAME = '�̳���');

-- (��â��)
--���� 21. �̸����� 'korea'�� �����, 'daum'�� ����� �̸�, ���� ǰ��, ������, ���� ����, ���� ��ǰ �� ������ ���� ��ȸ
-- �������� ���, ��ȸ �÷����� ��Ī ����, �̸� ������ ����"		
SELECT * FROM TBL_CUSTOM;

SELECT NAME AS "�̸�", PNAME AS "���� ǰ��", BUY_DATE AS "������", QUANTITY AS "���� ����", PRICE * QUANTITY AS "���Ź�ǰ�簡��������"
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE (EMAIL LIKE '%korea%') OR EMAIL LIKE '%daum%';


--���� 22. �� �������� 10���� �̻� ������ �����ڸ� ��ȸ	
SELECT NAME AS "�̸�", PNAME AS "���� ǰ��", BUY_DATE AS "������", QUANTITY AS "���� ����", PRICE * QUANTITY AS "���Ź�ǰ�簡��������"
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE (EMAIL LIKE '%korea%' OR EMAIL LIKE '%daum%') AND PRICE * QUANTITY >= 100000;

-- (������)
-- ���� 23. ��� ���� �̸�, ������ ��ǰ �̸�, �� ����(���� ���� * ��ǰ ����)�� ����Ѵ�. 
--�̶� �� ���鸶�� ������ �࿡�� ������ ��� ��ǰ�� ���� �� �ջ� �ݾ� ������ �־�� �ϸ�(�̶��� PNAME�� null),
--�� ������ �࿡�� ��� ���� �� ���� �ݾ��� �ջ��� ������ �־�� �Ѵ�.(�̶��� NAME, PNAME�� null)
--(ROLLUP �Լ� ���)
SELECT NAME, PNAME, SUM(PRICE * QUANTITY)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
GROUP BY ROLLUP(NAME, PNAME);

-- ���� 24. "2. 2023�� ���� �� 10���� �̻� ������ ���� ���� ������ ��ȸ�ϰ��� �Ѵ�.
--�� �̸�, ���̵�, 2023�� �� ���� �ݾ��� ��ȸ�Ͻÿ�."							
SELECT NAME, CUSTOM_ID, SUM(PRICE * QUANTITY) AS "2023�� �� ���� �ݾ�"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE TO_CHAR(BUY_DATE, 'YY') = '23'
GROUP BY NAME, CUSTOM_ID
HAVING SUM(PRICE * QUANTITY) >= 100000;

-- (������)
--���� 25. ��� ���� ������ ��ǰ, ������ ����, ��ǰ �� ����, ��ǰ �� �Ǹűݾ��հ踦 ���Ͻÿ�. 
--��� �� ǥ��Ǵ� ���� ��ǰ�̸�, ��ǰ�� �ǸŰ���, �ش� ��ǰ�� ���� ����, �Ǹűݾ��հ� '��' ǥ��Ǿ���Ѵ�. 	-- 6����� ����						

SELECT PCODE, SUM(QUANTITY), PRICE
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
GROUP BY PCODE, PRICE;


--���� 26. �Ǹŵ� ��ǰ�� ǥ��ǰ� �ϸ�, �߰��� �� ��ǰ���� ������ ���� ���ż����� ���Ͻÿ�. (�������� ����) -- 9����� ����
SELECT PCODE, CUSTOM_ID, QUANTITY
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
ORDER BY QUANTITY DESC;


