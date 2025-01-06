--3. �������� 25�� �̻��� å ��ȣ�� �������� ȭ�鿡 ����ϴ� SQL ���� �ۼ��Ͻÿ�. 
SELECT * FROM TB_BOOK;

SELECT BOOK_NO, BOOK_NM
FROM TB_BOOK
WHERE LENGTH(BOOK_NM) >= 25;

---4. �޴��� ��ȣ�� ��019���� �����ϴ� �达 ���� ���� �۰��� �̸������� �������� �� 
--���� ���� ǥ�õǴ� �۰� �̸��� �繫�� ��ȭ��ȣ, �� ��ȭ��ȣ, �޴��� ��ȭ��ȣ�� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. 
SELECT * FROM TB_WRITER; -- WIRTER_NM, OFFICE_TELNO, HOME_TELNO, MOBILE_NO

SELECT WRITER_NM, OFFICE_TELNO, HOME_TELNO, MOBILE_NO
FROM (
    SELECT WRITER_NM, OFFICE_TELNO, HOME_TELNO, MOBILE_NO
    FROM TB_WRITER
    WHERE MOBILE_NO LIKE '019%' AND WRITER_NM LIKE '��%'
    ORDER BY WRITER_NM
)
WHERE ROWNUM = 1; -- �������� �ۼ�, WHERE���� ROUWNUM = 1


--5. ���� ���°� ���ű衱�� �ش��ϴ� �۰����� �� �� ������ ����ϴ� SQL ������ �ۼ��Ͻÿ�. 
--(��� ����� ���۰�(��)������ ǥ�õǵ��� �� ��)  
SELECT * FROM TB_BOOK_AUTHOR;

SELECT COUNT(DISTINCT WRITER_NO) AS "�۰�(��)"
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE = '�ű�';

---6. 300�� �̻� ��ϵ� ������ ���� ���� �� ��ϵ� ���� ������ ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
--(���� ���°� ��ϵ��� ���� ���� ������ ��) 
SELECT * FROM TB_BOOK_AUTHOR;
SELECT * FROM TB_BOOK;

SELECT COMPOSE_TYPE, COUNT(*) AS STOCK_QTY -- ��Ī���� �����
FROM TB_BOOK
JOIN TB_BOOK_AUTHOR USING (BOOK_NO)
WHERE COMPOSE_TYPE IS NOT NULL
GROUP BY COMPOSE_TYPE -- �׷����� �����
HAVING COUNT(*) >= 300; -- ��Ī���� ���� �� ��������

--SELECT COMPOSE_TYPE, COUNT(STOCK_QTY)
--FROM TB_BOOK
--JOIN TB_BOOK_AUTHOR USING (BOOK_NO)
--WHERE COMPOSE_TYPE IS NOT NULL; -- ����


---7. ���� �ֱٿ� �߰��� �ֽ��� �̸��� ��������, ���ǻ� �̸��� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. 
SELECT * FROM TB_BOOK; --BOOK_NM, ISSUE_DATE, PUBLISHER_NM

SELECT MAX(ISSUE_DATE)
FROM TB_BOOK; -- ���� �ֱٿ� �߰��� �ֽ��� ���� ����

SELECT BOOK_NM, ISSUE_DATE, PUBLISHER_NM
FROM TB_BOOK
WHERE ISSUE_DATE = (SELECT MAX(ISSUE_DATE) 
                          FROM TB_BOOK); -- ��������


----8. ���� ���� å�� �� �۰� 3���� �̸��� ������ ǥ���ϵ�, ���� �� ������� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. 
--��, ��������(��٣���) �۰��� ���ٰ� �����Ѵ�. (��� ����� ���۰� �̸���, ���� ������ ǥ�õǵ��� �� ��)  
SELECT * FROM tb_writer WHERE WRITER_NM = 'Ȳ����'; -- WRITER_NO, WRITER_NM
SELECT * FROM tb_book_author; -- WRITER_NO, BOOK_NO

SELECT "�۰� �̸�", "�� ��"
FROM TB_WRITER (SELECT WRITER_NM AS "�۰� �̸�", COUNT(BOOK_NO) AS "�� ��"
                 FROM TB_WRITER
                 JOIN TB_BOOK_AUTHOR USING (WRITER_NO) 
                 GROUP BY WRITER_NM
                 ORDER BY COUNT(BOOK_NO) DESC
             )
WHERE ROWNUM <= 3;


