create or replace function finalizacion_llamado(ca_id int) returns boolean as $$

declare

begin
    
    -- Que el id de cola exista. En caso de que no cumpla, se debe cargar un error con el mensaje ?id de cola no válida.
    if not exists (select 1 from cola_atencion where id_cola_atencion = ca_id) then
        insert into error values (generar_id_error(), 'fin llamado', null, ca_id, null, null, null, null, current_timestamp, 'id de cola de atencion no valido');
        return false;
    end if;

    --que el estado del llamado sea en linea, de ser distinto se carga un error con el mensaje ?el llamado no esta en linea
    if exists (select 1 from cola_atencion where id_cola_atencion = ca_id and estado != 'en linea') then
        insert into error values (generar_id_error(), 'fin llamado', null, ca_id, null, null, null, null, current_timestamp, 'el llamado no esta en linea');
        return false;
    end if;

    -- actualiza la fila de la cola de atencion con el id que se obtuvo
    update cola_atencion set f_fin_atencion = current_timestamp,
			     estado = 'finalizado' 
	where id_cola_atencion = ca_id;
	
    return true;

end;
$$ language plpgsql;
