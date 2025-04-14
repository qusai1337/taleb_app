const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = 3000;

let users = [];
let shops = [];

// ✅ تسجيل مستخدم جديد
app.post('/signup', (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  const nameExists = users.find(u => u.name === name);
  if (nameExists) {
    return res.status(400).json({ error: 'Username already taken' });
  }

  if (!email.includes('edu') && !email.includes('student')) {
    return res.status(400).json({ error: 'Email must be a student email (contain "edu" or "student")' });
  }

  const existingUser = users.find(u => u.email === email);
  if (existingUser) {
    return res.status(400).json({ error: 'Email already exists' });
  }

  if (password.length < 8) {
    return res.status(400).json({ error: 'Password must be at least 8 characters long' });
  }

  const newUser = {
    id: users.length + 1,
    name,
    email,
    password
  };

  users.push(newUser);
  res.status(201).json({ message: 'User registered successfully', user: newUser });
});

// ✅ تسجيل الدخول
app.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }

  const user = users.find(u => u.email === email && u.password === password);
  if (!user) {
    return res.status(401).json({ error: 'Invalid email or password' });
  }

  res.json({ message: 'Login successful', user });
});

// ✅ عرض كل المحلات
app.get('/shops', (req, res) => {
  res.json(shops);
});

// ✅ إضافة محل جديد
app.post('/shops', (req, res) => {
  const { name, discount, location, category, logo_url, image_url } = req.body;

  if (!name || !discount || !location || !category) {
    return res.status(400).json({ error: 'Missing required fields: name, discount, location, category' });
  }

  const newShop = {
    id: shops.length + 1,
    name,
    discount,
    location,
    category,
    logo_url: logo_url || '',
    image_url: image_url || ''
  };

  shops.push(newShop);
  res.status(201).json({ message: 'Shop added successfully', shop: newShop });
});

// ✅ تعديل محل
app.put('/shops/:id', (req, res) => {
  const shopId = parseInt(req.params.id);
  const shop = shops.find(shop => shop.id === shopId);

  if (!shop) {
    return res.status(404).json({ error: 'Shop not found' });
  }

  const { name, discount, location, category, logo_url, image_url } = req.body;

  if (!name && !discount && !location && !category && !logo_url && !image_url) {
    return res.status(400).json({ error: 'At least one field is required to update' });
  }

  if (name) shop.name = name;
  if (discount) shop.discount = discount;
  if (location) shop.location = location;
  if (category) shop.category = category;
  if (logo_url) shop.logo_url = logo_url;
  if (image_url) shop.image_url = image_url;

  res.json({ message: 'Shop updated', shop });
});

// ✅ حذف محل
app.delete('/shops/:id', (req, res) => {
  const shopId = parseInt(req.params.id);
  const index = shops.findIndex(shop => shop.id === shopId);

  if (index === -1) {
    return res.status(404).json({ error: 'Shop not found' });
  }

  const removed = shops.splice(index, 1);
  res.json({ message: 'Shop deleted', shop: removed[0] });
});
app.get('/users', (req, res) => {
  res.json(users);
});

app.listen(PORT, () => {
  console.log(`✅ API is running on http://localhost:${PORT}`);
});
