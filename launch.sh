docker run -p7474:7474 -p7687:7687 \
  --name itsu \
  -v $PWD/import:/import \
  -v $PWD/plugins:/plugins \
  -v $PWD/data/data \
  -eNEO4J_apoc_import_file_use__neo4j__config=true \
  -eNEO4J_apoc_import_file_enabled=true \
  -eNEO4J_dbms_security_procedures_unrestricted=apoc.* \
  neo4j:3.5.14
