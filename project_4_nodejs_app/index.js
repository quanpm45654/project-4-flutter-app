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
  if (err) throw err;
  console.log("Connected to MySQL");
});

app.get("/api/students", (req, res) => {
  const query = `SELECT u.user_id, u.full_name, u.email, u.role
                FROM users u
                JOIN class_students cs ON u.user_id = cs.student_id
                WHERE cs.class_id = ?;`;

  connection.query(query, [req.query.class_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
    } else {
      res.status(200).json(result);
    }
  });
});

app.get("/api/classes", (req, res) => {
  const query = `SELECT *
                FROM classes
                WHERE lecturer_id = ?;`;

  connection.query(query, [req.query.lecturer_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
    } else {
      res.status(200).json(result);
    }
  });
});

app.post("/api/classes", (req, res) => {
  const { class_code, class_name, description, semester, lecturer_id } = req.body;
  const query = `INSERT INTO classes(class_code, class_name, description, semester, lecturer_id)
                VALUES( ?, ?, ?, ?, ?);`;

  connection.query(query, [class_code, class_name, description, semester, lecturer_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
    } else {
      const newClass = {
        class_id: result.insertId,
        class_code: class_code,
        class_name: class_name,
        description: description,
        semester: semester,
        lecturer_id: lecturer_id,
      };

      res.status(201).json(newClass);
    }
  });
});

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
    } else {
      const updatedClass = {
        class_id: class_id,
        class_code: class_code,
        class_name: class_name,
        description: description,
        semester: semester,
        lecturer_id: lecturer_id,
      };

      res.status(200).json(updatedClass);
    }
  });
});

app.delete("/api/classes/:class_id", (req, res) => {
  const class_id = parseInt(req.params.class_id);
  const query = `DELETE FROM classes WHERE class_id = ?;`;

  connection.query(query, [class_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
    } else {
      res.status(204).json(result);
    }
  });
});

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
    } else {
      res.status(200).json(result);
    }
  });
});

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
    } else {
      const newAssignment = {
        assignment_id: result[0].insertId,
        class_id: class_id,
        title: title,
        description: description,
        due_at: due_at,
        max_score: max_score,
        assignment_type: assignment_type,
        time_bound: time_bound,
        allow_resubmit: allow_resubmit,
        file_url: file_url,
      };

      res.status(201).json(newAssignment);
    }
  });
});

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
    } else {
      const updatedAssignment = {
        assignment_id: assignment_id,
        class_id: class_id,
        title: title,
        description: description,
        due_at: due_at,
        max_score: max_score,
        assignment_type: assignment_type,
        time_bound: time_bound,
        allow_resubmit: allow_resubmit,
        file_url: file_url,
      };

      res.status(200).json(updatedAssignment);
    }
  });
});

app.delete("/api/assignments/:assignment_id", (req, res) => {
  const assignment_id = parseInt(req.params.assignment_id);
  const query = `DELETE FROM assignments WHERE assignment_id = ?;`;

  connection.query(query, [assignment_id], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500);
    } else {
      res.status(204).json(result);
    }
  });
});

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
    } else {
      res.status(200).json(result);
    }
  });
});

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
    } else {
      res.status(200).json(result);
    }
  });
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
