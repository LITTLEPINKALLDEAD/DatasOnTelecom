/*
DROP TABLE TMP_SGL;
CREATE TABLE TMP_SGL
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
CUST_LEVEL VARCHAR2(20),
AREA_CODE VARCHAR2(20)
);
*/
---------------------------------------------------------
-------SGL

CREATE OR REPLACE PACKAGE PCH_SGL
IS

------------------------------------------------------------  
CURSOR SGL_INFO
  IS
  SELECT *
  FROM TMP_SGL;
-----------------------------------------------------------------------------
PROCEDURE SGL_INSERT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
PROCEDURE SGL_OUT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
PROCEDURE SGL_RUN(  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
----------------------------------------------------------------------------
END PCH_SGL;
/
------------------------------------------------------------------------------
------------------------------------------------------------------------------
CREATE OR REPLACE package BODY PCH_SGL
is
PROCEDURE SGL_INSERT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
  vREVERT_TIME_START varchar2(40);
  vREVERT_TIME_END   varchar2(40);
  
BEGIN
  
  vREVERT_TIME_START :=to_char(sysdate-1,'YYYYMMDD');
  vREVERT_TIME_END   :=to_char(sysdate,'YYYYMMDD');
  DELETE FROM TMP_SGL;
  COMMIT;
 
 
 INSERT INTO TMP_SGL  
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
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 1, 0) 及时修复,
   decode(A.INTRADAY_FINISH, 'Y', '是', '否') 需要当日修复,
   case
     when ((M.CREATE_TIME <= TRUNC(M.CREATE_TIME) + 16/24 AND 
       M.REVERT_TIME < TRUNC(M.CREATE_TIME) + 1) OR
       (M.CREATE_TIME > TRUNC(M.CREATE_TIME) + 16/24 AND 
       TRUNC(M.CREATE_TIME) = TRUNC(M.REVERT_TIME) AND
       TRUNC(M.REVERT_TIME) < TRUNC(M.CREATE_TIME) + 1))  then
      1
     else
      0
   end 是否当日修,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') 创建时间,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') 完成时间,
   (SELECT L.LEVEL_NAME FROM CH_CUST_LEVEL L WHERE L.DICTIONARYID = '0001078' AND L.LEVEL_VALUES = A.SERVICE_LEVEL) 用户星级,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) 所属区局
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
END SGL_INSERT;
---------------------------------------------------------------------


