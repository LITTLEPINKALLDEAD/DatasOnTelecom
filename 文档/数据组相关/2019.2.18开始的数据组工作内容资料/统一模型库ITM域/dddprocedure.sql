/*DROP TABLE TMP_DRZ;
CREATE TABLE TMP_DRZ
(
BILL_ID VARCHAR2(30) PRIMARY KEY,
BILL_SN VARCHAR2(30),
USER_TYPE VARCHAR2(10),
SPECIALTY_ID VARCHAR2(10),
SPS_ORDERID VARCHAR2(20),
NEED_INTRADAY_FINISH VARCHAR2(4),
INTRADAY_FINISH VARCHAR2(4),
CREATE_TIME VARCHAR2(30),
REVERT_TIME VARCHAR2(30),
AREA_CODE VARCHAR2(20),
CUST_LEVEL VARCHAR2(20)
);


DROP TABLE TMP_DRX;
CREATE TABLE TMP_DRX
(
BILL_ID VARCHAR2(30) PRIMARY KEY,
BILL_SN VARCHAR2(30),
USER_TYPE VARCHAR2(10),
SPECIALTY_ID VARCHAR2(10),
EXT_INFO VARCHAR2(4),
REPEAT_FAULT VARCHAR(4),
IS_OVER_TIME VARCHAR2(4),
NEED_INTRADAY_FINISH VARCHAR2(4),
INTRADAY_FINISH VARCHAR2(4),
CREATE_TIME VARCHAR2(30),
REVERT_TIME VARCHAR2(30),
AREA_CODE VARCHAR2(20),
CUST_LEVEL VARCHAR2(20)
);
*/

---------------------------------------------------------
-------DRZ

CREATE OR REPLACE PACKAGE PCH_DDD
IS
  CURSOR DRZ_INFO
  IS
  SELECT *
  FROM TMP_DRZ;
  ---------------
  CURSOR DRX_INFO
  IS
  SELECT *
  FROM TMP_DRX;
-----------------------------------------------------------------------------
PROCEDURE DDD_DRZ_INSERT  (  NERR    OUT NUMBER,
       SERR    OUT VARCHAR2);
PROCEDURE DDD_DRZ  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
PROCEDURE DDD_DRX_INSERT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
PROCEDURE DDD_DRX  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
PROCEDURE DRZ_RUN(	NERR		OUT NUMBER,
	   		SERR		OUT VARCHAR2);
PROCEDURE DRX_RUN(	NERR		OUT NUMBER,
	   		SERR		OUT VARCHAR2);
----------------------------------------------------------------------------
END PCH_DDD;
/
------------------------------------------------------------------------------
CREATE OR REPLACE package BODY PCH_DDD
is
PROCEDURE DDD_DRZ_INSERT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
  vREVERT_TIME_START varchar2(40);
  vREVERT_TIME_END   varchar2(40);
  
BEGIN

  vREVERT_TIME_START :=to_char(sysdate-2,'YYYYMMDD')||'160000';
  vREVERT_TIME_END   :=to_char(sysdate-1,'YYYYMMDD')||'160000';
  delete from TMP_DRZ;
  COMMIT;
  
insert into TMP_DRZ
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
     AND M.REVERT_TIME >= TO_DATE(vREVERT_TIME_START,'YYYY-MM-DD HH24:MI:SS')
     AND M.REVERT_TIME < TO_DATE(vREVERT_TIME_END,'YYYY-MM-DD HH24:MI:SS')
   ) temp
;

  COMMIT;
  exception
   when others then
      rollback;
      SERR:='INFOMATION-'||SQLERRM;
      NERR:=SQLCODE;
      dbms_output.put_line(serr);
END DDD_DRZ_INSERT;
----------------------------------------------------------------------------
PROCEDURE DDD_DRZ  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
v_OutputFile   UTL_FILE.FILE_TYPE;
---------------
vDRZ_NUM NUMBER;
---------------
v_Name_DAT VARCHAR2(100);
v_Name_CHECK VARCHAR2(100);
v_Name_VAL VARCHAR2(100);
vREVER_TIME_START VARCHAR2(30);
vREVER_TIME_END VARCHAR2(30);
vBUFFER    VARCHAR2(1000);
vDATE VARCHAR2(30);
vDATETIME VARCHAR2(30);
temp    TMP_DRZ%rowtype;
vEX BOOLEAN;
vFLEN NUMBER;
vBSIZE NUMBER;
BEGIN
NERR:=0;
SERR:='';
vDATE:=TO_CHAR(SYSDATE-1,'YYYYMMDD');
vDRZ_NUM:=0;

