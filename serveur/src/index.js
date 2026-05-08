import express from "express"
import pkg from "cors"
import "dotenv/config"
import userRouter from  "./routes/users.js"
import authRouter from  "./routes/authentification.js"
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

app.use('/api/auth', authRouter);
app.use('/user', userRouter);

app.listen(port,() => console.log("Server running"));
