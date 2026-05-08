import { Router } from "express";
import { register } from "../controller/user_controller.js";

const router = Router();

router.get('/', ()=>{console.log("Routes Authentification all")});
router.post('/register', register);

export default router;