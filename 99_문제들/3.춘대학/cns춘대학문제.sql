----- [Basic SELECT] �Ϸ�

--1. �� ������б��� �а� �̸��� �迭�� ǥ���Ͻÿ�.
-- ��, ��� ����� "�а� ��", "�迭" ���� ǥ���ϵ��� �Ѵ�.
SELECT * FROM TB_CLASS;
SELECT * FROM TB_DEPARTMENT;

SELECT DEPARTMENT_NAME AS "�а� ��", CATEGORY AS "�迭"
FROM TB_DEPARTMENT;


---2.  �а��� �а� ������ ������ ���� ���·� ȭ�鿡 ����Ѵ�.
-- ��Ʈ : ���� ������ �̿��ؼ� || �� 2�� �̻� ����
--CONCAT(STRING, STRING) : 2���� ���� �� ����

SELECT DEPARTMENT_NAME || '�� ������' AS "�а���", CAPACITY || '�� �Դϴ�.' AS "����"
FROM TB_DEPARTMENT;
--WHERE DEPARTMENT_NAME ||'�� ������' CAPACITY '�� �Դϴ�.' ;

--SELECT DEPARTMENT_NAME AS "�а���", CAPACITY AS "����"
--FROM TB_DEPARTMENT;
--WHERE CONCAT(DEPARTMENT_NAME '�� ������', CAPACITY '�� �Դϴ�.') ;



--3. "������а�" �� �ٴϴ� ���л� �� ���� �������� ���л��� ã�ƴ޶�� ��û�� ���Դ�. 
-- �����ΰ�? (�����а��� '�а��ڵ�'�� �а� ���̺�(TB_DEPARTMENT)�� ��ȸ�ؼ� ã�� ������ ����)
SELECT * FROM TB_STUDENT;      -- DEPARTMENT_NO
SELECT * FROM TB_DEPARTMENT;   -- DEPARTMENT_NO 001

SELECT STUDENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NO = '001' AND SUBSTR(STUDENT_SSN, 8 ,1) IN ('2', '4') AND ABSENCE_YN = 'Y';


--4. ���������� ���� ���� ��� ��ü�� ���� ã�� �̸��� �Խ��ϰ��� �Ѵ�. 
--�� ����ڵ��� �й��� ������ ���� �� ����ڵ��� ã�� ������ SQL ������ �ۼ��Ͻÿ�. 
--  A513079, A513090, A513091, A513110, A513119
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
ORDER BY STUDENT_NAME DESC;


-- 5. ���������� 20�� �̻� 30�� ������ �а����� �а� �̸��� �迭�� ����Ͻÿ�.
SELECT * FROM TB_DEPARTMENT;

SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY >= 20 AND CAPACITY <= 30;


-- 6. �� ������б��� ������ �����ϰ� ��� �������� �Ҽ� �а��� ������ �ִ�.
--�׷� �� ������б� ������ �̸��� �˾Ƴ� �� �ִ� SQL ������ �ۼ��Ͻÿ�.
SELECT * FROM TB_PROFESSOR;

SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;


--7. Ȥ�� ������� ������ �а��� �����Ǿ� ���� ���� �л��� �ִ��� Ȯ���ϰ��� �Ѵ�. 
--��� SQL ������ ����ϸ� �� ������ �ۼ��Ͻÿ�. 

SELECT *
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;


-- 8. ������û�� �Ϸ��� �Ѵ�. �������� ���θ� Ȯ���ؾ� �ϴµ�, ���������� �����ϴ� 
--������� � �������� �����ȣ�� ��ȸ�غ��ÿ�.
SELECT * FROM TB_CLASS; -- �������� = PREATTENDING_CLASS_NO

SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;


--9. �� ���п��� � �迭(CATEGORY)���� �ִ��� ��ȸ�غ��ÿ�.
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT;


--10. 02 �й� ���� �����ڵ��� ������ ������� �Ѵ�.
-- ������ ������� ������ �������� �л����� �й�, �̸�, �ֹι�ȣ�� ����ϴ� ������ �ۼ��Ͻÿ�.  
-- �� ���� �� �� ��� ABSENCE_YN 'N' / 02�й� = 'A21%'
SELECT * FROM TB_STUDENT;

SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'N'
    AND STUDENT_NO LIKE 'A21%'
    AND STUDENT_ADDRESS LIKE '%����%';



-----[Additional SELECT - �Լ�] 5��, 7-9��, 12�� ����~~

