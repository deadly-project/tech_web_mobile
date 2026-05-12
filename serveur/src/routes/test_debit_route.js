import { Router } from "express";
import { download, upload } from "../controller/test_debit_controller.js";


const router = Router();

router.get('/', ()=>{console.log("routeur speedtest")});
router.get('/download/:file', download);
router.get('/upload', upload);

export default router;