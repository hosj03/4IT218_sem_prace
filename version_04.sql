/*==============================================================*/
/* DBMS name:      ORACLE Version 10g                           */
/* Created on:     13.12.2020 17:57:06                          */
/*==============================================================*/


alter table HRAJE_ZA
   drop constraint FK_HRAJE_ZA_HRAJE_ZA_HRAC;

alter table HRAJE_ZA
   drop constraint FK_HRAJE_ZA_HRAJE_ZA2_TYM;

alter table SPONZORUJE
   drop constraint FK_SPONZORU_SPONZORUJ_SPONZOR;

alter table SPONZORUJE
   drop constraint FK_SPONZORU_SPONZORUJ_TYM;

alter table ZAPAS
   drop constraint FK_ZAPAS_DOMACI_TYM;

alter table ZAPAS
   drop constraint FK_ZAPAS_HOSTE_TYM;

drop index HRAJE_ZA2_FK;

drop index HRAJE_ZA_FK;

drop index SPONZORUJE2_FK;

drop index SPONZORUJE_FK;

drop index DOMACI_FK;

drop index HOSTE_FK;

drop table HRAC cascade constraints;

drop table HRAJE_ZA cascade constraints;

drop table SPONZOR cascade constraints;

drop table SPONZORUJE cascade constraints;

drop table TYM cascade constraints;

drop table ZAPAS cascade constraints;

/*==============================================================*/
/* Table: HRAC                                                  */
/*==============================================================*/
create table HRAC  (
   ID_H                 INTEGER                         not null,
   JMENO                VARCHAR2(100)                   not null,
   PRIJMENI             VARCHAR2(50)                    not null,
   DAT_NAR              DATE                            not null,
   constraint PK_HRAC primary key (ID_H)
);

/*==============================================================*/
/* Table: HRAJE_ZA                                              */
/*==============================================================*/
create table HRAJE_ZA  (
   ID_H                 INTEGER                         not null,
   ZKRATKA              VARCHAR2(3)                     not null,
   PRICHOD              DATE                            not null
      constraint CKC_PRICHOD_HRAJE_ZA check (EXTRACT(MONTH FROM PRICHOD) > 4 AND
       EXTRACT(MONTH FROM PRICHOD) < 10),
   ODCHOD               DATE                            default NULL 
      constraint CKC_ODCHOD_HRAJE_ZA check (EXTRACT(MONTH FROM ODCHOD) > 4 AND
       EXTRACT(MONTH FROM ODCHOD) < 10),
   CISLO_DRESU          INTEGER                         not null
      constraint CKC_CISLO_DRESU_HRAJE_ZA check (CISLO_DRESU between 0 and 99),
   constraint PK_HRAJE_ZA primary key (ID_H, ZKRATKA),
   constraint CKT_HRAJE_ZA check (PRICHOD <= ODCHOD)
);

/*==============================================================*/
/* Index: HRAJE_ZA_FK                                           */
/*==============================================================*/
create index HRAJE_ZA_FK on HRAJE_ZA (
   ID_H ASC
);

/*==============================================================*/
/* Index: HRAJE_ZA2_FK                                          */
/*==============================================================*/
create index HRAJE_ZA2_FK on HRAJE_ZA (
   ZKRATKA ASC
);

/*==============================================================*/
/* Table: SPONZOR                                               */
/*==============================================================*/
create table SPONZOR  (
   ICO                  NUMBER(8)                         not null
      constraint CKC_ICO_SPONZOR check (ICO >= 0 AND LENGTH(ICO) = 8),
   NAZEV                VARCHAR2(100)                   not null,
   JEDNATEL             VARCHAR2(150)                   not null,
   VYSE_SPONZORSTVI    NUMBER(12,2)                    not null
      constraint CKC_VYSE_SPONZORSTVI_SPONZOR check (VYSE_SPONZORSTVI >= 0),
   constraint PK_SPONZOR primary key (ICO)
);

/*==============================================================*/
/* Table: SPONZORUJE                                            */
/*==============================================================*/
create table SPONZORUJE  (
   ICO                  NUMBER(8)                         not null,
   ZKRATKA              VARCHAR2(3)                     not null,
   constraint PK_SPONZORUJE primary key (ICO, ZKRATKA)
);

/*==============================================================*/
/* Index: SPONZORUJE_FK                                         */
/*==============================================================*/
create index SPONZORUJE_FK on SPONZORUJE (
   ICO ASC
);

/*==============================================================*/
/* Index: SPONZORUJE2_FK                                        */
/*==============================================================*/
create index SPONZORUJE2_FK on SPONZORUJE (
   ZKRATKA ASC
);

/*==============================================================*/
/* Table: TYM                                                   */
/*==============================================================*/
create table TYM  (
   ZKRATKA              VARCHAR2(3)                     not null
   	  constraint CKC_ZKRATKA_TYM check (LENGTH(ZKRATKA) = 3),
   CELY_NAZEV           VARCHAR2(50)                    not null,
   KONFERENCE           VARCHAR2(1)                     not null
      constraint CKC_KONFERENCE_TYM check (KONFERENCE in ('W','E')),
   constraint PK_TYM primary key (ZKRATKA)
);

