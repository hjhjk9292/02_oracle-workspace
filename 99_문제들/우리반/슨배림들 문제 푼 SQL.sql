-- ó���� ���������� �� �ش� ���̺���� ��� ������ ����� ��, ������ ������ ���� ����!

--���̺��� ����, � ���������� �����غ���, �� ���̺� Ŀ��Ʈ�� �ܴ�. (�׸���, ĸ���صд�)
SELECT * FROM TBL_BUY; -- ��������(���Ź�ȣ, �����̵�, ��ǰ�ڵ�, ��ǰ ���ż���, ���� ����)
SELECT * FROM TBL_CUSTOM; -- ��(�� ���̵�, �� �̸�, �̸���, ����, ���� ����)
SELECT * FROM TBL_PRODUCT; -- ��ǰ(��ǰ�ڵ�, ��ǰī�װ�, ��ǰ��, ����)

--COMMENT ON COLUMN ���̺��.�÷��� IS '�ּ�����';
COMMENT ON COLUMN TBL_BUY.BUY_IDX IS '���Ź�ȣ';
COMMENT ON COLUMN TBL_BUY.CUSTOMID IS '�� ���̵�';
COMMENT ON COLUMN TBL_BUY.PCODE IS '��ǰ�ڵ�';
COMMENT ON COLUMN TBL_BUY.QUANTITY IS '��ǰ ���ż���';
COMMENT ON COLUMN TBL_BUY.BUY_DATE IS '���� ����';

COMMENT ON COLUMN TBL_CUSTOM.CUSTOM_ID IS '�� ���̵�';
COMMENT ON COLUMN TBL_CUSTOM.NAME IS '�� �̸�';
COMMENT ON COLUMN TBL_CUSTOM.EMAIL IS '�̸���';
COMMENT ON COLUMN TBL_CUSTOM.AGE IS '����';
COMMENT ON COLUMN TBL_CUSTOM.REG_DATE IS '���� ����';

COMMENT ON COLUMN TBL_PRODUCT.PCODE IS '��ǰ�ڵ�';
COMMENT ON COLUMN TBL_PRODUCT.CATEGORY IS '��ǰī�װ�';
COMMENT ON COLUMN TBL_PRODUCT.PNAME IS '��ǰ��';
COMMENT ON COLUMN TBL_PRODUCT.PRICE IS '����';

/* A��  */
SELECT * FROM TBL_BUY; --   CUSTOMID    PCODE     QUANTITY    BUY_DATE
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID
SELECT * FROM TBL_PRODUCT;--            PCODE   PNAME   RRICE

--A-1. 'mina012' �� ������ ��ǰ �ݾ� �հ�(�̱���)
SELECT CUSTOMID, SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
GROUP BY CUSTOMID
HAVING CUSTOMID = 'mina012';

--A-2. �̸��� '�浿'�� ���� ȸ�� ������ ��ǰ ������Ȳ (������)
-- ������ �߰� �� �����ϼ���.
INSERT INTO TBL_CUSTOM 
			VALUES ('dongL','�̱浿','lee@daum.net',25,sysdate);
INSERT INTO TBL_BUY 
			VALUES (1008,'dongL','DOWON123A',2,sysdate);
COMMIT;

SELECT * FROM TBL_CUSTOM;
SELECT * FROM TBL_BUY;
			            
--A-3. `25��`�̻� ���Ե��� `����`�� `��ǰ��` ��ȸ�ϱ� (������) => ���̺� 3��
SELECT PNAME
FROM TBL_BUY
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID)
JOIN TBL_PRODUCT USING(PCODE)
WHERE AGE >= 25;
	
--A-4. ��ǰ�� '���' �ܾ ���Ե� ��ǰ�� ������ ���� ���� ��ǰ�� ���űݾ��� ���� ���ϱ�.(�����)
-- ������ �߰� �� �����ϼ���.
INSERT INTO TBL_PRODUCT
			VALUES ('BUSA211','B2','�λ� ��� 3kg �ڽ�',25000);
INSERT INTO TBL_BUY  
			VALUES (1009,'hongGD','BUSA211',2,TO_date('2024-01-03','yyyy-mm-dd'));
COMMIT;

SELECT * FROM TBL_BUY; -- CUSTOMID      PCODE
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID
SELECT * FROM TBL_PRODUCT;--            PCODE   PNAME   RRICE

SELECT SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE PNAME LIKE '%���%';

--A-5. �� �����ջ� �ݾ��� 100000~200000 ���� �� ID�� ��ȸ�Ͻÿ�.(���¿�)
SELECT CUSTOMID, PRICE * QUANTITY AS "�� �����ջ� �ݾ�"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE PRICE * QUANTITY >= 10000 AND PRICE * QUANTITY <= 20000;


/*  B�� */
--B-1. 20�� ���� ���� ���� ��ǰ �ڵ�� ���̸� ���̼����� ���� ��ȸ (�̴�ȯ)
SELECT PCODE, AGE
FROM TBL_BUY
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
WHERE AGE >= 20 AND AGE < 30
ORDER BY AGE DESC;

----B-2. ���̰� ���� ���� ���� ��ǰ�� ������ Ƚ���� ��ȸ�ϼ���.-�������� ����ϱ� (�����)
SELECT MAX(AGE), COUNT(QUANTITY) AS "��ǰ����Ƚ��"
FROM TBL_BUY
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOM_ID);


