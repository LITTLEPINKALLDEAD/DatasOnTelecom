

----1�����ӹ���հ�װ��

select 
  temp.������ʶ,
  temp.������,
  temp.�ͻ�����,
  temp.ҵ������,
  temp.P6������,
  temp.��Ҫ����װ,
  CASE
    WHEN (TRUNC(temp.�״�ԤԼ��ʼʱ��) = TRUNC(TEMP.ibp_create_time) OR temp.��Լʱ��Ϊ���� = 1) and
        TRUNC(temp.ibp_create_time) <> TRUNC(temp.revert_time) AND temp.INTRADAY_FINISH ='Y'  THEN
    0
    WHEN temp.ibp_create_time >= TRUNC(temp.ibp_create_time) + 16 / 24 and
        temp.ibp_create_time < TRUNC(temp.ibp_create_time) + 1 AND
        temp.�״�ԤԼ��ʼʱ�� >= TRUNC(temp.ibp_create_time) + 1 AND
        temp.�״�ԤԼ��ʼʱ�� < TRUNC(temp.ibp_create_time) + 2  AND
        temp.revert_time >= temp.ibp_create_time + 1 AND temp.INTRADAY_FINISH ='Y' THEN
     0
    WHEN temp.reimburse_flag='Y'AND temp.INTRADAY_FINISH ='Y' THEN
      0
    WHEN TEMP.��Ҫ����װ = '��'THEN
      0
    ELSE
    1
  END �Ƿ���װ,
  temp.����ʱ��,
  temp.���ʱ��,
  temp.��������,
  temp.�û��Ǽ�
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
     when ((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
          (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
          (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0)-- and B.Is_Need_Test <> 'Y' 
          then
      'IPTV'
     when B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL') then
      '���'
   end ҵ������,
   decode(B.INTRADAY_FINISH, 'Y', '��', '��') ��Ҫ����װ,
   to_char(M.CREATE_TIME,'YYYYMMDDHH24MISS') ����ʱ��,
   to_char(M.REVERT_TIME,'YYYYMMDDHH24MISS') ���ʱ��,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) ��������,
   B.owner_account_star_group �û��Ǽ�,
   (SELECT s.suspend_begin_time
      FROM ufms.T_PUB_BILL_SUSPEND S
     WHERE S.BILL_ID = B.BILL_ID
       AND S.SUSPEND_ID =
           (SELECT MIN(S1.SUSPEND_ID)
              FROM ufms.T_PUB_BILL_SUSPEND S1
             WHERE S1.BILL_ID = M.BILL_ID
               AND S1.SUSPEND_TYPE = 'BOOKING') --���һ��ԤԼ
       AND S.BUSINESS_ID = '0002555') �״�ԤԼ��ʼʱ��,
   CASE
     WHEN EXISTS
      (SELECT 1
             FROM ufms.T_OPEN_CRM_REQUEST R
            WHERE trunc(R.BOOK_STARTTIME) = trunc(b.ibp_create_time)
              AND R.BOOK_STARTTIME IS NOT NULL
              AND R.BILL_ID = B.BILL_ID) THEN
      1
     ELSE
      0
   END ��Լʱ��Ϊ����,
   b.ibp_create_time,
   M.REVERT_TIME,
   B.REIMBURSE_FLAG,
   B.INTRADAY_FINISH
   FROM ufms.t_Pub_Mainbill M,ufms.t_Open_Billinfo B
   WHERE M.BILL_ID = B.BILL_ID
     AND (B.SUB_TYPE = 'סլ' OR B.SUB_TYPE = '����סլ' OR B.SUB_TYPE = '����' OR
         B.SUB_TYPE = '��������')
     AND ((((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
         (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
         (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) ) OR
         B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL'))
     AND M.BUSINESS_ID = '0002555'
     AND M.REVERT_TIME >= TO_DATE('20181020','YYYY-MM-DD HH24:MI:SS')
     AND M.REVERT_TIME < TO_DATE('20181021','YYYY-MM-DD HH24:MI:SS')
     --AND B.INTRADAY_FINISH = 'Y'
     --AND TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME)
   ) temp
   --where temp.INTRADAY_FINISH = 'Y'
;
