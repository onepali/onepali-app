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
      const value = row[c];
      if (value === '' || value == null) continue;
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