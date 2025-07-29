alter table cola_atencion drop constraint cola_atencion_cliente_fk; 

alter table cola_atencion drop constraint cola_atencion_operadore_fk;
 
alter table tramite  drop constraint tramite_cliente_fk;  

alter table tramite  drop constraint tramite_cola_atencion_fk;

alter table rendimiento_operadore  drop constraint rendimiento_operadore_operadore_fk;

alter table error  drop constraint error_cliente_fk;

alter table error  drop constraint error_cola_atencion_fk;

alter table error  drop constraint error_tramite_fk;
