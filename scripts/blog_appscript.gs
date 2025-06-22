const PROJECT_ID = 'o-nepali';
const COLLECTION = 'blog';
const API_KEY = 'AIzaSyAS3R2yPanym3CbkJ5hsf2nNJkVQXs6SaQ';

function toFirestoreTimestamp(val) {
  if (!val) return null;
  if (val instanceof Date) {
    return val.toISOString();
  }
  if (typeof val === 'string') {
    // If already ends with Z or has offset, return as is
    if (/\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:\d{2})$/.test(val)) {
      return val;
    }
    // Try to parse as date
    var d = new Date(val);
    if (!isNaN(d.getTime())) {
      return d.toISOString();
    }
  }
  return null;
}

function recreateBlogsInFirestore() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Blog');
  const data = sheet.getDataRange().getValues();

  for (let i = 1; i < data.length; i++) {
    const row = data[i];
    const docId = row[0]; // id
    if (!docId) continue;

    const createdAt = toFirestoreTimestamp(row[13]);
    const updatedAt = toFirestoreTimestamp(row[14]);
    const publishedAt = toFirestoreTimestamp(row[15]);

    const payload = {
      fields: {
        id: { stringValue: row[0] },
        authorName: { stringValue: row[1] },
        authorAvatar: { stringValue: row[2] },
        title: { stringValue: row[3] },
        slug: { stringValue: row[4] },
        content: { stringValue: row[5] },
        coverImage: { stringValue: row[6] },
        readTimeMinutes: { integerValue: parseInt(row[7], 10) },
        isDraft: { booleanValue: row[8] === true || row[8] === 'TRUE' || row[8] === 'true' },
        isFeatured: { booleanValue: row[9] === true || row[9] === 'TRUE' || row[9] === 'true' },
        viewCount: { integerValue: parseInt(row[10], 10) },
        likesCount: { integerValue: parseInt(row[11], 10) },
        tags: {
          arrayValue: {
            values: (row[12] ? row[12].split(',').map(tag => ({ stringValue: tag.trim() })) : [])
          }
        }
      }
    };
    if (createdAt) payload.fields.createdAt = { timestampValue: createdAt };
    if (updatedAt) payload.fields.updatedAt = { timestampValue: updatedAt };
    if (publishedAt) payload.fields.publishedAt = { timestampValue: publishedAt };

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
