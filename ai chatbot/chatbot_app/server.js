// Minimal Node.js proxy to forward chat messages to Rasa REST webhook
const express = require('express');
const cors = require('cors');
const fetch = require('node-fetch');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const RASA_URL = process.env.RASA_URL || 'http://localhost:5005/webhooks/rest/webhook';

app.post('/chat', async (req, res) => {
  try {
    const { message, sender } = req.body || {};

    if (!message || typeof message !== 'string') {
      return res.status(400).json({ reply: 'No message provided' });
    }

    const payload = {
      sender: sender || 'mobile_user_1',
      message: message,
    };

    const rasaResp = await fetch(RASA_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    });

    // Propagate known non-200 responses with a safe reply
    if (rasaResp.status === 401) {
      return res.status(401).json({ reply: 'Unauthorized to contact NLU server' });
    }
    if (rasaResp.status === 403) {
      return res.status(403).json({ reply: 'Forbidden when contacting NLU server' });
    }
    if (rasaResp.status === 410) {
      return res.status(410).json({ reply: 'NLU endpoint removed' });
    }
    if (rasaResp.status >= 500) {
      return res.status(502).json({ reply: 'NLU server error, try again later' });
    }

    const data = await rasaResp.json();

    // Rasa returns an array of messages: [{ recipient_id, text }, ...]
    let reply = 'Sorry, I did not understand that.';
    if (Array.isArray(data) && data.length > 0) {
      const first = data[0];
      if (first && typeof first.text === 'string' && first.text.trim().length > 0) {
        reply = first.text.trim();
      }
    }

    return res.json({ reply });
  } catch (err) {
    console.error('Error forwarding to Rasa:', err && err.stack ? err.stack : err);
    return res.status(500).json({ reply: 'Server error, please try again.' });
  }
});

app.listen(PORT, () => {
  // eslint-disable-next-line no-console
  console.log(`Chat proxy listening on http://localhost:${PORT} -> Rasa: ${RASA_URL}`);
});
