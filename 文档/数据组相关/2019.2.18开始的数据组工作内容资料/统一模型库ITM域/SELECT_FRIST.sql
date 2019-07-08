select *
from (select 
   M.BILL_ID ���ϵ���ʶ,
   M.BILL_SN ���ϵ���,
   M.DEAL_CODE �����豸��,
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
   --TO_CHAR((SELECT C.OPERATE_END_TIME FROM UFMS.T_PUB_BILL_ACTION C WHERE C.BILL_ID = M.BILL_ID AND C.REMARK LIKE '%�״���Ӧ%'),'YYYYMMDDHH24MISS') �״���Ӧʱ��,
   --C.OPERATE_END_TIME �״���Ӧʱ��,
   --c.remark ��ע,
   --c.control_ext_code1 ,
   TO_CHAR(A.FIRST_RESPONSE_TIME,'YYYYMMDDHH24MISS') �״���Ӧʱ��,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') ����ʱ��,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') ���ʱ��,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) �豸��������,
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 1, 0) �Ƿ�ʱ��Ӧ
   FROM ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A--,ufms.t_pub_bill_action C
   WHERE M.BILL_ID = A.BILL_ID
   --AND C.OPERATE_END_TIME IS NOT NULL;
   AND M.SPECIALTY_ID <> '22465958' --�޳����޵�
   AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
   AND M.NATIVENET_ID <> '0010823'
   AND M.BUSINESS_ID = '0001024'
   AND ((A.USER_TYPE = '��ҵ����' OR A.USER_TYPE = '��ҵ' OR A.USER_TYPE = '��ҵ') OR
       (A.USER_TYPE = '����' OR A.USER_TYPE = '��ͨסլ' OR A.USER_TYPE = '��ͨ����' OR
       A.USER_TYPE = '����' OR A.USER_TYPE IS NULL))
   AND (A.BUSINESS_TYPE <> 'CDMA' OR A.BUSINESS_TYPE IS NULL)
   AND (EXISTS
        (SELECT 1
           FROM ufms.BAF_SYS_BUSINESS S
          WHERE S.BUSINESSID = M.SPECIALTY_ID
            AND S.PARENTBUSINESSID = '0995070') OR
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
                           '140123756') OR
       M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977'))
   AND M.REVERT_TIME >= TO_DATE('20181210','YYYYMMDDHH24MISS')
   AND M.REVERT_TIME < TO_DATE('20181211','YYYYMMDDHH24MISS')
   --AND C.REMARK LIKE '%�״���Ӧ%'
   --AND C.CONTROL_EXT_CODE1 LIKE '____-__-__ __:__:__'
   --AND C.BILL_ID = M.BILL_ID
   )
   ;
   
   
