package db_bolt

import (
	"fmt"
    bolt "go.etcd.io/bbolt"
)

func CrearUpdate(db *bolt.DB, bucketName string, key []byte, val []byte) error {
    // abre transacción de escritura
    tx, err := db.Begin(true)
    if err != nil {
        return err
    }
    defer tx.Rollback()

    b, _ := tx.CreateBucketIfNotExists([]byte(bucketName))

    err = b.Put(key, val)
    if err != nil {
        return err
    }

    // cierra transacción
    if err := tx.Commit(); err != nil {
        return err
    }

    return nil
}

func MostrarDatosBucket(db * bolt.DB, bucketName string) error {
    // abre una transacción de lectura
    err := db.View(func(tx *bolt.Tx) error {
        b := tx.Bucket([]byte(bucketName))
        if errForEach := b.ForEach(func(k, v []byte) error {
        	fmt.Printf("ID: %s.  Datos: %s \n", k, v)
        	return nil
        }); errForEach != nil {
        	return errForEach
        }
        return nil
    })
    return err
	
}
