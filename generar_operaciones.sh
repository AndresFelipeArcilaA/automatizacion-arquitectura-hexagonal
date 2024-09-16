#!/bin/bash

# Verificar si se proporcionó el parámetro necesario
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Uso: ./crear_componentes.sh <nombre-entidad> <sufijo-proyecto>"
  exit 1
fi

ENTITY_NAME=$1
PROJECT_SUFIJO=$2
ENTITY_NAME_LOWER=$(echo "${ENTITY_NAME}" | awk '{print tolower(substr($0,1,1)) tolower(substr($0,2))}')


mkdir -p "src/main/java/com/$PROJECT_SUFIJO/application/usecases/${ENTITY_NAME_LOWER}"
mkdir -p "src/main/java/com/$PROJECT_SUFIJO/infrastructure/ports/in/${ENTITY_NAME_LOWER}"

# Crear Repository
REPOSITORY_FILE="src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/out/database/repository/${ENTITY_NAME}Repository.java"
echo "package com.$PROJECT_SUFIJO.infrastructure.adapters.out.database.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.$PROJECT_SUFIJO.infrastructure.adapters.out.database.entities.${ENTITY_NAME}Entity;

public interface ${ENTITY_NAME}Repository extends JpaRepository<${ENTITY_NAME}Entity, Long> {
}
" > $REPOSITORY_FILE

#Crear Port 

PORT_FILE="src/main/java/com/$PROJECT_SUFIJO/infrastructure/ports/out/${ENTITY_NAME}Port.java"
echo "package com.$PROJECT_SUFIJO.infrastructure.ports.out;

import java.util.List;

import com.$PROJECT_SUFIJO.domain.models.$ENTITY_NAME;

public interface ${ENTITY_NAME}Port {

	$ENTITY_NAME save($ENTITY_NAME model);
	
	void deleted(Long id);
	
	$ENTITY_NAME findById(Long id);
	
	List<$ENTITY_NAME> findAll();
}
"> $PORT_FILE 

#Crear Adaptador
ADAPTER_FILE="src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/out/database/${ENTITY_NAME}Adapter.java"

echo "package com.$PROJECT_SUFIJO.infrastructure.adapters.out.database;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.$PROJECT_SUFIJO.application.exception.DeletionException;
import com.$PROJECT_SUFIJO.application.exception.NotFoundException;
import com.$PROJECT_SUFIJO.domain.models.$ENTITY_NAME;
import com.$PROJECT_SUFIJO.infrastructure.adapters.out.database.mappers.${ENTITY_NAME}Mapper;
import com.$PROJECT_SUFIJO.infrastructure.adapters.out.database.repository.${ENTITY_NAME}Repository;
import com.$PROJECT_SUFIJO.infrastructure.ports.out.${ENTITY_NAME}Port;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class ${ENTITY_NAME}Adapter implements ${ENTITY_NAME}Port {

	@Autowired
	private ${ENTITY_NAME}Repository repository;
	
	@Autowired
	private ${ENTITY_NAME}Mapper mapper;

	@Override
	public $ENTITY_NAME save($ENTITY_NAME model) {
		return this.mapper.toModel(this.repository.saveAndFlush(this.mapper.toEntity(model)));
	}

	@Override
	public $ENTITY_NAME findById(Long id) {
		return this.repository.findById(id)
				.map(this.mapper::toModel)
				.orElseThrow(() -> new NotFoundException(id));
	}

	@Override
	public List<$ENTITY_NAME> findAll() {
		return this.mapper.toModel(this.repository.findAll());
	}

	@Override
	public void deleted(Long id) {
		try {
			this.findById(id);
			this.repository.deleteById(id);
		} catch (Exception e) {
			throw new DeletionException(id);
		}
	}
}
">$ADAPTER_FILE

#Crear mapper
MAPPER_FILE="src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/out/database/mappers/${ENTITY_NAME}Mapper.java"

echo "package com.$PROJECT_SUFIJO.infrastructure.adapters.out.database.mappers;

import java.util.List;

import org.mapstruct.Mapper;

import com.$PROJECT_SUFIJO.domain.models.${ENTITY_NAME};
import com.$PROJECT_SUFIJO.infrastructure.adapters.in.rest.controller.request.${ENTITY_NAME}Request;
import com.$PROJECT_SUFIJO.infrastructure.adapters.in.rest.controller.response.${ENTITY_NAME}Response;
import com.$PROJECT_SUFIJO.infrastructure.adapters.out.database.entities.${ENTITY_NAME}Entity;

