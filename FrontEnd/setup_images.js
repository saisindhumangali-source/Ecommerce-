const fs = require('fs');
const path = require('path');

const source = 'C:\\Users\\aishw\\.gemini\\antigravity-ide\\brain\\c2074a8b-fc60-4aa7-97a0-10153131d8b3\\ecommerce_placeholder_1783483340531.png';
const targetDir = path.join(__dirname, 'public', 'images');

if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
}

const images = [
    'LgTv.jpg', 'tv1.jpg', 'Lap.jpg', 'htc.jpg', 'mobile8.jpg', 
    'mobile6.jpg', 'mobile4.jpg', 'redmipro.jpg', 'Redmi.webp', 
    'camra.jpg', 'camra2.jpg', 'camra3.jpg', 'Computer.jpg', 
    'watch.jpg', 'watch2.jpg', 'watch3.jpg', 'headPhone.jpg', 
    'headPhone2.jpg', 'headPhone3.jpg'
];

images.forEach(img => {
    fs.copyFileSync(source, path.join(targetDir, img));
});

console.log('Images successfully generated and copied!');
