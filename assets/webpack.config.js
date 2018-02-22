const env = process.env.NODE_ENV;
const path = require("path");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const config = {
  entry: ["./css/app.scss", "./js/app.js"],
  output: {
    path: path.resolve(__dirname, "../priv/static"),
    filename: "js/app.js"
  },
  resolve: {
    extensions: [".ts", ".tsx", ".js", ".jsx"],
    modules: ["deps", "node_modules"]
  },
  module: {
    rules: [{
      test: /\.tsx?$/,
      use: ["babel-loader", "ts-loader"]
    }, {
      test: /\.jsx?$/,
      use: "babel-loader"
    }, {
      test: /\.scss$/,
      use: ExtractTextPlugin.extract({
        use: [{
          loader: "css-loader",
          options: {
            minimize: true,
            sourceMap: env === 'production',
          },
        }, {
          loader: "sass-loader",
          options: {
            includePaths: [path.resolve('node_modules')],
          }
        }],
        fallback: "style-loader"
      })
    }, {
      test: /\.(ttf|otf|eot|svg|woff(2)?)(\?[a-z0-9]+)?$/,
      // put fonts in assets/static/fonts/
      loader: 'file-loader?name=/fonts/[name].[ext]'
    }]
  },
  plugins: [
    new ExtractTextPlugin({
      filename: "css/app.css"
    }),
    new CopyWebpackPlugin([{ from: "./static" }])
  ]
};
module.exports = config;
