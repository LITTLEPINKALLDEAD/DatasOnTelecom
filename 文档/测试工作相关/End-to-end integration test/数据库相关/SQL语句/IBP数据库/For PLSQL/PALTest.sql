select * from ra_workorder_request where crm_order_number = '(2019)/19076533-0001'; --P7-����
select * from ra_workorder_request where crm_order_number LIKE '%(2020)/404841586%';
select * from ra_workorder_request where P_RESULT is NOT null and rownum < 11 order by RECEIVE_TIME DESC; --���ݶ����Ľ���ʱ��ӽ���Զѡȡ���10���б�����Ϣ�Ķ���
select * from ra_workorder_request where crm_order_number = '2-30242684394'; --P7-���ʣ�����ԭ�ʲ�����
select * from ra_workorder_request where ORDER_SEQ_ID = '28471' order by RA_COMPLELED_TIME DESC; --P7-���ʣ���P7�Ų�ѯ
select * from ra_workorder_request where ORDER_SEQ_ID = '35174' order by RECEIVE_TIME DESC; --P7-���ʣ���P7�Ų�ѯ
select * from ra_workorder_request where crm_order_number like 'WMZ2020032305208888%' order by RECEIVE_TIME DESC;
select * from ra_workorder_request where crm_order_number in ('WMZ2019120500516845','WMZ2019120500519229') order by RECEIVE_TIME DESC;
select * from ra_workorder_request where USER_ID_97 like '%M1323110%' order by RECEIVE_TIME DESC;--(Servrice ID���豸�ţ����̵����)��97ID��ѯ

select aa.STATE,aa.REQUEST_TYPE,aa.* from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER = '2-30309482575';

---STATEΪ���ض���״̬��������
---��1����ʼ״̬��׼�����ͣ�
---2������ʧ��
---3���ѷ��ͣ���δ�յ��ص���
---4��δ��
---5�����յ�ʧ�ܵĻص����
---6���������׼���ظ�P7
---7�����������P7ʧ��
---8�����������P7�ɹ�
---��

---request_typeΪ�����������ͣ���������
---createIntResService�Ǵ����񣨹����ģ�
---dispatchMOrder(2M������),checkService����Դ���(2M)
---queryIntResService��ԭ�ʲ���ѯ��
---csOrder�Ƿ��ؿͱ������ļ�¼��2M��
---completeIntResService�Ƕ����깤��������,archiveNMResource�Ƕ����깤(2M)
---��

select USER_ID_97 from ra_workorder_request where crm_order_number like '%2-30039336430%' order by RECEIVE_TIME DESC;
--��ѯCRM������Service ID�豸��

select CRM_ORDER_NUMBER from ra_workorder_request where USER_ID_97 like '%M1307690%' order by RECEIVE_TIME DESC;
--����Service ID�豸�Ų�ѯCRM������

--20190313:(2019)/19076920-0001
--20190314:2-29999072116
--WMX2019012100117301,WMX2019012600123517
--(2019)/19075950_0001C ,(2019)/19076141_0002C
--(2019)/19076225_0001PZ,�޶����Ĺ��̶�����P6��Ϊ15094

--(2019)/19076222_0001PZ,P6��Ϊ15091

select * from RA_WORKORDER_REQUEST where P_RESULT like '%Could%' and rownum<=10;

select aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER in ('WMX2020061905549744') and aa.REQUEST_TYPE like '%query%';
--���߿����ר�߿�����Ĳ�ѯ����WORK_ORDER_REQUEST����start_project_build�ֶ�

select pub_b2c(d.xmlinfo),D.* from t_Sf_Receive_Quene D WHERE D.SPS_APPLY_ID like '(2019)/19065595_0001PZ%';
--��֤�ͱ��յ�IBP�����������Ƿ��������ֶ����м���Ϣ�ڵ㣨vtrunkinfo���ͷ��������Ϣ�ڵ�(alloccodeinfo)on��;��
-- SN13��װ��(2019)/19065595_0001PZ,(2019)/19065599_0001PC

