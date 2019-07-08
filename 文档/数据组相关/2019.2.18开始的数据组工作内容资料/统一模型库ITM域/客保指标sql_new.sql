select M.BILL_ID,M.BILL_SN,B.SUB_TYPE,B.BUSINESS_TYPE,B.IPTV_NUM,B.OLD_IPTV_NUM,B.hd_iptv_num,B.ag_iptv_num,B.INTRADAY_FINISH,B.SERV_LEVEL
from ufms.t_Pub_Mainbill M,ufms.t_Open_Billinfo B
WHERE M.BUSINESS_ID = '0002555' 
--AND M.BILL_ID IN ('1563524453','1578459596','1578392936')
--AND B.BUSINESS_TYPE IS NOT NULL
AND M.BILL_ID = B.BILL_ID
AND m.revert_time >= to_date('20180621160000','yyyy-mm-dd hh24:mi:ss') and m.revert_time < to_date('20180622160000','yyyy-mm-dd hh24:mi:ss')


select * from ufms.T_SA_BILL A WHERE A.INTRADAY_FINISH = 'Y' AND ROWNUM <= 10
SELECT * FROM UFMS.T_OPEN_BILLINFO B WHERE B.INTRADAY_FINISH = 'Y' AND ROWNUM <= 10 AND B.SERV_LEVEL <> ''
select B.INTRADAY_FINISH 需要当日装,B.sps_orderid P6定单号,B.sps_applydate 工单派发时间 from ufms.t_Open_Billinfo B where bill_id in ('1831682021','1837432390')
select deal_code 报障设备号 from ufms.T_PUB_MAINBILL    --报障设备号
select C.operate_begin_time 首次响应时间 from ufms.T_PUB_BILL_ACTION C     --首次响应时间
SELECT *--B.SPS_ORDERID P6定单号,sps_applydate 工单派发时间,M.BILL_ID 工单标识 
FROM ufms.t_pub_mainbill M,ufms.t_open_billinfo B 
where M.bill_id = B.BILL_ID 
and m.bill_id = '964630106'

SELECT * FROM UFMS.T_OPEN_BILLINFO B WHERE B.SERV_LEVEL IS NOT NULL


SELECT * FROM UFMS.T_PUB_MAINBILL M,UFMS.T_SA_BILL A
WHERE M.BILL_ID = A.BILL_ID and m.bill_id = '964630106'

----1、电视光宽当日安装率

