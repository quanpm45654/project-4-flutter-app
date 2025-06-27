import mysql from "mysql2";
import express from "express";
import bodyParser from "body-parser";
import cors from "cors";

const app = express();
const port = 3000;
const connection = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",
  port: 3306,
  database: "assignment_app",
});

app.use(bodyParser.json());
app.use(cors());

connection.getConnection((err) => {
  if (err) throw err;
  console.log("Connected to MySQL");
});

app.get("/api/users", (req, res) => {
  const query = `SELECT
                  u.user_id,
                  u.full_name,
                  u.email,
                  u.role
                FROM
                  users u
                JOIN class_students cs ON
                  u.user_id = cs.student_id
                WHERE
                  cs.class_id = ?`;

  connection.query(query, [req.query.class_id], (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

app.get("/api/classes", (req, res) => {
  const query = `SELECT
                  *
                FROM
                  classes
                WHERE
                  lecturer_id = ?`;

  connection.query(query, [req.query.lecturer_id], (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

app.get("/api/assignments", (req, res) => {
  let class_id = req.query.class_id;
  let lecturer_id = req.query.lecturer_id;
  let query = `SELECT
                    a.*
                FROM
                    assignments a
                JOIN classes c ON
                    a.class_id = c.class_id`;

  let queryParams = [];

  if (class_id && lecturer_id) {
    query += ` WHERE a.class_id = ? AND c.lecturer_id = ?`;
    queryParams = [class_id, lecturer_id];
  } else if (lecturer_id) {
    query += ` WHERE c.lecturer_id = ?`;
    queryParams = [lecturer_id];
  } else if (class_id) {
    query += ` WHERE a.class_id = ?`;
    queryParams = [class_id];
  }

  connection.query(query, queryParams, (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

app.get("/api/submissions", (req, res) => {
  const query = `SELECT
                  s.*,
                  u.full_name
                FROM
                  submissions s
                JOIN
	                assignments a ON
    	              s.assignment_id = a.assignment_id
                JOIN
	                users u ON
    	              s.student_id = u.user_id
                WHERE
	                s.assignment_id = ?`;

  connection.query(query, [req.query.assignment_id], (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
