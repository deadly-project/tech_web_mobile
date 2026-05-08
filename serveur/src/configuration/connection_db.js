import pkg from 'pg';
import 'dotenv/config'
const { Pool } = pkg;
const user = process.env.POSTGRES_USER;
const password = process.env.POSTGRES_PASSWORD;
const db = process.env.POSTRES_DB;

export const pool = new Pool({
  user: user,
  host: 'localhost',
  database: db,
  password: password,
  port: 5432,
});

























{/**import mongoose from 'mongoose'
export function connection(uri){
    console.log("connection à la base de donnée : "+uri+" ...")
    mongoose.connect(uri);
    const db = mongoose.connection;
    db.on('error', console.error.bind(console, 'Erreur de connexion avec MongoDB:'));
    db.once('open', () => {
      console.log('Connexion à MongoDB réussie');
    });
}**/}