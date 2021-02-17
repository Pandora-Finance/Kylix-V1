var mongoose=require('mongoose');
var Schema=mongoose.Schema;

var NftDataSchema=new Schema({
id:{type:Number, required:true, unique: true},
instantSalePrice:{type:Number, required:true},
realWorldValue:{type:Number, required:true},
royalties:{type:Number, required:true},
name: {type:String, required:true},
description: {type:String, required:true},
link: {type:String, required:true}
}, { minimize: false,versionKey: false});

module.exports = mongoose.model('NftData',NftDataSchema);
