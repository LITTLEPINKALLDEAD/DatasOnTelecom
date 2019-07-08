select M.BILL_ID,M.BILL_SN,B.SUB_TYPE,B.BUSINESS_TYPE,B.IPTV_NUM,B.OLD_IPTV_NUM,B.hd_iptv_num,B.ag_iptv_num,B.INTRADAY_FINISH,B.SERV_LEVEL
from ufms.t_Pub_Mainbill M,ufms.t_Open_Billinfo B
WHERE M.BUSINESS_ID = '0002555' 
--AND M.BILL_ID IN ('1563524453','1578459596','1578392936')
--AND B.BUSINESS_TYPE IS NOT NULL
AND M.BILL_ID = B.BILL_ID
AND m.revert_time >= to_date('20180621160000','yyyy-mm-dd hh24:mi:ss') and m.revert_time < to_date('20180622160000','yyyy-mm-dd hh24:mi:ss')


select * from ufms.T_SA_BILL A WHERE A.INTRADAY_FINISH = 'Y' AND ROWNUM <= 10
SELECT * FROM UFMS.T_OPEN_BILLINFO B WHERE B.INTRADAY_FINISH = 'Y' AND ROWNUM <= 10 AND B.SERV_LEVEL <> ''
select B.INTRADAY_FINISH ��Ҫ����װ,B.sps_orderid P6������,B.sps_applydate �����ɷ�ʱ�� from ufms.t_Open_Billinfo B where bill_id in ('1831682021','1837432390')
select deal_code �����豸�� from ufms.T_PUB_MAINBILL    --�����豸��
select C.operate_begin_time �״���Ӧʱ�� from ufms.T_PUB_BILL_ACTION C     --�״���Ӧʱ��
SELECT *--B.SPS_ORDERID P6������,sps_applydate �����ɷ�ʱ��,M.BILL_ID ������ʶ 
FROM ufms.t_pub_mainbill M,ufms.t_open_billinfo B 
where M.bill_id = B.BILL_ID 
and m.bill_id = '964630106'

SELECT * FROM UFMS.T_OPEN_BILLINFO B WHERE B.SERV_LEVEL IS NOT NULL


SELECT * FROM UFMS.T_PUB_MAINBILL M,UFMS.T_SA_BILL A
WHERE M.BILL_ID = A.BILL_ID and m.bill_id = '964630106'

----1�����ӹ���հ�װ��

select *
/*"������ʶ"||'0x05'||
       "������"||'0x05'||
       "�ͻ�����"||'0x05'||
       "ҵ������"||'0x05'||
       "P6������"||'0x05'||
       "��Ҫ����װ"||'0x05'||
       "�Ƿ���װ"||'0x05'||
       "����ʱ��"||'0x05'||
       "���ʱ��"||'0x05'||
       "��������"||'0x05'||
       "�û��Ǽ�"||'0x0D0A'*/