PROCEDURE SGL_OUT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
v_OutputFile   UTL_FILE.FILE_TYPE;
---------------
vSGL_Name_DAT VARCHAR2(100);
vSGL_Name_CHECK VARCHAR2(100);
vSGL_Name_VAL VARCHAR2(100);
vJSL_Name_DAT VARCHAR2(100);
vJSL_Name_CHECK VARCHAR2(100);
vJSL_Name_VAL VARCHAR2(100);
vCFL_Name_DAT VARCHAR2(100);
vCFL_Name_CHECK VARCHAR2(100);
vCFL_Name_VAL VARCHAR2(100);
vREVER_DATE_END VARCHAR2(30);
vBUFFER    VARCHAR2(255);
vDATE VARCHAR2(30);
vDATETIME VARCHAR2(30);
vSGL_NUM NUMBER;
vEX BOOLEAN;
vFLEN NUMBER;
vBSIZE NUMBER;
temp    TMP_SGL%rowtype;
BEGIN
NERR:=0;
SERR:='';
vDATE:=TO_CHAR(SYSDATE-1,'YYYYMMDD');
vSGL_NUM:=0;
--vDATETIME:=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
vSGL_Name_DAT:='ETE_'||'121006_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.DAT';      ---ETE_121006_1105_L1_YYYYMMDD_00000001_001.DAT  申告率
vSGL_Name_VAL:='ETE_'||'121006_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.VAL'; 
vSGL_Name_CHECK:='ETE_'||'121006_'||'1105_'||'L1_'||vDATE||'_000'||'_000'||'.CHECK'; 
vJSL_Name_DAT:='ETE_'||'121008_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.DAT';      ---ETE_121008_1105_L1_YYYYMMDD_00000001_001.DAT  及时率
vJSL_Name_VAL:='ETE_'||'121008_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.VAL'; 
vJSL_Name_CHECK:='ETE_'||'121008_'||'1105_'||'L1_'||vDATE||'_000'||'_000'||'.CHECK'; 
vCFL_Name_DAT:='ETE_'||'121010_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.DAT';      ---ETE_121010_1105_L1_YYYYMMDD_00000001_001.DAT  重复申告率
vCFL_Name_VAL:='ETE_'||'121010_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.VAL'; 
vCFL_Name_CHECK:='ETE_'||'121010_'||'1105_'||'L1_'||vDATE||'_000'||'_000'||'.CHECK'; 
  BEGIN
    OPEN SGL_INFO;
      fetch SGL_INFO into temp;
    if SGL_INFO%notfound then
      close SGL_INFO;
      return;
    end if;
    v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',vSGL_Name_DAT,'W');
    exception
      when others then
        sERR:='SGL_INFO open error!'||'-'||SQLERRM;
          nERR:=SQLCODE;
        RETURN;
  END;
  if SGL_INFO%isopen then
        close SGL_INFO;
  end if;
  FOR CUR_SGL IN SGL_INFO LOOP
  begin
  vBUFFER:=CUR_SGL.BILL_ID||'0x05'||CUR_SGL.BILL_SN||'0x05'||CUR_SGL.USER_TYPE||'0x05'||CUR_SGL.SPECIALTY_ID||'0x05'||CUR_SGL.EXT_INFO||'0x05'||CUR_SGL.REPEAT_FAULT||'0x05'||CUR_SGL.IS_OVER_TIME||'0x05'||CUR_SGL.NEED_INTRADAY_FINISH||'0x05'||CUR_SGL.INTRADAY_FINISH||'0x05'||CUR_SGL.CREATE_TIME||'0x05'||CUR_SGL.REVERT_TIME||'0x05'||CUR_SGL.CUST_LEVEL||'0x05'||CUR_SGL.AREA_CODE||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  vSGL_NUM:=vSGL_NUM+1;
  exception
     when others then
       sERR:='SGL_OUT error!'||'-'||SQLERRM;
          nERR:=SQLCODE;
          RETURN;
  end;
  END LOOP;
  UTL_FILE.FCLOSE(v_OutputFile);
  
  UTL_FILE.fgetattr('DUMP_DIR_2',vSGL_Name_DAT,vEX,vFLEN,vBSIZE);
  IF vEX THEN
    DBMS_OUTPUT.PUT_LINE('SGL FILE EXISTS');
  ELSE
    DBMS_OUTPUT.put_line('SGL FILE DOES NOT EXIST');
  END IF;
  DBMS_OUTPUT.put_line('SGL FILE LENGTH:'||TO_CHAR(vFLEN));
  DBMS_OUTPUT.put_line('SGL BLOCK SIZE:'||TO_CHAR(vBSIZE));
  
  vDATETIME:=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',vSGL_Name_VAL,'W');
  vBUFFER:=vSGL_Name_DAT||'0x05'||TO_CHAR(vFLEN)||'0x05'||vSGL_NUM||'0x05'||vDATE||'0x05'||vDATETIME||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',vSGL_Name_CHECK,'W');
  vBUFFER:=vSGL_Name_DAT||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);
  
  UTL_FILE.fcopy('DUMP_DIR_2',vSGL_Name_DAT,'DUMP_DIR_2',vJSL_Name_DAT);
  UTL_FILE.fcopy('DUMP_DIR_2',vSGL_Name_DAT,'DUMP_DIR_2',vCFL_Name_DAT);
  --JSL
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',vJSL_Name_VAL,'W');
  vBUFFER:=vJSL_Name_DAT||'0x05'||TO_CHAR(vFLEN)||'0x05'||vSGL_NUM||'0x05'||vDATE||'0x05'||vDATETIME||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',vJSL_Name_CHECK,'W');
  vBUFFER:=vJSL_Name_DAT||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);
  --CFL
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',vCFL_Name_VAL,'W');
  vBUFFER:=vCFL_Name_DAT||'0x05'||TO_CHAR(vFLEN)||'0x05'||vSGL_NUM||'0x05'||vDATE||'0x05'||vDATETIME||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',vCFL_Name_CHECK,'W');
  vBUFFER:=vCFL_Name_DAT||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);
  

END SGL_OUT;
------------------------------------------------------------------------------------------------
PROCEDURE SGL_RUN(  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
sERROR VARCHAR2(4000);
nERROR NUMBER;
BEGIN
sERROR:='';
nERROR:=0;
  PCH_SGL.SGL_INSERT(nERROR,sERROR);
  if nERROR <> 0 then
    SERR:=SERR||'INSERT:'||sERROR||'|';
  end if;
  PCH_SGL.SGL_OUT(nERROR,sERROR);
  if nERROR <> 0 then
    SERR:=SERR||'OUT:'||sERROR||'|';
  end if;
EXCEPTION
  WHEN OTHERS THEN
  sERR:=SQLERRM;
  nERR:=SQLCODE;
END SGL_RUN;
-------------------------------------------------------------------------------

END PCH_SGL;
/


