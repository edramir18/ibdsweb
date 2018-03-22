--------------------------------------------------------
--  File created - Thursday-March-22-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence SEQ_CANAL
--------------------------------------------------------

   CREATE SEQUENCE  "IBDS"."SEQ_CANAL"  MINVALUE 1 MAXVALUE 100 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_LOGS
--------------------------------------------------------

   CREATE SEQUENCE  "IBDS"."SEQ_LOGS"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 772561 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Sequence SEQ_PERIODO
--------------------------------------------------------

   CREATE SEQUENCE  "IBDS"."SEQ_PERIODO"  MINVALUE 1 MAXVALUE 100 INCREMENT BY 1 START WITH 101 CACHE 20 NOORDER  NOCYCLE ;
--------------------------------------------------------
--  DDL for Table CANAL
--------------------------------------------------------

  CREATE TABLE "IBDS"."CANAL" 
   (	"ID" NUMBER, 
	"NOMBRE" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table CATEGORIA
--------------------------------------------------------

  CREATE TABLE "IBDS"."CATEGORIA" 
   (	"ID" NUMBER, 
	"NOMBRE" VARCHAR2(20 BYTE), 
	"ORDEN" NUMBER, 
	"FILL" VARCHAR2(10 BYTE), 
	"COLOR" VARCHAR2(20 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table LOGS
--------------------------------------------------------

  CREATE TABLE "IBDS"."LOGS" 
   (	"ID" NUMBER, 
	"USUARIO" NUMBER, 
	"CANAL" NUMBER, 
	"TRANSACCION" NUMBER, 
	"ERROR" VARCHAR2(20 BYTE), 
	"FECHA" TIMESTAMP (6), 
	"CODIGODIA" VARCHAR2(8 BYTE), 
	"CODIGOHORA" VARCHAR2(2 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table PERIODO
--------------------------------------------------------

  CREATE TABLE "IBDS"."PERIODO" 
   (	"ID" NUMBER, 
	"VALOR" NUMBER, 
	"RANGO" VARCHAR2(10 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table TRANSACCION
--------------------------------------------------------

  CREATE TABLE "IBDS"."TRANSACCION" 
   (	"ID" NUMBER, 
	"NOMBRE" VARCHAR2(50 BYTE), 
	"CATEGORIA" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table USUARIO
--------------------------------------------------------

  CREATE TABLE "IBDS"."USUARIO" 
   (	"ID" NUMBER, 
	"FECHA" TIMESTAMP (6)
   ) ;
--------------------------------------------------------
--  DDL for Index TRANSACCION_IDX_CATEGORIA
--------------------------------------------------------

  CREATE INDEX "IBDS"."TRANSACCION_IDX_CATEGORIA" ON "IBDS"."TRANSACCION" ("CATEGORIA") 
  ;
--------------------------------------------------------
--  DDL for Index LOGS_IDX_CODIGODIA
--------------------------------------------------------

  CREATE INDEX "IBDS"."LOGS_IDX_CODIGODIA" ON "IBDS"."LOGS" ("CODIGODIA", "CODIGOHORA") 
  ;
--------------------------------------------------------
--  DDL for Index TRANSACCION_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "IBDS"."TRANSACCION_PK" ON "IBDS"."TRANSACCION" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index USUARIO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "IBDS"."USUARIO_PK" ON "IBDS"."USUARIO" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index CANAL_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "IBDS"."CANAL_PK" ON "IBDS"."CANAL" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index LOGS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "IBDS"."LOGS_PK" ON "IBDS"."LOGS" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index PERIODO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "IBDS"."PERIODO_PK" ON "IBDS"."PERIODO" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Index PERIODO_IDX_RANGO
--------------------------------------------------------

  CREATE INDEX "IBDS"."PERIODO_IDX_RANGO" ON "IBDS"."PERIODO" ("RANGO") 
  ;
--------------------------------------------------------
--  DDL for Index CATEGORIA_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "IBDS"."CATEGORIA_PK" ON "IBDS"."CATEGORIA" ("ID") 
  ;
--------------------------------------------------------
--  DDL for Trigger TGR_PERIODO
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "IBDS"."TGR_PERIODO" 
   before insert on "IBDS"."PERIODO" 
   for each row 
begin  
   if inserting then 
      if :NEW."ID" is null then 
         select SEQ_PERIODO.nextval into :NEW."ID" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "IBDS"."TGR_PERIODO" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_CANAL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "IBDS"."TRG_CANAL" 
   before insert on "IBDS"."CANAL" 
   for each row 
begin  
   if inserting then 
      if :NEW."ID" is null then 
         select SEQ_CANAL.nextval into :NEW."ID" from dual; 
      end if; 
   end if; 
end;



/
ALTER TRIGGER "IBDS"."TRG_CANAL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_LOGS
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "IBDS"."TRG_LOGS" 
   before insert on "IBDS"."LOGS" 
   for each row 
begin  
   if inserting then 
      if :NEW."ID" is null then 
         select SEQ_LOGS.nextval into :NEW."ID" from dual; 
      end if; 
   end if; 
end;


/
ALTER TRIGGER "IBDS"."TRG_LOGS" ENABLE;
--------------------------------------------------------
--  Constraints for Table PERIODO
--------------------------------------------------------

  ALTER TABLE "IBDS"."PERIODO" ADD CONSTRAINT "PERIODO_PK" PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "IBDS"."PERIODO" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TRANSACCION
--------------------------------------------------------

  ALTER TABLE "IBDS"."TRANSACCION" ADD CONSTRAINT "TRANSACCION_PK" PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "IBDS"."TRANSACCION" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table LOGS
--------------------------------------------------------

  ALTER TABLE "IBDS"."LOGS" MODIFY ("CODIGODIA" NOT NULL ENABLE);
  ALTER TABLE "IBDS"."LOGS" ADD CONSTRAINT "LOGS_PK" PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "IBDS"."LOGS" MODIFY ("TRANSACCION" NOT NULL ENABLE);
  ALTER TABLE "IBDS"."LOGS" MODIFY ("CANAL" NOT NULL ENABLE);
  ALTER TABLE "IBDS"."LOGS" MODIFY ("USUARIO" NOT NULL ENABLE);
  ALTER TABLE "IBDS"."LOGS" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table USUARIO
--------------------------------------------------------

  ALTER TABLE "IBDS"."USUARIO" ADD CONSTRAINT "USUARIO_PK" PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "IBDS"."USUARIO" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CATEGORIA
--------------------------------------------------------

  ALTER TABLE "IBDS"."CATEGORIA" ADD CONSTRAINT "CATEGORIA_PK" PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "IBDS"."CATEGORIA" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CANAL
--------------------------------------------------------

  ALTER TABLE "IBDS"."CANAL" ADD CONSTRAINT "CANAL_PK" PRIMARY KEY ("ID") ENABLE;
  ALTER TABLE "IBDS"."CANAL" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "IBDS"."CANAL" MODIFY ("ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table LOGS
--------------------------------------------------------

  ALTER TABLE "IBDS"."LOGS" ADD CONSTRAINT "LOGS_FK_CANAL" FOREIGN KEY ("CANAL")
	  REFERENCES "IBDS"."CANAL" ("ID") ENABLE;
  ALTER TABLE "IBDS"."LOGS" ADD CONSTRAINT "LOGS_FK_TRANSACCION" FOREIGN KEY ("TRANSACCION")
	  REFERENCES "IBDS"."TRANSACCION" ("ID") ENABLE;
  ALTER TABLE "IBDS"."LOGS" ADD CONSTRAINT "LOGS_FK_USUARIO" FOREIGN KEY ("USUARIO")
	  REFERENCES "IBDS"."USUARIO" ("ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table TRANSACCION
--------------------------------------------------------

  ALTER TABLE "IBDS"."TRANSACCION" ADD CONSTRAINT "TRANSACCION_FK_CATEGORIA" FOREIGN KEY ("CATEGORIA")
	  REFERENCES "IBDS"."CATEGORIA" ("ID") ENABLE;
