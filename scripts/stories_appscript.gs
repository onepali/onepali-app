const PROJECT_ID = 'o-nepali';
const COLLECTION = 'stories'
const API_KEY = 'AIzaSyAS3R2yPanym3CbkJ5hsf2nNJkVQXs6SaQ';

function updateStoriesInFirestore() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName('Stories');
  const data = sheet.getDataRange().getValues();
  const headers = data[0];

  // Helper to set nested value by path
  function setNested(obj, path, value) {
    const keys = path.split('/');
    let curr = obj;
    for (let i = 0; i < keys.length - 1; i++) {
      let key = keys[i];
      if (/^\d+$/.test(key)) key = parseInt(key, 10);
      if (curr[key] == null) {
        curr[key] = /^\d+$/.test(keys[i + 1]) ? [] : {};
      }
      curr = curr[key];
    }
    let lastKey = keys[keys.length - 1];
    if (/^\d+$/.test(lastKey)) lastKey = parseInt(lastKey, 10);
    curr[lastKey] = value;
  }

  // Map storyId to story data (to merge rows for same story if needed)
  const storiesMap = {};

  for (let i = 1; i < data.length; i++) {
    const row = data[i];
    // Use nameEn as the unique ID for each story
    const storyId = row[headers.indexOf('nameEn')];
    if (!storyId) continue;

    if (!storiesMap[storyId]) storiesMap[storyId] = {};

    for (let c = 0; c < headers.length; c++) {
      const header = headers[c];
      let value = row[c];
      if (value === '' || value == null) continue;

      // Update image/character/thumbnail fields if they match old paths
      if (header.endsWith('image') && typeof value === 'string' && value.includes('/stories/content/')) {
        // For story images 1-13
        const match = value.match(/story_(\d+)(?:_\d+)?\.png/);
        if (match) {
          const idx = parseInt(match[1], 10);
          if (idx === 5 || idx === 6) {
            value = 'https://firebasestorage.googleapis.com/v0/b/o-nepali.firebasestorage.app/o/stories%2Fcontent%2Ftortoise_hare%2Fstory_5_6.png?alt=media&token=31285ac7-10b1-4709-91b7-977a7d31a24a';
          } else if (idx >= 1 && idx <= 13) {
            value = `https://firebasestorage.googleapis.com/v0/b/o-nepali.firebasestorage.app/o/stories%2Fcontent%2Ftortoise_hare%2Fstory_${idx}.png?alt=media&token=31285ac7-10b1-4709-91b7-977a7d31a24a`;
          }
        }
      }
      if (header.endsWith('character') && Array.isArray(value)) {
        value = value.map(v => {
          if (typeof v === 'string' && v.includes('tortoise.svg')) {
            return 'https://firebasestorage.googleapis.com/v0/b/o-nepali.firebasestorage.app/o/stories%2Fcontent%2Ftortoise_hare%2Ftortoise.svg?alt=media&token=8538ae1b-6ff6-45a9-a35d-348607c0587e';
          }
          if (typeof v === 'string' && v.includes('rabbit.svg')) {
            return 'https://firebasestorage.googleapis.com/v0/b/o-nepali.firebasestorage.app/o/stories%2Fcontent%2Ftortoise_hare%2Frabbit.svg?alt=media&token=033e9e65-16bc-46f8-bc65-b6fd6a616f9c';
          }
          if (typeof v === 'string' && v.includes('sleep_rabbit.svg')) {
            return 'https://firebasestorage.googleapis.com/v0/b/o-nepali.firebasestorage.app/o/stories%2Fcontent%2Ftortoise_hare%2Fsleep_rabbit.svg?alt=media&token=9d9a1a5f-eed8-4936-99c0-7b95904ca2f2';
          }
          return v;
        });
      }
      if (header === 'thumbnail' && typeof value === 'string' && value.includes('tb_intro_image.svg')) {
        value = 'https://firebasestorage.googleapis.com/v0/b/o-nepali.firebasestorage.app/o/stories%2Fcontent%2Ftortoise_hare%2Ftb_intro_image.svg?alt=media&token=2db977ee-ae5c-4b5b-a33b-9e671f341196';
      }
      setNested(storiesMap[storyId], header, value);
    }
  }

  // Convert JS object to Firestore REST API format (for top-level only)
  function toFirestoreFields(obj) {
    if (Array.isArray(obj)) {
      return {
        arrayValue: {
          values: obj.map(toFirestoreFields)
        }
      };
    } else if (typeof obj === 'object' && obj !== null) {
      return {
        mapValue: {
          fields: Object.fromEntries(
            Object.entries(obj).map(([k, v]) => [k, toFirestoreFields(v)])
          )
        }
      };
    } else if (typeof obj === 'number' && Number.isInteger(obj)) {
      return { integerValue: obj };
    } else if (typeof obj === 'number') {
      return { doubleValue: obj };
    } else if (typeof obj === 'boolean') {
      return { booleanValue: obj };
    } else {
      return { stringValue: String(obj) };
    }
  }

  // Upload each story
  for (const storyId in storiesMap) {
    const story = storiesMap[storyId];
    const payload = {
      fields: Object.fromEntries(
        Object.entries(story).map(([k, v]) => [k, toFirestoreFields(v)])
      )
    };
    const url = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/${COLLECTION}/${encodeURIComponent(storyId)}?key=${API_KEY}`;
    const options = {
      method: 'PATCH',
      contentType: 'application/json',
      payload: JSON.stringify(payload),
      muteHttpExceptions: true
    };
    try {
      const response = UrlFetchApp.fetch(url, options);
      const code = response.getResponseCode();
      const text = response.getContentText();
      if (code !== 200) {
        Logger.log(`Error updating story ${storyId}: ${code} - ${text}`);
      } else {
        Logger.log(`Updated story ${storyId}: ${text}`);
      }
    } catch (err) {
      Logger.log(`Exception for story ${storyId}: ${err.message}`);
    }
  }
}