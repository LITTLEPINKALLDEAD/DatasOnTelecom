update siebel.s_order_item set status_cd='97���',processed_flg='N',EAI_EXPRT_STAT_CD='���깤����' 
where row_id in
(select row_id from siebel.S_ORDER_ITEM 
where ORDER_ID in
(select row_id from siebel.S_ORDER where ORDER_NUM in 
('2-30309707282')) and 
PAR_ORDER_ITEM_ID is null and
(PROCESSED_FLG <> 'Y' or STATUS_CD='97���') and
ACTION_CD<>'���е�')

commit;
--1.��������Ŀˢ��97���

select row_id,PROCESSED_FLG,STATUS_CD,service_num from siebel.S_ORDER_ITEM 
where ORDER_ID in
(select row_id from siebel.S_ORDER where ORDER_NUM in 
('2-30309707282')) and 
PAR_ORDER_ITEM_ID is null and
(PROCESSED_FLG <> 'Y' or STATUS_CD='97���') and
ACTION_CD<>'���е�'

--2.��ѯ��������ĿID
--�Ƚ�����Ŀˢ��97���״̬���ٲ�ѯ��������Ŀ��ID����ģ����������
--CRMģ��������ҳ�Ŵ���Ѱ�ң��������ļ�1���ļ�2,���ļ�2�Ĵ���������ֵ������ROW_ID
--����ʽ|2-DS9XRG0|2-DS9XRH7|�����ٽ���ִ��
--2-30007915046�ɹ��깤��������Ӷ�����2-30017522181��2-30017529510Ҳ�깤��


select * from siebel.S_ORDER where ORDER_NUM='2-30335573161';
update siebel.S_ORDER set STATUS_CD='ͨ���Ϸ���У��' where row_id='2-DXP0M21';
commit;
--��CRM״̬Ϊͨ���Ϸ���У��

select * from siebel.S_ORDER where ORDER_NUM='2-30335573161';
update siebel.S_ORDER set STATUS_CD='ͨ���Ϸ���У��' where row_id='2-DTG5A84';
commit;
--2-22494391826��LHH��,2-22414821620(ZQY),All updated successfully!

select STATUS_CD from siebel.S_ORDER where ORDER_NUM in ('2-30007915046','2-30017522181','2-30017529510');
select STATUS_CD from siebel.S_ORDER where ORDER_NUM = '2-30023855818';
--��ѯ������״̬

select * from siebel.S_ORDER where STATUS_CD='ͨ���Ϸ���У��'

select SS.STATUS_CD from siebel.S_ORDER SS where SS.ORDER_NUM='2-30285926616';
--siebel.S_ORDER�е�STATUS_CDΪ��CRM���Ͷ�����״̬

select userenv('language') from dual;