from (select 
   M.BILL_ID ������ʶ,
   M.BILL_SN ������,
   B.SPS_ORDERID P6������,
   CASE
     WHEN (B.SUB_TYPE = 'סլ' OR B.SUB_TYPE = '����סլ') THEN
      '����'
     WHEN (B.SUB_TYPE = '����' OR B.SUB_TYPE = '��������') THEN
      '����'
   END �ͻ�����,
   case
     /*when B.business_type = 'POTS' then
      '����'*/
     when ((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
          (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
          (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and
          B.Is_Need_Test <> 'Y' then
      'IPTV'
     when B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL') then
      '���'
     /*when B.business_type = 'ADDSERV' then
      '����'*/
   end ҵ������,
   --decode(A.EXT_INFO, 'Y', '��', '��') "5A¥��",
   /*CASE
     WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
      1
     ELSE
      0
   END �Ƿ��ظ����,*/
   --DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) ��ʱ�޸�,
   decode(B.INTRADAY_FINISH, 'Y', '��', '��') ��Ҫ����װ,
   case
     when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
          B.INTRADAY_FINISH = 'Y' then
      1
     else
      0
   end �Ƿ���װ,
   to_char(M.CREATE_TIME,'YYYYMMDDHH24MISS') ����ʱ��,
   to_char(M.REVERT_TIME,'YYYYMMDDHH24MISS') ���ʱ��,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) ��������,
   (SELECT L.LEVEL_NAME FROM CH_CUST_LEVEL L WHERE L.DICTIONARYID = '0002350' AND L.LEVEL_VALUES = B.SERV_LEVEL) �û��Ǽ�
   --B.SERV_LEVEL �û��Ǽ�
   FROM ufms.t_Pub_Mainbill M,ufms.t_Open_Billinfo B
   WHERE M.BILL_ID = B.BILL_ID
     AND (B.SUB_TYPE = 'סլ' OR B.SUB_TYPE = '����סլ' OR B.SUB_TYPE = '����' OR
         B.SUB_TYPE = '��������')
     /*AND ((((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
         (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
         (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and B.Is_Need_Test <> 'Y') OR
         B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL'))*/
     AND M.BUSINESS_ID = '0002555'
     --AND M.CREATE_TIME IS NOT NULL
     AND M.REVERT_TIME IS NOT NULL
     --AND B.SERV_LEVEL IS NOT NULL
     --AND M.REVERT_TIME >= TO_DATE('2015-11-21 16:00:00','YYYY-MM-DD HH24:MI:SS')
     --AND M.REVERT_TIME < TO_DATE('2015-11-22 16:00:00','YYYY-MM-DD HH24:MI:SS')
     AND M.REVERT_TIME >= TO_DATE('&REVERT_TIME_START','YYYY-MM-DD HH24:MI:SS')
     AND M.REVERT_TIME < TO_DATE('&REVERT_TIME_END','YYYY-MM-DD HH24:MI:SS')
     --ORDER BY M.REVERT_TIME desc
   )
   
;

select * from ufms.t_Open_Billinfo B where B.BILL_ID = '1580134174'

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
                             '140123756') then
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
     when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
          a.INTRADAY_FINISH = 'Y' then
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
                           '140123756') OR
       (M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977')))
   --AND A.INTRADAY_FINISH = 'Y'
   AND M.REVERT_TIME IS NOT NULL
   --AND ROWNUM <= 10
   --AND M.REVERT_TIME >= DATE '&REVERT_TIME_START'
   --AND M.REVERT_TIME < DATE '&REVERT_TIME_END'
   AND M.REVERT_TIME >= TO_DATE('&REVER_TIME_START','YYYY-MM-DD HH24:MI:SS')
   AND M.REVERT_TIME < TO_DATE('&REVERT_TIME_END','YYYY-MM-DD HH24:MI:SS')
   )
;

----3���������������   

select "���ϵ���ʶ"||'0x05'||
       "���ϵ���"||'0x05'||
       "�ͻ�����"||'0x05'||
       "ҵ������"||'0x05'||
       "5A¥��"||'0x05'||
       "�Ƿ��ظ����"||'0x05'||
       "��ʱ�޸�"||'0x05'||
       "��Ҫ�����޸�"||'0x05'||
       "ʵ�ʵ�����"||'0x05'||
       "����ʱ��"||'0x05'||
       "���ʱ��"||'0x05'||
       "��������"||'0x05'||
       "�ͻ��ȼ�"||'0x0D0A'
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
   CASE
     WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
      1
     ELSE
      0
   END �Ƿ��ظ����,
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) ��ʱ�޸�,
   decode(A.INTRADAY_FINISH, 'Y', '��', '��') ��Ҫ�����޸�,
   case
     when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
          a.INTRADAY_FINISH = 'Y' then
      1
     else
      0
   end ʵ�ʵ�����,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') ����ʱ��,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') ���ʱ��,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) ��������,
   (SELECT L.LEVEL_NAME FROM CH_CUST_LEVEL L WHERE L.DICTIONARYID = '0001078' AND L.LEVEL_VALUES = A.SERVICE_LEVEL) �ͻ��ȼ�
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
                           '140123756') OR
       ((SELECT (SELECT S1.BUSINESSNAME
                 FROM ufms.BAF_SYS_BUSINESS S1
                WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
         FROM ufms.BAF_SYS_BUSINESS S
        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '����') OR
       (M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977') AND
       A.LINE_TYPE IN ('6', '7')))
   AND ROWNUM <= 10
   --AND M.CREATE_TIME >= DATE '2018-06-01'
   --AND M.CREATE_TIME < DATE '2018-06-03'
   --AND M.REVERT_TIME >= DATE '2018-06-01'
   --AND M.REVERT_TIME < DATE '2018-06-03'

   )
