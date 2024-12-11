FROM mongo:7.0.5

COPY ./dumps/mongo/ ./

CMD mongoimport --host db --username ${MONGO_INITDB_ROOT_USERNAME} --password ${MONGO_INITDB_ROOT_PASSWORD} --authenticationDatabase=admin -d ${DATABASE_NAME} -c ${LOGO_COLLECTION} --type json --file ./Logos.json --jsonArray && \
    mongoimport --host db --username ${MONGO_INITDB_ROOT_USERNAME} --password ${MONGO_INITDB_ROOT_PASSWORD} --authenticationDatabase=admin -d ${DATABASE_NAME} -c ${EQUIPMENT_COLLECTION} --type json --file ./EquipmentList.json --jsonArray && \
    mongoimport --host db --username ${MONGO_INITDB_ROOT_USERNAME} --password ${MONGO_INITDB_ROOT_PASSWORD} --authenticationDatabase=admin -d ${DATABASE_NAME} -c ${STAFF_COLLECTION} --type json --file ./Staff.json --jsonArray && \
    mongoimport --host db --username ${MONGO_INITDB_ROOT_USERNAME} --password ${MONGO_INITDB_ROOT_PASSWORD} --authenticationDatabase=admin -d ${DATABASE_NAME} -c ${USER_COLLECTION} --type json --file ./Users.json --jsonArray && \
    mongoimport --host db --username ${MONGO_INITDB_ROOT_USERNAME} --password ${MONGO_INITDB_ROOT_PASSWORD} --authenticationDatabase=admin -d ${DATABASE_NAME} -c ${WARNING_COLLECTION} --type json --file ./Warnings.json --jsonArray && \
    tail -f /dev/null


