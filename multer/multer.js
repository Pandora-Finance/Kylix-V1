const uuid = require("uuid").v1;
const util = require("util");
const path = require('path')
const multer = require("multer");
const storage = multer.diskStorage({
  destination: "./public/file-uploads",
  filename: function(req, file, cb) {
    const filename = uuid() + path.extname(file.originalname);
    cb(null, filename);
  },
});

const multerObj = {
  storage: storage
};

module.exports = uploadImage = async (req, res) => {
  try {
    let upload = multer(multerObj);
    upload = util.promisify(upload.single("fileData"));
    return upload(req, res);
  } catch (e) {
    console.log('error multer', e)
  }

};
