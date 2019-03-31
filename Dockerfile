FROM ubuntu:trusty
MAINTAINER Luke Murphy <lukewm@riseup.net>

ENV HOME /root
ADD requirements.txt requirements.txt

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update &&\
    apt-get upgrade -yq -o Dpkg::Options::="--force-confold" &&\
    apt-get install -yq --force-yes $(cat requirements.txt)

RUN curl https://raw.githubusercontent.com/ghidinelli/fred-jehle-spanish-verbs/master/jehle_verb_postgresql.sql -o verbs.sql

USER postgres
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER verbos WITH SUPERUSER PASSWORD 'passw0rd';" &&\
    createdb -O verbos verbos &&\
    psql verbos < verbs.sql
USER root

EXPOSE 8081
