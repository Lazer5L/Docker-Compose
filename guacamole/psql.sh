#!/bin/bash
psql -h localhost -U postres -f /docker-entrypoint-initdb.d/initdb.sql
