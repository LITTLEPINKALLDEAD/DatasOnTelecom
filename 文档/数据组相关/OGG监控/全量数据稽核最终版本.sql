select 
tp.wk,
case
  when sum(tp.abs_his) = 0
    then '100.00%'
  else to_char(round(100-sum(tp.abs_his)/sum(tp.produce_his)*100,4),'fm9990.0000')||'%'
end avg_his,                                --��ʷƽ��
case
  when sum(tp.abs_new) = 0
    then '100.00%'
  else to_char(round(100-sum(tp.abs_new)/sum(tp.produce_new)*100,4),'fm9990.0000')||'%'
end this_week                               --�������
from(
select 
tc.create_date c_date,
--������ʷ�뱾������
--case
--  when to_date(tc.create_date,'yyyymmdd') < trunc(sysdate,'d')+1
--    then tc.kudu_cnt
--end kudu_his,                             --��ʷkudu����
case
  when to_date(tc.create_date,'yyyymmdd') < trunc(sysdate,'d')-6
    then tc.Produce_Cnt
end produce_his,                               --��ʷ��������
case
  when to_date(tc.create_date,'yyyymmdd') < trunc(sysdate,'d')-6
    then abs(tc.kudu_cnt - tc.produce_cnt)  --��ʷ���Բ�ֵ
end abs_his,
--case
--  when to_date(tc.create_date,'yyyymmdd') >= trunc(sysdate,'d')+1
--    then tc.kudu_cnt
--end kudu_new,                             --����kudu����
case
  when to_date(tc.create_date,'yyyymmdd') >= trunc(sysdate,'d')-6 and to_date(tc.create_date,'yyyymmdd') < trunc(sysdate,'d')+1
    then tc.Produce_Cnt
end produce_new,                               --������������
case
  when to_date(tc.create_date,'yyyymmdd') >= trunc(sysdate,'d')-6 and to_date(tc.create_date,'yyyymmdd') < trunc(sysdate,'d')+1
    then abs(tc.kudu_cnt - tc.produce_cnt)   --���ܾ��Բ�ֵ
end abs_new,
case
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = 'monday   '
    then '1������һ'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = 'tuesday  '
    then '2�����ڶ�'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = 'wednesday'
    then '3��������'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = 'thursday '
    then '4��������'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = 'friday   '
    then '5��������'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = 'saturday '
    then '6��������'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = 'sunday   '
    then '7��������'
end wk                                      --����һ�����շ���ͳ��
from TABLE_COMPARE tc
WHERE tc.kudu_cnt <> 0
and tc.kudu_cnt is not null
and tc.produce_cnt <> 0
and tc.produce_cnt is not null
) tp
group by tp.wk
