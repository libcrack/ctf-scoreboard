#!/bin/bash
padrino rake db:create -e production 
padrino rake db:migrate -e production
padrino rake seed -e production
