#!make
.PHONY = all clean build run test cheer stop restart

DATE_STR = ''

ifeq ($(OS),Windows_NT)
	export DATE_STR=%DATE%
else
	export DATE_STR=`date`
endif

# include .env
# export

# default "all" target
all: clean build run test cheer

clean:
	docker compose down

build:
	echo "..."

run: 
	docker compose up -d --wait 

test:
	echo "no tests"

cheer:
	@echo "##### Success: . . . $(DATE_STR) #####"

stop:
	docker compose stop

restart:
	docker compose restart

