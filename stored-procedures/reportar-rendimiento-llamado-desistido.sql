create or replace function reportar_rendimiento_llamado_desistido(filaNueva record) returns void as $$
declare
	rendimiento_operadore_actual record;

	duracion_atencion_actual interval;
	fecha_atencion_actual date;

	duracion_total_atenciones_incluyendo_actual interval;
	cantidad_total_atenciones_incluyendo_actual int;
	duracion_promedio_total_atenciones_incluyendo_actual interval;

	duracion_atenciones_finalizadas_incluyendo_actual interval;
	cantidad_atenciones_finalizadas_incluyendo_actual int;
	duracion_promedio_atenciones_finalizadas_incluyendo_actual interval;

	duracion_atenciones_desistidas_incluyendo_actual interval;
	cantidad_atenciones_desistidas_incluyendo_actual int;
	duracion_promedio_atenciones_desistidas_incluyendo_actual interval;
	
	
begin

	duracion_atencion_actual = filaNueva.f_fin_atencion::time - filaNueva.f_inicio_atencion::time;
	fecha_atencion_actual = filaNueva.f_inicio_atencion::date;
		
	select * into rendimiento_operadore_actual from rendimiento_operadore r 
	where filaNueva.id_operadore = r.id_operadore and fecha_atencion_actual = r.fecha_atencion;
			
	if found then
		-- update datos atenciones generales:
			
		duracion_total_atenciones_incluyendo_actual = 
			rendimiento_operadore_actual.duracion_total_atenciones + duracion_atencion_actual;

		cantidad_total_atenciones_incluyendo_actual =
			rendimiento_operadore_actual.cantidad_total_atenciones + 1;

		duracion_promedio_total_atenciones_incluyendo_actual =
			duracion_total_atenciones_incluyendo_actual / cantidad_total_atenciones_incluyendo_actual;

		-- update datos atenciones desistidas

		duracion_atenciones_desistidas_incluyendo_actual =
			rendimiento_operadore_actual.duracion_atenciones_desistidas + duracion_atencion_actual;

		cantidad_atenciones_desistidas_incluyendo_actual = 
			rendimiento_operadore_actual.cantidad_atenciones_desistidas + 1;

		duracion_promedio_atenciones_desistidas_incluyendo_actual =
			duracion_atenciones_desistidas_incluyendo_actual / cantidad_atenciones_desistidas_incluyendo_actual;

		-- actualizar registro con los datos ya actualizados
			
		update rendimiento_operadore r set
		duracion_total_atenciones = duracion_total_atenciones_incluyendo_actual,
		cantidad_total_atenciones = cantidad_total_atenciones_incluyendo_actual,
		duracion_promedio_total_atenciones = duracion_promedio_total_atenciones_incluyendo_actual,
		duracion_atenciones_desistidas = duracion_atenciones_desistidas_incluyendo_actual,
		cantidad_atenciones_desistidas = cantidad_atenciones_desistidas_incluyendo_actual,
		duracion_promedio_atenciones_desistidas = duracion_promedio_atenciones_desistidas_incluyendo_actual
		where filaNueva.id_operadore = r.id_operadore and fecha_atencion_actual = r.fecha_atencion;

		else
			
			insert into rendimiento_operadore
			values(
				filaNueva.id_operadore, 
				fecha_atencion_actual,			-- fecha_atencion
				duracion_atencion_actual,		-- duracion_total_atenciones
				1,								-- cantidad_total_atenciones
				duracion_atencion_actual,		-- duracion_promedio_total_atenciones
				'00:00:00',						-- duracion_atenciones_finalizadas
				0,								-- cantidad_atenciones_finalizadas
				'00:00:00',						-- duracion_promedio_atenciones_finalizadas
				duracion_atencion_actual,		-- duracion_atenciones_desistidas
				1,								-- cantidad_atenciones_desistidas
				duracion_atencion_actual		-- duracion_promedio_total_atenciones
				);
	end if;

	-- marcar operador como disponible:
	update operadore o set disponible = true where filaNueva.id_operadore = o.id_operadore;

end;
$$ language plpgsql;
