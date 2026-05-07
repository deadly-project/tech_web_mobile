import express from "express"
import pkg from "cors"
import "dotenv/config"
const app = express();
const port = process.env.PORT;
const cors = pkg

app.use(express.json());
app.use(cors())

app.get('/test', (req, res) => {
    console.log("Requête reçue");
      res.json({
        success: true,
        message: "Connexion réussie"
    });
});


app.listen(port,() => console.log("Server running"));
