const {environment} = require('@rails/webpacker');
const webpack = require('webpack');

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    Popper: ['popper.js', 'default']
  })
);

const erb = require('./loaders/erb');
environment.loaders.prepend('erb', erb);

module.exports = environment;

console.log('=== Environment ===');
console.log(JSON.stringify(environment, null, 2));
console.log('===================');