select p.work_order_request from pai_workorder_request p  where p.crm_order_number in ('2-30264173016'); 
-- �����2-30264222174��WMZ2019122500529376, �豸�ţ� ACC400807650785(��CRM��װ), WMZ2019122500531058����CRM�����,WMZ2019122500529380  �豸�ţ� ACC400807650815����CRM��װ�����Ӳ�Ʒ��
--��֤�ֶΣ��ͻ���ʶ��service_account�����ͻ����ơ�account_number����һ����Ʒ���롰һ���Ӳ�Ʒ��š���Ⱥ��š�group_number��


select * from pai_workorder_request where crm_order_number = '2-29978524433'; --P7-PAI --2-29936482320
select * from asap_workorder_request where crm_order_number = '2-29978513149';  --P7-asap

select * from INT_RES_CONFIG_RESULT_NEW where CRM_ORDER_NO = 'WMX2019112100508401' --��ѯPAL��������ı�

select q.wop_process_state from pai_workorder_request q where q.crm_order_number='WMZ2020032605228633' and q.platform='P027'; 
---��������Ʒ������֤��wop_process_stateΪ1ʱ��ʾ���ط�����

select q.pai_compleled_time from pai_workorder_request q  where q.crm_order_number in('WMZ2020032705236482','WMZ2020032705236546') and q.platform='P027';
---��������Ʒ������֤���ɷ��������ܹ��������������ȥWOP��������,pai_compleled_time���ʱ������֤�����Ƿ���Ч

select t.*,t.rowid from asap_workorder_request t where crm_order_number='WMZ2020040205289110' and request_type='VIMS_OrderRequest' order by hist_seq_id;
--��֤IBP�ɷ���vims����

select t.*,t.rowid from asap_workorder_request t where crm_order_number in ('WMX2020040205288719','WMX2020040205289095','WMX2020040205288724','WMX2020040205289121','2-30309283705','2-30309482575') and request_type='VIMS_OrderRequest' order by hist_seq_id;
--��֤IBP�ɷ���vims��������Щ����������Ҫ��VIMS������

select t.*,t.rowid from asap_workorder_request t where crm_order_number in ('WMZ2020040205288743','WMZ2020040305289921','WMZ2020040205289110','WMZ2020040305289948','2-30309707282','2-30309754240') and request_type='VIMS_OrderRequest' order by hist_seq_id;
--��֤IBP�ɷ���vims����,��Щ���������ǲ���VIMS������

select p.work_order_request from pai_workorder_request p where p.crm_order_number in ('WMX2020040905308819','WMX2020040905308876','WMX2020040905308945') and p.platform='P017';

select p.work_order_request from pai_workorder_request p where p.crm_order_number in ('WMX2020040905308900','WMX2020040905308956','WMX2020040905308995') and p.platform='P017';

--��֤�ֶι����д����Ӳ�Ʒipoe_path��ipoeͨ�������Ӳ�Ʒ����biz_type��ҵ�����ͣ�Ϊ����Ϸ��up_bandwidth���������ʣ�Ϊ100M��down_bandwidth���������ʣ�Ϊ500M

--select asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in ('WMX2020040905308819','WMX2020040905308876','WMX2020040905308945') and asap.request_type='ONU_OrderRequest';

select asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in ('WMX2020040905308900','WMX2020040905308956','WMX2020040905308995') and asap.request_type='ONU_OrderRequest';
--�����к���yun_vlan����������vLan������ֵ����Դ��Ϣ���ص�һ��

select t.work_order_request from pai_workorder_request t where crm_order_number in ('WMZ2020041305323758','WMZ2020041405325093','WMZ2020041405325098','WMZ2020042005336888') and t.platform='P038d';
-- ��֤�����������ʼ��Զ������������ݣ���֤�ֶΣ�service_id���豸�ţ���Business_Type_AI������ҵ�����ͣ���Channel_Name���������ƣ���service_account���ͻ����ƣ���contact_person����ϵ�ˣ���contact_tel����ϵ�绰��

select t.work_order_request from pai_workorder_request t  where crm_order_number in ('WMZ2020041305324129','WMZ2020041405325065','WMZ2020041405325096') and t.platform='P038c';
-- ��֤���������������Զ������������ݣ���֤�ֶΣ�service_id���豸�ţ���Business_Type_AI������ҵ�����ͣ���Channel_Name���������ƣ���Concurrency������������Concurrency_Fee���������ۣ���service_account���ͻ����ƣ���contact_person����ϵ�ˣ���contact_tel����ϵ�绰��

select asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number = 'WMX2020041605329388';
-- ��֤����ims��ONU��SHLR������serviceProperty_new�������½ڵ㣬������old�����Ͻڵ㣬������Ӧ��ֻ���½ڵ�û���Ͻڵ��

select t.action_code,t.* from pai_workorder_request t where crm_order_number = 'WMX2020041605329388';
-- ��֤action_code���������ͣ�Ϊװ

select count(*) as count from ra_workorder_request where RECEIVE_TIME >= date '2020-4-7' AND RECEIVE_TIME <= date '2020-4-14'; 
-- ͳ�ƴ�2020��4��7�յ�2020��4��14������P7�յ��Ķ���

select count(*) from ra_workorder_request where to_char(RECEIVE_TIME,'yyyy-mm-dd hh:mm:ss') between '2020-04-07 09:00:00' AND '2020-04-14 21:00:00'; 
-- ͳ�ƴ�2020��4��7������9�㵽2020��4��14������9������P7�յ��Ķ���

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in('WMX2020042705390546','WMX2020042705390547','WMX2020042705390821','WMX2020042705390832','WMX2020042705390877');
-- ��֤Ԥ��������ʿ�����Ʒ�Ƿ��ɷ���ONU����,�ϵ��ӣ�'WMX2020042605389540','WMX2020042605389690','WMX2020042605389737','WMX2020042605389972'

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in('WMX2020042705390541','WMX2020042705390543','WMX2020042705390822','WMX2020042705390824','WMX2020042705390875');
-- ��֤�󸶷�����ʿ�����Ʒ�Ƿ��ɷ���ONU����

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number in('WMX2020050905428062');
--�鿴�̶��绰��vims�ʲ��ƻ��ı��ģ�IBP�ɷ�vimsװ��������IMS���Ʋ𹤵�

select aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER in ('WMX2020050605412739','WMX2020050605412755','WMX2020050605412758') and aa.REQUEST_TYPE like '%query%';
-- ��ѯ�̶��绰�ƻ����еı��ģ�ims_type��ֵΪ��ΪIMS

select aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN,AA.WORK_ORDER_REQUEST,aa.request_type from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER in ('WMZ2020050905427424','WMZ2020050905427428','WMZ2020050905430717','WMZ2020050905430719');
-- ��ѯר�߿�������еı��ģ��û�����ģʽ��user_access_mode��ֵΪ·��ģʽ�ͽ���ģʽ

select t.CRM_ORDER_NUMBER,t.work_order_request from pai_workorder_request t  where t.crm_order_number in('WMZ2020052105492801','WMZ2020052105497728','WMZ2020052305520425','WMZ2020052305520424','WMZ2020052305520423','WMZ2020052305520426','WMZ2020052505536997','WMZ2020052505536827') and t.platform='P002c';
-- ��ѯר�߿�������еı��ģ���֤��������user_access_mode ���û�����ģʽ��, co_ip_info���ֶ�IP��Ϣ��

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number in ('(2020)/404841383');
select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number in ('(2020)/404841397');
--�鿴��ֱͨ�����Ǹ����������onu�߼���ŷ����仯,��Ҫ�ɷ������ּ�ͥ����� �޸ĵ������ּ�ͥ�����ֲ𵥡�Vims�����װ����ims-hss/tel�����ֲ�
--����ͥ��������=SDN��
--�ɷ���SDN������޸ĵ���SDN�����ֲ���������������װ�������߹����ֲ������ONU�����ֲ𵥣�ONU�����װ����Enumʩ��ȷ�� ��ӡ�Enum������޸ĵ���SHLRʩ��ȷ�� ��ӡ�SHLR������޸ĵ�

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number in ('WMX2020050905428062');
--�鿴��ֱͨ�����Ǹ����������onu�߼�����ޱ仯,��Ҫ�ɷ���Vims�����װ����Ims-hss/tel�����ֲ𵥡�SHLR������޸ĵ���Enum������޸ĵ������ּ�ͥ������޸ĵ�
--����ͥ��������=SDN��
--�ɷ���SDN������޸ĵ�

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in('WMX2020061905549863','WMX2020062005549866','WMX2020062005549868');
-- ��֤Ԥ��������ʿ�����Ʒ(��������)�Ƿ��ɷ���ONU����

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in('WMX2020061905549744','WMX2020061905549864','WMX2020062005549865','WMX2020062005549867');
-- ��֤�󸶷�����ʿ�����Ʒ(��������)�Ƿ��ɷ���ONU����

select crm_order_number,work_order_request from  ra_workorder_request where crm_order_number in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100','WMX2020070105552001','WMX2020070205552126','WMX2020070205552136','WMX2020070205552135') and request_type='createIntResService';
--3.��֤IBP�������ʴ�������set_top_box_4k Ϊ��18����֤������½PAL���ݿ⣺

select a.crm_order_number,a.work_order_request from pai_workorder_request a  where crm_order_number in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100','WMX2020070105552001','WMX2020070205552126','WMX2020070205552136','WMX2020070205552135') and a.platform='13';
--4.��֤IBP����IPTV��������set_top_box_4k Ϊ��18����֤������½PAL���ݿ⣺

select crm_order_number,work_order_request from  ra_workorder_request where crm_order_number in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100','WMX2020070105552001','WMX2020070205552126','WMX2020070205552136','WMX2020070205552135') and request_type='queryIntResService';
--6.��֤����ԭ�ʲ���ѯ����ʱ�����ص�set_top_box_4k Ϊ��18����֤������½PAL���ݿ⣺

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100','WMX2020070105552001','WMX2020070205552126','WMX2020070205552136','WMX2020070205552135');
-- ��֤�󸶷ѿ����Ʒ����ITV�Ӳ�Ʒ���ҡ�4K�����С����ԣ������߲������С����Ƿ��ɷ���ONU����

select w.crm_order_number,w.user_id_97 from ra_workorder_request w where w.crm_order_number in ('2-30343454773','2-30343469276','2-30343471776','2-30343474275','2-30343475775');

select aa.ORDER_SEQ_ID,aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER like '%(2020)/404841383%' and aa.REQUEST_TYPE like '%query%';
select aa.ORDER_SEQ_ID,aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER like '%(2020)/404841397%' and aa.REQUEST_TYPE like '%query%';
select aa.ORDER_SEQ_ID,aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER like '%(2020)/404841587%' and aa.REQUEST_TYPE like '%query%';
select aa.ORDER_SEQ_ID,aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER like '%(2020)/404841586%' and aa.REQUEST_TYPE like '%query%';
-- ��ѯ��ӵ��еı��ģ�ims_type��ֵΪ��ΪIMS

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number like '%(2020)/404841383%';
select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number like '%(2020)/404841397%';
select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number like '%(2020)/404841587%';
select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number like '%(2020)/404841586%';
--�鿴��ֱͨ�����Ǹ����������onu�߼���ŷ����仯,��Ҫ�ɷ������ּ�ͥ����� �޸ĵ������ּ�ͥ�����ֲ𵥡�Vims�����װ����ims-hss/tel�����ֲ�
--����ͥ��������=SDN��
--�ɷ���SDN������޸ĵ���SDN�����ֲ���������������װ�������߹����ֲ������ONU�����ֲ𵥣�ONU�����װ����Enumʩ��ȷ�� ��ӡ�Enum������޸ĵ���SHLRʩ��ȷ�� ��ӡ�SHLR������޸ĵ�

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number like '%%';
--�鿴��ֱͨ�����Ǹ����������onu�߼�����ޱ仯,��Ҫ�ɷ���Vims�����װ����Ims-hss/tel�����ֲ𵥡�SHLR������޸ĵ���Enum������޸ĵ������ּ�ͥ������޸ĵ�
--����ͥ��������=SDN��
--�ɷ���SDN������޸ĵ�

select * from P6_CRM_NOTIFICATION where CRM_ORDER_NUMBER = 'WMX2020051105433000';
-- P6_CRM_NOTIFICATION�ǲ�ѯIBP����CRM��Ϣ��¼�ı�

--�ʺţ�nonphs_aa    ����nophsq