----9. �۰� ���� ���̺��� ��� ������� �׸��� �����Ǿ� �ִ� �� �߰��Ͽ���. 
--������ ������� ���� �� �۰��� ������ ���ǵ����� �����ϰ� ������ ��¥���� �����Ű�� SQL ������ �ۼ��Ͻÿ�. 
--(COMMIT ó���� ��) �� ���ڿ��� ��¥�� ��ȯ?
SELECT * FROM TB_WRITER; -- REGIST_DATE ������� (����) / WRITER_NO
SELECT * FROM TB_BOOK; -- ISSUE_DATE ���� ���ǵ����� ������ / BOOK_NO
SELECT * FROM TB_BOOK_AUTHOR; -- BOOK_NO, WRITER_NO

UPDATE TB_WRITER
SET REGIST_DATE = (
    SELECT MIN(ISSUE_DATE)
    FROM TB_BOOK_AUTHOR
    JOIN TB_BOOK USING (BOOK_NO)
    JOIN TB_WRITER USING (WRITER_NO)
    GROUP BY WRITER_NM
)
WHERE REGIST_DATE IS NULL;


ROLLBACK;

SELECT * FROM TB_WRITER;

COMMIT;


----10. ���� �������� ���� ���̺��� ������ �������� ���� ���� �����ϰ� �ִ�. �����δ� �������� ���� �����Ϸ��� �Ѵ�. 
-- ���õ� ���뿡 �°� ��TB_BOOK_ TRANSLATOR�� ���̺��� �����ϴ� SQL ������ �ۼ��Ͻÿ�. 
--(Primary Key ���� ���� �̸��� ��PK_BOOK_TRANSLATOR���� �ϰ�, 
--Reference ���� ���� �̸��� ��FK_BOOK_TRANSLATOR_01��, ��FK_BOOK_TRANSLATOR_02���� �� ��)

    CREATE TABLE TB_BOOK_TRANSLATOR (
    BOOK_NO VARCHAR2(10) NOT NULL,
    WRITER_NO VARCHAR2(10) NOT NULL,
    TRANS_LANG VARCHAR2(60),
    CONSTRAINT PK_BOOK_TRANSLATOR PRIMARY KEY (BOOK_NO, WRITER_NO),
    CONSTRAINT FK_BOOK_TRANSLATOR_01 FOREIGN KEY (BOOK_NO) REFERENCES TB_BOOK (BOOK_NO),
    CONSTRAINT FK_BOOK_TRANSLATOR_02 FOREIGN KEY (WRITER_NO) REFERENCES TB_WRITER (WRITER_NO)
);

SELECT * FROM TB_BOOK_TRANSLATOR;

--11. ���� ���� ����(compose_type)�� '�ű�', '����', '��', '����'�� �ش��ϴ� �����ʹ� 
--���� ���� ���� ���̺��� ���� ���� ���� ���̺�(TB_BOOK_ TRANSLATOR)�� �ű�� SQL ������ �ۼ��Ͻÿ�. 
--��, ��TRANS_LANG�� �÷��� NULL ���·� �ε��� �Ѵ�. 
--(�̵��� �����ʹ� �� �̻� TB_BOOK_AUTHOR ���̺� ���� ���� �ʵ��� ������ ��) 
SELECT * FROM TB_BOOK_AUTHOR;



-- TB_BOOK_TRANSLATOR�� ������ ����
INSERT INTO TB_BOOK_TRANSLATOR (BOOK_NO, WRITER_NO, TRANS_LANG)
SELECT BOOK_NO, WRITER_NO, NULL
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE IN ('�ű�', '����', '��', '����');

-- TB_BOOK_AUTHOR���� ������ ����
DELETE FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE IN ('�ű�', '����', '��', '����');

ROLLBACK;

SELECT * FROM TB_BOOK_TRANSLATOR;
SELECT * FROM TB_BOOK_AUTHOR;

----12. 2007�⵵�� ���ǵ� ������ �̸��� ������(����)�� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. 
SELECT * FROM TB_BOOK; -- BOOK_NM, ISSUE_DATE
SELECT * FROM TB_BOOK_AUTHOR; -- BOOK_NO, WRITER_NO
SELECT * FROM TB_WRITER; -- WRITER_NM, WRITER_NO

SELECT BOOK_NM, WRITER_NM, ISSUE_DATE
FROM TB_BOOK_AUTHOR
JOIN TB_BOOK USING(BOOK_NO)
JOIN TB_WRITER USING(WRITER_NO)
WHERE BOOK_NO LIKE '2007%' AND COMPOSE_TYPE = '�ű�';


