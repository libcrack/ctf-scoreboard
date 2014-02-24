#!/bin/bash
padrino -e production rake db:create
padrino -e production rake db:migrate
padrino -e production rake seed