select *
/*"工单标识"||'0x05'||
       "工单号"||'0x05'||
       "客户类型"||'0x05'||
       "业务类型"||'0x05'||
       "P6定单号"||'0x05'||
       "需要当日装"||'0x05'||
       "是否当日装"||'0x05'||
       "创建时间"||'0x05'||
       "完成时间"||'0x05'||
       "所属区局"||'0x05'||
       "用户星级"||'0x0D0A'*/
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
     /*when B.business_type = 'POTS' then
      '语音'*/
     when ((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
          (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
          (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and
          B.Is_Need_Test <> 'Y' then
      'IPTV'
     when B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL') then
      '宽带'
     /*when B.business_type = 'ADDSERV' then
      '智能'*/
   end 业务类型,
   --decode(A.EXT_INFO, 'Y', '是', '否') "5A楼宇",
   /*CASE
     WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
      1
     ELSE
      0
   END 是否重复申告,*/
   --DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) 及时修复,
   decode(B.INTRADAY_FINISH, 'Y', '是', '否') 需要当日装,
   case
     when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
          B.INTRADAY_FINISH = 'Y' then
      1
     else
      0
   end 是否当日装,
   to_char(M.CREATE_TIME,'YYYYMMDDHH24MISS') 创建时间,
   to_char(M.REVERT_TIME,'YYYYMMDDHH24MISS') 完成时间,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) 所属区局,
   (SELECT L.LEVEL_NAME FROM CH_CUST_LEVEL L WHERE L.DICTIONARYID = '0002350' AND L.LEVEL_VALUES = B.SERV_LEVEL) 用户星级
   --B.SERV_LEVEL 用户星级
   FROM ufms.t_Pub_Mainbill M,ufms.t_Open_Billinfo B
   WHERE M.BILL_ID = B.BILL_ID
     AND (B.SUB_TYPE = '住宅' OR B.SUB_TYPE = '公务住宅' OR B.SUB_TYPE = '政企' OR
         B.SUB_TYPE = '公务政企')
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

----2、电视光宽当日修复率

select */*"故障单标识"||'0x05'||
       "故障单号"||'0x05'||
       "客户类型"||'0x05'||
       "业务类型"||'0x05'||
       "5A楼宇"||'0x05'||
       "是否重复申告"||'0x05'||
       "及时修复"||'0x05'||
       "需要当日修复"||'0x05'||
       "是否当日修"||'0x05'||
       "创建时间"||'0x05'||
       "完成时间"||'0x05'||
       "所属区局"||'0x05'||
       "用户星级"||'0x0D0A'*/
from (select 
   M.BILL_ID 故障单标识,
   M.BILL_SN 故障单号,
   CASE
    WHEN (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR
         A.USER_TYPE = '普通宿舍' OR A.USER_TYPE = '公用' OR
         A.USER_TYPE IS NULL) THEN
     '公客'
    WHEN (A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR
         A.USER_TYPE = '企业') THEN
     '政企'
   end 客户类型,
   case
     /*when (SELECT (SELECT S1.BUSINESSNAME
                     FROM ufms.BAF_SYS_BUSINESS S1
                    WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
             FROM ufms.BAF_SYS_BUSINESS S
            WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音' then
      '固话'*/
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
      '宽带'
   end 业务类型,
   decode(A.EXT_INFO, 'Y', '是', '否') "5A楼宇",
   CASE
     WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
      1
     ELSE
      0
   END 是否重复申告,
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) 及时修复,
   decode(A.INTRADAY_FINISH, 'Y', '是', '否') 需要当日修复,
   case
     when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
          a.INTRADAY_FINISH = 'Y' then
      1
     else
      0
   end 是否当日修,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') 创建时间,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') 完成时间,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) 所属区局,
   (SELECT L.LEVEL_NAME FROM CH_CUST_LEVEL L WHERE L.DICTIONARYID = '0001078' AND L.LEVEL_VALUES = A.SERVICE_LEVEL) 用户星级
   FROM ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A
   WHERE M.BILL_ID = A.BILL_ID
   AND M.SPECIALTY_ID <> '22465958' --剔除测修单
      --AND M.BILL_ID = TMP.BILL_ID
   AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
   AND M.NATIVENET_ID <> '0010823'
      --AND TMP.ISINPUT = 'N'
   AND M.BUSINESS_ID = '0001024'
   AND ((A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR A.USER_TYPE = '企业') OR
       (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR A.USER_TYPE = '普通宿舍' OR
       A.USER_TYPE = '公用' OR A.USER_TYPE IS NULL))
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

----3、固网故障申告率   

select "故障单标识"||'0x05'||
       "故障单号"||'0x05'||
       "客户类型"||'0x05'||
       "业务类型"||'0x05'||
       "5A楼宇"||'0x05'||
       "是否重复申告"||'0x05'||
       "及时修复"||'0x05'||
       "需要当日修复"||'0x05'||
       "实际当日修"||'0x05'||
       "创建时间"||'0x05'||
       "完成时间"||'0x05'||
       "所属区局"||'0x05'||
       "客户等级"||'0x0D0A'
