import 'dotenv/config'
import { pool } from '../configuration/connection_db.js';
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken"
//import  from "../configuration/connection_db.js"
// REGISTER or CREATE A ACCOUNT
export const register = async (req, res) => {
  try {
    console.log('creation user');
    const { username, email, password } = req.body;
    console.log(username, email, password);
    const request1 = await pool.query(
      'SELECT username FROM utilisateur WHERE username=$1',
      [username]
    );
    console.log(request1.rows[0]);
    if(request1.rows.length > 0){
      console.log('erreur');
      res.status(409).json({error: "Utilisateur existant"});
      return;
    }
    console.log('hashage');
    const password_hash = await bcrypt.hash(password, 10);

    const result = await pool.query(
      'INSERT INTO utilisateur(username, email, password) VALUES($1,$2,$3) RETURNING *',
      [username, email, password_hash]
    );
    console.log('user crée');
    res.json({ message: "Utilisateur créé", user: result.rows[0] });

  } catch (err) {
    console.error(err)
    res.status(500).json({ error: err.message });
  }
};

//LOGIN
export const login = async (req, res) =>{
  const { username, password } = req.body;
  const request1 = await pool.query(
      'SELECT password FROM utilisateur WHERE username=$1',
      [username]
    );
}