--1. ������а�(�а��ڵ� 002) �л����� �й��� �̸�, ���� �⵵�� ���� �⵵�� ���� ������ ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
--( ��, ����� "�й�", "�̸�", "���г⵵" �� ǥ�õǵ��� �Ѵ�.)
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_CLASS;

SELECT STUDENT_NO AS "�й�", STUDENT_NAME AS "�̸�", ENTRANCE_DATE AS "���г⵵"
FROM TB_STUDENT
JOIN TB_CLASS USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NO = '002' AND CLASS_NAME = '���������'
ORDER BY ENTRANCE_DATE ASC;

--2. �� ������б��� ���� �� �̸��� �� ���ڰ� �ƴ� ������ �� �� �ִٰ� �Ѵ�. �� ������ �̸��� �ֹι�ȣ�� ȭ�鿡 ����ϴ� SQL ������ �ۼ��� ����. 
--(* �̶� �ùٸ��� �ۼ��� SQL ������ ��� ���� ����� �ٸ��� ���� �� �ִ�. ������ �������� �����غ� ��) 
SELECT * FROM TB_CLASS_PROFESSOR;
SELECT * FROM TB_PROFESSOR;

SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) != 3 ;

--3. �� ������б��� ���� �������� �̸��� ���̸� ����ϴ� SQL ������ �ۼ��Ͻÿ�. �� �̶� ���̰� ���� ������� ���� ��� ������ ȭ�鿡 ��µǵ��� ����ÿ�. 
--(��, ���� �� 2000 �� ���� ����ڴ� ������ ��� ����� "�����̸�", "����"�� �Ѵ�. ���̴� ���������� ����Ѵ�.)
SELECT PROFESSOR_NAME AS �����̸�, 
        (EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(PROFESSOR_SSN, 1, 2)))) AS ����
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8,1)IN('1','3')
ORDER BY ���� ASC;


--4. �������� �̸� �� ���� ������ �̸��� ����ϴ� SQL ������ �ۼ��Ͻÿ�. 
--��� ����� ?�̸�? �� �������� �Ѵ�. (���� 2���� ���� ������ ���ٰ� �����Ͻÿ�)
SELECT SUBSTR(PROFESSOR_NAME, 2) AS �̸�
FROM TB_PROFESSOR;


---- 5. �� ������б��� ����� �����ڸ� ���Ϸ��� �Ѵ�. ��� ã�Ƴ� ���ΰ�?  
-- �̶�, 19�쿡 �����ϸ� ����� ���� ���� ������ �����Ѵ�.
--SELECT STUDENT_NAME AS "�л� �̸�",
--       STUDENT_NO AS "�й�",
--       FLOOR(MONTHS_BETWEEN(TO_DATE(SUBSTR(STUDENT_NO, 1, 4) || '-03-01', 'YYYY-MM-DD'), 
--                            TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'YYMMDD')) / 12) AS "���� ����"
--FROM TB_STUDENT
--WHERE FLOOR(MONTHS_BETWEEN(TO_DATE(SUBSTR(STUDENT_NO, 1, 4) || '-03-01', 'YYYY-MM-DD'), 
--                            TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'YYMMDD')) / 12) > 19;


---6. 2020�� ũ���������� ���� �����ΰ�? 
SELECT TO_CHAR(TO_DATE('2020-12-25', 'YYYY-MM--DD'), 'DAY') AS "����"
FROM DUAL;


---- 7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD')  �� ���� �� �� �� �� �� ���� �ǹ��ұ�? 
-- �� TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD') �� ���� �� �� �� �� �� ���� �ǹ��ұ�? 
SELECT TO_DATE('99/10/11','YY/MM/DD') AS "��/��/��", 
       TO_DATE('49/10/11','YY/MM/DD') AS "��/��/��",
       TO_DATE('99/10/11','RR/MM/DD') AS "��/��/��",
       TO_DATE('49/10/11','RR/MM/DD') AS "��/��/��"
FROM DUAL;

-- SELECT TO_DATE('99/10/11', 'YY/MM/DD') AS "YY/MM/DD ����(99)",
--       TO_DATE('49/10/11', 'YY/MM/DD') AS "YY/MM/DD ����(49)",
--       TO_DATE('99/10/11', 'RR/MM/DD') AS "RR/MM/DD ����(99)",
--       TO_DATE('49/10/11', 'RR/MM/DD') AS "RR/MM/DD ����(49)"
--FROM DUAL;
 

