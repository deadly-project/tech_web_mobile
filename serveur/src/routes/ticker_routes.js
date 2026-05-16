import { Router } from "express";
import { createTicket, deleteTickets, getTickets, updateStatus, updateTicket } from "../controller/ticket_controller.js";
import { verifyToken } from "../middleware/verification_token.js";

const router = Router();
router.post('/', verifyToken, createTicket);
router.get('/',verifyToken , getTickets);
router.put('/:id/status', verifyToken, updateStatus);
router.delete('/:id', verifyToken, deleteTickets);
router.put('/:id', verifyToken, updateTicket);
// router.post('/:id/comment', );
export default router;