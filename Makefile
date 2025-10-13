include .env

build:
	docker-compose build

up:
	docker-compose --env-file .env up -d

down:
	docker-compose --env-file .env down

restart:
	make down && make up

to_psql:
	docker exec -ti de_psql psql postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}

create_schemas_psql:
	@echo "Creating data pipeline schemas..."
	docker exec -i de_psql psql postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} -c "CREATE SCHEMA IF NOT EXISTS raw;"
	docker exec -i de_psql psql postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} -c "CREATE SCHEMA IF NOT EXISTS staging;"
	docker exec -i de_psql psql postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} -c "CREATE SCHEMA IF NOT EXISTS marts;"
	@echo "Created schemas: raw, staging, marts"

# import_schemas_psql:
# 	@echo "Copying SCHEMA into container..."
# 	docker cp ./psql_code/psql_schemas.sql de_psql:/tmp/
# 	docker exec -i de_psql psql postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} -f /tmp/psql_schemas.sql
# 	@echo "Import schema finished."

# import_csv_pqsl:
# 	@echo "Copying CSV into container..."
# 	docker cp data/ de_psql:/tmp/
# 	docker cp ./psql_code/psql_load_csv.sql de_psql:/tmp/
# 	docker exec -i de_psql psql postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB} -f /tmp/psql_load_csv.sql
# 	@echo "Import csv finished."

create_db_mysql:
	docker exec -i de_mysql mysql -u"root" -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

to_mysql: create_db_mysql
	docker exec -it de_mysql mysql --local-infile=1 -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" ${MYSQL_DATABASE}

to_mysql_root: create_db_mysql
	docker exec -it de_mysql mysql -u"root" -p"${MYSQL_ROOT_PASSWORD}" ${MYSQL_DATABASE}

import_schemas_mysql: create_db_mysql
	@echo "Copying SCHEMA into container..."
	docker cp mysql_code/mysql_schemas.sql de_mysql:/tmp/
	docker exec -i de_mysql mysql -u"root" -p"${MYSQL_ROOT_PASSWORD}" ${MYSQL_DATABASE} -e 'source /tmp/mysql_schemas.sql'
	@echo "Import schema finished."

import_csv_mysql: create_db_mysql
	@echo "Copying CSV into container..."
	docker cp data/ de_mysql:/tmp/
	docker cp mysql_code/mysql_load_csv.sql de_mysql:/tmp/
	docker exec -i de_mysql mysql -u"root" -p"${MYSQL_ROOT_PASSWORD}" -e "SET GLOBAL local_infile=1;"                                           # local_infile here for server
	docker exec -i de_mysql mysql --local-infile=1 -u"root" -p"${MYSQL_ROOT_PASSWORD}" ${MYSQL_DATABASE} -e 'source /tmp/mysql_load_csv.sql'    # local_infile here for client
	@echo "Import csv finished."

# Dagster setup and start
setup_dagster: # first time only
	@echo "Setting up Dagster environment..."
	@mkdir -p elt_pipeline/.dagster/storage elt_pipeline/.dagster/logs elt_pipeline/.dagster/history elt_pipeline/.dagster/runs elt_pipeline/.dagster/schedules
	@echo "Installing elt_pipeline in editable mode..."
	cd elt_pipeline && pip install -e .
	@echo "Dagster setup completed."

start_dagster:
	@echo "Starting Dagster with isolated DAGSTER_HOME..."
	cd elt_pipeline && DAGSTER_HOME=$$(pwd)/.dagster dagster-webserver -w workspace.yml

dev_dagster: 
	@echo "Starting Dagster DEV mode with isolated DAGSTER_HOME..."
	cd elt_pipeline && DAGSTER_HOME=$$(pwd)/.dagster dagster dev

# Dbt setup and start
run_dbt:
	@echo "Running dbt models..."
	export $$(grep -v '^#' .env | xargs) && \
		cd dbt_cars && \
		dbt run --profiles-dir ./ --project-dir ./

gen_docs_dbt:
	@echo "Generating dbt documentation..."
	export $$(grep -v '^#' .env | xargs) && \
		cd dbt_cars && \
		dbt docs generate --profiles-dir ./ --project-dir ./ && \
		dbt docs serve --profiles-dir ./ --project-dir ./