----6��������װ�ƻ�ʩ���ɵ���ʱ��

select */*"������ʶ"||'0x05'||
       "������"||'0x05'||
       "�ͻ�����"||'0x05'||
       "ҵ������"||'0x05'||
       "P6������"||'0x05'||
       "��������ʱ��"||'0x05'||
       "�����ɷ�ʱ��"||'0x05'||
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
          (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0)-- and B.Is_Need_Test <> 'Y' 
          then
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
     WHEN M.CREATE_TIME > B.IBP_CREATE_TIME + 12/24 THEN
         1
       ELSE 
         0
   end �Ƿ�ʱ
   FROM ufms.t_Pub_Mainbill M,ufms.t_Open_Billinfo B
   WHERE M.BILL_ID = B.BILL_ID
     AND (B.SUB_TYPE = 'סլ' OR B.SUB_TYPE = '����סլ' OR B.SUB_TYPE = '����' OR
         B.SUB_TYPE = '��������')
     AND ((((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
         (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
         (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0)) OR
         B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL','POST','ADDSERV'))
     AND M.BUSINESS_ID = '0002555'
     --AND B.IBP_CREATE_TIME IS NOT NULL
     AND M.CREATE_TIME >= DATE '2018-10-13'
     AND M.CREATE_TIME < DATE '2018-10-14'
   )
;
