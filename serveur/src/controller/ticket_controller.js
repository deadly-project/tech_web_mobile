import { pool } from '../configuration/connection_db.js';

export const createTicket = async (req, res) => {
    console.log('create ticket')
    console.log(req.user.id);
  try {

    const {
      titre,
      description,
      localisation,
      typeProbleme
    } = req.body;

    const result = await pool.query(

      `
      INSERT INTO tickets
      (
        titre,
        description,
        localisation,
        type_probleme,
        utilisateur_id
      )

      VALUES($1,$2,$3,$4,$5)

      RETURNING *
      `,
      [
        titre,
        description,
        localisation,
        typeProbleme,
        req.user.id
      ]
    );
    req.io.emit("new-ticket", result.rows[0]);
    console.log('requete reçu')

    res.status(201).json(result.rows[0]);

  } catch (err) {

    res.status(500).json({
      message: err.message
    });
  }
};

export const getTickets = async (req, res) => {
  console.log('liste ticket');
  try {

    const result = await pool.query(
      `
      SELECT * FROM tickets
      ORDER BY created_at DESC
      `
    );

    res.json(result.rows);

  } catch (err) {

    res.status(500).json({
      message: err.message
    });
  }
};

export const updateStatus = async (req, res) => {

  try {

    const { statut } = req.body;

    const result = await pool.query(

      `
      UPDATE tickets

      SET statut = $1

      WHERE id = $2

      RETURNING *
      `,
      [
        statut,
        req.params.id
      ]
    );

    req.io.emit("ticket-updated", result.rows[0]);

    res.json(result.rows[0]);

  } catch (err) {

    res.status(500).json({
      message: err.message
    });
  }
};

export const assignTechnician = async (req, res) => {

  try {

    const { technicien_id } = req.body;

    const result = await pool.query(

      `
      UPDATE tickets

      SET
        technicien_id = $1,
        statut = 'EN_COURS'

      WHERE id = $2

      RETURNING *
      `,
      [
        technicien_id,
        req.params.id
      ]
    );

    req.io.emit("ticket-assigned", result.rows[0]);

    res.json(result.rows[0]);

  } catch (err) {

    res.status(500).json({
      message: err.message
    });
  }
};

export const addComment = async (req, res) => {

  try {

    const {
      auteur,
      message
    } = req.body;

    const result = await pool.query(

      `
      INSERT INTO commentaires
      (
        ticket_id,
        auteur,
        message
      )

      VALUES($1,$2,$3)

      RETURNING *
      `,
      [
        req.params.id,
        auteur,
        message
      ]
    );

    req.io.emit("ticket-comment", result.rows[0]);

    res.json(result.rows[0]);

  } catch (err) {

    res.status(500).json({
      message: err.message
    });
  }
};

export const getComments = async (req, res) => {

  try {

    const result = await pool.query(

      `
      SELECT * FROM commentaires

      WHERE ticket_id = $1

      ORDER BY created_at ASC
      `,
      [req.params.id]
    );

    res.json(result.rows);

  } catch (err) {

    res.status(500).json({
      message: err.message
    });
  }
};