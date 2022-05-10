###filter with the top assessments (assess_type, assess_unit)
SQL <- paste0(" select *
  from (
    select SUBSTRING(ft.TPT_ID_KEY, 1, 1) as indication, 
    mc.CODE_VALUE as assess_type, 
    /*mc.DECODE1 as decode, */
    asu.code_value as assess_unit,
   count(distinct a.TIMING_ID) as usage
    FROM SCOUT.ASSESSMENT as a
    LEFT JOIN SCOUT.FIELD_TESTING ft on ft.FIELD_TESTING_ID = a.FIELD_TESTING_ID
    LEFT JOIN SCOUT.MASTER_CODE mc on mc.CODE_ID = a.RATING_DATA_TYPE_CODE_ID
    left join scout.master_code asu on asu.code_id=a.RATING_UNIT_SCALE_CODE_ID 
    LEFT JOIN SCOUT.CROP c on a.CROP_ID = c.CROP_ID
    LEFT JOIN SCOUT.MASTER_OBJECTS mo on mo.OBJECTS_ID = c.CROP_OBJECTS_ID
    LEFT JOIN SCOUT.TARGET t on a.TARGET_ID = t.TARGET_ID
    LEFT JOIN SCOUT.MASTER_OBJECTS mo2 on mo2.OBJECTS_ID = t.TARGET_OBJECTS_ID
    WHERE ft.FIELD_YEAR > 2010 and a.ORIGINAL_CALCULATED_CODE_ID = 10032 and
     ft.field_testing_type = 3 and 
    indication in ('F','S','H','I')
    group by indication,assess_type,assess_unit
  ) as t1
order by t1.indication,t1.usage desc
       ")

top0<- distinct(dbGetQuery(conn=connection, statement=SQL))

#df1<-df %>%
 # filter(assess_type!="PHYGEN",assess_type!="COMPAT",assess_type!="PHYTHI",
 #        indication!="O")####exclude phygen,compat and phythi
##the data do not follow normal distribution and CV cannot be calculated 

###select the top assessments
top<-top0 %>%
  group_by(indication)%>%
  mutate(rank=rank(desc(usage)))%>%
  filter(rank<=10) 
#%>%
 # yield2<-filter(yield1,TRT==1|TRT==4|TRT==5)(assess_type!=ARERED, -DENSTY, -DISTAN, -PHYGEN)

################################################
###join td, va and use top as filter
join0<-inner_join(top,va,by=c("indication","assess_type","assess_unit"))
join<-join0%>%mutate(sd1=ifelse(sd<sd_tran,sd,sd_tran),cv1=ifelse(cv<cv_tran,cv,cv_tran))%>%
  dplyr::select(indication,assess_type,assess_unit,cv1,sd1)

###histogram(small multiple) for top_va/join
##no ARERED, DENSTY, DISTAN, PHYGEN,
png(filename = "CV_by_assess1.png",width = 800, height = 400)
ggplot(data = join) +
  aes(join$cv1)+
  geom_histogram(aes(colour = factor(indication)), breaks=seq(0, 100, by=1))+
  xlim(0,100)+
  ylim(0,400)+
  labs(title="Histogram for CVs by assessment type", x="CV", y="Count")+
  facet_wrap(~assess_type)
dev.off()


####med

top_va <- join %>%
  group_by(indication,assess_type,assess_unit) %>%
  summarise(cv = median(cv1),sd = median(sd1),count=n()) %>%
  mutate(mean=sd/cv*100)%>%
  arrange(indication,assess_type,desc(count))

td_va0<-inner_join(td,top_va,by=c("indication","assess_type","assess_unit"))

write.csv(top,"top.csv")
write.csv(top_va,"top_va.csv")
write.csv(td_va0,"td_va0.csv")


####read data if needed
va<-read.csv("variance.csv")
top<-read.csv("top.csv")
