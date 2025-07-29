package db_bolt
import (
	"encoding/json"
    "log"
    bolt "go.etcd.io/bbolt"
    "strconv"
    "time"
    "io/ioutil"
)

type Cliente struct {
	IdCliente int
	Nombre string
	Apellido string
	Dni int
	FechaNacimiento time.Time
	Telefono string
	Email string
}

type Operadore struct {
	IdOperadore int
	Nombre string
	Apellido string
	Dni int
	FechaIngreso time.Time
	Disponible bool
}

type Cola_atencion struct {
	IdColaAtencion int
	IdCliente int
	FechaInicioLlamado time.Time
	IdOperadore int
	FechaInicioAtencion time.Time
	FechaFinAtencion time.Time
	Estado string
}

type Tramite struct {
	IdTramite int
	IdCliente int
	IdColaAtencion int
	TipoTramite string
	FechaInicioGestion time.Time
	Descripcion string
	FechaFinGestion time.Time
	Respuesta string
	Estado string
}

func CargarDatosEnBoltDB() {
    db, err := bolt.Open("db_bolt/Centro_de_Atencion_Telefonica.db", 0600, nil)
    if err != nil {
        log.Fatal(err)
    }
    defer db.Close()

	cargarClientes(db)
	cargarOperadores(db)
	cargarLlamados(db)
	cargarTramites(db)
}

func cargarClientes(db *bolt.DB) {
	archivoLeido := leerArchivo("db_bolt/archivos_json/clientes.json")

    var clientes []Cliente

	err := json.Unmarshal(archivoLeido, &clientes)
	if err != nil {
		log.Fatal(err)
	}
	

	for i := 0; i < len(clientes); i++ {
		data, err := json.Marshal(clientes[i])
    	if err != nil {
    		log.Fatal(err)
    	}

    	CrearUpdate(db, "cliente", []byte(strconv.Itoa(clientes[i].IdCliente)), data)
	}
}

func cargarOperadores(db *bolt.DB) {
    archivoLeido := leerArchivo("db_bolt/archivos_json/operadores.json")

    var operadores []Operadore

	err := json.Unmarshal(archivoLeido, &operadores)
	if err != nil {
		log.Fatal(err)
	}

	for i := 0; i < len(operadores); i++ {
		data, err := json.Marshal(operadores[i])
    	if err != nil {
    		log.Fatal(err)
    	}

    	CrearUpdate(db, "operadore", []byte(strconv.Itoa(operadores[i].IdOperadore)), data)
	}
}

func cargarLlamados(db *bolt.DB) {
    archivoLeido := leerArchivo("db_bolt/archivos_json/llamados.json")

    var llamados []Cola_atencion

	err := json.Unmarshal(archivoLeido, &llamados)
	if err != nil {
		log.Fatal(err)
	}

	for i := 0; i < len(llamados); i++ {
		data, err := json.Marshal(llamados[i])
    	if err != nil {
    		log.Fatal(err)
    	}

    	CrearUpdate(db, "cola_atencion", []byte(strconv.Itoa(llamados[i].IdColaAtencion)), data)
	}
}

func cargarTramites(db *bolt.DB) {
    archivoLeido := leerArchivo("db_bolt/archivos_json/tramites.json")

    var tramites []Tramite

	err := json.Unmarshal(archivoLeido, &tramites)
	if err != nil {
		log.Fatal(err)
	}

	for i := 0; i < len(tramites); i++ {
		data, err := json.Marshal(tramites[i])
    	if err != nil {
    		log.Fatal(err)
    	}

    	CrearUpdate(db, "tramite", []byte(strconv.Itoa(tramites[i].IdTramite)), data)
	}
}

func leerArchivo(ruta string) []byte {
	archivoLeido, err := ioutil.ReadFile(ruta)

	if err != nil {
		log.Fatal(err)
	}

	return archivoLeido
}
