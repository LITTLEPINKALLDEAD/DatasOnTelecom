

----1、电视光宽当日安装率

select 
  temp.工单标识,
  temp.工单号,
  temp.客户类型,
  temp.业务类型,
  temp.P6定单号,
  temp.需要当日装,
  CASE
    WHEN (TRUNC(temp.首次预约开始时间) = TRUNC(TEMP.ibp_create_time) OR temp.改约时间为当天 = 1) and
        TRUNC(temp.ibp_create_time) <> TRUNC(temp.revert_time) AND temp.INTRADAY_FINISH ='Y'  THEN
    0
    WHEN temp.ibp_create_time >= TRUNC(temp.ibp_create_time) + 16 / 24 and
        temp.ibp_create_time < TRUNC(temp.ibp_create_time) + 1 AND
        temp.首次预约开始时间 >= TRUNC(temp.ibp_create_time) + 1 AND
        temp.首次预约开始时间 < TRUNC(temp.ibp_create_time) + 2  AND
        temp.revert_time >= temp.ibp_create_time + 1 AND temp.INTRADAY_FINISH ='Y' THEN
     0
    WHEN temp.reimburse_flag='Y'AND temp.INTRADAY_FINISH ='Y' THEN
      0
    WHEN TEMP.需要当日装 = '否'THEN
      0
    ELSE
    1
  END 是否当日装,
  temp.创建时间,
  temp.完成时间,
  temp.所属区局,
  temp.用户星级
from (select 
   M.BILL_ID 工单标识,
   M.BILL_SN 工单号,
   B.SPS_ORDERID P6定单号,
   CASE
     WHEN (B.SUB_TYPE = '住宅' OR B.SUB_TYPE = '公务住宅') THEN
      '公客'
     WHEN (B.SUB_TYPE = '政企' OR B.SUB_TYPE = '公务政企') THEN
      '政企'
   END 客户类型,
   case
     when ((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
          (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
          (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0)-- and B.Is_Need_Test <> 'Y' 
          then
      'IPTV'
     when B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL') then
      '宽带'
   end 业务类型,
   decode(B.INTRADAY_FINISH, 'Y', '是', '否') 需要当日装,
   to_char(M.CREATE_TIME,'YYYYMMDDHH24MISS') 创建时间,
   to_char(M.REVERT_TIME,'YYYYMMDDHH24MISS') 完成时间,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) 所属区局,
   B.owner_account_star_group 用户星级,
   (SELECT s.suspend_begin_time
      FROM ufms.T_PUB_BILL_SUSPEND S
     WHERE S.BILL_ID = B.BILL_ID
       AND S.SUSPEND_ID =
           (SELECT MIN(S1.SUSPEND_ID)
              FROM ufms.T_PUB_BILL_SUSPEND S1
             WHERE S1.BILL_ID = M.BILL_ID
               AND S1.SUSPEND_TYPE = 'BOOKING') --查第一笔预约
       AND S.BUSINESS_ID = '0002555') 首次预约开始时间,
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
   END 改约时间为当天,
   b.ibp_create_time,
   M.REVERT_TIME,
   B.REIMBURSE_FLAG,
   B.INTRADAY_FINISH
   FROM ufms.t_Pub_Mainbill M,ufms.t_Open_Billinfo B
   WHERE M.BILL_ID = B.BILL_ID
     AND (B.SUB_TYPE = '住宅' OR B.SUB_TYPE = '公务住宅' OR B.SUB_TYPE = '政企' OR
         B.SUB_TYPE = '公务政企')
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
