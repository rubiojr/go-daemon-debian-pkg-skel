package main

import (
	"fmt"
	"time"
	log "github.com/Sirupsen/logrus"
)

func main() {
	for {
		log.Info("I'm a daemon")
		time.Sleep(5*time.Second)
	}
}