;

SELECT * FROM ufms.t_pub_bill_action C where C.BILL_ID IN ('1056986135','1056986137','1056986111')


----4�������״���Ӧ��ʱ��

select "���ϵ���ʶ"||'0x05'||
       "���ϵ���"||'0x05'||
       "�����豸��"||'0x05'||
       "�ͻ�����"||'0x05'||
       "ҵ������"||'0x05'||
       --"�״���Ӧʱ��"||'0x05'||   --�ͱ�δ����������
       "����ʱ��"||'0x05'||
       "���ʱ��"||'0x05'||
       "�豸��������"||'0x05'||
       "�Ƿ�ʱ��Ӧ"||'0x0D0A'
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
   --TO_CHAR(C.OPERATE_BEGIN_TIME,'YYYYMMDDHH24MISS') �״���Ӧʱ��,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') ����ʱ��,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') ���ʱ��,
   M.NATIVENET_ID �豸��������,
   --A.SERVICE_LEVEL �ͻ��ȼ�
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) �Ƿ�ʱ��Ӧ
   FROM ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A--,UFMS.T_PUB_BILL_ACTION C
   WHERE M.BILL_ID = A.BILL_ID
   --AND M.BILL_ID = C.BILL_ID
   --AND C.OPERATE_BEGIN_TIME <> ''
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
       ((SELECT (SELECT S1.BUSINESSNAME
                 FROM ufms.BAF_SYS_BUSINESS S1
                WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
         FROM ufms.BAF_SYS_BUSINESS S
        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '����') OR
       (M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977') AND
       A.LINE_TYPE IN ('6', '7')))
   AND M.REVERT_TIME >= TO_DATE('&start','YYYYMMDDHH24MISS')
   AND M.REVERT_TIME < TO_DATE('&end','YYYYMMDDHH24MISS')
   )
;

select C.* from ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A,UFMS.T_PUB_BILL_ACTION C where M.BILL_ID = A.BILL_ID AND M.BILL_ID = C.BILL_ID AND ROWNUM < 11--AND C.OPERATE_BEGIN_TIME <> ''


----5�����������޸���ʱ��

