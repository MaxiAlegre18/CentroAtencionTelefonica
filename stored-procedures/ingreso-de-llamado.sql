create or replace function ingreso_llamado(idCLiente int) returns int as $$
declare
	idColaAtencion int;
begin
	if (select count(*) from cliente where id_cliente = idCliente) = 0 then
		insert into error (id_error, operacion, f_error, motivo)
			   values (generar_id_error(), 'nuevo llamado', current_timestamp, 'id de cliente no valido');
		return -1;
	end if;

	idColaAtencion := generar_id_cola_atencion();
	insert into cola_atencion(id_cola_atencion, id_cliente, f_inicio_llamado, estado)
		   values (idColaAtencion, idCliente, current_timestamp, 'en espera');
	return idColaAtencion;
end;
$$ language plpgsql;
