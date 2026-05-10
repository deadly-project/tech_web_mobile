import { Router } from "express";
import { createTicket, getTickets, updateStatus } from "../controller/ticket_controller.js";

const router = Router();
router.post('/', createTicket);
router.get('/', getTickets);
router.put('/:id/status', updateStatus);
// router.put('/:id/assign', );
// router.post('/:id/comment', );
export default router;