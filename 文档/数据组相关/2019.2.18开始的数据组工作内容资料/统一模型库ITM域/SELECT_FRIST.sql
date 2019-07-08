select *
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
   --TO_CHAR((SELECT C.OPERATE_END_TIME FROM UFMS.T_PUB_BILL_ACTION C WHERE C.BILL_ID = M.BILL_ID AND C.REMARK LIKE '%首次响应%'),'YYYYMMDDHH24MISS') 首次响应时间,
   --C.OPERATE_END_TIME 首次响应时间,
   --c.remark 备注,
   --c.control_ext_code1 ,
   TO_CHAR(A.FIRST_RESPONSE_TIME,'YYYYMMDDHH24MISS') 首次响应时间,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') 创建时间,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') 完成时间,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) 设备所属区局,
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 1, 0) 是否及时响应
   FROM ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A--,ufms.t_pub_bill_action C
   WHERE M.BILL_ID = A.BILL_ID
   --AND C.OPERATE_END_TIME IS NOT NULL;
   AND M.SPECIALTY_ID <> '22465958' --剔除测修单
   AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
   AND M.NATIVENET_ID <> '0010823'
   AND M.BUSINESS_ID = '0001024'
   AND ((A.USER_TYPE = '商业服务' OR A.USER_TYPE = '事业' OR A.USER_TYPE = '企业') OR
       (A.USER_TYPE = '个体' OR A.USER_TYPE = '普通住宅' OR A.USER_TYPE = '普通宿舍' OR
       A.USER_TYPE = '公用' OR A.USER_TYPE IS NULL))
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
   --AND C.REMARK LIKE '%首次响应%'
   --AND C.CONTROL_EXT_CODE1 LIKE '____-__-__ __:__:__'
   --AND C.BILL_ID = M.BILL_ID
   )
   ;
   
   