----B-3. 2023�� �Ϲݱ� ���űݾ��� ��ID���� ��ȸ�Ͻÿ�. �ݾ��� ���� �������� ��ȸ�ϼ���. (����) -- �Ϲݱ� ����
SELECT CUSTOMID, PRICE
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE SUBSTR(BUY_DATE, 1,2) = '23'
ORDER BY PRICE DESC;


--B-4. 2024�⿡ ����Ƚ���� 1ȸ �̻��� ��id, ���̸�, ����,�̸����� ��ȸ�ϼ���.(������)
SELECT CUSTOM_ID, NAME, EMAIL, BUY_DATE
FROM TBL_CUSTOM
JOIN TBL_BUY ON (CUSTOM_ID = CUSTOMID)
WHERE SUBSTR(BUY_DATE, 1,2) = '24';


---B-5. ����-��ǰ�� ���űݾ��� ��ȸ�ϼ���. ���ĵ� ��ID,��ǰ�ڵ� ������������ �����ϼ���.(�̿���)
SELECT CUSTOMID, PCODE, SUM(PRICE)
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
GROUP BY CUSTOMID, PCODE
ORDER BY 1, 2 ;


/* C�� */
---C-1. ���� 1���� �̻��� ��ǰ�� ���� ���� ������ ������ ��� ������ ����Ͻÿ�.��ǰ�ڵ� ������ ���� (������)
SELECT * FROM TBL_BUY; -- CUSTOMID      PCODE                   QUANTITY
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID
SELECT * FROM TBL_PRODUCT;--            PCODE   PNAME   RRICE

SELECT PCODE, AVG(QUANTITY) AS "��� ����"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE PRICE >= 10000
GROUP BY PCODE
ORDER BY PCODE;
	 
	 
--C-2. ������� ������ ���� �̸�, ���ż���, ���ų�¥�� ��ȸ����. (������ : ������)
SELECT NAME AS �̸�, QUANTITY AS ���ż���, BUY_DATE AS ���ų�¥
FROM TBL_BUY
JOIN TBL_CUSTOM ON (CUSTOMID = CUSTOM_ID)
JOIN TBL_PRODUCT USING (PCODE)
WHERE PNAME LIKE '�����%';


--C-4. 2023�⿡ �ȸ� ��ǰ�� �̸��� �ڵ�, �� �Ǹž� �׸��� �� �ǸŰ����� ��ǰ�ڵ� ������ �����Ͽ� ��ȸ�Ͻÿ�. (������)
SELECT PNAME, PCODE, SUM(PRICE * QUANTITY) AS "�� �Ǹž�", COUNT(QUANTITY) AS "�� �ǸŰ���" 
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE SUBSTR(BUY_DATE, 1,2) = '23'
GROUP BY PNAME, PCODE
ORDER BY PCODE;


--C-5. 'twice'�� 'hongGD'�� ������ ��� �ֽ��ϴ�. �̵��� ������ ��ǰ,����,������ ��ȸ�ϼ���.-������ ������������ ���� (�强��)
SELECT PNAME, QUANTITY, PRICE
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE CUSTOMID in('twice','hongGD')
ORDER BY PRICE DESC;


/* D�� */
--D-1. ������� ���� ���� ������ ȸ���� ���űݾ��� ���� ������ ȸ�����̵�� �� ����� ���űݾ��� �����ּ���.(���Ͽ�)
-- 							�� �������� ���� ���θ� ���

SELECT CUSTOMID AS "ȸ�� ���̵�", PRICE * QUANTITY AS "�� ���űݾ�"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
WHERE PCODE = 'JINRMN5'
ORDER BY PRICE DESC;


----D-2. �Ǹ� ������ ���� ���� ������ ��ǰ �� �����ϰ� �� �ȸ� �ݾ��� ����Ͻÿ�.(������)
-- 	   �Ǹ� ������ ������ ��ǰ �ڵ� ������ �����մϴ�.			�� ���� �������� ��ȸ

SELECT PCODE, QUANTITY, PRICE * QUANTITY AS "�� �ȸ��ݾ�"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
ORDER BY QUANTITY DESC, PCODE;


---D-3. ������� ������ ������ ��� ���̸� ��ǰ�ڵ�(PCODE)�� �Բ� ����� �ּ���.(Ȳ����)
SELECT * FROM TBL_BUY; -- CUSTOMID      PCODE
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID
SELECT * FROM TBL_PRODUCT;--            PCODE   PNAME   RRICE

SELECT PCODE "��ǰ�ڵ�", AVG(AGE) "��� ����"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOMID)
WHERE PNAME LIKE '%�����%'
GROUP BY PCODE;

---D-4. 30�� �̸� ȸ���� ���űݾ��� ���ϰ� ȸ������ �׷�����ؼ� ���űݾ� �հ谡 ū ������ ����(������)
-- 						�� 3���� ���̺� ����
SELECT CUSTOMID , SUM(PRICE * QUANTITY) "���űݾ� �հ�"
FROM TBL_BUY
JOIN TBL_PRODUCT USING(PCODE)
JOIN TBL_CUSTOM ON(CUSTOMID = CUSTOMID)
WHERE AGE < 30
GROUP BY CUSTOMID
ORDER BY 2 DESC;


SELECT * FROM TBL_BUY; --   CUSTOMID    PCODE     QUANTITY    BUY_DATE
SELECT * FROM TBL_CUSTOM;-- CUSTOM_ID
SELECT * FROM TBL_PRODUCT;--            PCODE   PNAME   RRICE

-- �������� 3�� �̻������ �ֱ� 1�� �� �� ���űݾ��� 10���� �̻��� ������ �̺�Ʈ�� �����Ϸ��� �Ѵ�. �ش��ϴ� ����?


-- 