----8. �� ������б��� 2000�⵵ ���� �����ڵ��� �й��� A�� �����ϰ� �Ǿ��ִ�. 
-- 2000�⵵ ���� �й��� ���� �л����� �й��� �̸��� �����ִ� SQL ������ �ۼ��Ͻÿ�.
-- ENTRANCE_DATE = ���г⵵ 
SELECT * FROM TB_STUDENT;
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO != 'A%';

--SELECT * FROM TB_STUDENT;
--SELECT STUDENT_NO, STUDENT_NAME
--FROM TB_STUDENT
--WHERE ENTRANCE_DATE >;


---- 9. �й��� A517178 �� �ѾƸ� �л��� ���� �� ������ ���ϴ� SQL ���� �ۼ��Ͻÿ�. 
--��, �̶� ��� ȭ���� ����� "����" �̶�� ������ �ϰ�, ������ �ݿø��Ͽ� �Ҽ��� ���� �� �ڸ������� ǥ������.
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_GRADE;

SELECT ROUND(POINT, 1)  AS "����"
FROM TB_GRADE
JOIN TB_STUDENT USING (STUDENT_NO)
WHERE STUDENT_NO = 'A517178';

-- ���� 1���� ���;� �ϴµ�...
--SELECT TB_GRADE, AVG(POINT) AS "����"
--FROM TB_GRADE
--JOIN TB_STUDENT USING (STUDENT_NO)
--WHERE STUDENT_NO = 'A517178';


-- 10. �а��� �л����� ���Ͽ� "�а���ȣ", "�л���(��)" �� ���·� ����� ����� ������� ��µǵ��� �Ͻÿ�.
-- �� �а����̴ϱ� GROUP BY ���
-- DEPARTMENT_NO = �а���ȣ, STUDENT_NO = �й� OR STUDENT_NAME ���� �ش� �а� �Ҽӵ� �л� ����
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;

SELECT DEPARTMENT_NO "�а���ȣ", COUNT(STUDENT_NO) "�л���(��)"
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING (DEPARTMENT_NO)
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO ASC;


-- 11. ���� ������ �������� ���� �л��� ���� �� �� ���� �Ǵ� �˾Ƴ��� SQL ���� �ۼ��Ͻÿ�.
-- ���� ���� ���� COACH_PROFESSOR_NO
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;


--12. �й��� A112113�� ���� �л��� �⵵ �� ������ ���ϴ� SQL ���� �ۼ��Ͻÿ�. 
--��, �̶� ��� ȭ���� ����� "�⵵", "�⵵ �� ����" �̶�� ������ �ϰ�, ������ �ݿø��Ͽ� �Ҽ��� ���� �� �ڸ������� ǥ���Ѵ�.
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_GRADE; -- TERM_NO �б� ��ȣ

--SELECT
--FROM
--WHERE STUDENT_NO = 'A112113'

----13. �а� �� ���л� ���� �ľ��ϰ��� �Ѵ�. �а� ��ȣ�� ���л� ���� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. 
--          �� �а����̴ϱ� GROUP BY ���, 
-- DEPARTMENT_NO = �а���ȣ, ������ ��� ABSENCE_YN 'Y' // �������� ����ϳ�???

SELECT DEPARTMENT_NO "�а��ڵ��", COUNT(ABSENCE_YN) "���л� ��"
FROM TB_DEPARTMENT
JOIN TB_STUDENT USING (DEPARTMENT_NO)
GROUP BY DEPARTMENT_NO
HAVING ABSENCE_YN = 'Y'
ORDER BY DEPARTMENT_NO ASC;


--SELECT DEPARTMENT_NO "�а��ڵ��", COUNT(ABSENCE_YN) "���л� ��"
--FROM TB_DEPARTMENT
--JOIN TB_STUDENT USING (DEPARTMENT_NO)
--GROUP BY DEPARTMENT_NO
--HAVING ABSENCE_YN = 'Y'
--ORDER BY DEPARTMENT_NO ASC;


--14.  �� ���б��� �ٴϴ� ��������(��٣���) �л����� �̸��� ã���� �Ѵ�. 
--� SQL ������ ����ϸ� �����ϰڴ°�?

--SELECT STUDENT_NAME AS "�����̸�" COUNT(STUDENT_NAME) AS "������ ��"
--FROM TB_STUDENT
--WHERE STUDENT_NAME = STUDENT_NAME;



--15. �й��� A112113 �� ���� �л��� �⵵, �б� �� ������ �⵵ �� ���� ���� , �� ������ ���ϴ� SQL ���� �ۼ��Ͻÿ�. 
--(��, ������ �Ҽ��� 1�ڸ������� �ݿø��Ͽ� ǥ���Ѵ�.)




