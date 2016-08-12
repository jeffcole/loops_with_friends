const elmMake = __dirname + '/node_modules/.bin/elm-make';
const elmSource = __dirname + '/web/static/js/elm';

var Autoprefixer = require('autoprefixer');
var CopyWebpackPlugin = require("copy-webpack-plugin");
var ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  entry: [
      "./web/static/css/app.scss",
      "./web/static/js/app.js",
      "./web/static/js/elm/src/App.elm"
  ],
  output: {
    path: "./priv/static",
    filename: "js/app.js"
  },
  module: {
    loaders: [
      {
        test: /\.elm$/,
        exclude: /(node_modules|elm-stuff)/,
        loader: `elm-webpack?pathToMake=${elmMake}&cwd=${elmSource}`
      },
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
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
    new CopyWebpackPlugin([{ from: "./web/static/assets" }]),
    new ExtractTextPlugin('css/app.css', { allChunks: true })
  ],
  postcss: function () {
    return [Autoprefixer];
  },
  sassLoader: {
    includePaths: [
      __dirname + "/node_modules",
      __dirname + '/web/static/vendor/css'
    ]
  }
};
