create or replace function desistimiento_de_llamado(idColaAtencion int) returns boolean as $$
begin
    if (select count(*) from cola_atencion where id_cola_atencion = idColaAtencion) = 0 then
        insert into error (id_error, operacion, f_error, motivo)
        values (generar_id_error(), 'baja llamado', current_timestamp, 'id de cola de atencion no valido');
        return false;
    end if;

    if (select estado from cola_atencion where id_cola_atencion = idColaAtencion) not in ('en espera', 'en linea') then
        insert into error (id_error, operacion, f_error, motivo)
        values (generar_id_error(), 'baja llamado', current_timestamp, 'el llamado no esta en espera ni en linea');
        return false;
    end if;

    if (select estado from cola_atencion where id_cola_atencion = idColaAtencion) = 'en linea' then
        update cola_atencion
        set estado = 'desistido', f_fin_atencion = current_timestamp
        where id_cola_atencion = idColaAtencion;
    else
        update cola_atencion
        set estado = 'desistido'
        where id_cola_atencion = idColaAtencion;
    end if;

    return true;
end;
$$ language plpgsql;
