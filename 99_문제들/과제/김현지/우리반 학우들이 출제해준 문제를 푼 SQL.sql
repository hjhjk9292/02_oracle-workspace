/*
 H �п�� �����ͺ��̽� 
*/
SELECT * FROM TBL_BUY; --   CUSTOMID    PCODE     QUANTITY    BUY_DATE  BUY_IDX
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID        NAME    EMAIL          REG_DATE
SELECT * FROM TBL_PRODUCT;--            PCODE   CATEGORY  PNAME   RRICE

							
-- ����1. 2023�� ���� ������ ���� �߿���, �� ���� ������ ��ǰ�� ��� ���� �ݾ��� 20,000�� �̻��� ������ �� ID�� �̸��� ��ȸ�Ͻÿ�.							
SELECT CUSTOM_ID, NAME, SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE SUBSTR(BUY_DATE, 1, 2) = '23'
GROUP BY CUSTOM_ID, NAME
HAVING AVG(PRICE) >= 20000;


-- ����2. "2023�� �Ϲݱ�  ���� '��'�̶�� �ܾ ���Ե� ��ǰ�� ������ ������ �̸�, ����, �̸����� ��ȸ�Ͻÿ�.
--��, �� ���� ������ ���� ��ǰ�� ���� ���� ������ ���� ���ϰ�, ���� ������ ���� ������ �����Ͻÿ�."							
SELECT NAME, AGE, EMAIL
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE (SUBSTR(BUY_DATE, 1, 2) = '23') AND PNAME LIKE '%��%'
GROUP BY NAME, AGE, EMAIL
ORDER BY SUM(QUANTITY) DESC;


-- ���� 3. 1)DATA_TYPE�� CHAR(2)�� CATEGORY_ID�� DATA_TYPE�� VARCHAR2(20)�� CATEGORY_NAME�� �����ִ� TBL_CATEGORY��� ���̺��� ������
-- �̶� CATEGORY_ID�� PRIMARY KEY�� ����� �������Ǹ��� CATEGORY_PK�� �����,
-- CATEGORY_ID�� COMMENT�� CATEGORY_ID��, CATEGORY_NAME�� COMMENT�� CATRGORY_NAME�� �����,
-- ���̺� ('A1', '����') �����Ϳ� ('B1', '��Ÿ') �����͸� �־��"
-- (�� ������ �� �������� Ǫ����!! ī�װ� �����Ͱ� �����ؼ� �ٸ� �е� ������ ��� �ٸ��� ���� �� �ֽ��ϴ�,,,)

CREATE TABLE TBL_CATEGORY (
    CATEGORY_ID CHAR(2) PRIMARY KEY,
    CATEGORY_NAME VARCHAR2(20),
    CONSTRAINT CATEGORY_PK PRIMARY KEY (CATEGORY_ID)
);



COMMENT ON COLUMN TBL_CATEGORY.CATEGORY_ID IS 'CATEGORY_ID';
COMMENT ON COLUMN TBL_CATEGORY.CATEGORY_NAME IS 'CATEGORY_NAME';

INSERT INTO TBL_CATEGORY (CATEGORY_ID, CATEGORY_NAME) 
VALUES ('A1', '����'), ('B1', '��Ÿ');

--���� 4.-- 2_1)���ϵ��� ������ A1���� �����ϰ�, �� ���� �͵��� B1���� �����Ͽ���
-- 2_2)TBL_PRODUCT�� CATEGORY�� TBL_CATEGORY�� CATEGORY_ID�� �����ϴ� �ܷ�Ű�� ����� ������ ������ �ڽ� �����͵� �����ǰ� �Ͽ���
-- (�̶� �������Ǹ��� CATEGOTY_ID_FK�� �Ͽ���)"							

UPDATE TBL_CATEGORY
SET CATEGORY_ID =


-- ����5. "CATEGORY �����Ϳ� 'B' ���ԵǾ� �ִ� ��ǰ�� ������ ȸ������ �̸�, ���� ��ǰ �̸��� ���Ź�ǰ�� �� ���� ��ȸ�Ͻÿ�.
--(ȸ���̸����� ���� ���� ����, �� ������ '�� ���űݾ�'���� ��Ī ����)"

SELECT NAME, PANME, SUM(PRICE) AS "�ѱ��űݾ�"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE CATEGORY LIKE '%B%'
ORDER BY NAME;


