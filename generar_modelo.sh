#!/bin/bash

# Verificar si se proporcionaron los parámetros necesarios
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Uso: ./model_generated.sh <nombre_modelo> <clave_primaria> <sufijo_proyecto> <atributo:tipo>..."
  exit 1
fi

MODEL_NAME=$1
PRIMARY_KEY=$2
PROJECT_SUFIJO=$3
shift 3 # Eliminar los tres primeros argumentos (nombre del modelo, clave primaria, y sufijo del proyecto) de la lista de parámetros
ATTRIBUTES=("$@") # El resto de los argumentos son los atributos

# Definir la ruta base
BASE_DIR="src/main/java/com/$PROJECT_SUFIJO/domain/models"

# Crear carpetas si no existen
mkdir -p $BASE_DIR
mkdir -p "src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/in/rest/controller/request"
mkdir -p "src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/in/rest/controller/response"
mkdir -p "src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/out/database/entities"

# Función para generar clases
generate_class() {
  CLASS_NAME=$1
  PACKAGE_NAME=$2
  FILE_PATH=$3

  echo "package $PACKAGE_NAME;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ${CLASS_NAME} {

    private Long $PRIMARY_KEY;
" > $FILE_PATH

  # Agregar los atributos a la clase
  for ATTRIBUTE in "${ATTRIBUTES[@]}"
  do
    ATTRIBUTE_NAME=$(echo $ATTRIBUTE | cut -d':' -f1)
    ATTRIBUTE_TYPE=$(echo $ATTRIBUTE | cut -d':' -f2)
    echo "    private $ATTRIBUTE_TYPE $ATTRIBUTE_NAME;" >> $FILE_PATH
  done

  # Cerrar la clase
  echo "}" >> $FILE_PATH
}

# Generar el modelo
generate_class $MODEL_NAME "com.$PROJECT_SUFIJO.domain.models" "$BASE_DIR/${MODEL_NAME}.java"

# Generar el request
generate_class "${MODEL_NAME}Request" "com.$PROJECT_SUFIJO.infrastructure.adapters.in.rest.controller.request" \
"src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/in/rest/controller/request/${MODEL_NAME}Request.java"

# Generar el response
generate_class "${MODEL_NAME}Response" "com.$PROJECT_SUFIJO.infrastructure.adapters.in.rest.controller.response" \
"src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/in/rest/controller/response/${MODEL_NAME}Response.java"

# Generar la entidad
ENTITY_FILE="src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/out/database/entities/${MODEL_NAME}Entity.java"

echo "package com.$PROJECT_SUFIJO.infrastructure.adapters.out.database.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class ${MODEL_NAME}Entity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long $PRIMARY_KEY;
" > $ENTITY_FILE

# Agregar los atributos a la entidad
for ATTRIBUTE in "${ATTRIBUTES[@]}"
do
  ATTRIBUTE_NAME=$(echo $ATTRIBUTE | cut -d':' -f1)
  ATTRIBUTE_TYPE=$(echo $ATTRIBUTE | cut -d':' -f2)
  echo "    private $ATTRIBUTE_TYPE $ATTRIBUTE_NAME;" >> $ENTITY_FILE
done

# Cerrar la clase de la entidad
echo "}" >> $ENTITY_FILE

echo "Modelo, Request, Response y Entity para ${MODEL_NAME} generados correctamente en el paquete com.$PROJECT_SUFIJO."
