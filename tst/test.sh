#!/bin/bash

curl -L "http://localhost:8000/cikado/verkaro?kiu=klasikaj"

curl -L "http://localhost:8000/cikado/verkaro?kiu=chiuj"

curl -L "http://localhost:8000/cikado/cikado?sercho=hundo&kie=klasikaj"

curl -L "http://localhost:8000/cikado/cikado?sercho=+hundo&kie=klasikaj"

curl -L "http://localhost:8000/cikado/cikado?sercho=\bhun[dt]o&kie=klasikaj"

curl -L "http://localhost:8000/cikado/kunteksto?frazo=35967&n=2"