--vDATETIME:=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
v_Name_DAT:='ETE_'||'121004_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.DAT';      ---ETE_121004_1105_L1_YYYYMMDD_00000001_001   DRZ
v_Name_CHECK:='ETE_'||'121004_'||'1105_'||'L1_'||vDATE||'_000'||'_000'||'.CHECK'; 
v_Name_VAL:='ETE_'||'121004_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.VAL'; 
  BEGIN
    OPEN DRZ_INFO;
      fetch DRZ_INFO into temp;
    if DRZ_INFO%notfound then
      close DRZ_INFO;
      return;
    end if;
    v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_DAT,'W');
    exception
      when others then
          sERR:='DRZ_INFO open error!'||'-'||SQLERRM;
          nERR:=SQLCODE;
        
        RETURN;
  END;
  
  if DRZ_INFO%isopen then
        close DRZ_INFO;
  end if;
  
  FOR CUR_DRZ IN DRZ_INFO LOOP
  begin
  vBUFFER:=CUR_DRZ.BILL_ID||'0x05'||CUR_DRZ.BILL_SN||'0x05'||CUR_DRZ.USER_TYPE||'0x05'||CUR_DRZ.SPECIALTY_ID||'0x05'||CUR_DRZ.SPS_ORDERID||'0x05'||CUR_DRZ.NEED_INTRADAY_FINISH||'0x05'||CUR_DRZ.INTRADAY_FINISH||'0x05'||CUR_DRZ.CREATE_TIME||'0x05'||CUR_DRZ.REVERT_TIME||'0x05'||CUR_DRZ.AREA_CODE||'0x05'||CUR_DRZ.CUST_LEVEL||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  vDRZ_NUM:=vDRZ_NUM+1;
  exception
     when others then
       sERR:='DRZ_OUT error!'||'-'||SQLERRM;
       nERR:=SQLCODE;
       RETURN;
  end;
  END LOOP;
  UTL_FILE.FCLOSE(v_OutputFile);
  
  UTL_FILE.fgetattr('DUMP_DIR_2',v_Name_DAT,vEX,vFLEN,vBSIZE);
  IF vEX THEN
    DBMS_OUTPUT.PUT_LINE('DRZ FILE EXISTS');
  ELSE
    DBMS_OUTPUT.put_line('DRZ FILE DOES NOT EXIST');
  END IF;
  DBMS_OUTPUT.put_line('DRZ FILE LENGTH:'||TO_CHAR(vFLEN));
  DBMS_OUTPUT.put_line('DRZ BLOCK SIZE:'||TO_CHAR(vBSIZE));
  
  vDATETIME:=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_VAL,'W');
  vBUFFER:=v_Name_DAT||'0x05'||TO_CHAR(vFLEN)||'0x05'||vDRZ_NUM||'0x05'||vDATE||'0x05'||vDATETIME||'0x0D0A';  
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_CHECK,'W');
  vBUFFER:=v_Name_DAT||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);
  
END DDD_DRZ;
-------------------------------------------------------------------------------------------------------------------
PROCEDURE DRZ_RUN(  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
sERROR VARCHAR2(4000);
nERROR NUMBER;
BEGIN
SERROR:='';
NERROR:=0;
  PCH_DDD.DDD_DRZ_INSERT(nERROR,sERROR);
  if nERROR <> 0 then
    SERR:=SERR||'INSERT:'||sERROR||'|';
  end if;
  PCH_DDD.DDD_DRZ(nERROR,sERROR);
  if nERROR <> 0 then
    SERR:=SERR||'OUT:'||sERROR||'|';
  end if;
EXCEPTION
  WHEN OTHERS THEN
  sERR:=SQLERRM;
  nERR:=SQLCODE;
END DRZ_RUN;

---------------------------------------------------------------------------------------------------------------
-----DRX
PROCEDURE DDD_DRX_INSERT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
  vREVERT_TIME_START varchar2(40);
  vREVERT_TIME_END   varchar2(40);
  
BEGIN
  
  vREVERT_TIME_START :=to_char(sysdate-2,'YYYYMMDD')||'160000';
  vREVERT_TIME_END   :=to_char(sysdate-1,'YYYYMMDD')||'160000';
  DELETE FROM TMP_DRX;
  COMMIT;
 
 
 INSERT INTO TMP_DRX  
   select *
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
   AND (A.USER_TYPE <> 'platinum' OR A.USER_TYPE IS NULL)
   AND M.NATIVENET_ID <> '0010823'
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
   AND M.REVERT_TIME >= TO_DATE(vREVERT_TIME_START,'YYYYMMDDHH24MISS')
   AND M.REVERT_TIME < TO_DATE(vREVERT_TIME_END,'YYYYMMDDHH24MISS')
   );
   
  COMMIT;
  exception
   when others then
      rollback;
      SERR:='INFOMATION-'||SQLERRM;
      NERR:=SQLCODE;
      --dbms_output.put_line(serr);
