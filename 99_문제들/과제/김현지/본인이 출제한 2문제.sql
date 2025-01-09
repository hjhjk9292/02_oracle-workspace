--������ ������ 2���� 
/*
����1. ���� ��¥ �������� �������� 2�� �̻������ �ֱ� 1�� �� �� ���űݾ��� 5���� �̻��� ������ �̺�Ʈ�� �����Ϸ��� �Ѵ�. 
�ش��ϴ� ���� ���̵�, �̸�, �� ���űݾ��� ��ȸ�Ͻÿ�.
*/
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

/*
����2. 2023��� 2024�⵵���� �Ǹŵ� ��ǰ�� �̸��� ��ǰ���ż����� �ش� ��ǰ�� ������ �� ���� ��ȸ�Ͻÿ�. 
��� ����� �⵵�� ������������ �����ϰ�, ��ǰ���ż����� ������ �� ���� ������������ �����Ѵ�.
*/
SELECT TO_CHAR(BUY_DATE, 'YYYY') AS YEAR, 
       PNAME, 
       COUNT(QUANTITY) AS "��ǰ���ż���", 
       COUNT(CUSTOMID) AS "������ �� ��"
FROM TBL_BUY
JOIN TBL_PRODUCT USING (PCODE)
WHERE TO_CHAR(BUY_DATE, 'YYYY') IN ('2023', '2024')
GROUP BY TO_CHAR(BUY_DATE, 'YYYY'), PNAME
ORDER BY YEAR ASC, "��ǰ���ż���" DESC, "������ �� ��" DESC;


