#############################################################
###query the TDs with relevant parameters directly from DB
####TDs in 2021 (tpt_id,SE, crop, target, assess_type,assess_unit,part_rated
####no_rep,no_trt,no_trial,indication)

##add product_phase_code_id
#phase 0 alpha design and p rep design
SQL1 <- paste0("
       SELECT    ft.TPT_ID_KEY as tpt_id,
          SUBSTRING(ft.TPT_ID_KEY, 1, 1) as indication,
          SUBSTRING(ft.TPT_ID_KEY, 2, 1) as category,
           sta.code_value as status,
           sede.SE_ID as SE,
           mo.OBJECTS as crop,
           mo2.OBJECTS as target,
           ast.code_value as assess_type,
           asu.code_value as assess_unit,
          /*pr.code_value as part_rated,*/
           ft.NO_TREATMENTS as no_trt,
           ft.NO_REPLICATES as no_rep,
           ft.PLANNED_TOTAL_NO_TRIALS as no_trial,
           ft.NO_REPLICATES*ft.PLANNED_TOTAL_NO_TRIALS as no_obs
         from SCOUT.FIELD_TESTING as ft
         left JOIN SCOUT.TRIAL_RESPONSIBLE as tr ON tr.FIELD_TESTING_ID = ft.FIELD_TESTING_ID
         left join scout.master_code as sta on ft.status_code_id=sta.code_id
         left JOIN SCOUT.ASSESSMENT_HEADER as ah ON ah.FIELD_TESTING_ID = ft.FIELD_TESTING_ID
         left JOIN SCOUT.ASSESSMENT as a ON a.FIELD_TESTING_ID = ft.FIELD_TESTING_ID
         left JOIN SCOUT.SE_DETAIL as sede ON sede.SE_MASTER_ID = ah.SE_KEY_SE_MASTER_ID
         left JOIN SCOUT.MASTER_OBJECTS as mo ON mo.OBJECTS_ID = ah.CROP_OBJECTS_ID
         left JOIN SCOUT.MASTER_OBJECTS as mo2 ON mo2.OBJECTS_ID = ah.TARGET_OBJECTS_ID 
         left join scout.master_code as ast on ast.code_id=a.RATING_DATA_TYPE_CODE_ID 
         left join scout.master_code as asu on asu.code_id=a.RATING_UNIT_SCALE_CODE_ID 
         left join scout.master_code as pr on pr.code_id=a.PART_RATED_CODE_ID 
         WHERE ft.field_testing_type = 1  
            and ft.FIELD_YEAR = 2021
            and sta.code_value !='9' /*status 1*/
           /* and ft.NO_TREATMENTS>1*/
           /* and ft.PLANNED_TOTAL_NO_TRIALS>1*/
            and indication in ('F','S','H','I')
          and category in ('A','D','R')
            
       ")
td0<- distinct(dbGetQuery(conn=connection, statement=SQL1))

tpt1<-unique(td0$tpt_id)
##2365

####check the TDs with one TRT  
###no_trt=1
trt1<-subset(td0, no_trt==1&status==1)
trt1_tpt<-length(unique(trt1$tpt_id))
trt1_tpt<-print(unique(trt1$tpt_id))  ##23 TDs
write.csv(trt1,"trt1.csv")
write.csv(trt1_tpt,"trt1_tpt.csv")

obs1<-subset(td,no_obs==1)
length(unique(obs1$tpt_id))  #7 TDs

td<-filter(td,no_trt>1)
td<-filter(td,no_obs>1)

tpt2<-unique(td$tpt_id)
##2339
#td<- na.omit(distinct(dbGetQuery(conn=connection, statement=SQL1)))

###check the number of non na entry of each column
apply(td, 2, function(x) length(which(!is.na(x))))

write.csv(td,"td2021.csv")

####read data
td<-read.csv("td2021.csv")