-----[Additional SELECT - Option] page 13 ~ 21 / 9��, 10�� ~~ (12���� �� ���� Ǫ�� �� ������)

--1. �л��̸��� �ּ����� ǥ���Ͻÿ�. ��, ��� ����� "�л� �̸�", "�ּ���"�� �ϰ�, ������ �̸����� �������� ǥ���ϵ��� �Ѵ�. 
SELECT * FROM TB_STUDENT;

SELECT STUDENT_NAME AS "�л��̸�", STUDENT_ADDRESS AS "�ּ���"
FROM TB_STUDENT
ORDER BY STUDENT_NAME ASC;

--2.  �������� �л����� �̸��� �ֹι�ȣ�� ���̰� ���� ������ ȭ�鿡 ����Ͻÿ�.
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY STUDENT_SSN DESC;

--3. �ּ����� �������� ��⵵�� �л��� �� 1900��� �й��� ���� �л����� �̸��� �й�, �ּҸ�
--�̸��� ������������ ȭ�鿡 ����Ͻÿ�. ��, ���������� "�л��̸�","�й�","������ �ּ�" �� ��µǵ��� �Ѵ�. 
SELECT STUDENT_NAME "�л��̸�", STUDENT_NO "�й�", STUDENT_ADDRESS "������ �ּ�"
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '%������%' OR STUDENT_ADDRESS LIKE '%��⵵%' AND STUDENT_NO LIKE '9%' 
ORDER BY STUDENT_NAME ASC;

--4. ���� ���а� ���� �� ���� ���̰� ���� ������� �̸��� Ȯ���� �� �ִ� SQL ������ �ۼ��Ͻÿ�. --
--(���а��� '�а��ڵ�'�� �а� ���̺�(TB_DEPARTMENT)�� ��ȸ�ؼ� ã�Ƴ����� ����) 
SELECT * FROM TB_PROFESSOR;
SELECT * FROM TB_DEPARTMENT;

SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '���а�'
ORDER BY PROFESSOR_SSN ASC;


----5. 2004�� 2�б⿡ 'C3118100' ������ ������ �л����� ������ ��ȸ�Ϸ��� �Ѵ�. 
--������ ���� �л����� ǥ���ϰ�, ������ ������ �й��� ���� �л����� ǥ���ϴ� ������ �ۼ��غ��ÿ�. 
SELECT * FROM TB_GRADE;
SELECT * FROM TB_CLASS;
SELECT * FROM TB_STUDENT;

SELECT STUDENT_NO,POINT
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_CLASS USING(DEPARTMENT_NO)
WHERE CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO ASC;

--SELECT STUDENT_NO, POINT
--FROM TB_GRADE
--WHERE CLASS_NO = 'C3118100' AND SEMESTER = '2�б�' AND YEAR = 2004
--ORDER BY POINT DESC, STUDENT_NO ASC;


--6. �л� ��ȣ, �л� �̸�, �а� �̸��� �л� �̸����� �������� �����Ͽ� ����ϴ� SQL ���� �ۼ��Ͻÿ�. 
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;

SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME ASC;

--7. �� ������б��� ���� �̸��� ������ �а� �̸��� ����ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT * FROM TB_CLASS;
SELECT * FROM TB_DEPARTMENT;

SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);

----8. ���� ���� �̸��� ã������ �Ѵ�. ���� �̸��� ���� �̸��� ����ϴ� SQL ���� �ۼ��Ͻÿ�. 
SELECT * FROM TB_CLASS;
SELECT * FROM TB_PROFESSOR;

--SELECT CLASS_NAME, PROFESSOR_NAME
--FROM TB_CLASS
--JOIN TB_PROFESSOR USING(DEPARTMENT_NO)
--GROUP BY CLASS_NAME;

SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_PROFESSOR USING (DEPARTMENT_NO);


SELECT CLASS_NAME, PROFESSOR_NAME
FROM (
    SELECT CLASS_NAME, PROFESSOR_NAME,
           ROW_NUMBER() OVER (PARTITION BY CLASS_NAME ORDER BY PROFESSOR_NAME) AS rn
    FROM TB_CLASS C
    JOIN TB_PROFESSOR P ON C.DEPARTMENT_NO = P.DEPARTMENT_NO)
WHERE rn = 1
ORDER BY CLASS_NAME;


--9. 8���� ��� �� ���ι���ȸ�� �迭�� ���� ������ ���� �̸��� ã������ �Ѵ�. 
--�̿� �ش��ϴ� ���� �̸��� ���� �̸��� ����ϴ� SQL ���� �ۼ��Ͻÿ�. 



