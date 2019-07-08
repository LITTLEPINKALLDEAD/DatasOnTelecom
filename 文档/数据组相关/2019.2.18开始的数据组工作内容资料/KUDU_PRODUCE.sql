select 
tp.wk,
case
  when sum(tp.abs_his) = 0
    then '100.00%'
  else to_char(round(100-sum(tp.abs_his)/sum(tp.produce_his)*100,4),'fm9990.0000')||'%'
end avg_his,                                --历史平均
case
  when sum(tp.abs_new) = 0
    then '100.00%'
  else to_char(round(100-sum(tp.abs_new)/sum(tp.produce_new)*100,4),'fm9990.0000')||'%'
end this_week                               --上周情况
from(
select 
tc.create_date c_date,
--区分历史与本周数据
--case
--  when to_date(tc.create_date,'yyyymmdd') < trunc(sysdate,'d')+1
--    then tc.kudu_cnt
--end kudu_his,                             --历史kudu数据
case
  when to_date(tc.create_date,'yyyymmdd') < trunc(sysdate,'d')-6
    then tc.Produce_Cnt
end produce_his,                               --历史生产数据
case
  when to_date(tc.create_date,'yyyymmdd') < trunc(sysdate,'d')-6
    then abs(tc.kudu_cnt - tc.produce_cnt)  --历史KUDU与生产的绝对差值
end abs_his,
--case
--  when to_date(tc.create_date,'yyyymmdd') >= trunc(sysdate,'d')+1
--    then tc.kudu_cnt
--end kudu_new,                             --上周kudu数据
case
  when to_date(tc.create_date,'yyyymmdd') >= trunc(sysdate,'d')-6 and to_date(tc.create_date,'yyyymmdd') < trunc(sysdate,'d')+1
    then tc.Produce_Cnt
end produce_new,                               --上周生产数据
case
  when to_date(tc.create_date,'yyyymmdd') >= trunc(sysdate,'d')-6 and to_date(tc.create_date,'yyyymmdd') < trunc(sysdate,'d')+1
    then abs(tc.kudu_cnt - tc.produce_cnt)   --上周KUDU与生产的绝对差值
end abs_new,
case
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = '星期一'
    then '星期一'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = '星期二'
    then '星期二'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = '星期三'
    then '星期三'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = '星期四'
    then '星期四'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = '星期五'
    then '星期五'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = '星期六'
    then '星期六'
  when to_char(to_date(tc.create_date,'yyyymmdd'),'day') = '星期日'
    then '星期日'
end wk                                    --按周一至周日分组统计
from TABLE_COMPARE tc
WHERE tc.kudu_cnt <> 0
and tc.kudu_cnt is not null
and tc.produce_cnt <> 0
and tc.produce_cnt is not null
) tp
group by tp.wk
order by decode(tp.wk, '星期一',1,'星期二',2,'星期三',3,'星期四',4,'星期五',5,'星期六',6,'星期日',7)                          --排序
