var Autoprefixer = require('autoprefixer');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  entry: [
      './web/static/css/app.scss',
      './web/static/js/app.js'
  ],
  output: {
    path: './priv/static',
    filename: 'js/app.js'
  },
  module: {
    loaders: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack'
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          presets: ['es2015']
        }
      },
      {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract('style', ['css', 'postcss', 'sass'])
      }
    ]
  },
  plugins: [
    new CopyWebpackPlugin([{ from: './web/static/assets' }]),
    new ExtractTextPlugin('css/app.css', { allChunks: true })
  ],
  resolve: {
    modulesDirectories: ['node_modules', __dirname + '/web/static/js']
  },
  elm: {
    pathToMake: __dirname + '/node_modules/.bin/elm-make',
    cwd: __dirname + '/web/static/elm'
  },
  postcss: function () {
    return [Autoprefixer];
  },
  sassLoader: {
    includePaths: [
      __dirname + '/node_modules',
      __dirname + '/web/static/vendor/css'
    ]
  }
};
