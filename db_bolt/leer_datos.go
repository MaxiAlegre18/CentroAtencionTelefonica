package db_bolt
import (
	"fmt"
    "log"
    bolt "go.etcd.io/bbolt"
)

func MostrarDatosDeBoltDB() {
	db, err := bolt.Open("db_bolt/Centro_de_Atencion_Telefonica.db", 0600, nil)
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

    mostrarClientes(db)
    mostrarOperadores(db)
    mostrarLlamados(db)
    mostrarTramites(db)

}

func mostrarClientes(db *bolt.DB) {
	fmt.Printf("-------------------- [ Mostrando información de clientes ]  --------------------- \n")
	MostrarDatosBucket(db, "cliente")
	fmt.Printf("-------------------- -------------------------------------  --------------------- \n")
}

func mostrarOperadores(db *bolt.DB) {
	fmt.Printf("-------------------- [ Mostrando información de operadores ]  --------------------- \n")
	MostrarDatosBucket(db, "operadore")
	fmt.Printf("-------------------- ---------------------------------------  --------------------- \n")
}

func mostrarLlamados(db *bolt.DB) {
	fmt.Printf("-------------------- [ Mostrando información de llamados ]  --------------------- \n")
	MostrarDatosBucket(db, "cola_atencion")
	fmt.Printf("-------------------- -------------------------------------  --------------------- \n")
}

func mostrarTramites(db *bolt.DB) {
	fmt.Printf("-------------------- [ Mostrando información de tramites ]  --------------------- \n")
	MostrarDatosBucket(db, "tramite")
	fmt.Printf("-------------------- -------------------------------------  --------------------- \n")
}
