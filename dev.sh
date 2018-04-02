#!/bin/bash
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\e[0;33m'


# Pq ninguem merece ter que ficar decorando comando
# Instruções:
# 1) "source dev.sh"
# 2) Seja feliz


export PROJ_BASE="$(dirname "${BASH_SOURCE[0]}")"
CD=$(pwd)
PROJECT="quero_votar"

#. ci/funcs.sh

function devhelp {
    echo -e "${RED}TODO - Customizar o dev.sh pra este projeto${RESTORE}"
    # Em progresso
    echo -e ""
    echo -e "${GREEN}devhelp${RESTORE}           Imprime este ${RED}help${RESTORE}"
    echo -e ""
    echo -e "${GREEN}cheguei${RESTORE}           Digite isso se vc eh um ${RED}desenvolvedor novo${RESTORE}"
    echo -e ""
    echo -e "${GREEN}dkbuild${RESTORE}           ${RED}Cria a imagem docker${RESTORE} desse projeto"
    echo -e ""
    echo -e "${GREEN}dkup${RESTORE}              ${RED}Sobe o ambiente${RESTORE} dockerizado completo"
    echo -e ""
    echo -e "${GREEN}dk <bla>${RESTORE}          ${RED}Roda o comando${RESTORE} 'bla' dentro do container docker que tah com o rails"
    echo -e ""
    echo -e "${GREEN}dk docker/createdb.sh${RESTORE}  Cria/Popula o ${RED}banco postgres${RESTORE} inicial pra desenvolvimento"
    echo -e ""
    echo -e "${GREEN}dk rails s${RESTORE}        ${RED}Sobe a aplicação${RESTORE} rails e disponibiliza na porta 3000"
    echo -e ""
    echo -e "${GREEN}dk bash${RESTORE}           ${RED}Abre um bash${RESTORE} dentro do container docker pra brincar"
    echo -e ""
    echo -e "${GREEN}dev <bla>${RESTORE}         ${RED}Executa sem docker${RESTORE} o comando 'bla' setando as variáveis de ambiente de custom.env"
    echo -e ""
    echo -e "${GREEN}dkdown${RESTORE}            ${RED}Para todos os containers${RESTORE} desse projeto"
    echo -e ""
    echo -e ""
}

function cheguei {
    echo -e "${GREEN}OPAAAAA, blz?${RESTORE} Vamo criar esse ambiente aeeee. Faz o seguinte:"
    echo -e ""
    echo -e "1) ${RED}instala o docker${RESTORE} (https://docs.docker.com/engine/installation/)"
    echo -e ""
    echo -e "2) ${RED}builda a imagem${RESTORE} docker desse projeto"
    echo -e "$ ${GREEN}dkbuild${RESTORE}"
    echo -e ""
    echo -e "3) ${RED}Cria a pastinha${RESTORE} pra ele usar os volumes"
    echo -e "$ ${GREEN}sudo mkdir -p /var/data/${PROJECT}${RESTORE}"
    echo -e "$ ${GREEN}sudo chmod o+rwx /var/data/${PROJECT}${RESTORE}  # Mac User? Veja https://github.com/redealumni/quero_bolsa/blob/devdocker/README2.md"
    echo -e ""
    echo -e "4) ${RED}Sobe os containers${RESTORE} da bagaça toda"
    echo -e "$ ${GREEN}dkup${RESTORE}  # deixa esse terminal rodando e já abre outro"
    echo -e ""
    echo -e "5) ${RED}Inicializa${RESTORE} o postgres"
    echo -e "$ ${GREEN}dk docker/createdb.sh${RESTORE} # ele vai pedir uma senha - digita 'queroedu'"
    echo -e ""
    echo -e "6) ${RED}Atualiza as dependências do Gemfile${RESTORE}"
    echo -e "$ ${GREEN}dk gem install bundler${RESTORE}  # Vai fazer isso uma vez na vida"
    echo -e "$ ${GREEN}dk bundle config --global silence_root_warning 1${RESTORE}  # Isso tambem"
    echo -e "$ ${GREEN}dk bundle install${RESTORE}  # Isso aqui toda vida que o Gemfile mudar"
    echo -e "Obs: As gems instaladas ficam cacheadas num volume fora do container (veja o docker-compose.yml)"
    echo -e ""
    echo -e "7) ${RED}Popula${RESTORE} o postgres"
    echo -e "$ ${GREEN}dk rake db:migrate${RESTORE}"
    echo -e "$ ${GREEN}dk rake db:seed${RESTORE}"
    echo -e ""
    echo -e "8) ${RED}Sobe o rails${RESTORE}"
    echo -e "$ ${GREEN}dk rails s -b 0.0.0.0${RESTORE}  # Deixa rodando"
    echo -e ""
    echo -e "9) ${RED}TESTA ae!${RESTORE}"
    echo -e "A aplicacao deve estar online em ${GREEN}http://localhost:3000${RESTORE}"
    echo -e "O mailcatcher em ${GREEN}http://localhost:1080${RESTORE}"
}

function dkbuild {
    CD="$(pwd)"
    cd "$PROJ_BASE"
    docker build -t ${PROJECT} .
    exitcode=$?
    cd "$CD"
    return $exitcode
}

function dkup {
    CD="$(pwd)"
    cd "$PROJ_BASE"
    docker-compose up
    exitcode=$?
    cd "$CD"
    return $exitcode
}
function dkdown {
    CD="$(pwd)"
    cd "$PROJ_BASE"
    docker-compose down
    exitcode=$?
    cd "$CD"
    return $exitcode
}
function dk {
    CD="$(pwd)"
    cd "$PROJ_BASE"
    docker exec -it ${PROJECT} $@
    exitcode=$?
    cd "$CD"
    return $exitcode
}

function dev {
    (if [ -f custom.env ]; then
         source custom.env
     elif [ -f custom.env.example ]; then
         source custom.env.example
     fi
     $@
    )
}

function echo_red {
    echo -e "${RED}$1${RESTORE}";
}

function echo_green {
    echo -e "${GREEN}$1${RESTORE}";
}

function echo_yellow {
    echo -e "${YELLOW}$1${RESTORE}";
}

echo_green "Bem vindo ao ambiente de desenvolvimento do ${PROJECT}"
echo_green "Olha o help aih"
echo_red   "------------------------------------------------------------------------"
devhelp
