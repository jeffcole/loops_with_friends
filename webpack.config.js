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
        test: /\.css$/,
        loader: ExtractTextPlugin.extract('style', ['css', 'postcss'])
      },
      {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract('style', ['css', 'postcss', 'sass'])
      },
      {
        test: /\.(eot|svg|ttf)(\?v=\d+\.\d+\.\d+)?$/,
        loader: "file?name=css/[name].[ext]"
      },
      {
        test: /\.woff(2)?(\?v=\d+\.\d+\.\d+)?$/,
        loader: "url?limit=10000&mimetype=application/font-woff&name=css/[name].[ext]"
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
  fileLoader: {
    publicPath: function (url) {
      return url.split("/")[1];
    }
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
