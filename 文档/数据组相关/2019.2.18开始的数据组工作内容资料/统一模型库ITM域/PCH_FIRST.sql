/*
DROP TABLE TMP_FIRST;
CREATE TABLE TMP_FIRST
(
BILL_ID VARCHAR2(30) PRIMARY KEY,
BILL_SN VARCHAR2(30),
WARNING_EQ_NUM VARCHAR2(30),
USER_TYPE VARCHAR2(10),
SPECIALTY_ID VARCHAR2(10),
RESPOND_TIME VARCHAR2(30),
CREATE_TIME VARCHAR2(30),
REVERT_TIME VARCHAR2(30),
EQ_AREA_CODE VARCHAR2(20),
IS_OVER_TIME VARCHAR2(4)
);
*/
---------------------------------------------------------
-------FIRST

CREATE OR REPLACE PACKAGE PCH_FIRST
IS

------------------------------------------------------------  
CURSOR FIRST_INFO
  IS
  SELECT *
  FROM TMP_FIRST;
-----------------------------------------------------------------------------
PROCEDURE FIRST_INSERT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
PROCEDURE FIRST_OUT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
PROCEDURE FIRST_RUN(  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
----------------------------------------------------------------------------
END PCH_FIRST;
/
------------------------------------------------------------------------------
------------------------------------------------------------------------------
CREATE OR REPLACE package BODY PCH_FIRST
is
PROCEDURE FIRST_INSERT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
  vREVERT_TIME_START varchar2(40);
  vREVERT_TIME_END   varchar2(40);
  
BEGIN
  
  vREVERT_TIME_START :=to_char(sysdate-1,'YYYYMMDD');
  vREVERT_TIME_END   :=to_char(sysdate,'YYYYMMDD');
  DELETE FROM TMP_FIRST;
  COMMIT;
 
 
 INSERT INTO TMP_FIRST  
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
                             '140123756',
                             '1729795994',
                             '1729795996',
                             '1729795998') then
      'IPTV'
     when M.SPECIALTY_ID IN
          ('0057382', '23586626', '23586609', '84112977') then
      '宽带'
   end 业务类型,
   TO_CHAR((SELECT MIN(C.OPERATE_END_TIME) FROM UFMS.T_PUB_BILL_ACTION C WHERE C.BILL_ID = M.BILL_ID),'YYYYMMDDHH24MISS') 首次响应时间,
   TO_CHAR(M.CREATE_TIME,'YYYYMMDDHH24MISS') 创建时间,
   TO_CHAR(M.REVERT_TIME,'YYYYMMDDHH24MISS') 完成时间,
   (SELECT Q.QJ_NAME FROM CH_QJ Q WHERE Q.QJ_ID = M.NATIVENET_ID) 设备所属区局,
   DECODE(M.BILL_IS_OVER_TIME, 'Y', 1, 0) 是否及时响应
   FROM ufms.t_Pub_Mainbill M,ufms.T_SA_BILL A
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
                           '140123756',
                           '1729795994',
                           '1729795996',
                           '1729795998') OR
       M.SPECIALTY_ID IN ('0057382', '23586626', '23586609', '84112977'))
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
END FIRST_INSERT;
---------------------------------------------------------------------


PROCEDURE FIRST_OUT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
v_OutputFile   UTL_FILE.FILE_TYPE;
---------------
v_Name_DAT VARCHAR2(100);
v_Name_CHECK VARCHAR2(100);
v_Name_VAL VARCHAR2(100);
vREVER_DATE_END VARCHAR2(30);
vBUFFER    VARCHAR2(255);
vDATE VARCHAR2(30);
vDATETIME VARCHAR2(30);
vFIRST_NUM NUMBER;
vEX BOOLEAN;
vFLEN NUMBER;
vBSIZE NUMBER;
temp    TMP_FIRST%rowtype;
BEGIN
NERR:=0;
SERR:='';
vDATE:=TO_CHAR(SYSDATE-1,'YYYYMMDD');
vFIRST_NUM:=0;
--vDATETIME:=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
v_Name_DAT:='ETE_'||'121007_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.DAT';      ---ETE_121007_1105_L1_YYYYMMDD_00000001_001.DAT
v_Name_VAL:='ETE_'||'121007_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.VAL'; 
v_Name_CHECK:='ETE_'||'121007_'||'1105_'||'L1_'||vDATE||'_000'||'_000'||'.CHECK'; 
  BEGIN
    OPEN FIRST_INFO;
      fetch FIRST_INFO into temp;
    if FIRST_INFO%notfound then
      close FIRST_INFO;
      return;
    end if;
    v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_DAT,'W');
    exception
      when others then
        sERR:='FIRST_INFO open error!'||'-'||SQLERRM;
          nERR:=SQLCODE;
        RETURN;
  END;
  if FIRST_INFO%isopen then
        close FIRST_INFO;
  end if;
  FOR CUR_FIRST IN FIRST_INFO LOOP
  begin
  vBUFFER:=CUR_FIRST.BILL_ID||'0x05'||CUR_FIRST.BILL_SN||'0x05'||CUR_FIRST.WARNING_EQ_NUM||'0x05'||CUR_FIRST.USER_TYPE||'0x05'||CUR_FIRST.SPECIALTY_ID||'0x05'||CUR_FIRST.RESPOND_TIME||'0x05'||CUR_FIRST.CREATE_TIME||'0x05'||CUR_FIRST.REVERT_TIME||'0x05'||CUR_FIRST.EQ_AREA_CODE||'0x05'||CUR_FIRST.IS_OVER_TIME||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  vFIRST_NUM:=vFIRST_NUM+1;
  exception
     when others then
       sERR:='FIRST_OUT error!'||'-'||SQLERRM;
          nERR:=SQLCODE;
          RETURN;
  end;
  END LOOP;
  UTL_FILE.FCLOSE(v_OutputFile);
  
  UTL_FILE.fgetattr('DUMP_DIR_2',v_Name_DAT,vEX,vFLEN,vBSIZE);
  IF vEX THEN
    DBMS_OUTPUT.PUT_LINE('FIRST FILE EXISTS');
  ELSE
    DBMS_OUTPUT.put_line('FIRST FILE DOES NOT EXIST');
  END IF;
  DBMS_OUTPUT.put_line('FIRST FILE LENGTH:'||TO_CHAR(vFLEN));
  DBMS_OUTPUT.put_line('FIRST BLOCK SIZE:'||TO_CHAR(vBSIZE));
  
  vDATETIME:=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_VAL,'W');
  vBUFFER:=v_Name_DAT||'0x05'||TO_CHAR(vFLEN)||'0x05'||vFIRST_NUM||'0x05'||vDATE||'0x05'||vDATETIME||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_CHECK,'W');
  vBUFFER:=v_Name_DAT||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);

END FIRST_OUT;
------------------------------------------------------------------------------------------------
PROCEDURE FIRST_RUN(  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
sERROR VARCHAR2(4000);
nERROR NUMBER;
BEGIN
sERROR:='';
nERROR:=0;
  PCH_FIRST.FIRST_INSERT(nERROR,sERROR);
  if nERROR <> 0 then
    SERR:=SERR||'INSERT:'||sERROR||'|';
  end if;
  PCH_FIRST.FIRST_OUT(nERROR,sERROR);
  if nERROR <> 0 then
    SERR:=SERR||'OUT:'||sERROR||'|';
  end if;
EXCEPTION
  WHEN OTHERS THEN
  sERR:=SQLERRM;
  nERR:=SQLCODE;
END FIRST_RUN;
-------------------------------------------------------------------------------

END PCH_FIRST;
/
