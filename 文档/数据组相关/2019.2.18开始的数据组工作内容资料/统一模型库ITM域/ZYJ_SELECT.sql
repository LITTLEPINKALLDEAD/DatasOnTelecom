----6、固网新装移机施工派单及时率

select */*"工单标识"||'0x05'||
       "工单号"||'0x05'||
       "客户类型"||'0x05'||
       "业务类型"||'0x05'||
       "P6定单号"||'0x05'||
       "定单创建时间"||'0x05'||
       "工单派发时间"||'0x05'||
       "所属区局"||'0x05'||
       "是否及时"||'0x0D0A'*/
from (select 
   M.BILL_ID 工单标识,
   M.BILL_SN 工单号,
   CASE
     WHEN (B.SUB_TYPE = '住宅' OR B.SUB_TYPE = '公务住宅') THEN
      '公客'
     WHEN (B.SUB_TYPE = '政企' OR B.SUB_TYPE = '公务政企') THEN
      '政企'
   END 客户类型,
   case
     when B.business_type = 'POTS' then
      '语音'
     when ((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
          (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
          (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0)-- and B.Is_Need_Test <> 'Y' 
          then
      'IPTV'
     when B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL') then
      '宽带'
     when B.business_type = 'ADDSERV' then
      '智能'
   end 业务类型,
   B.SPS_ORDERID P6定单号,
   TO_CHAR(B.ibp_create_time,'YYYYMMDDHH24MISS') 定单创建时间,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') 工单派发时间,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) 所属区局,
   CASE
     WHEN M.CREATE_TIME > B.IBP_CREATE_TIME + 12/24 THEN
         1
       ELSE 
         0
   end 是否及时
   FROM ufms.t_Pub_Mainbill M,ufms.t_Open_Billinfo B
   WHERE M.BILL_ID = B.BILL_ID
     AND (B.SUB_TYPE = '住宅' OR B.SUB_TYPE = '公务住宅' OR B.SUB_TYPE = '政企' OR
         B.SUB_TYPE = '公务政企')
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