---- ����6. "ȸ������ �� ���� ���� ������ ��ǰ��� �� ��ǰ�� �� ���� ������ ���� ��ǰ�� ��ȸ�ҷ��� �Ѵ�. 
-- ����, ��ǰ�̸�, ���� �� ���� ��� ��ǰ ������ ��ȸ�Ͻÿ�.
--(�߰� ����� �� ���迡�� ��ǰ �̸��� '���� ��� ��ǰ�� ����' ������ ��µǵ��� �ۼ�, ���� �������� �������� ����)"							

SELECT AGE, PNAME , MAX(PRICE) AS "���� ��� ��ǰ�� ����"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
GROUP BY AGE, PNAME
ORDER BY 1;

						
--���� 7. �̸��� ��̳��� ����� ������ ��ǰ�߿� �ι�°�� ���� ���� ��ǰ�ڵ�, ��ǰ��, ����, ����
-- ���� ������ ���� �� �Ѵ� ��� RANK()OVER�� ������"
SELECT PCODE, PNAME, PRICE, QUANTITY
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE NAME = '��̳�';
   
                        	
--���� 8. ��ǰ �ڵ� �� ������ �����(BUY_DATE)�� �հ踦 ���Ͻÿ�
--ROLL UP ��� / UNION ALL ��� 
--UNION ALL�������� �׳� ROLLUP�� ������"	



-- ���� 9. �� ī�װ����� ���� ������ ������ ��ǰ���� ��ǰ �ڵ�� �ش� ī�װ� �̸��� ���ϴ� SQL ����




/* ���� 10. "�� ���� �ݾ׿� ���� ȸ�� ����� ������ ���� �з��˴ϴ�:

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


-- ���� 11. 2025�� ����, �������� 3�� �̻� �� �����ڵ��� ���̵�, �̸�, �̸����� ��ȸ�϶�
-- (�̶� �̸��� '@' �޹��ڵ��� *�� ǥ�õǰ� ��ȸ�ض�) 	


SELECT CUSTOM_ID, NAME, PPAD(SUBSTR(EMAIL, 1, 8, 10,'*')
FROM TBL_CUSTOM;



SELECT CUSTOM_ID, NAME, SUM(PRICE * QUANTITY) AS "�� ���űݾ�"
FROM TBL_CUSTOM
JOIN TBL_BUY ON (CUSTOM_ID = CUSTOMID)
JOIN TBL_PRODUCT USING(PCODE)
WHERE ADD_MONTHS(REG_DATE, 24) <= SYSDATE -- �������� 2�� �̻�
  AND BUY_DATE >= ADD_MONTHS(SYSDATE, -12) -- �ֱ� 1�� ��
GROUP BY CUSTOM_ID, NAME
HAVING SUM(PRICE * QUANTITY) >= 50000;

----���� 12. ī�װ��� �������� ���� ���� ī�װ��� 
--�� ī�װ� ��ǰ�� ���� ó�� ������ �����ھ��̵�� ���ų�¥�� ���Ͻÿ�							



-- ���� 13. ���� ������ ������ ������ ��ȸ�ϰ��� �Ѵ�. ��ǰ 1���� ������ 20000�� �̻��̰�,
-- ȸ�� 1�� �� ������ ��ǰ�� �� �ݾ��� 100000�� �̻��� ���� ��ȸ�Ͻÿ�.
-- �̶� ȸ���ڵ�, ��ǰ�ڵ�, ��ǰ �̸�, ��ǰ ����, ������ ��ǰ ����, ������ ��ǰ�� �� �ݾ��� ��ȸ�Ͻÿ�."							
SELECT CUSTOM_ID, PCODE, PNAME, PRICE, QUANTITY , QUANTITY * PRICE AS "��������ǰ���ѱݾ�"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE QUANTITY * PRICE >= 100000;


-- ���� 14. �� �⵵�� �Ǹ� ��θ� �����ϰ� �ִ�.
-- 23�⵵, 24�⵵�� �������� ���� ����, ��ǰ �̸�, ��ǰ ����, ���� ����, ��ǰ�� �� �ݾ��� ��ȸ�Ͻÿ�.
-- �Ǹ� ��δ� 23�⵵���� �����Ѵ�."							
SELECT BUY_DATE, PNAME, PRICE, QUANTITY, (PRICE * QUANTITY) AS ��_�ݾ�
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE SUBSTR(BUY_DATE, 1, 2) IN ('23', '24')
ORDER BY BUY_DATE;


-- ���� 15. ���̰� 20���� ȸ���� ������ ��ǰ �� �ݾ��� 20000�� �̻��� ��ǰ�鸸 �̾� ��ǰ�� ���űݾ��� ���� ���Ͻÿ�.							
SELECT SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE (AGE >=20 AND AGE < 30) AND PRICE >= 20000;

/*
���� 16. ����Ʈ������ �����ϰ��� �Ѵ�. ����Ʈ�� �̿� �ݾ׿� ����(0.1%) �����Ǹ�, 
������ ����Ʈ�� 10�� �̻���� 10�� ������ ���忡�� ����� �����ϴ�. 
(��, ����� ������ ����Ʈ�� 5000���� �Ѿ�� ����� ������)
�̶�, ����Ʈ ����� ������ ȸ���� �̸��� ������ ����Ʈ�� ��ȸ�Ͻÿ�.
- TBL_POINT ���̺��� ������ �� �����Ѵ�. 
�����ʹ� TBL_CUSTOM�� ��� �÷��� ������ ��, POINT �÷��� �߰��Ѵ�. (�ڷ����� NUMBER, �⺻���� 0���� �ش�.)
- POINT�� �� �� ���� ���� �ݾ� * 0.1 ���� ����Ѵ�.
*/