--10. �������а��� �л����� ������ ���Ϸ��� �Ѵ�. 
--�����а� �л����� "�й�", "�л� �̸�", "��ü ����"�� ����ϴ� SQL ������ �ۼ��Ͻÿ�.
--(��, ������ �Ҽ��� 1�ڸ������� �ݿø��Ͽ� ǥ���Ѵ�.)
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;
SELECT * FROM TB_GRADE;

SELECT STUDENT_NO, STUDENT_NAME, POINT --ROUND(AVG(POINT),1)
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_GRADE USING(STUDENT_NO)
WHERE DEPARTMENT_NAME = '�����а�';


--11. �й��� A313047�� �л��� �б��� ������ ���� �ʴ�. ���� �������� ������ �����ϱ� ���� �а� �̸�, �л� �̸��� ���� ���� �̸��� �ʿ��ϴ�. 
--�̶� ����� SQL ���� �ۼ��Ͻÿ�.  ��, �������� ?�а��̸�?, ?�л��̸�?, ?���������̸�?���� ��µǵ��� �Ѵ�. 
--SELECT DEPARTMENT_NAME AS "�а��̸�", STUDENT_NAME AS "�л��̸�", PROFESSOR_NAME "���������̸�";
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;
SELECT * FROM TB_PROFESSOR;


--12. 2007 �⵵�� '�ΰ������' ������ ������ �л��� ã�� �л��̸��� �����б⸦ ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�. 
SELECT * FROM TB_CLASS
WHERE CLASS_NAME = '�ΰ������';

SELECT * FROM TB_GRADE
WHERE TERM_NO LIKE '2007%' AND CLASS_NO = 'C2604100';

SELECT STUDENT_NAME, TERM_NO
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
WHERE TERM_NO LIKE '2007%' AND CLASS_NO = 'C2604100';


--13. ��ü�� �迭 ���� �� ���� ��米���� �� �� �������� ���� ������ ã�� �� ���� �̸��� �а� �̸��� ����ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT * FROM TB_DEPARTMENT
WHERE CATEGORY = '��ü��'; -- DEPARMENT_NO = 056 ~063

SELECT * FROM TB_CLASS; -- DEPARTMENT_NO

SELECT * FROM TB_PROFESSOR; -- PROFESSOR_NO, DEPARTMENT_NO

SELECT * FROM TB_CLASS_PROFESSOR; -- PROFESSOR_NO

SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_DEPARTMENT
JOIN TB_CLASS USING (DEPARTMENT_NO)
WHERE CATEGORY = '��ü��';


SELECT
    CLASS_NAME,
    DEPARTMENT_NAME
FROM TB_CLASS C, TB_CLASS_PROFESSOR CP,TB_DEPARTMENT D
WHERE 
    C.CLASS_NO = CP.CLASS_NO
    AND C.DEPARTMENT_NO = D.DEPARTMENT_NO
    AND PROFESSOR_NO IS NULL
    AND CATEGORY = '��ü��';


--14. �� ������б� ���ݾƾ��а� �л����� ���������� �Խ��ϰ��� �Ѵ�. 
--�л��̸��� �������� �̸��� ã�� ���� ���� ������ ���� �л��� ��� "�������� ������?���� ǥ���ϵ��� �ϴ� SQL ���� �ۼ��Ͻÿ�. 
--��,  �������� ?�л��̸�?, ?��������?�� ǥ���ϸ� ���й� �л��� ���� ǥ�õǵ��� �Ѵ�. 


--15. ���л��� �ƴ� �л� �� ������ 4.0 �̻��� �л��� ã�� �� �л��� �й�, �̸�, �а� �̸�, ������ ����ϴ� SQL ���� �ۼ��Ͻÿ�.  


--16. ȯ�������а� ����������� ���� �� ������ �ľ��� �� �ִ� SQL ���� �ۼ��Ͻÿ�.


--17. �� ������б��� �ٴϰ� �ִ� �ְ��� �л��� ���� �� �л����� �̸��� �ּҸ� ����ϴ� SQL ���� �ۼ��Ͻÿ�. 


--18. ������а����� �� ������ ���� ���� �л��� �̸��� �й��� ǥ���ϴ� SQL���� �ۼ��Ͻÿ�. 


