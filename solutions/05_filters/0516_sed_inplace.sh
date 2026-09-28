#!/bin/bash
sed -i 's/^debug=false$/debug=true/; s/localhost/127.0.0.1/g; /deprecated/d' app.conf