select "���ϵ���ʶ"||'0x05'||
       "���ϵ���"||'0x05'||
       "�ͻ�����"||'0x05'||
       "ҵ������"||'0x05'||
       "5A¥��"||'0x05'||
       "�Ƿ��ظ����"||'0x05'||
       "��ʱ�޸�"||'0x05'||
       "��Ҫ�����޸�"||'0x05'||
       "ʵ�ʵ�����"||'0x05'||
       "����ʱ��"||'0x05'||
       "���ʱ��"||'0x05'||
       "�ͻ��Ǽ�"||'0x05'||
       "��������"||'0x0D0A'
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
   CASE
     WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
      1
     ELSE
      0
   END �Ƿ��ظ����,
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) ��ʱ�޸�,
   decode(A.INTRADAY_FINISH, 'Y', '��', '��') ��Ҫ�����޸�,
   case
     when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
          a.INTRADAY_FINISH = 'Y' then
      1
     else
      0
   end ʵ�ʵ�����,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') ����ʱ��,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') ���ʱ��,
   A.SERVICE_LEVEL �ͻ��Ǽ�,
   M.NATIVENET_ID ��������
   
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
                           '140123756') OR
       ((SELECT (SELECT S1.BUSINESSNAME
                 FROM ufms.BAF_SYS_BUSINESS S1
                WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
         FROM ufms.BAF_SYS_BUSINESS S
        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '����') OR
       (M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977') AND A.LINE_TYPE IN ('6', '7')))
   AND ROWNUM <= 10
   --AND M.CREATE_TIME >= DATE '2018-06-01'
   --AND M.CREATE_TIME < DATE '2018-06-03'
   --AND M.REVERT_TIME >= DATE '2018-06-01'
   --AND M.REVERT_TIME < DATE '2018-06-03'
   )
;


----6��������װ�ƻ�ʩ���ɵ���ʱ��

select */*"������ʶ"||'0x05'||
       "������"||'0x05'||
       "�ͻ�����"||'0x05'||
       "ҵ������"||'0x05'||
       "P6������"||'0x05'||
       "��������ʱ��"||'0x05'||
       "�����ɷ�ʱ��"||'0x05'||    --
       "��������"||'0x05'||
       "�Ƿ�ʱ"||'0x0D0A'*/
from (select 
   M.BILL_ID ������ʶ,
   M.BILL_SN ������,
   CASE
     WHEN (B.SUB_TYPE = 'סլ' OR B.SUB_TYPE = '����סլ') THEN
      '����'
     WHEN (B.SUB_TYPE = '����' OR B.SUB_TYPE = '��������') THEN
      '����'
   END �ͻ�����,
   case
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
   B.SPS_ORDERID P6������,
   TO_CHAR(B.ibp_create_time,'YYYYMMDDHH24MISS') ��������ʱ��,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') �����ɷ�ʱ��,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) ��������,
   CASE
     WHEN 
   
   --DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) �Ƿ�ʱ
   FROM ufms.t_Pub_Mainbill M,ufms.t_Open_Billinfo B
   WHERE M.BILL_ID = B.BILL_ID
     AND (B.SUB_TYPE = 'סլ' OR B.SUB_TYPE = '����סլ' OR B.SUB_TYPE = '����' OR
         B.SUB_TYPE = '��������')
     AND ((((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
         (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
         (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and B.Is_Need_Test <> 'Y') OR
         B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL','POST','ADDSERV'))
     AND M.BUSINESS_ID = '0002555'
     --AND ROWNUM 
     AND B.IBP_CREATE_TIME IS NOT NULL
     AND M.REVERT_TIME >= DATE '2018-08-20'
     AND M.REVERT_TIME < DATE '2018-08-22'
   ) --where ҵ������ in ('IPTV')
;


select round(to_number(to_date()-)*24)


select
to_number(TO_DATE('2018-08-02 5:00:00','yyyy-mm-dd hh24:mi:ss')-TO_DATE('2018-08-01 17:00:01','yyyy-mm-dd hh24:mi:ss'))*24 as Day
from dual;


----7�������ظ����������

select "���ϵ���ʶ"||'0x05'||
       "���ϵ���"||'0x05'||
       "�ͻ�����"||'0x05'||
       "ҵ������"||'0x05'||
       "5A¥��"||'0x05'||
       "�Ƿ��ظ����"||'0x05'||
       "��ʱ�޸�"||'0x05'||
       "��Ҫ�����޸�"||'0x05'||
       "ʵ�ʵ�����"||'0x05'||
       "����ʱ��"||'0x05'||
       "���ʱ��"||'0x05'||
       "�ͻ��Ǽ�"||'0x05'||
       "��������"||'0x0D0A'
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
   CASE
     WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
      1
     ELSE
      0
   END �Ƿ��ظ����,
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) ��ʱ�޸�,
   decode(A.INTRADAY_FINISH, 'Y', '��', '��') ��Ҫ�����޸�,
   case
     when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
          a.INTRADAY_FINISH = 'Y' then
      1
     else
      0
   end ʵ�ʵ�����,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') ����ʱ��,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') ���ʱ��,
   A.SERVICE_LEVEL �ͻ��Ǽ�,
   M.NATIVENET_ID ��������
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
                           '140123756') OR
       ((SELECT (SELECT S1.BUSINESSNAME
                 FROM ufms.BAF_SYS_BUSINESS S1
                WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
         FROM ufms.BAF_SYS_BUSINESS S
        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '����') OR
       (M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977') AND
       A.LINE_TYPE IN ('6', '7')))
   AND ROWNUM <= 10
   --AND M.CREATE_TIME >= DATE '2018-06-01'
   --AND M.CREATE_TIME < DATE '2018-06-03'
   --AND M.REVERT_TIME >= DATE '2018-06-01'
   --AND M.REVERT_TIME < DATE '2018-06-03'
   )
;


       
     
-----------------------------------------------------------------------------------

SELECT temp2.����,
       temp2.�ͻ��ȼ�,
       TEMP2.�ͻ�����,
       temp2.ҵ������,
       SUM(TEMP2.�����) �����,
       SUM(TEMP2.�ظ���湤����) �ظ���湤����,
       SUM(TEMP2.�û���) �û���
  FROM (SELECT /*(SELECT U.BUREAUNAME
                  FROM ufms.BAF_PUB_BUREAU U
                 WHERE U.BUREAUID = M.NATIVENET_ID) ����,
               (SELECT I.ITEMNAME
                  FROM ufms.BAF_SYS_DICTIONARY D, ufms.BAF_SYS_DICTIONARY_ITEM I
                 WHERE D.DICTIONARYID = I.DICTIONARYID
                   AND D.DICTIONARYCODE IN ('IDD_SA_SERVICELEVEL')
                   AND I.ISVALID = 'Y'
                   AND I.ITEMVALUE = A.SERVICE_LEVEL) �ͻ��ȼ�,*/
               M.NATIVENET_ID ����,
               A.SERVICE_LEVEL �ͻ��ȼ�,
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
               1 �����,
               CASE
                 WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
                  1
                 ELSE
                  0
               END �ظ���湤����,
               0 �û���
          FROM ufms.t_Pub_Mainbill M, ufms.T_SA_BILL_HIS A
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
           --AND M.ARCH_TIME >= DATE '2018-3-1' --��ʼʱ��
           --AND A.ARCH_TIME >= DATE '2018-3-1' --��ʼʱ��
        /*UNION ALL
        SELECT TEMP.����,
               '' �ͻ��ȼ�,
               TEMP.�ͻ�����,
               DECODE(TEMP.SPECIALTY, '�̻�', '�̻�', '���', '���', 'IPTV') ҵ������,
               0 �����,
               0 �ظ���湤����,
               TEMP.USERNUM �û���
          FROM (SELECT UM.SPECIALTY,
                       um.user_type �ͻ�����,
                       sum(TO_NUMBER(UM.USERNUM)) USERNUM,
                       (SELECT U.BUREAUNAME
                          FROM BAF_PUB_BUREAU U
                         WHERE U.BUREAUID = BR.PARENTBUREAUID) ����
                  FROM RT_SA_USERNUM UM, RT_SA_BUREAU_RELATION BR
                 WHERE UM.NATIVENET_ID = BR.OUTBUREAUID
                   and UM.SIMPLESM = TRUNC(DATE '2018-4-1', 'MM')
                --  AND UM.SPECIALTY IN ('�̻�', '���')
                 group by UM.SPECIALTY, um.user_type,BR.PARENTBUREAUID) TEMP*/) TEMP2
 GROUP BY temp2.����,
          temp2.�ͻ��ȼ�,
          TEMP2.�ͻ�����,
          temp2.ҵ������;

--3 �޸���ʱ��

SELECT TEMP.����,
       TEMP.�ͻ��ȼ�,
       TEMP.�ͻ�����,
       temp.ҵ������,
       TEMP."5A¥��",
       SUM(TEMP.������) ������,
       sum(temp.��ʱ��) ��ʱ��
  FROM (SELECT M.NATIVENET_ID ����,
               A.SERVICE_LEVEL �ͻ��ȼ�,
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
               decode(A.EXT_INFO, 'Y', '��', '��') "5A¥��",
               1 ������,
               DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) ��ʱ��
               /*(SELECT U.BUREAUNAME
                  FROM BAF_PUB_BUREAU U
                 WHERE U.BUREAUID = M.NATIVENET_ID) ����,
               (SELECT I.ITEMNAME
                  FROM BAF_SYS_DICTIONARY D, BAF_SYS_DICTIONARY_ITEM I
                 WHERE D.DICTIONARYID = I.DICTIONARYID
                   AND D.DICTIONARYCODE IN ('IDD_SA_SERVICELEVEL')
                   AND I.ISVALID = 'Y'
                   AND I.ITEMVALUE = A.SERVICE_LEVEL) �ͻ��ȼ�*/
          FROM ufms.t_Pub_Mainbill M, ufms.T_SA_BILL_HIS A
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
           --AND M.ARCH_TIME >= DATE '2018-3-1' --��ʼʱ��
           --AND M.ARCH_TIME < DATE '2018-4-1' --����ʱ��
           AND A.ARCH_TIME >= DATE '2018-3-1' --��ʼʱ��
           AND A.ARCH_TIME < DATE '2018-4-1' --����ʱ��
        ) temp
 group by TEMP.�ͻ�����,
          temp.ҵ������,
          TEMP."5A¥��",
          TEMP.����,
          TEMP.�ͻ��ȼ�;

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
       /*(SELECT U.BUREAUNAME
          FROM BAF_PUB_BUREAU U
         WHERE U.BUREAUID = M.NATIVENET_ID) ����,
       (SELECT IB.ITEMNAME
          FROM BAF_SYS_DICTIONARY I, BAF_SYS_DICTIONARY_ITEM IB
         WHERE IB.DICTIONARYID = I.DICTIONARYID
           AND I.DICTIONARYCODE = 'IDD_OPEN_SERV_LEVEL'
           AND IB.ITEMVALUE = B.SERV_LEVEL
           AND ROWNUM = 1) ����ȼ�*/
  FROM ufms.t_Pub_Mainbill M, ufms.T_OPEN_BILLINFO_HIS B
 WHERE M.BILL_ID = B.BILL_ID
   AND (B.SUB_TYPE = 'סլ' OR B.SUB_TYPE = '����סլ' OR B.SUB_TYPE = '����' OR
       B.SUB_TYPE = '��������')
   AND ((((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
       (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
       (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and B.Is_Need_Test <> 'Y') OR
       B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL'))
   AND M.BUSINESS_ID = '0002555'
   AND B.ARCH_TIME >= DATE '2018-3-1'
   AND B.ARCH_TIME < DATE '2018-4-1';
   --AND M.ARCH_TIME >= DATE '2018-3-1'
   --AND M.ARCH_TIME < DATE '2018-4-1';

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
       /*(SELECT U.BUREAUNAME
          FROM BAF_PUB_BUREAU U
         WHERE U.BUREAUID = M.NATIVENET_ID) ����,
       (SELECT I.ITEMNAME
          FROM BAF_SYS_DICTIONARY D, BAF_SYS_DICTIONARY_ITEM I
         WHERE D.DICTIONARYID = I.DICTIONARYID
           AND D.DICTIONARYCODE IN ('IDD_SA_SERVICELEVEL')
           AND I.ISVALID = 'Y'
           AND I.ITEMVALUE = A.SERVICE_LEVEL) �ͻ��ȼ�*/
  FROM ufms.t_Pub_Mainbill M, ufms.T_SA_BILL A
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
   --AND M.ARCH_TIME >= DATE '2018-3-1' --��ʼʱ��
   --AND M.ARCH_TIME < DATE '2018-4-1' --����ʱ��
   --AND A.ARCH_TIME >= DATE '2018-6-1' --��ʼʱ��
   --AND A.ARCH_TIME < DATE '2018-6-5' --����ʱ��
   AND A.Occur_Time >= DATE '2018-6-1' --��ʼʱ��
   AND A.Occur_Time < DATE '2018-6-5' --����ʱ��
;

select * from  ufms.T_SA_BILL a;
select a.bill_id||';5'||a.bill_type from  ufms.T_SA_BILL a;
select * from ufms.t_Pub_Mainbill


select file_name,bytes/1024/1024||'M' "size" from dba_data_files;
--

DROP TABLE CH_CUST_LEVEL;
CREATE TABLE CH_CUST_LEVEL(
LEVEL_VALUES VARCHAR(40),
LEVEL_NAME VARCHAR(40),
DICTIONARYID VARCHAR(10),
PRIMARY KEY(LEVEL_VALUES,DICTIONARYID)
);

SELECT * FROM CH_CUST_LEVEL

INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('5A','A','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('��','3','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('��ʯ','4','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('����','5','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('4A','B','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('3A','C','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('2A','D','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('1A','E','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('5B','F','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('4B','G','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('3B','H','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('2B','I','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('1B','J','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('��ͨ','-1','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('�׽�','7','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('����','8','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('5��','e','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('6��','f','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('7��','g','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('4��','d','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('1��','a','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('2��','b','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('3��','c','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('��ͨ','D','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('�꿨','A','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('��','B','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('����','C','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('����VIP��Ӣ��','����VIP��Ӣ��','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('�׽�','�׽�','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('����','����','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('��','��','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('��ʯ��','��ʯ��','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('3B','3B','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('2B','2B','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('1B','1B','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('5A','5A','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('4A','4A','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('3A','3A','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('2A','2A','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('1A','1A','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('5B','5B','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('4B','4B','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('������','������','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('�����','�����','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('�����','�����','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('����','����','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('����','����','0002350');
