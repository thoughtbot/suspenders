module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-nesting'),
    require('autoprefixer'),
    require('postcss-url')({
      url: 'copy',
      assetsPath: 'app/assets/static'
    })
  ],
}