--19. �� ������б��� "ȯ�������а�"�� ���� ���� �迭 �а����� �а� �� �������� ������ �ľ��ϱ� ���� ������ SQL ���� ã�Ƴ��ÿ�.
--��, �������� "�迭 �а���", "��������"���� ǥ�õǵ��� �ϰ�, ������ �Ҽ��� �� �ڸ������� �ݿø��Ͽ� ǥ�õǵ��� �Ѵ�.



--[DDL] 
--1. �迭 ������ ������ ī�װ� ���̺��� ������� �Ѵ�. ������ ���� ���̺��� �ۼ��Ͻÿ�.
-- ���̺� �̸� 
-- TB_CATEGORY 
--�÷� 
--NAME, VARCHAR2(10)  
--USE_YN, CHAR(1), �⺻���� Y �� ������

CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);

SELECT * FROM TB_CATEGORY;

--2. ���� ������ ������ ���̺��� ������� �Ѵ�. ������ ���� ���̺��� �ۼ��Ͻÿ�.
--���̺��̸� 
--TB_CLASS_TYPE 
--�÷� 
--NO, VARCHAR2(5), PRIMARY KEY 
--NAME , VARCHAR2(10)  

DROP TABLE TB_CLASS_TYPE;
SELECT * FROM TB_CLASS_TYPE;

CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10)
);

CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5),
    NAME VARCHAR2(10),
    PRIMARY KEY(NO)
);

--3. TB_CATAGORY ���̺��� NAME �÷��� PRIMARY KEY�� �����Ͻÿ�. 
--(KEY �̸��� �������� �ʾƵ� ������. ���� KEY �̸� �����ϰ��� �Ѵٸ� �̸��� ������ �˾Ƽ� ������ �̸��� ����Ѵ�.)
DROP TABLE TB_CATEGORY;
SELECT * FROM TB_CATEGORY;

ALTER TABLE TB_CATEGORY ADD CONSTRAINT NAME_PK PRIMARY KEY(NAME);

--4. TB_CLASS_TYPE ���̺��� NAME �÷��� NULL ���� ���� �ʵ��� �Ӽ��� �����Ͻÿ�.
ALTER TABLE TB_CLASS_TYPE MODIFY NAME NOT NULL;

-- 5. �� ���̺��� �÷� ���� NO�� ���� ���� Ÿ���� �����ϸ鼭 ũ��� 10 ����, 
--�÷����� NAME �� ���� ���������� ���� Ÿ���� �����ϸ鼭 ũ�� 20 ���� �����Ͻÿ�.
ALTER TABLE TB_CATEGORY 
    MODIFY NAME VARCHAR2(20);
    
ALTER TABLE TB_CLASS_TYPE
    MODIFY NO VARCHAR2(10)
    MODIFY NAME VARCHAR2(20);

--6. �� ���̺��� NO �÷��� NAME �÷��� �̸��� �� �� TB_ �� ������ ���̺� �̸��� �տ� 
--���� ���·� �����Ѵ�. (ex. CATEGORY_NAME) 

ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;

ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;


--7. TB_CATAGORY ���̺�� TB_CLASS_TYPE ���̺��� PRIMARY KEY �̸��� ������ ���� �����Ͻÿ�. 
--Primary Key �� �̸��� "PK_ + �÷��̸�"���� �����Ͻÿ�. (ex. PK_CATEGORY_NAME ) 
ALTER TABLE TB_CATEGORY RENAME CONSTRAINT NAME_PK TO PK_CATEGORY_NAME;
--ALTER TABLE TB_CLASS_TYPE RENAME CONSTRAINT SYS_C007215 TO PK_CLASS_TYPE_NO;

SELECT * FROM TB_CLASS_TYPE;
SELECT * FROM TB_CATEGORY;

--8. ������ ����INSERT ���� �����Ѵ�. 
--INSERT INTO TB_CATEGORY VALUES ('����','Y'); 
--INSERT INTO TB_CATEGORY VALUES ('�ڿ�����','Y'); 
--INSERT INTO TB_CATEGORY VALUES ('����','Y'); 
--INSERT INTO TB_CATEGORY VALUES ('��ü��','Y'); 
--INSERT INTO TB_CATEGORY VALUES ('�ι���ȸ','Y'); 
--COMMIT;  

INSERT INTO TB_CATEGORY VALUES ('����','Y'); 
INSERT INTO TB_CATEGORY VALUES ('�ڿ�����','Y'); 
INSERT INTO TB_CATEGORY VALUES ('����','Y'); 
INSERT INTO TB_CATEGORY VALUES ('��ü��','Y'); 
INSERT INTO TB_CATEGORY VALUES ('�ι���ȸ','Y'); 
COMMIT;

