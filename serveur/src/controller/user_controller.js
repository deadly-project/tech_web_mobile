import 'dotenv/config'
import { pool } from '../configuration/connection_db.js';
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken"

const SECRET = process.env.SECRET_KEY
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
  console.log("login");
 try{
    const { username, password } = req.body;
    console.log("select");
    const request1 = await pool.query(
      'SELECT * FROM utilisateur WHERE username=$1',
      [username]
    );
    
    if (request1.rows.length === 0) {
      return res.status(404).json({ error: "Utilisateur introuvable" });
      console.log("introuvable");
    }
    const user = request1.rows[0];
    const valid = await bcrypt.compare(password, user.password);
    if (!valid) {
    console.log("fausse mdp");
      return res.status(400).json({ error: "Mot de passe incorrect" });
    }
    console.log("vita");
    const token = jwt.sign(
      { id: user.id_user, role: user.role },
      SECRET,
      { expiresIn: '1d' }
    );
    console.log(token, user.username);
    res.json({ token: token, user: user.id})
  }catch(err){
    console.error(err)
  }
    
}