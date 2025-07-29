create or replace function alta_de_tramite(id_at int, tipo_de_tramite char, descr text) returns int as $$
	declare 
	id_tram int;
	id_c int;
	

	begin
		id_tram = -1;
		id_c = 0;
	
		if not (tipo_de_tramite='consulta' or tipo_de_tramite='reclamo') THEN
				insert into error(id_error,operacion, f_error, motivo) values
				(generar_id_error(),'alta tramite', current_timestamp, '? tipo de tramite no válido');

				return id_tram;

		elsif(exists(select 1 from cola_atencion where id_cola_atencion=id_at))  and
			     (select estado from cola_atencion where id_cola_atencion=id_at) <> 'en espera' THEN 
				  id_tram:=generar_id_tramite();
				  id_c:=(select id_cliente from cola_atencion where id_cola_atencion=id_at);
				  insert into tramite(id_tramite, id_cliente, id_cola_atencion, tipo_tramite, f_inicio_gestion, descripcion, estado)
			      values(id_tram, id_c, id_at, tipo_de_tramite, current_timestamp, descr, 'iniciado');
			      
			      return id_tram;
			      

		else  
			 	  insert into error(id_error, operacion, f_error, motivo) 
				  values(generar_id_error(), 'alta tramite', current_timestamp, '? id de cola de atención no válido');
				 
				  return id_tram;
		
		end if;

		end;
		$$ language plpgsql;