SELECT * FROM TB_CATEGORY;

----9.TB_DEPARTMENT �� CATEGORY �÷��� TB_CATEGORY ���̺��� CATEGORY_NAME �÷��� �θ����� �����ϵ��� FOREIGN KEY�� �����Ͻÿ�. 
-- �� �� KEY �̸��� FK_���̺��̸�_�÷��̸����� �����Ѵ�. (ex. FK_DEPARTMENT_CATEGORY ) 
SELECT * FROM TB_DEPARTMENT;

ALTER TABLE TB_DEPARTMENT ADD CONSTRAINT FK_DEPARTMENT_CATEGORY 
FOREIGN KEY(CATEGORY) REFERENCES TB_CATEGORY(CATEGORY_NAME);

SELECT * FROM TB_CATEGORY;
SELECT * FROM TB_CLASS_TYPE;
SELECT * FROM TB_DEPARTMENT;


-----10. �� ������б� �л����� �������� ���ԵǾ� �ִ� �л��Ϲ����� VIEW�� ������� �Ѵ�. 
--�Ʒ� ������ �����Ͽ� ������ SQL ���� �ۼ��Ͻÿ�.


-----11. �� ������б��� 1�⿡ �� ���� �а����� �л��� ���������� ���� ����� �����Ѵ�. 
--�̸� ���� ����� �л��̸�, �а��̸�, ��米���̸� ���� �����Ǿ� �ִ� VIEW �� ����ÿ�. 
--�̶� ���� ������ ���� �л��� ���� �� ������ ����Ͻÿ� 
--(��, �� VIEW �� �ܼ� SELECT ���� �� ��� �а����� ���ĵǾ� ȭ�鿡 �������� ����ÿ�.) 


-----12. ��� �а��� �а��� �л� ���� Ȯ���� �� �ֵ��� ������ VIEW �� �ۼ��� ����. 


-----13. ������ ������ �л��Ϲ����� View�� ���ؼ� �й��� A213046�� �л��� �̸��� ���� 
--�̸����� �����ϴ� SQL ���� �ۼ��Ͻÿ�. 

-----14. 13 �������� ���� VIEW�� ���ؼ� �����Ͱ� ����� �� �ִ� ��Ȳ�� �������� VIEW�� 
--��� �����ؾ� �ϴ��� �ۼ��Ͻÿ�. 

-----15. �� ������б��� �ų� ������û �Ⱓ�� �Ǹ� Ư�� �α� ����鿡 ���� ��û�� ���� 
--������ �ǰ� �ִ�. �ֱ� 3���� �������� �����ο��� ���� ���Ҵ� 3 ������ ã�� ������ �ۼ��غ��ÿ�.



--------------------------------------[DML]---------------------------------
-- 1. �������� ���̺�(TB_CLASS_TYPE)�� �Ʒ��� ���� �����͸� �Է��Ͻÿ�.
--��ȣ, �����̸� ------------ 
--01, �����ʼ� 
--02, �������� 
--03, �����ʼ� 
--04, ���缱�� 
--05. ������  
SELECT * FROM TB_CLASS_TYPE;

INSERT INTO TB_CLASS_TYPE
VALUES(01,'�����ʼ�');

INSERT INTO TB_CLASS_TYPE VALUES(02,'��������');
INSERT INTO TB_CLASS_TYPE VALUES(03,'�����ʼ�');
INSERT INTO TB_CLASS_TYPE VALUES(04,'���缱��');
INSERT INTO TB_CLASS_TYPE VALUES(05,'������');

-- 2. �� ������б� �л����� ������ ���ԵǾ� �ִ� �л��Ϲ����� ���̺��� ������� �Ѵ�. 
-- �Ʒ� ������ �����Ͽ� ������ SQL ���� �ۼ��Ͻÿ�. (���������� �̿��Ͻÿ�) 
-- ���̺��̸� 
--  TB_�л��Ϲ����� 
--  �÷� 
--  �й� 
--  �л��̸� 
--  �ּ�
CREATE TABLE TB_�л��Ϲ�����
AS SELECT STUDENT_NO AS "�й�", STUDENT_NAME AS "�л��̸�", STUDENT_ADDRESS AS "�ּ�"
FROM TB_STUDENT;

-- 3. ������а� �л����� �������� ���ԵǾ� �ִ� �а����� ���̺��� ������� ����. 
--�Ʒ� ������ �����Ͽ� ������ SQL ���� �ۼ��Ͻÿ�. (��Ʈ : ����� �پ���, �ҽŲ� �ۼ��Ͻÿ�) 
--���̺��̸� 
--  TB_������а� 
--�÷� 
--   �й� 
--   �л��̸� 
--   ����⵵ <= ���ڸ� �⵵�� ǥ�� 
--   �����̸� 
SELECT * FROM TB_STUDENT;

