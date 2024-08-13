const path = require('path');

module.exports = {
    entry : './html/file.js',
    output : {
        filename:'bundle.js',
        path: path.resolve(__dirname,'html')
    },
    mode: 'development'
}