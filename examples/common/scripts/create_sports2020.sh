#!/bin/bash

# set -x

if [ ! -f /psc/wrk/sports2020.db ]
then
  echo "Creating OpenEdge database instance (sports2020)..."
  export DLC=/psc/dlc
  export PATH=$DLC/bin:$PATH
  cd /psc/wrk
  cat > create_dba.sql <<EOT
create user 'dba', 'dba';
grant dba to 'dba';
commit;
EOT
  prodb sports2020 sports2020
  proserve sports2020 -S 20000 -n 30
  sqlexp sports2020 -S 20000 -infile create_dba.sql
fi
