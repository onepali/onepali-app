const PROJECT_ID = 'o-nepali';
const COLLECTION = 'reward_collection';
const API_KEY = 'AIzaSyAS3R2yPanym3CbkJ5hsf2nNJkVQXs6SaQ';

function appendRewardsToFirestore() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Reward Collection');
  const data = sheet.getDataRange().getValues();

  for (let i = 1; i < data.length; i++) {
    const row = data[i];
    const docId = String(row[0]); 
    if (!docId) continue;

    const payload = {
      fields: {
        id: { stringValue: docId },
        title_np: { stringValue: row[1] },
        title_en: { stringValue: row[2] },
        description_np: { stringValue: row[3] },
        description_en: { stringValue: row[4] },
        s_audio: { stringValue: row[5] },
        image: { stringValue: row[6] },
        image_outline: { stringValue: row[7] || "" }
      }
    };

    const url = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/${COLLECTION}/${docId}?key=${API_KEY}`;

    const options = {
      method: 'PATCH', // Use PATCH so it creates or replaces as needed
      contentType: 'application/json',
      payload: JSON.stringify(payload),
      muteHttpExceptions: true
    };

    try {
      const response = UrlFetchApp.fetch(url, options);
      const code = response.getResponseCode();
      const text = response.getContentText();
      if (code !== 200) {
        Logger.log(`Error creating row ${i + 1} [${docId}]: ${code} - ${text}`);
      } else {
        Logger.log(`Created row ${i + 1} [${docId}]: ${text}`);
      }
    } catch (err) {
      Logger.log(`Exception on row ${i + 1} [${docId}]: ${err.message}`);
    }
  }
}