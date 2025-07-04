## App function

### 1. GET ALL CLASSES FOR A TEACHER
// GET /api/teacher/classes?teacher_id=?
// class_list_widget.dart
```
app.get("/api/teacher/classes", (request, response) => {
  const teacher_id = request.query.teacher_id;
  const sql = `SELECT id, class_name, teacher_id, code 
               FROM classes 
               WHERE teacher_id = ?;`;

  connection.query(sql, [teacher_id], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result);
  });
});
```
### 2. CREATE A NEW CLASS
// POST /api/teacher/classes
// class_create_widget.dart
```
app.post("/api/teacher/classes", (request, response) => {
  const { class_name, teacher_id, code } = request.body;
  const sql = `INSERT INTO classes(class_name, teacher_id, code)
               VALUES( ?, ?, ?);`;

  connection.query(sql, [class_name, teacher_id, code], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result.insertId);
  });
});
```
### 3. EDIT A CLASS
// PATCH /api/teacher/classes/:class_id
//class_edit_widget.dart
```
app.patch("/api/teacher/classes/:class_id", (request, response) => {
  const class_id = request.params.class_id;
  const { class_name, teacher_id, code } = request.body;
  const sql = `UPDATE classes
               SET class_name = ?, teacher_id = ?, code = ?
               WHERE id = ?;`;

  connection.query(sql, [class_name, teacher_id, code, class_id], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result);
  });
});
```
### 4. DELETE A CLASS
// DELETE /api/teacher/classes/:class_id
// class_list_widget.dart
```
app.delete("/api/teacher/classes/:class_id", (request, response) => {
  const class_id = request.params.class_id;
  const sql = `DELETE FROM classes 
               WHERE id = ?;`;

  connection.query(sql, [class_id], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result);
  });
});
```
### 5. GET ALL STUDENTS IN A CLASS
// GET /api/teacher/classes/:class_id/students
// student_list_widget.dart
```
app.get("/api/teacher/classes/:class_id/students", (request, response) => {
  const class_id = request.params.class_id;
  const sql = `SELECT s.id, s.full_name, s.email, ce.id AS enrollment_id
               FROM students s
               JOIN class_enrollments ce ON s.id = ce.student_id
               WHERE ce.class_id = ?;`;

  connection.query(sql, [class_id], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result);
  });
});
```
### 6. ADD A STUDENT TO A CLASS
// POST /api/teacher/classes/:class_id/students
// student_add_widget.dart
```
app.post("/api/teacher/classes/:class_id/students", (request, response) => {
  const class_id = request.params.class_id;
  const email = request.body.email;
  const sql1 = `SELECT id FROM students 
                WHERE email = ?;`;

  connection.query(sql1, [email], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    const student_id = result[0].id;
    const sql2 = `INSERT INTO class_enrollments (student_id, class_id) 
                  VALUES (?, ?)`;

    connection.query(sql2, [student_id, class_id], (error, result) => {
      if (error) {
        console.error(error);
        response.status(500).json(error.code);
        return;
      }
      response.status(200).json(result);
    });
  });
});
```
### 7. REMOVE A STUDENT IN A CLASS
// DELETE /api/teacher/classes/:class_id/students/:student_id
// student_list_widget.dart
```
app.delete("/api/teacher/classes/:class_id/students/:student_id", (request, response) => {
  const class_id = request.params.class_id;
  const student_id = request.params.student_id;
  const sql = `DELETE FROM class_enrollments
               WHERE class_id = ? AND student_id = ?;`;

  connection.query(sql, [class_id, student_id], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result);
  });
});
```
### 8. GET ALL ASSIGNMENTS IN A CLASS
// GET /api/teacher/classes/:class_id/assignments
// assignment_list_widget.dart
```
app.get("/api/teacher/classes/:class_id/assignments", (request, response) => {
  const class_id = request.params.class_id;
  const sql = `SELECT a.id ,a.class_id, a.title, a.description, a.attached_file, a.due_date, a.allow_resubmit
               FROM assignments a
               JOIN classes c ON a.class_id = c.id
               WHERE a.class_id = ?;`;

  connection.query(sql, [class_id], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result);
  });
});
```
### 9. CREATE A NEW ASSIGNMENT IN A CLASS
// POST /api/teacher/classes/:class_id/assignments
// assignment_create_widget.dart
```
app.post("/api/teacher/classes/:class_id/assignments", (request, response) => {
  const class_id = request.params.class_id;
  const { title, description, attached_file, due_date, allow_resubmit } = request.body;
  const sql = `INSERT INTO assignments(class_id, title, description, attached_file, due_date, allow_resubmit)
               VALUES(?, ?, ?, ?, ?, ?);`;

  connection.query(sql, [class_id, title, description, attached_file, due_date, allow_resubmit], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result.insertId);
  });
});
```
### 10. EDIT AN ASSIGNMENT IN A CLASS
// PATCH /api/teacher/classes/:class_id/assignments/:assignment_id
// assignment_edit_widget.dart
```
app.patch("/api/teacher/classes/:class_id/assignments/:assignment_id", (request, response) => {
  const class_id = request.params.class_id;
  const assignment_id = request.params.assignment_id;
  const { title, description, attached_file, due_date, allow_resubmit } = request.body;
  const sql = `UPDATE assignments 
               SET
                 class_id = ?,
                 title = ?,
                 description = ?,
                 attached_file = ?,
                 due_date = ?,
                 allow_resubmit = ?
               WHERE id = ?`;

  connection.query(sql, [class_id, title, description, attached_file, due_date, allow_resubmit, assignment_id], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result);
  });
});
```
### 11. DELETE AN ASSIGNMENT
// DELETE /api/teacher/assignments/:assignment_id
// assignment_list_widget.dart
```
app.delete("/api/teacher/assignments/:assignment_id", (request, response) => {
  const assignment_id = request.params.assignment_id;
  const sql = `DELETE FROM assignments 
               WHERE id = ?;`;

  connection.query(sql, [assignment_id], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result);
  });
});
```
### 12. GET ALL SUBMISSION WITH ASSIGNED, SUBMITTED, GRADED STATUS OF AN ASSIGNMENT
// GET /api/teacher/assignments/:assignment_id/submissions
// submission_list_widget.dart
```
app.get("/api/teacher/assignments/:assignment_id/submissions", (request, response) => {
  const assignment_id = request.params.assignment_id;
  const sql = `SELECT
                 sub.id AS submission_id,
                 a.id AS assignment_id,
                 f.id AS feedback_id,
                 s.full_name AS student_name,
                 sub.note,
                 sub.submitted_at,
                 sub.file_path,
                 f.score,
                 f.comment,
                 CASE 
                   WHEN sub.id IS NOT NULL THEN 'Submitted'
                   ELSE 'Assigned'
                 END AS submit_status,
                 CASE 
                   WHEN f.id IS NOT NULL THEN 'Graded'
                   ELSE NULL
                 END AS grade_status
               FROM students s
               JOIN class_enrollments ce ON s.id = ce.student_id
               JOIN assignments a ON ce.class_id = a.class_id
               LEFT JOIN submissions sub ON sub.assignment_id = a.id AND sub.student_id = s.id
               LEFT JOIN feedbacks f ON f.submission_id = sub.id
               WHERE a.id = ?;`;

  connection.query(sql, [assignment_id], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result);
  });
});
```
### 13. FEEDBACK STUDENT SUBMISSION
// PUT /api/teacher/feedbacks
// submission_widget.dart
```
app.put("/api/teacher/feedbacks", (request, response) => {
  const { id, submission_id, score, comment } = request.body;
  const sql = `REPLACE feedbacks(id, submission_id, score, comment) 
               VALUES (?, ?, ?, ?)`;

  connection.query(sql, [id, submission_id, score, comment], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result);
  });
});
```
### 14. View assignment detail
// assignment_widget.dart

### 15. View submission detail
// submission_widget.dart
