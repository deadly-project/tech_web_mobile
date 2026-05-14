// seed/admin_seed.js
import 'dotenv/config'
import bcrypt from "bcryptjs";
import { pool } from "./connection_db.js";
const username_admin = process.env.DEFAULT_ADMIN_USERNAME;
const email_admin = process.env.DEFAULT_ADMIN_EMAIL;
const password_admin = process.env.DEFAULT_ADMIN_PASSWORD;

export const createDefaultAdmin =
async () => {

  try {

    console.log(
      "Verification admin..."
    );

    /*
    |--------------------------------------------------------------------------
    | RECHERCHE ADMIN
    |--------------------------------------------------------------------------
    */

    const existingAdmin =
      await pool.query(

      `
      SELECT * FROM utilisateur

      WHERE role = 'admin'

      LIMIT 1
      `
    );

    /*
    |--------------------------------------------------------------------------
    | ADMIN EXISTE
    |--------------------------------------------------------------------------
    */

    if (
      existingAdmin.rows.length > 0
    ) {

      console.log(
        "Admin deja existant"
      );

      return;
    }

    /*
    |--------------------------------------------------------------------------
    | CREATION ADMIN
    |--------------------------------------------------------------------------
    */

    const passwordHash =
      await bcrypt.hash(
        password_admin,
        10
      );

    const result =
      await pool.query(

      `
      INSERT INTO utilisateur
      (
        username,
        email,
        password,
        role
      )

      VALUES($1,$2,$3,$4)

      RETURNING *
      `,
      [
        username_admin,
        email_admin,
        passwordHash,
        "admin"
      ]
    );

    console.log(
      "Admin cree avec succes"
    );

    console.log(result.rows[0]);

  } catch (err) {

    console.log(err);
  }
};