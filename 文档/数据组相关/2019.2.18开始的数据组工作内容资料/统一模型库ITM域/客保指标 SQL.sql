----1，2

select * from BAF_PUB_BUREAU   --视图或表不存在
select * from ufms.BAF_PUB_BUREAU    --视图或表不存在
select * from BAF_SYS_DICTIONARY    --不存在
select * from ufms.BAF_SYS_DICTIONARY    --不存在
select * from BAF_SYS_DICTIONARY_ITEM    --不存在
select * from ufms.BAF_SYS_DICTIONARY_ITEM    --不存在

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

--
