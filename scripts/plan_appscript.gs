const PROJECT_ID = 'o-nepali';
const COLLECTION = 'plans';
const API_KEY = 'AIzaSyAS3R2yPanym3CbkJ5hsf2nNJkVQXs6SaQ';

function recreatePlansInFirestore() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Plans');
  const data = sheet.getDataRange().getValues();

  for (let i = 1; i < data.length; i++) {
    const row = data[i];
    const docId = row[0]; // e.g., 'annual', 'monthly'
    if (!docId) continue;

    const payload = {
      fields: {
        id: { stringValue: row[0] },
        name: { stringValue: row[1] },
        price: { doubleValue: parseFloat(row[2]) },
        currency: { stringValue: row[3] },
        billing_cycle: { stringValue: row[4] },
        description: { stringValue: row[5] }
      }
    };

    const url = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/${COLLECTION}/${docId}?key=${API_KEY}`;

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
        Logger.log(`Error creating row ${i + 1} [${docId}]: ${code} - ${text}`);
      } else {
        Logger.log(`Created row ${i + 1} [${docId}]: ${text}`);
      }
    } catch (err) {
      Logger.log(`Exception on row ${i + 1} [${docId}]: ${err.message}`);
    }
  }
}
