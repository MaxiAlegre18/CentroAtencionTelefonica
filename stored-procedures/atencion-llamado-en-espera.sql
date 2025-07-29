create or replace function atención_llamado_en_espera() returns boolean as $$
	declare 
	id_op int;
	id_llamado_en_espera int;

	begin
		id_op = -1;
		id_llamado_en_espera = -1;
	
		if ( (select count(id_operadore) from operadore where disponible = true) > 0 AND 
			(select count(id_cola_atencion) from cola_atencion where estado = 'en espera') > 0 ) then
		         id_op := (select id_operadore 
		                  from operadore
		                  where disponible = true
		                  limit 1);
 
                  id_llamado_en_espera:=(select id_cola_atencion
			       from cola_atencion
			       where estado='en espera'
			       order by f_inicio_llamado asc
			       limit 1);
			       
				   update cola_atencion set id_operadore=id_op,f_inicio_atencion=current_timestamp, 
                   estado='en linea' where id_cola_atencion=id_llamado_en_espera;

                   update operadore o set disponible = 'false' where o.id_operadore = id_op;
			       return true;

		elsif(select count (id_cola_atencion) from cola_atencion where estado='en espera')<1  then 
		  insert into error(id_error, operacion, f_error, motivo) values
		  (generar_id_error(),'atencion_llamado',current_timestamp, '? no existe ningun llamado en espera'); 
		  return false;

		elsif(select count(id_operadore) from operadore where disponible=true)<1 then
		  insert into error(id_error, operacion, f_error, motivo) values
		  (generar_id_error(),'atencion_llamado',current_timestamp, '? no existe ningune operadore disponible'); 
		  return false;

		end if;
	end;
       $$ language plpgsql;
