import express from "express"
import pkg from "cors"
import "dotenv/config"
const app = express();
const port = process.env.PORT;

app.use(express.json());
app.use(pkg)

app.get('/', (req, res) => {
    res.send("API OK");
});


app.listen(port, () => console.log("Server running"));
