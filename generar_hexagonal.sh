#!/bin/bash

# Verificar si se proporcionaron los parámetros necesarios
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Uso: ./generar_hexagonal.sh <nombre-proyecto> <sufijo-proyecto>"
  exit 1
fi

PROJECT_NAME=$1
PROJECT_SUFIJO=$2

# Crear estructura de carpetas
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/application/exception
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/application/usecases
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/domain/models
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/domain/models/enums
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/in/rest/configuration
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/in/rest/controller
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/in/rest/controller/request
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/in/rest/controller/response
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/out/database
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/out/database/entities
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/out/database/mappers
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/out/database/repository
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/config
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/ports/in
mkdir -p $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/ports/out
mkdir -p $PROJECT_NAME/src/main/resources
mkdir -p $PROJECT_NAME/src/test/java/com/$PROJECT_SUFIJO

# Crear archivos básicos con contenido adecuado
touch $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/application/exception/CustomException.java
touch $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/application/usecases/UseCase.java
touch $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/domain/models/DomainModel.java
touch $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/domain/models/enums/EnumModel.java
touch $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/Adapter.java

# Agregar contenido básico a los archivos creados
echo "package com.$PROJECT_SUFIJO.domain.models;" > $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/domain/models/DomainModel.java
echo "package com.$PROJECT_SUFIJO.application.exception;" > $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/application/exception/CustomException.java
echo "package com.$PROJECT_SUFIJO.application.usecases;" > $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/application/usecases/UseCase.java
echo "package com.$PROJECT_SUFIJO.domain.models.enums;" > $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/domain/models/enums/EnumModel.java
echo "package com.$PROJECT_SUFIJO.infrastructure.adapters;" > $PROJECT_NAME/src/main/java/com/$PROJECT_SUFIJO/infrastructure/adapters/Adapter.java

# Agregar un pom.xml básico
cat <<EOL > $PROJECT_NAME/pom.xml

<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>3.3.2</version>
		<relativePath /> <!-- lookup parent from repository -->
	</parent>
	<groupId>com</groupId>
	<artifactId>$PROJECT_SUFIJO</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>$PROJECT_SUFIJO</name>
	<description>Prueba tecnica para Capgemini</description>
	<url />
	<licenses>
		<license />
	</licenses>
	<developers>
		<developer />
	</developers>
	<scm>
		<connection />
		<developerConnection />
		<tag />
		<url />
	</scm>
	<properties>
		<java.version>17</java.version>
		<org.mapstruct.version>1.5.5.Final</org.mapstruct.version>
		<lombok-mapstruct-binding.version>0.2.0</lombok-mapstruct-binding.version>
		<org.projectlombok.version>1.18.24</org.projectlombok.version>
	</properties>
	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-data-jpa</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-devtools</artifactId>
			<scope>runtime</scope>
			<optional>true</optional>
		</dependency>
		<dependency>
			<groupId>com.oracle.database.jdbc</groupId>
			<artifactId>ojdbc11</artifactId>
			<scope>runtime</scope>
		</dependency>
		<dependency>
			<groupId>org.projectlombok</groupId>
			<artifactId>lombok</artifactId>
			<scope>compile</scope>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>

		<dependency>
			<groupId>org.mapstruct</groupId>
			<artifactId>mapstruct</artifactId>
			<version>1.5.5.Final</version>
		</dependency>

		<!-- https://mvnrepository.com/artifact/javax.validation/validation-api -->
		<dependency>
			<groupId>javax.validation</groupId>
			<artifactId>validation-api</artifactId>
			<version>2.0.1.Final</version>
		</dependency>

		<dependency>
			<groupId>org.postgresql</groupId>
			<artifactId>postgresql</artifactId>
			<version>42.5.0</version>
		</dependency>


	</dependencies>

	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
				<configuration>
					<excludes>
						<exclude>
							<groupId>org.projectlombok</groupId>
							<artifactId>lombok</artifactId>
						</exclude>
					</excludes>
				</configuration>
			</plugin>

			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>3.8.1</version>
				<configuration>
					<source>17</source>
					<target>17</target>
					<annotationProcessorPaths>
						<path>
							<groupId>org.mapstruct</groupId>
							<artifactId>mapstruct-processor</artifactId>
							<version>1.5.5.Final</version>
						</path>
						<path>
							<groupId>org.projectlombok</groupId>
							<artifactId>lombok</artifactId>
							<version>1.18.24</version>
						</path>
						<path>
							<groupId>org.projectlombok</groupId>
							<artifactId>lombok-mapstruct-binding</artifactId>
							<version>0.2.0</version>
						</path>
					</annotationProcessorPaths>
				</configuration>
			</plugin>
		</plugins>
	</build>

</project>
EOL

echo "Estructura generada correctamente para el proyecto $PROJECT_NAME con sufijo $PROJECT_SUFIJO."
