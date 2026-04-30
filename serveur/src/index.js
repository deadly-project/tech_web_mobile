import express from "express"
import pkg from "cors"
import "dotenv/config"
const app = express();


app.use(express.json());
app.use(pkg)

app.get('/', (req, res) => {
    res.send("API OK");
});

console.log(process.env.MONGO_URI)
app.listen(3000, () => console.log("Server running"));
