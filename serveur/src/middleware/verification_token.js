// middleware/auth.js

import jwt from "jsonwebtoken";

export const verifyToken = (
  req,
  res,
  next
) => {

  try {

    const authHeader =
      req.headers.authorization;

    if (!authHeader) {

      return res.status(401).json({
        message: "Token manquant"
      });
    }

    const token =
      authHeader.split(" ")[1];

    const decoded = jwt.verify(
      token,
      process.env.SECRET_KEY
    );

    req.user = decoded;

    next();

  } catch (err) {

    return res.status(401).json({
      message: "Token invalide"
    });
  }
};