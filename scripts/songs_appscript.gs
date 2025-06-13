const PROJECT_ID = 'o-nepali';
const COLLECTION = 'songs';
const API_KEY = 'AIzaSyAS3R2yPanym3CbkJ5hsf2nNJkVQXs6SaQ';

function recreateSongsInFirestore() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Songs');
  const data = sheet.getDataRange().getValues();

  for (let i = 1; i < data.length; i++) {
    const row = data[i];
    const docId = row[0]; // e.g., song_005
    if (!docId) continue;

    const payload = {
      fields: {
        id: {stringValue: row[0]},
        title_en: { stringValue: row[1] },
        title_ne: { stringValue: row[2] },
        youtube_title_en: { stringValue: row[3] },
        youtube_title_ne: { stringValue: row[4] },
        age_group: { stringValue: row[5] },
        type: { stringValue: row[6] },
        language: {
          arrayValue: {
            values: row[7].split(',').map(lang => ({ stringValue: lang.trim() }))
          }
        },
        media: {
          mapValue: {
            fields: {
              youtube_link: { stringValue: row[8] }
            }
          }
        },
        rank: { integerValue: parseInt(row[9], 10) },
        tags: {
          arrayValue: {
            values: row[10].split(',').map(tag => ({ stringValue: tag.trim() }))
          }
        },
        categoryName: { stringValue: row[11] }
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
