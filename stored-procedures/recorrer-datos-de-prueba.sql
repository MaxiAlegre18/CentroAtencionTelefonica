create or replace function recorrerDatosDePrueba() returns void as $$
declare
	dato record;
begin
	for dato in 
		select *
		from datos_de_prueba
		order by id_orden
	loop
		case dato.operacion
			when 'nuevo llamado' then
				perform ingreso_llamado(dato.id_cliente);
			when 'baja llamado' then
				perform desistimiento_de_llamado(dato.id_cola_atencion);
			when 'atencion llamado' then
				perform atención_llamado_en_espera();
			when 'fin llamado' then
				perform finalizacion_llamado(dato.id_cola_atencion);
			when 'alta tramite' then
				perform alta_de_tramite(dato.id_cola_atencion, dato.tipo_tramite, dato.descripcion_tramite);
			when 'cierre tramite' then
				
		end case;
	end loop;
end;
$$ language plpgsql;
