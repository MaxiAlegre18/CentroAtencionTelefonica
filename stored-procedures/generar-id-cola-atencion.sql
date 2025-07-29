create or replace function generar_id_cola_atencion() returns int as $$
declare
	idGenerado int;
begin
	select coalesce(max(id_cola_atencion),0) + 1
	into idGenerado
	from cola_atencion;

	return idGenerado;
end;
$$ language plpgsql;
