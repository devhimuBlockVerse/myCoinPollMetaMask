const fs = require("fs");
const path = require("path");
const tinify = require("tinify");

tinify.key = "BZsLyhDsVnGNBSBlPj1qMz4rTbCKf7cm";

const INPUT_DIR = "./assets/images";
const OUTPUT_DIR = "./assets/images_optimized";

function compressFile(filePath, outputPath) {
  return tinify.fromFile(filePath).toFile(outputPath);
}

function processDirectory(inputDir, outputDir) {
  fs.mkdirSync(outputDir, { recursive: true });

  fs.readdirSync(inputDir).forEach((file) => {
    const inputFilePath = path.join(inputDir, file);
    const outputFilePath = path.join(outputDir, file);

    if (fs.lstatSync(inputFilePath).isDirectory()) {
      processDirectory(inputFilePath, outputFilePath);
    } else if (file.endsWith(".png") || file.endsWith(".jpg")) {
      console.log(`Compressing: ${file}`);
      compressFile(inputFilePath, outputFilePath)
        .then(() => console.log(`✓ Done: ${file}`))
        .catch((err) => console.error(`✗ Failed: ${file}`, err));
    }
  });
}

processDirectory(INPUT_DIR, OUTPUT_DIR);
