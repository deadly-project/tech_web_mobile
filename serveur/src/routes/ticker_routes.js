import { Router } from "express";
import { createTicket, getTickets, updateStatus } from "../controller/ticket_controller.js";
import { verifyToken } from "../middleware/verification_token.js";

const router = Router();
router.post('/', verifyToken, createTicket);
router.get('/',verifyToken , getTickets);
router.put('/:id/status', verifyToken, updateStatus);
// router.put('/:id/assign', );
// router.post('/:id/comment', );
export default router;