CREATE TABLE TB_������а�
AS SELECT 
    STUDENT_NO AS "�й�", 
    STUDENT_NAME AS "�л��̸�", 
    EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN,1,6),'RR/MM/DD')) AS "����⵵", 
    PROFESSOR_NAME AS "�����̸�"
   FROM TB_STUDENT, TB_PROFESSOR
   WHERE COACH_PROFESSOR_NO = PROFESSOR_NO;

--4. �� �а����� ������ 10% ������Ű�� �Ǿ���. �̿� ����� SQL ���� �ۼ��Ͻÿ�. 
--(��, �ݿø��� ����Ͽ� �Ҽ��� �ڸ����� ������ �ʵ��� �Ѵ�) 
SELECT * FROM TB_DEPARTMENT;

UPDATE TB_DEPARTMENT
SET CAPACITY = ROUND(CAPACITY * 1.1); -- ������а� 20, ������а� 36, 28, 28

ROLLBACK;

--5. �й� A413042 �� �ڰǿ� �л��� �ּҰ� "����� ���α� ���ε� 181-21 "�� ����Ǿ��ٰ� �Ѵ�.
-- �ּ����� �����ϱ� ���� ����� SQL ���� �ۼ��Ͻÿ�. 
SELECT * FROM TB_STUDENT;

SELECT STUDENT_ADDRESS
FROM TB_STUDENT
WHERE STUDENT_NO = 'A413042' AND STUDENT_NAME = '�ڰǿ�';

UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '����� ���α� ���ε� 182-21'; -- ��⵵ ���ֽ� ������ ����2�� ��65����

ROLLBACK;

--6. �ֹε�Ϲ�ȣ ��ȣ���� ���� �л����� ���̺��� �ֹι�ȣ ���ڸ��� �������� �ʱ�� �����Ͽ���. 
--�� ������ �ݿ��� ������ SQL ������ �ۼ��Ͻÿ�. (��. 830530-2124663 ==> 830530 )  
SELECT * FROM TB_STUDENT;

SELECT SUBSTR(STUDENT_SSN,1,6)
FROM TB_STUDENT;

UPDATE TB_STUDENT
SET STUDENT_SSN = SUBSTR(STUDENT_SSN,1,6); -- 830530-2124663

ROLLBACK;

--7. ���а� ����� �л��� 2005�� 1�б⿡ �ڽ��� ������ '�Ǻλ�����' ������ �߸��Ǿ��ٴ� ���� �߰��ϰ�� ������ ��û�Ͽ���. 
--��� ������ Ȯ�� ���� ��� �ش� ������ ������ 3.5�� ����Ű�� �����Ǿ���. ������ SQL ���� �ۼ��Ͻÿ�. 

SELECT *
FROM TB_STUDENT
WHERE STUDENT_NAME = '�����'; -- �������� DEPARTMENT_NO = 024, 053 / STUDENT_NO = A331092, A331101

SELECT * 
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME = '���а�'; -- DEPARTMENT_NO 053

SELECT *
FROM TB_GRADE -- TERM_NO = 200501
WHERE STUDENT_NO = 'A331101' AND TERM_NO = '200501' AND CLASS_NO = 'C3843900';

--SELECT * FROM TB_CLASS
--WHERE CLASS_NAME = '�Ǻλ�����'; -- DEPARTMENT_NO = 053 / CALSS_NO = C3843900

UPDATE TB_GRADE
SET POINT = 3.5
WHERE STUDENT_NO = 'A331101' AND TERM_NO = '200501'; -- 1.5

ROLLBACK; -- �� ū �ϳ���... WHERE �� ���ֱ�..!! �� ���� �ۼ��ϴ� �ڵ� ���� �� ������..


--8. ���� ���̺�(TB_GRADE) ���� ���л����� �����׸��� �����Ͻÿ�.
SELECT * FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y';

SELECT *
FROM TB_GRADE
JOIN TB_STUDENT USING(STUDENT_NO)
WHERE ABSENCE_YN = 'Y';

UPDATE TB_GRADE
SET POINT = NULL
WHERE TB_GRADE.STUDENT_NO IN (SELECT STUDENT_NO 
                                FROM TB_STUDENT 
                               WHERE ABSENCE_YN = 'Y');

