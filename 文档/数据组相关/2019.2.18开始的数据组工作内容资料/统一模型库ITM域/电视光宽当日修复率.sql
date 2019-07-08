---(M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977') AND
---       A.LINE_TYPE IN ('6', '7')

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
                             '140123756',
                             '1729795994',
                             '1729795996',
                             '1729795998') then
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
     when ((M.CREATE_TIME <= TRUNC(M.CREATE_TIME) + 16/24 AND 
       M.REVERT_TIME < TRUNC(M.CREATE_TIME) + 1) OR
       (M.CREATE_TIME > TRUNC(M.CREATE_TIME) + 16/24 AND 
       TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
       TRUNC(M.REVERT_TIME) < TRUNC(M.CREATE_TIME) + 1))
       AND A.INTRADAY_FINISH = 'Y'  then
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
                           '140123756',
                           '1729795994',
                           '1729795996',
                           '1729795998') OR
       (M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977')))
   --AND A.INTRADAY_FINISH = 'Y'
   --AND M.REVERT_TIME IS NOT NULL
   AND M.REVERT_TIME >= TO_DATE('20181010160000','YYYY-MM-DD HH24:MI:SS')
   AND M.REVERT_TIME < TO_DATE('20181011160000','YYYY-MM-DD HH24:MI:SS')
   ) --where 业务类型 = 'IPTV'
;
