
--��ĸ��
select count(*) from ftth_once_success_20170516 aa 
where to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2018-04-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2018-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
;

���ӣ�
select count(*) from ftth_once_success_20170516 gy
where to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2018-03-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2018-04-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
and (gy.if_kb_tuidan='��' or gy.if_zz_tuidan='��' or gy.order_status in ('3','6'));

FTTH�˵���������ȡ�������嵥��
select decode(gy.bureau_code,'1','�ֶ�','2','����','3','����','4','����','5','����','6','����',
'7','ݷ��','8','��ɽ','9','����','a','ר��','c','��ɽ','d','����','e','�ζ�','f','����','g','����',
'h','�ϻ�','i','�ɽ�'),gy.* 
from ftth_once_success_20170516 gy
where to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2019-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2019-02-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
and (gy.if_kb_tuidan='��' or gy.if_zz_tuidan='��' or gy.order_status in ('3','6'));


select * from ftth_once_success_20170516 gy where action_name = 'Y' and product_code in ('524','566')
and   to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2018-07-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2018-08-01 00:00:00','yyyy-mm-dd hh24:mi:ss')


����������
select decode(aa.bureau_code,'1','�ֶ�','2','����','3','����','4','����','5','����','6','����',
'7','ݷ��','8','��ɽ','9','����','a','ר��','c','��ɽ','d','����','e','�ζ�','f','����','g','����',
'h','�ϻ�','i','�ɽ�'),count(*) from ftth_once_success_20170516 aa 
where to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2018-12-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2019-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
group by decode(aa.bureau_code,'1','�ֶ�','2','����','3','����','4','����','5','����','6','����',
'7','ݷ��','8','��ɽ','9','����','a','ר��','c','��ɽ','d','����','e','�ζ�','f','����','g','����',
'h','�ϻ�','i','�ɽ�');

select aa.* from ftth_once_success_20170516 aa 
where to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2018-03-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2018-04-01 00:00:00','yyyy-mm-dd hh24:mi:ss');