from (select 
   M.BILL_ID 故障单标识,
   M.BILL_SN 故障单号,
   CASE
    WHEN (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR
         A.USER_TYPE = '普通宿舍' OR A.USER_TYPE = '公用' OR
         A.USER_TYPE IS NULL) THEN
     '公客'
    WHEN (A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR
         A.USER_TYPE = '企业') THEN
     '政企'
   end 客户类型,
   case
     when (SELECT (SELECT S1.BUSINESSNAME
                     FROM ufms.BAF_SYS_BUSINESS S1
                    WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
             FROM ufms.BAF_SYS_BUSINESS S
            WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音' then
      '固话'
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
      '宽带'
   end 业务类型,
   decode(A.EXT_INFO, 'Y', '是', '否') "5A楼宇",
   CASE
     WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
      1
     ELSE
      0
   END 是否重复申告,
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) 及时修复,
   decode(A.INTRADAY_FINISH, 'Y', '是', '否') 需要当日修复,
   case
     when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
          a.INTRADAY_FINISH = 'Y' then
      1
     else
      0
   end 实际当日修,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') 创建时间,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') 完成时间,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) 所属区局,
   (SELECT L.LEVEL_NAME FROM CH_CUST_LEVEL L WHERE L.DICTIONARYID = '0001078' AND L.LEVEL_VALUES = A.SERVICE_LEVEL) 客户等级
   FROM ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A
   WHERE M.BILL_ID = A.BILL_ID
   AND M.SPECIALTY_ID <> '22465958' --剔除测修单
      --AND M.BILL_ID = TMP.BILL_ID
   AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
   AND M.NATIVENET_ID <> '0010823'
      --AND TMP.ISINPUT = 'N'
   AND M.BUSINESS_ID = '0001024'
   AND ((A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR A.USER_TYPE = '企业') OR
       (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR A.USER_TYPE = '普通宿舍' OR
       A.USER_TYPE = '公用' OR A.USER_TYPE IS NULL))
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
        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音') OR
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


----4、固网首次响应及时率

select "故障单标识"||'0x05'||
       "故障单号"||'0x05'||
       "报障设备号"||'0x05'||
       "客户类型"||'0x05'||
       "业务类型"||'0x05'||
       --"首次响应时间"||'0x05'||   --客保未开发，暂无
       "创建时间"||'0x05'||
       "完成时间"||'0x05'||
       "设备所属区局"||'0x05'||
       "是否及时响应"||'0x0D0A'
from (select 
   M.BILL_ID 故障单标识,
   M.BILL_SN 故障单号,
   M.DEAL_CODE 报障设备号,
   CASE
    WHEN (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR
         A.USER_TYPE = '普通宿舍' OR A.USER_TYPE = '公用' OR
         A.USER_TYPE IS NULL) THEN
     '公客'
    WHEN (A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR
         A.USER_TYPE = '企业') THEN
     '政企'
   end 客户类型,
   case
     when (SELECT (SELECT S1.BUSINESSNAME
                     FROM ufms.BAF_SYS_BUSINESS S1
                    WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
             FROM ufms.BAF_SYS_BUSINESS S
            WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音' then
      '固话'
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
      '宽带'
   end 业务类型,
   --TO_CHAR(C.OPERATE_BEGIN_TIME,'YYYYMMDDHH24MISS') 首次响应时间,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') 创建时间,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') 完成时间,
   M.NATIVENET_ID 设备所属区局,
   --A.SERVICE_LEVEL 客户等级
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) 是否及时响应
   FROM ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A--,UFMS.T_PUB_BILL_ACTION C
   WHERE M.BILL_ID = A.BILL_ID
   --AND M.BILL_ID = C.BILL_ID
   --AND C.OPERATE_BEGIN_TIME <> ''
   AND M.SPECIALTY_ID <> '22465958' --剔除测修单
      --AND M.BILL_ID = TMP.BILL_ID
   AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
   AND M.NATIVENET_ID <> '0010823'
      --AND TMP.ISINPUT = 'N'
   AND M.BUSINESS_ID = '0001024'
   AND ((A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR A.USER_TYPE = '企业') OR
       (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR A.USER_TYPE = '普通宿舍' OR
       A.USER_TYPE = '公用' OR A.USER_TYPE IS NULL))
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
        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音') OR
       (M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977') AND
       A.LINE_TYPE IN ('6', '7')))
   AND M.REVERT_TIME >= TO_DATE('&start','YYYYMMDDHH24MISS')
   AND M.REVERT_TIME < TO_DATE('&end','YYYYMMDDHH24MISS')
   )
;

select C.* from ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A,UFMS.T_PUB_BILL_ACTION C where M.BILL_ID = A.BILL_ID AND M.BILL_ID = C.BILL_ID AND ROWNUM < 11--AND C.OPERATE_BEGIN_TIME <> ''


