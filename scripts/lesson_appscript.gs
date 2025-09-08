const PROJECT_ID = 'o-nepali';
const COLLECTION = 'courses';
const API_KEY = 'AIzaSyAS3R2yPanym3CbkJ5hsf2nNJkVQXs6SaQ';

function updateCoursesInFirestore() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName('Courses');
  
  if (!sheet) {
    Logger.log('Error: Sheet "Courses" not found');
    return;
  }
  
  const data = sheet.getDataRange().getValues();
  if (data.length < 2) {
    Logger.log('Error: No data found in sheet');
    return;
  }
  
  const headers = data[0];
  Logger.log(`Processing ${data.length - 1} rows with ${headers.length} columns`);

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
    
    // Handle comma-separated values for arrays
    if (typeof value === 'string' && value.includes(',') && 
        (path.includes('/tags/') || path.includes('/image') || path.includes('/audio') || 
         path.includes('/color') || path.includes('/text_color') || path.includes('/correct_answer_ids/'))) {
      curr[lastKey] = value.split(',').map(v => v.trim());
    } else {
      curr[lastKey] = value;
    }
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
      
      // Convert numeric strings to numbers where appropriate
      let processedValue = value;
      if (typeof value === 'string') {
        // Check if it's a number
        if (/^\d+$/.test(value)) {
          processedValue = parseInt(value, 10);
        } else if (/^\d+\.\d+$/.test(value)) {
          processedValue = parseFloat(value);
        } else if (value.toLowerCase() === 'true') {
          processedValue = true;
        } else if (value.toLowerCase() === 'false') {
          processedValue = false;
        }
      }
      
      setNested(coursesMap[courseId], path, processedValue);
    }
  }

  // Convert JS object to Firestore REST API format
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
      return { integerValue: obj.toString() };
    } else if (typeof obj === 'number') {
      return { doubleValue: obj };
    } else if (typeof obj === 'boolean') {
      return { booleanValue: obj };
    } else if (obj === null || obj === undefined) {
      return { nullValue: null };
    } else {
      return { stringValue: String(obj) };
    }
  }

  // Upload each course
  let successCount = 0;
  let errorCount = 0;
  
  for (const courseId in coursesMap) {
    const course = coursesMap[courseId];
    
    // Clean up empty objects and arrays
    cleanupEmptyValues(course);
    
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
        errorCount++;
      } else {
        Logger.log(`Successfully updated course ${courseId}`);
        successCount++;
      }
    } catch (err) {
      Logger.log(`Exception for course ${courseId}: ${err.message}`);
      errorCount++;
    }
  }
  
  Logger.log(`Upload completed: ${successCount} successful, ${errorCount} errors`);
}

// Helper function to clean up empty objects and arrays
function cleanupEmptyValues(obj) {
  if (Array.isArray(obj)) {
    return obj.filter(item => {
      if (typeof item === 'object' && item !== null) {
        cleanupEmptyValues(item);
        return Object.keys(item).length > 0;
      }
      return item !== null && item !== undefined && item !== '';
    });
  } else if (typeof obj === 'object' && obj !== null) {
    Object.keys(obj).forEach(key => {
      const value = obj[key];
      if (value === null || value === undefined || value === '') {
        delete obj[key];
      } else if (typeof value === 'object') {
        cleanupEmptyValues(value);
        if (Array.isArray(value) && value.length === 0) {
          delete obj[key];
        } else if (!Array.isArray(value) && Object.keys(value).length === 0) {
          delete obj[key];
        }
      }
    });
  }
  return obj;
}

// Test function to validate data structure before uploading
function testDataStructure() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName('Courses');
  
  if (!sheet) {
    Logger.log('Error: Sheet "Courses" not found');
    return;
  }
  
  const data = sheet.getDataRange().getValues();
  const headers = data[0];
  const coursesMap = {};

  // Helper functions (same as in main function)
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
    
    if (typeof value === 'string' && value.includes(',') && 
        (path.includes('/tags/') || path.includes('/image') || path.includes('/audio') || 
         path.includes('/color') || path.includes('/text_color') || path.includes('/correct_answer_ids/'))) {
      curr[lastKey] = value.split(',').map(v => v.trim());
    } else {
      curr[lastKey] = value;
    }
  }

  // Process data
  for (let i = 1; i < data.length; i++) {
    const row = data[i];
    const courseId = row[headers.indexOf('courses/id')];
    if (!courseId) continue;

    if (!coursesMap[courseId]) coursesMap[courseId] = {};

    for (let c = 0; c < headers.length; c++) {
      const header = headers[c];
      const value = row[c];
      if (value === '' || value == null) continue;
      
      const path = header.startsWith('courses/') ? header.substring(8) : header;
      
      let processedValue = value;
      if (typeof value === 'string') {
        if (/^\d+$/.test(value)) {
          processedValue = parseInt(value, 10);
        } else if (/^\d+\.\d+$/.test(value)) {
          processedValue = parseFloat(value);
        } else if (value.toLowerCase() === 'true') {
          processedValue = true;
        } else if (value.toLowerCase() === 'false') {
          processedValue = false;
        }
      }
      
      setNested(coursesMap[courseId], path, processedValue);
    }
  }

  // Log summary for each course
  for (const courseId in coursesMap) {
    const course = coursesMap[courseId];
    const chaptersCount = course.chapters ? course.chapters.length : 0;
    let lessonsCount = 0;
    let contentCount = 0;
    
    if (course.chapters) {
      course.chapters.forEach(chapter => {
        if (chapter.lessons) {
          lessonsCount += chapter.lessons.length;
          chapter.lessons.forEach(lesson => {
            if (lesson.lesson_content) {
              contentCount += lesson.lesson_content.length;
            }
          });
        }
      });
    }
    
    Logger.log(`Course: ${courseId} - Chapters: ${chaptersCount}, Lessons: ${lessonsCount}, Content Items: ${contentCount}`);
  }
  
  Logger.log(`Total courses found: ${Object.keys(coursesMap).length}`);
}

// Function to preview just the basic structure without full content
function previewDataStructure() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName('Courses');
  
  if (!sheet) {
    Logger.log('Error: Sheet "Courses" not found');
    return;
  }
  
  const data = sheet.getDataRange().getValues();
  const headers = data[0];
  
  Logger.log(`Headers found: ${headers.length}`);
  Logger.log(`Sample headers: ${headers.slice(0, 10).join(', ')}...`);
  Logger.log(`Data rows: ${data.length - 1}`);
  
  // Show first non-empty course ID
  for (let i = 1; i < data.length && i < 6; i++) {
    const courseId = data[i][headers.indexOf('courses/id')];
    const courseName = data[i][headers.indexOf('courses/name_en')];
    if (courseId) {
      Logger.log(`Sample course: ID=${courseId}, Name=${courseName}`);
      break;
    }
  }
}
