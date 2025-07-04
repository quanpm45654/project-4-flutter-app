## App function
```
// GET ALL CLASSES FOR A TEACHER
// GET /api/teacher/classes?teacher_id=?
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

// CREATE A NEW CLASS
// POST /api/teacher/classes
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

// EDIT A CLASS
// PATCH /api/teacher/classes/:class_id
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

// DELETE A CLASS
// DELETE /api/teacher/classes/:class_id
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

// GET ALL STUDENTS IN A CLASS
// GET /api/teacher/classes/:class_id/students
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

// ADD A STUDENT TO A CLASS
// POST /api/teacher/classes/:class_id/students
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

// REMOVE A STUDENT FROM A CLASS
// DELETE /api/teacher/classes/:class_id/students/:student_id
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

// GET ALL ASSIGNMENTS IN A CLASS
// GET /api/teacher/classes/:class_id/assignments
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

// CREATE A NEW ASSIGNMENT
// POST /api/teacher/classes/:class_id/assignments
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
    response.status(200).json(assignment_id);
  });
});

// EDIT AN ASSIGNMENT
// PATCH /api/teacher/classes/:class_id/assignments/:assignment_id
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

// DELETE AN ASSIGNMENT
// DELETE /api/teacher/assignments/:assignment_id
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

// GET ALL STUDENT WITH ASSIGNED, SUBMITTED, GRADED STATUS OF AN ASSIGNMENT
// GET /api/teacher/assignment-students?assignment_id=?
app.get("/api/teacher/assignment-students", (request, response) => {
  const assignment_id = request.query.assignment_id;
  const sql = `SELECT
                 s.full_name AS student_name,
                 sub.id AS submission_id,
                 sub.submitted_at,
                 sub.file_path,
                 f.score,
                 f.comment,
                 CASE 
                   WHEN sub.id IS NOT NULL THEN 'Submitted'
                   ELSE 'Assigned'
                 END AS submission_status,
                 CASE 
                   WHEN f.id IS NOT NULL THEN 'Graded'
                   ELSE NULL
                 END AS grading_status
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

// FEEDBACK STUDENT SUBMISSION
// POST /api/teacher/feedbacks
app.post("/api/teacher/feedbacks", (request, response) => {
  const { submission_id, score, comment, created_at } = request.body;
  const sql = `INSERT INTO feedbacks(submission_id, score, comment, created_at) 
               VALUES (?, ?, ?, ?)`;

  connection.query(sql, [submission_id, score, comment, created_at], (error, result) => {
    if (error) {
      console.error(error);
      response.status(500).json(error.code);
      return;
    }
    response.status(200).json(result);
  });
});
```
