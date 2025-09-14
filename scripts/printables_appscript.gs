const PROJECT_ID = 'o-nepali';
const COLLECTION = 'printables';
const API_KEY = 'AIzaSyAS3R2yPanym3CbkJ5hsf2nNJkVQXs6SaQ';

function recreatePrintablesInFirestore() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Printables');
  const data = sheet.getDataRange().getValues();

  for (let i = 1; i < data.length; i++) {
    const row = data[i];
    const docId = row[0]; // e.g., pr_animals
    if (!docId) continue;

    // Build lessons array from flattened columns
    let lessonsArray = [];
    
    // Check for lessons in groups of 5 columns starting from column 7 (index 7)
    // Columns: lessons/0/id, lessons/0/title, lessons/0/worksheet/preview_image, lessons/0/worksheet/pdf_url, lessons/0/worksheet/level
    for (let lessonIndex = 0; lessonIndex < 10; lessonIndex++) { // Support up to 10 lessons
      const baseCol = 7 + (lessonIndex * 5); // Starting column for each lesson
      
      const lessonId = row[baseCol];
      const lessonTitle = row[baseCol + 1];
      const previewImage = row[baseCol + 2];
      const pdfUrl = row[baseCol + 3];
      const level = row[baseCol + 4];
      
      // If lesson ID exists, add the lesson
      if (lessonId && lessonId.trim()) {
        lessonsArray.push({
          id: lessonId,
          title: lessonTitle || '',
          worksheet: {
            preview_image: previewImage || '',
            pdf_url: pdfUrl || '',
            level: level || ''
          }
        });
      }
    }

    // Convert lessons to Firestore format
    const lessonsFirestore = lessonsArray.map(lesson => ({
      mapValue: {
        fields: {
          id: { stringValue: lesson.id },
          title: { stringValue: lesson.title },
          worksheet: {
            mapValue: {
              fields: {
                preview_image: { stringValue: lesson.worksheet.preview_image },
                pdf_url: { stringValue: lesson.worksheet.pdf_url },
                level: { stringValue: lesson.worksheet.level }
              }
            }
          }
        }
      }
    }));

    const payload = {
      fields: {
        id: { stringValue: row[0] },
        lesson_id: { stringValue: row[1] },
        chapter_id: { stringValue: row[2] },
        title: { stringValue: row[3] },
        description: { stringValue: row[4] },
        thumbnail: { stringValue: row[5] },
        total_worksheets: { integerValue: parseInt(row[6], 10) || 0 },
        lessons: {
          arrayValue: {
            values: lessonsFirestore
          }
        }
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
        Logger.log(`Error updating row ${i + 1} [${docId}]: ${code} - ${text}`);
      } else {
        Logger.log(`Updated row ${i + 1} [${docId}]: Success`);
      }
    } catch (err) {
      Logger.log(`Exception on row ${i + 1} [${docId}]: ${err.message}`);
    }
  }
}