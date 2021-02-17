const express = require("express");
const uploadImage = require('../multer/multer');
const {
  check
} = require("express-validator/check");
const {
  getAllNfts,
  addNft
} = require("../controllers/nft");
const router = express.Router();
const db = require('../model/nftData.model');

router.post('/addNft',addNft);
router.get('/getAllNfts', getAllNfts);

module.exports = router;
