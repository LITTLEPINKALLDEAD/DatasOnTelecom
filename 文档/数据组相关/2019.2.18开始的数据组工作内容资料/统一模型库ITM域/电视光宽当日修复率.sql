---(M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977') AND
---       A.LINE_TYPE IN ('6', '7')

----2�����ӹ�����޸���

select */*"���ϵ���ʶ"||'0x05'||
       "���ϵ���"||'0x05'||
       "�ͻ�����"||'0x05'||
       "ҵ������"||'0x05'||
       "5A¥��"||'0x05'||
       "�Ƿ��ظ����"||'0x05'||
       "��ʱ�޸�"||'0x05'||
       "��Ҫ�����޸�"||'0x05'||
       "�Ƿ�����"||'0x05'||
       "����ʱ��"||'0x05'||
       "���ʱ��"||'0x05'||
       "��������"||'0x05'||
       "�û��Ǽ�"||'0x0D0A'*/
from (select 
   M.BILL_ID ���ϵ���ʶ,
   M.BILL_SN ���ϵ���,
   CASE
    WHEN (A.USER_TYPE = '����' OR A.USER_TYPE = '��ͨסլ' OR
         A.USER_TYPE = '��ͨ����' OR A.USER_TYPE = '����' OR
         A.USER_TYPE IS NULL) THEN
     '����'
    WHEN (A.USER_TYPE = '��ҵ����' OR A.USER_TYPE = '��ҵ' OR
         A.USER_TYPE = '��ҵ') THEN
     '����'
   end �ͻ�����,
   case
     /*when (SELECT (SELECT S1.BUSINESSNAME
                     FROM ufms.BAF_SYS_BUSINESS S1
                    WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
             FROM ufms.BAF_SYS_BUSINESS S
            WHERE S.BUSINESSID = M.SPECIALTY_ID) = '����' then
      '�̻�'*/
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
                             '140123756',
                             '1729795994',
                             '1729795996',
                             '1729795998') then
      'IPTV'
     when M.SPECIALTY_ID IN
          ('0057382', '23586626', '23586609', '84112977') then
      '���'
   end ҵ������,
   decode(A.EXT_INFO, 'Y', '��', '��') "5A¥��",
   CASE
     WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
      1
     ELSE
      0
   END �Ƿ��ظ����,
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) ��ʱ�޸�,
   decode(A.INTRADAY_FINISH, 'Y', '��', '��') ��Ҫ�����޸�,
   case
     when ((M.CREATE_TIME <= TRUNC(M.CREATE_TIME) + 16/24 AND 
       M.REVERT_TIME < TRUNC(M.CREATE_TIME) + 1) OR
       (M.CREATE_TIME > TRUNC(M.CREATE_TIME) + 16/24 AND 
       TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
       TRUNC(M.REVERT_TIME) < TRUNC(M.CREATE_TIME) + 1))
       AND A.INTRADAY_FINISH = 'Y'  then
      1
     else
      0
   end �Ƿ�����,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') ����ʱ��,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') ���ʱ��,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) ��������,
   (SELECT L.LEVEL_NAME FROM CH_CUST_LEVEL L WHERE L.DICTIONARYID = '0001078' AND L.LEVEL_VALUES = A.SERVICE_LEVEL) �û��Ǽ�
   FROM ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A
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
                           '140123756',
                           '1729795994',
                           '1729795996',
                           '1729795998') OR
       (M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977')))
   --AND A.INTRADAY_FINISH = 'Y'
   --AND M.REVERT_TIME IS NOT NULL
   AND M.REVERT_TIME >= TO_DATE('20181010160000','YYYY-MM-DD HH24:MI:SS')
   AND M.REVERT_TIME < TO_DATE('20181011160000','YYYY-MM-DD HH24:MI:SS')
   ) --where ҵ������ = 'IPTV'
;
