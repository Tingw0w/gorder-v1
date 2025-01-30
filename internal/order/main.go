package main

import (
	"github.com/Tingw0w/gorder-pay/common/config"
	"github.com/spf13/viper"
	"log"
)

func init() {
	// viper config
	if err := config.NewViperConfig(); err != nil {
		log.Fatal(err)
	}
}

func main() {
	log.Printf("%v", viper.Get("order"))
	/**
	原生
	*/
	//log.Println("Listening on :8082")
	//mux := http.NewServeMux()
	//mux.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
	//	log.Printf("%v \n", r.RequestURI)
	//	_, _ = io.WriteString(w, "pong")
	//})
	//if err := http.ListenAndServe(":8082", mux); err != nil {
	//	log.Fatal(err)
	//}
}
