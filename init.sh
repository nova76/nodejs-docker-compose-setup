if [ ! -f ./app/index.js ]; then
   
    docker-compose up -d

    docker exec -it test-docker npm init -y
    docker exec -it test-docker npm install express

    touch ./app/index.js

    # Add the following code to the index.js file
    cat << EOF > ./app/index.js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send('Hello World!');
});

app.listen(3000, () => {
    console.log('Server started on port 3000');
});
EOF

    docker-compose down
    docker-compose up -d

else
  echo "index.js already exists, nothing to do"
fi