@Mapper(componentModel = \"spring\")
public interface ${ENTITY_NAME}Mapper {

	$ENTITY_NAME toModel(${ENTITY_NAME}Entity entity);

	${ENTITY_NAME}Entity toEntity($ENTITY_NAME model);

	$ENTITY_NAME toModel(${ENTITY_NAME}Request request);

	${ENTITY_NAME}Response toResponse($ENTITY_NAME model);

	List<$ENTITY_NAME> toModel(List<${ENTITY_NAME}Entity> entity);
	
	List<${ENTITY_NAME}Response> toResponse(List<$ENTITY_NAME> models);

}
"> $MAPPER_FILE

#Crear use case
USECASE_SAVE_FILE="src/main/java/com/$PROJECT_SUFIJO/application/usecases/${ENTITY_NAME_LOWER}/Save${ENTITY_NAME}UseCaseImpl.java"

echo "package com.$PROJECT_SUFIJO.application.usecases.${ENTITY_NAME_LOWER};

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.$PROJECT_SUFIJO.domain.models.$ENTITY_NAME;
import com.$PROJECT_SUFIJO.infrastructure.ports.in.$ENTITY_NAME_LOWER.Save${ENTITY_NAME}UseCase;
import com.$PROJECT_SUFIJO.infrastructure.ports.out.${ENTITY_NAME}Port;

@Service
public class Save${ENTITY_NAME}UseCaseImpl implements Save${ENTITY_NAME}UseCase{

	@Autowired
	private ${ENTITY_NAME}Port adapter;

	@Override
	public void save($ENTITY_NAME $ENTITY_NAME_LOWER) {

		this.adapter.save($ENTITY_NAME_LOWER);
	}
}
"> $USECASE_SAVE_FILE

USECASE_SAVE_FILE_I="src/main/java/com/$PROJECT_SUFIJO/infrastructure/ports/in/${ENTITY_NAME_LOWER}/Save${ENTITY_NAME}UseCase.java"

echo "package com.$PROJECT_SUFIJO.infrastructure.ports.in.${ENTITY_NAME_LOWER};

import java.util.List;

import com.${PROJECT_SUFIJO}.domain.models.${ENTITY_NAME};

public interface Save${ENTITY_NAME}UseCase {

	void save(${ENTITY_NAME} ${ENTITY_NAME_LOWER});
		
}
	
	"> $USECASE_SAVE_FILE_I

API_FILE="src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/in/rest/configuration/${ENTITY_NAME}Api.java"
echo "package com.$PROJECT_SUFIJO.infrastructure.adapters.in.rest.configuration;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.$PROJECT_SUFIJO.infrastructure.adapters.in.rest.controller.request.${ENTITY_NAME}Request;
import com.$PROJECT_SUFIJO.infrastructure.adapters.in.rest.controller.response.${ENTITY_NAME}Response;

public interface ${ENTITY_NAME}Api {

	@PostMapping
	ResponseEntity<Void> save (@RequestBody ${ENTITY_NAME}Request request);
}
	"> $API_FILE

CONTOLLER_FILE="src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/in/rest/controller/${ENTITY_NAME}Controller.java"

echo "package com.$PROJECT_SUFIJO.infrastructure.adapters.in.rest.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.$PROJECT_SUFIJO.infrastructure.adapters.in.rest.configuration.${ENTITY_NAME}Api;
import com.$PROJECT_SUFIJO.infrastructure.adapters.in.rest.controller.request.${ENTITY_NAME}Request;
import com.$PROJECT_SUFIJO.infrastructure.adapters.in.rest.controller.response.${ENTITY_NAME}Response;
import com.$PROJECT_SUFIJO.infrastructure.adapters.out.database.mappers.${ENTITY_NAME}Mapper;
import com.$PROJECT_SUFIJO.infrastructure.ports.in.$ENTITY_NAME_LOWER.Save${ENTITY_NAME}UseCase;

@RestController
@RequestMapping(\"${request-mapping.controller.${ENTITY_NAME_LOWER}}\")
@Validated
public class ${ENTITY_NAME}Controller implements ${ENTITY_NAME}Api {

	@Autowired
	private Save${ENTITY_NAME}UseCase save${ENTITY_NAME}UseCase;

	@Autowired
	private ${ENTITY_NAME}Mapper mapper;

	@Override
	public ResponseEntity<Void> save(${ENTITY_NAME}Request request) {

		this.save${ENTITY_NAME}UseCase.save(this.mapper.toModel(request));
		return new ResponseEntity<>(HttpStatus.CREATED);
	}
}" >$CONTOLLER_FILE

HANDLER_EXCEPTION_FILE="src/main/java/com/$PROJECT_SUFIJO/application/exception/ApplicationExceptionHandler.java"

echo "package com.${PROJECT_SUFIJO}.application.exception;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class ApplicationExceptionHandler {

	@ExceptionHandler(NotFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNotFoundException(NotFoundException ex) {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put(\"message\", ex.getMessage());

        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }
}"> $HANDLER_EXCEPTION_FILE

NOT_FOUND_EXCEPTION_FILE="src/main/java/com/$PROJECT_SUFIJO/application/exception/NotFoundException.java"

echo "package com.$PROJECT_SUFIJO.application.exception;

public class NotFoundException extends RuntimeException {

	private static final long serialVersionUID = 2475863539121533779L;

	public NotFoundException(Long id) {
        super(\"No existe ninguna tarea con el id : \" + id);
    }
}"> $NOT_FOUND_EXCEPTION_FILE

DELETION_EXCEPTION="src/main/java/com/$PROJECT_SUFIJO/application/exception/DeletionException.java"

echo "package com.$PROJECT_SUFIJO.application.exception;

public class DeletionException extends RuntimeException {

	private static final long serialVersionUID = -4902284848309893321L;

	public DeletionException(Long id) {
        super(\"No se puede eliminar el id: \" + id + \" porque no existe\");
    }
}" > $DELETION_EXCEPTION

echo "Componentes creados: Repository, Adapter, UseCase y Controller para la entidad $ENTITY_NAME."
