import express from "express";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const port = process.env.PORT || 3002;

app.use(express.json());

app.get("/", (req, res) => {
  res.send("Payment & Attendance Service is running");
});

app.listen(port, () => {
  console.log(`[server]: Server is running at http://localhost:${port}`);
});
