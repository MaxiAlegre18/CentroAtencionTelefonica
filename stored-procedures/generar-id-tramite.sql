create or replace function generar_id_tramite() returns int as $$
declare
	idGenerado int;
begin
	select coalesce(max(id_tramite),0) + 1
	into idGenerado
	from tramite;

	return idGenerado;
end;
$$ language plpgsql;
