const fetch = require('node-fetch');

const PROXY_URL = process.env.PROXY_URL || 'http://localhost:3000/chat';

(async () => {
  try {
    const resp = await fetch(PROXY_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: 'hello', sender: 'test_user' }),
    });

    const body = await resp.json();
    console.log('Status:', resp.status);
    console.log('Body:', body);

    if (resp.status === 200 && body && typeof body.reply === 'string') {
      console.log('Test succeeded.');
      process.exit(0);
    }

    console.error('Test failed. Unexpected response.');
    process.exit(2);
  } catch (err) {
    console.error('Test failed with error:', err);
    process.exit(1);
  }
})();
