import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const FILE_DIR = path.join(__dirname, "..", "files");

// créer dossier si besoin
if (!fs.existsSync(FILE_DIR)) {
  fs.mkdirSync(FILE_DIR);
}

// créer fichier si absent
export function ensureFile(fileName, sizeMB) {
  
  const filePath = path.join(FILE_DIR, fileName);

  if (!fs.existsSync(filePath)) {
    console.log(`Creating ${fileName}`);

    const buffer = Buffer.alloc(1024 * 1024, "0");
    const stream = fs.createWriteStream(filePath);

    for (let i = 0; i < sizeMB; i++) {
      stream.write(buffer);
    }

    stream.end();
  }
}
//============== DOWNLOAD ================
export const download = (req, res) =>{
  console.log("download");
  
    const filePath = path.join(FILE_DIR, req.params.file);

  if (!fs.existsSync(filePath)) {
    return res.status(404).send("File not found");
  }

  const stat = fs.statSync(filePath);

  res.writeHead(200, {
    "Content-Length": stat.size,
    "Content-Type": "application/octet-stream",
  });

  fs.createReadStream(filePath).pipe(res);
}

//============== UPLOAD ================
export const upload = (req, res) =>{
  console.log('upload')
    let size = 0;

  req.on("data", (chunk) => {
    size += chunk.length;
  });

  req.on("end", () => {
    res.json({ receivedBytes: size });
  });
}