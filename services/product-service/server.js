
const express = require('express');
const client = require('prom-client');

const app = express();
const port = process.env.PORT || 3000;
const version = process.env.APP_VERSION || 'blue';
const name = process.env.SERVICE_NAME || 'frontend';

app.use(express.json());
client.collectDefaultMetrics();

const httpRequests = new client.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests received',
  labelNames: ['service', 'method', 'route', 'status_code'],
});

// Count requests after each response completes.
app.use((req, res, next) => {
  res.on('finish', () => {
    httpRequests.inc({
      service: name,
      method: req.method,
      route: req.route?.path || req.path,
      status_code: String(res.statusCode),
    });
  });
  next();
});

app.get('/health', (req, res) =>
  res.json({ status: 'healthy' })
);

app.get('/ready', (req, res) =>
  res.json({ status: 'ready' })
);

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

app.get('/', (req, res) => {
  res.json({ service: name, version, status: 'running' });
});

if (name === 'product-service') {
  app.get('/products', (req, res) => res.json([
    { id: 1, name: 'Laptop', price: 55000 },
    { id: 2, name: 'Keyboard', price: 2500 }
  ]));
}

if (name === 'cart-service') {
  app.post('/cart', (req, res) => res.status(201).json({
    message: 'Item added to cart', item: req.body
  }));
}

if (name === 'order-service') {
  app.post('/orders', (req, res) => res.status(201).json({
    orderId: Date.now(), status: 'created', item: req.body
  }));
  app.get('/orders', (req, res) => res.json([]));
}

app.listen(port, '0.0.0.0', () => {
  console.log(`${name} listening on port ${port}`);
});

