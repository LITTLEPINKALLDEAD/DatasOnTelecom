----1��2
SELECT TEMP2.�ͻ�����,
       temp2.ҵ������,
       SUM(TEMP2.�����) �����,
       SUM(TEMP2.�ظ���湤����) �ظ���湤����,
       SUM(TEMP2.�û���) �û���
  FROM (SELECT CASE
                 WHEN (A.USER_TYPE = '����' OR A.USER_TYPE = '��ͨסլ' OR
                      A.USER_TYPE = '��ͨ����' OR A.USER_TYPE = '����' OR
                      A.USER_TYPE IS NULL) THEN
                  '����'
                 WHEN (A.USER_TYPE = '��ҵ����' OR A.USER_TYPE = '��ҵ' OR
                      A.USER_TYPE = '��ҵ') THEN
                  '����'
               end �ͻ�����,
               case
                 when (SELECT (SELECT S1.BUSINESSNAME
                                 FROM ufms.BAF_SYS_BUSINESS S1
                                WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
                         FROM ufms.BAF_SYS_BUSINESS S
                        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '����' then
                  '�̻�'
                 when M.SPECIALTY_ID IN ('0057396',
                                         '0057400',
                                         '0057402',
                                         '0057398',
                                         '140123319',
                                         '140122776',
                                         '140123366',
                                         '140122819',
                                         '140123521',
                                         '140123590',
                                         '140123657',
                                         '140123756') then
                  'IPTV'
                 when M.SPECIALTY_ID IN
                      ('0057382', '23586626', '23586609', '84112977') then
                  '���'
               end ҵ������,
               1 �����,
               CASE
                 WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
                  1
                 ELSE
                  0
               END �ظ���湤����,
               0 �û���
          FROM ufms.t_Pub_Mainbill M, ufms.T_SA_BILL_HIS A --M���޸�
         WHERE M.BILL_ID = A.BILL_ID
           AND M.SPECIALTY_ID <> '22465958' --�޳����޵�
              --AND M.BILL_ID = TMP.BILL_ID
           AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
           AND M.NATIVENET_ID <> '0010823'
              --AND TMP.ISINPUT = 'N'
           AND M.BUSINESS_ID = '0001024'
           AND ((A.USER_TYPE = '��ҵ����' OR A.USER_TYPE = '��ҵ' OR
               A.USER_TYPE = '��ҵ') OR
               (A.USER_TYPE = '����' OR A.USER_TYPE = '��ͨסլ' OR
               A.USER_TYPE = '��ͨ����' OR A.USER_TYPE = '����' OR
               A.USER_TYPE IS NULL))
           AND (A.BUSINESS_TYPE <> 'CDMA' OR A.BUSINESS_TYPE IS NULL)
           AND (EXISTS
                (SELECT 1
                   FROM ufms.BAF_SYS_BUSINESS S
                  WHERE S.BUSINESSID = M.SPECIALTY_ID
                    AND S.PARENTBUSINESSID = '0995070') OR
                M.SPECIALTY_ID IN
                ('0057382', '23586626', '23586609', '84112977') OR
                M.SPECIALTY_ID IN ('0057396',
                                   '0057400',
                                   '0057402',
                                   '0057398',
                                   '140123319',
                                   '140122776',
                                   '140123366',
                                   '140122819',
                                   '140123521',
                                   '140123590',
                                   '140123657',
                                   '140123756'))
           AND M.CREATE_TIME >= DATE '2018-3-1' --��ʼʱ��
           AND M.CREATE_TIME < DATE '2018-4-1' --����ʱ��
           AND M.ARCH_TIME >= DATE '2018-3-1' --��ʼʱ��
           AND A.ARCH_TIME >= DATE '2018-3-1' --��ʼʱ��
       /*UNION ALL
        SELECT TEMP.�ͻ�����,
               DECODE(TEMP.SPECIALTY, '�̻�', '�̻�', '���', '���', 'IPTV') ҵ������,
               0 �����,
               0 �ظ���湤����,
               TEMP.USERNUM �û���
          FROM (SELECT UM.SPECIALTY,
                       um.user_type �ͻ�����,
                       sum(TO_NUMBER(UM.USERNUM)) USERNUM
                  FROM RT_SA_USERNUM UM  --RT_SA_USERNUM������
                 WHERE UM.SIMPLESM = TRUNC(DATE '2018-4-1', 'MM')
                --  AND UM.SPECIALTY IN ('�̻�', '���')
                 group by UM.SPECIALTY, um.user_type) TEMP*/) TEMP2
 GROUP BY TEMP2.�ͻ�����, temp2.ҵ������;

--3 �޸���ʱ��

SELECT TEMP.�ͻ�����,
       temp.ҵ������,
       TEMP."5A¥��",
       SUM(TEMP.������) ������,
       sum(temp.��ʱ��) ��ʱ��
  FROM (SELECT CASE
                 WHEN (A.USER_TYPE = '����' OR A.USER_TYPE = '��ͨסլ' OR
                      A.USER_TYPE = '��ͨ����' OR A.USER_TYPE = '����' OR
                      A.USER_TYPE IS NULL) THEN
                  '����'
                 WHEN (A.USER_TYPE = '��ҵ����' OR A.USER_TYPE = '��ҵ' OR
                      A.USER_TYPE = '��ҵ') THEN
                  '����'
               end �ͻ�����,
               case
                 when (SELECT (SELECT S1.BUSINESSNAME
                                 FROM ufms.BAF_SYS_BUSINESS S1
                                WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
                         FROM ufms.BAF_SYS_BUSINESS S
                        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '����' then
                  '�̻�'
                 when M.SPECIALTY_ID IN ('0057396',
                                         '0057400',
                                         '0057402',
                                         '0057398',
                                         '140123319',
                                         '140122776',
                                         '140123366',
                                         '140122819',
                                         '140123521',
                                         '140123590',
                                         '140123657',
                                         '140123756') then
                  'IPTV'
                 when M.SPECIALTY_ID IN
                      ('0057382', '23586626', '23586609', '84112977') then
                  '���'
               end ҵ������,
               decode(A.EXT_INFO, 'Y', '��', '��') "5A¥��",
               1 ������,
               DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) ��ʱ��
          FROM ufms.T_PUB_MAINBILL_HIS M, ufms.T_SA_BILL_HIS A
         WHERE M.BILL_ID = A.BILL_ID
           AND M.SPECIALTY_ID <> '22465958' --�޳����޵�
              --AND M.BILL_ID = TMP.BILL_ID
           AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
           AND M.NATIVENET_ID <> '0010823'
              --AND TMP.ISINPUT = 'N'
           AND M.BUSINESS_ID = '0001024'
           AND ((A.USER_TYPE = '��ҵ����' OR A.USER_TYPE = '��ҵ' OR
               A.USER_TYPE = '��ҵ') OR
               (A.USER_TYPE = '����' OR A.USER_TYPE = '��ͨסլ' OR
               A.USER_TYPE = '��ͨ����' OR A.USER_TYPE = '����' OR
               A.USER_TYPE IS NULL))
           AND (A.BUSINESS_TYPE <> 'CDMA' OR A.BUSINESS_TYPE IS NULL)
           AND (EXISTS
                (SELECT 1
                   FROM ufms.BAF_SYS_BUSINESS S
                  WHERE S.BUSINESSID = M.SPECIALTY_ID
                    AND S.PARENTBUSINESSID = '0995070') OR
                M.SPECIALTY_ID IN
                ('0057382', '23586626', '23586609', '84112977') OR
                M.SPECIALTY_ID IN ('0057396',
                                   '0057400',
                                   '0057402',
                                   '0057398',
                                   '140123319',
                                   '140122776',
                                   '140123366',
                                   '140122819',
                                   '140123521',
                                   '140123590',
                                   '140123657',
                                   '140123756'))
           AND M.ARCH_TIME >= DATE '2018-3-1' --��ʼʱ��
           AND M.ARCH_TIME < DATE '2018-4-1' --����ʱ��
           AND A.ARCH_TIME >= DATE '2018-3-1' --��ʼʱ��
           AND A.ARCH_TIME < DATE '2018-4-1' --����ʱ��
        ) temp
 group by TEMP.�ͻ�����, temp.ҵ������, TEMP."5A¥��";

--4
SELECT case
         when B.business_type = 'POTS' then
          '����'
         when ((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
              (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
              (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and
              B.Is_Need_Test <> 'Y' then
          'IPTV'
         when B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL') then
          '���'
         when B.business_type = 'ADDSERV' then
          '����'
       end ҵ������,
       CASE
         WHEN (B.SUB_TYPE = 'סլ' OR B.SUB_TYPE = '����סլ') THEN
          '����'
         WHEN (B.SUB_TYPE = '����' OR B.SUB_TYPE = '��������') THEN
          '����'
       END �ͻ�����,
       case
         when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
              B.INTRADAY_FINISH = 'Y' then
          1
         else
          0
       end ʵ�ʵ������,
       decode(B.INTRADAY_FINISH, 'Y', '��', '��') "����װ"
  FROM ufms.T_PUB_MAINBILL_HIS M, ufms.T_OPEN_BILLINFO_HIS B
 WHERE M.BILL_ID = B.BILL_ID
   AND (B.SUB_TYPE = 'סլ' OR B.SUB_TYPE = '����סլ' OR B.SUB_TYPE = '����' OR
       B.SUB_TYPE = '��������')
   AND ((((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
       (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
       (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and B.Is_Need_Test <> 'Y') OR
       B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL'))
   AND M.BUSINESS_ID = '0002555'
   AND b.ARCH_TIME >= DATE '2018-3-1'
   AND b.ARCH_TIME < DATE '2018-4-1'
   AND M.ARCH_TIME >= DATE '2018-3-1'
   AND M.ARCH_TIME < DATE '2018-4-1';

--5,6 ���ӹ��
SELECT CASE
         WHEN (A.USER_TYPE = '����' OR A.USER_TYPE = '��ͨסլ' OR
              A.USER_TYPE = '��ͨ����' OR A.USER_TYPE = '����' OR
              A.USER_TYPE IS NULL) THEN
          '����'
         WHEN (A.USER_TYPE = '��ҵ����' OR A.USER_TYPE = '��ҵ' OR
              A.USER_TYPE = '��ҵ') THEN
          '����'
       end �ͻ�����,
       case
         when (SELECT (SELECT S1.BUSINESSNAME
                         FROM ufms.BAF_SYS_BUSINESS S1
                        WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
                 FROM ufms.BAF_SYS_BUSINESS S
                WHERE S.BUSINESSID = M.SPECIALTY_ID) = '����' then
          '�̻�'
         when M.SPECIALTY_ID IN ('0057396',
                                 '0057400',
                                 '0057402',
                                 '0057398',
                                 '140123319',
                                 '140122776',
                                 '140123366',
                                 '140122819',
                                 '140123521',
                                 '140123590',
                                 '140123657',
                                 '140123756') then
          'IPTV'
         when M.SPECIALTY_ID IN
              ('0057382', '23586626', '23586609', '84112977') then
          '���'
       end ҵ������,
       1 ������,
       case
         when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
              a.INTRADAY_FINISH = 'Y' then
          1
         else
          0
       end ʵ�ʵ������,
       decode(a.INTRADAY_FINISH, 'Y', '��', '��') "������",
       case
         when exists (SELECT 1
                 FROM ufms.T_PUB_BILL_CONTROL_HIS C
                WHERE C.CONTROL_TYPE = 'HASTEN'
                  AND C.CONTROL_INFO LIKE '��112ϵͳ���ޡ�%'
                  AND C.BILL_ID = A.BILL_ID) then
          1
         else
          0
       end ������
  FROM ufms.T_PUB_MAINBILL_HIS M, ufms.T_SA_BILL_HIS A
 WHERE M.BILL_ID = A.BILL_ID
   AND M.SPECIALTY_ID <> '22465958' --�޳����޵�
      --AND M.BILL_ID = TMP.BILL_ID
   AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
   AND M.NATIVENET_ID <> '0010823'
      --AND TMP.ISINPUT = 'N'
   AND M.BUSINESS_ID = '0001024'
   AND ((A.USER_TYPE = '��ҵ����' OR A.USER_TYPE = '��ҵ' OR A.USER_TYPE = '��ҵ') OR
       (A.USER_TYPE = '����' OR A.USER_TYPE = '��ͨסլ' OR A.USER_TYPE = '��ͨ����' OR
       A.USER_TYPE = '����' OR A.USER_TYPE IS NULL))
   AND (A.BUSINESS_TYPE <> 'CDMA' OR A.BUSINESS_TYPE IS NULL)
   AND (M.SPECIALTY_ID IN ('0057396',
                           '0057400',
                           '0057402',
                           '0057398',
                           '140123319',
                           '140122776',
                           '140123366',
                           '140122819',
                           '140123521',
                           '140123590',
                           '140123657',
                           '140123756') OR
       (M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977') AND
       A.LINE_TYPE IN ('6', '7')))
   AND M.ARCH_TIME >= DATE '2018-3-1' --��ʼʱ��
   AND M.ARCH_TIME < DATE '2018-4-1' --����ʱ��
   AND A.ARCH_TIME >= DATE '2018-3-1' --��ʼʱ��
   AND A.ARCH_TIME < DATE '2018-4-1' --����ʱ��
;

--
