const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Middleware-ka ilaalinta waddooyinka (Protected Routes)
const protect = async (req, res, next) => {
    let token;
    console.log(`Protect Middleware: ${req.method} ${req.url}`);

    if (
        req.headers.authorization &&
        req.headers.authorization.startsWith('Bearer')
    ) {
        try {
            // Ka soo saar token-ka header-ka
            token = req.headers.authorization.split(' ')[1];
            console.log('Token found in headers');

            // Xaqiijinta token-ka
            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            // Helitaanka isticmaalaha token-ka iska leh
            req.user = await User.findById(decoded.id).select('-password');

            next();
        } catch (error) {
            console.error(error);
            res.status(401).json({ message: 'Ma tihid qof la aqoonsan yahay (Not authorized)' });
        }
    }

    if (!token) {
        res.status(401).json({ message: 'Ma jiro token, aqoonsi ma jiro' });
    }
};

// Middleware-ka xaqiijinta Admin-ka
const admin = (req, res, next) => {
    if (req.user && req.user.role === 'admin') {
        next();
    } else {
        res.status(401).json({ message: 'Kaliya Admin-ka ayaa loo ogol yahay halkaan' });
    }
};

module.exports = { protect, admin };
