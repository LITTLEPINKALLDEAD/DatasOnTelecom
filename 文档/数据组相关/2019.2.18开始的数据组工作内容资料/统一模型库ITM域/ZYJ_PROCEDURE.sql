/*
DROP TABLE TMP_ZYJ;
CREATE TABLE TMP_ZYJ
(
BILL_ID VARCHAR2(30) PRIMARY KEY,
BILL_SN VARCHAR2(30),
USER_TYPE VARCHAR2(10),
SPECIALTY_ID VARCHAR2(10),
SPS_ORDERID VARCHAR2(20),
ORDER_CREATE_TIME VARCHAR2(30),
SEND_TIME VARCHAR2(30),
AREA_CODE VARCHAR2(20),
IS_OVER_TIME VARCHAR2(4)
);
select * from tmp_zyj
*/
---------------------------------------------------------
-------ZYJ

CREATE OR REPLACE PACKAGE PCH_ZYJ
IS

------------------------------------------------------------  
CURSOR ZYJ_INFO
  IS
  SELECT *
  FROM TMP_ZYJ;
-----------------------------------------------------------------------------
PROCEDURE ZYJ_INSERT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
PROCEDURE ZYJ_OUT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
PROCEDURE ZYJ_RUN(  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2);
----------------------------------------------------------------------------
END PCH_ZYJ;
/
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
CREATE OR REPLACE package BODY PCH_ZYJ
is
PROCEDURE ZYJ_INSERT  (  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
  vREVERT_TIME_START varchar2(40);
  vREVERT_TIME_END   varchar2(40);
  
BEGIN
  
  vREVERT_TIME_START :=to_char(sysdate-1,'YYYYMMDD');
  vREVERT_TIME_END   :=to_char(sysdate,'YYYYMMDD');
  DELETE FROM TMP_ZYJ;
  COMMIT;
 
 
 INSERT INTO TMP_ZYJ  
select *
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
          (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) --and B.Is_Need_Test <> 'Y' 
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
         (B.ag_iptv_num - B.OLD_ag_iptv_num) > 0) and B.Is_Need_Test <> 'Y') OR
         B.business_type in ('FTTH', 'FTTO', 'FTTB+LAN', 'ADSL','POST','ADDSERV'))
     AND M.BUSINESS_ID = '0002555'
     AND B.IBP_CREATE_TIME IS NOT NULL
     AND M.CREATE_TIME >= TO_DATE(vREVERT_TIME_START,'YYYYMMDDHH24MISS')
     AND M.CREATE_TIME < TO_DATE(vREVERT_TIME_END,'YYYYMMDDHH24MISS')
   )
;

   
  COMMIT;
  exception
   when others then
      rollback;
      SERR:='INFOMATION-'||SQLERRM;
      NERR:=SQLCODE;
      --dbms_output.put_line(serr);
END ZYJ_INSERT;
---------------------------------------------------------------------


PROCEDURE ZYJ_OUT  (  NERR    OUT NUMBER,
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
vZYJ_NUM NUMBER;
vEX BOOLEAN;
vFLEN NUMBER;
vBSIZE NUMBER;
temp    TMP_ZYJ%rowtype;
BEGIN
NERR:=0;
SERR:='';
vDATE:=TO_CHAR(SYSDATE-1,'YYYYMMDD');
vZYJ_NUM:=0;
--vDATETIME:=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
v_Name_DAT:='ETE_'||'121009_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.DAT';      ---ETE_121009_1105_L1_YYYYMMDD_00000001_001.DAT
v_Name_VAL:='ETE_'||'121009_'||'1105_'||'L1_'||vDATE||'_00000001'||'_000'||'.VAL'; 
v_Name_CHECK:='ETE_'||'121009_'||'1105_'||'L1_'||vDATE||'_000'||'_000'||'.CHECK'; 
  BEGIN
    OPEN ZYJ_INFO;
      fetch ZYJ_INFO into temp;
    if ZYJ_INFO%notfound then
      close ZYJ_INFO;
      return;
    end if;
    v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_DAT,'W');
    exception
      when others then
        sERR:='ZYJ_INFO open error!'||'-'||SQLERRM;
          nERR:=SQLCODE;
        RETURN;
  END;
  if ZYJ_INFO%isopen then
        close ZYJ_INFO;
  end if;
  FOR CUR_ZYJ IN ZYJ_INFO LOOP
  begin
  vBUFFER:=CUR_ZYJ.BILL_ID||'0x05'||CUR_ZYJ.BILL_SN||'0x05'||CUR_ZYJ.USER_TYPE||'0x05'||CUR_ZYJ.SPECIALTY_ID||'0x05'||CUR_ZYJ.SPS_ORDERID||'0x05'||CUR_ZYJ.ORDER_CREATE_TIME||'0x05'||CUR_ZYJ.SEND_TIME||'0x05'||CUR_ZYJ.AREA_CODE||'0x05'||CUR_ZYJ.IS_OVER_TIME||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  vZYJ_NUM:=vZYJ_NUM+1;
  exception
     when others then
       sERR:='ZYJ_OUT error!'||'-'||SQLERRM;
          nERR:=SQLCODE;
          RETURN;
  end;
  END LOOP;
  UTL_FILE.FCLOSE(v_OutputFile);
  
  UTL_FILE.fgetattr('DUMP_DIR_2',v_Name_DAT,vEX,vFLEN,vBSIZE);
  IF vEX THEN
    DBMS_OUTPUT.PUT_LINE('ZYJ FILE EXISTS');
  ELSE
    DBMS_OUTPUT.put_line('ZYJ FILE DOES NOT EXIST');
  END IF;
  DBMS_OUTPUT.put_line('ZYJ FILE LENGTH:'||TO_CHAR(vFLEN));
  DBMS_OUTPUT.put_line('ZYJ BLOCK SIZE:'||TO_CHAR(vBSIZE));
  
  vDATETIME:=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_VAL,'W');
  vBUFFER:=v_Name_DAT||'0x05'||TO_CHAR(vFLEN)||'0x05'||vZYJ_NUM||'0x05'||vDATE||'0x05'||vDATETIME||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);
  
  v_OutputFile := UTL_FILE.FOPEN('DUMP_DIR_2',v_Name_CHECK,'W');
  vBUFFER:=v_Name_DAT||'0x0D0A';
  UTL_FILE.PUT_LINE(v_OutputFile,vBUFFER);
  UTL_FILE.FCLOSE(v_OutputFile);

END ZYJ_OUT;
------------------------------------------------------------------------------------------------
PROCEDURE ZYJ_RUN(  NERR    OUT NUMBER,
         SERR    OUT VARCHAR2)
IS
sERROR VARCHAR2(4000);
nERROR NUMBER;
BEGIN
sERROR:='';
nERROR:=0;
  PCH_ZYJ.ZYJ_INSERT(nERROR,sERROR);
  if nERROR <> 0 then
    SERR:=SERR||'INSERT:'||sERROR||'|';
  end if;
  PCH_ZYJ.ZYJ_OUT(nERROR,sERROR);
  if nERROR <> 0 then
    SERR:=SERR||'OUT:'||sERROR||'|';
  end if;
EXCEPTION
  WHEN OTHERS THEN
  sERR:=SQLERRM;
  nERR:=SQLCODE;
END ZYJ_RUN;
-------------------------------------------------------------------------------

END PCH_ZYJ;
/
