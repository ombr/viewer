webpack = require('webpack')
ExtractTextPlugin = require("extract-text-webpack-plugin")
HtmlWebpackPlugin = require('html-webpack-plugin')
module.exports =
  entry:
    "index": "./src/index.coffee",
    "index.min": "./src/index.coffee"
  output:
    path: __dirname,
    filename: "dist/[name].js",
    libraryTarget: "umd",
    library: '[name]'
  module:
    loaders: [
      {
        test: /\.coffee$/,
        loaders: ["babel?presets[]=es2015", "coffee-loader" ]
      },
      {
        test: /\.sass$/,
        loader: ExtractTextPlugin.extract("style-loader", "css!sass")
      },
      {
        test: /\.pug$/,
        loader: "pug"
      }
    ]
  plugins: [
    new webpack.optimize.UglifyJsPlugin({ include: /\.min\.js$/ }),
    new HtmlWebpackPlugin(
      {
        template: './src/index.pug',
        inject: false,
        cache: false,
        chunks: ['index.min'],
        filename: 'dist/index.html'
      }
    ),
    new ExtractTextPlugin("dist/[name].css")
  ]
