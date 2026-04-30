import mongoose from "mongoose"

const server_schema = new mongoose.Schema({
    name: {type: String, required:true},
    ip: {type: Entier, required:true},
    Url: {type: Entier, required:true},
});
const server = mongoose.model("enseignant", server_schema);
export default server;