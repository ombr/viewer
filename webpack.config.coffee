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
    rules: [
      {
        test: /\.coffee$/,
        loaders: [ "coffee-loader" ]
      },
      {
        test: /\.sass$/,
        use: ExtractTextPlugin.extract({
          use: ["css-loader", 'sass-loader']
          fallback: 'style-loader'
        })
      },
      {
        test: /\.pug$/,
        use: ['pug-loader']
      }
    ]
  plugins: [
    new webpack.optimize.UglifyJsPlugin({ include: /\.min\.js$/ }),
    new HtmlWebpackPlugin(
      {
        template: './src/index.pug',
        inject: false,
        cache: false,
        chunks: ['index'],
        filename: 'dist/index.html'
      }
    ),
    new ExtractTextPlugin("dist/[name].css"),
  ]
