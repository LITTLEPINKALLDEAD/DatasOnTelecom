select * from intf_requestlog where crmquotenumber='WMX2020021405150807';--�ӿڱ�IBP�������ʵ���Ϣ
-- intf_requestlog���е�TARGETMETHODΪ��������״̬��createService�Ǵ�����checkService����Դ���
SELECT * from c_serviceorder where crmquotenumber like 'WMX2020021405150807'; --������
-- c_serviceorder����һ����¼������SERVICE_IDΪ�գ���Ϊ����Ϊ������SERVICE_ID��ֵ��Ϊ�ӵ�
-- �����ʽ������õ�ʱ�򣬶������ӵ��в���
SELECT * from c_Servicecurrent WHERE globalserviceid='M2049021';--��;�����,����c_serviceorder��GLOBALSERVICEID��ѯ,���豸���
SELECT * from intf_datafortelement where CRMQUOTENUMBER = 'WMX2020011705148008';  
--���ʷ���IBP�Ƿ��յ��ı�

select * from INTF_FAILEDREQLOG_IFCARCHIVE WHERE SERVICEID LIKE 'M2049022%'; -- ���ʹ鵵��

Select t.*,t.rowid From intf_failedrequestlog_forifc t Where t.serviceid like 'M2049022%'

SELECT * FROM INTF_FAILEDREQUESTLOG_FORIFC where SERVICEID = 'M2049022'; --���������귢��ȥ�ı�

select * from mm_dictionary where id in (SELECT PROCESSTYPE from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
 -- ��c_serviceorder���в�ѯPROCESSTYPE��Ϊ��������
select * from mm_dictionary where id in (SELECT DOTYPE from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- DOTYPE�ǲ���״̬��
select * from mm_dictionary where id in (SELECT PROCESSTYPE from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- PROCESSTYPE�Ƕ������ͣ�
select * from mm_dictionary where id in (SELECT ORDERTYPE from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- ORDERTYPE����Դ��������,
select * from mm_dictionary where id in (SELECT STATUS from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- STATUS�Ƕ�������״̬��
select * from mm_dictionary where id in (SELECT ISLEGAL from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- ISLEGAL�Ƿ�Ϸ�,
select * from mm_dictionary where id in (SELECT OPERATION_TYPE from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- OPERATION_TYPE���̲�������

select DISTINCT(STATUS) from C_SERVICEORDER;

select * from mm_dictionary where id in (select DISTINCT(OPERATION_TYPE) from C_SERVICEORDER);

select * from mm_dictionary where id in (SELECT STATUS from intf_datafortelement where CRMQUOTENUMBER = 'WMZ2020011705147885');
