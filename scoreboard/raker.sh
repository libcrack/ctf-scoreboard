#!/bin/bash
PADRINO_ENV=production padrino rake db:create
PADRINO_ENV=production padrino rake db:migrate
PADRINO_ENV=production padrino rake seed