END DDD_DRX_INSERT;
---------------------------------------------------------------------


PROCEDURE DDD_DRX  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
v_OutputFile   UTL_FILE.FILE_TYPE;
---------------
vDRX_NUM NUMBER;
---------------
v_Name_DAT VARCHAR2(100);
v_Name_CHECK VARCHAR2(100);
v_Name_VAL VARCHAR2(100);
vREVER_DATE_END VARCHAR2(30);
vBUFFER    VARCHAR2(255);
vDATE VARCHAR2(30);
vDATETIME VARCHAR2(30);
vEX BOOLEAN;
vFLEN NUMBER;
vBSIZE NUMBER;
temp    TMP_DRX%rowtype;
BEGIN
NERR:=0;
SERR:='';
vDATE:=TO_CHAR(SYSDATE-1,'YYYYMMDD');
vDRX_NUM:=0;
--vDATETIME:=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
v_Name_DAT:='ETE_'||'121005_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.DAT';      ---ETE_121005_1105_L1_YYYYMMDD_00000001_001
v_Name_CHECK:='ETE_'||'121005_'||'1105_'||'L1_'||vDATE||'_000'||'_000'||'.CHECK'; 
v_Name_VAL:='ETE_'||'121005_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.VAL'; 
  BEGIN
    OPEN DRX_INFO;
      fetch DRX_INFO into temp;
    if DRX_INFO%notfound then
      close DRX_INFO;
      --return;
    end if;
    v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_DAT,'W');
    exception
      when others then
        sERR:='DRX_INFO open error!'||'-'||SQLERRM;
          nERR:=SQLCODE;
        RETURN;
  END;
  if DRX_INFO%isopen then
        close DRX_INFO;
  end if;
  FOR CUR_DRX IN DRX_INFO LOOP
  begin
  vBUFFER:=CUR_DRX.BILL_ID||'0x05'||CUR_DRX.BILL_SN||'0x05'||CUR_DRX.USER_TYPE||'0x05'||CUR_DRX.SPECIALTY_ID||'0x05'||CUR_DRX.EXT_INFO||'0x05'||CUR_DRX.REPEAT_FAULT||'0x05'||CUR_DRX.IS_OVER_TIME||'0x05'||CUR_DRX.NEED_INTRADAY_FINISH||'0x05'||CUR_DRX.INTRADAY_FINISH||'0x05'||CUR_DRX.CREATE_TIME||'0x05'||CUR_DRX.REVERT_TIME||'0x05'||CUR_DRX.AREA_CODE||'0x05'||CUR_DRX.CUST_LEVEL||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  vDRX_NUM:=vDRX_NUM+1;
  exception
     when others then
       sERR:='DRX_OUT error!'||'-'||SQLERRM;
          nERR:=SQLCODE;
          RETURN;
  end;
  END LOOP;
  UTL_FILE.FCLOSE(v_OutputFile);
  
  UTL_FILE.fgetattr('DUMP_DIR_2',v_Name_DAT,vEX,vFLEN,vBSIZE);
  IF vEX THEN
    DBMS_OUTPUT.PUT_LINE('DRX FILE EXISTS');
  ELSE
    DBMS_OUTPUT.put_line('DRX FILE DOES NOT EXIST');
  END IF;
  DBMS_OUTPUT.put_line('DRX FILE LENGTH:'||TO_CHAR(vFLEN));
  DBMS_OUTPUT.put_line('DRX BLOCK SIZE:'||TO_CHAR(vBSIZE));
  
  vDATETIME:=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_VAL,'W');
  vBUFFER:=v_Name_DAT||'0x05'||TO_CHAR(vFLEN)||'0x05'||vDRX_NUM||'0x05'||vDATE||'0x05'||vDATETIME||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_CHECK,'W');
  vBUFFER:=v_Name_DAT||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);

END DDD_DRX;
------------------------------------------------------------------------------------------------
PROCEDURE DRX_RUN(  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
sERROR VARCHAR2(4000);
nERROR NUMBER;
BEGIN
sERROR:='';
nERROR:=0;
  PCH_DDD.DDD_DRX_INSERT(nERROR,sERROR);
  if nERROR <> 0 then
    SERR:=SERR||'INSERT:'||sERROR||'|';
  end if;
  PCH_DDD.DDD_DRX(nERROR,sERROR);
  if nERROR <> 0 then
    SERR:=SERR||'OUT:'||sERROR||'|';
  end if;
EXCEPTION
  WHEN OTHERS THEN
  sERR:=SQLERRM;
  nERR:=SQLCODE;
END DRX_RUN;
-------------------------------------------------------------------------------

END PCH_DDD;
/


