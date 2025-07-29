create or replace function reporte_rendimiento_operadore() returns trigger as $$
begin
	case
		when new.estado = 'finalizado' then

			perform reportar_rendimiento_llamado_finalizado(new);

		when new.estado = 'desistido' and new.id_operadore is not null then
		
			perform reportar_rendimiento_llamado_desistido(new);
			
		else 

			-- no ejecuta nada
			
	end case;

	return new;

end;
$$ language plpgsql;
