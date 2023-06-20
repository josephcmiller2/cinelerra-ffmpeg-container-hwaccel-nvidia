#!/bin/bash


echo "Starting container..."
sleep 1
systemctl start default.target
echo "done."

exec bash
