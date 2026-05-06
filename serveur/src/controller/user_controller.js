import 'dotenv/config'

// REGISTER
export const register = async (req, res) => {
  try {
    const { nom, email, password } = req.body;

    const password_hash = await bcrypt.hash(password, 10);

    const result = await pool.query(
      'INSERT INTO utilisateur(nom, email, password) VALUES($1,$2,$3) RETURNING *',
      [nom, email, password_hash]
    );

    res.json({ message: "Utilisateur créé", user: result.rows[0] });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};