/*==============================================================*/
/* Table: ZAPAS                                                 */
/*==============================================================*/
create table ZAPAS  (
   DOMACI               VARCHAR2(3)                     not null,
   HOSTE                VARCHAR2(3)                     not null,
   DATUM                DATE                            not null
      constraint CKC_DATUM_ZAPAS check( EXTRACT(MONTH FROM DATUM) >= 10 OR
        EXTRACT(MONTH FROM DATUM)<= 4),
   MESTO_KONANI         VARCHAR2(150)                   not null,
   SKORE                VARCHAR2(7)                     not null
      constraint CKC_SKORE_ZAPAS check(INSTR(SKORE, ':', 1) > 0 AND
      (SUBSTR( SKORE, 0, INSTR(SKORE, ':' , 1) - 1) >= 0 AND
      SUBSTR( SKORE, 0, INSTR(SKORE, ':' , 1) - 1) is not null) AND
      (SUBSTR( SKORE, INSTR(SKORE, ':', 1) + 1, LENGTH(SKORE)) >= 0 AND
      	SUBSTR( SKORE, INSTR(SKORE, ':', 1) + 1, LENGTH(SKORE)) is not null) AND
      SUBSTR( SKORE, 0, INSTR(SKORE, ':' , 1) - 1) != SUBSTR( SKORE, INSTR(SKORE, ':', 1) + 1, LENGTH(SKORE))),
   constraint PK_ZAPAS primary key (DOMACI, HOSTE, DATUM),
   constraint CKT_ZAPAS check (DOMACI != HOSTE)   
);

/*==============================================================*/
/* Index: DOMACI_FK                                             */
/*==============================================================*/
create index DOMACI_FK on ZAPAS (
   DOMACI ASC
);

/*==============================================================*/
/* Index: HOSTE_FK                                              */
/*==============================================================*/
create index HOSTE_FK on ZAPAS (
   HOSTE ASC
);

alter table HRAJE_ZA
   add constraint FK_HRAJE_ZA_HRAJE_ZA_HRAC foreign key (ID_H)
      references HRAC (ID_H)
      on delete cascade;

alter table HRAJE_ZA
   add constraint FK_HRAJE_ZA_HRAJE_ZA2_TYM foreign key (ZKRATKA)
      references TYM (ZKRATKA);

alter table SPONZORUJE
   add constraint FK_SPONZORU_SPONZORUJ_SPONZOR foreign key (ICO)
      references SPONZOR (ICO)
      on delete cascade;

alter table SPONZORUJE
   add constraint FK_SPONZORU_SPONZORUJ_TYM foreign key (ZKRATKA)
      references TYM (ZKRATKA);

alter table ZAPAS
   add constraint FK_ZAPAS_DOMACI_TYM foreign key (DOMACI)
      references TYM (ZKRATKA);

alter table ZAPAS
   add constraint FK_ZAPAS_HOSTE_TYM foreign key (HOSTE)
      references TYM (ZKRATKA);

CREATE OR REPLACE TRIGGER viceZapasuJednohoTymuVJedenDen
BEFORE INSERT or UPDATE on ZAPAS
FOR EACH ROW
DECLARE
val number:=0;
BEGIN
    val := porovnani(:new.domaci, :new.hoste, :new.datum);
    if(val = 1)
    then
        raise_application_error(-20000, 'domácí tým, již tento den zápas hrál');
    end if;
    if(val = 2)
    then
        raise_application_error(-20000, 'hostující tým, již tento den zápas hrál');
    end if;
    if(val = 3)
    then
        raise_application_error(-20000, 'oba týmy, již tento den zápas hrály');
    end if;
END;
/

create or replace function porovnani(domaci_func in VARCHAR2, hoste_func in VARCHAR2, datum_func in DATE)
return number as val number;
domaci_pocet number := 0;
hoste_pocet number := 0;

begin
val:=0;

select count(*) into domaci_pocet
from zapas
where datum_func = datum and
(domaci like domaci_func or hoste like domaci_func);

select count(*) into hoste_pocet
from zapas
where datum_func = datum and
(hoste like hoste_func or domaci like hoste_func);

if (domaci_pocet > 0) then val:= val + 1;
end if;

if (hoste_pocet > 0) then val:= val + 2;
end if;

return(val);
end;
/

drop SEQUENCE hrac_seq;

create SEQUENCE hrac_seq
start with 1
increment by 1
nomaxvalue
nocycle;

CREATE OR REPLACE TRIGGER id_h
before insert on hrac
for each row
begin
select hrac_seq.nextval into :new.id_h
from dual;
end;
/

CREATE OR REPLACE TRIGGER kontrolaExistenceHrajeZa
BEFORE INSERT or UPDATE on HRAJE_ZA
FOR EACH ROW
DECLARE
	prichod_trig number := 0;
BEGIN
	select count(*) into prichod_trig
	from hraje_za
	where id_h = :new.id_h and
	(odchod is null or :new.prichod <= odchod);

	if(prichod_trig > 0) then
	raise_application_error(-20000, 'hráč již hraje za jiný tým');
	end if;
END;
/

GRANT SELECT ON HRAC TO STUDENT;
GRANT SELECT ON HRAJE_ZA TO STUDENT;
GRANT SELECT ON SPONZOR TO STUDENT;
GRANT SELECT ON SPONZORUJE TO STUDENT;
GRANT SELECT ON TYM TO STUDENT;
GRANT SELECT ON ZAPAS TO STUDENT;

GRANT DELETE,INSERT,SELECT,UPDATE ON HRAC TO DB4IT218;
GRANT DELETE,INSERT,SELECT,UPDATE ON HRAJE_ZA TO DB4IT218;
GRANT DELETE,INSERT,SELECT,UPDATE ON SPONZOR TO DB4IT218;
GRANT DELETE,INSERT,SELECT,UPDATE ON SPONZORUJE TO DB4IT218;
GRANT DELETE,INSERT,SELECT,UPDATE ON TYM TO DB4IT218;
GRANT DELETE,INSERT,SELECT,UPDATE ON ZAPAS TO DB4IT218;