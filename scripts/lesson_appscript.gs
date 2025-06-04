const PROJECT_ID = 'o-nepali';
const COLLECTION = 'courses';
const API_KEY = 'AIzaSyAS3R2yPanym3CbkJ5hsf2nNJkVQXs6SaQ';

function updateCoursesInFirestore() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName('Courses');
  const data = sheet.getDataRange().getValues();
  const headers = data[0];

  // Helper to set nested value by path
  function setNested(obj, path, value) {
    const keys = path.split('/');
    let curr = obj;
    for (let i = 0; i < keys.length - 1; i++) {
      let key = keys[i];
      // If key is a number, treat as array index
      if (/^\d+$/.test(key)) key = parseInt(key, 10);
      if (curr[key] == null) {
        // Next key is a number? Make array, else object
        curr[key] = /^\d+$/.test(keys[i + 1]) ? [] : {};
      }
      curr = curr[key];
    }
    let lastKey = keys[keys.length - 1];
    if (/^\d+$/.test(lastKey)) lastKey = parseInt(lastKey, 10);
    curr[lastKey] = value;
  }

  // Map courseId to course data (to merge rows for same course)
  const coursesMap = {};

  for (let i = 1; i < data.length; i++) {
    const row = data[i];
    const courseId = row[headers.indexOf('courses/id')];
    if (!courseId) continue;

    if (!coursesMap[courseId]) coursesMap[courseId] = {};

    for (let c = 0; c < headers.length; c++) {
      const header = headers[c];
      const value = row[c];
      if (value === '' || value == null) continue;
      // Remove "courses/" prefix for root
      const path = header.startsWith('courses/') ? header.substring(8) : header;
      setNested(coursesMap[courseId], path, value);
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

  // Upload each course
  for (const courseId in coursesMap) {
    const course = coursesMap[courseId];
    const payload = {
      fields: Object.fromEntries(
        Object.entries(course).map(([k, v]) => [k, toFirestoreFields(v)])
      )
    };
    const url = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/${COLLECTION}/${courseId}?key=${API_KEY}`;
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
        Logger.log(`Error updating course ${courseId}: ${code} - ${text}`);
      } else {
        Logger.log(`Updated course ${courseId}: ${text}`);
      }
    } catch (err) {
      Logger.log(`Exception for course ${courseId}: ${err.message}`);
    }
  }
}