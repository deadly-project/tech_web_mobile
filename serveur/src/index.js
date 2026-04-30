import express from "express"
import pkg from "cors"
import "dotenv/config"
import { connection } from "./configuration/connection_db.js";
const app = express();
const uri_db = process.env.MONGO_URI;
const port = process.env.PORT;

app.use(express.json());
app.use(pkg)

app.get('/', (req, res) => {
    res.send("API OK");
});

connection(uri_db);
app.listen(port, () => console.log("Server running"));
