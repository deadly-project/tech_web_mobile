import { Router } from "express";
import { login, register } from "../controller/user_controller.js";

const router = Router();

router.get('/', ()=>{console.log("Routes Authentification all")});
router.post('/register', register);
router.post('/login', login);

export default router;