var path = require('path');

module.exports = {
    mode: 'development',
    entry: path.join(__dirname, 'srcjs', 'chakraSlider.jsx'),
    output: {
        path: path.join(__dirname, 'inst', 'www', '${package}', 'chakraSlider'),
        path: path.join(__dirname, 'inst/www/shinyChakraSlider/chakraSlider'),
        filename: 'chakraSlider.js'
    },
    module: {
      rules: [
        {
          test: /\.jsx?$/,
          loader: 'babel-loader',
          options: {
            presets: [
              [
                '@babel/preset-env',
                {
                  targets: {
                    esmodules: true
                  }
                }
              ],
              '@babel/preset-react'
            ]
          }
        }
      ]
    },
    externals: {
        'react': 'window.React',
        'react-dom': 'window.ReactDOM',
        'reactR': 'window.reactR'
    },
    stats: {
        colors: true
    },
    devtool: 'source-map'
};