-- ���� 17. �޹� 12���Կ� ���� ī�װ��� �����ִ� ��ǰ�� ������ ���� �̸�, ���̸� ����Ͻÿ�.

SELECT NAME, AGE
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE CATEGORY = 'B1';


-- ���� 18. �̳����� ���� ��¥�� ������ ȸ���� �̸��� EMAIL�� ��ȸ�϶�. '�̳���'��� �̸��� ����ؼ� ��ȸ�ϵ��� �϶�. (��ȸ��� : �̳���, �̱浿)
SELECT REG_DATE
FROM TBL_CUSTOM
WHERE NAME = '�̳���';

--SELECT NAME, EMAIL
--FROM TBL_CUSTOM
--WHERE REG_DATE = (SELECT REG_DATE
--                    FROM TBL_CUSTOM
--                    WHERE NAME = '�̳���'
--                  );


--���� 19. �̸����� 'korea'�� �����, 'daum'�� ����� �̸�, ���� ǰ��, ������, ���� ����, ���� ��ǰ �� ������ ���� ��ȸ
-- �������� ���, ��ȸ �÷����� ��Ī ����, �̸� ������ ����"		
SELECT NAME "�̸�", PANME AS "���� ǰ��", BUY_DATE AS "������", QUANTITY AS "���� ����", (PRICE * QUANTITY) AS "���Ź�ǰ�簡��������"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
WHERE EMAIL LIKE '%KOREA%';


--���� 20. �� �������� 10���� �̻� ������ �����ڸ� ��ȸ	



-- ���� 21. ��� ���� �̸�, ������ ��ǰ �̸�, �� ����(���� ���� * ��ǰ ����)�� ����Ѵ�. 
--�̶� �� ���鸶�� ������ �࿡�� ������ ��� ��ǰ�� ���� �� �ջ� �ݾ� ������ �־�� �ϸ�(�̶��� PNAME�� null),
--�� ������ �࿡�� ��� ���� �� ���� �ݾ��� �ջ��� ������ �־�� �Ѵ�.(�̶��� NAME, PNAME�� null)
--(ROLLUP �Լ� ���)



-- ���� 22. "2. 2023�� ���� �� 10���� �̻� ������ ���� ���� ������ ��ȸ�ϰ��� �Ѵ�.
--�� �̸�, ���̵�, 2023�� �� ���� �ݾ��� ��ȸ�Ͻÿ�."							
SELECT NAME, CUSTOM_ID, (PRICE * QUANTITY) AS "2023�� �� ���� �ݾ�"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE SUBSTR(BUY_DATE, 1, 2) = '23' AND QUANTITY * PRICE >= 100000;



--���� 23. ��� ���� ������ ��ǰ, ������ ����, ��ǰ �� ����, ��ǰ �� �Ǹűݾ��հ踦 ���Ͻÿ�. 
--��� �� ǥ��Ǵ� ���� ��ǰ�̸�, ��ǰ�� �ǸŰ���, �ش� ��ǰ�� ���� ����, �Ǹűݾ��հ� '��' ǥ��Ǿ���Ѵ�. 							

SELECT PNAME, QUANTITY, PRICE, QUANTITY * PRICE
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID);


--���� 24. �Ǹŵ� ��ǰ�� ǥ��ǰ� �ϸ�, �߰��� �� ��ǰ���� ������ ���� ���ż����� ���Ͻÿ�. (�������� ����)


