create or replace function generar_id_error() returns int as $$
declare
	idGenerado int;
begin
	select coalesce(max(id_error),0) + 1
	into idGenerado
	from error;

	return idGenerado;
end;
$$ language plpgsql;
