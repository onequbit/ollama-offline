#!make
.PHONY = all clean build run test cheer stop restart

DATE_STR = ''

ifeq ($(OS),Windows_NT)
	export DATE_STR=%DATE%
else
	export DATE_STR=`date`
endif

include .env
export

# default "all" target
all: clean build run test cheer

stop:
	docker compose stop

down: stop
	docker compose down -v
# 	-rm -f open-webui/data/webui.db

clean: down

build:
	echo "..."

run:  
	docker compose up -d --wait
	docker exec -it ollama sh -c 'ollama pull ${STARTING_MODEL}'
# https://huggingface.co/collections/m-a-p/opencodeinterpreter-65d312f6f88da990a64da456

test:
	echo "no tests"

cheer:
	@echo "##### Success: . . . $(DATE_STR) #####"


restart:
	docker compose restart

random-hex:
	@powershell -noprofile -command "[guid]::NewGuid().ToString('N')"

# set-key:
# 	for /f %A in ('powershell -NoProfile -Command "$r=[Security.Cryptography.RandomNumberGenerator]::Create();$b=New-Object byte[] 32;$r.GetBytes($b);[BitConverter]::ToString($b).Replace('-','').ToLower()"') do set "HEX=%A"
# 	echo %HEX


# Draft System Prompt:
# Your answers will only ever be based on knowledge you have learned. 
# You will not make up information about things you don't actually know, 
# and you will indicate the limit of your knowledge in your response. 
# You can hypothesize answers as long as you specifically state that 
# it is a hypothesis and only if such an answer was requested.