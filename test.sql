

TRUNCATE TABLE "GBI_007"."Customer_Staging_Store";

drop procedure "BI-TEMPORAL_HISTORIZATION"."gbi-student-007.Bi-Temporal_Historization::bitemporalCorrection";

TRUNCATE TABLE "BI-TEMPORAL_HISTORIZATION"."Customer_Business";
INSERT INTO "BI-TEMPORAL_HISTORIZATION"."Customer_Business" 
    (CUSTOMER_NUMBER,CUSTOMER_NAME,CITY,DELETE_CUSTOMER,MODIFICATION_TIME,BUSINESS_VALID_FROM,BUSINESS_VALID_TO)
    VALUES
    ('B123','JOHN DOE','BEACHY',FALSE,CURRENT_TIMESTAMP,'2005-06-01','9999-12-31');
    
    
DROP PROCEDURE "BI-TEMPORAL_HISTORIZATION"."gbi-student-007.Bi-Temporal_Historization::main";

DROP PROCEDURE "BI-TEMPORAL_HISTORIZATION"."gbi-student-007.Bi-Temporal_Historization::bitemporalInsert";

DROP PROCEDURE "BI-TEMPORAL_HISTORIZATION"."gbi-student-007.Bi-Temporal_Historization::bitemporalCorrection";

CALL "BI-TEMPORAL_HISTORIZATION"."gbi-student-007.Bi-Temporal_Historization::main"();