----5、固网故障修复及时率

select "故障单标识"||'0x05'||
       "故障单号"||'0x05'||
       "客户类型"||'0x05'||
       "业务类型"||'0x05'||
       "5A楼宇"||'0x05'||
       "是否重复申告"||'0x05'||
       "及时修复"||'0x05'||
       "需要当日修复"||'0x05'||
       "实际当日修"||'0x05'||
       "创建时间"||'0x05'||
       "完成时间"||'0x05'||
       "客户星级"||'0x05'||
       "所属区局"||'0x0D0A'
from (select 
   M.BILL_ID 故障单标识,
   M.BILL_SN 故障单号,
   CASE
    WHEN (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR
         A.USER_TYPE = '普通宿舍' OR A.USER_TYPE = '公用' OR
         A.USER_TYPE IS NULL) THEN
     '公客'
    WHEN (A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR
         A.USER_TYPE = '企业') THEN
     '政企'
   end 客户类型,
   case
     when (SELECT (SELECT S1.BUSINESSNAME
                     FROM ufms.BAF_SYS_BUSINESS S1
                    WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
             FROM ufms.BAF_SYS_BUSINESS S
            WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音' then
      '固话'
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
      '宽带'
   end 业务类型,
   decode(A.EXT_INFO, 'Y', '是', '否') "5A楼宇",
   CASE
     WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
      1
     ELSE
      0
   END 是否重复申告,
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) 及时修复,
   decode(A.INTRADAY_FINISH, 'Y', '是', '否') 需要当日修复,
   case
     when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
          a.INTRADAY_FINISH = 'Y' then
      1
     else
      0
   end 实际当日修,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') 创建时间,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') 完成时间,
   A.SERVICE_LEVEL 客户星级,
   M.NATIVENET_ID 所属区局
   
   FROM ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A
   WHERE M.BILL_ID = A.BILL_ID
   AND M.SPECIALTY_ID <> '22465958' --剔除测修单
      --AND M.BILL_ID = TMP.BILL_ID
   AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
   AND M.NATIVENET_ID <> '0010823'
      --AND TMP.ISINPUT = 'N'
   AND M.BUSINESS_ID = '0001024'
   AND ((A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR A.USER_TYPE = '企业') OR
       (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR A.USER_TYPE = '普通宿舍' OR
       A.USER_TYPE = '公用' OR A.USER_TYPE IS NULL))
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
        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音') OR
       (M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977') AND A.LINE_TYPE IN ('6', '7')))
   AND ROWNUM <= 10
   --AND M.CREATE_TIME >= DATE '2018-06-01'
   --AND M.CREATE_TIME < DATE '2018-06-03'
   --AND M.REVERT_TIME >= DATE '2018-06-01'
   --AND M.REVERT_TIME < DATE '2018-06-03'
   )
;


----6、固网新装移机施工派单及时率

select */*"工单标识"||'0x05'||
       "工单号"||'0x05'||
       "客户类型"||'0x05'||
       "业务类型"||'0x05'||
       "P6定单号"||'0x05'||
       "定单创建时间"||'0x05'||
       "工单派发时间"||'0x05'||    --
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
          (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and
          B.Is_Need_Test <> 'Y' then
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
     WHEN 
   
   --DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) 是否及时
   FROM ufms.t_Pub_Mainbill M,ufms.t_Open_Billinfo B
   WHERE M.BILL_ID = B.BILL_ID
     AND (B.SUB_TYPE = '住宅' OR B.SUB_TYPE = '公务住宅' OR B.SUB_TYPE = '政企' OR
         B.SUB_TYPE = '公务政企')
     AND ((((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
         (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
         (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and B.Is_Need_Test <> 'Y') OR
         B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL','POST','ADDSERV'))
     AND M.BUSINESS_ID = '0002555'
     --AND ROWNUM 
     AND B.IBP_CREATE_TIME IS NOT NULL
     AND M.REVERT_TIME >= DATE '2018-08-20'
     AND M.REVERT_TIME < DATE '2018-08-22'
   ) --where 业务类型 in ('IPTV')
;


select round(to_number(to_date()-)*24)


select
to_number(TO_DATE('2018-08-02 5:00:00','yyyy-mm-dd hh24:mi:ss')-TO_DATE('2018-08-01 17:00:01','yyyy-mm-dd hh24:mi:ss'))*24 as Day
from dual;


----7、固网重复故障申告率

select "故障单标识"||'0x05'||
       "故障单号"||'0x05'||
       "客户类型"||'0x05'||
       "业务类型"||'0x05'||
       "5A楼宇"||'0x05'||
       "是否重复申告"||'0x05'||
       "及时修复"||'0x05'||
       "需要当日修复"||'0x05'||
       "实际当日修"||'0x05'||
       "创建时间"||'0x05'||
       "完成时间"||'0x05'||
       "客户星级"||'0x05'||
       "所属区局"||'0x0D0A'
from (select 
   M.BILL_ID 故障单标识,
   M.BILL_SN 故障单号,
   CASE
    WHEN (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR
         A.USER_TYPE = '普通宿舍' OR A.USER_TYPE = '公用' OR
         A.USER_TYPE IS NULL) THEN
     '公客'
    WHEN (A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR
         A.USER_TYPE = '企业') THEN
     '政企'
   end 客户类型,
   case
     when (SELECT (SELECT S1.BUSINESSNAME
                     FROM ufms.BAF_SYS_BUSINESS S1
                    WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
             FROM ufms.BAF_SYS_BUSINESS S
            WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音' then
      '固话'
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
      '宽带'
   end 业务类型,
   decode(A.EXT_INFO, 'Y', '是', '否') "5A楼宇",
   CASE
     WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
      1
     ELSE
      0
   END 是否重复申告,
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) 及时修复,
   decode(A.INTRADAY_FINISH, 'Y', '是', '否') 需要当日修复,
   case
     when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
          a.INTRADAY_FINISH = 'Y' then
      1
     else
      0
   end 实际当日修,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') 创建时间,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') 完成时间,
   A.SERVICE_LEVEL 客户星级,
   M.NATIVENET_ID 所属区局
   FROM ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A
   WHERE M.BILL_ID = A.BILL_ID
   AND M.SPECIALTY_ID <> '22465958' --剔除测修单
      --AND M.BILL_ID = TMP.BILL_ID
   AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
   AND M.NATIVENET_ID <> '0010823'
      --AND TMP.ISINPUT = 'N'
   AND M.BUSINESS_ID = '0001024'
   AND ((A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR A.USER_TYPE = '企业') OR
       (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR A.USER_TYPE = '普通宿舍' OR
       A.USER_TYPE = '公用' OR A.USER_TYPE IS NULL))
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
        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音') OR
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

SELECT temp2.区局,
       temp2.客户等级,
       TEMP2.客户类型,
       temp2.业务类型,
       SUM(TEMP2.申告数) 申告数,
       SUM(TEMP2.重复申告工单数) 重复申告工单数,
       SUM(TEMP2.用户数) 用户数
  FROM (SELECT /*(SELECT U.BUREAUNAME
                  FROM ufms.BAF_PUB_BUREAU U
                 WHERE U.BUREAUID = M.NATIVENET_ID) 区局,
               (SELECT I.ITEMNAME
                  FROM ufms.BAF_SYS_DICTIONARY D, ufms.BAF_SYS_DICTIONARY_ITEM I
                 WHERE D.DICTIONARYID = I.DICTIONARYID
                   AND D.DICTIONARYCODE IN ('IDD_SA_SERVICELEVEL')
                   AND I.ISVALID = 'Y'
                   AND I.ITEMVALUE = A.SERVICE_LEVEL) 客户等级,*/
               M.NATIVENET_ID 区局,
               A.SERVICE_LEVEL 客户等级,
               CASE
                 WHEN (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR
                      A.USER_TYPE = '普通宿舍' OR A.USER_TYPE = '公用' OR
                      A.USER_TYPE IS NULL) THEN
                  '公客'
                 WHEN (A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR
                      A.USER_TYPE = '企业') THEN
                  '政企'
               end 客户类型,
               case
                 when (SELECT (SELECT S1.BUSINESSNAME
                                 FROM ufms.BAF_SYS_BUSINESS S1
                                WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
                         FROM ufms.BAF_SYS_BUSINESS S
                        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音' then
                  '固话'
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
                  '宽带'
               end 业务类型,
               1 申告数,
               CASE
                 WHEN A.REPEAT_NUM_FAULT_CODE > 0 THEN
                  1
                 ELSE
                  0
               END 重复申告工单数,
               0 用户数
          FROM ufms.t_Pub_Mainbill M, ufms.T_SA_BILL_HIS A
         WHERE M.BILL_ID = A.BILL_ID
           AND M.SPECIALTY_ID <> '22465958' --剔除测修单
              --AND M.BILL_ID = TMP.BILL_ID
           AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
           AND M.NATIVENET_ID <> '0010823'
              --AND TMP.ISINPUT = 'N'
           AND M.BUSINESS_ID = '0001024'
           AND ((A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR
               A.USER_TYPE = '企业') OR
               (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR
               A.USER_TYPE = '普通宿舍' OR A.USER_TYPE = '公用' OR
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
           AND M.CREATE_TIME >= DATE '2018-3-1' --开始时间
           AND M.CREATE_TIME < DATE '2018-4-1' --结束时间
           --AND M.ARCH_TIME >= DATE '2018-3-1' --开始时间
           --AND A.ARCH_TIME >= DATE '2018-3-1' --开始时间
        /*UNION ALL
        SELECT TEMP.区局,
               '' 客户等级,
               TEMP.客户类型,
               DECODE(TEMP.SPECIALTY, '固话', '固话', '宽带', '宽带', 'IPTV') 业务类型,
               0 申告数,
               0 重复申告工单数,
               TEMP.USERNUM 用户数
          FROM (SELECT UM.SPECIALTY,
                       um.user_type 客户类型,
                       sum(TO_NUMBER(UM.USERNUM)) USERNUM,
                       (SELECT U.BUREAUNAME
                          FROM BAF_PUB_BUREAU U
                         WHERE U.BUREAUID = BR.PARENTBUREAUID) 区局
                  FROM RT_SA_USERNUM UM, RT_SA_BUREAU_RELATION BR
                 WHERE UM.NATIVENET_ID = BR.OUTBUREAUID
                   and UM.SIMPLESM = TRUNC(DATE '2018-4-1', 'MM')
                --  AND UM.SPECIALTY IN ('固话', '宽带')
                 group by UM.SPECIALTY, um.user_type,BR.PARENTBUREAUID) TEMP*/) TEMP2
 GROUP BY temp2.区局,
          temp2.客户等级,
          TEMP2.客户类型,
          temp2.业务类型;

--3 修复及时率

SELECT TEMP.区局,
       TEMP.客户等级,
       TEMP.客户类型,
       temp.业务类型,
       TEMP."5A楼宇",
       SUM(TEMP.故障数) 故障数,
       sum(temp.及时数) 及时数
  FROM (SELECT M.NATIVENET_ID 区局,
               A.SERVICE_LEVEL 客户等级,
               CASE
                 WHEN (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR
                      A.USER_TYPE = '普通宿舍' OR A.USER_TYPE = '公用' OR
                      A.USER_TYPE IS NULL) THEN
                  '公客'
                 WHEN (A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR
                      A.USER_TYPE = '企业') THEN
                  '政企'
               end 客户类型,
               case
                 when (SELECT (SELECT S1.BUSINESSNAME
                                 FROM ufms.BAF_SYS_BUSINESS S1
                                WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
                         FROM ufms.BAF_SYS_BUSINESS S
                        WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音' then
                  '固话'
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
                  '宽带'
               end 业务类型,
               decode(A.EXT_INFO, 'Y', '是', '否') "5A楼宇",
               1 故障数,
               DECODE(M.BILL_IS_OVER_TIME, 'Y', 0, 1) 及时数
               /*(SELECT U.BUREAUNAME
                  FROM BAF_PUB_BUREAU U
                 WHERE U.BUREAUID = M.NATIVENET_ID) 区局,
               (SELECT I.ITEMNAME
                  FROM BAF_SYS_DICTIONARY D, BAF_SYS_DICTIONARY_ITEM I
                 WHERE D.DICTIONARYID = I.DICTIONARYID
                   AND D.DICTIONARYCODE IN ('IDD_SA_SERVICELEVEL')
                   AND I.ISVALID = 'Y'
                   AND I.ITEMVALUE = A.SERVICE_LEVEL) 客户等级*/
          FROM ufms.t_Pub_Mainbill M, ufms.T_SA_BILL_HIS A
         WHERE M.BILL_ID = A.BILL_ID
           AND M.SPECIALTY_ID <> '22465958' --剔除测修单
              --AND M.BILL_ID = TMP.BILL_ID
           AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
           AND M.NATIVENET_ID <> '0010823'
              --AND TMP.ISINPUT = 'N'
           AND M.BUSINESS_ID = '0001024'
           AND ((A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR
               A.USER_TYPE = '企业') OR
               (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR
               A.USER_TYPE = '普通宿舍' OR A.USER_TYPE = '公用' OR
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
           AND M.CREATE_TIME >= DATE '2018-3-1' --开始时间
           AND M.CREATE_TIME < DATE '2018-4-1' --结束时间
           --AND M.ARCH_TIME >= DATE '2018-3-1' --开始时间
           --AND M.ARCH_TIME < DATE '2018-4-1' --结束时间
           AND A.ARCH_TIME >= DATE '2018-3-1' --开始时间
           AND A.ARCH_TIME < DATE '2018-4-1' --结束时间
        ) temp
 group by TEMP.客户类型,
          temp.业务类型,
          TEMP."5A楼宇",
          TEMP.区局,
          TEMP.客户等级;

--4
SELECT case
         when B.business_type = 'POTS' then
          '语音'
         when ((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
              (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
              (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and
              B.Is_Need_Test <> 'Y' then
          'IPTV'
         when B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL') then
          '宽带'
         when B.business_type = 'ADDSERV' then
          '智能'
       end 业务类型,
       CASE
         WHEN (B.SUB_TYPE = '住宅' OR B.SUB_TYPE = '公务住宅') THEN
          '公客'
         WHEN (B.SUB_TYPE = '政企' OR B.SUB_TYPE = '公务政企') THEN
          '政企'
       END 客户类型,
       case
         when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
              B.INTRADAY_FINISH = 'Y' then
          1
         else
          0
       end 实际当日完成,
       decode(B.INTRADAY_FINISH, 'Y', '是', '否') "当日装"
       /*(SELECT U.BUREAUNAME
          FROM BAF_PUB_BUREAU U
         WHERE U.BUREAUID = M.NATIVENET_ID) 区局,
       (SELECT IB.ITEMNAME
          FROM BAF_SYS_DICTIONARY I, BAF_SYS_DICTIONARY_ITEM IB
         WHERE IB.DICTIONARYID = I.DICTIONARYID
           AND I.DICTIONARYCODE = 'IDD_OPEN_SERV_LEVEL'
           AND IB.ITEMVALUE = B.SERV_LEVEL
           AND ROWNUM = 1) 服务等级*/
  FROM ufms.t_Pub_Mainbill M, ufms.T_OPEN_BILLINFO_HIS B
 WHERE M.BILL_ID = B.BILL_ID
   AND (B.SUB_TYPE = '住宅' OR B.SUB_TYPE = '公务住宅' OR B.SUB_TYPE = '政企' OR
       B.SUB_TYPE = '公务政企')
   AND ((((B.IPTV_NUM - B.OLD_IPTV_NUM) > 0 or
       (B.hd_iptv_num - B.OLD_hd_iptv_num) > 0 or
       (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and B.Is_Need_Test <> 'Y') OR
       B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL'))
   AND M.BUSINESS_ID = '0002555'
   AND B.ARCH_TIME >= DATE '2018-3-1'
   AND B.ARCH_TIME < DATE '2018-4-1';
   --AND M.ARCH_TIME >= DATE '2018-3-1'
   --AND M.ARCH_TIME < DATE '2018-4-1';

--5,6 电视光宽
SELECT CASE
         WHEN (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR
              A.USER_TYPE = '普通宿舍' OR A.USER_TYPE = '公用' OR
              A.USER_TYPE IS NULL) THEN
          '公客'
         WHEN (A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR
              A.USER_TYPE = '企业') THEN
          '政企'
       end 客户类型,
       case
         when (SELECT (SELECT S1.BUSINESSNAME
                         FROM ufms.BAF_SYS_BUSINESS S1
                        WHERE S1.BUSINESSID = S.PARENTBUSINESSID)
                 FROM ufms.BAF_SYS_BUSINESS S
                WHERE S.BUSINESSID = M.SPECIALTY_ID) = '语音' then
          '固话'
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
          '宽带'
       end 业务类型,
       1 故障数,
       case
         when TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
              a.INTRADAY_FINISH = 'Y' then
          1
         else
          0
       end 实际当日完成,
       decode(a.INTRADAY_FINISH, 'Y', '是', '否') "当日修",
       case
         when exists (SELECT 1
                 FROM ufms.T_PUB_BILL_CONTROL_HIS C
                WHERE C.CONTROL_TYPE = 'HASTEN'
                  AND C.CONTROL_INFO LIKE '【112系统催修】%'
                  AND C.BILL_ID = A.BILL_ID) then
          1
         else
          0
       end 催修数
       /*(SELECT U.BUREAUNAME
          FROM BAF_PUB_BUREAU U
         WHERE U.BUREAUID = M.NATIVENET_ID) 区局,
       (SELECT I.ITEMNAME
          FROM BAF_SYS_DICTIONARY D, BAF_SYS_DICTIONARY_ITEM I
         WHERE D.DICTIONARYID = I.DICTIONARYID
           AND D.DICTIONARYCODE IN ('IDD_SA_SERVICELEVEL')
           AND I.ISVALID = 'Y'
           AND I.ITEMVALUE = A.SERVICE_LEVEL) 客户等级*/
  FROM ufms.t_Pub_Mainbill M, ufms.T_SA_BILL A
 WHERE M.BILL_ID = A.BILL_ID
   AND M.SPECIALTY_ID <> '22465958' --剔除测修单
      --AND M.BILL_ID = TMP.BILL_ID
   AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
   AND M.NATIVENET_ID <> '0010823'
      --AND TMP.ISINPUT = 'N'
   AND M.BUSINESS_ID = '0001024'
   AND ((A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR A.USER_TYPE = '企业') OR
       (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR A.USER_TYPE = '普通宿舍' OR
       A.USER_TYPE = '公用' OR A.USER_TYPE IS NULL))
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
   --AND M.ARCH_TIME >= DATE '2018-3-1' --开始时间
   --AND M.ARCH_TIME < DATE '2018-4-1' --结束时间
   --AND A.ARCH_TIME >= DATE '2018-6-1' --开始时间
   --AND A.ARCH_TIME < DATE '2018-6-5' --结束时间
   AND A.Occur_Time >= DATE '2018-6-1' --开始时间
   AND A.Occur_Time < DATE '2018-6-5' --结束时间
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
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('金卡','3','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('钻石','4','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('银卡','5','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('4A','B','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('3A','C','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('2A','D','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('1A','E','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('5B','F','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('4B','G','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('3B','H','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('2B','I','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('1B','J','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('普通','-1','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('白金卡','7','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('至尊卡','8','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('5星','e','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('6星','f','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('7星','g','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('4星','d','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('1星','a','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('2星','b','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('3星','c','0001078');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('普通','D','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('钻卡','A','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('金卡','B','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('银卡','C','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('公客VIP精英卡','公客VIP精英卡','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('白金卡','白金卡','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('银卡','银卡','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('金卡','金卡','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('钻石卡','钻石卡','0002350');
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
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('政企中','政企中','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('政企高','政企高','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('政企低','政企低','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('至尊卡','至尊卡','0002350');
INSERT INTO CH_CUST_LEVEL (LEVEL_NAME,LEVEL_VALUES,DICTIONARYID) VALUES ('尊享','尊享','0002350');
