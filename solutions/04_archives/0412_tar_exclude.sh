#!/bin/bash
tar -czf codigo.tgz --exclude=proyecto/tmp proyecto
tar -tzf codigo.tgz | wc -l

