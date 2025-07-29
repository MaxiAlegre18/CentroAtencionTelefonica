create or replace trigger reporte_rendimiento_operadore_trg
before insert or update on cola_atencion
for each row
execute procedure reporte_rendimiento_operadore();
