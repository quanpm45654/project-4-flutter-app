import bodyParser from "body-parser";
import cors from "cors";
import express from "express";
import mysql from "mysql2";

const app = express();
const port = 3000;
const connection = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",
  port: 3306,
  database: "assignment_app",
  multipleStatements: true,
});

app.use(bodyParser.json());
app.use(cors());

connection.getConnection((err) => {
  if (err) {
    console.error("Error connecting to the database: ", err);
    return;
  }
  console.log("Connected to MySQL");
});

// GET ALL STUDENTS FROM CLASS
app.get("/api/students", (req, res) => {
  const query = `SELECT u.user_id, u.full_name, u.email, u.role
                FROM users u
                JOIN class_students cs ON u.user_id = cs.student_id
                WHERE cs.class_id = ?;`;

  connection.query(query, [req.query.class_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// ADD STUDENT TO CLASS
app.post("/api/students", (req, res) => {
  const { email, class_id } = req.body;
  const queryStudent = "SELECT user_id, full_name, email, role FROM users WHERE email = ?";

  connection.query(queryStudent, [email], (err, result) => {
    if (err) {
      res.status(500);
      return;
    }

    const user_id = result[0].user_id;
    const queryAddStudent = "INSERT INTO class_students (class_id, student_id) VALUES (?, ?)";

    connection.query(queryAddStudent, [class_id, user_id], (err, result) => {
      if (err) {
        console.error(err);
        res.status(500);
        return;
      }

      res.status(200).json(result);
    });
  });
});

// REMOVE STUDENT FROM CLASS
app.delete("/api/students", (req, res) => {
  const { class_id, student_id } = req.body;
  const query = "DELETE FROM class_students WHERE class_id = ? AND student_id = ?;";

  connection.query(query, [class_id, student_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// GET ALL CLASSES FOR LECTURER
app.get("/api/classes", (req, res) => {
  const query = "SELECT * FROM classes WHERE lecturer_id = ?;";

  connection.query(query, [req.query.lecturer_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// CREATE NEW CLASS
app.post("/api/classes", (req, res) => {
  const { class_code, class_name, description, semester, lecturer_id } = req.body;
  const query = `INSERT INTO classes(class_code, class_name, description, semester, lecturer_id)
                VALUES( ?, ?, ?, ?, ?);`;

  connection.query(query, [class_code, class_name, description, semester, lecturer_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// EDIT CLASS
app.patch("/api/classes/:class_id", (req, res) => {
  const class_id = parseInt(req.params.class_id);
  const { class_code, class_name, description, semester, lecturer_id } = req.body;
  const query = `UPDATE classes
                SET
                  class_code = ?,
                  class_name = ?,
                  description = ?,
                  semester = ?,
                  lecturer_id = ?
                WHERE class_id = ?;`;

  connection.query(query, [class_code, class_name, description, semester, lecturer_id, class_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// DELETE CLASS
app.delete("/api/classes/:class_id", (req, res) => {
  const class_id = parseInt(req.params.class_id);
  const query = `DELETE FROM classes WHERE class_id = ?;`;

  connection.query(query, [class_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// GET ALL ASSIGNMENTS FOR CLASS
app.get("/api/assignments", (req, res) => {
  const { class_id, lecturer_id } = req.query;
  let query = `SELECT a.*, aa.file_url
              FROM assignments a
              JOIN classes c ON a.class_id = c.class_id
              LEFT JOIN assignment_attachments aa ON a.assignment_id = aa.assignment_id`;
  let queryParams = [];

  if (class_id && lecturer_id) {
    query += ` WHERE a.class_id = ? AND c.lecturer_id = ?;`;
    queryParams = [class_id, lecturer_id];
  } else if (lecturer_id) {
    query += ` WHERE c.lecturer_id = ?;`;
    queryParams = [lecturer_id];
  } else if (class_id) {
    query += ` WHERE a.class_id = ?;`;
    queryParams = [class_id];
  }

  connection.query(query, queryParams, (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// CREATE NEW ASSIGNMENT
app.post("/api/assignments", (req, res) => {
  const { class_id, title, description, due_at, max_score, assignment_type, time_bound, allow_resubmit, file_url } = req.body;
  const query = `START TRANSACTION;

                INSERT INTO assignments(class_id, title, description, due_at, max_score, assignment_type, time_bound, allow_resubmit)
                VALUES(?, ?, ?, ?, ?, ?, ?, ?);

                INSERT INTO assignment_attachments(assignment_id, file_url)
                VALUES(LAST_INSERT_ID(), ?);

                COMMIT;`;

  connection.query(query, [class_id, title, description, due_at, max_score, assignment_type, time_bound, allow_resubmit, file_url], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// EDIT ASSIGNMENT
app.patch("/api/assignments/:assignment_id", (req, res) => {
  const assignment_id = parseInt(req.params.assignment_id);
  const { class_id, title, description, due_at, max_score, assignment_type, time_bound, allow_resubmit, file_url } = req.body;
  const query = `START TRANSACTION;

                UPDATE assignments 
                SET
                  class_id = ?,
                  title = ?,
                  description = ?,
                  due_at = ?,
                  max_score = ?,
                  assignment_type = ?,
                  allow_resubmit = ?,
                  time_bound = ?
                WHERE assignment_id = ?;

                UPDATE assignment_attachments
                SET
                  file_url = ?,
                  uploaded_at = NOW()
                WHERE assignment_id = ?;

                COMMIT;`;

  connection.query(query, [class_id, title, description, due_at, max_score, assignment_type, allow_resubmit, time_bound, assignment_id, file_url, assignment_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// DELETE ASSIGNMENT
app.delete("/api/assignments/:assignment_id", (req, res) => {
  const assignment_id = parseInt(req.params.assignment_id);
  const query = `DELETE FROM assignments WHERE assignment_id = ?;`;

  connection.query(query, [assignment_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// GET ALL SUBMISSIONS FOR ASSIGNMENT
app.get("/api/submissions", (req, res) => {
  const query = `SELECT s.*, u.full_name
                FROM submissions s
                JOIN assignments a ON s.assignment_id = a.assignment_id
                JOIN users u ON s.student_id = u.user_id
                WHERE s.assignment_id = ?;`;

  connection.query(query, [req.query.assignment_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// GRADE AND FEEDBACK STUDENT SUBMISSION
app.patch("/api/submissions/:submission_id", (req, res) => {
  const submission_id = parseInt(req.params.submission_id);
  const { score, graded_by } = req.body;
  const query = `UPDATE submissions
                SET
                    score = ?,
                    graded_by = ?,
                    graded_at = NOW()
                WHERE submission_id = ?;`;

  connection.query(query, [score, graded_by, submission_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

// GET ALL STUDENT ASSIGNMENT NOT SUBMITTED
app.get("/api/assignments-students", (req, res) => {
  const query = `SELECT u.user_id, u.full_name, u.email
                FROM assignments a
                JOIN class_students cs ON a.class_id = cs.class_id
                JOIN users u ON cs.student_id = u.user_id
                LEFT JOIN submissions s ON s.assignment_id = a.assignment_id AND s.student_id = u.user_id
                WHERE a.assignment_id = ? AND s.submission_id IS NULL;`;

  connection.query(query, [req.query.assignment_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
      return;
    }

    res.status(200).json(result);
  });
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
