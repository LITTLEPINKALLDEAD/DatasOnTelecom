select * from ra_workorder_request where crm_order_number = '(2019)/19076533-0001'; --P7-����
select * from ra_workorder_request where crm_order_number = 'WMX2020040205288735'
select * from ra_workorder_request where P_RESULT is NOT null and rownum < 11 order by RECEIVE_TIME DESC; --���ݶ����Ľ���ʱ��ӽ���Զѡȡ���10���б�����Ϣ�Ķ���
select * from ra_workorder_request where crm_order_number = '2-30242684394'; --P7-���ʣ�����ԭ�ʲ�����
select * from ra_workorder_request where ORDER_SEQ_ID = '28471' order by RA_COMPLELED_TIME DESC; --P7-���ʣ���P7�Ų�ѯ
select * from ra_workorder_request where ORDER_SEQ_ID = '35174' order by RECEIVE_TIME DESC; --P7-���ʣ���P7�Ų�ѯ
select * from ra_workorder_request where crm_order_number like '%2-30285708158%' order by RECEIVE_TIME DESC;
select * from ra_workorder_request where crm_order_number in ('WMZ2019120500516845','WMZ2019120500519229') order by RECEIVE_TIME DESC;
select * from ra_workorder_request where USER_ID_97 like '%M1323110%' order by RECEIVE_TIME DESC;--(Servrice ID���豸�ţ����̵����)��97ID��ѯ

select * from RA_WORKORDER_REQUEST where CRM_ORDER_NUMBER = 'WMX2020040205289095' and REQUEST_TYPE like '%queryIntResService%' order by RECEIVE_TIME desc;

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
---dispatchMOrder(2M�����Ǵ�����),checkService����Դ���(2M)
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

select t.work_order_return from  ra_workorder_request t  where crm_order_number like '%(2019)/19065599%' and t.request_type='queryIntResService'
--��֤��Դ��Ϣ�������ֶ����м���Ϣ�ڵ㣨vtrunkinfo���ͷ��������Ϣ�ڵ�(alloccodeinfo) IBP�Ƿ��յ�

select p.work_order_request from pai_workorder_request p  where p.crm_order_number in ('2-30264173016'); 
-- �����2-30264222174��WMZ2019122500529376, �豸�ţ� ACC400807650785(��CRM��װ), WMZ2019122500531058����CRM�����,WMZ2019122500529380  �豸�ţ� ACC400807650815����CRM��װ�����Ӳ�Ʒ��
--��֤�ֶΣ��ͻ���ʶ��service_account�����ͻ����ơ�account_number����һ����Ʒ���롰һ���Ӳ�Ʒ��š���Ⱥ��š�group_number��


select * from pai_workorder_request where crm_order_number = '2-29978524433'; --P7-PAI --2-29936482320
select * from asap_workorder_request where crm_order_number = '2-29978513149';  --P7-asap

select * from INT_RES_CONFIG_RESULT_NEW where CRM_ORDER_NO = 'WMX2019112100508401' --��ѯPAL��������ı�

select q.wop_process_state from pai_workorder_request q where q.crm_order_number='WMZ2020032605228166' and q.platform='P027'; 
---��������Ʒ������֤��wop_process_stateΪ1ʱ��ʾ���ط�����

select q.pai_compleled_time from pai_workorder_request q  where q.crm_order_number='WMZ2020032605228166' and q.platform='P027';
---��������Ʒ������֤���ɷ��������ܹ��������������ȥWOP��������,pai_compleled_time���ʱ������֤�����Ƿ���Ч

select q.pai_compleled_time from pai_workorder_request q  where q.crm_order_number in('WMZ2020032705236482','WMZ2020032705236546') and q.platform='P027';
---��������Ʒ������֤���ɷ��������ܹ��������������ȥWOP��������,pai_comp

select userenv('language') from dual

select t.*,t.rowid from asap_workorder_request t where crm_order_number='WMX2020040205289121' and request_type='VIMS_OrderRequest' order by hist_seq_id;
--��֤IBP�ɷ���vims����

select t.*,t.rowid from asap_workorder_request t where crm_order_number in ('WMX2020040205288719','WMX2020040205289095','WMX2020040205288724','WMX2020040205289121') and request_type='VIMS_OrderRequest' order by hist_seq_id;
--��֤IBP�ɷ���vims����

--�ʺţ�nonphs_aa    ����nophsq
