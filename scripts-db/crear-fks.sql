alter table cola_atencion add constraint cola_atencion_cliente_fk foreign key (id_cliente) references cliente (id_cliente); 

alter table cola_atencion add constraint cola_atencion_operadore_fk foreign key (id_operadore) references operadore (id_operadore);
 
alter table tramite  add constraint tramite_cliente_fk foreign key (id_cliente) references cliente (id_cliente); 

alter table tramite  add constraint tramite_cola_atencion_fk foreign key (id_cola_atencion) references cola_atencion (id_cola_atencion);

alter table rendimiento_operadore  add constraint rendimiento_operadore_operadore_fk foreign key (id_operadore) references operadore (id_operadore);

alter table error  add constraint error_cliente_fk foreign key (id_cliente) references cliente (id_cliente); 

alter table error  add constraint error_cola_atencion_fk foreign key (id_cola_atencion) references cola_atencion (id_cola_atencion);

alter table error  add constraint error_tramite_fk foreign key (id_tramite) references tramite (id_tramite);
