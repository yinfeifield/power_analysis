#######################
####variance (tpt_id,SE,crop, target, assess_type,assess_unit,part_rated,
#### SD, CV with and without transformation,####indication)
SQLStatement <- paste0("
        SELECT ft.TPT_ID_KEY as tpt_id,
               SUBSTRING(ft.TPT_ID_KEY, 1, 1) as indication,
               sede.SE_ID as SE,
               mo.OBJECTS as crop,
               mot.OBJECTS as target,
                cmrd.CODE_VALUE as assess_type,
                cmru.CODE_VALUE as assess_unit,
                cmss.CODE_VALUE as part_rated,
               asest.UNTR0_TRAN0_STANDARD_DEVIATION as sd,
               asest.UNTR0_TRAN1_STANDARD_DEVIATION as sd_tran,
               asest.UNTR0_TRAN0_COEFF_OF_VARIATION as cv,
               asest.UNTR0_TRAN1_COEFF_OF_VARIATION as cv_tran
        FROM scout.FIELD_TESTING as ft
        LEFT OUTER JOIN scout.MASTER_OBJECTS AS mo ON mo.OBJECTS_ID = ft.FIRST_CROP_OBJECTS_ID
        left JOIN SCOUT.ASSESSMENT_HEADER as ah ON ah.FIELD_TESTING_ID = ft.FIELD_TESTING_ID
        left JOIN SCOUT.SE_DETAIL as sede ON sede.SE_MASTER_ID = ah.SE_KEY_SE_MASTER_ID
        INNER JOIN scout.ASSESSMENT AS ase ON ft.FIELD_TESTING_ID = ase.FIELD_TESTING_ID
        LEFT JOIN scout.TARGET AS ta ON ta.TARGET_ID = ase.TARGET_ID           
        LEFT OUTER JOIN scout.MASTER_OBJECTS AS mot ON mot.OBJECTS_ID = ta.TARGET_OBJECTS_ID           
        INNER JOIN scout.MASTER_CODE AS mc ON ft.FIELD_COUNTRY_CODE_ID = mc.CODE_ID 
        RIGHT JOIN scout.ASSESSMENT_STATISTICS AS asest ON asest.ASSESSMENT_ID = ase.ASSESSMENT_ID
        LEFT OUTER JOIN scout.MASTER_CODE AS cmru on cmru.CODE_ID = ase.RATING_UNIT_SCALE_CODE_ID
        LEFT OUTER JOIN scout.MASTER_CODE AS cmrd on cmrd.CODE_ID = ase.RATING_DATA_TYPE_CODE_ID
        LEFT OUTER JOIN scout.MASTER_CODE AS cmss on cmss.CODE_ID = ase.PART_RATED_CODE_ID
      
        WHERE ft.FIELD_TESTING_TYPE_CODE_ID = 11788 and
        ft.field_testing_type = 3 and
        ft.field_year between 2011 and 2020 and 
        length(mo.objects)=5  
        /*and length(mot.objects)=6*/
       ")

va<- na.omit(distinct(dbGetQuery(conn=connection, statement=SQLStatement)))

write.csv(va,file="variance.csv")


####read data if needed
va<-read.csv("variance.csv")


