const express = require('express');
const bodyParser = require('body-parser');
const CONST = require('./const/const');
const fs = require('fs');
const cors = require('cors');
const path = require('path');
var https = require('https');
const mongoose = require('mongoose');
mongoose.set('useCreateIndex', true);
mongoose.Promise = global.Promise;
mongoose.connect(CONST.db);
var app = express();
app.use(cors());
app.use(bodyParser({limit:'50mb'}));
app.use(bodyParser.json({limit:'50mb'}));
app.use(express.static(path.join(__dirname, "public")));
var urlencodedParser = bodyParser.urlencoded({
  extended: false
});
app.use(urlencodedParser);
app.use(express.json());

app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  res.setHeader("Access-Control-Allow-Methods", "GET, POST");

  next();
});

// Routes
app.use("/api", require("./routes/nft"));

app.use((req, res, next) => {
  const error = new Error("Could not find this route.");
  throw error;
});

app.use((error, req, res, next) => {
  if (res.headerSent) {
    return next(error);
  }
  res.status(error.code || 500);
  res.json({ success: false, msg: error || "An unknown error occurred!" });
});

const PORT = "3001";

// https.createServer({
//   key: fs.readFileSync('./ssl/stamp.vulcanforged.com.key'),
//   cert: fs.readFileSync('./ssl/stamp.vulcanforged.com.cert'),
//   ca: fs.readFileSync('./ssl/stamp.vulcanforged.com.ca'),
//   csr: fs.readFileSync('./ssl/stamp.vulcanforged.com.csr'),
// }, app)
// .listen(PORT, async () => {
//   try {
//     console.log(`Server running on port ${PORT}`);
//   } catch (e) {
//     console.log('e=', e);
//   }
// });
app.listen(PORT, async () => {
    try {
      console.log(`Server running on port ${PORT}`);
    } catch (e) {
      console.log('e=',e);
    }
});