--14. ���ο� ���ǻ�(�� ���ǻ�)�� �ŷ� ����� �ΰ� �Ǿ���. 
--���õ� ���� ������ �Է��ϴ� SQL ������ �ۼ��Ͻÿ�.(COMMIT ó���� ��) 
--���ǻ�       �繫����ȭ��ȣ     �ŷ����� 
--�� ���ǻ�     02-6710-3737    Default �� ��� 
SELECT * FROM TB_PUBLISHER;

INSERT INTO TB_PUBLISHER VALUES ('�� ���ǻ�', '02-6710-3737', DEFAULT); -- ���� ��

COMMIT; -- �����ؾ���

--15. ��������(��٣���) �۰��� �̸��� ã������ �Ѵ�. �̸��� �������� ���ڸ� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. 
SELECT * FROM TB_WRITER;

SELECT WRITER_NM, COUNT(*)
FROM TB_WRITER
GROUP BY WRITER_NM
HAVING COUNT(*) > 1
ORDER BY 1; --�۰��̸����� �׷� ���� COUNT(*) ����� 1 �̻��� �� ��ȸ

--16. ������ ���� ���� �� ���� ����(compose_type)�� ������ �����͵��� ���� �ʰ� �����Ѵ�. 
--�ش� �÷��� NULL�� ��� '����'���� �����ϴ� SQL ������ �ۼ��Ͻÿ�.(COMMIT ó���� ��)  



--17. �������� �۰� ������ �����Ϸ��� �Ѵ�. �繫���� �����̰�, �繫�� ��ȭ ��ȣ ������ 3�ڸ��� 
--�۰��� �̸��� �繫�� ��ȭ ��ȣ�� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. 
SELECT * FROM TB_WRITER;
SELECT * FROM TB_PUBLISHER;

SELECT WRITER_NM, OFFICE_TELNO
FROM TB_WRITER
WHERE OFFICE_TELNO LIKE '02%' AND OFFICE_TELNO LIKE '02-___-%';

---18. 2006�� 1�� �������� ��ϵ� �� 31�� �̻� �� �۰� �̸��� �̸������� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. -- 9�� Ǯ�����
SELECT * FROM TB_WRITER; -- REGIST_DATE

SELECT WRITER_NM
FROM TB_WRITER
WHERE 
ORDER BY WRITER_NM;


---19. ���� ��� �ٽñ� �α⸦ ��� �ִ� 'Ȳ�ݰ���' ���ǻ縦 ���� ��ȹ���� ������ �Ѵ�. 
--'Ȳ�ݰ���' ���ǻ翡�� ������ ���� �� ��� ������ 10�� �̸��� ������� ����, �����¸� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. 
--��� ������ 5�� �̸��� ������ ���߰��ֹ��ʿ䡯��, �������� ���ҷ��������� ǥ���ϰ�, 
--�������� ���� ��, ������ ������ ǥ�õǵ��� �Ѵ�.  
SELECT * FROM TB_PUBLISHER; -- PUBLISHER_NM
SELECT * FROM TB_BOOK; --PUBLISHER_NM / STOCK_QTY ������

SELECT BOOK_NM, PRICE, STOCK_QTY
FROM TB_BOOK
JOIN TB_PUBLISHER USING(PUBLISHER_NM)
WHERE PUBLISHER_NM = 'Ȳ�ݰ���' AND STOCK_QTY < 10 -- CASE WHEN THEN ���??
ORDER BY STOCK_QTY DESC, BOOK_NM;

--20.  '��ŸƮ��' ���� �۰��� ���ڸ� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. 
--(��� ����� ��������,�����ڡ�,�����ڡ��� ǥ���� ��) 
SELECT * FROM TB_BOOK; -- BOOK_NM, ISSUE_DATE
SELECT * FROM TB_BOOK_AUTHOR; -- BOOK_NO, WRITER_NO
SELECT * FROM TB_WRITER; -- WRITER_NM, WRITER_NO

SELECT BOOK_NM AS ������, WRITER_NM AS ����
FROM TB_BOOK_AUTHOR
JOIN TB_BOOK USING(BOOK_NO)
JOIN TB_WRITER USING(WRITER_NO)
WHERE BOOK_NM = '��ŸƮ��';



--21. ���� �������� ���� �����Ϸκ��� �� 30���� ����ǰ�, ��� ������ 90�� �̻��� ������ ���� 
--������, ��� ����, ���� ����, 20% ���� ������ ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. 
--(��� ����� ��������, ����� ������, ������(Org)��, ������(New)���� ǥ���� ��. 
--��� ������ ���� ��, ���� ������ ���� ��, ������ ������ ǥ�õǵ��� �� ��)