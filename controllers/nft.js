const fs = require('fs');
const _ = require('lodash');
const {
  contractABI,
  asyncForEach
} = require("../const/const.js");
const path = require('path')
const db = require('../model/nftData.model');
const uploadImage = require('../multer/multer');
const {
  validationResult
} = require("express-validator/check");

const addNft = async (req, res, next) => {
  try {
    await uploadImage(req, res);
    if (!req.file) {
      return res.json({
        errors: [{
          msg: "File is missing"
        }]
      });
    }
    fs.readFile(path.resolve(__dirname, '..') + '/public/file-uploads/' + req.file.filename, 'utf-8', async (err, fileData) => {
      if (err) {
        fs.unlinkSync(path.resolve(__dirname, '..') + '/public/file-uploads/' + req.file.filename);
        return res.json({
          errors: [{
            msg: "Error uploading file"
          }]
        });
      } else {

        let obj = {
          id,
          instantSalePrice,
          realWorldValue,
          royalties,
          name,
          description
        } = req.body;
        obj.link = req.file.filename;
        let result = await db.findOne({
          id: obj.id
        });
        if (result || obj.id == 0) {
          fs.unlinkSync(path.resolve(__dirname, '..') + '/public/file-uploads/' + req.file.filename);
          return res.status(200).json({
            status: false,
            message: 'Id already exists'
          });
        }
        if (
          obj.instantSalePrice == undefined ||
          obj.realWorldValue == undefined ||
          obj.royalties == undefined ||
          obj.name == undefined ||
          obj.description == undefined) {
          fs.unlinkSync(path.resolve(__dirname, '..') + '/public/file-uploads/' + req.file.filename);
          return res.status(200).json({
            status: false,
            message: 'Invalid param'
          });
        }
        await new db(obj).save();
        return res.json({
          status: true,
          message: 'Nft Saved',
        });
      }
    })
  } catch (e) {
    console.log('e caught in catch', e);
    return res.status(200).json({
      status: false,
      message: e.message
    });
  }
};

const getAllNfts = async (req, res, next) => {
  try {
    let nfts = await db.find();
    res.json({
      status: true,
      data: {nfts}
    });
  } catch (e) {
    console.log('e caught in catch', e);
    res.status(200).json({
      status: false,
      message: 'Error in getting data from contract'
    });
  }
};

module.exports = {
  getAllNfts,
  addNft
};
