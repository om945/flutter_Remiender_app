import jwt from 'jsonwebtoken';

const auth = async (req, res, next) => {
  try {
    // const token = req.header('x-auth-token'); 
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token)
      return res.status(401).json({ msg: 'No auth token, access denied' });

    const verified = jwt.verify(token, 'passwordKey');
    if (!verified)
      return res
        .status(401)
        .json({ msg: 'Token verification failed, authoeization denied' });
    req.user = verified.id;
    req.token = token;
    next();
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

export default auth;
