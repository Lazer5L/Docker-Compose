#!/bin/bash
psql -U postres -f /docker-entrypoint-initdb.d/initdb.sql
