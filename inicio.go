package main

import (
	"fmt"
    "database/sql"
	"io/ioutil"
	_ "github.com/lib/pq"
	"log"
	"inicio.go/db_bolt"
)

func mostrarMenu() {
	fmt.Printf("### MENÚ ###\n")
	fmt.Printf("1 Crear base de datos\n")
	fmt.Printf("2 Crear tablas\n")
	fmt.Printf("3 Agregar PKs y FKs\n")
	fmt.Printf("4 Eliminar PKs y FKs\n")
	fmt.Printf("5 Cargar datos\n")
	fmt.Printf("6 Crear stored procedures y triggers\n")
	fmt.Printf("7 Iniciar pruebas\n")
	fmt.Printf("8 Cargar datos en BoltDB\n")
	fmt.Printf("9 Mostrar datos de BoltDB\n")
	fmt.Printf("0 Salir\n")
}

func opcionElegida() {
	var opcion int

	for {
		fmt.Scanf("%d", &opcion)
		switch opcion {
		case 1:
			crearBD()
			fmt.Println("Base de datos creada")

		case 2:
			crearTablas()
			fmt.Println("Tablas creadas")

		case 3:
			crearPKs()
			crearFKs()
			fmt.Println("PKs y FKs agregadas")

		case 4:
			eliminarFKs()
			eliminarPKs()
			fmt.Println("PKs y FKs eliminadas")
			
		case 5:
			cargarClientes()
			cargarOperadores()
			cargarDatosDePrueba()
			fmt.Println("Datos cargados")

		case 6:
			cargarStoredProcedures()
			cargarTriggers()
			fmt.Println("Stored procedures y triggers cargados")

		case 7:
			iniciarPruebas()
			fmt.Println("Pruebas iniciadas")

		case 8:
			db_bolt.CargarDatosEnBoltDB()
			fmt.Println("Datos cargados en BoltBD")

		case 9:
			db_bolt.MostrarDatosDeBoltDB()
			fmt.Println("Datos mostrados de BoltDB")
			mostrarMenu()

		case 0:
			fmt.Println("Salir")
			return

		default:
			fmt.Println("Opción no válida")
		}
	}

}

func main() {
	mostrarMenu()
	opcionElegida()

}

func crearBD() {
	db, err := sql.Open("postgres", "user=postgres host=localhost dbname=postgres sslmode=disable")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	_, err = db.Exec("drop database if exists alegre_galvan_madariaga_meira_db1;")
	if err !=nil {
		log.Fatal(err)
	}

	_, err = db.Exec("create database alegre_galvan_madariaga_meira_db1;")
	if err !=nil {
		log.Fatal(err)
	}
}

func crearTablas() {
	db := conectarABaseDeDatos()
	defer db.Close()

	ejecutarSQL(db ,"scripts-db/crear-tablas.sql")
}

func crearPKs() {
	db := conectarABaseDeDatos()
	defer db.Close()
	
	ejecutarSQL(db ,"scripts-db/crear-pks.sql")
}

func crearFKs() {
	db := conectarABaseDeDatos()
	defer db.Close()
	
	ejecutarSQL(db ,"scripts-db/crear-fks.sql")
}

func eliminarPKs() {
	db := conectarABaseDeDatos()
	defer db.Close()
	
	ejecutarSQL(db ,"scripts-db/eliminar-pks.sql")
}

func eliminarFKs() {
	db := conectarABaseDeDatos()
	defer db.Close()
	
	ejecutarSQL(db ,"scripts-db/eliminar-fks.sql")
}

func cargarClientes() {
	db := conectarABaseDeDatos()
	defer db.Close()
	
	ejecutarSQL(db ,"scripts-db/insert-clientes.sql")
}

func cargarOperadores() {
	db := conectarABaseDeDatos()
	defer db.Close()
	
	ejecutarSQL(db ,"scripts-db/insert-operadores.sql")
}

func cargarDatosDePrueba() {
	db := conectarABaseDeDatos()
	defer db.Close()
	
	ejecutarSQL(db ,"scripts-db/insert-datos-de-prueba.sql")
}

func cargarStoredProcedures() {
	db := conectarABaseDeDatos()
	defer db.Close()

	var storedProcedures = []string{
			"stored-procedures/recorrer-datos-de-prueba.sql",
			"stored-procedures/generar-id-cola-atencion.sql",
			"stored-procedures/generar-id-error.sql",
			"stored-procedures/generar-id-tramite.sql",
			"stored-procedures/ingreso-de-llamado.sql",
			"stored-procedures/desistimiento-de-llamado.sql",
			"stored-procedures/reportar-rendimiento-llamado-desistido.sql",
			"stored-procedures/reportar-rendimiento-llamado-finalizado.sql",
			"stored-procedures/reporte-rendimiento-operadore.sql",
			"stored-procedures/alta-de-tramite.sql",
			"stored-procedures/atencion-llamado-en-espera.sql",
			"stored-procedures/finalizacion_llamado.sql"}

	for i := 0; i < len(storedProcedures); i++ {
		ejecutarSQL(db , storedProcedures[i])
	}
}

func cargarTriggers() {
	db := conectarABaseDeDatos()
	defer db.Close()

	var triggers = []string{"stored-procedures/reporte-rendimiento-operadore-trg.sql"}

	for i := 0; i < len(triggers); i++ {
		ejecutarSQL(db , triggers[i])
	}
}

func iniciarPruebas() {
	db := conectarABaseDeDatos()
	defer db.Close()
	
	_, err := db.Exec("select recorrerDatosDePrueba()")
	if err !=nil {
		log.Fatal(err)
	}
	
}

func conectarABaseDeDatos() *sql.DB {
	db, err := sql.Open("postgres", "user=postgres host=localhost dbname=alegre_galvan_madariaga_meira_db1 sslmode=disable")
	if err != nil {
		log.Fatal(err)
	}
	return db
}

func ejecutarSQL(db *sql.DB, contenido string) {
	file, err :=ioutil.ReadFile(contenido)
	if err !=nil {
		log.Fatal(err)
	}
	string :=string(file)

	_, err = db.Exec(string)
	if err !=nil {
		log.Fatal(err)
	}
}
