import express from "express"
import pkg from "cors"
import "dotenv/config"
import http from "http";
import {Server} from "socket.io";

import userRouter from  "./routes/users.js"
import authRouter from  "./routes/authentification.js"
import speedtest from "./routes/test_debit_route.js"
import ticketRouter from "./routes/ticker_routes.js"
import { ensureFile } from "./controller/test_debit_controller.js"
const app = express();
const port = process.env.PORT;
const cors = pkg

app.use(express.json());
app.use(cors())
const server = http.createServer(app);

app.get('/test', (req, res) => {
    console.log("Requête reçue");
      res.json({
        success: true,
        message: "Connexion réussie"
    });
});

const io = new Server(server, {

    cors: {
        origin: "*",
        methods: ["GET", "POST", "PUT", "DELETE"]
    }
});

app.use((req, res, next) => {

    req.io = io;

    next();
});

io.on("connection", (socket) => {

    console.log("Client connecté :", socket.id);

    socket.on("disconnect", () => {

        console.log("Client déconnecté :", socket.id);
    });
});

ensureFile("20mb.bin", 20);
ensureFile("50mb.bin", 50);
ensureFile("100mb.bin", 100);


app.use('/api/auth', authRouter);
app.use('/user', userRouter);
app.use('/speedtest', speedtest);
app.use('/tickets', ticketRouter);

app.listen(port, "0.0.0.0",() => console.log("Server running"));
