CREATE PROCEDURE "BI-TEMPORAL_HISTORIZATION"."gbi-student-007.Bi-Temporal_Historization::main" ( )
   LANGUAGE SQLSCRIPT SQL SECURITY INVOKER DEFAULT SCHEMA "BI-TEMPORAL_HISTORIZATION" AS
BEGIN
   /*************************************
       Write your procedure logic 
   *************************************/
    DECLARE v_isbn VARCHAR(20):=' ';
    DECLARE CURSOR c_cursor1(v_isbn VARCHAR(20)) FOR
        select * from "BI-TEMPORAL_HISTORIZATION"."Customer_Business";
    FOR cur_row AS c_cursor1(v_isbn) 
	DO
        DECLARE no_of_rows int ;
        DECLARE DELCUS INT;
        no_of_rows:=0;
        SELECT count(*) INTO no_of_rows FROM "BI-TEMPORAL_HISTORIZATION"."Customer_Technical" AS CT WHERE CT.CUSTOMER_NUMBER = cur_row.CUSTOMER_NUMBER;
        IF :no_of_rows = 0 
    	THEN
            CALL "BI-TEMPORAL_HISTORIZATION"."gbi-student-007.Bi-Temporal_Historization::bitemporalInsert"(cur_row.CUSTOMER_NUMBER,cur_row.CUSTOMER_NAME,cur_row.CITY,cur_row.MODIFICATION_TIME,cur_row.BUSINESS_VALID_FROM,cur_row.BUSINESS_VALID_TO);
        ELSE
            IF TO_INT(cur_row.DELETE_CUSTOMER)=1
            THEN
                DELCUS:=1;
            ELSE 
                DELCUS:=0;
            END IF;
            CALL "BI-TEMPORAL_HISTORIZATION"."gbi-student-007.Bi-Temporal_Historization::bitemporalCorrection"(cur_row.CUSTOMER_NUMBER,cur_row.CUSTOMER_NAME,cur_row.CITY,cur_row.MODIFICATION_TIME,cur_row.BUSINESS_VALID_FROM,cur_row.BUSINESS_VALID_TO,DELCUS);
        END IF;
    END FOR;
END;

GO;

CREATE PROCEDURE "BI-TEMPORAL_HISTORIZATION"."gbi-student-007.Bi-Temporal_Historization::bitemporalInsert"(IN CNUM NVARCHAR(10),IN CNAME NVARCHAR(20),IN CTY NVARCHAR(35),IN MODTIME TIMESTAMP,IN BVALID_FROM DATE,IN BVALID_TO DATE)
   LANGUAGE SQLSCRIPT SQL SECURITY INVOKER DEFAULT SCHEMA "BI-TEMPORAL_HISTORIZATION" AS
BEGIN
   /*************************************
       Write your procedure logic 
   *************************************/
   INSERT INTO "BI-TEMPORAL_HISTORIZATION"."Customer_Technical" 
                (CUSTOMER_NUMBER,CUSTOMER_NAME,CITY,MODIFICATION_TIME,BUSINESS_VALID_FROM,BUSINESS_VALID_TO,TECHNICAL_VALID_FROM,TECHNICAL_VALID_TO) 
                VALUES 
                (CNUM,CNAME,CTY,MODTIME,BVALID_FROM,BVALID_TO,current_date,'9999-12-31');
END;

GO;

CREATE PROCEDURE "BI-TEMPORAL_HISTORIZATION"."gbi-student-007.Bi-Temporal_Historization::bitemporalCorrection"(IN CNUM NVARCHAR(10),IN CNAME NVARCHAR(20),IN CTY NVARCHAR(35), IN MODTIME TIMESTAMP,IN BVALID_FROM DATE,IN BVALID_TO DATE,IN DELCUS INT)
   LANGUAGE SQLSCRIPT SQL SECURITY INVOKER DEFAULT SCHEMA "BI-TEMPORAL_HISTORIZATION" AS
BEGIN
   /*************************************
       Write your procedure logic 
   *************************************/
    DECLARE v_isbn VARCHAR(20):=' ';
    DECLARE CURSOR c_cursor(v_isbn VARCHAR(20)) FOR
        select * from "BI-TEMPORAL_HISTORIZATION"."Customer_Technical" AS CT WHERE CT.CUSTOMER_NUMBER=CNUM AND CT.TECHNICAL_VALID_TO='9999-12-31' ORDER BY CT.BUSINESS_VALID_FROM;
    FOR cur_row AS c_cursor(v_isbn) 
	DO
	    IF (cur_row.BUSINESS_VALID_FROM<=BVALID_FROM AND cur_row.BUSINESS_VALID_TO>BVALID_FROM)
	        OR (cur_row.BUSINESS_VALID_FROM<BVALID_TO AND cur_row.BUSINESS_VALID_TO>=BVALID_TO)
	        OR (cur_row.BUSINESS_VALID_FROM>BVALID_FROM AND cur_row.BUSINESS_VALID_TO<BVALID_TO)
	    THEN 
	        UPDATE "BI-TEMPORAL_HISTORIZATION"."Customer_Technical" SET TECHNICAL_VALID_TO=current_date WHERE SKID=cur_row.SKID;
	        IF cur_row.BUSINESS_VALID_FROM<BVALID_FROM
	        THEN
	            INSERT INTO "BI-TEMPORAL_HISTORIZATION"."Customer_Technical" 
                    (CUSTOMER_NUMBER,CUSTOMER_NAME,CITY,MODIFICATION_TIME,BUSINESS_VALID_FROM,BUSINESS_VALID_TO,TECHNICAL_VALID_FROM,TECHNICAL_VALID_TO) 
                    VALUES
                    (cur_row.CUSTOMER_NUMBER, cur_row.CUSTOMER_NAME,cur_row.CITY,cur_row.MODIFICATION_TIME,cur_row.BUSINESS_VALID_FROM,BVALID_FROM,current_date,'9999-12-31');
	        END IF;
	        IF (cur_row.BUSINESS_VALID_TO>=BVALID_TO) AND (BVALID_TO!='9999-12-31') AND (cur_row.BUSINESS_VALID_TO!='9999-12-31')
	        THEN
	            INSERT INTO "BI-TEMPORAL_HISTORIZATION"."Customer_Technical" 
                    (CUSTOMER_NUMBER,CUSTOMER_NAME,CITY,MODIFICATION_TIME,BUSINESS_VALID_FROM,BUSINESS_VALID_TO,TECHNICAL_VALID_FROM,TECHNICAL_VALID_TO) 
                    VALUES
                    (cur_row.CUSTOMER_NUMBER, cur_row.CUSTOMER_NAME,cur_row.CITY,cur_row.MODIFICATION_TIME,BVALID_TO,cur_row.BUSINESS_VALID_TO,current_date,'9999-12-31');
	        END IF;
	    END IF;
	END FOR;
	INSERT INTO "BI-TEMPORAL_HISTORIZATION"."Customer_Technical" 
                    (CUSTOMER_NUMBER,CUSTOMER_NAME,CITY,MODIFICATION_TIME,BUSINESS_VALID_FROM,BUSINESS_VALID_TO,TECHNICAL_VALID_FROM,TECHNICAL_VALID_TO) 
                    VALUES 
                    (CNUM,CNAME,CTY,MODTIME,BVALID_FROM,BVALID_TO,current_date,'9999-12-31');
    IF DELCUS=1
    THEN
        UPDATE "BI-TEMPORAL_HISTORIZATION"."Customer_Technical" SET TECHNICAL_VALID_TO=current_date WHERE CUSTOMER_NUMBER=CNUM;
    END IF;
END;

GO;
